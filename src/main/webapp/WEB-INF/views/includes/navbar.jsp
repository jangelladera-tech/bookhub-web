<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<nav class="navbar navbar-expand-lg navbar-dark navbar-bookhub sticky-top">
    <div class="container">
        <a class="navbar-brand d-flex align-items-center" href="${pageContext.request.contextPath}/catalogo">
            <i class="bi bi-book-half me-2 text-warning fs-4"></i>
            <span>BOOK<span class="text-warning">HUB</span></span>
        </a>

        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarBookHub" aria-controls="navbarBookHub" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="navbarBookHub">
            <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/catalogo">
                        <i class="bi bi-grid-fill me-1"></i> Catálogo
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/recursos-digitales">
                        <i class="bi bi-file-earmark-pdf-fill me-1"></i> Recursos Digitales
                    </a>
                </li>
                <c:if test="${sessionScope.usuarioLogueado != null && !sessionScope.usuarioLogueado.esAdmin()}">
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/mis-prestamos">
                            <i class="bi bi-clock-history me-1"></i> Mis Préstamos
                        </a>
                    </li>
                </c:if>

                <c:if test="${sessionScope.usuarioLogueado != null && sessionScope.usuarioLogueado.esAdmin()}">
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle text-warning" href="#" id="adminDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                            <i class="bi bi-shield-lock-fill me-1"></i> Panel Admin
                        </a>
                        <ul class="dropdown-menu dropdown-menu-dark" aria-labelledby="adminDropdown">
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/admin/dashboard"><i class="bi bi-speedometer2 me-2"></i>Dashboard</a></li>
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/admin/libros"><i class="bi bi-journals me-2"></i>Gestión de Libros (CRUD)</a></li>
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/admin/prestamos"><i class="bi bi-arrow-left-right me-2"></i>Control de Préstamos</a></li>
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/admin/usuarios"><i class="bi bi-people-fill me-2"></i>Gestión de Usuarios</a></li>
                        </ul>
                    </li>
                </c:if>
            </ul>

            <div class="d-flex align-items-center">
                <c:choose>
                    <c:when test="${sessionScope.usuarioLogueado != null}">
                        <div class="dropdown">
                            <button class="btn btn-outline-light dropdown-toggle d-flex align-items-center" type="button" id="userMenuBtn" data-bs-toggle="dropdown" aria-expanded="false">
                                <i class="bi bi-person-circle fs-5 me-2"></i>
                                <span>${sessionScope.usuarioLogueado.nombreCompleto}</span>
                            </button>
                            <ul class="dropdown-menu dropdown-menu-end shadow" aria-labelledby="userMenuBtn">
                                <li class="dropdown-header">
                                    <small class="text-muted">Rol: ${sessionScope.usuarioLogueado.rol}</small><br>
                                    <strong>${sessionScope.usuarioLogueado.codigoUniversitario}</strong>
                                </li>
                                <li><hr class="dropdown-divider"></li>
                                <c:if test="${!sessionScope.usuarioLogueado.esAdmin()}">
                                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/mis-prestamos"><i class="bi bi-journal-bookmark me-2"></i>Mis Préstamos</a></li>
                                </c:if>
                                <c:if test="${sessionScope.usuarioLogueado.esAdmin()}">
                                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/admin/dashboard"><i class="bi bi-speedometer2 me-2"></i>Panel Administrativo</a></li>
                                </c:if>
                                <li><hr class="dropdown-divider"></li>
                                <li><a class="dropdown-item text-danger" href="${pageContext.request.contextPath}/logout"><i class="bi bi-box-arrow-right me-2"></i>Cerrar Sesión</a></li>
                            </ul>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <a href="${pageContext.request.contextPath}/login" class="btn btn-outline-light me-2">
                            <i class="bi bi-box-arrow-in-right me-1"></i> Ingresar
                        </a>
                        <a href="${pageContext.request.contextPath}/registro" class="btn btn-warning fw-semibold">
                            Registrarse
                        </a>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</nav>
<main class="py-4">
