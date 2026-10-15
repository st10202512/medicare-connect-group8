// Contact form submission (simulated)
function submitContact(event) {
  event.preventDefault();
  const msg = document.getElementById('contact-msg');
  msg.textContent = 'Thank you. Your message has been sent.';
  event.target.reset();
}

// Login validation (simulated)
function validateLogin(event) {
  event.preventDefault();
  const email = document.getElementById('login-email').value;
  const password = document.getElementById('login-password').value;
  const msg = document.getElementById('login-msg');

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

  msg.style.color = '#00897B';
  msg.textContent = 'Login successful. Redirecting to dashboard...';
}

// Google Sign-In placeholder
function googleSignIn() {
  const msg = document.getElementById('login-msg');
  msg.style.color = '#00897B';
  msg.textContent = 'Google Sign-In is available in the mobile app.';
}