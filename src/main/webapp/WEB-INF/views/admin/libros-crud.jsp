<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<jsp:include page="../includes/header.jsp" />
<jsp:include page="../includes/navbar.jsp" />

<div class="container-fluid px-4 py-4">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h3 class="fw-bold mb-1"><i class="bi bi-journals text-primary me-2"></i> Gestión de Libros y Recursos (CRUD)</h3>
            <p class="text-muted small mb-0">Mantenimiento de títulos, inventario físico, ubicación y recursos digitales.</p>
        </div>
        <button type="button" class="btn btn-primary fw-semibold" data-bs-toggle="modal" data-bs-target="#modalNuevoLibro">
            <i class="bi bi-plus-circle-fill me-1"></i> Registrar Nuevo Libro
        </button>
    </div>

    <c:if test="${param.msg == 'creado_ok'}">
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            <i class="bi bi-check-circle-fill me-2"></i> ¡Libro registrado exitosamente en el catálogo!
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    </c:if>
    <c:if test="${param.msg == 'actualizado_ok'}">
        <div class="alert alert-info alert-dismissible fade show" role="alert">
            <i class="bi bi-info-circle-fill me-2"></i> Datos del libro actualizados correctamente.
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    </c:if>
    <c:if test="${param.msg == 'eliminado_ok'}">
        <div class="alert alert-warning alert-dismissible fade show" role="alert">
            <i class="bi bi-trash-fill me-2"></i> El libro ha sido eliminado del sistema.
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    </c:if>

    <div class="card border-0 shadow-sm rounded-4 overflow-hidden">
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead class="table-light">
                        <tr>
                            <th class="ps-4">ID</th>
                            <th>Portada</th>
                            <th>Título / Autor</th>
                            <th>Categoría</th>
                            <th>ISBN</th>
                            <th>Stock (Disp / Total)</th>
                            <th>Ubicación</th>
                            <th>Recurso Digital</th>
                            <th class="pe-4 text-end">Acciones</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${libros}" var="l">
                            <tr>
                                <td class="ps-4 fw-bold text-muted">#${l.idLibro}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty l.portadaUrl}">
                                            <img src="${l.portadaUrl}" alt="portada" class="rounded shadow-sm" style="width: 42px; height: 58px; object-fit: cover;">
                                        </c:when>
                                        <c:otherwise>
                                            <div class="bg-secondary text-white rounded d-flex align-items-center justify-content-center" style="width: 42px; height: 58px;">
                                                <i class="bi bi-book"></i>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <div class="fw-bold text-dark">${l.titulo}</div>
                                    <small class="text-muted"><i class="bi bi-person"></i> ${l.autor} (${l.anioPublicacion})</small>
                                </td>
                                <td><span class="badge bg-light text-dark border">${l.categoriaNombre}</span></td>
                                <td><small class="text-muted">${l.isbn}</small></td>
                                <td>
                                    <span class="badge ${l.stockDisponible > 0 ? 'bg-success-subtle text-success border border-success-subtle' : 'bg-danger-subtle text-danger border border-danger-subtle'}">
                                        ${l.stockDisponible} / ${l.stockTotal}
                                    </span>
                                </td>
                                <td><small class="text-secondary"><i class="bi bi-geo-alt-fill text-danger me-1"></i> ${l.ubicacionFisica}</small></td>
                                <td>
                                    <c:choose>
                                        <c:when test="${l.tieneRecursoDigital()}">
                                            <a href="${l.pdfUrl}" target="_blank" class="badge bg-primary text-decoration-none">
                                                <i class="bi bi-file-earmark-pdf-fill me-1"></i> PDF
                                            </a>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="text-muted small">N/A</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="pe-4 text-end">
                                    <button type="button" class="btn btn-sm btn-outline-primary me-1"
                                            data-bs-toggle="modal" data-bs-target="#modalEditarLibro"
                                            data-id="${l.idLibro}"
                                            data-titulo="${l.titulo}"
                                            data-autor="${l.autor}"
                                            data-editorial="${l.editorial}"
                                            data-anio="${l.anioPublicacion}"
                                            data-isbn="${l.isbn}"
                                            data-categoria="${l.idCategoria}"
                                            data-stock-total="${l.stockTotal}"
                                            data-stock-disp="${l.stockDisponible}"
                                            data-ubicacion="${l.ubicacionFisica}"
                                            data-portada="${l.portadaUrl}"
                                            data-pdf="${l.pdfUrl}"
                                            data-estado="${l.estado}">
                                        <i class="bi bi-pencil-square"></i>
                                    </button>

                                    <form action="${pageContext.request.contextPath}/admin/libros" method="POST" class="d-inline">
                                        <input type="hidden" name="action" value="eliminar">
                                        <input type="hidden" name="idLibro" value="${l.idLibro}">
                                        <button type="submit" class="btn btn-sm btn-outline-danger btn-confirm-delete" data-title="${l.titulo}">
                                            <i class="bi bi-trash"></i>
                                        </button>
                                    </form>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<!-- MODAL: REGISTRAR NUEVO LIBRO -->
