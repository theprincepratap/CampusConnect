/**
 * CampusConnect - JavaScript Functionality
 */

document.addEventListener('DOMContentLoaded', function() {
    // Initialize all functionality
    initFormValidation();
    initMobileMenu();
    initAlertDismiss();
    initSmoothScrolling();
});

/**
 * Toggle Password Visibility
 * @param {string} inputId - ID of the password input field
 */
function togglePassword(inputId) {
    const input = document.getElementById(inputId);
    const icon = document.getElementById(inputId + '-toggle-icon');
    
    if (input.type === 'password') {
        input.type = 'text';
        if (icon) icon.textContent = '🔒';
    } else {
        input.type = 'password';
        if (icon) icon.textContent = '👁️';
    }
}

/**
 * Check Password Strength
 * Updates the password strength indicator
 */
function checkPasswordStrength() {
    const password = document.getElementById('password');
    const strengthFill = document.getElementById('strengthFill');
    const strengthText = document.getElementById('strengthText');
    
    if (!password || !strengthFill || !strengthText) return;
    
    const value = password.value;
    let strength = 0;
    let strengthLabel = 'Password strength';
    
    if (value.length === 0) {
        strengthFill.className = 'strength-fill';
        strengthText.className = 'strength-text';
        strengthText.textContent = strengthLabel;
        return;
    }
    
    // Length check
    if (value.length >= 8) strength++;
    if (value.length >= 12) strength++;
    
    // Character variety checks
    if (/[a-z]/.test(value)) strength++;
    if (/[A-Z]/.test(value)) strength++;
    if (/[0-9]/.test(value)) strength++;
    if (/[^a-zA-Z0-9]/.test(value)) strength++;
    
    // Determine strength level
    if (strength <= 2) {
        strengthFill.className = 'strength-fill weak';
        strengthText.className = 'strength-text weak';
        strengthLabel = 'Weak - Add more characters';
    } else if (strength <= 4) {
        strengthFill.className = 'strength-fill medium';
        strengthText.className = 'strength-text medium';
        strengthLabel = 'Medium - Add uppercase or special chars';
    } else {
        strengthFill.className = 'strength-fill strong';
        strengthText.className = 'strength-text strong';
        strengthLabel = 'Strong password';
    }
    
    strengthText.textContent = strengthLabel;
}

/**
 * Initialize Form Validation
 */
function initFormValidation() {
    // Login Form
    const loginForm = document.getElementById('loginForm');
    if (loginForm) {
        loginForm.addEventListener('submit', function(e) {
            const email = document.getElementById('email').value.trim();
            const password = document.getElementById('password').value;
            
            if (!isValidEmail(email)) {
                e.preventDefault();
                showError('Please enter a valid email address');
                return false;
            }
            
            if (password.length < 1) {
                e.preventDefault();
                showError('Please enter your password');
                return false;
            }
        });
    }
    
    // Registration Form
    const registerForm = document.getElementById('registerForm');
    if (registerForm) {
        registerForm.addEventListener('submit', function(e) {
            const fullName = document.getElementById('fullName').value.trim();
            const email = document.getElementById('email').value.trim();
            const password = document.getElementById('password').value;
            const confirmPassword = document.getElementById('confirmPassword').value;
            const college = document.getElementById('college').value.trim();
            const pincode = document.getElementById('pincode').value.trim();
            
            // Validate full name
            if (fullName.length < 2) {
                e.preventDefault();
                showError('Full name must be at least 2 characters');
                highlightField('fullName');
                return false;
            }
            
            // Validate email
            if (!isValidEmail(email)) {
                e.preventDefault();
                showError('Please enter a valid email address');
                highlightField('email');
                return false;
            }
            
            // Validate password length
            if (password.length < 8) {
                e.preventDefault();
                showError('Password must be at least 8 characters');
                highlightField('password');
                return false;
            }
            
            // Validate password strength
            if (!/[A-Z]/.test(password) || !/[a-z]/.test(password) || !/[0-9]/.test(password)) {
                e.preventDefault();
                showError('Password must contain uppercase, lowercase, and numbers');
                highlightField('password');
                return false;
            }
            
            // Validate password match
            if (password !== confirmPassword) {
                e.preventDefault();
                showError('Passwords do not match');
                highlightField('confirmPassword');
                return false;
            }
            
            // Validate college
            if (college.length < 2) {
                e.preventDefault();
                showError('Please enter your college name');
                highlightField('college');
                return false;
            }
            
            // Validate pincode
            if (!/^[0-9]{6}$/.test(pincode)) {
                e.preventDefault();
                showError('Please enter a valid 6-digit pincode');
                highlightField('pincode');
                return false;
            }
        });
    }
    
    // Profile Form
    const profileForm = document.getElementById('profileForm');
    if (profileForm) {
        profileForm.addEventListener('submit', function(e) {
            const fullName = document.getElementById('fullName').value.trim();
            const college = document.getElementById('college').value.trim();
            const pincode = document.getElementById('pincode').value.trim();
            
            if (fullName.length < 2) {
                e.preventDefault();
                showError('Full name must be at least 2 characters');
                highlightField('fullName');
                return false;
            }
            
            if (college.length < 2) {
                e.preventDefault();
                showError('Please enter your college name');
                highlightField('college');
                return false;
            }
            
            if (!/^[0-9]{6}$/.test(pincode)) {
                e.preventDefault();
                showError('Please enter a valid 6-digit pincode');
                highlightField('pincode');
                return false;
            }
        });
    }
    
    // Real-time validation for pincode fields
    const pincodeInputs = document.querySelectorAll('input[name="pincode"]');
    pincodeInputs.forEach(function(input) {
        input.addEventListener('input', function() {
            this.value = this.value.replace(/[^0-9]/g, '').slice(0, 6);
        });
    });
    
    // Real-time validation for email
    const emailInputs = document.querySelectorAll('input[type="email"]');
    emailInputs.forEach(function(input) {
        input.addEventListener('blur', function() {
            if (this.value && !isValidEmail(this.value.trim())) {
                this.style.borderColor = '#ef4444';
            } else {
                this.style.borderColor = '';
            }
        });
    });
}

