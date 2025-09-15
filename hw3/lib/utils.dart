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
import 'package:http_status/http_status.dart';
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

// Total points: 215
