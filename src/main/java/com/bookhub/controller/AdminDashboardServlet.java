package com.bookhub.controller;

import com.bookhub.dao.LibroDAO;
import com.bookhub.dao.PrestamoDAO;
import com.bookhub.dao.UsuarioDAO;
import com.bookhub.model.Usuario;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * Servlet para el Dashboard del panel administrativo.
 */
@WebServlet(name = "AdminDashboardServlet", urlPatterns = {"/admin/dashboard"})
public class AdminDashboardServlet extends HttpServlet {

    private LibroDAO libroDAO;
    private PrestamoDAO prestamoDAO;
    private UsuarioDAO usuarioDAO;

    @Override
    public void init() {
        libroDAO = new LibroDAO();
        prestamoDAO = new PrestamoDAO();
        usuarioDAO = new UsuarioDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        Usuario usuario = (session != null) ? (Usuario) session.getAttribute("usuarioLogueado") : null;

        if (usuario == null || !usuario.esAdmin()) {
            response.sendRedirect(request.getContextPath() + "/login?error=acceso_denegado");
            return;
        }

        int totalLibros = libroDAO.contarTotalLibros();
        int prestamosActivos = prestamoDAO.contarPrestamosActivos();
        int usuariosActivos = usuarioDAO.contarUsuariosActivos();

        request.setAttribute("totalLibros", totalLibros);
        request.setAttribute("prestamosActivos", prestamosActivos);
        request.setAttribute("usuariosActivos", usuariosActivos);
        request.setAttribute("ultimosPrestamos", prestamoDAO.listarTodos());

        request.getRequestDispatcher("/WEB-INF/views/admin/dashboard.jsp").forward(request, response);
    }
}
