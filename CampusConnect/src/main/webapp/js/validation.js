/* ============================================
   validation.js — Register page validation
   ============================================ */

document.addEventListener('DOMContentLoaded', function () {
    const form = document.getElementById('registerForm');
    if (!form) return;

    // Live validation on blur
    form.querySelectorAll('input[type="text"], input[type="email"], input[type="password"]')
        .forEach(function (input) {
            input.addEventListener('blur', function () { validateField(this); });
            input.addEventListener('input', function () {
                if (this.classList.contains('input-error')) validateField(this);
            });
        });

    // Password strength on keyup
    var pwdInput = document.getElementById('password');
    if (pwdInput) {
        pwdInput.addEventListener('focus', function () {
            var bar = document.getElementById('passwordStrength');
            if (bar) bar.classList.add('active');
        });
        pwdInput.addEventListener('keyup', checkPasswordStrength);
        pwdInput.addEventListener('keyup', checkPasswordMatch);
    }

    var cpwdInput = document.getElementById('confirmPassword');
    if (cpwdInput) cpwdInput.addEventListener('keyup', checkPasswordMatch);

    // Submit
    form.addEventListener('submit', function (e) {
        if (!validateAll()) e.preventDefault();
    });
});

/* ── Validate all fields ── */
function validateAll() {
    var ok = true;
    var form = document.getElementById('registerForm');

    ['firstName', 'lastName', 'email', 'password', 'confirmPassword', 'college', 'pincode']
        .forEach(function (id) {
            var el = document.getElementById(id);
            if (el && !validateField(el)) ok = false;
        });

    // Gender
    var genders = form.querySelectorAll('input[name="gender"]');
    var genderPicked = Array.prototype.some.call(genders, function (r) { return r.checked; });
    if (!genderPicked) {
        showMsg('gender-error', 'Please select a gender.');
        ok = false;
    } else {
        hideMsg('gender-error');
    }

    // Terms
    var terms = document.getElementById('agreeTerms');
    if (terms && !terms.checked) {
        showMsg('terms-error', 'You must agree to the Terms of Use.');
        ok = false;
    } else {
        hideMsg('terms-error');
    }

    return ok;
}

/* ── Validate single field ── */
function validateField(input) {
    var v = input.value.trim();
    var id = input.id;
    var isOk = true;

    if (input.required && v === '') {
        setError(input, getLabel(id) + ' is required.');
        return false;
    }

    if (id === 'firstName' || id === 'lastName') {
        if (v && (v.length < 2 || v.length > 50)) {
            setError(input, 'Must be 2–50 characters.'); isOk = false;
        } else if (v && !/^[a-zA-Z\s'\-]+$/.test(v)) {
            setError(input, 'Only letters, spaces, hyphens, apostrophes.'); isOk = false;
        }
    }

    if (id === 'email' && v && !isValidEmail(v)) {
        setError(input, 'Enter a valid email address.'); isOk = false;
    }

    if (id === 'password') {
        if (v && v.length < 8) { setError(input, 'Min 8 characters.'); isOk = false; }
    }

    if (id === 'confirmPassword') {
        var pwd = document.getElementById('password');
        if (v && pwd && v !== pwd.value) { setError(input, 'Passwords do not match.'); isOk = false; }
    }

    if (id === 'pincode' && v && !/^\d{6}$/.test(v)) {
        setError(input, 'Must be exactly 6 digits.'); isOk = false;
    }

    if (isOk) clearError(input);
    return isOk;
}

/* ── Password strength ── */
function checkPasswordStrength() {
    var input = document.getElementById('password');
    var fill  = document.getElementById('strengthFill');
    var text  = document.getElementById('strengthText');
    if (!input || !fill || !text) return;

    var v = input.value;
    var score = 0;
    if (v.length >= 8)  score += 25;
    if (v.length >= 12) score += 25;
    if (/[a-z]/.test(v) && /[A-Z]/.test(v)) score += 25;
    if (/[0-9]/.test(v) || /[^a-zA-Z0-9]/.test(v)) score += 25;

    fill.style.width = score + '%';

    var levels = [
        { max: 25,  label: 'Too weak', color: '#EF4444' },
        { max: 50,  label: 'Weak',     color: '#F59E0B' },
        { max: 75,  label: 'Good',     color: '#EAB308' },
        { max: 101, label: 'Strong',   color: '#22C55E' }
    ];
    for (var i = 0; i < levels.length; i++) {
        if (score <= levels[i].max) {
            text.textContent = levels[i].label;
            fill.style.background = levels[i].color;
            break;
        }
    }
}

/* ── Password match indicator ── */
function checkPasswordMatch() {
    var pwd  = document.getElementById('password');
    var cpwd = document.getElementById('confirmPassword');
    var ind  = document.getElementById('passwordMatch');
    if (!pwd || !cpwd || !ind) return;

    if (!cpwd.value || !pwd.value) {
        ind.className = 'password-match-indicator';
        return;
    }
    if (pwd.value === cpwd.value) {
        ind.textContent = '✓ Passwords match';
        ind.className = 'password-match-indicator match';
        clearError(cpwd);
    } else {
        ind.textContent = '✗ Passwords do not match';
        ind.className = 'password-match-indicator mismatch';
    }
}

/* ── Toggle password visibility ── */
function togglePassword(inputId) {
    var input = document.getElementById(inputId);
    var btn   = event.currentTarget;
    if (!input) return;
    if (input.type === 'password') {
        input.type = 'text';
        btn.textContent = '🙈';
    } else {
        input.type = 'password';
        btn.textContent = '👁️';
    }
    event.preventDefault();
}

/* ── Helpers ── */
function setError(input, msg) {
    input.classList.add('input-error');
    input.classList.remove('input-success');
    var container = input.closest('.input-group') || input.parentElement;
    var existing  = container.parentElement.querySelector('.error-message');
    if (!existing) {
        var el = document.createElement('span');
        el.className = 'error-message show';
        container.parentElement.appendChild(el);
        existing = el;
    }
    existing.textContent = msg;
    existing.classList.add('show');
}

function clearError(input) {
    input.classList.remove('input-error');
    var container = input.closest('.input-group') || input.parentElement;
    var msg = container.parentElement.querySelector('.error-message');
    if (msg) msg.classList.remove('show');
}

function showMsg(id, text) {
    var el = document.getElementById(id);
    if (el) { el.textContent = text; el.classList.add('show'); }
}

function hideMsg(id) {
    var el = document.getElementById(id);
    if (el) el.classList.remove('show');
}

function isValidEmail(email) {
    return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email);
}

function getLabel(id) {
    var map = {
        firstName: 'First Name', lastName: 'Last Name',
        email: 'Email', password: 'Password',
        confirmPassword: 'Confirm Password',
        college: 'College', pincode: 'Pincode'
    };
    return map[id] || id;
}
