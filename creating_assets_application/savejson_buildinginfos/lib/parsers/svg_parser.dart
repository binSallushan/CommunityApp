import 'package:xml/xml.dart';
import '../models/building_info.dart';
import '../utils/coordinate_utils_methods.dart';
import 'dvalue_parser.dart';

class SvgParser {

  static BuildingInfo parse(XmlElement element) {
    if (element.localName != "path") {
      throw ArgumentError();
    }
    var buildingNumber = int.parse(element.getAttribute("id")!.substring(1));
    var dValue = element.getAttribute("d")!;

    var coordinates = DValueParser.parse(dValue);
    var sidesToCoordinates = CoordinateUtilMethods.getSidesCoordinates(CoordinateUtilMethods.getTriangleCoordinates(coordinates), coordinates);
    return BuildingInfo(buildingNumber, sidesToCoordinates);
  }

}