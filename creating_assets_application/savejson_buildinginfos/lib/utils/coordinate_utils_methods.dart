import 'package:models/coordinate.dart';
import 'package:models/side.dart';

class CoordinateUtilMethods {
  
  static Coordinate getSmallestXCoordinate(List<Coordinate> coordinates) {
    var smallestXPoint = coordinates.first.x;
    var indexSmallestXPoint = 0;
    for (int i = 0; i < coordinates.length; i++) {
      if (coordinates[i].x < smallestXPoint) {
        smallestXPoint = coordinates[i].x;
        indexSmallestXPoint = i;
      }
    }

    return coordinates[indexSmallestXPoint];
  }

  static Coordinate getLargestXCoordinate(List<Coordinate> coordinates) {
    var largestXPoint = coordinates.first.x;
    var indexLargestXPoint = 0;
    for (int i = 0; i < coordinates.length; i++) {
      if (coordinates[i].x > largestXPoint) {
        largestXPoint = coordinates[i].x;
        indexLargestXPoint = i;
      }
    }

    return coordinates[indexLargestXPoint];
  }

  static Coordinate getSmallestYCoordinate(List<Coordinate> coordinates) {
    var smallestYPoint = coordinates.first.y;
    var indexSmallestYPoint = 0;
    for (int i = 0; i < coordinates.length; i++){
      if (coordinates[i].y < smallestYPoint) {
        smallestYPoint = coordinates[i].y;
        indexSmallestYPoint = i;
      }
    }
    return coordinates[indexSmallestYPoint];
  }

  static Coordinate getLargestYCoordinate(List<Coordinate> coordinates) {
    var largestYPoint = coordinates.first.y;
    var indexLargestYPoint = 0;
    for (int i = 0; i < coordinates.length; i++) {
      if (coordinates[i].y > largestYPoint) {
        largestYPoint = coordinates[i].y;
        indexLargestYPoint = i;
      }
    }

    return coordinates[indexLargestYPoint];
  }

  static List<Coordinate> getConnectedCoordinates(Coordinate coordinate, List<Coordinate> coordinates) {    
    var coordinateInList = coordinates.where((crd) => crd.x == coordinate.x && crd.y == coordinate.y).first;
    var indexCoordinate = coordinates.indexOf(coordinateInList);
    List<Coordinate> coordinatesConnected = [];

    if (indexCoordinate == coordinates.length - 1) {
      coordinatesConnected.add(coordinates[indexCoordinate - 1]);
      coordinatesConnected.add(coordinates.first);      
    } else if (indexCoordinate == 0) {
      coordinatesConnected.add(coordinates[1]);
      coordinatesConnected.add(coordinates.last);
    } else {
      coordinatesConnected.add(coordinates[indexCoordinate + 1]);
      coordinatesConnected.add(coordinates[indexCoordinate - 1]);
    }

    return coordinatesConnected;
  }

  static List<Coordinate> removeMaxMinCoordinates(List<Coordinate> coordinates) {
    List<Coordinate> maxMinCoordinates = [getLargestYCoordinate(coordinates), getSmallestYCoordinate(coordinates), getSmallestXCoordinate(coordinates), getLargestXCoordinate(coordinates)];
    for (var cord in maxMinCoordinates) {
      coordinates.remove(cord);
    }
    return maxMinCoordinates;
  }

  static List<Coordinate> getTriangleCoordinates(List<Coordinate> buildingCoordinates) {    
    List<Coordinate> originalBuildingCoordinates = [];
    for (var cord in buildingCoordinates) {
      originalBuildingCoordinates.add(cord);
    }
    List<Coordinate> myBuildingCoordinates = [];
    for (var x in buildingCoordinates) {
      myBuildingCoordinates.add(x);
    }

    var minMaxCoordinates = removeMaxMinCoordinates(myBuildingCoordinates); //building coordinates are reduced. min max are removed.

    Coordinate? firstCoordinate; //Finding the coordinate which has both of its connected coordinates in minMaxCoordinates        
    List<Coordinate> connectedCoordinatesToFirstPoint = [];    
    for (var cord in myBuildingCoordinates) {        
      connectedCoordinatesToFirstPoint = getConnectedCoordinates(cord, originalBuildingCoordinates);
      if (minMaxCoordinates.contains(connectedCoordinatesToFirstPoint[0]) && minMaxCoordinates.contains(connectedCoordinatesToFirstPoint[1])) {
        firstCoordinate = cord;        
        break;
      }
    }

    if (firstCoordinate == null) {
      throw Exception("First Coordinate not found, error.");
    }
    
    myBuildingCoordinates.remove(firstCoordinate);

    List<Coordinate> tempBuildingCoordinates = [];
    for (var x in myBuildingCoordinates) {
      tempBuildingCoordinates.add(x);
    }

    //Removing any coordinate which are connected to first coordninate's immediate coordinates
    for (var cord in tempBuildingCoordinates) {
      if (connectedCoordinatesToFirstPoint.contains(cord)) {
        myBuildingCoordinates.remove(cord);
      }
    }
    
    tempBuildingCoordinates.clear();
    for (var x in myBuildingCoordinates) {
      tempBuildingCoordinates.add(x);
    }
    
    //Removing any coordinate that are connected to first coordinate's immediate coordinates
    //Removing any coordniate that are not connected to second immediate first coordinate's
    while (myBuildingCoordinates.length > 2) {
      for (var cord in tempBuildingCoordinates) {
        var immediateConnectedCords = getConnectedCoordinates(cord, originalBuildingCoordinates);

        if (immediateConnectedCords.any((x) => connectedCoordinatesToFirstPoint.contains(x))) {
          myBuildingCoordinates.remove(cord);

        } else {
          List<Coordinate> secondImmediateCords = [];

          for (var connectedCord in immediateConnectedCords) {
            var secondImmediateConnectedCords = getConnectedCoordinates(connectedCord, originalBuildingCoordinates);
            secondImmediateConnectedCords.remove(cord);
            secondImmediateCords.add(secondImmediateConnectedCords.first);
          }

          if (secondImmediateCords.every((x) => !connectedCoordinatesToFirstPoint.contains(x))) {
            myBuildingCoordinates.remove(cord);
          }
        }
      }
    }

    
    return [firstCoordinate, myBuildingCoordinates[0], myBuildingCoordinates[1]];
  }

