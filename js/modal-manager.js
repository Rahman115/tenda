// modal-manager.js
class ModalManager {
    constructor() {
        this.init();
    }
    
    init() {
        // Close modal ketika klik di luar content
        this.bindOutsideClick();
        
        // Close modal dengan ESC key
        this.bindEscapeKey();
    }

// Open modal by ID
    open(modalId) {
        const modal = document.getElementById(modalId);
        if (modal) {
            modal.style.display = 'flex';
            modal.setAttribute('aria-hidden', 'false');
            
            // Trigger event untuk hook functionality
            this.triggerEvent('modal:open', { modalId, modal });
        }
    }

    // Close modal by ID
    close(modalId) {
        const modal = document.getElementById(modalId);
        if (modal) {
            modal.style.display = 'none';
            modal.setAttribute('aria-hidden', 'true');
            
            // Reset form dalam modal
            const form = modal.querySelector('form');
            if (form) form.reset();
            
            this.triggerEvent('modal:close', { modalId, modal });
        }
    }

    // Close all modals
    closeAll() {
        document.querySelectorAll('.modal').forEach(modal => {
            modal.style.display = 'none';
            modal.setAttribute('aria-hidden', 'true');
        });
    }

    // Toggle modal
    toggle(modalId) {
        const modal = document.getElementById(modalId);
        if (modal) {
            if (modal.style.display === 'flex') {
                this.close(modalId);
            } else {
                this.open(modalId);
            }
        }
    }

    // Populate form data in modal
    populateForm(modalId, data, prefix = '') {
        const modal = document.getElementById(modalId);
        if (!modal) return;

        Object.keys(data).forEach(key => {
            const element = modal.querySelector(`#${prefix}${key}`);
            if (element) {
                if (element.type === 'checkbox' || element.type === 'radio') {
                    element.checked = data[key];
                } else {
                    element.value = data[key];
                }
            }
        });
    }

    // Show loading state in modal
    setLoading(modalId, isLoading) {
        const modal = document.getElementById(modalId);
        if (!modal) return;

        const buttons = modal.querySelectorAll('button[type="submit"]');
        buttons.forEach(button => {
            if (isLoading) {
                button.disabled = true;
                button.innerHTML = 'Loading...';
            } else {
                button.disabled = false;
                button.innerHTML = button.getAttribute('data-original-text') || 'Simpan';
            }
        });
    }

    // Private methods
    bindOutsideClick() {
        document.addEventListener('click', (e) => {
            if (e.target.classList.contains('modal')) {
                this.close(e.target.id);
            }
        });
    }

    bindEscapeKey() {
        document.addEventListener('keydown', (e) => {
            if (e.key === 'Escape') {
                this.closeAll();
            }
        });
    }

    triggerEvent(eventName, detail) {
        const event = new CustomEvent(eventName, { detail });
        document.dispatchEvent(event);
    }

    // Utility untuk membuat modal handler otomatis
    static autoBind() {
        // Bind close buttons
        document.querySelectorAll('.modal .close').forEach(closeBtn => {
            closeBtn.addEventListener('click', (e) => {
                const modal = e.target.closest('.modal');
                if (modal) modalManager.close(modal.id);
            });
        });

        // Bind modal triggers
        document.querySelectorAll('[data-modal-target]').forEach(trigger => {
            trigger.addEventListener('click', (e) => {
                const modalId = e.target.getAttribute('data-modal-target');
                modalManager.open(modalId);
            });
        });
    }
}

// Global instance
const modalManager = new ModalManager();

// Auto initialize ketika DOM ready
document.addEventListener('DOMContentLoaded', () => {
    ModalManager.autoBind();
});