# 🏛️ Diagrama de Clases, Modelo de Datos y Arquitectura - BOOKHUB

## 1. Arquitectura del Sistema (Patrón MVC + DAO en Java)

El sistema implementa la arquitectura Modelo-Vista-Controlador (MVC) utilizando Servlets para el control, JSPs para las vistas, JavaBeans para la representación de entidades y DAOs con JDBC para la persistencia de datos.

```
       [ Cliente / Navegador ]
                 │
                 ▼ (HTTP GET / POST)
       ┌────────────────────┐
       │   Controladores    │  <-- Servlets (LoginServlet, LibroServlet, etc.)
       └─────────┬──────────┘
                 │
        ┌────────┴────────┐
        ▼                 ▼
 ┌───────────────┐ ┌────────────────┐
 │    Vistas     │ │     Modelo     │
 │  (JSP + JSTL  │ │  (JavaBeans    │
 │ + Bootstrap)  │ │   + DAOs)      │
 └───────────────┘ └────────┬───────┘
                            │ (JDBC)
                            ▼
                   [ Base de Datos SQL ]
```

---

## 2. Diagrama de Clases UML (Java)

```mermaid
classDiagram
    class Usuario {
        -int idUsuario
        -String nombreCompleto
        -String codigoUniversitario
        -String correo
        -String password
        -String rol
        -String estado
        +getters()
        +setters()
    }

    class Categoria {
        -int idCategoria
        -String nombre
        -String descripcion
        +getters()
        +setters()
    }

    class Libro {
        -int idLibro
        -String titulo
        -String autor
        -String editorial
        -int anioPublicacion
        -String isbn
        -int stockTotal
        -int stockDisponible
        -String ubicacionFisica
        -String portadaUrl
        -String pdfUrl
        -int idCategoria
        -String categoriaNombre
        +getters()
        +setters()
    }

    class Prestamo {
        -int idPrestamo
        -int idUsuario
        -int idLibro
        -Date fechaSolicitud
        -Date fechaPrestamo
        -Date fechaLimiteDevolucion
        -Date fechaDevolucionReal
        -String estado
        -String observaciones
        -String usuarioNombre
        -String libroTitulo
        +getters()
        +setters()
    }

    class ConexionBD {
        -String URL
        -String USER
        -String PASS
        +getConnection() Connection
    }

    class UsuarioDAO {
        +autenticar(correo, password) Usuario
        +registrar(Usuario u) boolean
        +listarTodos() List~Usuario~
        +obtenerPorId(id) Usuario
        +actualizarEstado(id, estado) boolean
    }

    class LibroDAO {
        +listarTodos() List~Libro~
        +listarDisponibles() List~Libro~
        +buscarPorFiltro(query, idCategoria) List~Libro~
        +obtenerPorId(id) Libro
        +insertar(Libro l) boolean
        +actualizar(Libro l) boolean
        +eliminar(id) boolean
        +actualizarStock(idLibro, cantidad) boolean
    }

    class PrestamoDAO {
        +solicitarPrestamo(Prestamo p) boolean
        +listarTodos() List~Prestamo~
        +listarPorUsuario(idUsuario) List~Prestamo~
        +aprobarPrestamo(idPrestamo) boolean
        +registrarDevolucion(idPrestamo, fechaDev) boolean
        +contarPrestamosActivos() int
    }

    Usuario "1" <-- "*" Prestamo : realiza
    Libro "1" <-- "*" Prestamo : es prestado en
    Categoria "1" <-- "*" Libro : clasifica
    UsuarioDAO ..> Usuario : gestiona
    LibroDAO ..> Libro : gestiona
    PrestamoDAO ..> Prestamo : gestiona
    UsuarioDAO ..> ConexionBD : usa
    LibroDAO ..> ConexionBD : usa
    PrestamoDAO ..> ConexionBD : usa
```

---

## 3. Modelo Entidad - Relación (MER)

```mermaid
erDiagram
    CATEGORIA ||--o{ LIBRO : contiene
    USUARIO ||--o{ PRESTAMO : solicita
    LIBRO ||--o{ PRESTAMO : incluye
    USUARIO ||--o{ SANCION : recibe

    CATEGORIA {
        int id_categoria PK
        varchar nombre
        varchar descripcion
    }

    LIBRO {
        int id_libro PK
        int id_categoria FK
        varchar titulo
        varchar autor
        varchar editorial
        int anio_publicacion
        varchar isbn
        int stock_total
        int stock_disponible
        varchar ubicacion_fisica
        varchar portada_url
        varchar pdf_url
        varchar estado
    }

    USUARIO {
        int id_usuario PK
        varchar nombre_completo
        varchar codigo_universitario
        varchar correo
        varchar password
        varchar rol
        varchar estado
        timestamp fecha_registro
    }

    PRESTAMO {
        int id_prestamo PK
        int id_usuario FK
        int id_libro FK
        date fecha_solicitud
        date fecha_prestamo
        date fecha_limite
        date fecha_devolucion
        varchar estado
        text observaciones
    }

    SANCION {
        int id_sancion PK
        int id_usuario FK
        int id_prestamo FK
        date fecha_inicio
        date fecha_fin
        decimal monto_multa
        varchar motivo
        varchar estado
    }
```
