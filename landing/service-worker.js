'use strict';

var CACHE = 'lexora-v1';
var BASE = self.location.pathname.replace(/\/service-worker\.js$/, '').replace(/\/+$/, '');

var CORE = [
  BASE + '/',
  BASE + '/index.html',
  BASE + '/assets/lexora.css',
  BASE + '/assets/lexora.js',
  BASE + '/assets/favicon.svg',
  BASE + '/Icon-512.png'
];

self.addEventListener('install', function (event) {
  event.waitUntil(
    caches.open(CACHE).then(function (cache) {
      return cache.addAll(CORE);
    }).then(function () { return self.skipWaiting(); })
  );
});

self.addEventListener('activate', function (event) {
  event.waitUntil(
    caches.keys().then(function (keys) {
      return Promise.all(keys.filter(function (k) { return k !== CACHE; }).map(function (k) { return caches.delete(k); }));
    }).then(function () { return self.clients.claim(); })
  );
});

self.addEventListener('fetch', function (event) {
  var req = event.request;
  if (req.method !== 'GET') return;

  var url = new URL(req.url);
  if (url.origin !== self.location.origin) return;

  event.respondWith(
    caches.match(req).then(function (cached) {
      var fetchPromise = fetch(req).then(function (res) {
        if (res && res.ok) {
          var copy = res.clone();
          caches.open(CACHE).then(function (cache) { cache.put(req, copy); });
        }
        return res;
      }).catch(function () {});
      return cached || fetchPromise;
    })
  );
});