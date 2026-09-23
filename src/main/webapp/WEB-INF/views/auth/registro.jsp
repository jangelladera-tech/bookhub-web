<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<jsp:include page="../includes/header.jsp" />
<jsp:include page="../includes/navbar.jsp" />

<div class="container py-5">
    <div class="row justify-content-center">
        <div class="col-md-7 col-lg-6">
            <div class="card shadow-lg border-0 rounded-4">
                <div class="card-body p-4 p-md-5">
                    <div class="text-center mb-4">
                        <div class="bg-warning text-dark d-inline-flex align-items-center justify-content-center rounded-circle mb-3" style="width: 65px; height: 65px;">
                            <i class="bi bi-person-plus-fill fs-2"></i>
                        </div>
                        <h3 class="fw-bold text-dark">Registro de Usuario</h3>
                        <p class="text-muted small">Crea tu cuenta institucional para solicitar préstamos y recursos</p>
                    </div>

                    <c:if test="${not empty error}">
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            <i class="bi bi-exclamation-triangle-fill me-2"></i> ${error}
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                    </c:if>

                    <form action="${pageContext.request.contextPath}/registro" method="POST">
                        <input type="hidden" name="action" value="registrar">

                        <div class="mb-3">
                            <label for="nombreCompleto" class="form-label fw-semibold small text-muted">Nombre Completo</label>
                            <input type="text" class="form-control" id="nombreCompleto" name="nombreCompleto" placeholder="Ej. Ana Lucía Morales" required>
                        </div>

                        <div class="row g-2 mb-3">
                            <div class="col-md-6">
                                <label for="codigoUniversitario" class="form-label fw-semibold small text-muted">Código Universitario</label>
                                <input type="text" class="form-control" id="codigoUniversitario" name="codigoUniversitario" placeholder="Ej. U20241050" required>
                            </div>
                            <div class="col-md-6">
                                <label for="rol" class="form-label fw-semibold small text-muted">Tipo de Miembro</label>
                                <select class="form-select" id="rol" name="rol">
                                    <option value="ESTUDIANTE" selected>Estudiante</option>
                                    <option value="DOCENTE">Docente / Investigador</option>
                                </select>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label for="correo" class="form-label fw-semibold small text-muted">Correo Institucional</label>
                            <input type="email" class="form-control" id="correo" name="correo" placeholder="usuario@bookhub.edu" required>
                        </div>

                        <div class="mb-4">
                            <label for="password" class="form-label fw-semibold small text-muted">Contraseña</label>
                            <input type="password" class="form-control" id="password" name="password" placeholder="Mínimo 6 caracteres" required minlength="4">
                        </div>

                        <button type="submit" class="btn btn-warning text-dark w-100 py-2 fw-bold shadow-sm mb-3">
                            <i class="bi bi-check2-circle me-1"></i> Completar Registro
                        </button>
                    </form>

                    <div class="text-center small text-muted">
                        ¿Ya tienes una cuenta? 
                        <a href="${pageContext.request.contextPath}/login" class="fw-semibold text-primary text-decoration-none">Inicia sesión</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="../includes/footer.jsp" />
