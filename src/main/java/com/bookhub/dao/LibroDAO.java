package com.bookhub.dao;

import com.bookhub.model.Libro;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 * Capa DAO para operaciones de Libros (CRUD completo, filtros y control de stock).
 */
public class LibroDAO {

    public List<Libro> listarTodos() {
        List<Libro> lista = new ArrayList<>();
        String sql = "SELECT l.*, c.nombre AS categoria_nombre FROM libros l " +
                     "INNER JOIN categorias c ON l.id_categoria = c.id_categoria " +
                     "ORDER BY l.id_libro DESC";
        try (Connection con = ConexionBD.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                lista.add(mapearLibro(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }

    public List<Libro> buscarPorFiltros(String query, int idCategoria) {
        List<Libro> lista = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT l.*, c.nombre AS categoria_nombre FROM libros l " +
            "INNER JOIN categorias c ON l.id_categoria = c.id_categoria WHERE 1=1 "
        );

        if (query != null && !query.trim().isEmpty()) {
            sql.append(" AND (l.titulo LIKE ? OR l.autor LIKE ? OR l.isbn LIKE ?)");
        }
        if (idCategoria > 0) {
            sql.append(" AND l.id_categoria = ?");
        }
        sql.append(" ORDER BY l.id_libro DESC");

        try (Connection con = ConexionBD.getConnection();
             PreparedStatement ps = con.prepareStatement(sql.toString())) {
            int paramIndex = 1;
            if (query != null && !query.trim().isEmpty()) {
                String searchPattern = "%" + query.trim() + "%";
                ps.setString(paramIndex++, searchPattern);
                ps.setString(paramIndex++, searchPattern);
                ps.setString(paramIndex++, searchPattern);
            }
            if (idCategoria > 0) {
                ps.setInt(paramIndex++, idCategoria);
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    lista.add(mapearLibro(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }

    public List<Libro> listarRecursosDigitales() {
        List<Libro> lista = new ArrayList<>();
        String sql = "SELECT l.*, c.nombre AS categoria_nombre FROM libros l " +
                     "INNER JOIN categorias c ON l.id_categoria = c.id_categoria " +
                     "WHERE l.pdf_url IS NOT NULL AND l.pdf_url != '' ORDER BY l.titulo ASC";
        try (Connection con = ConexionBD.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                lista.add(mapearLibro(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }

    public Libro obtenerPorId(int idLibro) {
        String sql = "SELECT l.*, c.nombre AS categoria_nombre FROM libros l " +
                     "INNER JOIN categorias c ON l.id_categoria = c.id_categoria WHERE l.id_libro = ?";
        try (Connection con = ConexionBD.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idLibro);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapearLibro(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean insertar(Libro l) {
        String sql = "INSERT INTO libros (id_categoria, titulo, autor, editorial, anio_publicacion, isbn, stock_total, stock_disponible, ubicacion_fisica, portada_url, pdf_url, estado) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection con = ConexionBD.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, l.getIdCategoria());
            ps.setString(2, l.getTitulo());
            ps.setString(3, l.getAutor());
            ps.setString(4, l.getEditorial());
            ps.setInt(5, l.getAnioPublicacion());
            ps.setString(6, l.getIsbn());
            ps.setInt(7, l.getStockTotal());
            ps.setInt(8, l.getStockDisponible());
            ps.setString(9, l.getUbicacionFisica());
            ps.setString(10, l.getPortadaUrl());
            ps.setString(11, l.getPdfUrl());
            ps.setString(12, l.getEstado() != null ? l.getEstado() : "DISPONIBLE");
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean actualizar(Libro l) {
        String sql = "UPDATE libros SET id_categoria = ?, titulo = ?, autor = ?, editorial = ?, anio_publicacion = ?, isbn = ?, stock_total = ?, stock_disponible = ?, ubicacion_fisica = ?, portada_url = ?, pdf_url = ?, estado = ? " +
                     "WHERE id_libro = ?";
        try (Connection con = ConexionBD.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, l.getIdCategoria());
            ps.setString(2, l.getTitulo());
            ps.setString(3, l.getAutor());
            ps.setString(4, l.getEditorial());
            ps.setInt(5, l.getAnioPublicacion());
            ps.setString(6, l.getIsbn());
            ps.setInt(7, l.getStockTotal());
            ps.setInt(8, l.getStockDisponible());
            ps.setString(9, l.getUbicacionFisica());
            ps.setString(10, l.getPortadaUrl());
            ps.setString(11, l.getPdfUrl());
            ps.setString(12, l.getEstado());
            ps.setInt(13, l.getIdLibro());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean eliminar(int idLibro) {
        String sql = "DELETE FROM libros WHERE id_libro = ?";
        try (Connection con = ConexionBD.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idLibro);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public int contarTotalLibros() {
        String sql = "SELECT COUNT(*) FROM libros";
        try (Connection con = ConexionBD.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    private Libro mapearLibro(ResultSet rs) throws SQLException {
        Libro l = new Libro();
        l.setIdLibro(rs.getInt("id_libro"));
        l.setIdCategoria(rs.getInt("id_categoria"));
        l.setCategoriaNombre(rs.getString("categoria_nombre"));
        l.setTitulo(rs.getString("titulo"));
        l.setAutor(rs.getString("autor"));
        l.setEditorial(rs.getString("editorial"));
        l.setAnioPublicacion(rs.getInt("anio_publicacion"));
        l.setIsbn(rs.getString("isbn"));
        l.setStockTotal(rs.getInt("stock_total"));
        l.setStockDisponible(rs.getInt("stock_disponible"));
        l.setUbicacionFisica(rs.getString("ubicacion_fisica"));
        l.setPortadaUrl(rs.getString("portada_url"));
        l.setPdfUrl(rs.getString("pdf_url"));
        l.setEstado(rs.getString("estado"));
        return l;
    }
}
