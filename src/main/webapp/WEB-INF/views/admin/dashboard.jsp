<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<jsp:include page="../includes/header.jsp" />
<jsp:include page="../includes/navbar.jsp" />

<div class="container py-4">
    <!-- Header Admin -->
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h3 class="fw-bold mb-1"><i class="bi bi-speedometer2 text-primary me-2"></i> Panel de Administración General</h3>
            <p class="text-muted small mb-0">Monitoreo en tiempo real del acervo bibliográfico, préstamos en curso y miembros.</p>
        </div>
        <div class="d-flex gap-2">
            <a href="${pageContext.request.contextPath}/admin/libros" class="btn btn-primary btn-sm">
                <i class="bi bi-plus-lg me-1"></i> Gestionar Libros
            </a>
            <a href="${pageContext.request.contextPath}/admin/prestamos" class="btn btn-warning btn-sm fw-semibold text-dark">
                <i class="bi bi-arrow-left-right me-1"></i> Ver Préstamos
            </a>
        </div>
    </div>

    <!-- Stats Cards -->
    <div class="row g-4 mb-4">
        <div class="col-md-4">
            <div class="stat-card">
                <div class="stat-icon books">
                    <i class="bi bi-book-half"></i>
                </div>
                <div>
                    <h2 class="fw-bold mb-0 text-dark">${totalLibros}</h2>
                    <span class="text-muted small">Títulos en Catálogo</span>
                </div>
            </div>
        </div>

        <div class="col-md-4">
            <div class="stat-card">
                <div class="stat-icon loans">
                    <i class="bi bi-journal-check"></i>
                </div>
                <div>
                    <h2 class="fw-bold mb-0 text-dark">${prestamosActivos}</h2>
                    <span class="text-muted small">Préstamos Activos / Solicitudes</span>
                </div>
            </div>
        </div>

        <div class="col-md-4">
            <div class="stat-card">
                <div class="stat-icon users">
                    <i class="bi bi-people-fill"></i>
                </div>
                <div>
                    <h2 class="fw-bold mb-0 text-dark">${usuariosActivos}</h2>
                    <span class="text-muted small">Usuarios Registrados Activos</span>
                </div>
            </div>
        </div>
    </div>

    <!-- Tabla de últimos movimientos -->
    <div class="card border-0 shadow-sm rounded-4 overflow-hidden">
        <div class="card-header bg-white py-3 border-0 d-flex justify-content-between align-items-center">
            <h5 class="fw-bold mb-0 text-dark"><i class="bi bi-clock-history me-2 text-primary"></i> Últimos Préstamos y Solicitudes</h5>
            <a href="${pageContext.request.contextPath}/admin/prestamos" class="btn btn-sm btn-outline-primary">Ver Todos</a>
        </div>
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead class="table-light">
                        <tr>
                            <th class="ps-4">ID</th>
                            <th>Usuario / Código</th>
                            <th>Libro</th>
                            <th>F. Solicitud</th>
                            <th>F. Límite</th>
                            <th>Estado</th>
                            <th class="pe-4 text-end">Acciones</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${ultimosPrestamos}" var="p">
                            <tr>
                                <td class="ps-4 fw-bold text-muted">#P-${p.idPrestamo}</td>
                                <td>
                                    <div class="fw-semibold text-dark">${p.usuarioNombre}</div>
                                    <small class="text-muted">${p.usuarioCodigo}</small>
                                </td>
                                <td>
                                    <div class="text-dark">${p.libroTitulo}</div>
                                </td>
                                <td>${p.fechaSolicitud}</td>
                                <td><strong>${p.fechaLimite}</strong></td>
                                <td>
                                    <c:choose>
                                        <c:when test="${p.estado == 'SOLICITADO'}">
                                            <span class="badge bg-warning text-dark">Solicitado</span>
                                        </c:when>
                                        <c:when test="${p.estado == 'EN_PRESTAMO'}">
                                            <span class="badge bg-primary">En Préstamo</span>
                                        </c:when>
                                        <c:when test="${p.estado == 'DEVUELTO'}">
                                            <span class="badge bg-success">Devuelto</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-secondary">${p.estado}</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="pe-4 text-end">
                                    <c:if test="${p.estado == 'SOLICITADO'}">
                                        <form action="${pageContext.request.contextPath}/admin/prestamos" method="POST" class="d-inline">
                                            <input type="hidden" name="action" value="aprobar">
                                            <input type="hidden" name="idPrestamo" value="${p.idPrestamo}">
                                            <button type="submit" class="btn btn-sm btn-success">
                                                <i class="bi bi-check-lg"></i> Aprobar Entrega
                                            </button>
                                        </form>
                                    </c:if>
                                    <c:if test="${p.estado == 'EN_PRESTAMO'}">
                                        <form action="${pageContext.request.contextPath}/admin/prestamos" method="POST" class="d-inline">
                                            <input type="hidden" name="action" value="devolver">
                                            <input type="hidden" name="idPrestamo" value="${p.idPrestamo}">
                                            <input type="hidden" name="idLibro" value="${p.idLibro}">
                                            <button type="submit" class="btn btn-sm btn-info text-white">
                                                <i class="bi bi-box-arrow-in-left"></i> Devolver
                                            </button>
                                        </form>
                                    </c:if>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<jsp:include page="../includes/footer.jsp" />
