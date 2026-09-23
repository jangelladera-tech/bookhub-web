package com.bookhub.model;

import java.io.Serializable;

/**
 * JavaBean que representa un Libro o Recurso Bibliográfico en BookHub.
 */
public class Libro implements Serializable {
    private static final long serialVersionUID = 1L;

    private int idLibro;
    private int idCategoria;
    private String categoriaNombre;
    private String titulo;
    private String autor;
    private String editorial;
    private int anioPublicacion;
    private String isbn;
    private int stockTotal;
    private int stockDisponible;
    private String ubicacionFisica;
    private String portadaUrl;
    private String pdfUrl;
    private String estado; // 'DISPONIBLE', 'NO_DISPONIBLE'

    public Libro() {
    }

    public Libro(int idLibro, int idCategoria, String titulo, String autor, String editorial, int anioPublicacion, String isbn, int stockTotal, int stockDisponible, String ubicacionFisica, String portadaUrl, String pdfUrl, String estado) {
        this.idLibro = idLibro;
        this.idCategoria = idCategoria;
        this.titulo = titulo;
        this.autor = autor;
        this.editorial = editorial;
        this.anioPublicacion = anioPublicacion;
        this.isbn = isbn;
        this.stockTotal = stockTotal;
        this.stockDisponible = stockDisponible;
        this.ubicacionFisica = ubicacionFisica;
        this.portadaUrl = portadaUrl;
        this.pdfUrl = pdfUrl;
        this.estado = estado;
    }

    public int getIdLibro() {
        return idLibro;
    }

    public void setIdLibro(int idLibro) {
        this.idLibro = idLibro;
    }

    public int getIdCategoria() {
        return idCategoria;
    }

    public void setIdCategoria(int idCategoria) {
        this.idCategoria = idCategoria;
    }

    public String getCategoriaNombre() {
        return categoriaNombre;
    }

    public void setCategoriaNombre(String categoriaNombre) {
        this.categoriaNombre = categoriaNombre;
    }

    public String getTitulo() {
        return titulo;
    }

    public void setTitulo(String titulo) {
        this.titulo = titulo;
    }

    public String getAutor() {
        return autor;
    }

    public void setAutor(String autor) {
        this.autor = autor;
    }

    public String getEditorial() {
        return editorial;
    }

    public void setEditorial(String editorial) {
        this.editorial = editorial;
    }

    public int getAnioPublicacion() {
        return anioPublicacion;
    }

    public void setAnioPublicacion(int anioPublicacion) {
        this.anioPublicacion = anioPublicacion;
    }

    public String getIsbn() {
        return isbn;
    }

    public void setIsbn(String isbn) {
        this.isbn = isbn;
    }

    public int getStockTotal() {
        return stockTotal;
    }

    public void setStockTotal(int stockTotal) {
        this.stockTotal = stockTotal;
    }

    public int getStockDisponible() {
        return stockDisponible;
    }

    public void setStockDisponible(int stockDisponible) {
        this.stockDisponible = stockDisponible;
    }

    public String getUbicacionFisica() {
        return ubicacionFisica;
    }

    public void setUbicacionFisica(String ubicacionFisica) {
        this.ubicacionFisica = ubicacionFisica;
    }

    public String getPortadaUrl() {
        return portadaUrl;
    }

    public void setPortadaUrl(String portadaUrl) {
        this.portadaUrl = portadaUrl;
    }

    public String getPdfUrl() {
        return pdfUrl;
    }

    public void setPdfUrl(String pdfUrl) {
        this.pdfUrl = pdfUrl;
    }

    public String getEstado() {
        return estado;
    }

    public void setEstado(String estado) {
        this.estado = estado;
    }

    public boolean tieneRecursoDigital() {
        return this.pdfUrl != null && !this.pdfUrl.trim().isEmpty();
    }
}