  static Map<Side, List<Coordinate>> getSidesCoordinates(List<Coordinate> triangleCoordinates, List<Coordinate> allCoordinates) {
    List<Coordinate> connectedCords = [];  
    Map<Side, List<Coordinate>> sidesToCoordinates = {};
    for (var cord in triangleCoordinates) {
      var connectedCoordinates = getConnectedCoordinates(cord, allCoordinates);
      connectedCords.add(cord);
      connectedCords.addAll(connectedCoordinates);
    }

    var smallestYCoordinate = getSmallestYCoordinate(connectedCords);
    connectedCords.remove(smallestYCoordinate);
    var secondSmallestYCoordinate = getSmallestYCoordinate(connectedCords);
    connectedCords.remove(secondSmallestYCoordinate);

    var greatestYCoordinate = getLargestYCoordinate(connectedCords);
    connectedCords.remove(greatestYCoordinate);
    var secondGreatestYCoordinate = getLargestYCoordinate(connectedCords);
    connectedCords.remove(secondGreatestYCoordinate);

    var topRight = getLargestXCoordinate([smallestYCoordinate, secondSmallestYCoordinate]); //GreatestXinSmallestY
    var topLeft = getSmallestXCoordinate([smallestYCoordinate, secondSmallestYCoordinate]); //SmallestXinSmallesty

    var bottomRight = getLargestXCoordinate([greatestYCoordinate, secondGreatestYCoordinate]);
    var bottomLeft = getSmallestXCoordinate([greatestYCoordinate, secondGreatestYCoordinate]);
    

    var connectedCoordinatesToTopRightPoint = getConnectedCoordinates(topRight, allCoordinates);
    var connectedCoordinatesToTopLeftPoint = getConnectedCoordinates(topLeft, allCoordinates);

    var connectedCoordinatesToBottomRightPoint = getConnectedCoordinates(bottomRight, allCoordinates);
    var connectedCoordinatesToBottomLeftPoint = getConnectedCoordinates(bottomLeft, allCoordinates); 

    //topRight
    for (var cord in connectedCoordinatesToTopRightPoint) {
      for (var cordInTriangle in triangleCoordinates) {
        if (cord.equalTo(cordInTriangle)) {          
          sidesToCoordinates[Side.topRight] = [Coordinate(topRight.x, topRight.y), Coordinate(cordInTriangle.x, cordInTriangle.y)];
          connectedCords.remove(cordInTriangle);
        }
      }
    }

    //topLeft
    for (var cord in connectedCoordinatesToTopLeftPoint) {
      for (var cordInTriangle in triangleCoordinates) {
        if (cord.equalTo(cordInTriangle)) {
          sidesToCoordinates[Side.topLeft] = [Coordinate(topLeft.x, topLeft.y), Coordinate(cordInTriangle.x, cordInTriangle.y)];
          connectedCords.remove(cordInTriangle);
        }
      }
    }  
    
    //bottomRight
    for (var cord in connectedCoordinatesToBottomRightPoint) {
      for (var cordInTriangle in triangleCoordinates) {
        if (cord.equalTo(cordInTriangle)) {          
          sidesToCoordinates[Side.bottomRight] = [Coordinate(bottomRight.x, bottomRight.y), Coordinate(cordInTriangle.x, cordInTriangle.y)];
          connectedCords.remove(cordInTriangle);
        }
      }
    }

    //bottomLeft  
    for (var cord in connectedCoordinatesToBottomLeftPoint) {
      for (var cordInTriangle in triangleCoordinates) {
        if (cord.equalTo(cordInTriangle)) {          
          sidesToCoordinates[Side.bottomLeft] = [Coordinate(bottomLeft.x, bottomLeft.y), Coordinate(cordInTriangle.x, cordInTriangle.y)];
          connectedCords.remove(cordInTriangle);
        }
      }
    }    

    var right = getLargestXCoordinate(connectedCords);
    var left = getSmallestXCoordinate(connectedCords);

    var connectedCoordinatesToRight = getConnectedCoordinates(right, allCoordinates);
    var connectedCoordinatesToLeft = getConnectedCoordinates(left, allCoordinates);

    //right
    for (var cord in connectedCoordinatesToRight) {
      for (var cordInTriangle in triangleCoordinates) {
        if (cord.equalTo(cordInTriangle)) {          
          sidesToCoordinates[Side.right] = [Coordinate(right.x, right.y), Coordinate(cordInTriangle.x, cordInTriangle.y)];
        }
      }
    }

    //left
    for (var cord in connectedCoordinatesToLeft) {
      for (var cordInTriangle in triangleCoordinates) {
        if (cord.equalTo(cordInTriangle)) {          
          sidesToCoordinates[Side.left] = [Coordinate(left.x, left.y), Coordinate(cordInTriangle.x, cordInTriangle.y)];
        }
      }
    }

    return sidesToCoordinates;
  }
}