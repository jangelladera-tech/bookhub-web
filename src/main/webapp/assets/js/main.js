// ==========================================================================
// BOOKHUB - SCRIPT JAVASCRIPT PRINCIPAL (UX INTERACTIONS & VALIDATIONS)
// ==========================================================================

document.addEventListener('DOMContentLoaded', () => {
    // Inicializar tooltips de Bootstrap si existen
    const tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
    tooltipTriggerList.map((tooltipTriggerEl) => new bootstrap.Tooltip(tooltipTriggerEl));

    // Confirmación de eliminación de libros
    const deleteButtons = document.querySelectorAll('.btn-confirm-delete');
    deleteButtons.forEach(button => {
        button.addEventListener('click', (e) => {
            const title = button.getAttribute('data-title') || 'este elemento';
            if (!confirm(`¿Estás seguro de que deseas eliminar permanentemente "${title}"?`)) {
                e.preventDefault();
            }
        });
    });

    // Cargar datos en Modal de Edición de Libro
    const editModal = document.getElementById('modalEditarLibro');
    if (editModal) {
        editModal.addEventListener('show.bs.modal', (event) => {
            const button = event.relatedTarget;
            document.getElementById('editIdLibro').value = button.getAttribute('data-id');
            document.getElementById('editTitulo').value = button.getAttribute('data-titulo');
            document.getElementById('editAutor').value = button.getAttribute('data-autor');
            document.getElementById('editEditorial').value = button.getAttribute('data-editorial') || '';
            document.getElementById('editAnio').value = button.getAttribute('data-anio') || '';
            document.getElementById('editIsbn').value = button.getAttribute('data-isbn') || '';
            document.getElementById('editCategoria').value = button.getAttribute('data-categoria');
            document.getElementById('editStockTotal').value = button.getAttribute('data-stock-total');
            document.getElementById('editStockDisponible').value = button.getAttribute('data-stock-disp');
            document.getElementById('editUbicacion').value = button.getAttribute('data-ubicacion') || '';
            document.getElementById('editPortada').value = button.getAttribute('data-portada') || '';
            document.getElementById('editPdf').value = button.getAttribute('data-pdf') || '';
            document.getElementById('editEstado').value = button.getAttribute('data-estado') || 'DISPONIBLE';
        });
    }

    // Modal de Solicitud de Préstamo Rápido desde Catálogo
    const prestamoModal = document.getElementById('modalSolicitarPrestamo');
    if (prestamoModal) {
        prestamoModal.addEventListener('show.bs.modal', (event) => {
            const button = event.relatedTarget;
            document.getElementById('prestamoIdLibro').value = button.getAttribute('data-id');
            document.getElementById('prestamoTituloLibro').textContent = button.getAttribute('data-titulo');
            document.getElementById('prestamoAutorLibro').textContent = button.getAttribute('data-autor');
            document.getElementById('prestamoUbicacion').textContent = button.getAttribute('data-ubicacion');
        });
    }
});
