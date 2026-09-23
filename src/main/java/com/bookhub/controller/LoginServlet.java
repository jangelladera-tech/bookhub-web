package com.bookhub.controller;

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
 * Servlet para autenticación y registro de usuarios.
 */
@WebServlet(name = "LoginServlet", urlPatterns = {"/login", "/registro"})
public class LoginServlet extends HttpServlet {

    private UsuarioDAO usuarioDAO;

    @Override
    public void init() {
        usuarioDAO = new UsuarioDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();
        
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("usuarioLogueado") != null) {
            Usuario u = (Usuario) session.getAttribute("usuarioLogueado");
            if (u.esAdmin()) {
                response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            } else {
                response.sendRedirect(request.getContextPath() + "/catalogo");
            }
            return;
        }

        if ("/registro".equals(path)) {
            request.getRequestDispatcher("/WEB-INF/views/auth/registro.jsp").forward(request, response);
        } else {
            request.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        if ("registrar".equals(action)) {
            procesarRegistro(request, response);
        } else {
            procesarLogin(request, response);
        }
    }

    private void procesarLogin(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String correo = request.getParameter("correo");
        String password = request.getParameter("password");

        if (correo == null || password == null || correo.trim().isEmpty() || password.trim().isEmpty()) {
            request.setAttribute("error", "Por favor ingrese su correo institucional y contraseña.");
            request.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(request, response);
            return;
        }

        Usuario usuario = usuarioDAO.autenticar(correo.trim(), password.trim());

        if (usuario != null) {
            if ("SANCIONADO".equalsIgnoreCase(usuario.getEstado())) {
                request.setAttribute("error", "Su cuenta tiene sanciones activas. Comuníquese con la biblioteca.");
                request.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(request, response);
                return;
            }

            HttpSession session = request.getSession(true);
            session.setAttribute("usuarioLogueado", usuario);

            if (usuario.esAdmin()) {
                response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            } else {
                response.sendRedirect(request.getContextPath() + "/catalogo");
            }
        } else {
            request.setAttribute("error", "Credenciales incorrectas o usuario no encontrado.");
            request.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(request, response);
        }
    }

    private void procesarRegistro(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String nombre = request.getParameter("nombreCompleto");
        String codigo = request.getParameter("codigoUniversitario");
        String correo = request.getParameter("correo");
        String password = request.getParameter("password");
        String rol = request.getParameter("rol");

        if (nombre == null || codigo == null || correo == null || password == null ||
            nombre.trim().isEmpty() || codigo.trim().isEmpty() || correo.trim().isEmpty() || password.trim().isEmpty()) {
            request.setAttribute("error", "Todos los campos son obligatorios.");
            request.getRequestDispatcher("/WEB-INF/views/auth/registro.jsp").forward(request, response);
            return;
        }

        Usuario nuevoUsuario = new Usuario();
        nuevoUsuario.setNombreCompleto(nombre.trim());
        nuevoUsuario.setCodigoUniversitario(codigo.trim());
        nuevoUsuario.setCorreo(correo.trim());
        nuevoUsuario.setPassword(password.trim());
        nuevoUsuario.setRol(rol != null && !rol.trim().isEmpty() ? rol : "ESTUDIANTE");
        nuevoUsuario.setEstado("ACTIVO");

        boolean exito = usuarioDAO.registrar(nuevoUsuario);

        if (exito) {
            request.setAttribute("mensajeExito", "¡Cuenta creada exitosamente! Inicie sesión con sus credenciales.");
            request.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(request, response);
        } else {
            request.setAttribute("error", "Error al registrar el usuario. Es posible que el correo o código ya existan.");
            request.getRequestDispatcher("/WEB-INF/views/auth/registro.jsp").forward(request, response);
        }
    }
}
