#!/usr/bin/env bash
set -euo pipefail

BUILD_DIR="build/web"

if [ ! -f "$BUILD_DIR/flutter_bootstrap.js" ]; then
  echo "ERROR: $BUILD_DIR/flutter_bootstrap.js not found. Run 'flutter build web' first."
  exit 1
fi

# --- 1. Create flutter_bootstrap_embedded.js ---
CONFIG_LINE=$(grep -n '_flutter.buildConfig' "$BUILD_DIR/flutter_bootstrap.js" | head -1 | cut -d: -f1)
head -n "$CONFIG_LINE" "$BUILD_DIR/flutter_bootstrap.js" > "$BUILD_DIR/flutter_bootstrap_embedded.js"

cat >> "$BUILD_DIR/flutter_bootstrap_embedded.js" << 'EMBEDDED_LOAD'

_flutter.loader.load({
  onEntrypointLoaded: async function(engineInitializer) {
    var el = document.querySelector("#flutter-app");
    var opts = el ? { hostElement: el } : {};
    var appRunner = await engineInitializer.initializeEngine(opts);
    await appRunner.runApp();
  }
});
EMBEDDED_LOAD

echo "Created flutter_bootstrap_embedded.js"

# --- 2. Generate static HTML pages ---
SITE_URL="https://lailmoa.com"
GA4_ID="G-ZGHL80T4B8"

