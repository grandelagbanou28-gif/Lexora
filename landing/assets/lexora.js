(function () {
  'use strict';

  var root = document.documentElement;

  /* ---------- Footer year ---------- */
  document.querySelectorAll('.year').forEach(function (el) {
    el.textContent = new Date().getFullYear();
  });

  /* ---------- Sticky nav state ---------- */
  var nav = document.querySelector('nav.site');
  function onScrollNav() {
    if (nav) nav.classList.toggle('scrolled', window.scrollY > 8);
  }
  onScrollNav();

  /* ---------- Mobile menu ---------- */
  var burger = document.getElementById('navBurger');
  var links = document.getElementById('navLinks');
  if (burger && links) {
    burger.addEventListener('click', function () {
      links.classList.toggle('open');
      burger.setAttribute('aria-expanded', links.classList.contains('open'));
    });
    links.querySelectorAll('a').forEach(function (a) {
      a.addEventListener('click', function () { links.classList.remove('open'); });
    });
  }

  /* ---------- Active nav link ---------- */
  var path = window.location.pathname.replace(/\/+$/, '');
  var map = [
    ['blog/', 'blog'],
    ['a-propos.html', 'a-propos'],
    ['faq.html', 'faq'],
    ['telecharger.html', 'telecharger'],
    ['contact.html', 'contact'],
    ['index.html', 'index']
  ];
  var found = null;
  for (var i = 0; i < map.length; i++) {
    if (path.indexOf(map[i][0]) !== -1) { found = map[i][1]; break; }
  }
  if (path === '' || path.split('/').pop() === '' || found === 'index') found = 'index';
  if (!found) found = 'index';
  document.querySelectorAll('.nav-links a[data-page]').forEach(function (a) {
    if (a.getAttribute('data-page') === found) a.classList.add('active');
  });

  /* ---------- Reveal on scroll ---------- */
  var revealEls = document.querySelectorAll('.reveal');
  if ('IntersectionObserver' in window) {
    var io = new IntersectionObserver(function (entries) {
      entries.forEach(function (e) {
        if (e.isIntersecting) { e.target.classList.add('in'); io.unobserve(e.target); }
      });
    }, { threshold: 0.12, rootMargin: '0px 0px -40px 0px' });
    revealEls.forEach(function (el) { io.observe(el); });
  } else {
    revealEls.forEach(function (el) { el.classList.add('in'); });
  }

  /* ---------- Counters ---------- */
  var counters = document.querySelectorAll('[data-count]');
  function animateCount(el) {
    var target = parseFloat(el.getAttribute('data-count'));
    var suffix = el.getAttribute('data-suffix') || '';
    var dur = 1100, start = null;
    function step(ts) {
      if (!start) start = ts;
      var p = Math.min((ts - start) / dur, 1);
      var eased = 1 - Math.pow(1 - p, 3);
      el.textContent = Math.round(target * eased) + suffix;
      if (p < 1) requestAnimationFrame(step);
    }
    requestAnimationFrame(step);
  }
  if ('IntersectionObserver' in window) {
    var cio = new IntersectionObserver(function (entries) {
      entries.forEach(function (e) {
        if (e.isIntersecting) { animateCount(e.target); cio.unobserve(e.target); }
      });
    }, { threshold: 0.5 });
    counters.forEach(function (el) { cio.observe(el); });
  } else {
    counters.forEach(animateCount);
  }

  /* ---------- Back to top ---------- */
  var btt = document.getElementById('backToTop');
  function onScroll() {
    if (btt) btt.classList.toggle('show', window.scrollY > 500);
  }
  onScroll();
  if (btt) btt.addEventListener('click', function () { window.scrollTo({ top: 0, behavior: 'smooth' }); });

  window.addEventListener('scroll', function () { onScrollNav(); onScroll(); }, { passive: true });

  /* ---------- Contact form -> mailto ---------- */
  var contactForm = document.getElementById('contactForm');
  if (contactForm) {
    contactForm.addEventListener('submit', function (e) {
      e.preventDefault();
      var g = function (id) { var el = document.getElementById(id); return el ? el.value.trim() : ''; };
      var name = g('name'), subject = g('subject'), message = g('message'), email = g('email');
      var body = (name ? 'Bonjour, je suis ' + name + '.' : 'Bonjour.') + '\n\n' + message +
        (email ? '\n\nRépondre à : ' + email : '');
      window.location.href = 'mailto:grandelagbanou28@gmail.com?subject=' +
        encodeURIComponent(subject || 'Contact Lexora') + '&body=' + encodeURIComponent(body);
    });
  }

  /* ---------- Newsletter -> mailto ---------- */
  var nlForm = document.getElementById('newsletterForm');
  if (nlForm) {
    nlForm.addEventListener('submit', function (e) {
      e.preventDefault();
      var email = document.getElementById('nlEmail');
      if (!email || !email.value.trim()) return;
      window.location.href = 'mailto:grandelagbanou28@gmail.com?subject=' +
        encodeURIComponent('Inscription newsletter Lexora') + '&body=' +
        encodeURIComponent('Bonjour, je souhaite recevoir la newsletter Lexora.\nMon email : ' + email.value.trim());
    });
  }

  /* ---------- Copy share link ---------- */
  document.querySelectorAll('.copy-link').forEach(function (btn) {
    btn.addEventListener('click', function () {
      var target = btn.getAttribute('data-copy') || window.location.href;
      var done = function () {
        var old = btn.textContent;
        btn.textContent = 'Lien copié ✓';
        setTimeout(function () { btn.textContent = old; }, 1800);
      };
      navigator.clipboard ? navigator.clipboard.writeText(target).then(done) : done();
    });
  });

  /* ---------- Service worker (hors-ligne) ---------- */
  if ('serviceWorker' in navigator && location.protocol === 'https:') {
    navigator.serviceWorker.register('/service-worker.js').catch(function () {});
  }
})();