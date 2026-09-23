package com.bookhub.dao;

import com.bookhub.model.Prestamo;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

/**
 * Capa DAO para gestión de préstamos, devoluciones y solicitudes.
 */
public class PrestamoDAO {

    public boolean solicitarPrestamo(int idUsuario, int idLibro, int diasPrestamo) {
        String sqlVerificar = "SELECT stock_disponible FROM libros WHERE id_libro = ?";
        String sqlInsertar = "INSERT INTO prestamos (id_usuario, id_libro, fecha_solicitud, fecha_limite, estado, observaciones) " +
                             "VALUES (?, ?, ?, ?, 'SOLICITADO', 'Solicitud realizada desde la plataforma web')";
        String sqlActualizarStock = "UPDATE libros SET stock_disponible = stock_disponible - 1 WHERE id_libro = ? AND stock_disponible > 0";

        try (Connection con = ConexionBD.getConnection()) {
            con.setAutoCommit(false);
            try {
                // 1. Validar stock
                try (PreparedStatement psVerificar = con.prepareStatement(sqlVerificar)) {
                    psVerificar.setInt(1, idLibro);
                    try (ResultSet rs = psVerificar.executeQuery()) {
                        if (!rs.next() || rs.getInt("stock_disponible") <= 0) {
                            con.rollback();
                            return false;
                        }
                    }
                }

                // 2. Insertar solicitud
                LocalDate hoy = LocalDate.now();
                LocalDate limite = hoy.plusDays(diasPrestamo > 0 ? diasPrestamo : 7);

                try (PreparedStatement psInsertar = con.prepareStatement(sqlInsertar)) {
                    psInsertar.setInt(1, idUsuario);
                    psInsertar.setInt(2, idLibro);
                    psInsertar.setDate(3, Date.valueOf(hoy));
                    psInsertar.setDate(4, Date.valueOf(limite));
                    psInsertar.executeUpdate();
                }

                // 3. Descontar 1 del stock disponible
                try (PreparedStatement psStock = con.prepareStatement(sqlActualizarStock)) {
                    psStock.setInt(1, idLibro);
                    psStock.executeUpdate();
                }

                con.commit();
                return true;
            } catch (SQLException ex) {
                con.rollback();
                ex.printStackTrace();
            } finally {
                con.setAutoCommit(true);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Prestamo> listarTodos() {
        List<Prestamo> lista = new ArrayList<>();
        String sql = "SELECT p.*, u.nombre_completo AS usuario_nombre, u.codigo_universitario, l.titulo AS libro_titulo, l.isbn AS libro_isbn " +
                     "FROM prestamos p " +
                     "INNER JOIN usuarios u ON p.id_usuario = u.id_usuario " +
                     "INNER JOIN libros l ON p.id_libro = l.id_libro " +
                     "ORDER BY p.id_prestamo DESC";
        try (Connection con = ConexionBD.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                lista.add(mapearPrestamo(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }

    public List<Prestamo> listarPorUsuario(int idUsuario) {
        List<Prestamo> lista = new ArrayList<>();
        String sql = "SELECT p.*, u.nombre_completo AS usuario_nombre, u.codigo_universitario, l.titulo AS libro_titulo, l.isbn AS libro_isbn " +
                     "FROM prestamos p " +
                     "INNER JOIN usuarios u ON p.id_usuario = u.id_usuario " +
                     "INNER JOIN libros l ON p.id_libro = l.id_libro " +
                     "WHERE p.id_usuario = ? " +
                     "ORDER BY p.id_prestamo DESC";
        try (Connection con = ConexionBD.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idUsuario);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    lista.add(mapearPrestamo(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }

    public boolean aprobarPrestamo(int idPrestamo) {
        String sql = "UPDATE prestamos SET estado = 'EN_PRESTAMO', fecha_prestamo = ? WHERE id_prestamo = ?";
        try (Connection con = ConexionBD.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setDate(1, Date.valueOf(LocalDate.now()));
            ps.setInt(2, idPrestamo);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean registrarDevolucion(int idPrestamo, int idLibro) {
        String sqlBuscar = "SELECT fecha_limite FROM prestamos WHERE id_prestamo = ?";
        String sqlActualizarPrestamo = "UPDATE prestamos SET fecha_devolucion = ?, estado = ? WHERE id_prestamo = ?";
        String sqlIncrementarStock = "UPDATE libros SET stock_disponible = stock_disponible + 1 WHERE id_libro = ?";

        try (Connection con = ConexionBD.getConnection()) {
            con.setAutoCommit(false);
            try {
                LocalDate hoy = LocalDate.now();
                String estadoFinal = "DEVUELTO";

                try (PreparedStatement psBuscar = con.prepareStatement(sqlBuscar)) {
                    psBuscar.setInt(1, idPrestamo);
                    try (ResultSet rs = psBuscar.executeQuery()) {
                        if (rs.next()) {
                            Date fechaLimite = rs.getDate("fecha_limite");
                            if (fechaLimite != null && hoy.isAfter(fechaLimite.toLocalDate())) {
                                estadoFinal = "DEVUELTO_CON_RETRASO";
                            }
                        }
                    }
                }

                try (PreparedStatement psAct = con.prepareStatement(sqlActualizarPrestamo)) {
                    psAct.setDate(1, Date.valueOf(hoy));
                    psAct.setString(2, estadoFinal);
                    psAct.setInt(3, idPrestamo);
                    psAct.executeUpdate();
                }

                try (PreparedStatement psStock = con.prepareStatement(sqlIncrementarStock)) {
                    psStock.setInt(1, idLibro);
                    psStock.executeUpdate();
                }

                con.commit();
                return true;
            } catch (SQLException ex) {
                con.rollback();
                ex.printStackTrace();
            } finally {
                con.setAutoCommit(true);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public int contarPrestamosActivos() {
        String sql = "SELECT COUNT(*) FROM prestamos WHERE estado IN ('SOLICITADO', 'EN_PRESTAMO')";
        try (Connection con = ConexionBD.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    private Prestamo mapearPrestamo(ResultSet rs) throws SQLException {
        Prestamo p = new Prestamo();
        p.setIdPrestamo(rs.getInt("id_prestamo"));
        p.setIdUsuario(rs.getInt("id_usuario"));
        p.setIdLibro(rs.getInt("id_libro"));
        p.setFechaSolicitud(rs.getDate("fecha_solicitud"));
        p.setFechaPrestamo(rs.getDate("fecha_prestamo"));
        p.setFechaLimite(rs.getDate("fecha_limite"));
        p.setFechaDevolucion(rs.getDate("fecha_devolucion"));
        p.setEstado(rs.getString("estado"));
        p.setObservaciones(rs.getString("observaciones"));
        p.setUsuarioNombre(rs.getString("usuario_nombre"));
        p.setUsuarioCodigo(rs.getString("codigo_universitario"));
        p.setLibroTitulo(rs.getString("libro_titulo"));
        p.setLibroIsbn(rs.getString("libro_isbn"));
        return p;
    }
}
