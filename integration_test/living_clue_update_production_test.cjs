const { chromium } = require('playwright');

const targetUrl =
  process.env.E2E_URL ||
  'https://educacaoonlife.gpedu.com.br/#/living_clues/update?id=8';
const email = process.env.E2E_EMAIL || 'admin@admin.com';
const password = process.env.E2E_PASSWORD || 'uu2admin';
const screenshotPath =
  process.env.E2E_SCREENSHOT || '/tmp/uniusp-living-clue-update-8.png';

async function enableFlutterAccessibility(page) {
  const button = page.getByRole('button', { name: 'Enable accessibility' });
  if (await button.count()) {
    await button.evaluate((element) => element.click());
    await page.waitForTimeout(1000);
  }
}

(async () => {
  const events = [];
  const browser = await chromium.launch({
    executablePath: process.env.CHROME_PATH || '/usr/bin/google-chrome',
    headless: true,
    args: ['--no-sandbox'],
  });
  const page = await browser.newPage({ viewport: { width: 1440, height: 1000 } });

  page.on('console', (message) => {
    if (['error', 'warning', 'warn'].includes(message.type())) {
      events.push(`console.${message.type()}: ${message.text()}`);
    }
  });
  page.on('pageerror', (error) => {
    events.push(`pageerror: ${error.stack || error.message}`);
  });
  page.on('response', (response) => {
    if (response.status() >= 400) {
      events.push(`http ${response.status()}: ${response.url()}`);
    }
  });

  try {
    await page.goto(targetUrl, { waitUntil: 'networkidle', timeout: 60000 });
    await page.waitForTimeout(3000);
    await enableFlutterAccessibility(page);

    const inputs = page.locator('input');
    if ((await inputs.count()) >= 2) {
      await inputs.nth(0).fill(email);
      await inputs.nth(1).fill(password);
      await page.getByText('Entrar', { exact: true }).click();
    } else if (page.url().includes('/login')) {
      // Flutter CanvasKit pode não expor a árvore semântica em headless.
      // As coordenadas são relativas ao viewport fixo configurado acima.
      await page.mouse.click(720, 405);
      await page.keyboard.type(email);
      await page.mouse.click(720, 477);
      await page.keyboard.type(password);
      await page.mouse.click(720, 574);
    }

    await page.waitForTimeout(8000);
    await page.goto(targetUrl, { waitUntil: 'networkidle', timeout: 60000 });
    await page.waitForTimeout(3000);
    await enableFlutterAccessibility(page);

    await page.waitForTimeout(12000);
    await page.screenshot({ path: screenshotPath, fullPage: true });

    const visibleText = (await page.locator('body').innerText()).trim();
    console.log(JSON.stringify({
      targetUrl,
      finalUrl: page.url(),
      title: await page.title(),
      visibleText,
      screenshotPath,
      events,
    }, null, 2));

    const fatalEvents = events.filter((event) =>
      event.startsWith('pageerror:') ||
      event.startsWith('console.error:') ||
      event.startsWith('http '));
    if (page.url().includes('/login') || fatalEvents.length > 0) {
      process.exitCode = 1;
    }
  } finally {
    await browser.close();
  }
})().catch((error) => {
  console.error(error.stack || error);
  process.exitCode = 1;
});
