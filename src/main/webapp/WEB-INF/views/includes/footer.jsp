<%@ page contentType="text/html;charset=UTF-8" language="java" %>
</main>

<footer class="footer-bookhub">
    <div class="container">
        <div class="row gy-4">
            <div class="col-lg-5 col-md-6">
                <h5 class="text-white d-flex align-items-center mb-3">
                    <i class="bi bi-book-half text-warning me-2"></i> BookHub
                </h5>
                <p class="small text-secondary">
                    Sistema de Gestión de Biblioteca Universitaria y Digital. Desarrollado con arquitectura Java Web (Servlets, JSP, JavaBeans, DAO y Bootstrap).
                </p>
                <div class="d-flex gap-3 fs-5">
                    <a href="#"><i class="bi bi-github"></i></a>
                    <a href="#"><i class="bi bi-globe"></i></a>
                    <a href="#"><i class="bi bi-envelope-fill"></i></a>
                </div>
            </div>

            <div class="col-lg-3 col-md-6">
                <h6 class="text-white mb-3">Enlaces Rápidos</h6>
                <ul class="list-unstyled small d-flex flex-column gap-2">
                    <li><a href="${pageContext.request.contextPath}/catalogo">Catálogo General</a></li>
                    <li><a href="${pageContext.request.contextPath}/recursos-digitales">Repositorio Digital</a></li>
                    <li><a href="${pageContext.request.contextPath}/mis-prestamos">Mis Solicitudes</a></li>
                </ul>
            </div>

            <div class="col-lg-4 col-md-12">
                <h6 class="text-white mb-3">Atención y Soporte</h6>
                <p class="small text-secondary mb-1"><i class="bi bi-geo-alt-fill text-warning me-2"></i> Campus Universitario - Edificio Central, Piso 2</p>
                <p class="small text-secondary mb-1"><i class="bi bi-clock-fill text-warning me-2"></i> Lun - Vie: 08:00 AM - 08:00 PM | Sáb: 09:00 AM - 01:00 PM</p>
                <p class="small text-secondary"><i class="bi bi-envelope-at-fill text-warning me-2"></i> biblioteca@universidad.edu</p>
            </div>
        </div>

        <hr class="border-secondary my-4">

        <div class="d-flex flex-column flex-sm-row justify-content-between align-items-center small text-secondary">
            <span>&copy; 2026 BookHub - Todos los derechos reservados.</span>
            <span>Desarrollo Java Web MVC</span>
        </div>
    </div>
</footer>

<!-- Bootstrap 5.3 JS Bundle with Popper -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<!-- Custom JS -->
<script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
</body>
</html>
