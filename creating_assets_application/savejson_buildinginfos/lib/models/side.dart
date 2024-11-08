enum Side {
  topRight, 
  topLeft, 
  right, 
  left, 
  bottomRight, 
  bottomLeft
}

extension SideExtension on Side {
  // Convert Side enum to String
  String toJson() {
    return toString().split('.').last; // Converts Side.topRight -> "topRight"
  }

  // Create Side enum from String
  static Side fromJson(String side) {
    return Side.values.firstWhere((e) => e.toString().split('.').last == side);
  }
}