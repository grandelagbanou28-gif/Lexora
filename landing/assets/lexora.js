(function () {
  document.querySelectorAll('.year').forEach(function (el) {
    el.textContent = new Date().getFullYear();
  });

  var contactForm = document.getElementById('contactForm');
  if (contactForm) {
    contactForm.addEventListener('submit', function (e) {
      e.preventDefault();
      var name = document.getElementById('name').value.trim();
      var subject = document.getElementById('subject').value.trim();
      var message = document.getElementById('message').value.trim();
      var email = document.getElementById('email') && document.getElementById('email').value.trim();
      var s = 'subject=' + encodeURIComponent(subject || 'Contact Lexora') +
        '&body=' + encodeURIComponent((name ? 'Bonjour, je suis ' + name + '.\n\n' : '') + message + (email ? '\n\nRépondre à : ' + email : ''));
      window.location.href = 'mailto:grandelagbanou28@gmail.com?' + s;
    });
  }
})();