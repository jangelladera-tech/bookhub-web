<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<jsp:include page="../includes/header.jsp" />
<jsp:include page="../includes/navbar.jsp" />

<div class="container py-5">
    <div class="row justify-content-center">
        <div class="col-md-6 col-lg-5">
            <div class="card shadow-lg border-0 rounded-4">
                <div class="card-body p-4 p-md-5">
                    <div class="text-center mb-4">
                        <div class="bg-primary text-white d-inline-flex align-items-center justify-content-center rounded-circle mb-3" style="width: 65px; height: 65px;">
                            <i class="bi bi-person-lock fs-2"></i>
                        </div>
                        <h3 class="fw-bold text-dark">Iniciar Sesión</h3>
                        <p class="text-muted small">Ingresa con tu correo institucional y contraseña</p>
                    </div>

                    <c:if test="${not empty error}">
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            <i class="bi bi-exclamation-triangle-fill me-2"></i> ${error}
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                    </c:if>

                    <c:if test="${not empty mensajeExito}">
                        <div class="alert alert-success alert-dismissible fade show" role="alert">
                            <i class="bi bi-check-circle-fill me-2"></i> ${mensajeExito}
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                    </c:if>

                    <form action="${pageContext.request.contextPath}/login" method="POST">
                        <input type="hidden" name="action" value="login">

                        <div class="mb-3">
                            <label for="correo" class="form-label fw-semibold small text-muted">Correo Institucional</label>
                            <div class="input-group">
                                <span class="input-group-text bg-light"><i class="bi bi-envelope"></i></span>
                                <input type="email" class="form-control" id="correo" name="correo" placeholder="ejemplo@bookhub.edu" required autofocus>
                            </div>
                        </div>

                        <div class="mb-4">
                            <label for="password" class="form-label fw-semibold small text-muted">Contraseña</label>
                            <div class="input-group">
                                <span class="input-group-text bg-light"><i class="bi bi-key"></i></span>
                                <input type="password" class="form-control" id="password" name="password" placeholder="••••••••" required>
                            </div>
                        </div>

                        <button type="submit" class="btn btn-primary w-100 py-2 fw-semibold shadow-sm mb-3">
                            <i class="bi bi-box-arrow-in-right me-1"></i> Ingresar al Sistema
                        </button>
                    </form>

                    <div class="card bg-light border-0 p-3 rounded-3 mb-3">
                        <span class="fw-bold text-dark small mb-1"><i class="bi bi-info-circle me-1 text-primary"></i> Credenciales de Demostración:</span>
                        <div class="small text-muted">
                            <div><strong>Admin:</strong> <code>admin@bookhub.edu</code> / <code>admin123</code></div>
                            <div><strong>Estudiante:</strong> <code>juan.perez@bookhub.edu</code> / <code>user123</code></div>
                        </div>
                    </div>

                    <div class="text-center small text-muted">
                        ¿No tienes una cuenta registrada? 
                        <a href="${pageContext.request.contextPath}/registro" class="fw-semibold text-primary text-decoration-none">Regístrate aquí</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="../includes/footer.jsp" />
