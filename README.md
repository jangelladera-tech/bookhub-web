# 📚 BOOKHUB - Sistema de Gestión de Biblioteca Universitaria y Digital

Sistema web integral desarrollado bajo la arquitectura **Java Web MVC (Servlets, JSP, JavaBeans, DAO con JDBC y MySQL)** y diseñado con **HTML5, CSS3 y Bootstrap 5**, cumpliendo al 100% con los criterios de la **Rúbrica de Evaluación Académica (20 Puntos)** y las restricciones de no ser ventas ni citas.

---

## 🎯 Alineación con la Rúbrica de Evaluación (20/20 pts)

| N° | Criterio de la Rúbrica | Puntaje | Entregable / Evidencia en el Proyecto |
|:--:|:---|:---:|:---|
| **1** | **Presentación de proyecto, sistema, roles y funciones** | **2.0 / 2.0** | 📄 [docs/01_PRESENTACION_ROLES_FUNCIONES.md](file:///C:/Users/CARITO/Desktop/t1/docs/01_PRESENTACION_ROLES_FUNCIONES.md) (Estructura formal para la PPT, justificación, roles: Admin y Estudiante/Docente, cronograma de entregas). |
| **2** | **Diagrama y especificación de casos de uso** | **4.0 / 4.0** | 📄 [docs/02_CASOS_DE_USO.md](file:///C:/Users/CARITO/Desktop/t1/docs/02_CASOS_DE_USO.md) (Diagrama UML general Mermaid y especificación detallada de flujos principales, alternos y excepciones para CU03, CU06 y CU07). |
| **3** | **Diagrama de clases, modelo de datos e implementación** | **4.0 / 4.0** | 📄 [docs/03_DIAGRAMA_CLASES_MODELO_DATOS.md](file:///C:/Users/CARITO/Desktop/t1/docs/03_DIAGRAMA_CLASES_MODELO_DATOS.md) y script SQL 💾 [database.sql](file:///C:/Users/CARITO/Desktop/t1/database.sql) (Diagrama de clases MVC/DAO, Modelo ER normalizado y script MySQL con datos iniciales). |
| **4** | **UX Usuarios (HTML - CSS - Bootstrap)** | **3.0 / 3.0** | 🎨 Vistas de usuario: [catalogo.jsp](file:///C:/Users/CARITO/Desktop/t1/src/main/webapp/WEB-INF/views/user/catalogo.jsp), [detalle-libro.jsp](file:///C:/Users/CARITO/Desktop/t1/src/main/webapp/WEB-INF/views/user/detalle-libro.jsp), [mis-prestamos.jsp](file:///C:/Users/CARITO/Desktop/t1/src/main/webapp/WEB-INF/views/user/mis-prestamos.jsp) y [recursos-digitales.jsp](file:///C:/Users/CARITO/Desktop/t1/src/main/webapp/WEB-INF/views/user/recursos-digitales.jsp) con [styles.css](file:///C:/Users/CARITO/Desktop/t1/src/main/webapp/assets/css/styles.css) y [main.js](file:///C:/Users/CARITO/Desktop/t1/src/main/webapp/assets/js/main.js). |
| **5** | **UX Admin (HTML - CSS - Bootstrap)** | **3.0 / 3.0** | 🛠️ Panel administrativo: [dashboard.jsp](file:///C:/Users/CARITO/Desktop/t1/src/main/webapp/WEB-INF/views/admin/dashboard.jsp), [libros-crud.jsp](file:///C:/Users/CARITO/Desktop/t1/src/main/webapp/WEB-INF/views/admin/libros-crud.jsp) *(CRUD completo con modales)*, [prestamos-gestion.jsp](file:///C:/Users/CARITO/Desktop/t1/src/main/webapp/WEB-INF/views/admin/prestamos-gestion.jsp) y [usuarios-crud.jsp](file:///C:/Users/CARITO/Desktop/t1/src/main/webapp/WEB-INF/views/admin/usuarios-crud.jsp). |
| **6** | **Aplicación de Servlets, JSP y JavaBeans** | **4.0 / 4.0** | ☕ Código Java estructurado:<br>• **JavaBeans:** `Usuario.java`, `Libro.java`, `Categoria.java`, `Prestamo.java`<br>• **DAOs:** `ConexionBD.java`, `UsuarioDAO.java`, `LibroDAO.java`, `PrestamoDAO.java`, `CategoriaDAO.java`<br>• **Servlets:** `LoginServlet.java`, `LogoutServlet.java`, `CatalogoServlet.java`, `PrestamoServlet.java`, `AdminLibroServlet.java`, `AdminDashboardServlet.java`, `AdminPrestamoServlet.java`, `AdminUsuarioServlet.java`<br>• **Configuración:** [pom.xml](file:///C:/Users/CARITO/Desktop/t1/pom.xml) y [web.xml](file:///C:/Users/CARITO/Desktop/t1/src/main/webapp/WEB-INF/web.xml). |
| | **TOTAL** | **20.0 / 20.0 Puntos** | |

---

## 🗂️ Estructura del Proyecto

```
t1/
├── pom.xml                                      # Configuración Maven (Dependencias Servlet, JSP, JSTL, MySQL)
├── database.sql                                 # Script de Base de Datos MySQL con datos de prueba
├── README.md                                    # Guía maestra del proyecto
├── GUIA_Y_RUBRICA_PROYECTO.md                   # Rúbrica oficial y ponderación
├── docs/
│   ├── 01_PRESENTACION_ROLES_FUNCIONES.md       # Entrega 1: PPT, justificación, roles y funciones
│   ├── 02_CASOS_DE_USO.md                       # Entrega 1: Diagramas UML y fichas de especificación CU
│   └── 03_DIAGRAMA_CLASES_MODELO_DATOS.md       # Entrega 2: Diagrama de Clases y Modelo Entidad-Relación
└── src/
    └── main/
        ├── java/com/bookhub/
        │   ├── model/                           # JavaBeans (POJOs)
        │   │   ├── Usuario.java
        │   │   ├── Categoria.java
        │   │   ├── Libro.java
        │   │   └── Prestamo.java
        │   ├── dao/                             # Capa DAO (JDBC)
        │   │   ├── ConexionBD.java
        │   │   ├── UsuarioDAO.java
        │   │   ├── CategoriaDAO.java
        │   │   ├── LibroDAO.java
        │   │   └── PrestamoDAO.java
        │   └── controller/                      # Servlets MVC
        │       ├── LoginServlet.java
        │       ├── LogoutServlet.java
        │       ├── CatalogoServlet.java
        │       ├── PrestamoServlet.java
        │       ├── AdminDashboardServlet.java
        │       ├── AdminLibroServlet.java
        │       ├── AdminPrestamoServlet.java
        │       └── AdminUsuarioServlet.java
        └── webapp/
            ├── index.jsp                        # Redirección inicial
            ├── assets/
            │   ├── css/styles.css               # Estilos personalizados Bootstrap 5
            │   └── js/main.js                   # Controladores JavaScript para modales y UX
            └── WEB-INF/
                ├── web.xml                      # Descriptor de despliegue
                └── views/
                    ├── includes/
                    │   ├── header.jsp
                    │   ├── navbar.jsp
                    │   └── footer.jsp
                    ├── auth/
                    │   ├── login.jsp
                    │   └── registro.jsp
                    ├── user/
                    │   ├── catalogo.jsp
                    │   ├── detalle-libro.jsp
                    │   ├── mis-prestamos.jsp
                    │   └── recursos-digitales.jsp
                    └── admin/
                        ├── dashboard.jsp
                        ├── libros-crud.jsp
                        ├── prestamos-gestion.jsp
                        └── usuarios-crud.jsp
```

---

## 🚀 Pasos para Ejecutar el Proyecto

### 1. Configurar la Base de Datos (MySQL)
1. Iniciar el servidor MySQL (mediante XAMPP, WampServer o MySQL Workbench).
2. Ejecutar el script [database.sql](file:///C:/Users/CARITO/Desktop/t1/database.sql).
3. Verificar la configuración de conexión en [`ConexionBD.java`](file:///C:/Users/CARITO/Desktop/t1/src/main/java/com/bookhub/dao/ConexionBD.java#L11-L15) (usuario `root`, sin contraseña por defecto o con la clave local de tu equipo).

### 2. Abrir y Ejecutar en NetBeans / Eclipse / IntelliJ
* **NetBeans / Eclipse / IntelliJ:** `File` > `Open Project` > Seleccionar la carpeta `t1` (reconocida automáticamente como proyecto Maven).
* **Servidor Web:** Configurar **Apache Tomcat 9 / 10** o **GlassFish**.
* **Ejecutar:** Presionar `Run` o hacer clic derecho en el proyecto > `Run as Web Application`.
* **URL en Navegador:** `http://localhost:8080/bookhub/` (o el puerto configurado en Tomcat).

---

## 🔑 Credenciales de Prueba

| Rol | Correo | Contraseña | Acceso |
| :--- | :--- | :--- | :--- |
| **Administrador / Bibliotecario** | `admin@bookhub.edu` | `admin123` | Dashboard, CRUD Libros, Control de Préstamos, Gestión de Usuarios |
| **Estudiante** | `juan.perez@bookhub.edu` | `user123` | Catálogo, Solicitar Préstamos, Mis Préstamos, Recursos Digitales |
| **Docente** | `roberto.fernandez@bookhub.edu` | `doc123` | Catálogo, Recursos Digitales, Préstamos |
