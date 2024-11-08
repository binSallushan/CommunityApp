import 'coordinate.dart';
import 'side.dart';

class BuildingInfo {  
  final int buildingNumber;
  final Map<Side, List<Coordinate>> sideCoordinates;

  BuildingInfo(this.buildingNumber, this.sideCoordinates);

    // Convert BuildingInfo to JSON
  Map<String, dynamic> toJson() {
    return {    
      'buildingNumber': buildingNumber,
      'sideCoordinates': sideCoordinates.map((key, value) =>
          MapEntry(key.toJson(), value.map((e) => e.toJson()).toList())),
    };
  }

  // Create BuildingInfo from JSON
  factory BuildingInfo.fromJson(Map<String, dynamic> json) {
    return BuildingInfo(
      json['buildingNumber'],      
      (json['sideCoordinates'] as Map<String, dynamic>).map((key, value) =>
          MapEntry(SideExtension.fromJson(key), (value as List).map((e) => Coordinate.fromJson(e)).toList())),
    );
  }
}