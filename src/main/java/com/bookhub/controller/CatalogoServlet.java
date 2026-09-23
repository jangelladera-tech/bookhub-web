package com.bookhub.controller;

import com.bookhub.dao.CategoriaDAO;
import com.bookhub.dao.LibroDAO;
import com.bookhub.model.Categoria;
import com.bookhub.model.Libro;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet para consulta del catálogo público de libros y recursos digitales.
 */
@WebServlet(name = "CatalogoServlet", urlPatterns = {"/catalogo", "/libro-detalle", "/recursos-digitales"})
public class CatalogoServlet extends HttpServlet {

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
        String path = request.getServletPath();

        if ("/libro-detalle".equals(path)) {
            mostrarDetalleLibro(request, response);
        } else if ("/recursos-digitales".equals(path)) {
            mostrarRecursosDigitales(request, response);
        } else {
            mostrarCatalogo(request, response);
        }
    }

    private void mostrarCatalogo(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String query = request.getParameter("q");
        String catParam = request.getParameter("categoria");
        int idCategoria = 0;
        if (catParam != null && !catParam.trim().isEmpty()) {
            try {
                idCategoria = Integer.parseInt(catParam.trim());
            } catch (NumberFormatException ignored) {}
        }

        List<Libro> libros = libroDAO.buscarPorFiltros(query, idCategoria);
        List<Categoria> categorias = categoriaDAO.listarTodas();

        request.setAttribute("libros", libros);
        request.setAttribute("categorias", categorias);
        request.setAttribute("q", query != null ? query : "");
        request.setAttribute("categoriaSeleccionada", idCategoria);

        request.getRequestDispatcher("/WEB-INF/views/user/catalogo.jsp").forward(request, response);
    }

    private void mostrarDetalleLibro(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idParam = request.getParameter("id");
        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/catalogo");
            return;
        }

        try {
            int idLibro = Integer.parseInt(idParam.trim());
            Libro libro = libroDAO.obtenerPorId(idLibro);
            if (libro != null) {
                request.setAttribute("libro", libro);
                request.getRequestDispatcher("/WEB-INF/views/user/detalle-libro.jsp").forward(request, response);
                return;
            }
        } catch (NumberFormatException ignored) {}

        response.sendRedirect(request.getContextPath() + "/catalogo?error=libro_no_encontrado");
    }

    private void mostrarRecursosDigitales(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Libro> recursos = libroDAO.listarRecursosDigitales();
        request.setAttribute("recursos", recursos);
        request.getRequestDispatcher("/WEB-INF/views/user/recursos-digitales.jsp").forward(request, response);
    }
}
