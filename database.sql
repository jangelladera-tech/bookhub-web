-- =====================================================================
-- PROYECTO: BOOKHUB - Sistema de Gestión de Biblioteca Universitaria y Digital
-- SCRIPT SQL: Estructura de Tablas y Datos Iniciales de Prueba
-- COMPATIBILIDAD: MySQL 8.0+ / MariaDB 10.4+
-- =====================================================================

DROP DATABASE IF EXISTS bookhub_db;
CREATE DATABASE bookhub_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE bookhub_db;

-- ---------------------------------------------------------------------
-- 1. TABLA: categorias
-- ---------------------------------------------------------------------
CREATE TABLE categorias (
    id_categoria INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL UNIQUE,
    descripcion VARCHAR(255) NULL
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- 2. TABLA: usuarios
-- ---------------------------------------------------------------------
CREATE TABLE usuarios (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    nombre_completo VARCHAR(150) NOT NULL,
    codigo_universitario VARCHAR(20) NOT NULL UNIQUE,
    correo VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    rol ENUM('ADMIN', 'ESTUDIANTE', 'DOCENTE') NOT NULL DEFAULT 'ESTUDIANTE',
    estado ENUM('ACTIVO', 'SANCIONADO', 'INACTIVO') NOT NULL DEFAULT 'ACTIVO',
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- 3. TABLA: libros
-- ---------------------------------------------------------------------
CREATE TABLE libros (
    id_libro INT AUTO_INCREMENT PRIMARY KEY,
    id_categoria INT NOT NULL,
    titulo VARCHAR(200) NOT NULL,
    autor VARCHAR(150) NOT NULL,
    editorial VARCHAR(100) NULL,
    anio_publicacion INT NULL,
    isbn VARCHAR(30) UNIQUE,
    stock_total INT NOT NULL DEFAULT 1,
    stock_disponible INT NOT NULL DEFAULT 1,
    ubicacion_fisica VARCHAR(80) NOT NULL COMMENT 'Ej: Estante B-4, Nivel 2',
    portada_url VARCHAR(255) NULL,
    pdf_url VARCHAR(255) NULL COMMENT 'Enlace o ruta del recurso digital',
    estado ENUM('DISPONIBLE', 'NO_DISPONIBLE') DEFAULT 'DISPONIBLE',
    CONSTRAINT fk_libros_categoria FOREIGN KEY (id_categoria) REFERENCES categorias(id_categoria) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- 4. TABLA: prestamos
-- ---------------------------------------------------------------------
CREATE TABLE prestamos (
    id_prestamo INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL,
    id_libro INT NOT NULL,
    fecha_solicitud DATE NOT NULL,
    fecha_prestamo DATE NULL,
    fecha_limite DATE NOT NULL,
    fecha_devolucion DATE NULL,
    estado ENUM('SOLICITADO', 'EN_PRESTAMO', 'DEVUELTO', 'DEVUELTO_CON_RETRASO', 'CANCELADO') NOT NULL DEFAULT 'SOLICITADO',
    observaciones TEXT NULL,
    CONSTRAINT fk_prestamos_usuario FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_prestamos_libro FOREIGN KEY (id_libro) REFERENCES libros(id_libro) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- 5. TABLA: sanciones
-- ---------------------------------------------------------------------
CREATE TABLE sanciones (
    id_sancion INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL,
    id_prestamo INT NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE NOT NULL,
    monto_multa DECIMAL(8,2) DEFAULT 0.00,
    motivo VARCHAR(255) NOT NULL,
    estado ENUM('PENDIENTE', 'PAGADA', 'CONDONADA') DEFAULT 'PENDIENTE',
    CONSTRAINT fk_sanciones_usuario FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_sanciones_prestamo FOREIGN KEY (id_prestamo) REFERENCES prestamos(id_prestamo) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- =====================================================================
-- DATOS SEMILLA / PRUEBAS INICIALES
-- =====================================================================

-- Categorías
INSERT INTO categorias (id_categoria, nombre, descripcion) VALUES
(1, 'Ingeniería de Software y Sistemas', 'Libros de programación, arquitectura de software, bases de datos y redes.'),
(2, 'Ciencias Básicas y Matemáticas', 'Cálculo, álgebra lineal, física y estadística aplicadas.'),
(3, 'Inteligencia Artificial y Datos', 'Machine Learning, Deep Learning, Big Data y Ciencia de Datos.'),
(4, 'Gestión de Proyectos y Negocios', 'Metodologías ágiles, Scrum, liderazgo y gestión de empresas tecnológicas.'),
(5, 'Humanidades e Investigación', 'Metodología de la investigación, ética profesional y redacción académica.');

-- Usuarios de prueba (Passwords en texto plano para el proyecto académico o hash)
-- Admin: admin@bookhub.edu / admin123
-- Estudiante 1: juan.perez@bookhub.edu / user123
-- Estudiante 2: maria.garcia@bookhub.edu / user123
INSERT INTO usuarios (id_usuario, nombre_completo, codigo_universitario, correo, password, rol, estado) VALUES
(1, 'Mg. Carlos Mendoza (Bibliotecario)', 'ADM-001', 'admin@bookhub.edu', 'admin123', 'ADMIN', 'ACTIVO'),
(2, 'Juan Pérez Rodríguez', 'U20210045', 'juan.perez@bookhub.edu', 'user123', 'ESTUDIANTE', 'ACTIVO'),
(3, 'María García Salazar', 'U20221478', 'maria.garcia@bookhub.edu', 'user123', 'ESTUDIANTE', 'ACTIVO'),
(4, 'Dr. Roberto Fernández', 'DOC-9921', 'roberto.fernandez@bookhub.edu', 'doc123', 'DOCENTE', 'ACTIVO');

-- Libros de prueba
INSERT INTO libros (id_libro, id_categoria, titulo, autor, editorial, anio_publicacion, isbn, stock_total, stock_disponible, ubicacion_fisica, portada_url, pdf_url, estado) VALUES
(1, 1, 'Clean Code: A Handbook of Agile Software Craftsmanship', 'Robert C. Martin', 'Prentice Hall', 2008, '978-0132350884', 5, 4, 'Estante A-1, Nivel 1', 'https://images.unsplash.com/photo-1532012164546-f432f2e3edd4?w=400', 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf', 'DISPONIBLE'),
(2, 1, 'Java: The Complete Reference (12th Edition)', 'Herbert Schildt', 'McGraw-Hill', 2021, '978-1260463415', 4, 3, 'Estante A-2, Nivel 1', 'https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?w=400', 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf', 'DISPONIBLE'),
(3, 1, 'Design Patterns: Elements of Reusable Object-Oriented Software', 'Erich Gamma, Richard Helm, Ralph Johnson, John Vlissides', 'Addison-Wesley', 1994, '978-0201633610', 3, 2, 'Estante A-3, Nivel 1', 'https://images.unsplash.com/photo-1512820790803-83ca734da794?w=400', 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf', 'DISPONIBLE'),
(4, 3, 'Hands-On Machine Learning with Scikit-Learn, Keras, and TensorFlow', 'Aurélien Géron', 'O\'Reilly Media', 2019, '978-1492032649', 4, 4, 'Estante B-1, Nivel 2', 'https://images.unsplash.com/photo-1526374965328-7f61d4dc18c5?w=400', 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf', 'DISPONIBLE'),
(5, 2, 'Cálculo de una Variable: Trascendentes Tempranas', 'James Stewart', 'Cengage Learning', 2016, '978-6075220154', 6, 5, 'Estante C-1, Nivel 1', 'https://images.unsplash.com/photo-1509228468518-180dd4864904?w=400', 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf', 'DISPONIBLE'),
(6, 4, 'Scrum: The Art of Doing Twice the Work in Half the Time', 'Jeff Sutherland', 'Crown Business', 2014, '978-0385346450', 3, 3, 'Estante D-2, Nivel 2', 'https://images.unsplash.com/photo-1552664730-d307ca884978?w=400', 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf', 'DISPONIBLE'),
(7, 5, 'Metodología de la Investigación Científica', 'Roberto Hernández-Sampieri', 'McGraw-Hill', 2018, '978-1456223960', 5, 5, 'Estante E-1, Nivel 3', 'https://images.unsplash.com/photo-1497633762265-9d179a990aa6?w=400', 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf', 'DISPONIBLE');

-- Préstamos iniciales de prueba
INSERT INTO prestamos (id_prestamo, id_usuario, id_libro, fecha_solicitud, fecha_prestamo, fecha_limite, fecha_devolucion, estado, observaciones) VALUES
(1, 2, 1, '2026-09-15', '2026-09-15', '2026-09-22', '2026-09-21', 'DEVUELTO', 'Devuelto en óptimas condiciones.'),
(2, 2, 2, '2026-09-20', '2026-09-20', '2026-09-27', NULL, 'EN_PRESTAMO', 'Préstamo vigente para estudio de parciales.'),
(3, 3, 3, '2026-09-22', '2026-09-22', '2026-09-29', NULL, 'EN_PRESTAMO', 'Préstamo regular.'),
(4, 3, 5, '2026-09-23', NULL, '2026-09-30', NULL, 'SOLICITADO', 'Pendiente de entrega en mostrador.');
