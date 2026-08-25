(function () {
  function setBadge(env) {
    const el = document.getElementById('env-badge');
    el.textContent = env;
    el.className = 'badge badge--' + env.toLowerCase();
  }

  function formatUptime(seconds) {
    const h = Math.floor(seconds / 3600);
    const m = Math.floor((seconds % 3600) / 60);
    const s = seconds % 60;
    return [h, m, s].map((n) => String(n).padStart(2, '0')).join(':');
  }

  async function loadInfo() {
    try {
      const res = await fetch('/api/info', { cache: 'no-store' });
      const data = await res.json();

      setBadge(data.environment || 'unknown');
      document.getElementById('v-env').textContent = data.environment;
      document.getElementById('v-version').textContent = data.version;
      document.getElementById('v-sha').textContent = data.gitSha;
      document.getElementById('v-host').textContent = data.hostname;
      document.getElementById('v-region').textContent = data.region;
      document.getElementById('v-node').textContent = data.nodeVersion;
      document.getElementById('v-uptime').textContent = formatUptime(data.uptimeSeconds);
      document.getElementById('v-time').textContent = new Date(data.serverTime).toLocaleString();
    } catch (err) {
      setBadge('error');
      console.error('No se pudo cargar /api/info', err);
    }
  }

  loadInfo();
  setInterval(loadInfo, 5000);
})();
