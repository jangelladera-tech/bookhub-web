package com.bookhub.model;

import java.io.Serializable;
import java.sql.Date;

/**
 * JavaBean que representa una solicitud o registro de Préstamo de libro.
 */
public class Prestamo implements Serializable {
    private static final long serialVersionUID = 1L;

    private int idPrestamo;
    private int idUsuario;
    private int idLibro;
    private Date fechaSolicitud;
    private Date fechaPrestamo;
    private Date fechaLimite;
    private Date fechaDevolucion;
    private String estado; // 'SOLICITADO', 'EN_PRESTAMO', 'DEVUELTO', 'DEVUELTO_CON_RETRASO', 'CANCELADO'
    private String observaciones;

    // Atributos de conveniencia para visualización en tablas
    private String usuarioNombre;
    private String usuarioCodigo;
    private String libroTitulo;
    private String libroIsbn;

    public Prestamo() {
    }

    public Prestamo(int idPrestamo, int idUsuario, int idLibro, Date fechaSolicitud, Date fechaPrestamo, Date fechaLimite, Date fechaDevolucion, String estado, String observaciones) {
        this.idPrestamo = idPrestamo;
        this.idUsuario = idUsuario;
        this.idLibro = idLibro;
        this.fechaSolicitud = fechaSolicitud;
        this.fechaPrestamo = fechaPrestamo;
        this.fechaLimite = fechaLimite;
        this.fechaDevolucion = fechaDevolucion;
        this.estado = estado;
        this.observaciones = observaciones;
    }

    public int getIdPrestamo() {
        return idPrestamo;
    }

    public void setIdPrestamo(int idPrestamo) {
        this.idPrestamo = idPrestamo;
    }

    public int getIdUsuario() {
        return idUsuario;
    }

    public void setIdUsuario(int idUsuario) {
        this.idUsuario = idUsuario;
    }

    public int getIdLibro() {
        return idLibro;
    }

    public void setIdLibro(int idLibro) {
        this.idLibro = idLibro;
    }

    public Date getFechaSolicitud() {
        return fechaSolicitud;
    }

    public void setFechaSolicitud(Date fechaSolicitud) {
        this.fechaSolicitud = fechaSolicitud;
    }

    public Date getFechaPrestamo() {
        return fechaPrestamo;
    }

    public void setFechaPrestamo(Date fechaPrestamo) {
        this.fechaPrestamo = fechaPrestamo;
    }

    public Date getFechaLimite() {
        return fechaLimite;
    }

    public void setFechaLimite(Date fechaLimite) {
        this.fechaLimite = fechaLimite;
    }

    public Date getFechaDevolucion() {
        return fechaDevolucion;
    }

    public void setFechaDevolucion(Date fechaDevolucion) {
        this.fechaDevolucion = fechaDevolucion;
    }

    public String getEstado() {
        return estado;
    }

    public void setEstado(String estado) {
        this.estado = estado;
    }

    public String getObservaciones() {
        return observaciones;
    }

    public void setObservaciones(String observaciones) {
        this.observaciones = observaciones;
    }

    public String getUsuarioNombre() {
        return usuarioNombre;
    }

    public void setUsuarioNombre(String usuarioNombre) {
        this.usuarioNombre = usuarioNombre;
    }

    public String getUsuarioCodigo() {
        return usuarioCodigo;
    }

    public void setUsuarioCodigo(String usuarioCodigo) {
        this.usuarioCodigo = usuarioCodigo;
    }

    public String getLibroTitulo() {
        return libroTitulo;
    }

    public void setLibroTitulo(String libroTitulo) {
        this.libroTitulo = libroTitulo;
    }

    public String getLibroIsbn() {
        return libroIsbn;
    }

    public void setLibroIsbn(String libroIsbn) {
        this.libroIsbn = libroIsbn;
    }
}
