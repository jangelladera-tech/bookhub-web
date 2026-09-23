package com.bookhub.controller;

import com.bookhub.dao.UsuarioDAO;
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
 * Servlet para administración de usuarios y sanciones en el panel de control.
 */
@WebServlet(name = "AdminUsuarioServlet", urlPatterns = {"/admin/usuarios"})
public class AdminUsuarioServlet extends HttpServlet {

    private UsuarioDAO usuarioDAO;

    @Override
    public void init() {
        usuarioDAO = new UsuarioDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!validarAdmin(request, response)) return;

        List<Usuario> usuarios = usuarioDAO.listarTodos();
        request.setAttribute("usuarios", usuarios);
        request.getRequestDispatcher("/WEB-INF/views/admin/usuarios-crud.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!validarAdmin(request, response)) return;

        String action = request.getParameter("action");
        String idUsuarioStr = request.getParameter("idUsuario");
        String nuevoEstado = request.getParameter("estado");

        if (idUsuarioStr != null && nuevoEstado != null) {
            try {
                int idUsuario = Integer.parseInt(idUsuarioStr.trim());
                boolean ok = usuarioDAO.actualizarEstado(idUsuario, nuevoEstado.trim());
                response.sendRedirect(request.getContextPath() + "/admin/usuarios?msg=" + (ok ? "actualizado_ok" : "error"));
                return;
            } catch (NumberFormatException ignored) {}
        }

        response.sendRedirect(request.getContextPath() + "/admin/usuarios");
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
