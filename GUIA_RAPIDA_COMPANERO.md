# 🚀 Guía Rápida para el Compañero de Equipo: BookHub

¡Bienvenido! Este repositorio contiene todo el proyecto **BOOKHUB** organizado según la rúbrica del curso (20 puntos) sin instalaciones complejas requeridas para previsualizarlo.

---

## ⚡ Opción 1: Ejecutar al Instante con 1 Clic (Sin Configurar Tomcat)

Si tienes **Node.js** instalado en tu computadora:

1. **En Windows:** Haz doble clic sobre el archivo 👉 `INICIAR_PROYECTO.bat`.
2. O desde la terminal en esta carpeta ejecuta:
   ```bash
   node server.js
   ```
3. Se abrirá automáticamente en tu navegador en:
   👉 **http://localhost:8080/**

---

## ☕ Opción 2: Ejecutar en NetBeans / Eclipse / IntelliJ (Java Web Oficial)

1. **Base de Datos:**
   * Abre phpMyAdmin, XAMPP o MySQL Workbench.
   * Importa y ejecuta el script [database.sql](file:///C:/Users/CARITO/Desktop/t1/database.sql).
   * La base de datos `bookhub_db` se creará con todas sus tablas y datos de prueba.

2. **Abrir en el IDE:**
   * En NetBeans / Eclipse / IntelliJ: `File` > `Open Project` > Selecciona esta carpeta (reconocida automáticamente por [pom.xml](file:///C:/Users/CARITO/Desktop/t1/pom.xml)).
   * Agrega el servidor **Apache Tomcat (v9 o v10)**.
   * Haz clic derecho en el proyecto > `Run`.

---

## 🔑 Credenciales y Accesos Disponibles

Puedes iniciar sesión con cualquiera de estos roles para probar todas las vistas y funciones:

### 🛡️ 1. Rol Administrador / Bibliotecario
* **Correo:** `admin@bookhub.edu`
* **Contraseña:** `admin123`
* **Accesos:**
  * Dashboard de Métricas y Estadísticas (`/admin/dashboard`).
  * CRUD completo de Libros: Crear, editar datos/stock y eliminar (`/admin/libros`).
  * Control de Préstamos: Entregar libros solicitados y registrar devoluciones (`/admin/prestamos`).
  * Gestión de Usuarios y Sanciones (`/admin/usuarios`).

### 👤 2. Rol Estudiante (Usuario General)
* **Correo:** `juan.perez@bookhub.edu`
* **Contraseña:** `user123`
* **Código:** `U20210045`
* **Accesos:**
  * Catálogo de libros con buscador y filtros (`/catalogo`).
  * Solicitar préstamo físico (`/solicitar-prestamo`).
  * Mis préstamos con control de fechas límite (`/mis-prestamos`).
  * Repositorio de recursos y PDFs descargables (`/recursos-digitales`).

### 🎓 3. Rol Docente
* **Correo:** `roberto.fernandez@bookhub.edu`
* **Contraseña:** `doc123`
* **Código:** `DOC-9921`

---

## 📑 Documentos Listos para la PPT y Presentación Académica

* 📄 [docs/01_PRESENTACION_ROLES_FUNCIONES.md](file:///C:/Users/CARITO/Desktop/t1/docs/01_PRESENTACION_ROLES_FUNCIONES.md) -> Datos de la empresa, justificación, roles y entregas para armar la PPT.
* 📄 [docs/02_CASOS_DE_USO.md](file:///C:/Users/CARITO/Desktop/t1/docs/02_CASOS_DE_USO.md) -> Diagramas UML y especificaciones de Casos de Uso.
* 📄 [docs/03_DIAGRAMA_CLASES_MODELO_DATOS.md](file:///C:/Users/CARITO/Desktop/t1/docs/03_DIAGRAMA_CLASES_MODELO_DATOS.md) -> Diagrama de Clases (MVC/DAO) y Modelo Entidad-Relación (MER).
* 💾 [database.sql](file:///C:/Users/CARITO/Desktop/t1/database.sql) -> Script SQL normalizado con integridad referencial.
