class Coordinate {
  final double x;
  final double y;

  Coordinate(this.x, this.y);

  bool equalTo(Coordinate cord) {
    return cord.x == x && cord.y == y;
  }
  
  // Convert Coordinate to JSON
  Map<String, dynamic> toJson() {  
    return {
      'x': x,
      'y': y,
    };
  }

   // Create a Coordinate from JSON
  factory Coordinate.fromJson(Map<String, dynamic> json) {
    return Coordinate(
      json['x'],
      json['y'],
    );
  }

}