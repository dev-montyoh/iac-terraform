const MAINTENANCE_HTML = `${maintenance_html}`;

addEventListener('fetch', event => {
  event.respondWith(handleRequest(event.request));
});

async function handleRequest(request) {
  try {
    const response = await fetch(request);
    if (response.status < 500) {
      return response;
    }
    return new Response(MAINTENANCE_HTML, {
      status: 503,
      headers: { 'Content-Type': 'text/html; charset=utf-8' }
    });
  } catch (e) {
    return new Response(MAINTENANCE_HTML, {
      status: 503,
      headers: { 'Content-Type': 'text/html; charset=utf-8' }
    });
  }
}
