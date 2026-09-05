// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use
import 'dart:convert';
import 'dart:html' as html;

const siteBaseUrl = String.fromEnvironment(
  'SITE_URL',
  defaultValue: 'https://lailmoa.com',
);

class SeoService {
  static const _defaultOgImage = '$siteBaseUrl/ticketingcatch-og.png';

  static void update({
    required String description,
    required String path,
    String? ogTitle,
    String? ogImage,
    List<Map<String, dynamic>>? jsonLd,
  }) {
    _setMeta('description', description);
    _setCanonical('$siteBaseUrl$path');

    _setMetaProperty('og:description', description);
    _setMetaProperty('og:url', '$siteBaseUrl$path');
    _setMetaProperty('og:type', 'website');
    _setMetaProperty('og:site_name', '티켓팅캐치');
    if (ogTitle != null) _setMetaProperty('og:title', ogTitle);
    _setMetaProperty('og:image', ogImage ?? _defaultOgImage);

    _setMeta('twitter:card', 'summary_large_image');
    _setMeta('twitter:description', description);
    if (ogTitle != null) _setMeta('twitter:title', ogTitle);
    _setMeta('twitter:image', ogImage ?? _defaultOgImage);

    if (jsonLd != null) _setJsonLd(jsonLd);
  }

  static Map<String, dynamic> webSiteSchema() => {
        '@context': 'https://schema.org',
        '@type': 'WebSite',
        'name': '티켓팅캐치',
        'url': siteBaseUrl.isEmpty ? '/' : siteBaseUrl,
        'description': '실전처럼 티켓팅을 연습하세요. '
            '대기열, CAPTCHA, 좌석 선택까지 주요 공연장 좌석 구조를 참고한 연습.',
      };

  static Map<String, dynamic> webPageSchema({
    required String name,
    required String description,
    required String path,
  }) =>
      {
        '@context': 'https://schema.org',
        '@type': 'WebPage',
        'name': name,
        'description': description,
        'url': '$siteBaseUrl$path',
      };

  static Map<String, dynamic> breadcrumbSchema(
    List<(String label, String? path)> items,
  ) =>
      {
        '@context': 'https://schema.org',
        '@type': 'BreadcrumbList',
        'itemListElement': [
          for (var i = 0; i < items.length; i++)
            {
              '@type': 'ListItem',
              'position': i + 1,
              'name': items[i].$1,
              if (items[i].$2 != null) 'item': '$siteBaseUrl${items[i].$2}',
            },
        ],
      };

  static void _setMeta(String name, String content) {
    var el = html.document.head?.querySelector('meta[name="$name"]');
    if (el == null) {
      el = html.document.createElement('meta');
      el.setAttribute('name', name);
      html.document.head?.append(el);
    }
    el.setAttribute('content', content);
  }

  static void _setMetaProperty(String property, String content) {
    var el = html.document.head?.querySelector('meta[property="$property"]');
    if (el == null) {
      el = html.document.createElement('meta');
      el.setAttribute('property', property);
      html.document.head?.append(el);
    }
    el.setAttribute('content', content);
  }

  static void _setCanonical(String href) {
    var el = html.document.head?.querySelector('link[rel="canonical"]');
    if (el == null) {
      el = html.document.createElement('link');
      el.setAttribute('rel', 'canonical');
      html.document.head?.append(el);
    }
    el.setAttribute('href', href);
  }

  static void _setJsonLd(List<Map<String, dynamic>> data) {
    html.document.head
        ?.querySelectorAll('script[type="application/ld+json"]')
        .forEach((e) => e.remove());

    for (final item in data) {
      final script = html.document.createElement('script');
      script.setAttribute('type', 'application/ld+json');
      script.text = jsonEncode(item);
      html.document.head?.append(script);
    }
  }
}
