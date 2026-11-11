// Contact form submission (simulated)
function submitContact(event) {
  event.preventDefault();
  const msg = document.getElementById('contact-msg');
  msg.textContent = 'Thank you. Your message has been sent successfully.';
  msg.style.color = '#00897B';
  event.target.reset();
}

// Login validation & Role-based redirect
function validateLogin(event) {
  event.preventDefault();
  const email = document.getElementById('login-email').value;
  const password = document.getElementById('login-password').value;
  const role = document.getElementById('login-role').value;
  const msg = document.getElementById('login-msg');

  // Basic validation
  if (!email.includes('@')) {
    msg.style.color = 'red';
    msg.textContent = 'Please enter a valid email address.';
    return;
  }

  if (password.length < 6) {
    msg.style.color = 'red';
    msg.textContent = 'Password must be at least 6 characters.';
    return;
  }

  // Simulate successful login
  msg.style.color = '#00897B';
  msg.textContent = 'Login successful. Redirecting...';

  // Save session to localStorage
  localStorage.setItem('userRole', role);
  localStorage.setItem('userEmail', email);

  // Redirect after 1 second
  setTimeout(() => {
    if (role === 'admin') {
      window.location.href = 'admin.html';
    } else if (role === 'doctor') {
      window.location.href = 'doctor.html';
    } else {
      window.location.href = 'patient.html';
    }
  }, 1000);
}

// Logout function
function logout() {
  localStorage.removeItem('userRole');
  localStorage.removeItem('userEmail');
  window.location.href = 'login.html';
}

// Check session on protected pages
function checkSession(requiredRole) {
  const role = localStorage.getItem('userRole');
  if (role !== requiredRole) {
    window.location.href = 'login.html';
  }
}

// Display user email on dashboard
function displayUserEmail(elementId) {
  const email = localStorage.getItem('userEmail');
  const el = document.getElementById(elementId);
  if (el && email) {
    el.textContent = email;
  }
}