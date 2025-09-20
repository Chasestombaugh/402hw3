//****************************************************************************
// slinky.dart - Main entrypoint for slinky
//
// Boise State University CS 402
// Dr. Henderson
// Lab 1
//
// slinky is an application to scrape links from a webpage. It will recursively
// follow links and scrape them as well up to a specified depth.
//
// Command line options are:
// --depth/-d: depth limit of links to crawl (default: 5)
// <page>: the url of the webpage to start the crawl
//
//----------------------------------------------------------------------------
import 'dart:io';
import 'package:args/args.dart';

import 'package:slinky/utils.dart' as utils;

const optionDepth = 'depth';

Future<void> main(List<String> arguments) async {
  final parser = ArgParser()
    ..addOption(optionDepth, abbr: 'd', defaultsTo: "5");
  ArgResults argResults = parser.parse(arguments);

  if (argResults.rest.length == 0) {
    print("A url must be specified");
    exit(1);
  }

  final links = await utils.crawl(
    argResults.rest[0],
    int.parse(argResults[optionDepth]),
  );

  // TODO: 1. (5 pts) Print the returned links
  for (var link in links) {
    print(link);
  }
  exit(0);
}

// Total points: 5
