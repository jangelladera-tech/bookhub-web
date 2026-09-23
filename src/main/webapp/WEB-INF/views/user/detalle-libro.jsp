<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<jsp:include page="../includes/header.jsp" />
<jsp:include page="../includes/navbar.jsp" />

<div class="container py-4">
    <nav aria-label="breadcrumb" class="mb-4">
        <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/catalogo" class="text-decoration-none">Catálogo</a></li>
            <li class="breadcrumb-item active" aria-current="page">${libro.titulo}</li>
        </ol>
    </nav>

    <c:if test="${param.error == 'sin_stock'}">
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
            <i class="bi bi-exclamation-octagon-fill me-2"></i> Lo sentimos, en este momento no quedan ejemplares físicos disponibles para préstamo.
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    </c:if>

    <div class="card border-0 shadow-sm rounded-4 overflow-hidden mb-4">
        <div class="row g-0">
            <div class="col-md-4 bg-light text-center p-4 d-flex align-items-center justify-content-center">
                <c:choose>
                    <c:when test="${not empty libro.portadaUrl}">
                        <img src="${libro.portadaUrl}" alt="${libro.titulo}" class="img-fluid rounded-3 shadow" style="max-height: 380px; object-fit: cover;">
                    </c:when>
                    <c:otherwise>
                        <i class="bi bi-book display-1 text-muted"></i>
                    </c:otherwise>
                </c:choose>
            </div>
            <div class="col-md-8 p-4 p-lg-5 d-flex flex-column justify-content-between">
                <div>
                    <span class="badge bg-primary-subtle text-primary border border-primary-subtle px-3 py-2 rounded-pill fw-semibold mb-3">
                        ${libro.categoriaNombre}
                    </span>
                    <h2 class="fw-bold text-dark mb-2">${libro.titulo}</h2>
                    <h5 class="text-muted fw-normal mb-4"><i class="bi bi-person me-1"></i> ${libro.autor}</h5>

                    <div class="row g-3 mb-4">
                        <div class="col-sm-6">
                            <div class="p-3 bg-light rounded-3">
                                <small class="text-muted d-block">Editorial y Año</small>
                                <strong>${libro.editorial} (${libro.anioPublicacion})</strong>
                            </div>
                        </div>
                        <div class="col-sm-6">
                            <div class="p-3 bg-light rounded-3">
                                <small class="text-muted d-block">Código ISBN</small>
                                <strong>${libro.isbn}</strong>
                            </div>
                        </div>
                        <div class="col-sm-6">
                            <div class="p-3 bg-light rounded-3">
                                <small class="text-muted d-block">Ubicación Física</small>
                                <strong><i class="bi bi-geo-alt-fill text-danger me-1"></i> ${libro.ubicacionFisica}</strong>
                            </div>
                        </div>
                        <div class="col-sm-6">
                            <div class="p-3 bg-light rounded-3">
                                <small class="text-muted d-block">Disponibilidad en Sala</small>
                                <c:choose>
                                    <c:when test="${libro.stockDisponible > 0}">
                                        <strong class="text-success"><i class="bi bi-check-circle-fill me-1"></i> ${libro.stockDisponible} de ${libro.stockTotal} disponibles</strong>
                                    </c:when>
                                    <c:otherwise>
                                        <strong class="text-danger"><i class="bi bi-x-circle-fill me-1"></i> Sin ejemplares en estante</strong>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="d-flex flex-wrap gap-3 pt-3 border-top">
                    <c:if test="${libro.stockDisponible > 0}">
                        <form action="${pageContext.request.contextPath}/solicitar-prestamo" method="POST" class="d-inline">
                            <input type="hidden" name="idLibro" value="${libro.idLibro}">
                            <input type="hidden" name="dias" value="7">
                            <button type="submit" class="btn btn-warning text-dark fw-bold px-4 py-2 shadow-sm">
                                <i class="bi bi-bookmark-plus-fill me-2"></i> Solicitar Préstamo Físico (7 días)
                            </button>
                        </form>
                    </c:if>

                    <c:if test="${libro.tieneRecursoDigital()}">
                        <a href="${libro.pdfUrl}" target="_blank" class="btn btn-primary fw-semibold px-4 py-2 shadow-sm">
                            <i class="bi bi-file-earmark-arrow-down-fill me-2"></i> Descargar Documento Digital
                        </a>
                    </c:if>

                    <a href="${pageContext.request.contextPath}/catalogo" class="btn btn-outline-secondary px-4 py-2">
                        <i class="bi bi-arrow-left me-1"></i> Volver al Catálogo
                    </a>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="../includes/footer.jsp" />
