package com.bookhub.model;

import java.io.Serializable;
import java.sql.Timestamp;

/**
 * JavaBean que representa a un Usuario del sistema BookHub (Estudiante, Docente o Administrador).
 */
public class Usuario implements Serializable {
    private static final long serialVersionUID = 1L;

    private int idUsuario;
    private String nombreCompleto;
    private String codigoUniversitario;
    private String correo;
    private String password;
    private String rol; // 'ADMIN', 'ESTUDIANTE', 'DOCENTE'
    private String estado; // 'ACTIVO', 'SANCIONADO', 'INACTIVO'
    private Timestamp fechaRegistro;

    public Usuario() {
    }

    public Usuario(int idUsuario, String nombreCompleto, String codigoUniversitario, String correo, String password, String rol, String estado) {
        this.idUsuario = idUsuario;
        this.nombreCompleto = nombreCompleto;
        this.codigoUniversitario = codigoUniversitario;
        this.correo = correo;
        this.password = password;
        this.rol = rol;
        this.estado = estado;
    }

    public int getIdUsuario() {
        return idUsuario;
    }

    public void setIdUsuario(int idUsuario) {
        this.idUsuario = idUsuario;
    }

    public String getNombreCompleto() {
        return nombreCompleto;
    }

    public void setNombreCompleto(String nombreCompleto) {
        this.nombreCompleto = nombreCompleto;
    }

    public String getCodigoUniversitario() {
        return codigoUniversitario;
    }

    public void setCodigoUniversitario(String codigoUniversitario) {
        this.codigoUniversitario = codigoUniversitario;
    }

    public String getCorreo() {
        return correo;
    }

    public void setCorreo(String correo) {
        this.correo = correo;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getRol() {
        return rol;
    }

    public void setRol(String rol) {
        this.rol = rol;
    }

    public String getEstado() {
        return estado;
    }

    public void setEstado(String estado) {
        this.estado = estado;
    }

    public Timestamp getFechaRegistro() {
        return fechaRegistro;
    }

    public void setFechaRegistro(Timestamp fechaRegistro) {
        this.fechaRegistro = fechaRegistro;
    }

    public boolean esAdmin() {
        return "ADMIN".equalsIgnoreCase(this.rol);
    }
}
