const { app, BrowserWindow, dialog, shell } = require('electron');
const path = require('node:path');
const http = require('node:http');
const fs = require('node:fs');

const logFile = path.join(app.getPath('temp'), 'open-kugou.log');
function desktopLog(...args) {
  try { fs.appendFileSync(logFile, `[${new Date().toISOString()}] ${args.join(' ')}\n`); } catch {}
}

// Playback URLs are resolved asynchronously. Without this Chromium treats
// the later audio.play() call as autoplay rather than the original click.
app.commandLine.appendSwitch('autoplay-policy', 'no-user-gesture-required');

let service;
let mainWindow;

function findFreePort() {
  return new Promise((resolve, reject) => {
    const probe = http.createServer();
    probe.once('error', reject);
    probe.listen(0, '127.0.0.1', () => {
      const { port } = probe.address();
      probe.close(() => resolve(port));
    });
  });
}

async function startLocalService() {
  const port = await findFreePort();
  process.env.HOST = '127.0.0.1';
  process.env.PORT = String(port);
  process.env.KUGOU_ENV_PATH = path.join(app.getAppPath(), '.env');
  desktopLog('service config', JSON.stringify({ appPath: app.getAppPath(), envPath: process.env.KUGOU_ENV_PATH, platform: process.env.platform }));
  const { startService } = require(path.join(__dirname, '..', 'server.js'));
  service = await startService();
  return port;
}

async function createWindow() {
  const port = await startLocalService();
  mainWindow = new BrowserWindow({
    width: 1440,
    height: 920,
    minWidth: 1000,
    minHeight: 700,
    title: 'Open-Kugou',
    backgroundColor: '#f7f5f8',
    autoHideMenuBar: true,
    webPreferences: {
      contextIsolation: true,
      nodeIntegration: false,
    },
  });
  mainWindow.webContents.setWindowOpenHandler(({ url }) => {
    if (/^https?:/i.test(url)) shell.openExternal(url);
    return { action: 'deny' };
  });
  await mainWindow.loadURL(`http://127.0.0.1:${port}/`);
  desktopLog('window loaded', `http://127.0.0.1:${port}/`);
}

app.whenReady().then(() => createWindow()).catch((error) => {
  dialog.showErrorBox('Open-Kugou 启动失败', error.stack || error.message);
  app.quit();
});

app.on('window-all-closed', () => {
  if (process.platform !== 'darwin') app.quit();
});

app.on('before-quit', () => {
  if (service?.service) service.service.close();
});

app.on('activate', () => {
  if (BrowserWindow.getAllWindows().length === 0) createWindow();
});
