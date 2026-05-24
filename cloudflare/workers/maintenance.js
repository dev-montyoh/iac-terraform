const MAINTENANCE_HTML = `${maintenance_html}`;

export default {
  async fetch(request, env) {
    try {
      const response = await fetch(request);
      if (response.status < 500) {
        return response;
      }
      return new Response(MAINTENANCE_HTML, {
        status: 503,
        headers: { 'Content-Type': 'text/html; charset=utf-8' }
      });
    } catch {
      return new Response(MAINTENANCE_HTML, {
        status: 503,
        headers: { 'Content-Type': 'text/html; charset=utf-8' }
      });
    }
  }
};
