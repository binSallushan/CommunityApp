import 'dart:io';

class IoUtils {
  static Future<String> readFile(String filePath) async {
  try {
    final file = File(filePath);

    // Read the file
    String contents = await file.readAsString();
    return contents;
  } catch (e) {
    print("Error reading file: $e");
    return "";
  }
}

static Future<void> writeFile(String filePath, String content) async {
  try {
    final file = File(filePath);

    // Write the content to the file
    await file.writeAsString(content);
    print("File written successfully.");
  } catch (e) {
    print("Error writing file: $e");
  }
}
}