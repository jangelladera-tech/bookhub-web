<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<jsp:include page="../includes/header.jsp" />
<jsp:include page="../includes/navbar.jsp" />

<div class="container-fluid px-4 py-4">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h3 class="fw-bold mb-1"><i class="bi bi-arrow-left-right text-warning me-2"></i> Control de Préstamos y Devoluciones</h3>
            <p class="text-muted small mb-0">Atención de solicitudes de salida de libros, recepción de devoluciones y control de stock.</p>
        </div>
    </div>

    <c:if test="${param.msg == 'aprobado_ok'}">
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            <i class="bi bi-check-circle-fill me-2"></i> Préstamo aprobado y registrado como entregado al estudiante.
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    </c:if>
    <c:if test="${param.msg == 'devolucion_ok'}">
        <div class="alert alert-info alert-dismissible fade show" role="alert">
            <i class="bi bi-box-arrow-in-left me-2"></i> Devolución completada. El stock del libro ha sido restablecido.
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    </c:if>

    <div class="card border-0 shadow-sm rounded-4 overflow-hidden">
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead class="table-light">
                        <tr>
                            <th class="ps-4">Código Préstamo</th>
                            <th>Estudiante / Miembro</th>
                            <th>Libro Solicitado</th>
                            <th>F. Solicitud</th>
                            <th>F. Préstamo</th>
                            <th>F. Límite Devolución</th>
                            <th>F. Devolución Real</th>
                            <th>Estado</th>
                            <th class="pe-4 text-end">Acción de Control</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${prestamos}" var="p">
                            <tr>
                                <td class="ps-4 fw-bold text-muted">#P-${p.idPrestamo}</td>
                                <td>
                                    <div class="fw-bold text-dark">${p.usuarioNombre}</div>
                                    <small class="badge bg-light text-dark border">${p.usuarioCodigo}</small>
                                </td>
                                <td>
                                    <div class="text-dark fw-semibold">${p.libroTitulo}</div>
                                    <small class="text-muted">ISBN: ${p.libroIsbn}</small>
                                </td>
                                <td>${p.fechaSolicitud}</td>
                                <td>${p.fechaPrestamo != null ? p.fechaPrestamo : '<em class="text-muted">No entregado</em>'}</td>
                                <td><strong class="text-primary">${p.fechaLimite}</strong></td>
                                <td>${p.fechaDevolucion != null ? p.fechaDevolucion : '<em class="text-muted">-</em>'}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${p.estado == 'SOLICITADO'}">
                                            <span class="badge bg-warning text-dark"><i class="bi bi-hourglass-split me-1"></i> SOLICITADO</span>
                                        </c:when>
                                        <c:when test="${p.estado == 'EN_PRESTAMO'}">
                                            <span class="badge bg-primary"><i class="bi bi-book me-1"></i> EN PRÉSTAMO</span>
                                        </c:when>
                                        <c:when test="${p.estado == 'DEVUELTO'}">
                                            <span class="badge bg-success"><i class="bi bi-check2-all me-1"></i> DEVUELTO</span>
                                        </c:when>
                                        <c:when test="${p.estado == 'DEVUELTO_CON_RETRASO'}">
                                            <span class="badge bg-danger"><i class="bi bi-exclamation-triangle-fill me-1"></i> CON RETRASO</span>
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
                                            <button type="submit" class="btn btn-sm btn-success fw-semibold">
                                                <i class="bi bi-box-arrow-right me-1"></i> Entregar Ejemplar
                                            </button>
                                        </form>
                                    </c:if>
                                    <c:if test="${p.estado == 'EN_PRESTAMO'}">
                                        <form action="${pageContext.request.contextPath}/admin/prestamos" method="POST" class="d-inline">
                                            <input type="hidden" name="action" value="devolver">
                                            <input type="hidden" name="idPrestamo" value="${p.idPrestamo}">
                                            <input type="hidden" name="idLibro" value="${p.idLibro}">
                                            <button type="submit" class="btn btn-sm btn-info text-white fw-semibold">
                                                <i class="bi bi-box-arrow-in-left me-1"></i> Registrar Devolución
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
