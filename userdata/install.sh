#!/bin/bash
set -e

# Detect package manager and install nginx
if command -v yum >/dev/null 2>&1; then
  yum update -y
  if command -v amazon-linux-extras >/dev/null 2>&1; then
    amazon-linux-extras install nginx1 -y || yum install -y nginx
  else
    yum install -y nginx
  fi
  systemctl enable nginx
  systemctl start nginx

else
  apt-get update -y
  apt-get install -y nginx
  systemctl enable nginx
  systemctl start nginx
fi

# Find correct nginx docroot
if [ -d /usr/share/nginx/html ]; then
  DOCROOT="/usr/share/nginx/html"
else
  DOCROOT="/var/www/html"
fi

# Write your index file
cat > ${DOCROOT}/index.html <<'EOF'
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width,initial-scale=1" />
  <title>EC2 Webserver</title>
  <link rel="icon" type="image/x-icon" sizes="64x64" href="/mnt/data/favicon.ico" />

  <style>
    :root{
      --bg:#0b1220;
      --panel:#0f1724;
      --muted:#9aa4b2;
      --accent:#06b6d4;
      --white:#eef6fb;
      --radius:12px;
      --card-padding:20px;
      font-family: Inter, system-ui, -apple-system, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
    }

    * { box-sizing: border-box; }
    html,body { height:100%; margin:0; background: linear-gradient(180deg,#051228 0%, #07142a 100%); color:var(--white); -webkit-font-smoothing:antialiased; -moz-osx-font-smoothing:grayscale; }

    .wrap {
      min-height:100%;
      display:flex;
      align-items:center;
      justify-content:center;
      padding:28px;
    }

    .card {
      width:100%;
      max-width:840px;
      background: linear-gradient(180deg, rgba(255,255,255,0.02), rgba(255,255,255,0.01));
      border-radius:var(--radius);
      padding:var(--card-padding);
      border:1px solid rgba(255,255,255,0.03);
      box-shadow: 0 10px 30px rgba(2,6,23,0.6);
    }

    header { display:flex; gap:14px; align-items:center; }
    .logo {
      width:52px; height:52px; border-radius:10px;
      background: linear-gradient(180deg,#0ea5b8,#0891b2);
      display:flex; align-items:center; justify-content:center; font-weight:700; color:#042028;
      font-size:18px;
    }

    h1 { margin:0; font-size:20px; line-height:1.05; }
    p.lead { margin:10px 0 18px 0; color:var(--muted); font-size:15px; }

    .cols { display:grid; grid-template-columns: 1fr 260px; gap:18px; align-items:start; }
    .main { padding:14px; background:rgba(255,255,255,0.01); border-radius:10px; }
    .panel { padding:14px; background:rgba(255,255,255,0.01); border-radius:10px; }

    .muted { color:var(--muted); font-size:13px; }
    .mono { font-family: ui-monospace, SFMono-Regular, Menlo, Monaco, "Roboto Mono", monospace; font-size:13px; color:#dff8fb; background: rgba(255,255,255,0.01); padding:8px; border-radius:8px; overflow:auto; }

    .btn { display:inline-block; padding:8px 12px; border-radius:8px; background:var(--accent); color:#042028; font-weight:600; text-decoration:none; border:0; cursor:pointer; }

    footer { margin-top:16px; text-align:center; color:var(--muted); font-size:13px; }

    @media (max-width:760px){
      .cols { grid-template-columns:1fr; }
    }
  </style>
</head>
<body>
  <div class="wrap">
    <div class="card" role="main" aria-labelledby="title">
      <header>
        <div class="logo">NG</div>
        <div>
          <h1 id="title">EC2 Webserver</h1>
          <div class="muted">Provisioned by Terraform · nginx serving this page</div>
        </div>
      </header>

      <p class="lead">This minimal page is intended as a simple status/landing page for your instance. It uses a small, contained stylesheet and a tiny amount of JavaScript.</p>

      <div class="cols" aria-live="polite">
        <section class="main">
          <h2 style="margin-top:0;margin-bottom:8px;font-size:16px">Welcome</h2>
          <p class="muted">Hello — this instance was launched and provisioned automatically. Use the panel to the right for quick commands and the public IP (if available).</p>

          <div style="margin-top:14px">
            <div class="mono" id="info">Fetching info…</div>
          </div>
        </section>

        <aside class="panel">
          <h3 style="margin:0 0 8px 0">Quick commands</h3>
          <pre class="mono" style="margin:0">
sudo systemctl status nginx
curl -I http://localhost
sudo journalctl -u nginx -n 50
          </pre>
          <div style="margin-top:12px">
            <button class="btn" id="refresh">Refresh Info</button>
          </div>
        </aside>
      </div>

      <footer>&copy; <span id="year"></span> EC2 instance</footer>
    </div>
  </div>

  <script>
    // Minimal JS: fill current year, show simple runtime info, and allow manual refresh.
    document.getElementById('year').textContent = new Date().getFullYear();

    async function fetchMeta() {
      const infoEl = document.getElementById('info');
      infoEl.textContent = 'Fetching metadata...';
      try {
        const res = await fetch('http://169.254.169.254/latest/meta-data/public-ipv4', {cache:'no-store'});
        if (!res.ok) throw new Error('no metadata');
        const ip = await res.text();
        infoEl.textContent = 'Public IP: ' + ip;
      } catch (e) {
        infoEl.textContent = 'Public IP: not available (metadata unreachable)';
      }
    }

    document.getElementById('refresh').addEventListener('click', fetchMeta);
    // try once on load
    fetchMeta();
  </script>
</body>
</html>
EOF
