import 'dart:ui';

class MapHelper {
  static bool polyContains(
      int nvert, List<double> vertx, List<double> verty, Offset test) {
    int c = 0;
    int j = nvert - 1;

    try {
      for (int i = 0; i < nvert && j < nvert; i++) {
        if (((verty[i] > test.dy) != (verty[j] > test.dy)) &&
            (test.dx <
                (vertx[j] - vertx[i]) *
                        (test.dy - verty[i]) /
                        (verty[j] - verty[i]) +
                    vertx[i])) {
          c = 1 - c;
        }

        j++;
      }
    } catch (e) {
      print(e);
    }

    return c == 1;
  }
}