generate_page() {
  local page_path="$1"
  local page_title="$2"
  local meta_desc="$3"
  local h1_text="$4"
  local body_text="$5"

  local canonical_path="$page_path"
  if [ "$page_path" = "/_home" ]; then
    canonical_path="/"
  fi

  local breadcrumb_html=""
  if [ "$page_path" != "/_home" ]; then
    breadcrumb_html="<div class=\"seo-breadcrumb\"><a href=\"/\">홈</a> &gt; ${h1_text}</div>"
  fi

  local dir="$BUILD_DIR${page_path}"
  mkdir -p "$dir"

  cat > "$dir/index.html" << HTMLEOF
<!DOCTYPE html>
<html lang="ko">
<head>
  <base href="/">
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>${page_title}</title>
  <meta name="description" content="${meta_desc}">
  <link rel="canonical" href="${SITE_URL}${canonical_path}">
  <meta property="og:type" content="website">
  <meta property="og:title" content="${page_title}">
  <meta property="og:description" content="${meta_desc}">
  <meta property="og:url" content="${SITE_URL}${canonical_path}">
  <meta property="og:site_name" content="티켓팅캐치">
  <meta property="og:image" content="${SITE_URL}/ticketingcatch-og.png">
  <meta name="twitter:card" content="summary_large_image">
  <meta name="twitter:title" content="${page_title}">
  <meta name="twitter:description" content="${meta_desc}">
  <meta name="twitter:image" content="${SITE_URL}/ticketingcatch-og.png">
  <meta name="mobile-web-app-capable" content="yes">
  <meta name="apple-mobile-web-app-status-bar-style" content="black">
  <meta name="apple-mobile-web-app-title" content="티켓팅캐치">
  <link rel="apple-touch-icon" href="/icons/Icon-192.png">
  <link rel="icon" type="image/png" href="/favicon.png">
  <link rel="manifest" href="/manifest.json">
  <script async src="https://www.googletagmanager.com/gtag/js?id=${GA4_ID}"></script>
  <script>
    window.dataLayer = window.dataLayer || [];
    function gtag(){dataLayer.push(arguments);}
    gtag('js', new Date());
    gtag('config', '${GA4_ID}');
    function sendPageView(pagePath) {
      gtag('config', '${GA4_ID}', { page_path: pagePath });
    }
  </script>
  <style>
    * { margin: 0; padding: 0; box-sizing: border-box; }
    body { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif; background: #fff; }
    #seo-header { border-bottom: 1px solid #F0F0F0; }
    .seo-nav { max-width: 960px; margin: 0 auto; padding: 12px 20px; display: flex; align-items: center; flex-wrap: wrap; gap: 20px; }
    .seo-logo { font-size: 15px; font-weight: 700; color: #5C2D91; text-decoration: none; letter-spacing: -0.3px; }
    .seo-nav-links { display: flex; flex-wrap: wrap; gap: 20px; }
    .seo-nav-links a { font-size: 13px; color: #757575; text-decoration: none; font-weight: 500; }
    .seo-nav-links a:hover { color: #5C2D91; }
    .seo-hero { max-width: 720px; margin: 0 auto; padding: 24px 20px 0; }
    .seo-breadcrumb { font-size: 13px; color: #9E9E9E; margin-bottom: 16px; }
    .seo-breadcrumb a { color: #9E9E9E; text-decoration: none; }
    .seo-breadcrumb a:hover { color: #5C2D91; }
    .seo-hero h1 { font-size: 24px; font-weight: 800; color: #1A1A1A; line-height: 1.3; margin-bottom: 16px; }
    .seo-hero p { font-size: 15px; color: #757575; line-height: 1.7; }
    #flutter-app { width: 100%; min-height: 60vh; position: relative; }
    #seo-footer { max-width: 960px; margin: 0 auto; padding: 32px 20px; border-top: 1px solid #F0F0F0; text-align: center; }
    .seo-footer-links { display: flex; flex-wrap: wrap; gap: 16px; justify-content: center; margin-bottom: 12px; }
    .seo-footer-links a { font-size: 13px; color: #9E9E9E; text-decoration: none; }
    .seo-footer-links a:hover { color: #5C2D91; }
    .seo-footer-info { font-size: 12px; color: #BDBDBD; }
    .seo-footer-info a { color: #BDBDBD; text-decoration: none; }
    .seo-footer-info a:hover { color: #5C2D91; }
  </style>
</head>
<body>
  <header id="seo-header">
    <div class="seo-nav">
      <a href="/" class="seo-logo">티켓팅캐치</a>
      <nav class="seo-nav-links">
        <a href="/practice">실전 티켓팅 연습</a>
        <a href="/seat-practice">좌석 집중 연습</a>
        <a href="/grape-practice">포도알 연습</a>
        <a href="/ticketing-charm">티켓팅 부적</a>
      </nav>
    </div>
    <div class="seo-hero">
      ${breadcrumb_html}
      <h1>${h1_text}</h1>
      <p>${body_text}</p>
    </div>
  </header>
  <div id="flutter-app"></div>
  <footer id="seo-footer">
    <div class="seo-footer-links">
      <a href="/practice">실전 티켓팅 연습</a>
      <a href="/seat-practice">좌석 집중 연습</a>
      <a href="/grape-practice">포도알 연습</a>
      <a href="/ticketing-charm">티켓팅 부적</a>
    </div>
    <div class="seo-footer-info">
      <a href="https://lailstudio.github.io/privacy.html" target="_blank" rel="noopener">개인정보처리방침</a>
      &nbsp;·&nbsp;
      <a href="mailto:lailstudio.app@gmail.com">문의: lailstudio.app@gmail.com</a>
    </div>
  </footer>
  <script src="/flutter_bootstrap_embedded.js" async></script>
</body>
</html>
HTMLEOF

  echo "Generated ${dir}/index.html"
}

generate_page \
  "/practice" \
  "실전 티켓팅 연습 | 티켓팅캐치" \
  "대기열 진입부터 좌석 선택까지 티켓팅 흐름을 연습할 수 있습니다. 전체 과정을 반복하며 티켓팅 감각을 키워보세요." \
  "티켓팅 연습" \
  "대기열 진입부터 좌석 선택까지 티켓팅 흐름을 연습할 수 있습니다. 전체 과정을 반복하며 티켓팅 감각을 키워보세요."

generate_page \
  "/grape-practice" \
  "포도알 연습 | 티켓팅캐치" \
  "티켓팅에서 빈 좌석을 빠르게 찾아 클릭하는 연습입니다. 랜덤 좌석 중 선택 가능한 좌석을 찾아 반복 클릭하며 탐색 속도와 정확도를 높이세요." \
  "포도알 연습" \
  "티켓팅에서 빈 좌석을 빠르게 찾아 클릭하는 연습입니다. 랜덤 좌석 중 선택 가능한 좌석을 찾아 반복 클릭하며 탐색 속도와 정확도를 높이세요."

generate_page \
  "/_home" \
  "티켓팅캐치 | 실전 티켓팅 · 좌석 집중 연습" \
  "실전처럼 티켓팅을 연습하세요. 대기열, CAPTCHA, 좌석 선택까지 주요 공연장 좌석 배치 기반 연습." \
  "티켓팅캐치" \
  "실전처럼 티켓팅을 연습하세요. 대기열, CAPTCHA, 좌석 선택까지 주요 공연장 좌석 구조를 참고한 연습."

echo "SEO pages generation complete."
