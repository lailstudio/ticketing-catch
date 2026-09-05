const SITE_URL = 'https://lailmoa.com';
const DEFAULT_OG_IMAGE = `${SITE_URL}/ticketingcatch-og.png`;

const SEO_PAGES = {
  '/': {
    title: '티켓팅캐치 | 실전 티켓팅 · 좌석 집중 연습',
    description:
      '실전처럼 티켓팅을 연습하세요. 대기열, CAPTCHA, 좌석 선택까지 주요 공연장 좌석 배치 기반 연습.',
    h1: '티켓팅캐치',
    body: '실전처럼 티켓팅을 연습하세요. 대기열, CAPTCHA, 좌석 선택까지 주요 공연장 좌석 구조를 참고한 연습.',
  },
  '/practice': {
    title: '실전 티켓팅 연습 | 티켓팅캐치',
    description:
      '대기열 진입부터 좌석 선택까지 티켓팅 흐름을 연습할 수 있습니다. 전체 과정을 반복하며 티켓팅 감각을 키워보세요.',
    h1: '티켓팅 연습',
    body: '대기열 진입부터 좌석 선택까지 티켓팅 흐름을 연습할 수 있습니다. 전체 과정을 반복하며 티켓팅 감각을 키워보세요.',
  },
  '/seat-practice': {
    title: '좌석 집중 연습 | 티켓팅캐치',
    description:
      '공연장 구역을 선택한 뒤 좌석 선택 단계만 반복해서 연습할 수 있습니다. 좌석 찾기와 클릭 속도에 집중하는 연습 모드입니다.',
    h1: '좌석 집중 연습',
    body: '공연장 구역을 선택한 뒤 좌석 선택 단계만 반복해서 연습할 수 있습니다. 좌석 찾기와 클릭 속도에 집중하는 연습 모드입니다.',
  },
  '/grape-practice': {
    title: '포도알 연습 | 티켓팅캐치',
    description:
      '티켓팅에서 빈 좌석을 빠르게 찾아 클릭하는 연습입니다. 랜덤 좌석 중 선택 가능한 좌석을 찾아 반복 클릭하며 탐색 속도와 정확도를 높이세요.',
    h1: '포도알 연습',
    body: '티켓팅에서 빈 좌석을 빠르게 찾아 클릭하는 연습입니다. 랜덤 좌석 중 선택 가능한 좌석을 찾아 반복 클릭하며 탐색 속도와 정확도를 높이세요.',
  },
  '/ticketing-charm': {
    title:
      '티켓팅 부적 무료 다운로드 | 티켓팅 성공 · 포도알 · 취켓팅 부적 - 티켓팅캐치',
    description:
      '콘서트 티켓팅 성공을 기원하는 티켓팅 부적 무료 다운로드. 유령 부적, 피규어 부적, 12간지 부적을 카카오톡 공유용·포토카드용으로 저장하세요.',
    h1: '티켓팅 부적',
    body: '콘서트 티켓팅 성공을 기원하는 티켓팅 부적 무료 다운로드. 유령 부적, 피규어 부적, 12간지 부적을 카카오톡 공유용·포토카드용으로 저장하세요.',
  },
};

const VENUE_PAGES = {
  'gocheok-sky-dome': {
    name: '고척스카이돔',
    title: '고척스카이돔 티켓팅 연습 | 티켓팅캐치',
    description:
      '고척스카이돔 티켓팅 연습. 약 18,000석 규모의 좌석 구조를 참고한 배치에서 구역 선택과 좌석 선택을 연습하세요.',
    h1: '고척스카이돔 티켓팅',
    body: '고척스카이돔은 서울 구로구에 위치한 국내 유일의 돔 경기장입니다. 약 18,000석 규모의 넓은 좌석 구조를 참고해 구역 선택과 좌석 선택 과정을 연습할 수 있습니다.',
  },
  'kspo-dome': {
    name: 'KSPO DOME',
    title: 'KSPO DOME 티켓팅 연습 | 티켓팅캐치',
    description:
      'KSPO DOME(올림픽체조경기장) 티켓팅 연습. 약 15,000석 규모의 좌석 구조를 참고한 배치에서 구역 선택과 좌석 선택을 연습하세요.',
    h1: 'KSPO DOME 티켓팅',
    body: 'KSPO DOME(올림픽체조경기장)은 서울 송파구 올림픽공원 내에 위치한 국내 대표 공연장입니다. 약 15,000석 규모의 좌석 구조를 참고해 구역 선택과 좌석 선택 과정을 연습할 수 있습니다.',
  },
  'jamsil-indoor-stadium': {
    name: '잠실실내체육관',
    title: '잠실실내체육관 티켓팅 연습 | 티켓팅캐치',
    description:
      '잠실실내체육관 티켓팅 연습. 약 11,000석 규모의 좌석 구조를 참고한 배치에서 구역 선택과 좌석 선택을 연습하세요.',
    h1: '잠실실내체육관 티켓팅',
    body: '잠실실내체육관은 서울 송파구 잠실종합운동장 내에 위치한 실내 공연장입니다. 약 11,000석 규모의 좌석 구조를 참고해 구역 선택과 좌석 선택 과정을 연습할 수 있습니다.',
  },
  'inspire-arena': {
    name: '인스파이어 아레나',
    title: '인스파이어 아레나 티켓팅 연습 | 티켓팅캐치',
    description:
      '인스파이어 아레나 티켓팅 연습. 약 15,000석 규모의 좌석 구조를 참고한 배치에서 구역 선택과 좌석 선택을 연습하세요.',
    h1: '인스파이어 아레나 티켓팅',
    body: '인스파이어 아레나는 인천 영종도 인스파이어 리조트 내에 위치한 대규모 공연장입니다. 약 15,000석 규모의 좌석 구조를 참고해 구역 선택과 좌석 선택 과정을 연습할 수 있습니다.',
  },
  'olympic-hall': {
    name: '올림픽홀',
    title: '올림픽홀 티켓팅 연습 | 티켓팅캐치',
    description:
      '올림픽홀 티켓팅 연습. 약 5,000석 규모의 좌석 구조를 참고한 배치에서 구역 선택과 좌석 선택을 연습하세요.',
    h1: '올림픽홀 티켓팅',
    body: '올림픽홀은 서울 송파구 올림픽공원 내에 위치한 중규모 공연장입니다. 약 5,000석 규모로 비교적 아늑한 구조이며, 좌석 간 거리가 가까워 빠른 선택이 중요합니다.',
  },
};

