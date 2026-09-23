package com.bookhub.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * Clase utilitaria para gestionar la conexión JDBC con la base de datos MySQL.
 */
public class ConexionBD {

    private static final String URL = "jdbc:mysql://localhost:3306/bookhub_db?useSSL=false&serverTimezone=America/Lima&allowPublicKeyRetrieval=true";
    private static final String USER = "root";
    private static final String PASS = ""; // Modificar según contraseña local de MySQL / XAMPP / WampServer

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            System.err.println("Error al cargar Driver MySQL JDBC: " + e.getMessage());
        }
    }

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASS);
    }
}
