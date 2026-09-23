<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<jsp:include page="../includes/header.jsp" />
<jsp:include page="../includes/navbar.jsp" />

<div class="container-fluid px-4 py-4">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h3 class="fw-bold mb-1"><i class="bi bi-people-fill text-primary me-2"></i> Gestión de Miembros y Usuarios</h3>
            <p class="text-muted small mb-0">Control de acceso, roles académicos y aplicación de sanciones por retrasos.</p>
        </div>
    </div>

    <c:if test="${param.msg == 'actualizado_ok'}">
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            <i class="bi bi-check-circle-fill me-2"></i> Estado de cuenta de usuario actualizado exitosamente.
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
                            <th>Nombre Completo</th>
                            <th>Código</th>
                            <th>Correo Electrónico</th>
                            <th>Rol</th>
                            <th>Estado Actual</th>
                            <th>Fecha Registro</th>
                            <th class="pe-4 text-end">Modificar Estado</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${usuarios}" var="u">
                            <tr>
                                <td class="ps-4 fw-bold text-muted">#${u.idUsuario}</td>
                                <td class="fw-bold text-dark">${u.nombreCompleto}</td>
                                <td><span class="badge bg-light text-dark border">${u.codigoUniversitario}</span></td>
                                <td>${u.correo}</td>
                                <td>
                                    <span class="badge ${u.rol == 'ADMIN' ? 'bg-dark' : (u.rol == 'DOCENTE' ? 'bg-info text-dark' : 'bg-secondary')}">
                                        ${u.rol}
                                    </span>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${u.estado == 'ACTIVO'}">
                                            <span class="badge bg-success-subtle text-success border border-success-subtle"><i class="bi bi-check-circle me-1"></i> ACTIVO</span>
                                        </c:when>
                                        <c:when test="${u.estado == 'SANCIONADO'}">
                                            <span class="badge bg-danger-subtle text-danger border border-danger-subtle"><i class="bi bi-slash-circle me-1"></i> SANCIONADO</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-secondary-subtle text-secondary border border-secondary-subtle">INACTIVO</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td><small class="text-muted">${u.fechaRegistro}</small></td>
                                <td class="pe-4 text-end">
                                    <c:if test="${u.idUsuario != sessionScope.usuarioLogueado.idUsuario}">
                                        <form action="${pageContext.request.contextPath}/admin/usuarios" method="POST" class="d-inline-flex gap-1 align-items-center">
                                            <input type="hidden" name="idUsuario" value="${u.idUsuario}">
                                            <select name="estado" class="form-select form-select-sm" style="width: 140px;">
                                                <option value="ACTIVO" ${u.estado == 'ACTIVO' ? 'selected' : ''}>Activar</option>
                                                <option value="SANCIONADO" ${u.estado == 'SANCIONADO' ? 'selected' : ''}>Sancionar</option>
                                                <option value="INACTIVO" ${u.estado == 'INACTIVO' ? 'selected' : ''}>Inactivar</option>
                                            </select>
                                            <button type="submit" class="btn btn-sm btn-outline-primary">
                                                <i class="bi bi-save"></i>
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
