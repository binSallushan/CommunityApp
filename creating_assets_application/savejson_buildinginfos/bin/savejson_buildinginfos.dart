import 'dart:convert';

import 'package:models/building_info.dart';
import 'package:savejson_buildinginfos/parsers/svg_parser.dart';
import 'package:savejson_buildinginfos/utils/io_utils.dart';
import 'package:xml/xml.dart';

Future<void> main(List<String> assetFolderPath) async {
  String svgPath = "${assetFolderPath.first}\\Askan.svg";
  String jsonPath = "${assetFolderPath.first}\\BuildingInfo.json";

  var svgContent = await IoUtils.readFile(svgPath);  
  var parameterPaths = getBuildingParameters(XmlDocument.parse(svgContent).rootElement);
  
  List<BuildingInfo> buildingInfos = [];
  for (var path in parameterPaths) {
    buildingInfos.add(SvgParser.parse(path));
  }

  IoUtils.writeFile(jsonPath, jsonEncode(buildingInfos));  
}

Iterable<XmlElement> getBuildingParameters(XmlElement rootElement) {
  return rootElement.findAllElements("g").where((x) => x.getAttribute("id") == "BuildingsParameter").first.childElements;
}