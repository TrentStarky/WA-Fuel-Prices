import 'package:wa_fuel/models/fuel_station.dart';
import 'package:xml/xml.dart';

///CLASS: RssParser
///Parses incoming RSS data, taken mostly from webfeed (https://pub.dev/packages/webfeed) but adapted to be able to be used with the FuelWatch RSS feed as webfeed couldn't provide access to specific values in RSS item
class RssParser {
  List<FuelStation> parse(String xmlString) {
    var document = XmlDocument.parse(xmlString);
    var rss = findFirstElement(document, 'rss');
    var rdf = findFirstElement(document, 'rdf:RDF');
    if (rss == null && rdf == null) {
      throw ArgumentError('not a rss feed');
    }
    var channelElement = findFirstElement(rss!, 'channel');
    if (channelElement == null) {
      throw ArgumentError('channel not found');
    }
    return channelElement
        .findElements('item')
        .map((e) => FuelStation.fromRssFeed(e))
        .toList();
  }

  XmlElement? findFirstElement(
      XmlNode node,
      String name, {
        bool recursive = false,
      }) {
    try {
      return findElements(node, name,
          recursive: recursive)!
          .first;
    } on StateError {
      return null;
    }
  }

  Iterable<XmlElement>? findElements(
      XmlNode node,
      String name, {
        bool recursive = false,
      }) {
    try {
      if (recursive) {
        return node.findAllElements(name);
      } else {
        return node.findElements(name);
      }
    } on StateError {
      return null;
    }
  }

  bool parseBoolLiteral(XmlElement element, String tagName) {
    var v = findFirstElement(element, tagName)?.text.toLowerCase().trim();
    if (v == null) return false;
    return ['yes', 'true'].contains(v);
  }
}
