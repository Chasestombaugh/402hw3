import 'package:html/parser.dart' show parse;
import 'package:slinky/utils.dart';
import 'package:test/test.dart';

void main() {
  // TODO: 6. (30 pts) create unit tests for each function in the utils module
  /** Crawl Page given */
  test('crawlPage', () {
    crawlPage('google.com', 2);
  });

  /** Extract Links */
  group('extractLinks', () {
    test ('keeps only absolute http(s) links and dedupes', () {
      final doc = parse('''
        <a href="http://a.com/x">A</a>
        <a href="http://a.com/x">A-duplicate</a>
        <a href="https://b.com/">B</a>
        <a href="/relative">relative</a>
        <a>no href</a>
        ''');
        final links = extractLinks(doc, 'http://example.org/');
        expect(links.toSet(), {'http://a.com/x', 'https://b.com/'});
    });
  });

  /** Crawl Page mine */
  group('crawPage', () {
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

// Total points: 30
