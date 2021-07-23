class SDPUtil {
  static String parseMID(line) {
    return line.substring(6);
  }

  static String? findLine(haystack, needle, sessionpart) {
    List<String> lines = haystack.split("\r\n");
    try {
      for (int i = 0; i < lines.length; i++) {
        if (lines[i].length >= needle.length &&
            lines[i].substring(0, needle.length) == needle) {
          return lines[i];
        }
      }
      if (sessionpart == null) {
        return null;
      }

      // search session part
      lines = sessionpart.split("\r\n");
      for (int j = 0; j < lines.length; j++) {
        if (lines[j].length >= needle.length &&
            lines[j].substring(0, needle.length) == needle) {
          return lines[j];
        }
      }
    } catch (err, s) {
      print(err);
      print(s);
    }
    return null;
  }

  static List<String> findLines(String haystack, var needle, var sessionpart) {
    List<String> lines = haystack.split("\r\n");
    //('needle ${needle}');
    List<String> needles = [];
    try {
      for (int i = 0; i < lines.length; i++) {
        //log('lines[i].substring(0, needle.length)  ${lines[i]}');
        if (lines[i].length >= needle.length &&
            lines[i].substring(0, needle.length) == needle) {
          needles.add(lines[i]);
        }
      }
      if (needles.length > 0 || sessionpart == null) {
        return needles;
      }

      // search session part
      lines = sessionpart.split("\r\n");
      for (int j = 0; j < lines.length; j++) {
        if (lines[j].length >= needle.length &&
            lines[j].substring(0, needle.length) == needle) {
          needles.add(lines[j]);
        }
      }
    } catch (err, s) {
      print(err);
      print(s);
    }
    return needles;
  }
}
