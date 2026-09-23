package com.bookhub.model;

import java.io.Serializable;

/**
 * JavaBean que representa la categoría o área de conocimiento de un libro.
 */
public class Categoria implements Serializable {
    private static final long serialVersionUID = 1L;

    private int idCategoria;
    private String nombre;
    private String descripcion;

    public Categoria() {
    }

    public Categoria(int idCategoria, String nombre, String descripcion) {
        this.idCategoria = idCategoria;
        this.nombre = nombre;
        this.descripcion = descripcion;
    }

    public int getIdCategoria() {
        return idCategoria;
    }

    public void setIdCategoria(int idCategoria) {
        this.idCategoria = idCategoria;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public String getDescripcion() {
        return descripcion;
    }

    public void setDescripcion(String descripcion) {
        this.descripcion = descripcion;
    }
}
