/* 任务农场 Service Worker — 离线缓存。
   首次联网时缓存页面与素材；之后离线也能秒开。
   GitHub API（看板数据）永不缓存，始终读最新。 */
const CACHE = 'farm-cache-v3';
const ASSETS = [
  './kanban-farm-idle.html',
  './farm-manifest.json',
  './farm-icon.svg',
  './farm-assets/mon_hamster.png',
  './farm-assets/mon_fox.png',
  './farm-assets/mon_dragon.png'
];

self.addEventListener('install', e => {
  e.waitUntil(caches.open(CACHE).then(c => c.addAll(ASSETS)).then(() => self.skipWaiting()));
});
self.addEventListener('activate', e => {
  e.waitUntil(
    caches.keys().then(ks => Promise.all(ks.filter(k => k !== CACHE).map(k => caches.delete(k))))
      .then(() => self.clients.claim())
  );
});
self.addEventListener('fetch', e => {
  const url = new URL(e.request.url);
  // 看板数据走网络、不缓存（保证只读到最新）
  if (url.hostname === 'api.github.com') return;
  if (e.request.method !== 'GET') return;
  e.respondWith(
    caches.match(e.request).then(hit =>
      hit || fetch(e.request).then(resp => {
        if (url.origin === location.origin) {
          const copy = resp.clone();
          caches.open(CACHE).then(c => c.put(e.request, copy));
        }
        return resp;
      }).catch(() => caches.match('./kanban-farm-idle.html'))
    )
  );
});
