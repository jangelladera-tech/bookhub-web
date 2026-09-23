package com.bookhub.controller;

import com.bookhub.dao.CategoriaDAO;
import com.bookhub.dao.LibroDAO;
import com.bookhub.model.Categoria;
import com.bookhub.model.Libro;
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
 * Servlet para el CRUD de Libros en el panel de administración.
 */
@WebServlet(name = "AdminLibroServlet", urlPatterns = {"/admin/libros"})
public class AdminLibroServlet extends HttpServlet {

    private LibroDAO libroDAO;
    private CategoriaDAO categoriaDAO;

    @Override
    public void init() {
        libroDAO = new LibroDAO();
        categoriaDAO = new CategoriaDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!validarAdmin(request, response)) return;

        List<Libro> libros = libroDAO.listarTodos();
        List<Categoria> categorias = categoriaDAO.listarTodas();

        request.setAttribute("libros", libros);
        request.setAttribute("categorias", categorias);
        request.getRequestDispatcher("/WEB-INF/views/admin/libros-crud.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!validarAdmin(request, response)) return;

        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        try {
            if ("crear".equals(action)) {
                Libro l = extraerLibroDeFormulario(request, 0);
                boolean ok = libroDAO.insertar(l);
                response.sendRedirect(request.getContextPath() + "/admin/libros?msg=" + (ok ? "creado_ok" : "error"));
            } else if ("actualizar".equals(action)) {
                int idLibro = Integer.parseInt(request.getParameter("idLibro"));
                Libro l = extraerLibroDeFormulario(request, idLibro);
                boolean ok = libroDAO.actualizar(l);
                response.sendRedirect(request.getContextPath() + "/admin/libros?msg=" + (ok ? "actualizado_ok" : "error"));
            } else if ("eliminar".equals(action)) {
                int idLibro = Integer.parseInt(request.getParameter("idLibro"));
                boolean ok = libroDAO.eliminar(idLibro);
                response.sendRedirect(request.getContextPath() + "/admin/libros?msg=" + (ok ? "eliminado_ok" : "error"));
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/libros");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/libros?error=operacion_fallida");
        }
    }

    private Libro extraerLibroDeFormulario(HttpServletRequest request, int idLibro) {
        Libro l = new Libro();
        l.setIdLibro(idLibro);
        l.setIdCategoria(Integer.parseInt(request.getParameter("idCategoria")));
        l.setTitulo(request.getParameter("titulo"));
        l.setAutor(request.getParameter("autor"));
        l.setEditorial(request.getParameter("editorial"));
        
        String anioStr = request.getParameter("anioPublicacion");
        l.setAnioPublicacion(anioStr != null && !anioStr.trim().isEmpty() ? Integer.parseInt(anioStr.trim()) : 2024);
        
        l.setIsbn(request.getParameter("isbn"));
        
        int stockTotal = Integer.parseInt(request.getParameter("stockTotal"));
        l.setStockTotal(stockTotal);
        
        String stockDispStr = request.getParameter("stockDisponible");
        if (stockDispStr != null && !stockDispStr.trim().isEmpty()) {
            l.setStockDisponible(Integer.parseInt(stockDispStr.trim()));
        } else {
            l.setStockDisponible(stockTotal);
        }
        
        l.setUbicacionFisica(request.getParameter("ubicacionFisica"));
        l.setPortadaUrl(request.getParameter("portadaUrl"));
        l.setPdfUrl(request.getParameter("pdfUrl"));
        l.setEstado(request.getParameter("estado") != null ? request.getParameter("estado") : "DISPONIBLE");
        return l;
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
