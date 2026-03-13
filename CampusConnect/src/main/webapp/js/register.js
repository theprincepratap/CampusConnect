/**
 * Register Page - Form Validation & Interactions
 */

document.addEventListener('DOMContentLoaded', function() {
    initializeRegisterForm();
});

/**
 * Initialize Register Form
 */
function initializeRegisterForm() {
    const registerForm = document.getElementById('registerForm');
    
    if (registerForm) {
        // Form submission validation
        registerForm.addEventListener('submit', function(e) {
            if (!validateAllFields()) {
                e.preventDefault();
            }
        });

        // Real-time validation
        const inputs = registerForm.querySelectorAll('input[type="text"], input[type="email"], input[type="password"]');
        inputs.forEach(input => {
            input.addEventListener('blur', function() {
                validateField(this);
            });

            input.addEventListener('input', function() {
                if (this.classList.contains('error')) {
                    validateField(this);
                }
            });
        });

        // Password strength check on keyup
        const passwordInput = document.getElementById('password');
        if (passwordInput) {
            passwordInput.addEventListener('keyup', checkPasswordStrength);
        }

        // Password match check on keyup
        const confirmPasswordInput = document.getElementById('confirmPassword');
        if (confirmPasswordInput) {
            confirmPasswordInput.addEventListener('keyup', checkPasswordMatch);
        }

        // Show password strength on focus
        if (passwordInput) {
            passwordInput.addEventListener('focus', function() {
                const strength = document.getElementById('passwordStrength');
                if (strength) {
                    strength.classList.add('active');
                }
            });
        }
    }
}

/**
 * Validate All Fields
 */
function validateAllFields() {
    const registerForm = document.getElementById('registerForm');
    if (!registerForm) return false;

    const inputs = registerForm.querySelectorAll('input[type="text"], input[type="email"], input[type="password"]');
    let isValid = true;

    // Clear previous errors
    inputs.forEach(input => {
        removeErrorMessage(input);
        input.classList.remove('error');
    });

    // Validate each field
    inputs.forEach(input => {
        if (!validateField(input)) {
            isValid = false;
        }
    });

    // Validate gender selection
    const genderOptions = registerForm.querySelectorAll('input[name="gender"]');
    const genderSelected = Array.from(genderOptions).some(option => option.checked);
    if (!genderSelected) {
        showError('gender', 'Please select a gender');
        isValid = false;
    }

    // Validate terms checkbox
    const agreeTerms = document.getElementById('agreeTerms');
    if (agreeTerms && !agreeTerms.checked) {
        showError('agreeTerms', 'Please agree to Terms of Use and Conditions');
        isValid = false;
    }

    // Validate password match
    const password = document.getElementById('password');
    const confirmPassword = document.getElementById('confirmPassword');
    if (password && confirmPassword && password.value !== confirmPassword.value) {
        showError('confirmPassword', 'Passwords do not match');
        isValid = false;
    }

    return isValid;
}

/**
 * Validate Individual Field
 */
