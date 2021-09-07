import 'package:scidash/core/typedefs.dart';
import 'package:scidash/core/vector.dart';

Vector gradientDescentF(
    ScalarFunction f, VectorFunction gradF, Vector x0, double eta, double eps) {
  bool done = false;
  Vector x1 = x0.copy();

  while (!done) {
    final Vector x2 = x1 - gradF(x1).scale(eta);

    assert(
      !x2.elements.any((double el) => el.isNaN || el.isInfinite),
      "A NaN or Infinite value encountered",
    );

    done = (x2 - x1).norm() < eps;
    x1 = x2.copy();
  }

  return x1;
}
