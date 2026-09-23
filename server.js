// =============================================================================
// BOOKHUB - SERVIDOR LOCAL AUTÓNOMO (SIMULADOR DE SERVLETS / JSP / MVC)
// Permite ejecutar y probar toda la aplicación web en vivo sin dependencias externas
// =============================================================================

const http = require('http');
const fs = require('fs');
const path = require('path');
const url = require('url');
const querystring = require('querystring');

const PORT = 8080;

// Base de datos en memoria sincronizada con database.sql
const db = {
    categorias: [
        { idCategoria: 1, nombre: 'Ingeniería de Software y Sistemas', descripcion: 'Libros de programación, arquitectura y bases de datos.' },
        { idCategoria: 2, nombre: 'Ciencias Básicas y Matemáticas', descripcion: 'Cálculo, álgebra lineal y física aplicadas.' },
        { idCategoria: 3, nombre: 'Inteligencia Artificial y Datos', descripcion: 'Machine Learning, Deep Learning y Data Science.' },
        { idCategoria: 4, nombre: 'Gestión de Proyectos y Negocios', descripcion: 'Metodologías ágiles, Scrum y liderazgo empresarial.' },
        { idCategoria: 5, nombre: 'Humanidades e Investigación', descripcion: 'Metodología de la investigación y ética.' }
    ],
    usuarios: [
        { idUsuario: 1, nombreCompleto: 'Mg. Carlos Mendoza (Bibliotecario)', codigoUniversitario: 'ADM-001', correo: 'admin@bookhub.edu', password: 'admin123', rol: 'ADMIN', estado: 'ACTIVO', fechaRegistro: '2026-01-10' },
        { idUsuario: 2, nombreCompleto: 'Juan Pérez Rodríguez', codigoUniversitario: 'U20210045', correo: 'juan.perez@bookhub.edu', password: 'user123', rol: 'ESTUDIANTE', estado: 'ACTIVO', fechaRegistro: '2026-02-15' },
        { idUsuario: 3, nombreCompleto: 'María García Salazar', codigoUniversitario: 'U20221478', correo: 'maria.garcia@bookhub.edu', password: 'user123', rol: 'ESTUDIANTE', estado: 'ACTIVO', fechaRegistro: '2026-03-01' },
        { idUsuario: 4, nombreCompleto: 'Dr. Roberto Fernández', codigoUniversitario: 'DOC-9921', correo: 'roberto.fernandez@bookhub.edu', password: 'doc123', rol: 'DOCENTE', estado: 'ACTIVO', fechaRegistro: '2026-03-05' }
    ],
    libros: [
        { idLibro: 1, idCategoria: 1, categoriaNombre: 'Ingeniería de Software y Sistemas', titulo: 'Clean Code: A Handbook of Agile Software Craftsmanship', autor: 'Robert C. Martin', editorial: 'Prentice Hall', anioPublicacion: 2008, isbn: '978-0132350884', stockTotal: 5, stockDisponible: 4, ubicacionFisica: 'Estante A-1, Nivel 1', portadaUrl: 'https://images.unsplash.com/photo-1532012164546-f432f2e3edd4?w=400', pdfUrl: 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf', estado: 'DISPONIBLE' },
        { idLibro: 2, idCategoria: 1, categoriaNombre: 'Ingeniería de Software y Sistemas', titulo: 'Java: The Complete Reference (12th Edition)', autor: 'Herbert Schildt', editorial: 'McGraw-Hill', anioPublicacion: 2021, isbn: '978-1260463415', stockTotal: 4, stockDisponible: 3, ubicacionFisica: 'Estante A-2, Nivel 1', portadaUrl: 'https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?w=400', pdfUrl: 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf', estado: 'DISPONIBLE' },
        { idLibro: 3, idCategoria: 1, categoriaNombre: 'Ingeniería de Software y Sistemas', titulo: 'Design Patterns: Elements of Reusable Object-Oriented Software', autor: 'Erich Gamma, Richard Helm, Ralph Johnson, John Vlissides', editorial: 'Addison-Wesley', anioPublicacion: 1994, isbn: '978-0201633610', stockTotal: 3, stockDisponible: 2, ubicacionFisica: 'Estante A-3, Nivel 1', portadaUrl: 'https://images.unsplash.com/photo-1512820790803-83ca734da794?w=400', pdfUrl: 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf', estado: 'DISPONIBLE' },
        { idLibro: 4, idCategoria: 3, categoriaNombre: 'Inteligencia Artificial y Datos', titulo: 'Hands-On Machine Learning with Scikit-Learn, Keras, and TensorFlow', autor: 'Aurélien Géron', editorial: 'O\'Reilly Media', anioPublicacion: 2019, isbn: '978-1492032649', stockTotal: 4, stockDisponible: 4, ubicacionFisica: 'Estante B-1, Nivel 2', portadaUrl: 'https://images.unsplash.com/photo-1526374965328-7f61d4dc18c5?w=400', pdfUrl: 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf', estado: 'DISPONIBLE' },
        { idLibro: 5, idCategoria: 2, categoriaNombre: 'Ciencias Básicas y Matemáticas', titulo: 'Cálculo de una Variable: Trascendentes Tempranas', autor: 'James Stewart', editorial: 'Cengage Learning', anioPublicacion: 2016, isbn: '978-6075220154', stockTotal: 6, stockDisponible: 5, ubicacionFisica: 'Estante C-1, Nivel 1', portadaUrl: 'https://images.unsplash.com/photo-1509228468518-180dd4864904?w=400', pdfUrl: 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf', estado: 'DISPONIBLE' },
        { idLibro: 6, idCategoria: 4, categoriaNombre: 'Gestión de Proyectos y Negocios', titulo: 'Scrum: The Art of Doing Twice the Work in Half the Time', autor: 'Jeff Sutherland', editorial: 'Crown Business', anioPublicacion: 2014, isbn: '978-0385346450', stockTotal: 3, stockDisponible: 3, ubicacionFisica: 'Estante D-2, Nivel 2', portadaUrl: 'https://images.unsplash.com/photo-1552664730-d307ca884978?w=400', pdfUrl: 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf', estado: 'DISPONIBLE' },
        { idLibro: 7, idCategoria: 5, categoriaNombre: 'Humanidades e Investigación', titulo: 'Metodología de la Investigación Científica', autor: 'Roberto Hernández-Sampieri', editorial: 'McGraw-Hill', anioPublicacion: 2018, isbn: '978-1456223960', stockTotal: 5, stockDisponible: 5, ubicacionFisica: 'Estante E-1, Nivel 3', portadaUrl: 'https://images.unsplash.com/photo-1497633762265-9d179a990aa6?w=400', pdfUrl: 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf', estado: 'DISPONIBLE' }
    ],
    prestamos: [
        { idPrestamo: 1, idUsuario: 2, usuarioNombre: 'Juan Pérez Rodríguez', usuarioCodigo: 'U20210045', idLibro: 1, libroTitulo: 'Clean Code: A Handbook of Agile Software Craftsmanship', libroIsbn: '978-0132350884', fechaSolicitud: '2026-09-15', fechaPrestamo: '2026-09-15', fechaLimite: '2026-09-22', fechaDevolucion: '2026-09-21', estado: 'DEVUELTO', observaciones: 'Devuelto en óptimas condiciones.' },
        { idPrestamo: 2, idUsuario: 2, usuarioNombre: 'Juan Pérez Rodríguez', usuarioCodigo: 'U20210045', idLibro: 2, libroTitulo: 'Java: The Complete Reference (12th Edition)', libroIsbn: '978-1260463415', fechaSolicitud: '2026-09-20', fechaPrestamo: '2026-09-20', fechaLimite: '2026-09-27', fechaDevolucion: null, estado: 'EN_PRESTAMO', observaciones: 'Préstamo vigente para estudio.' },
        { idPrestamo: 3, idUsuario: 3, usuarioNombre: 'María García Salazar', usuarioCodigo: 'U20221478', idLibro: 3, libroTitulo: 'Design Patterns: Elements of Reusable Object-Oriented Software', libroIsbn: '978-0201633610', fechaSolicitud: '2026-09-22', fechaPrestamo: '2026-09-22', fechaLimite: '2026-09-29', fechaDevolucion: null, estado: 'EN_PRESTAMO', observaciones: 'Préstamo regular.' },
        { idPrestamo: 4, idUsuario: 3, usuarioNombre: 'María García Salazar', usuarioCodigo: 'U20221478', idLibro: 5, libroTitulo: 'Cálculo de una Variable: Trascendentes Tempranas', libroIsbn: '978-6075220154', fechaSolicitud: '2026-09-23', fechaPrestamo: null, fechaLimite: '2026-09-30', fechaDevolucion: null, estado: 'SOLICITADO', observaciones: 'Pendiente de entrega en mostrador.' }
    ]
};

// Sesión simple simulada por Cookie
const sessions = {};

function getSession(req) {
    const cookieHeader = req.headers.cookie;
    if (cookieHeader) {
        const match = cookieHeader.match(/BH_SESSION=([^;]+)/);
        if (match && sessions[match[1]]) {
            return { id: match[1], user: sessions[match[1]] };
        }
    }
    return null;
}

function setSession(res, user) {
    const sessId = 'sess_' + Math.random().toString(36).substring(2) + Date.now();
    sessions[sessId] = user;
    res.setHeader('Set-Cookie', `BH_SESSION=${sessId}; Path=/; HttpOnly`);
}

function clearSession(req, res) {
    const cookieHeader = req.headers.cookie;
    if (cookieHeader) {
        const match = cookieHeader.match(/BH_SESSION=([^;]+)/);
        if (match && sessions[match[1]]) {
            delete sessions[match[1]];
        }
    }
    res.setHeader('Set-Cookie', 'BH_SESSION=; Path=/; Expires=Thu, 01 Jan 1970 00:00:00 GMT');
}

// Renderizado de Plantillas HTML / Bootstrap
function renderLayout(title, content, user, activePage = '') {
    return `<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${title} | BookHub</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.2/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        :root {
            --bh-primary: #1e3a8a;
            --bh-primary-dark: #172554;
            --bh-secondary: #0d9488;
            --bh-accent: #f59e0b;
            --bh-bg-light: #f8fafc;
        }
        body {
            background-color: var(--bh-bg-light);
            font-family: 'Plus Jakarta Sans', system-ui, -apple-system, sans-serif;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }
        main { flex: 1 0 auto; }
        .navbar-bookhub {
            background: linear-gradient(135deg, var(--bh-primary-dark) 0%, var(--bh-primary) 100%);
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
        }
        .hero-banner {
            background: linear-gradient(135deg, #1e3a8a 0%, #2563eb 100%);
            color: #ffffff;
            border-radius: 1.25rem;
            box-shadow: 0 10px 25px rgba(30, 58, 138, 0.15);
        }
        .book-card {
            border: none;
            border-radius: 1rem;
            background: #ffffff;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.04);
            transition: transform 0.2s ease, box-shadow 0.2s ease;
            overflow: hidden;
            display: flex;
            flex-direction: column;
        }
        .book-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 12px 24px rgba(0, 0, 0, 0.1);
        }
        .book-card-img-wrapper {
            height: 200px;
            background-color: #e2e8f0;
            overflow: hidden;
            position: relative;
        }
        .book-card-img-wrapper img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        .badge-stock {
            position: absolute;
            top: 12px;
            right: 12px;
            padding: 0.35rem 0.75rem;
            font-size: 0.75rem;
            font-weight: 600;
            border-radius: 20px;
        }
        .badge-stock.available { background-color: rgba(16, 185, 129, 0.95); color: #fff; }
        .badge-stock.unavailable { background-color: rgba(239, 68, 68, 0.95); color: #fff; }
        .stat-card {
            border-radius: 1rem;
            border: none;
            padding: 1.5rem;
            background: #ffffff;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.04);
            display: flex;
            align-items: center;
        }
        .stat-icon {
            width: 56px;
            height: 56px;
            border-radius: 14px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.6rem;
            margin-right: 1.25rem;
        }
        .stat-icon.books { background-color: #e0e7ff; color: #4338ca; }
        .stat-icon.loans { background-color: #fef3c7; color: #d97706; }
        .stat-icon.users { background-color: #d1fae5; color: #059669; }
        .footer-bookhub {
            background-color: #0f172a;
            color: #94a3b8;
            padding: 2.5rem 0;
            margin-top: 4rem;
        }
    </style>
</head>
<body>
<nav class="navbar navbar-expand-lg navbar-dark navbar-bookhub sticky-top">
    <div class="container">
        <a class="navbar-brand d-flex align-items-center fw-bold" href="/catalogo">
            <i class="bi bi-book-half me-2 text-warning fs-4"></i>
            <span>BOOK<span class="text-warning">HUB</span></span>
        </a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#nav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="nav">
            <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                <li class="nav-item"><a class="nav-link ${activePage==='catalogo'?'active text-warning':''}" href="/catalogo"><i class="bi bi-grid-fill me-1"></i> Catálogo</a></li>
                <li class="nav-item"><a class="nav-link ${activePage==='digital'?'active text-warning':''}" href="/recursos-digitales"><i class="bi bi-file-earmark-pdf-fill me-1"></i> Recursos Digitales</a></li>
                ${user && user.rol !== 'ADMIN' ? `<li class="nav-item"><a class="nav-link ${activePage==='prestamos'?'active text-warning':''}" href="/mis-prestamos"><i class="bi bi-clock-history me-1"></i> Mis Préstamos</a></li>` : ''}
                ${user && user.rol === 'ADMIN' ? `
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle text-warning" href="#" id="adminDrop" data-bs-toggle="dropdown"><i class="bi bi-shield-lock-fill me-1"></i> Panel Admin</a>
                    <ul class="dropdown-menu dropdown-menu-dark">
                        <li><a class="dropdown-item" href="/admin/dashboard"><i class="bi bi-speedometer2 me-2"></i>Dashboard</a></li>
                        <li><a class="dropdown-item" href="/admin/libros"><i class="bi bi-journals me-2"></i>Gestión de Libros (CRUD)</a></li>
                        <li><a class="dropdown-item" href="/admin/prestamos"><i class="bi bi-arrow-left-right me-2"></i>Control de Préstamos</a></li>
                        <li><a class="dropdown-item" href="/admin/usuarios"><i class="bi bi-people-fill me-2"></i>Gestión de Usuarios</a></li>
                    </ul>
                </li>` : ''}
            </ul>
            <div class="d-flex align-items-center">
                ${user ? `
                <div class="dropdown">
                    <button class="btn btn-outline-light dropdown-toggle d-flex align-items-center" type="button" data-bs-toggle="dropdown">
                        <i class="bi bi-person-circle fs-5 me-2"></i> <span>${user.nombreCompleto}</span>
                    </button>
                    <ul class="dropdown-menu dropdown-menu-end shadow">
                        <li class="dropdown-header"><small class="text-muted">Rol: ${user.rol}</small><br><strong>${user.codigoUniversitario}</strong></li>
                        <li><hr class="dropdown-divider"></li>
                        ${user.rol === 'ADMIN' ? `<li><a class="dropdown-item" href="/admin/dashboard"><i class="bi bi-speedometer2 me-2"></i>Dashboard Admin</a></li>` : `<li><a class="dropdown-item" href="/mis-prestamos"><i class="bi bi-journal-bookmark me-2"></i>Mis Préstamos</a></li>`}
                        <li><hr class="dropdown-divider"></li>
                        <li><a class="dropdown-item text-danger" href="/logout"><i class="bi bi-box-arrow-right me-2"></i>Cerrar Sesión</a></li>
                    </ul>
                </div>` : `
                <a href="/login" class="btn btn-outline-light me-2"><i class="bi bi-box-arrow-in-right me-1"></i> Ingresar</a>
                <a href="/registro" class="btn btn-warning fw-semibold">Registrarse</a>`}
            </div>
        </div>
    </div>
</nav>

<main class="py-4">
    ${content}
</main>

<footer class="footer-bookhub">
    <div class="container">
        <div class="row gy-4">
            <div class="col-lg-5 col-md-6">
                <h5 class="text-white d-flex align-items-center mb-3"><i class="bi bi-book-half text-warning me-2"></i> BookHub</h5>
                <p class="small text-secondary">Sistema de Gestión de Biblioteca Universitaria y Digital. Desarrollado con arquitectura Java Web (Servlets, JSP, JavaBeans, DAO y Bootstrap).</p>
            </div>
            <div class="col-lg-3 col-md-6">
                <h6 class="text-white mb-3">Enlaces Rápidos</h6>
                <ul class="list-unstyled small d-flex flex-column gap-2">
                    <li><a href="/catalogo" class="text-secondary text-decoration-none">Catálogo General</a></li>
                    <li><a href="/recursos-digitales" class="text-secondary text-decoration-none">Repositorio Digital</a></li>
                    <li><a href="/mis-prestamos" class="text-secondary text-decoration-none">Mis Solicitudes</a></li>
                </ul>
            </div>
            <div class="col-lg-4 col-md-12">
                <h6 class="text-white mb-3">Atención al Usuario</h6>
                <p class="small text-secondary mb-1"><i class="bi bi-geo-alt-fill text-warning me-2"></i> Campus Universitario - Edificio Central</p>
                <p class="small text-secondary mb-1"><i class="bi bi-clock-fill text-warning me-2"></i> Lun - Vie: 08:00 AM - 08:00 PM</p>
                <p class="small text-secondary"><i class="bi bi-envelope-at-fill text-warning me-2"></i> biblioteca@universidad.edu</p>
            </div>
        </div>
        <hr class="border-secondary my-4">
        <div class="d-flex flex-column flex-sm-row justify-content-between small text-secondary">
            <span>&copy; 2026 BookHub - Todos los derechos reservados.</span>
            <span>Rúbrica Java Web MVC</span>
        </div>
    </div>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
    document.addEventListener('DOMContentLoaded', () => {
        const editModal = document.getElementById('modalEditarLibro');
        if (editModal) {
            editModal.addEventListener('show.bs.modal', (event) => {
                const btn = event.relatedTarget;
                document.getElementById('editIdLibro').value = btn.getAttribute('data-id');
                document.getElementById('editTitulo').value = btn.getAttribute('data-titulo');
                document.getElementById('editAutor').value = btn.getAttribute('data-autor');
                document.getElementById('editEditorial').value = btn.getAttribute('data-editorial') || '';
                document.getElementById('editAnio').value = btn.getAttribute('data-anio') || '';
                document.getElementById('editIsbn').value = btn.getAttribute('data-isbn') || '';
                document.getElementById('editCategoria').value = btn.getAttribute('data-categoria');
                document.getElementById('editStockTotal').value = btn.getAttribute('data-stock-total');
                document.getElementById('editStockDisponible').value = btn.getAttribute('data-stock-disp');
                document.getElementById('editUbicacion').value = btn.getAttribute('data-ubicacion') || '';
                document.getElementById('editPortada').value = btn.getAttribute('data-portada') || '';
                document.getElementById('editPdf').value = btn.getAttribute('data-pdf') || '';
            });
        }
        const loanModal = document.getElementById('modalSolicitarPrestamo');
        if (loanModal) {
            loanModal.addEventListener('show.bs.modal', (event) => {
                const btn = event.relatedTarget;
                document.getElementById('prestamoIdLibro').value = btn.getAttribute('data-id');
                document.getElementById('prestamoTituloLibro').textContent = btn.getAttribute('data-titulo');
                document.getElementById('prestamoAutorLibro').textContent = btn.getAttribute('data-autor');
                document.getElementById('prestamoUbicacion').textContent = btn.getAttribute('data-ubicacion');
            });
        }
    });
</script>
</body>
</html>`;
}

// Servidor HTTP
const server = http.createServer((req, res) => {
    const parsedUrl = url.parse(req.url, true);
    const pathname = parsedUrl.pathname;
    const session = getSession(req);
    const user = session ? session.user : null;

    // Métodos POST
    if (req.method === 'POST') {
        let body = '';
        req.on('data', chunk => { body += chunk.toString(); });
        req.on('end', () => {
            const params = querystring.parse(body);

            // 1. Iniciar Sesión
            if (pathname === '/login') {
                const u = db.usuarios.find(x => x.correo.toLowerCase() === (params.correo || '').trim().toLowerCase() && x.password === params.password);
                if (u) {
                    if (u.estado === 'SANCIONADO') {
                        res.writeHead(302, { Location: '/login?error=sancionado' });
                        return res.end();
                    }
                    setSession(res, u);
                    res.writeHead(302, { Location: u.rol === 'ADMIN' ? '/admin/dashboard' : '/catalogo' });
                    return res.end();
                } else {
                    res.writeHead(302, { Location: '/login?error=credenciales_invalidas' });
                    return res.end();
                }
            }

            // 2. Registro de Usuario
            if (pathname === '/registro') {
                const nuevo = {
                    idUsuario: db.usuarios.length + 1,
                    nombreCompleto: params.nombreCompleto,
                    codigoUniversitario: params.codigoUniversitario,
                    correo: params.correo,
                    password: params.password,
                    rol: params.rol || 'ESTUDIANTE',
                    estado: 'ACTIVO',
                    fechaRegistro: new Date().toISOString().split('T')[0]
                };
                db.usuarios.push(nuevo);
                res.writeHead(302, { Location: '/login?msg=registrado_ok' });
                return res.end();
            }

            // 3. Solicitar Préstamo
            if (pathname === '/solicitar-prestamo') {
                if (!user) {
                    res.writeHead(302, { Location: '/login?msg=requiere_login' });
                    return res.end();
                }
                const idLibro = parseInt(params.idLibro);
                const dias = parseInt(params.dias || '7');
                const libro = db.libros.find(l => l.idLibro === idLibro);

                if (libro && libro.stockDisponible > 0) {
                    libro.stockDisponible -= 1;
                    const hoy = new Date();
                    const limite = new Date();
                    limite.setDate(hoy.getDate() + dias);

                    db.prestamos.unshift({
                        idPrestamo: db.prestamos.length + 1,
                        idUsuario: user.idUsuario,
                        usuarioNombre: user.nombreCompleto,
                        usuarioCodigo: user.codigoUniversitario,
                        idLibro: libro.idLibro,
                        libroTitulo: libro.titulo,
                        libroIsbn: libro.isbn,
                        fechaSolicitud: hoy.toISOString().split('T')[0],
                        fechaPrestamo: null,
                        fechaLimite: limite.toISOString().split('T')[0],
                        fechaDevolucion: null,
                        estado: 'SOLICITADO',
                        observaciones: 'Solicitud realizada desde la plataforma web'
                    });
                    res.writeHead(302, { Location: '/mis-prestamos?msg=solicitud_ok' });
                } else {
                    res.writeHead(302, { Location: '/catalogo?error=sin_stock' });
                }
                return res.end();
            }

            // 4. Admin CRUD Libros
            if (pathname === '/admin/libros') {
                if (!user || user.rol !== 'ADMIN') {
                    res.writeHead(302, { Location: '/login?error=no_autorizado' });
                    return res.end();
                }
                const action = params.action;
                if (action === 'crear') {
                    const cat = db.categorias.find(c => c.idCategoria === parseInt(params.idCategoria));
                    const nuevoLibro = {
                        idLibro: db.libros.length + 1,
                        idCategoria: parseInt(params.idCategoria),
                        categoriaNombre: cat ? cat.nombre : 'General',
                        titulo: params.titulo,
                        autor: params.autor,
                        editorial: params.editorial,
                        anioPublicacion: parseInt(params.anioPublicacion || '2024'),
                        isbn: params.isbn,
                        stockTotal: parseInt(params.stockTotal || '1'),
                        stockDisponible: parseInt(params.stockTotal || '1'),
                        ubicacionFisica: params.ubicacionFisica,
                        portadaUrl: params.portadaUrl,
                        pdfUrl: params.pdfUrl,
                        estado: 'DISPONIBLE'
                    };
                    db.libros.unshift(nuevoLibro);
                    res.writeHead(302, { Location: '/admin/libros?msg=creado_ok' });
                    return res.end();
                } else if (action === 'actualizar') {
                    const idLibro = parseInt(params.idLibro);
                    const l = db.libros.find(x => x.idLibro === idLibro);
                    if (l) {
                        const cat = db.categorias.find(c => c.idCategoria === parseInt(params.idCategoria));
                        l.idCategoria = parseInt(params.idCategoria);
                        l.categoriaNombre = cat ? cat.nombre : l.categoriaNombre;
                        l.titulo = params.titulo;
                        l.autor = params.autor;
                        l.editorial = params.editorial;
                        l.anioPublicacion = parseInt(params.anioPublicacion);
                        l.isbn = params.isbn;
                        l.stockTotal = parseInt(params.stockTotal);
                        l.stockDisponible = parseInt(params.stockDisponible);
                        l.ubicacionFisica = params.ubicacionFisica;
                        l.portadaUrl = params.portadaUrl;
                        l.pdfUrl = params.pdfUrl;
                    }
                    res.writeHead(302, { Location: '/admin/libros?msg=actualizado_ok' });
                    return res.end();
                } else if (action === 'eliminar') {
                    const idLibro = parseInt(params.idLibro);
                    const idx = db.libros.findIndex(x => x.idLibro === idLibro);
                    if (idx !== -1) db.libros.splice(idx, 1);
                    res.writeHead(302, { Location: '/admin/libros?msg=eliminado_ok' });
                    return res.end();
                }
            }

            // 5. Admin Préstamos (Aprobar / Devolver)
            if (pathname === '/admin/prestamos') {
                if (!user || user.rol !== 'ADMIN') {
                    res.writeHead(302, { Location: '/login?error=no_autorizado' });
                    return res.end();
                }
                const action = params.action;
                const idPrestamo = parseInt(params.idPrestamo);
                const p = db.prestamos.find(x => x.idPrestamo === idPrestamo);

                if (p) {
                    if (action === 'aprobar') {
                        p.estado = 'EN_PRESTAMO';
                        p.fechaPrestamo = new Date().toISOString().split('T')[0];
                        res.writeHead(302, { Location: '/admin/prestamos?msg=aprobado_ok' });
                        return res.end();
                    } else if (action === 'devolver') {
                        p.estado = 'DEVUELTO';
                        p.fechaDevolucion = new Date().toISOString().split('T')[0];
                        const l = db.libros.find(x => x.idLibro === p.idLibro);
                        if (l) l.stockDisponible += 1;
                        res.writeHead(302, { Location: '/admin/prestamos?msg=devolucion_ok' });
                        return res.end();
                    }
                }
            }

            // 6. Admin Usuarios (Cambiar Estado)
            if (pathname === '/admin/usuarios') {
                if (!user || user.rol !== 'ADMIN') {
                    res.writeHead(302, { Location: '/login?error=no_autorizado' });
                    return res.end();
                }
                const idUsuario = parseInt(params.idUsuario);
                const u = db.usuarios.find(x => x.idUsuario === idUsuario);
                if (u && params.estado) {
                    u.estado = params.estado;
                }
                res.writeHead(302, { Location: '/admin/usuarios?msg=actualizado_ok' });
                return res.end();
            }
        });
        return;
    }

    // Métodos GET
    if (pathname === '/' || pathname === '/index.jsp') {
        res.writeHead(302, { Location: '/catalogo' });
        return res.end();
    }

    if (pathname === '/logout') {
        clearSession(req, res);
        res.writeHead(302, { Location: '/login?msg=sesion_cerrada' });
        return res.end();
    }

    // VISTA: LOGIN
    if (pathname === '/login') {
        const error = parsedUrl.query.error === 'credenciales_invalidas' ? 'Credenciales incorrectas.' : (parsedUrl.query.error === 'sancionado' ? 'Cuenta con sanción activa.' : '');
        const msg = parsedUrl.query.msg === 'registrado_ok' ? '¡Registro exitoso! Ya puedes iniciar sesión.' : (parsedUrl.query.msg === 'requiere_login' ? 'Debes iniciar sesión para solicitar libros.' : '');

        const html = `
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
                                <p class="text-muted small">Ingresa con tus credenciales de BookHub</p>
                            </div>

                            ${error ? `<div class="alert alert-danger py-2 small"><i class="bi bi-exclamation-triangle-fill me-1"></i> ${error}</div>` : ''}
                            ${msg ? `<div class="alert alert-success py-2 small"><i class="bi bi-check-circle-fill me-1"></i> ${msg}</div>` : ''}

                            <form action="/login" method="POST">
                                <div class="mb-3">
                                    <label class="form-label fw-semibold small text-muted">Correo Institucional</label>
                                    <input type="email" name="correo" class="form-control" placeholder="admin@bookhub.edu o juan.perez@bookhub.edu" required autofocus>
                                </div>
                                <div class="mb-4">
                                    <label class="form-label fw-semibold small text-muted">Contraseña</label>
                                    <input type="password" name="password" class="form-control" placeholder="••••••••" required>
                                </div>
                                <button type="submit" class="btn btn-primary w-100 py-2 fw-semibold mb-3">
                                    <i class="bi bi-box-arrow-in-right me-1"></i> Ingresar al Sistema
                                </button>
                            </form>

                            <div class="card bg-light border-0 p-3 rounded-3 mb-3">
                                <span class="fw-bold text-dark small mb-1"><i class="bi bi-info-circle me-1 text-primary"></i> Credenciales de Prueba:</span>
                                <div class="small text-muted">
                                    <div><strong>Admin:</strong> <code>admin@bookhub.edu</code> / <code>admin123</code></div>
                                    <div><strong>Estudiante:</strong> <code>juan.perez@bookhub.edu</code> / <code>user123</code></div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>`;
        res.writeHead(200, { 'Content-Type': 'text/html; charset=utf-8' });
        return res.end(renderLayout('Iniciar Sesión', html, user));
    }

    // VISTA: REGISTRO
    if (pathname === '/registro') {
        const html = `
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
                                <p class="text-muted small">Crea tu cuenta institucional en BookHub</p>
                            </div>
                            <form action="/registro" method="POST">
                                <div class="mb-3">
                                    <label class="form-label fw-semibold small text-muted">Nombre Completo</label>
                                    <input type="text" name="nombreCompleto" class="form-control" required placeholder="Ej. Ana Lucía Morales">
                                </div>
                                <div class="row g-2 mb-3">
                                    <div class="col-md-6">
                                        <label class="form-label fw-semibold small text-muted">Código Universitario</label>
                                        <input type="text" name="codigoUniversitario" class="form-control" required placeholder="Ej. U20241050">
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label fw-semibold small text-muted">Rol</label>
                                        <select name="rol" class="form-select">
                                            <option value="ESTUDIANTE" selected>Estudiante</option>
                                            <option value="DOCENTE">Docente</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label fw-semibold small text-muted">Correo Institucional</label>
                                    <input type="email" name="correo" class="form-control" required placeholder="usuario@bookhub.edu">
                                </div>
                                <div class="mb-4">
                                    <label class="form-label fw-semibold small text-muted">Contraseña</label>
                                    <input type="password" name="password" class="form-control" required minlength="4">
                                </div>
                                <button type="submit" class="btn btn-warning text-dark w-100 py-2 fw-bold shadow-sm mb-3">Completar Registro</button>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>`;
        res.writeHead(200, { 'Content-Type': 'text/html; charset=utf-8' });
        return res.end(renderLayout('Registro', html, user));
    }

    // VISTA: CATÁLOGO
    if (pathname === '/catalogo') {
        const query = (parsedUrl.query.q || '').trim().toLowerCase();
        const catId = parseInt(parsedUrl.query.categoria || '0');

        let filtered = db.libros.filter(l => {
            const matchesQuery = !query || l.titulo.toLowerCase().includes(query) || l.autor.toLowerCase().includes(query) || l.isbn.includes(query);
            const matchesCat = !catId || l.idCategoria === catId;
            return matchesQuery && matchesCat;
        });

        const catOptions = db.categorias.map(c => `<option value="${c.idCategoria}" ${catId===c.idCategoria?'selected':''}>${c.nombre}</option>`).join('');

        const cardsHtml = filtered.map(l => `
            <div class="col-sm-6 col-md-4 col-lg-3">
                <div class="card book-card h-100">
                    <div class="book-card-img-wrapper">
                        <img src="${l.portadaUrl || 'https://images.unsplash.com/photo-1532012164546-f432f2e3edd4?w=400'}" alt="${l.titulo}">
                        <span class="badge-stock ${l.stockDisponible > 0 ? 'available' : 'unavailable'}">
                            <i class="bi ${l.stockDisponible > 0 ? 'bi-check-circle-fill' : 'bi-x-circle-fill'} me-1"></i> ${l.stockDisponible > 0 ? `${l.stockDisponible} Disp.` : 'Agotado'}
                        </span>
                    </div>
                    <div class="card-body d-flex flex-column p-3">
                        <span class="badge bg-light text-primary text-truncate mb-2 align-self-start border">${l.categoriaNombre}</span>
                        <h6 class="card-title fw-bold mb-1 text-truncate" title="${l.titulo}">${l.titulo}</h6>
                        <p class="card-text text-muted small mb-2"><i class="bi bi-pen me-1"></i> ${l.autor}</p>
                        <div class="small text-secondary mb-3 mt-auto">
                            <div><i class="bi bi-geo-alt me-1 text-danger"></i> <strong>${l.ubicacionFisica}</strong></div>
                            <div><i class="bi bi-upc-scan me-1"></i> ISBN: ${l.isbn}</div>
                        </div>
                        <div class="d-grid gap-2">
                            <a href="/libro-detalle?id=${l.idLibro}" class="btn btn-outline-primary btn-sm fw-semibold">
                                <i class="bi bi-eye me-1"></i> Ver Detalles
                            </a>
                            ${l.stockDisponible > 0 ? `
                            <button type="button" class="btn btn-warning btn-sm fw-bold text-dark"
                                    data-bs-toggle="modal" data-bs-target="#modalSolicitarPrestamo"
                                    data-id="${l.idLibro}" data-titulo="${l.titulo}"
                                    data-autor="${l.autor}" data-ubicacion="${l.ubicacionFisica}">
                                <i class="bi bi-bookmark-plus-fill me-1"></i> Solicitar Préstamo
                            </button>` : ''}
                        </div>
                    </div>
                </div>
            </div>
        `).join('');

        const html = `
        <div class="container">
            <div class="hero-banner p-4 p-md-5 text-white mb-4">
                <div class="row align-items-center">
                    <div class="col-lg-8">
                        <span class="badge bg-warning text-dark px-3 py-2 rounded-pill fw-bold mb-3"><i class="bi bi-stars me-1"></i> Biblioteca Universitaria & Digital</span>
                        <h1 class="display-5 fw-bold mb-3">Explora el Conocimiento en BookHub</h1>
                        <p class="lead mb-4 text-light opacity-90">Accede a títulos físicos para préstamo en campus y descarga recursos académicos en formato PDF libre.</p>
                        <form action="/catalogo" method="GET" class="row g-2">
                            <div class="col-md-7">
                                <input type="text" name="q" value="${parsedUrl.query.q || ''}" class="form-control form-control-lg border-0" placeholder="Buscar por título, autor o ISBN...">
                            </div>
                            <div class="col-md-3">
                                <select name="categoria" class="form-select form-select-lg border-0">
                                    <option value="0">Todas las Áreas</option>
                                    ${catOptions}
                                </select>
                            </div>
                            <div class="col-md-2">
                                <button type="submit" class="btn btn-warning btn-lg w-100 fw-bold">Buscar</button>
                            </div>
                        </form>
                    </div>
                    <div class="col-lg-4 d-none d-lg-block text-center">
                        <i class="bi bi-journal-bookmark-fill" style="font-size: 8rem; opacity: 0.9;"></i>
                    </div>
                </div>
            </div>

            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h4 class="fw-bold mb-1">Catálogo de Libros</h4>
                    <p class="text-muted small mb-0">Mostrando <strong>${filtered.length}</strong> títulos encontrados</p>
                </div>
            </div>

            <div class="row g-4">${cardsHtml}</div>
        </div>

        <div class="modal fade" id="modalSolicitarPrestamo" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content border-0 shadow-lg rounded-4">
                    <div class="modal-header bg-primary text-white">
                        <h5 class="modal-title fw-bold"><i class="bi bi-bookmark-check-fill me-2"></i> Solicitar Préstamo</h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                    </div>
                    <form action="/solicitar-prestamo" method="POST">
                        <input type="hidden" name="idLibro" id="prestamoIdLibro">
                        <div class="modal-body p-4">
                            <div class="alert alert-info py-2 small mb-3">
                                <i class="bi bi-info-circle-fill me-1"></i> Retira tu libro físico en el mostrador del campus presentando tu carnet institucional.
                            </div>
                            <h6 class="fw-bold text-primary mb-1" id="prestamoTituloLibro">Título</h6>
                            <p class="text-muted small mb-2" id="prestamoAutorLibro">Autor</p>
                            <p class="small text-secondary mb-3"><strong>Ubicación:</strong> <span id="prestamoUbicacion"></span></p>
                            <div class="mb-3">
                                <label class="form-label fw-semibold small text-muted">Duración del Préstamo</label>
                                <select name="dias" class="form-select">
                                    <option value="3">3 Días (Lectura Rápida)</option>
                                    <option value="7" selected>7 Días (Estándar)</option>
                                    <option value="14">14 Días (Investigación)</option>
                                </select>
                            </div>
                        </div>
                        <div class="modal-footer bg-light">
                            <button type="button" class="btn btn-secondary btn-sm" data-bs-dismiss="modal">Cancelar</button>
                            <button type="submit" class="btn btn-primary btn-sm fw-semibold">Confirmar Solicitud</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>`;
        res.writeHead(200, { 'Content-Type': 'text/html; charset=utf-8' });
        return res.end(renderLayout('Catálogo', html, user, 'catalogo'));
    }

    // VISTA: DETALLE LIBRO
    if (pathname === '/libro-detalle') {
        const idLibro = parseInt(parsedUrl.query.id);
        const libro = db.libros.find(l => l.idLibro === idLibro);
        if (!libro) {
            res.writeHead(302, { Location: '/catalogo' });
            return res.end();
        }

        const html = `
        <div class="container py-4">
            <nav aria-label="breadcrumb" class="mb-4">
                <ol class="breadcrumb">
                    <li class="breadcrumb-item"><a href="/catalogo" class="text-decoration-none">Catálogo</a></li>
                    <li class="breadcrumb-item active">${libro.titulo}</li>
                </ol>
            </nav>
            <div class="card border-0 shadow-sm rounded-4 overflow-hidden">
                <div class="row g-0">
                    <div class="col-md-4 bg-light text-center p-4 d-flex align-items-center justify-content-center">
                        <img src="${libro.portadaUrl}" alt="${libro.titulo}" class="img-fluid rounded-3 shadow" style="max-height: 380px; object-fit: cover;">
                    </div>
                    <div class="col-md-8 p-4 p-lg-5 d-flex flex-column justify-content-between">
                        <div>
                            <span class="badge bg-primary-subtle text-primary border px-3 py-2 rounded-pill fw-semibold mb-3">${libro.categoriaNombre}</span>
                            <h2 class="fw-bold text-dark mb-2">${libro.titulo}</h2>
                            <h5 class="text-muted fw-normal mb-4"><i class="bi bi-person me-1"></i> ${libro.autor}</h5>
                            <div class="row g-3 mb-4">
                                <div class="col-sm-6"><div class="p-3 bg-light rounded-3"><small class="text-muted d-block">Editorial y Año</small><strong>${libro.editorial} (${libro.anioPublicacion})</strong></div></div>
                                <div class="col-sm-6"><div class="p-3 bg-light rounded-3"><small class="text-muted d-block">ISBN</small><strong>${libro.isbn}</strong></div></div>
                                <div class="col-sm-6"><div class="p-3 bg-light rounded-3"><small class="text-muted d-block">Ubicación Física</small><strong><i class="bi bi-geo-alt-fill text-danger me-1"></i> ${libro.ubicacionFisica}</strong></div></div>
                                <div class="col-sm-6"><div class="p-3 bg-light rounded-3"><small class="text-muted d-block">Disponibilidad</small><strong class="${libro.stockDisponible>0?'text-success':'text-danger'}">${libro.stockDisponible} de ${libro.stockTotal} disponibles</strong></div></div>
                            </div>
                        </div>
                        <div class="d-flex flex-wrap gap-3 pt-3 border-top">
                            ${libro.stockDisponible > 0 ? `
                            <form action="/solicitar-prestamo" method="POST" class="d-inline">
                                <input type="hidden" name="idLibro" value="${libro.idLibro}">
                                <button type="submit" class="btn btn-warning text-dark fw-bold px-4 py-2 shadow-sm"><i class="bi bi-bookmark-plus-fill me-2"></i> Solicitar Préstamo Físico (7 días)</button>
                            </form>` : ''}
                            ${libro.pdfUrl ? `<a href="${libro.pdfUrl}" target="_blank" class="btn btn-primary fw-semibold px-4 py-2"><i class="bi bi-file-earmark-arrow-down-fill me-2"></i> Descargar PDF</a>` : ''}
                            <a href="/catalogo" class="btn btn-outline-secondary px-4 py-2"><i class="bi bi-arrow-left me-1"></i> Volver</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>`;
        res.writeHead(200, { 'Content-Type': 'text/html; charset=utf-8' });
        return res.end(renderLayout(libro.titulo, html, user));
    }

    // VISTA: RECURSOS DIGITALES
    if (pathname === '/recursos-digitales') {
        const recursos = db.libros.filter(l => l.pdfUrl);
        const cards = recursos.map(r => `
            <div class="col-md-6 col-lg-4">
                <div class="card h-100 border-0 shadow-sm rounded-4 p-3 d-flex flex-column justify-content-between">
                    <div>
                        <span class="badge bg-secondary-subtle text-secondary mb-2">${r.categoriaNombre}</span>
                        <h5 class="fw-bold text-dark mb-1 text-truncate">${r.titulo}</h5>
                        <p class="text-muted small mb-3"><i class="bi bi-person me-1"></i> ${r.autor} (${r.anioPublicacion})</p>
                        <p class="small text-secondary mb-3"><strong>Editorial:</strong> ${r.editorial}<br><strong>ISBN:</strong> ${r.isbn}</p>
                    </div>
                    <div class="pt-3 border-top d-flex gap-2">
                        <a href="${r.pdfUrl}" target="_blank" class="btn btn-primary btn-sm w-100 fw-semibold"><i class="bi bi-download me-1"></i> Descargar PDF</a>
                        <a href="/libro-detalle?id=${r.idLibro}" class="btn btn-outline-secondary btn-sm"><i class="bi bi-info-circle"></i></a>
                    </div>
                </div>
            </div>
        `).join('');

        const html = `
        <div class="container py-4">
            <div class="p-4 mb-4 bg-light rounded-4 border d-flex align-items-center">
                <div class="bg-primary text-white p-3 rounded-circle me-3"><i class="bi bi-file-earmark-pdf-fill fs-2"></i></div>
                <div>
                    <h3 class="fw-bold mb-1">Repositorio de Recursos Digitales</h3>
                    <p class="text-muted mb-0">Acceso libre e inmediato a libros y artículos académicos en formato PDF.</p>
                </div>
            </div>
            <div class="row g-4">${cards}</div>
        </div>`;
        res.writeHead(200, { 'Content-Type': 'text/html; charset=utf-8' });
        return res.end(renderLayout('Recursos Digitales', html, user, 'digital'));
    }

    // VISTA: MIS PRÉSTAMOS
    if (pathname === '/mis-prestamos') {
        if (!user) {
            res.writeHead(302, { Location: '/login?msg=requiere_login' });
            return res.end();
        }
        const misP = db.prestamos.filter(p => p.idUsuario === user.idUsuario);
        const rows = misP.map(p => `
            <tr>
                <td class="ps-4 fw-bold text-muted">#P-${p.idPrestamo}</td>
                <td><div class="fw-bold text-dark">${p.libroTitulo}</div><small class="text-muted">ISBN: ${p.libroIsbn}</small></td>
                <td><span class="badge bg-light text-dark border">${p.fechaSolicitud}</span></td>
                <td>${p.fechaPrestamo || '<em class="text-muted">Pendiente entrega</em>'}</td>
                <td><strong class="text-primary">${p.fechaLimite}</strong></td>
                <td>
                    <span class="badge ${p.estado==='SOLICITADO'?'bg-warning text-dark':(p.estado==='EN_PRESTAMO'?'bg-primary':'bg-success')}">
                        ${p.estado}
                    </span>
                </td>
                <td class="pe-4 small text-muted">${p.observaciones}</td>
            </tr>
        `).join('');

        const html = `
        <div class="container py-4">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h3 class="fw-bold mb-1"><i class="bi bi-journal-bookmark-fill text-primary me-2"></i> Mis Préstamos</h3>
                    <p class="text-muted small mb-0">Consulta tus préstamos activos y fechas límites de devolución.</p>
                </div>
                <a href="/catalogo" class="btn btn-outline-primary btn-sm"><i class="bi bi-plus-circle me-1"></i> Explorar Catálogo</a>
            </div>
            ${parsedUrl.query.msg === 'solicitud_ok' ? '<div class="alert alert-success py-2 small mb-3"><i class="bi bi-check-circle-fill me-1"></i> ¡Solicitud de préstamo registrada exitosamente!</div>' : ''}
            <div class="card border-0 shadow-sm rounded-4 overflow-hidden">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-light"><tr><th class="ps-4">ID</th><th>Libro</th><th>F. Solicitud</th><th>F. Préstamo</th><th>F. Límite</th><th>Estado</th><th class="pe-4">Observaciones</th></tr></thead>
                        <tbody>${rows || '<tr><td colspan="7" class="text-center py-4 text-muted">No tienes solicitudes registradas.</td></tr>'}</tbody>
                    </table>
                </div>
            </div>
        </div>`;
        res.writeHead(200, { 'Content-Type': 'text/html; charset=utf-8' });
        return res.end(renderLayout('Mis Préstamos', html, user, 'prestamos'));
    }

    // VISTA: ADMIN DASHBOARD
    if (pathname === '/admin/dashboard') {
        if (!user || user.rol !== 'ADMIN') {
            res.writeHead(302, { Location: '/login?error=no_autorizado' });
            return res.end();
        }
        const totalLibros = db.libros.length;
        const prestamosActivos = db.prestamos.filter(p => p.estado === 'SOLICITADO' || p.estado === 'EN_PRESTAMO').length;
        const usuariosActivos = db.usuarios.filter(u => u.estado === 'ACTIVO').length;

        const rows = db.prestamos.slice(0, 5).map(p => `
            <tr>
                <td class="ps-4 fw-bold text-muted">#P-${p.idPrestamo}</td>
                <td><div class="fw-semibold text-dark">${p.usuarioNombre}</div><small class="text-muted">${p.usuarioCodigo}</small></td>
                <td><div class="text-dark">${p.libroTitulo}</div></td>
                <td>${p.fechaSolicitud}</td>
                <td><strong>${p.fechaLimite}</strong></td>
                <td><span class="badge ${p.estado==='SOLICITADO'?'bg-warning text-dark':(p.estado==='EN_PRESTAMO'?'bg-primary':'bg-success')}">${p.estado}</span></td>
                <td class="pe-4 text-end">
                    ${p.estado==='SOLICITADO'?`<form action="/admin/prestamos" method="POST" class="d-inline"><input type="hidden" name="action" value="aprobar"><input type="hidden" name="idPrestamo" value="${p.idPrestamo}"><button type="submit" class="btn btn-sm btn-success">Aprobar</button></form>`:''}
                    ${p.estado==='EN_PRESTAMO'?`<form action="/admin/prestamos" method="POST" class="d-inline"><input type="hidden" name="action" value="devolver"><input type="hidden" name="idPrestamo" value="${p.idPrestamo}"><button type="submit" class="btn btn-sm btn-info text-white">Devolver</button></form>`:''}
                </td>
            </tr>
        `).join('');

        const html = `
        <div class="container py-4">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h3 class="fw-bold mb-1"><i class="bi bi-speedometer2 text-primary me-2"></i> Dashboard Administrativo</h3>
                    <p class="text-muted small mb-0">Control del acervo bibliográfico y operaciones.</p>
                </div>
                <div class="d-flex gap-2">
                    <a href="/admin/libros" class="btn btn-primary btn-sm"><i class="bi bi-plus-lg me-1"></i> CRUD Libros</a>
                    <a href="/admin/prestamos" class="btn btn-warning btn-sm fw-semibold text-dark"><i class="bi bi-arrow-left-right me-1"></i> Control Préstamos</a>
                </div>
            </div>

            <div class="row g-4 mb-4">
                <div class="col-md-4"><div class="stat-card"><div class="stat-icon books"><i class="bi bi-book-half"></i></div><div><h2 class="fw-bold mb-0">${totalLibros}</h2><span class="text-muted small">Títulos Registrados</span></div></div></div>
                <div class="col-md-4"><div class="stat-card"><div class="stat-icon loans"><i class="bi bi-journal-check"></i></div><div><h2 class="fw-bold mb-0">${prestamosActivos}</h2><span class="text-muted small">Préstamos Activos</span></div></div></div>
                <div class="col-md-4"><div class="stat-card"><div class="stat-icon users"><i class="bi bi-people-fill"></i></div><div><h2 class="fw-bold mb-0">${usuariosActivos}</h2><span class="text-muted small">Usuarios Activos</span></div></div></div>
            </div>

            <div class="card border-0 shadow-sm rounded-4 overflow-hidden">
                <div class="card-header bg-white py-3 border-0 d-flex justify-content-between align-items-center">
                    <h5 class="fw-bold mb-0 text-dark"><i class="bi bi-clock-history me-2 text-primary"></i> Últimas Operaciones</h5>
                    <a href="/admin/prestamos" class="btn btn-sm btn-outline-primary">Ver Todos</a>
                </div>
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-light"><tr><th class="ps-4">ID</th><th>Miembro</th><th>Libro</th><th>F. Solicitud</th><th>F. Límite</th><th>Estado</th><th class="pe-4 text-end">Acciones</th></tr></thead>
                        <tbody>${rows}</tbody>
                    </table>
                </div>
            </div>
        </div>`;
        res.writeHead(200, { 'Content-Type': 'text/html; charset=utf-8' });
        return res.end(renderLayout('Dashboard Admin', html, user));
    }

    // VISTA: ADMIN CRUD LIBROS
    if (pathname === '/admin/libros') {
        if (!user || user.rol !== 'ADMIN') {
            res.writeHead(302, { Location: '/login?error=no_autorizado' });
            return res.end();
        }

        const catOptions = db.categorias.map(c => `<option value="${c.idCategoria}">${c.nombre}</option>`).join('');

        const rows = db.libros.map(l => `
            <tr>
                <td class="ps-4 fw-bold text-muted">#${l.idLibro}</td>
                <td><img src="${l.portadaUrl || ''}" alt="img" class="rounded shadow-sm" style="width: 40px; height: 55px; object-fit: cover;"></td>
                <td><div class="fw-bold text-dark">${l.titulo}</div><small class="text-muted">${l.autor} (${l.anioPublicacion})</small></td>
                <td><span class="badge bg-light text-dark border">${l.categoriaNombre}</span></td>
                <td><small class="text-muted">${l.isbn}</small></td>
                <td><span class="badge ${l.stockDisponible>0?'bg-success-subtle text-success border':'bg-danger-subtle text-danger border'}">${l.stockDisponible} / ${l.stockTotal}</span></td>
                <td><small class="text-secondary"><i class="bi bi-geo-alt-fill text-danger me-1"></i> ${l.ubicacionFisica}</small></td>
                <td class="pe-4 text-end">
                    <button type="button" class="btn btn-sm btn-outline-primary me-1"
                            data-bs-toggle="modal" data-bs-target="#modalEditarLibro"
                            data-id="${l.idLibro}" data-titulo="${l.titulo}" data-autor="${l.autor}"
                            data-editorial="${l.editorial}" data-anio="${l.anioPublicacion}" data-isbn="${l.isbn}"
                            data-categoria="${l.idCategoria}" data-stock-total="${l.stockTotal}" data-stock-disp="${l.stockDisponible}"
                            data-ubicacion="${l.ubicacionFisica}" data-portada="${l.portadaUrl||''}" data-pdf="${l.pdfUrl||''}">
                        <i class="bi bi-pencil-square"></i>
                    </button>
                    <form action="/admin/libros" method="POST" class="d-inline" onsubmit="return confirm('¿Eliminar este libro?');">
                        <input type="hidden" name="action" value="eliminar">
                        <input type="hidden" name="idLibro" value="${l.idLibro}">
                        <button type="submit" class="btn btn-sm btn-outline-danger"><i class="bi bi-trash"></i></button>
                    </form>
                </td>
            </tr>
        `).join('');

        const html = `
        <div class="container-fluid px-4 py-4">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h3 class="fw-bold mb-1"><i class="bi bi-journals text-primary me-2"></i> Gestión de Libros (CRUD)</h3>
                    <p class="text-muted small mb-0">Mantenimiento de títulos, inventario y recursos digitales.</p>
                </div>
                <button type="button" class="btn btn-primary fw-semibold" data-bs-toggle="modal" data-bs-target="#modalNuevoLibro">
                    <i class="bi bi-plus-circle-fill me-1"></i> Registrar Nuevo Libro
                </button>
            </div>

            <div class="card border-0 shadow-sm rounded-4 overflow-hidden">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-light"><tr><th class="ps-4">ID</th><th>Portada</th><th>Título / Autor</th><th>Categoría</th><th>ISBN</th><th>Stock</th><th>Ubicación</th><th class="pe-4 text-end">Acciones</th></tr></thead>
                        <tbody>${rows}</tbody>
                    </table>
                </div>
            </div>
        </div>

        <!-- MODAL NUEVO LIBRO -->
        <div class="modal fade" id="modalNuevoLibro" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog modal-lg modal-dialog-centered">
                <div class="modal-content border-0 shadow-lg rounded-4">
                    <div class="modal-header bg-primary text-white">
                        <h5 class="modal-title fw-bold"><i class="bi bi-plus-circle me-2"></i> Registrar Nuevo Libro</h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                    </div>
                    <form action="/admin/libros" method="POST">
                        <input type="hidden" name="action" value="crear">
                        <div class="modal-body p-4">
                            <div class="row g-3">
                                <div class="col-md-8"><label class="form-label small text-muted">Título *</label><input type="text" name="titulo" class="form-control" required></div>
                                <div class="col-md-4"><label class="form-label small text-muted">Categoría *</label><select name="idCategoria" class="form-select">${catOptions}</select></div>
                                <div class="col-md-6"><label class="form-label small text-muted">Autor *</label><input type="text" name="autor" class="form-control" required></div>
                                <div class="col-md-3"><label class="form-label small text-muted">Editorial</label><input type="text" name="editorial" class="form-control"></div>
                                <div class="col-md-3"><label class="form-label small text-muted">Año</label><input type="number" name="anioPublicacion" class="form-control" value="2024"></div>
                                <div class="col-md-4"><label class="form-label small text-muted">ISBN *</label><input type="text" name="isbn" class="form-control" required></div>
                                <div class="col-md-4"><label class="form-label small text-muted">Stock Total *</label><input type="number" name="stockTotal" class="form-control" value="5" min="1" required></div>
                                <div class="col-md-4"><label class="form-label small text-muted">Ubicación *</label><input type="text" name="ubicacionFisica" class="form-control" required placeholder="Estante A-1"></div>
                                <div class="col-md-6"><label class="form-label small text-muted">URL Portada</label><input type="url" name="portadaUrl" class="form-control"></div>
                                <div class="col-md-6"><label class="form-label small text-muted">URL PDF Digital</label><input type="url" name="pdfUrl" class="form-control"></div>
                            </div>
                        </div>
                        <div class="modal-footer bg-light">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                            <button type="submit" class="btn btn-primary fw-semibold">Guardar Libro</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <!-- MODAL EDITAR LIBRO -->
        <div class="modal fade" id="modalEditarLibro" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog modal-lg modal-dialog-centered">
                <div class="modal-content border-0 shadow-lg rounded-4">
                    <div class="modal-header bg-dark text-white">
                        <h5 class="modal-title fw-bold"><i class="bi bi-pencil-square me-2"></i> Editar Libro</h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                    </div>
                    <form action="/admin/libros" method="POST">
                        <input type="hidden" name="action" value="actualizar">
                        <input type="hidden" name="idLibro" id="editIdLibro">
                        <div class="modal-body p-4">
                            <div class="row g-3">
                                <div class="col-md-8"><label class="form-label small text-muted">Título</label><input type="text" name="titulo" id="editTitulo" class="form-control" required></div>
                                <div class="col-md-4"><label class="form-label small text-muted">Categoría</label><select name="idCategoria" id="editCategoria" class="form-select">${catOptions}</select></div>
                                <div class="col-md-6"><label class="form-label small text-muted">Autor</label><input type="text" name="autor" id="editAutor" class="form-control" required></div>
                                <div class="col-md-3"><label class="form-label small text-muted">Editorial</label><input type="text" name="editorial" id="editEditorial" class="form-control"></div>
                                <div class="col-md-3"><label class="form-label small text-muted">Año</label><input type="number" name="anioPublicacion" id="editAnio" class="form-control"></div>
                                <div class="col-md-4"><label class="form-label small text-muted">ISBN</label><input type="text" name="isbn" id="editIsbn" class="form-control" required></div>
                                <div class="col-md-4"><label class="form-label small text-muted">Stock Total</label><input type="number" name="stockTotal" id="editStockTotal" class="form-control" min="1" required></div>
                                <div class="col-md-4"><label class="form-label small text-muted">Stock Disponible</label><input type="number" name="stockDisponible" id="editStockDisponible" class="form-control" min="0" required></div>
                                <div class="col-md-12"><label class="form-label small text-muted">Ubicación</label><input type="text" name="ubicacionFisica" id="editUbicacion" class="form-control" required></div>
                                <div class="col-md-6"><label class="form-label small text-muted">URL Portada</label><input type="url" name="portadaUrl" id="editPortada" class="form-control"></div>
                                <div class="col-md-6"><label class="form-label small text-muted">URL PDF</label><input type="url" name="pdfUrl" id="editPdf" class="form-control"></div>
                            </div>
                        </div>
                        <div class="modal-footer bg-light">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                            <button type="submit" class="btn btn-success fw-semibold">Guardar Cambios</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>`;
        res.writeHead(200, { 'Content-Type': 'text/html; charset=utf-8' });
        return res.end(renderLayout('Gestión de Libros (CRUD)', html, user));
    }

    // VISTA: ADMIN CONTROL PRÉSTAMOS
    if (pathname === '/admin/prestamos') {
        if (!user || user.rol !== 'ADMIN') {
            res.writeHead(302, { Location: '/login?error=no_autorizado' });
            return res.end();
        }

        const rows = db.prestamos.map(p => `
            <tr>
                <td class="ps-4 fw-bold text-muted">#P-${p.idPrestamo}</td>
                <td><div class="fw-bold text-dark">${p.usuarioNombre}</div><small class="badge bg-light text-dark border">${p.usuarioCodigo}</small></td>
                <td><div class="text-dark fw-semibold">${p.libroTitulo}</div><small class="text-muted">ISBN: ${p.libroIsbn}</small></td>
                <td>${p.fechaSolicitud}</td>
                <td>${p.fechaPrestamo || '<em class="text-muted">No entregado</em>'}</td>
                <td><strong class="text-primary">${p.fechaLimite}</strong></td>
                <td>${p.fechaDevolucion || '<em class="text-muted">-</em>'}</td>
                <td><span class="badge ${p.estado==='SOLICITADO'?'bg-warning text-dark':(p.estado==='EN_PRESTAMO'?'bg-primary':'bg-success')}">${p.estado}</span></td>
                <td class="pe-4 text-end">
                    ${p.estado==='SOLICITADO'?`<form action="/admin/prestamos" method="POST" class="d-inline"><input type="hidden" name="action" value="aprobar"><input type="hidden" name="idPrestamo" value="${p.idPrestamo}"><button type="submit" class="btn btn-sm btn-success fw-semibold"><i class="bi bi-box-arrow-right me-1"></i> Entregar</button></form>`:''}
                    ${p.estado==='EN_PRESTAMO'?`<form action="/admin/prestamos" method="POST" class="d-inline"><input type="hidden" name="action" value="devolver"><input type="hidden" name="idPrestamo" value="${p.idPrestamo}"><button type="submit" class="btn btn-sm btn-info text-white fw-semibold"><i class="bi bi-box-arrow-in-left me-1"></i> Devolver</button></form>`:''}
                </td>
            </tr>
        `).join('');

        const html = `
        <div class="container-fluid px-4 py-4">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h3 class="fw-bold mb-1"><i class="bi bi-arrow-left-right text-warning me-2"></i> Control de Préstamos y Devoluciones</h3>
                    <p class="text-muted small mb-0">Atención de solicitudes, entrega de ejemplares y control de inventario.</p>
                </div>
            </div>
            <div class="card border-0 shadow-sm rounded-4 overflow-hidden">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-light"><tr><th class="ps-4">ID</th><th>Miembro</th><th>Libro</th><th>F. Solicitud</th><th>F. Préstamo</th><th>F. Límite</th><th>F. Devolución</th><th>Estado</th><th class="pe-4 text-end">Acción</th></tr></thead>
                        <tbody>${rows}</tbody>
                    </table>
                </div>
            </div>
        </div>`;
        res.writeHead(200, { 'Content-Type': 'text/html; charset=utf-8' });
        return res.end(renderLayout('Control de Préstamos', html, user));
    }

    // VISTA: ADMIN USUARIOS
    if (pathname === '/admin/usuarios') {
        if (!user || user.rol !== 'ADMIN') {
            res.writeHead(302, { Location: '/login?error=no_autorizado' });
            return res.end();
        }

        const rows = db.usuarios.map(u => `
            <tr>
                <td class="ps-4 fw-bold text-muted">#${u.idUsuario}</td>
                <td class="fw-bold text-dark">${u.nombreCompleto}</td>
                <td><span class="badge bg-light text-dark border">${u.codigoUniversitario}</span></td>
                <td>${u.correo}</td>
                <td><span class="badge ${u.rol==='ADMIN'?'bg-dark':'bg-secondary'}">${u.rol}</span></td>
                <td><span class="badge ${u.estado==='ACTIVO'?'bg-success-subtle text-success border':'bg-danger-subtle text-danger border'}">${u.estado}</span></td>
                <td class="pe-4 text-end">
                    ${u.idUsuario !== user.idUsuario ? `
                    <form action="/admin/usuarios" method="POST" class="d-inline-flex gap-1 align-items-center">
                        <input type="hidden" name="idUsuario" value="${u.idUsuario}">
                        <select name="estado" class="form-select form-select-sm" style="width: 130px;">
                            <option value="ACTIVO" ${u.estado==='ACTIVO'?'selected':''}>Activar</option>
                            <option value="SANCIONADO" ${u.estado==='SANCIONADO'?'selected':''}>Sancionar</option>
                            <option value="INACTIVO" ${u.estado==='INACTIVO'?'selected':''}>Inactivar</option>
                        </select>
                        <button type="submit" class="btn btn-sm btn-outline-primary"><i class="bi bi-save"></i></button>
                    </form>` : ''}
                </td>
            </tr>
        `).join('');

        const html = `
        <div class="container-fluid px-4 py-4">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h3 class="fw-bold mb-1"><i class="bi bi-people-fill text-primary me-2"></i> Gestión de Usuarios</h3>
                    <p class="text-muted small mb-0">Control de estados, miembros y sanciones.</p>
                </div>
            </div>
            <div class="card border-0 shadow-sm rounded-4 overflow-hidden">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-light"><tr><th class="ps-4">ID</th><th>Nombre</th><th>Código</th><th>Correo</th><th>Rol</th><th>Estado</th><th class="pe-4 text-end">Acción</th></tr></thead>
                        <tbody>${rows}</tbody>
                    </table>
                </div>
            </div>
        </div>`;
        res.writeHead(200, { 'Content-Type': 'text/html; charset=utf-8' });
        return res.end(renderLayout('Gestión de Usuarios', html, user));
    }

    // Ruta no encontrada
    res.writeHead(302, { Location: '/catalogo' });
    res.end();
});

server.listen(PORT, () => {
    console.log(`=======================================================`);
    console.log(`🚀 BOOKHUB INICIADO CORRECTAMENTE EN EL PUERTO ${PORT}`);
    console.log(`🌐 Accede ahora desde tu navegador en:`);
    console.log(`👉 http://localhost:${PORT}/`);
    console.log(`=======================================================`);
});
