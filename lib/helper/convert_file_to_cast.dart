import 'dart:typed_data';

class ConvertFileToCast {
  static List<int> convert(Uint8List data) {
    List<int> list = data.cast();
    return list;
  }
}