function validateField(input) {
    const fieldId = input.id;
    const fieldValue = input.value.trim();
    let isValid = true;

    // Check if field is required and empty
    if (input.required && !fieldValue) {
        showError(fieldId, `${getFieldLabel(fieldId)} is required`);
        return false;
    }

    // Field-specific validation
    switch(fieldId) {
        case 'firstName':
        case 'lastName':
            if (fieldValue && (fieldValue.length < 2 || fieldValue.length > 50)) {
                showError(fieldId, 'Name must be between 2 and 50 characters');
                isValid = false;
            } else if (fieldValue && !/^[a-zA-Z\s'-]+$/.test(fieldValue)) {
                showError(fieldId, 'Name can only contain letters, spaces, hyphens, and apostrophes');
                isValid = false;
            }
            break;

        case 'email':
            if (fieldValue && !isValidEmail(fieldValue)) {
                showError(fieldId, 'Please enter a valid email address');
                isValid = false;
            }
            break;

        case 'password':
            if (fieldValue && fieldValue.length < 8) {
                showError(fieldId, 'Password must be at least 8 characters long');
                isValid = false;
            } else if (fieldValue && !hasPasswordStrength(fieldValue)) {
                showError(fieldId, 'Password should contain letters, numbers, and special characters');
                isValid = false;
            }
            break;

        case 'confirmPassword':
            const password = document.getElementById('password');
            if (fieldValue && password.value !== fieldValue) {
                showError(fieldId, 'Passwords do not match');
                isValid = false;
            }
            break;

        case 'college':
            if (fieldValue && fieldValue.length < 2) {
                showError(fieldId, 'Please select or enter a valid college name');
                isValid = false;
            }
            break;

        case 'pincode':
            if (fieldValue && !/^\d{6}$/.test(fieldValue)) {
                showError(fieldId, 'Pincode must be exactly 6 digits');
                isValid = false;
            }
            break;
    }

    if (isValid) {
        input.classList.remove('error');
        removeErrorMessage(input);
    } else {
        input.classList.add('error');
    }

    return isValid;
}

/**
 * Check Email Validity
 */
function isValidEmail(email) {
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return emailRegex.test(email);
}

/**
 * Check Password Strength
 */
function checkPasswordStrength() {
    const passwordInput = document.getElementById('password');
    const strength = document.getElementById('passwordStrength');
    const fill = document.getElementById('strengthFill');
    const text = document.getElementById('strengthText');

    if (!passwordInput || !strength || !fill) return;

    const password = passwordInput.value;
    strength.classList.add('active');

    let strength_value = 0;
    
    if (password.length >= 8) strength_value += 25;
    if (password.length >= 12) strength_value += 25;
    if (/[a-z]/.test(password) && /[A-Z]/.test(password)) strength_value += 25;
    if (/[0-9]/.test(password)) strength_value += 25;

    fill.style.width = strength_value + '%';

    // Update strength text and color
    if (strength_value < 25) {
        text.textContent = 'Too weak';
        fill.style.background = 'linear-gradient(90deg, #ef4444, #f87171)';
    } else if (strength_value < 50) {
        text.textContent = 'Weak';
        fill.style.background = 'linear-gradient(90deg, #f59e0b, #fbbf24)';
    } else if (strength_value < 75) {
        text.textContent = 'Good';
        fill.style.background = 'linear-gradient(90deg, #eab308, #facc15)';
    } else {
        text.textContent = 'Strong';
        fill.style.background = 'linear-gradient(90deg, #10b981, #6ee7b7)';
    }
}

/**
 * Check Password Has Minimum Strength Requirements
 */
function hasPasswordStrength(password) {
    const hasLetter = /[a-zA-Z]/.test(password);
    const hasNumber = /[0-9]/.test(password);
    const hasSpecial = /[!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?]/.test(password);
    
    // At least 2 out of 3 requirements
    const requirementsMet = [hasLetter, hasNumber, hasSpecial].filter(Boolean).length;
    return requirementsMet >= 2;
}

/**
 * Check Password Match
 */
function checkPasswordMatch() {
    const password = document.getElementById('password');
    const confirmPassword = document.getElementById('confirmPassword');
    const matchIndicator = document.getElementById('passwordMatch');

    if (!password || !confirmPassword || !matchIndicator) return;

    if (confirmPassword.value === '' || password.value === '') {
        matchIndicator.classList.remove('match', 'mismatch');
        return;
    }

    if (password.value === confirmPassword.value) {
        matchIndicator.textContent = '✓ Passwords match';
        matchIndicator.classList.add('match');
        matchIndicator.classList.remove('mismatch');
        confirmPassword.classList.remove('error');
        removeErrorMessage(confirmPassword);
    } else {
        matchIndicator.textContent = '✗ Passwords do not match';
        matchIndicator.classList.add('mismatch');
        matchIndicator.classList.remove('match');
    }
}

/**
 * Toggle Password Visibility
 */
function togglePassword(inputId) {
    const input = document.getElementById(inputId);
    const button = event.currentTarget;

    if (!input) return;

    if (input.type === 'password') {
        input.type = 'text';
        button.textContent = '🙈';
    } else {
        input.type = 'password';
        button.textContent = '👁️';
    }

    event.preventDefault();
}

/**
 * Show Error Message
 */
function showError(fieldId, message) {
    const field = document.getElementById(fieldId);
    if (!field) return;

    field.classList.add('error');

    // Remove old error message
    removeErrorMessage(field);

    // Create and insert error message
    const errorDiv = document.createElement('div');
    errorDiv.className = 'error-message show';
    errorDiv.textContent = message;
    field.parentElement.appendChild(errorDiv);
}

/**
 * Remove Error Message
 */
function removeErrorMessage(field) {
    if (!field) return;

    const errorMessage = field.parentElement.querySelector('.error-message');
    if (errorMessage) {
        errorMessage.remove();
    }
}

/**
 * Get Field Label for Error Messages
 */
function getFieldLabel(fieldId) {
    const labels = {
        'firstName': 'First Name',
        'lastName': 'Last Name',
        'email': 'Email Address',
        'password': 'Password',
        'confirmPassword': 'Confirm Password',
        'college': 'College/University',
        'pincode': 'Pincode',
        'gender': 'Gender'
    };
    
    return labels[fieldId] || fieldId;
}
