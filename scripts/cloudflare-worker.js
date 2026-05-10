export default {
  async fetch(request, env) {
    const url = new URL(request.url);
    const key = url.pathname.slice(1); // e.g. "releases/penos-0.1.0.iso"

    if (request.method === "PUT") {
      // Basic check: You can add Supabase JWT verification here for extra security
      await env.OS_BUCKET.put(key, request.body);
      return new Response(`Put ${key} successfully!`, { status: 200 });
    }

    return new Response("Method not allowed", { status: 405 });
  }
};
