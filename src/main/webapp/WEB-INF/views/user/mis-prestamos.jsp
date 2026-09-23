<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<jsp:include page="../includes/header.jsp" />
<jsp:include page="../includes/navbar.jsp" />

<div class="container py-4">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h3 class="fw-bold mb-1"><i class="bi bi-journal-bookmark-fill text-primary me-2"></i> Mis Préstamos y Solicitudes</h3>
            <p class="text-muted small mb-0">Revisa el estado de tus libros solicitados y fechas límite de devolución.</p>
        </div>
        <a href="${pageContext.request.contextPath}/catalogo" class="btn btn-outline-primary btn-sm">
            <i class="bi bi-plus-circle me-1"></i> Explorar Más Libros
        </a>
    </div>

    <c:if test="${param.msg == 'solicitud_exitosa'}">
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            <i class="bi bi-check-circle-fill me-2"></i> ¡Tu solicitud de préstamo se ha registrado con éxito! Acércate al mostrador de la biblioteca para recoger tu libro.
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    </c:if>

    <div class="card border-0 shadow-sm rounded-4 overflow-hidden">
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead class="table-light">
                        <tr>
                            <th class="ps-4">Código / ID</th>
                            <th>Libro</th>
                            <th>Fecha Solicitud</th>
                            <th>Fecha Préstamo</th>
                            <th>Fecha Límite</th>
                            <th>Estado</th>
                            <th class="pe-4">Observaciones</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${not empty misPrestamos}">
                                <c:forEach items="${misPrestamos}" var="p">
                                    <tr>
                                        <td class="ps-4 fw-bold text-muted">#P-${p.idPrestamo}</td>
                                        <td>
                                            <div class="fw-bold text-dark">${p.libroTitulo}</div>
                                            <small class="text-muted">ISBN: ${p.libroIsbn}</small>
                                        </td>
                                        <td><span class="badge bg-light text-dark border">${p.fechaSolicitud}</span></td>
                                        <td>${p.fechaPrestamo != null ? p.fechaPrestamo : '<em class="text-muted">Pendiente entrega</em>'}</td>
                                        <td>
                                            <strong class="text-primary">${p.fechaLimite}</strong>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${p.estado == 'SOLICITADO'}">
                                                    <span class="badge bg-warning text-dark"><i class="bi bi-hourglass-split me-1"></i> Solicitado</span>
                                                </c:when>
                                                <c:when test="${p.estado == 'EN_PRESTAMO'}">
                                                    <span class="badge bg-primary"><i class="bi bi-book me-1"></i> En Préstamo</span>
                                                </c:when>
                                                <c:when test="${p.estado == 'DEVUELTO'}">
                                                    <span class="badge bg-success"><i class="bi bi-check2-all me-1"></i> Devuelto</span>
                                                </c:when>
                                                <c:when test="${p.estado == 'DEVUELTO_CON_RETRASO'}">
                                                    <span class="badge bg-danger"><i class="bi bi-exclamation-triangle me-1"></i> Devuelto c/ retraso</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-secondary">${p.estado}</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="pe-4 small text-muted">${p.observaciones}</td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="7" class="text-center py-5 text-muted">
                                        <i class="bi bi-journal-x display-4 d-block mb-3 opacity-50"></i>
                                        No tienes préstamos ni solicitudes registradas por el momento.
                                    </td>
                                </tr>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<jsp:include page="../includes/footer.jsp" />
