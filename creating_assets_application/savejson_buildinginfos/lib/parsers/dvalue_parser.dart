import 'package:models/coordinate.dart';

class DValueParser {
  static String normalizeString(String dStr) {     
    // Adds space between each argument in string
    // Assumes the first letter is always a command
           
    var newString = dStr[0];
    var i = 1;
    var lengthReached = false;

    while(!lengthReached) {
      var currentChar = dStr[i];
      var prevChar = dStr[i - 1];
      var space = " ";

      if (currentChar != space) {

        if (isCommand(currentChar)) {

          if (prevChar != space) {
            newString += " " + currentChar;
          }else {
           newString += currentChar;
          }
        } else if (currentChar != space && !isCommand(currentChar)) {

          if (isCommand(prevChar)) {
            newString += " " + currentChar;
          } else {
            newString += currentChar;
          }
        } 
         
      } else {
        newString += currentChar;
      }    
      i++;
      if (i == dStr.length) {
        lengthReached = true;
      }      
    }   

    return newString; 
  }
  
  static List<Coordinate> parse(String dValue) {
    var normalizedData = normalizeString(dValue);
    var seperateArguments = normalizedData.split(' ');
    List<Coordinate> coordinates = [];

    double x = 0;
    double y = 0;
    double oldX = 0;
    double oldY = 0;

    for (int i = 0; i < seperateArguments.length; i++) {
      var current = seperateArguments[i];

      if (i > 0)
      {
        oldX = x;
        oldY = y;      
      }

      switch (current.toUpperCase()) {
        case "M":
          x = double.parse(seperateArguments[i+1]);
          y = double.parse(seperateArguments[i+2]);
          coordinates.add(Coordinate(x, y));
          break;
        case "L":
          x = double.parse(seperateArguments[i+1]);
          y = double.parse(seperateArguments[i+2]);
          coordinates.add(Coordinate(x, y));
          break;
        case "V":
          y = double.parse(seperateArguments[i+1]);
          coordinates.add(Coordinate(oldX, y));
          break;
        case "H":
          x = double.parse(seperateArguments[i+1]);
          coordinates.add(Coordinate(x, oldY));
          break;
        default:
      }
    }
    coordinates.removeLast();
    return coordinates;
  }
  
  static bool isCommand(String currentChar) {
    switch (currentChar.toLowerCase()) {
      case 'm':
        return true;
      case 'l':
        return true;
      case 'c':
        return true;
      case 'v':
        return true;
      case 'h':
        return true;
      case 'z':
        return true;        
        
      default:
        return false;
    }
  }
}