/**
 * Toggle Mobile Menu
 */
function toggleMobileMenu() {
    const mobileMenu = document.getElementById('mobileMenu');
    const menuBtn = document.querySelector('.mobile-menu-btn');
    
    if (mobileMenu) {
        mobileMenu.classList.toggle('active');
        if (menuBtn) {
            menuBtn.classList.toggle('active');
        }
    }
}

/**
 * Initialize Mobile Menu
 */
function initMobileMenu() {
    // Close menu when clicking outside
    document.addEventListener('click', function(e) {
        const mobileMenu = document.getElementById('mobileMenu');
        const menuBtn = document.querySelector('.mobile-menu-btn');
        
        if (mobileMenu && mobileMenu.classList.contains('active')) {
            if (!mobileMenu.contains(e.target) && !menuBtn.contains(e.target)) {
                mobileMenu.classList.remove('active');
                menuBtn.classList.remove('active');
            }
        }
    });
}

/**
 * Initialize Alert Dismissal
 */
function initAlertDismiss() {
    const alerts = document.querySelectorAll('.alert');
    alerts.forEach(function(alert) {
        // Auto dismiss after 5 seconds
        setTimeout(function() {
            alert.style.animation = 'fadeOut 0.3s ease forwards';
            setTimeout(function() {
                alert.remove();
            }, 300);
        }, 5000);
        
        // Click to dismiss
        alert.addEventListener('click', function() {
            this.style.animation = 'fadeOut 0.3s ease forwards';
            setTimeout(() => this.remove(), 300);
        });
    });
}

/**
 * Initialize Smooth Scrolling
 */
function initSmoothScrolling() {
    document.querySelectorAll('a[href^="#"]').forEach(function(anchor) {
        anchor.addEventListener('click', function(e) {
            e.preventDefault();
            const target = document.querySelector(this.getAttribute('href'));
            if (target) {
                target.scrollIntoView({
                    behavior: 'smooth',
                    block: 'start'
                });
            }
        });
    });
}

/**
 * Validate Email Format
 * @param {string} email - Email address to validate
 * @returns {boolean} True if valid
 */
function isValidEmail(email) {
    const emailRegex = /^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$/;
    return emailRegex.test(email);
}

/**
 * Show Error Message
 * @param {string} message - Error message to display
 */
function showError(message) {
    // Remove existing client-side error
    const existingError = document.querySelector('.alert-client-error');
    if (existingError) existingError.remove();
    
    // Create error element
    const errorDiv = document.createElement('div');
    errorDiv.className = 'alert alert-error alert-client-error';
    errorDiv.innerHTML = `
        <span class="alert-icon">!</span>
        ${message}
    `;
    
    // Insert at top of form
    const form = document.querySelector('.auth-form, .profile-form');
    if (form) {
        form.insertBefore(errorDiv, form.firstChild);
        errorDiv.scrollIntoView({ behavior: 'smooth', block: 'center' });
    }
    
    // Auto dismiss
    setTimeout(function() {
        errorDiv.style.animation = 'fadeOut 0.3s ease forwards';
        setTimeout(function() {
            errorDiv.remove();
        }, 300);
    }, 5000);
}

/**
 * Highlight Invalid Field
 * @param {string} fieldId - ID of the field to highlight
 */
function highlightField(fieldId) {
    const field = document.getElementById(fieldId);
    if (field) {
        field.style.borderColor = '#ef4444';
        field.focus();
        
        // Reset on input
        field.addEventListener('input', function() {
            this.style.borderColor = '';
        }, { once: true });
    }
}

/**
 * Add fadeOut keyframe animation
 */
const style = document.createElement('style');
style.textContent = `
    @keyframes fadeOut {
        from {
            opacity: 1;
            transform: translateY(0);
        }
        to {
            opacity: 0;
            transform: translateY(-10px);
        }
    }
`;
document.head.appendChild(style);

/**
 * Dark Mode Toggle (Optional Feature)
 */
function toggleDarkMode() {
    document.documentElement.classList.toggle('dark-mode');
    const isDark = document.documentElement.classList.contains('dark-mode');
    localStorage.setItem('darkMode', isDark);
}

// Check for saved dark mode preference
if (localStorage.getItem('darkMode') === 'true') {
    document.documentElement.classList.add('dark-mode');
}

/**
 * Search/Filter Enhancement
 */
function debounce(func, wait) {
    let timeout;
    return function executedFunction(...args) {
        const later = () => {
            clearTimeout(timeout);
            func(...args);
        };
        clearTimeout(timeout);
        timeout = setTimeout(later, wait);
    };
}

// Apply debounce to search input if exists
const searchInput = document.querySelector('.filter-input-group input[name="pincode"]');
if (searchInput) {
    searchInput.addEventListener('input', debounce(function() {
        // Auto-submit form after user stops typing (optional)
        // const form = this.closest('form');
        // if (this.value.length === 6) form.submit();
    }, 500));
}

console.log('CampusConnect JavaScript loaded successfully.');
