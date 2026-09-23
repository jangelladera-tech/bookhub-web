<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<jsp:include page="../includes/header.jsp" />
<jsp:include page="../includes/navbar.jsp" />

<div class="container py-4">
    <div class="p-4 mb-4 bg-light rounded-4 border">
        <div class="d-flex align-items-center">
            <div class="bg-primary text-white p-3 rounded-circle me-3">
                <i class="bi bi-file-earmark-pdf-fill fs-2"></i>
            </div>
            <div>
                <h3 class="fw-bold mb-1">Repositorio de Recursos Digitales</h3>
                <p class="text-muted mb-0">Acceso libre e inmediato a libros electrónicos, artículos científicos y guías en formato PDF.</p>
            </div>
        </div>
    </div>

    <div class="row g-4">
        <c:forEach items="${recursos}" var="r">
            <div class="col-md-6 col-lg-4">
                <div class="card h-100 border-0 shadow-sm rounded-4 p-3 d-flex flex-column justify-content-between">
                    <div>
                        <span class="badge bg-secondary-subtle text-secondary mb-2">${r.categoriaNombre}</span>
                        <h5 class="fw-bold text-dark mb-1 text-truncate-2">${r.titulo}</h5>
                        <p class="text-muted small mb-3"><i class="bi bi-person me-1"></i> ${r.autor} (${r.anioPublicacion})</p>
                        <p class="small text-secondary mb-3">
                            <strong>Editorial:</strong> ${r.editorial}<br>
                            <strong>ISBN:</strong> ${r.isbn}
                        </p>
                    </div>
                    <div class="pt-3 border-top d-flex gap-2">
                        <a href="${r.pdfUrl}" target="_blank" class="btn btn-primary btn-sm w-100 fw-semibold">
                            <i class="bi bi-download me-1"></i> Descargar PDF
                        </a>
                        <a href="${pageContext.request.contextPath}/libro-detalle?id=${r.idLibro}" class="btn btn-outline-secondary btn-sm">
                            <i class="bi bi-info-circle"></i>
                        </a>
                    </div>
                </div>
            </div>
        </c:forEach>
    </div>
</div>

<jsp:include page="../includes/footer.jsp" />
