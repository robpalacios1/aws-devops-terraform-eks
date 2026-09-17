'use strict';

const express = require('express');
const os = require('os');
const path = require('path');

const app = express();

const PORT = process.env.PORT || 3000;
const APP_ENV = process.env.APP_ENV || 'local';
const APP_VERSION = process.env.APP_VERSION || 'dev';
const GIT_SHA = process.env.GIT_SHA || 'unknown';
const AWS_REGION = process.env.AWS_REGION || process.env.AWS_DEFAULT_REGION || 'n/a';
const startedAt = new Date();

// A tiny flag that flips to true a moment after boot, to demonstrate a
// realistic readiness probe (e.g. waiting for a DB connection, cache warmup, etc).
let isReady = false;
setTimeout(() => {
  isReady = true;
}, 2000);

app.disable('x-powered-by');
app.use(express.static(path.join(__dirname, '..', 'public')));

// Liveness probe: process is up and responding.
app.get('/health', (req, res) => {
  res.status(200).json({ status: 'ok' });
});

// Readiness probe: process is up AND ready to receive traffic.
app.get('/ready', (req, res) => {
  if (isReady) {
    return res.status(200).json({ status: 'ready' });
  }
  return res.status(503).json({ status: 'starting' });
});

// Info endpoint consumed by the frontend to show where/what is deployed.
app.get('/api/info', (req, res) => {
  res.status(200).json({
    environment: APP_ENV,
    version: APP_VERSION,
    gitSha: GIT_SHA,
    hostname: os.hostname(),
    region: AWS_REGION,
    platform: os.platform(),
    arch: os.arch(),
    nodeVersion: process.version,
    uptimeSeconds: Math.round(process.uptime()),
    startedAt: startedAt.toISOString(),
    serverTime: new Date().toISOString(),
  });
});

app.get('*', (req, res, next) => {
  if (req.path.startsWith('/api') || req.path === '/health' || req.path === '/ready') {
    return next();
  }
  res.sendFile(path.join(__dirname, '..', 'public', 'index.html'));
});

const server = app.listen(PORT, () => {
  console.log(`[devops-demo-app] env=${APP_ENV} version=${APP_VERSION} listening on port ${PORT}`);
});

// Graceful shutdown so Kubernetes/EKS pods drain connections cleanly on SIGTERM.
function shutdown(signal) {
  console.log(`[devops-demo-app] received ${signal}, shutting down gracefully...`);
  server.close(() => {
    console.log('[devops-demo-app] closed all connections, bye.');
    process.exit(0);
  });
  // Force-exit if something hangs.
  setTimeout(() => process.exit(1), 10000).unref();
}

process.on('SIGTERM', () => shutdown('SIGTERM'));
process.on('SIGINT', () => shutdown('SIGINT'));
