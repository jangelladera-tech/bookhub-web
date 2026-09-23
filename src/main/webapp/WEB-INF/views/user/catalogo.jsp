<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<jsp:include page="../includes/header.jsp" />
<jsp:include page="../includes/navbar.jsp" />

<div class="container">
    <!-- Hero Banner -->
    <div class="hero-banner p-4 p-md-5 text-white">
        <div class="row align-items-center">
            <div class="col-lg-8">
                <span class="badge bg-warning text-dark px-3 py-2 rounded-pill fw-bold mb-3">
                    <i class="bi bi-stars me-1"></i> Biblioteca Universitaria & Digital
                </span>
                <h1 class="display-5 fw-bold mb-3">Explora el Conocimiento en BookHub</h1>
                <p class="lead mb-4 text-light opacity-90">
                    Accede a más de miles de títulos físicos para préstamo en campus y descarga recursos académicos digitales en formato libre.
                </p>

                <!-- Barra de búsqueda principal -->
                <form action="${pageContext.request.contextPath}/catalogo" method="GET" class="row g-2">
                    <div class="col-md-7">
                        <div class="input-group input-group-lg">
                            <span class="input-group-text bg-white border-0"><i class="bi bi-search text-primary"></i></span>
                            <input type="text" name="q" value="${q}" class="form-control border-0" placeholder="Buscar por título, autor o ISBN...">
                        </div>
                    </div>
                    <div class="col-md-3">
                        <select name="categoria" class="form-select form-select-lg border-0">
                            <option value="0">Todas las Áreas</option>
                            <c:forEach items="${categorias}" var="c">
                                <option value="${c.idCategoria}" ${categoriaSeleccionada == c.idCategoria ? 'selected' : ''}>${c.nombre}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="col-md-2">
                        <button type="submit" class="btn btn-warning btn-lg w-100 fw-bold">Buscar</button>
                    </div>
                </form>
            </div>
            <div class="col-lg-4 d-none d-lg-block text-center">
                <i class="bi bi-journal-bookmark-fill" style="font-size: 8rem; opacity: 0.85;"></i>
            </div>
        </div>
    </div>

    <!-- Filtros activos y resultados -->
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h4 class="fw-bold mb-1">Catálogo de Libros</h4>
            <p class="text-muted small mb-0">Mostrando <strong>${libros.size()}</strong> resultados encontrados</p>
        </div>
        <c:if test="${not empty q or categoriaSeleccionada > 0}">
            <a href="${pageContext.request.contextPath}/catalogo" class="btn btn-sm btn-outline-secondary">
                <i class="bi bi-x-circle me-1"></i> Limpiar Filtros
            </a>
        </c:if>
    </div>

    <!-- Grid de Libros -->
    <div class="row g-4">
        <c:forEach items="${libros}" var="libro">
            <div class="col-sm-6 col-md-4 col-lg-3">
                <div class="card book-card h-100">
                    <div class="book-card-img-wrapper">
                        <c:choose>
                            <c:when test="${not empty libro.portadaUrl}">
                                <img src="${libro.portadaUrl}" alt="${libro.titulo}">
                            </c:when>
                            <c:otherwise>
                                <div class="d-flex align-items-center justify-content-center h-100 bg-secondary text-white">
                                    <i class="bi bi-book fs-1"></i>
                                </div>
                            </c:otherwise>
                        </c:choose>

                        <c:choose>
                            <c:when test="${libro.stockDisponible > 0}">
                                <span class="badge-stock available">
                                    <i class="bi bi-check-circle-fill me-1"></i> ${libro.stockDisponible} Disponible(s)
                                </span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge-stock unavailable">
                                    <i class="bi bi-x-circle-fill me-1"></i> Agotado
                                </span>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <div class="card-body d-flex flex-column p-3">
                        <span class="badge bg-light text-primary text-truncate mb-2 align-self-start border">
                            ${libro.categoriaNombre}
                        </span>
                        <h6 class="card-title fw-bold mb-1 text-truncate-2" title="${libro.titulo}">
                            ${libro.titulo}
                        </h6>
                        <p class="card-text text-muted small mb-2"><i class="bi bi-pen me-1"></i> ${libro.autor}</p>

                        <div class="small text-secondary mb-3 mt-auto">
                            <div><i class="bi bi-geo-alt me-1 text-danger"></i> <strong>${libro.ubicacionFisica}</strong></div>
                            <div><i class="bi bi-upc-scan me-1"></i> ISBN: ${libro.isbn}</div>
                        </div>

                        <div class="d-grid gap-2">
                            <a href="${pageContext.request.contextPath}/libro-detalle?id=${libro.idLibro}" class="btn btn-outline-primary btn-sm fw-semibold">
                                <i class="bi bi-eye me-1"></i> Ver Detalles
                            </a>
                            <c:if test="${libro.stockDisponible > 0}">
                                <button type="button" class="btn btn-warning btn-sm fw-bold text-dark"
                                        data-bs-toggle="modal" data-bs-target="#modalSolicitarPrestamo"
                                        data-id="${libro.idLibro}" data-titulo="${libro.titulo}"
                                        data-autor="${libro.autor}" data-ubicacion="${libro.ubicacionFisica}">
                                    <i class="bi bi-bookmark-plus-fill me-1"></i> Solicitar Préstamo
                                </button>
                            </c:if>
                        </div>
                    </div>
                </div>
            </div>
        </c:forEach>
    </div>
</div>

<!-- Modal Solicitar Préstamo Rápido -->
<div class="modal fade" id="modalSolicitarPrestamo" tabindex="-1" aria-labelledby="modalPrestamoLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content border-0 shadow-lg rounded-4">
            <div class="modal-header bg-primary text-white">
                <h5 class="modal-title fw-bold" id="modalPrestamoLabel"><i class="bi bi-bookmark-check-fill me-2"></i> Solicitar Préstamo de Libro</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form action="${pageContext.request.contextPath}/solicitar-prestamo" method="POST">
                <input type="hidden" name="idLibro" id="prestamoIdLibro">
                <div class="modal-body p-4">
                    <div class="alert alert-info py-2 small mb-3">
                        <i class="bi bi-info-circle-fill me-1"></i> Podrás retirar tu libro físicamente en el mostrador del campus presentando tu carnet o código universitario.
                    </div>

                    <h6 class="fw-bold text-primary mb-1" id="prestamoTituloLibro">Título del Libro</h6>
                    <p class="text-muted small mb-2" id="prestamoAutorLibro">Autor</p>
                    <p class="small text-secondary mb-3"><strong>Ubicación en estantería:</strong> <span id="prestamoUbicacion"></span></p>

                    <div class="mb-3">
                        <label for="dias" class="form-label fw-semibold small text-muted">Duración del Préstamo</label>
                        <select name="dias" id="dias" class="form-select">
                            <option value="3">3 Días (Lectura Rápida)</option>
                            <option value="7" selected>7 Días (Estándar)</option>
                            <option value="14">14 Días (Trabajos de Investigación)</option>
                        </select>
                    </div>
                </div>
                <div class="modal-footer bg-light">
                    <button type="button" class="btn btn-secondary btn-sm" data-bs-dismiss="modal">Cancelar</button>
                    <button type="submit" class="btn btn-primary btn-sm fw-semibold">Confirmar Solicitud</button>
                </div>
            </form>
        </div>
    </div>
</div>

<jsp:include page="../includes/footer.jsp" />
