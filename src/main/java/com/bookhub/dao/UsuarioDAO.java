package com.bookhub.dao;

import com.bookhub.model.Usuario;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 * Capa DAO para operaciones de Usuarios (Autenticación, Registro y Gestión Admin).
 */
public class UsuarioDAO {

    public Usuario autenticar(String correo, String password) {
        String sql = "SELECT * FROM usuarios WHERE correo = ? AND password = ? AND estado != 'INACTIVO'";
        try (Connection con = ConexionBD.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, correo);
            ps.setString(2, password);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapearUsuario(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean registrar(Usuario u) {
        String sql = "INSERT INTO usuarios (nombre_completo, codigo_universitario, correo, password, rol, estado) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection con = ConexionBD.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, u.getNombreCompleto());
            ps.setString(2, u.getCodigoUniversitario());
            ps.setString(3, u.getCorreo());
            ps.setString(4, u.getPassword());
            ps.setString(5, u.getRol() != null ? u.getRol() : "ESTUDIANTE");
            ps.setString(6, u.getEstado() != null ? u.getEstado() : "ACTIVO");
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Usuario> listarTodos() {
        List<Usuario> lista = new ArrayList<>();
        String sql = "SELECT * FROM usuarios ORDER BY id_usuario DESC";
        try (Connection con = ConexionBD.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                lista.add(mapearUsuario(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }

    public Usuario obtenerPorId(int idUsuario) {
        String sql = "SELECT * FROM usuarios WHERE id_usuario = ?";
        try (Connection con = ConexionBD.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idUsuario);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapearUsuario(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean actualizarEstado(int idUsuario, String nuevoEstado) {
        String sql = "UPDATE usuarios SET estado = ? WHERE id_usuario = ?";
        try (Connection con = ConexionBD.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, nuevoEstado);
            ps.setInt(2, idUsuario);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public int contarUsuariosActivos() {
        String sql = "SELECT COUNT(*) FROM usuarios WHERE estado = 'ACTIVO'";
        try (Connection con = ConexionBD.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    private Usuario mapearUsuario(ResultSet rs) throws SQLException {
        Usuario u = new Usuario();
        u.setIdUsuario(rs.getInt("id_usuario"));
        u.setNombreCompleto(rs.getString("nombre_completo"));
        u.setCodigoUniversitario(rs.getString("codigo_universitario"));
        u.setCorreo(rs.getString("correo"));
        u.setPassword(rs.getString("password"));
        u.setRol(rs.getString("rol"));
        u.setEstado(rs.getString("estado"));
        u.setFechaRegistro(rs.getTimestamp("fecha_registro"));
        return u;
    }
}