<div class="modal fade" id="modalNuevoLibro" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-lg modal-dialog-centered">
        <div class="modal-content border-0 shadow-lg rounded-4">
            <div class="modal-header bg-primary text-white">
                <h5 class="modal-title fw-bold"><i class="bi bi-plus-circle me-2"></i> Registrar Nuevo Libro en Catálogo</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form action="${pageContext.request.contextPath}/admin/libros" method="POST">
                <input type="hidden" name="action" value="crear">
                <div class="modal-body p-4">
                    <div class="row g-3">
                        <div class="col-md-8">
                            <label class="form-label fw-semibold small text-muted">Título del Libro *</label>
                            <input type="text" name="titulo" class="form-control" required placeholder="Ej. Clean Code">
                        </div>
                        <div class="col-md-4">
                            <label class="form-label fw-semibold small text-muted">Categoría *</label>
                            <select name="idCategoria" class="form-select" required>
                                <c:forEach items="${categorias}" var="c">
                                    <option value="${c.idCategoria}">${c.nombre}</option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="col-md-6">
                            <label class="form-label fw-semibold small text-muted">Autor(es) *</label>
                            <input type="text" name="autor" class="form-control" required placeholder="Ej. Robert C. Martin">
                        </div>
                        <div class="col-md-3">
                            <label class="form-label fw-semibold small text-muted">Editorial</label>
                            <input type="text" name="editorial" class="form-control" placeholder="Ej. Prentice Hall">
                        </div>
                        <div class="col-md-3">
                            <label class="form-label fw-semibold small text-muted">Año</label>
                            <input type="number" name="anioPublicacion" class="form-control" value="2024">
                        </div>

                        <div class="col-md-4">
                            <label class="form-label fw-semibold small text-muted">ISBN *</label>
                            <input type="text" name="isbn" class="form-control" required placeholder="Ej. 978-0132350884">
                        </div>
                        <div class="col-md-4">
                            <label class="form-label fw-semibold small text-muted">Stock Total *</label>
                            <input type="number" name="stockTotal" class="form-control" value="5" min="1" required>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label fw-semibold small text-muted">Ubicación en Estante *</label>
                            <input type="text" name="ubicacionFisica" class="form-control" required placeholder="Ej. Estante A-2, Nivel 1">
                        </div>

                        <div class="col-md-6">
                            <label class="form-label fw-semibold small text-muted">URL Imagen de Portada</label>
                            <input type="url" name="portadaUrl" class="form-control" placeholder="https://...">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold small text-muted">URL Documento PDF (Digital)</label>
                            <input type="url" name="pdfUrl" class="form-control" placeholder="https://...">
                        </div>
                    </div>
                </div>
                <div class="modal-footer bg-light">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                    <button type="submit" class="btn btn-primary fw-semibold">Guardar Libro</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- MODAL: EDITAR LIBRO -->
<div class="modal fade" id="modalEditarLibro" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-lg modal-dialog-centered">
        <div class="modal-content border-0 shadow-lg rounded-4">
            <div class="modal-header bg-dark text-white">
                <h5 class="modal-title fw-bold"><i class="bi bi-pencil-square me-2"></i> Editar Información de Libro</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form action="${pageContext.request.contextPath}/admin/libros" method="POST">
                <input type="hidden" name="action" value="actualizar">
                <input type="hidden" name="idLibro" id="editIdLibro">

                <div class="modal-body p-4">
                    <div class="row g-3">
                        <div class="col-md-8">
                            <label class="form-label fw-semibold small text-muted">Título del Libro</label>
                            <input type="text" name="titulo" id="editTitulo" class="form-control" required>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label fw-semibold small text-muted">Categoría</label>
                            <select name="idCategoria" id="editCategoria" class="form-select" required>
                                <c:forEach items="${categorias}" var="c">
                                    <option value="${c.idCategoria}">${c.nombre}</option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="col-md-6">
                            <label class="form-label fw-semibold small text-muted">Autor(es)</label>
                            <input type="text" name="autor" id="editAutor" class="form-control" required>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label fw-semibold small text-muted">Editorial</label>
                            <input type="text" name="editorial" id="editEditorial" class="form-control">
                        </div>
                        <div class="col-md-3">
                            <label class="form-label fw-semibold small text-muted">Año</label>
                            <input type="number" name="anioPublicacion" id="editAnio" class="form-control">
                        </div>

                        <div class="col-md-3">
                            <label class="form-label fw-semibold small text-muted">ISBN</label>
                            <input type="text" name="isbn" id="editIsbn" class="form-control" required>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label fw-semibold small text-muted">Stock Total</label>
                            <input type="number" name="stockTotal" id="editStockTotal" class="form-control" min="1" required>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label fw-semibold small text-muted">Stock Disponible</label>
                            <input type="number" name="stockDisponible" id="editStockDisponible" class="form-control" min="0" required>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label fw-semibold small text-muted">Estado</label>
                            <select name="estado" id="editEstado" class="form-select">
                                <option value="DISPONIBLE">DISPONIBLE</option>
                                <option value="NO_DISPONIBLE">NO DISPONIBLE</option>
                            </select>
                        </div>

                        <div class="col-md-12">
                            <label class="form-label fw-semibold small text-muted">Ubicación en Estante</label>
                            <input type="text" name="ubicacionFisica" id="editUbicacion" class="form-control" required>
                        </div>

                        <div class="col-md-6">
                            <label class="form-label fw-semibold small text-muted">URL Portada</label>
                            <input type="url" name="portadaUrl" id="editPortada" class="form-control">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold small text-muted">URL Recurso PDF</label>
                            <input type="url" name="pdfUrl" id="editPdf" class="form-control">
                        </div>
                    </div>
                </div>
                <div class="modal-footer bg-light">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                    <button type="submit" class="btn btn-success fw-semibold">Guardar Cambios</button>
                </div>
            </form>
        </div>
    </div>
</div>

<jsp:include page="../includes/footer.jsp" />
