import 'package:breeze/main.dart';
import 'package:path/path.dart' as p;

class Config {
  Config._();
  static const currentSchemaVersion = '1.0.0';

  static String get dataFilePath {
    return p.join(
      platformAppSupportDir,
      'breeze-data.json',
    );
  }

  static Map<int, String> weekdayNames = {
    1: "Monday",
    2: "Tuesday",
    3: "Wednesday",
    4: "Thursday",
    5: "Friday",
    6: "Saturday",
    7: "Sunday"
  };
}
