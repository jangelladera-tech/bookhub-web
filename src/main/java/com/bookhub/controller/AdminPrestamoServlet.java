package com.bookhub.controller;

import com.bookhub.dao.PrestamoDAO;
import com.bookhub.model.Prestamo;
import com.bookhub.model.Usuario;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * Servlet para administración y seguimiento de préstamos y devoluciones.
 */
@WebServlet(name = "AdminPrestamoServlet", urlPatterns = {"/admin/prestamos"})
public class AdminPrestamoServlet extends HttpServlet {

    private PrestamoDAO prestamoDAO;

    @Override
    public void init() {
        prestamoDAO = new PrestamoDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!validarAdmin(request, response)) return;

        List<Prestamo> prestamos = prestamoDAO.listarTodos();
        request.setAttribute("prestamos", prestamos);
        request.getRequestDispatcher("/WEB-INF/views/admin/prestamos-gestion.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!validarAdmin(request, response)) return;

        String action = request.getParameter("action");
        String idPrestamoStr = request.getParameter("idPrestamo");

        if (idPrestamoStr == null || idPrestamoStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/prestamos?error=datos_faltantes");
            return;
        }

        try {
            int idPrestamo = Integer.parseInt(idPrestamoStr.trim());

            if ("aprobar".equals(action)) {
                boolean ok = prestamoDAO.aprobarPrestamo(idPrestamo);
                response.sendRedirect(request.getContextPath() + "/admin/prestamos?msg=" + (ok ? "aprobado_ok" : "error"));
            } else if ("devolver".equals(action)) {
                int idLibro = Integer.parseInt(request.getParameter("idLibro"));
                boolean ok = prestamoDAO.registrarDevolucion(idPrestamo, idLibro);
                response.sendRedirect(request.getContextPath() + "/admin/prestamos?msg=" + (ok ? "devolucion_ok" : "error"));
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/prestamos");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/prestamos?error=id_invalido");
        }
    }

    private boolean validarAdmin(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        Usuario usuario = (session != null) ? (Usuario) session.getAttribute("usuarioLogueado") : null;
        if (usuario == null || !usuario.esAdmin()) {
            response.sendRedirect(request.getContextPath() + "/login?error=acceso_denegado");
            return false;
        }
        return true;
    }
}
