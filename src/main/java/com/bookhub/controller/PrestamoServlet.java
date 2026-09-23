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
 * Servlet para solicitud y consulta de préstamos por parte de usuarios (Estudiantes / Docentes).
 */
@WebServlet(name = "PrestamoServlet", urlPatterns = {"/mis-prestamos", "/solicitar-prestamo"})
public class PrestamoServlet extends HttpServlet {

    private PrestamoDAO prestamoDAO;

    @Override
    public void init() {
        prestamoDAO = new PrestamoDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        Usuario usuario = (session != null) ? (Usuario) session.getAttribute("usuarioLogueado") : null;

        if (usuario == null) {
            response.sendRedirect(request.getContextPath() + "/login?msg=requiere_autenticacion");
            return;
        }

        List<Prestamo> misPrestamos = prestamoDAO.listarPorUsuario(usuario.getIdUsuario());
        request.setAttribute("misPrestamos", misPrestamos);
        request.getRequestDispatcher("/WEB-INF/views/user/mis-prestamos.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        Usuario usuario = (session != null) ? (Usuario) session.getAttribute("usuarioLogueado") : null;

        if (usuario == null) {
            response.sendRedirect(request.getContextPath() + "/login?msg=requiere_autenticacion");
            return;
        }

        String idLibroParam = request.getParameter("idLibro");
        String diasParam = request.getParameter("dias");

        if (idLibroParam == null || idLibroParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/catalogo?error=libro_invalido");
            return;
        }

        try {
            int idLibro = Integer.parseInt(idLibroParam.trim());
            int dias = 7;
            if (diasParam != null && !diasParam.trim().isEmpty()) {
                dias = Integer.parseInt(diasParam.trim());
            }

            boolean exito = prestamoDAO.solicitarPrestamo(usuario.getIdUsuario(), idLibro, dias);

            if (exito) {
                response.sendRedirect(request.getContextPath() + "/mis-prestamos?msg=solicitud_exitosa");
            } else {
                response.sendRedirect(request.getContextPath() + "/libro-detalle?id=" + idLibro + "&error=sin_stock");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/catalogo?error=datos_invalidos");
        }
    }
}
