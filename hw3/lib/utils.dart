//****************************************************************************
// utils.dart - Utility functions for slinky
//
// Boise State University CS 402
// Dr. Henderson
// Homework 2
//
// This module contains all the functions to crawl a page, extract the links
// and recurse into each link.
//----------------------------------------------------------------------------
import 'dart:async';
import 'package:http/http.dart' as http;
//import 'package:http_status/http_status.dart';
import 'dart:io' show HttpStatus;
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart';

//**************************************************************************************************
// The Page class represents a single web page
//--------------------------------------------------------------------------------------------------
// TODO: 2. (5 pts) Create a class called Page with the following properties:
// url - a string representing the url of the page
// depth - an integer representing the depth of the page in the recursion
// links - a list of strings containing all the unique links found on the page
// The class should have a constructor that takes values for each of the properties
class Page {
  final String url;
  final int depth;
  final List<String> links;

  Page({required this.url, required this.depth, required this.links});

  // this actually prints the webpage strings, comment out to return just "Instance of 'Page'"
  String toString() => url;
}

//**************************************************************************************************
// crawlPage(String url, int depth) is a function that crawls a single web page and extracts the links
//--------------------------------------------------------------------------------------------------
// TODO: 3. (100 pts) Implement the crawlPage() function. It should take a url string and integer
// depth argument and return a Page object with all the Page properties filled in.
//
// The function should implement the following pseudocode:
//
// if depth is negative return an empty Page object (containing an empty list of links but other properties populated)
// get the url using the http package get() function
// if the response status code != HttpStatusCode.ok print an error and return an empty Page object (as above)
// Parse the body of the response into a document object using the html/parser package parse() function
// Extract the links using your extractLinks() function
// Return a Page object with all the properties set
// If an exception occurs, print an error and return an empty Page object (as above)

String _ensureHttp(String url) =>
    (url.startsWith('http://') || url.startsWith('https://'))
    ? url
    : 'https://$url';

Future<Page> crawlPage(String url, int depth) async {
  // If depth is negative, return an empty Page object
  if (depth < 0) {
    return Page(url: url, depth: depth, links: []);
  }

  try {
    // Get the URL using the http package get() function
    final response = await http.get(Uri.parse(_ensureHttp(url)));

    // If the response status code is not OK, print an error and return an empty Page object
    if (response.statusCode != HttpStatus.ok) {
      print(
        ' There was an error fetching the URL: $url (Status code: ${response.statusCode})',
      );
      return Page(url: url, depth: depth, links: []);
    }

    // Parse the body of the response into a document object
    final document = parse(response.body);

    // Extract the links using the extractLinks() function
    final links = extractLinks(document, url);

    // Return a Page object with all properties set
    return Page(url: url, depth: depth, links: links);
  } catch (e) {
    // If an exception occurs, print an error and return an empty Page object
    print('Error: Exception occurred while fetching $url ($e)');
    return Page(url: url, depth: depth, links: []);
  }
}

//**************************************************************************************************
// extractLinks(Document document, String baseUrl) is a function that finds all the html anchor
// elements (a) in the document and collects the value of the 'href' attribute of each anchor
// into a list. It first filters out any 'href' values that don't begin with 'http' and it
// removes all duplicates so the final list contains only unique values.
//
// Note: This can be implemented in a single statement. Start with the
// Document querySelectorAll() function and consider the following list methods: map, where, toSet, toList
//--------------------------------------------------------------------------------------------------
// TODO: 4. (40 pts) Implement the extractLinks() function as specified above
List<String> extractLinks(Document document, String baseUrl) {
  // Find all anchor elements in the document
  List<Element> anchorElements = document.querySelectorAll('a');

  // Extract the 'href' attribute from each anchor element, filter out non-http links, and remove duplicates
  List<String> links = anchorElements
      .map((element) => element.attributes['href'] ?? '')
      .where((href) => href.startsWith('http'))
      .toSet()
      .toList();
  return links;
}

//**************************************************************************************************
// crawl(String url,  int maxDepth) is the top-level function called from the main slinky app. It
// should call crawlPage for the initial url and then iterate over all the returned links. For each
// link it should call crawlPage and add any new unique links to the list of links to visit.
//
// Suggested pseudocode:
//
// Let visited be a map of visited links
// Let queue be a list of Future page objects
// Call crawlPage for the starting url and add the returned list to the queue
// while queue is not empty
//    wait for all future pages in the queue to complete
//    save the completed pages
//    clear the queue
//    for each page in the completed pages
//        if the page's url (normalized) appears in the visited map do nothing
//        add the page's url (normalized) to the visited map
//        if the page's depth is not negative
//            for each of the page's links
//                add the page's links to the queue if its (normalized) url is not in the visited map
//                Call crawlPage for the link and add the returned links to the queue
// return the visited map as a sorted list
//--------------------------------------------------------------------------------------------------
// TODO: 5. (70 pts) Implement the crawl function as described above
Future<List<Page>> crawl(String url, int maxDepth) async {
  // Map to keep track of visited links
  final Map<String, Page> visited = {};
  // List to keep track of pages to visit
  final List<Future<Page>> queue = [];
  // Start by crawling the initial URL
  queue.add(crawlPage(url, maxDepth));

  while (queue.isNotEmpty) {
    // Wait for all future pages in the queue to complete
    final completedPages = await Future.wait(queue);
    // Clear the queue for the next iteration
    queue.clear();

    for (final page in completedPages) {
      final normalizedUrl = page.url.toLowerCase();
      // If the page's URL has already been visited, skip it
      if (visited.containsKey(normalizedUrl)) {
        continue;
      }

      visited[normalizedUrl] = page;

      if (page.depth > 0) {
        for (final link in page.links) {
          final normalizedLink = link.toLowerCase();

          if (!visited.containsKey(normalizedLink)) {
            queue.add(crawlPage(link, page.depth - 1));
          }
        }
      }
    }
  }

  return visited.values.toList()..sort((a, b) => a.url.compareTo(b.url));
}

// Total points: 215