function getSeoData(pathname) {
  const normalized = pathname.endsWith('/') && pathname !== '/'
    ? pathname.slice(0, -1)
    : pathname;

  if (SEO_PAGES[normalized]) {
    return { ...SEO_PAGES[normalized], canonical: `${SITE_URL}${normalized === '/' ? '/' : normalized}` };
  }

  const venueMatch = normalized.match(/^\/venue\/([a-z0-9-]+)$/);
  if (venueMatch && VENUE_PAGES[venueMatch[1]]) {
    const venue = VENUE_PAGES[venueMatch[1]];
    return { ...venue, canonical: `${SITE_URL}${normalized}` };
  }

  return {
    title: '티켓팅캐치 | 실전 티켓팅 · 좌석 집중 연습',
    description:
      '실전처럼 티켓팅을 연습하세요. 대기열, CAPTCHA, 좌석 선택까지 주요 공연장 좌석 배치 기반 연습.',
    h1: '티켓팅캐치',
    body: '실전처럼 티켓팅을 연습하세요. 대기열, CAPTCHA, 좌석 선택까지 주요 공연장 좌석 구조를 참고한 연습.',
    canonical: `${SITE_URL}/`,
  };
}

function injectSeo(html, seo) {
  let result = html;

  result = result.replace(
    /<title>[^<]*<\/title>/,
    `<title>${seo.title}</title>`,
  );

  result = result.replace(
    /<meta name="description" content="[^"]*">/,
    `<meta name="description" content="${seo.description}">`,
  );

  result = result.replace(
    /<link rel="canonical" href="[^"]*">/,
    `<link rel="canonical" href="${seo.canonical}">`,
  );

  result = result.replace(
    /<meta property="og:title" content="[^"]*">/,
    `<meta property="og:title" content="${seo.title}">`,
  );
  result = result.replace(
    /<meta property="og:description" content="[^"]*">/,
    `<meta property="og:description" content="${seo.description}">`,
  );
  result = result.replace(
    /<meta property="og:url" content="[^"]*">/,
    `<meta property="og:url" content="${seo.canonical}">`,
  );

  result = result.replace(
    /<meta name="twitter:title" content="[^"]*">/,
    `<meta name="twitter:title" content="${seo.title}">`,
  );
  result = result.replace(
    /<meta name="twitter:description" content="[^"]*">/,
    `<meta name="twitter:description" content="${seo.description}">`,
  );

  const seoHtml = `<div id="seo-content" style="position:absolute;width:100%;padding:40px 20px;box-sizing:border-box;text-align:center;font-family:sans-serif;z-index:0;"><h1 style="font-size:24px;margin:0 0 12px 0;color:#333;">${seo.h1}</h1><p style="font-size:15px;color:#666;margin:0;max-width:600px;display:inline-block;line-height:1.6;">${seo.body}</p></div>\n  `;

  result = result.replace(
    '<script src="flutter_bootstrap.js" async></script>',
    `${seoHtml}<script src="flutter_bootstrap.js" async></script>`,
  );

  return result;
}

const STATIC_HTML_PAGES = ['/practice', '/grape-practice'];

function hasFileExtension(pathname) {
  const lastSegment = pathname.split('/').pop();
  return lastSegment && lastSegment.includes('.') && !lastSegment.startsWith('.');
}

function normalizePathname(pathname) {
  return pathname.endsWith('/') && pathname !== '/'
    ? pathname.slice(0, -1)
    : pathname;
}

export default {
  async fetch(request, env) {
    const url = new URL(request.url);
    const pathname = url.pathname;

    if (hasFileExtension(pathname)) {
      const response = await env.ASSETS.fetch(request);
      if (response.ok) {
        return response;
      }
    }

    const normalized = normalizePathname(pathname);
    if (STATIC_HTML_PAGES.includes(normalized)) {
      const staticUrl = new URL(`${normalized}/index.html`, request.url);
      const staticRequest = new Request(staticUrl, {
        method: request.method,
        headers: request.headers,
      });
      const response = await env.ASSETS.fetch(staticRequest);
      if (response.ok) {
        return response;
      }
    }

    const indexUrl = new URL('/index.html', request.url);
    const indexRequest = new Request(indexUrl, {
      method: request.method,
      headers: request.headers,
    });
    const response = await env.ASSETS.fetch(indexRequest);
    const html = await response.text();

    const seo = getSeoData(pathname);
    const modifiedHtml = injectSeo(html, seo);

    const headers = new Headers(response.headers);
    headers.set('Content-Type', 'text/html; charset=utf-8');

    return new Response(modifiedHtml, {
      status: 200,
      headers,
    });
  },
};
