import 'package:html/parser.dart' show parse;
import 'package:slinky/utils.dart';
import 'package:test/test.dart';

void main() {
  // TODO: 6. (30 pts) create unit tests for each function in the utils module
  /** Crawl Page given */
  test('crawlPage', () {
    crawlPage('google.com', 2);
  });

  /** Page tests */
  group('Page', () {
    test('confirming the constructor stores fields', () {
      final p = Page(
        url: 'https://example.org/',
        depth: 3,
        links: ['http://a.com', 'http://b.com']
      );
      expect(p.url, 'https://example.org/');
      expect(p.depth, 3);
      expect(p.links, ['http://a.com', 'http://b.com']);
    });
  });

  /** Extract Links */
  group('extractLinks', () {
    test ('keeps only absolute http(s) links and dedupes', () {
      final doc = parse('''
        <a href="http://a.com/x">A</a>
        <a href="http://a.com/x">A-duplicate</a>
        <a href="https://b.com/">B</a>
        <a href="/relative">relative</a>
        <a>no href</a>S
        ''');
        final links = extractLinks(doc, 'http://example.org/');
        expect(links.toSet(), {'http://a.com/x', 'https://b.com/'});
    });

    test('empty document yields an empty list', () {
      final doc = parse('');
      final links = extractLinks(doc, 'http://example.org/');
      expect(links, isEmpty);
    });
  });

  /** Crawl Page mine */
  group('crawlPage', () {
    test('negative depth returns empty links', () async {
      final page = await crawlPage('http://example.org/', -1);
      expect(page.url, 'http://example.org/');
      expect(page.depth, -1);
      expect(page.links, isEmpty);
    });
  });

    test('invalid url returns empty links', () async {
      final page = await crawlPage('http://invalid.url/', 2);
      expect(page.url, 'http://invalid.url/');
      expect(page.depth, 2);
      expect(page.links, isEmpty);
    });

}

/** Crawl tests */

// Total points: 30
