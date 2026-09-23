# Guía Oficial y Rúbrica de Evaluación: Proyecto Java Web (JSP, Servlets, JavaBeans)

**Puntaje Total:** 20 Puntos  
**Tecnologías:** Java (Servlets, JSP, JavaBeans), HTML5, CSS3, Bootstrap (BS), Base de Datos Relacional (MySQL / PostgreSQL / Oracle).  
**Restricciones Clave:**  
🚫 **NO ESTÁ PERMITIDO:** Sistema de Ventas  
🚫 **NO ESTÁ PERMITIDO:** Sistema de Citas  

---

## 📊 Matriz Oficial de Rúbrica (Escala Vigesimal: 0 - 20 pts)

| N° | Criterio / Concepto | Máximo (Excelente) | Medio (Regular) | Mínimo (Insuficiente) |
|:--:|:---|:---:|:---:|:---:|
| **1** | **Presentación de proyecto, sistema, roles y funciones** | **2.0 pts**<br>Presentación clara en PPT, descripción formal de la empresa, justificación del sistema, definición rigurosa de roles (ej. Admin, Operador, Usuario) y catálogo de funciones por entrega. | **1.0 pt**<br>Presentación incompleta, roles confusos o funciones poco detalladas. | **0.0 pts**<br>No presenta PPT o no define empresa, roles ni funciones. |
| **2** | **Diagrama y especificación de casos de uso (CU)** | **4.0 pts**<br>Diagrama de Casos de Uso en UML completo, actores identificados correctamente y fichas de especificación de CU con flujos principales, alternos y excepciones. | **2.0 pts**<br>Diagrama incompleto, errores en relaciones UML (`<<include>>`, `<<extend>>`) o especificaciones superficiales. | **0.0 pts**<br>No presenta diagrama ni especificación de casos de uso. |
| **3** | **Diagrama de clases, modelo de datos e implementación** | **4.0 pts**<br>Diagrama de clases robusto (patrón MVC/DAO), modelo entidad-relación (MER/MR) normalizado con integridad referencial, y scripts de base de datos implementados y funcionales. | **2.0 pts**<br>Diagrama o modelo con fallas de diseño, tablas sin normalizar o implementación parcial de la BD. | **0.0 pts**<br>Sin diagramas ni base de datos implementada. |
| **4** | **UX Usuarios (HTML - CSS - Bootstrap)** | **3.0 pts**<br>Interfaz de usuario final limpia, moderna, responsiva, amigable, validaciones de formularios y navegación intuitiva. | **1.5 pts**<br>Diseño funcional pero poco atractivo, problemas de adaptabilidad móvil o validaciones incompletas. | **0.0 pts**<br>Interfaz descuidada, rota o sin uso de CSS/Bootstrap. |
| **5** | **UX Admin (HTML - CSS - Bootstrap)** | **3.0 pts**<br>Panel administrativo completo con Dashboard/Gestión, tablas interactivas, operaciones CRUD fluidas, modales de confirmación y alertas visuales claras. | **1.5 pts**<br>CRUD administrativo incompleto, diseño básico o con fallas visuales de usabilidad. | **0.0 pts**<br>No implementa panel de administración o CRUD inoperativo. |
| **6** | **Aplicación de Servlets, JSP y JavaBeans** | **4.0 pts**<br>Arquitectura MVC correcta: JSP para la vista (con JSTL / EL), Servlets como controladores de peticiones (GET/POST), JavaBeans / POJOs para encapsulamiento y DAOs para persistencia JDBC. | **2.0 pts**<br>Código Java desordenado, lógica de negocio incrustada directamente en JSPs (scriptlets) o mal uso de Servlets/JavaBeans. | **0.0 pts**<br>No utiliza Servlets/JSP/JavaBeans o el código no compila. |
| | **TOTAL** | **20.0 pts** | **10.0 pts** | **0.0 pts** |

---

## 💡 Propuestas de Temas Validados (Cumplen con NO Ventas y NO Citas)

A continuación, 4 propuestas sólidas y académicamente recomendadas:

### Opción 1: Sistema de Mesa de Ayuda y Gestión de Tickets / Incidencias TI (Helpdesk)
* **Empresa:** Empresa de Servicios Tecnológicos / Consultora de TI.
* **Rol Usuario:** Reporta incidencias técnicas, consulta el estado de sus solicitudes, califica la atención recibida.
* **Rol Técnico / Operador:** Atiende tickets, cambia estados (Pendiente, En Proceso, Resuelto), registra soluciones.
* **Rol Administrador (CRUD):** Gestión de usuarios, categorías de incidencias, asignación de técnicos, reportes de tiempos de respuesta.

### Opción 2: Sistema de Préstamo y Control de Equipos / Laboratorios
* **Empresa:** Institución Educativa o Centro de Investigación.
* **Rol Docente / Estudiante:** Solicita préstamo de equipos (laptops, proyectores, kits de robótica), revisa disponibilidad y estado de devolución.
* **Rol Encargado de Almacén:** Valida entregas, registra devoluciones y observaciones de estado físico del equipo.
* **Rol Administrador (CRUD):** CRUD de equipos, categorías, inventario físico, usuarios y reportes de penalidades por mora.

### Opción 3: Sistema de Gestión y Seguimiento de Prácticas Pre-Profesionales / Bolsa de Trabajo
* **Empresa:** Universidad / Instituto de Educación Superior.
* **Rol Estudiante:** Sube CV, postula a convocatorias de prácticas, registra convenios y sube informes periódicos.
* **Rol Empresa Convenio:** Publica ofertas de prácticas y evalúa postulantes.
* **Rol Administrador (CRUD):** Gestión de empresas aliadas, validación de convenios, aprobación de horas acumuladas y reportes de inserción laboral.

### Opción 4: Sistema de Control de Mantenimiento de Flota Vehicular / Maquinaria
* **Empresa:** Empresa de Logística, Transporte o Construcción.
* **Rol Conductor / Operador:** Registra reportes de fallas mecánicas, kilometraje y solicitud de revisión.
* **Rol Mecánico:** Registra órdenes de trabajo, insumos/repuestos utilizados y cierre de mantenimiento.
* **Rol Administrador (CRUD):** CRUD de vehículos, repuestos, mecánicos, programación de mantenimientos preventivos y métricas.

---

## 🏗️ Arquitectura Técnica Recomendada (Java Web MVC)

```
ProyectoJavaWeb/
├── src/main/java/
│   ├── com.proyecto.model/          # JavaBeans (POJOs con getters/setters)
│   │   ├── Usuario.java
│   │   ├── Incidencia.java
│   │   └── Categoria.java
│   ├── com.proyecto.dao/            # Acceso a Datos (JDBC Connection + Queries)
│   │   ├── ConexionBD.java
│   │   ├── UsuarioDAO.java
│   │   └── IncidenciaDAO.java
│   └── com.proyecto.controller/     # Servlets (Controladores GET/POST)
│       ├── LoginServlet.java
│       ├── IncidenciaServlet.java
│       └── AdminCrudServlet.java
└── src/main/webapp/
    ├── assets/                      # CSS, JS, Bootstrap, Imágenes
    │   ├── css/custom.css
    │   └── js/app.js
    ├── views/                       # JSPs organizadas
    │   ├── auth/login.jsp
    │   ├── user/portal-usuario.jsp
    │   └── admin/dashboard-crud.jsp
    └── WEB-INF/
        └── web.xml                  # Mapeo de Servlets y filtros
```
