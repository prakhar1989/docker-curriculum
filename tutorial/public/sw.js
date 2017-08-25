let version = "0.01";

self.addEventListener("install", e => {
  let timestamp = Date.now();
  e.waitUntil(
    caches.open("dockercurriculum").then(cache => {
      return cache.addAll([
          `/`,
          `/index.html?timestamp=${timestamp}`,
      ]).then(() => self.skipWaiting());
    })
  );
});

self.addEventListener("fetch", event => {
  event.respondWith(
    caches.match(event.request, { ignoreSearch: true }).then(response => {
      return response || fetch(event.request);
    })
  );
});