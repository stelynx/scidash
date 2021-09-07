import 'dart:math';

import 'package:scidash/algo/optimization/gradient_descent.dart';
import 'package:scidash/core/typedefs.dart';
import 'package:scidash/core/vector.dart';
import 'package:test/test.dart';

void main() {
  test('should converge to [1.0, 1.0]', () {
    final ScalarFunction f = (Vector x) {
      return 100.0 * pow((x.elements[1] - pow(x.elements[0], 2)), 2) +
          pow(1 - x.elements[0], 2);
    };
    final VectorFunction gradF = (Vector x) {
      return Vector.fromList([
        400 * x.elements[0] * (pow(x.elements[0], 2) - x.elements[1]) +
            2 * (x.elements[0] - 1),
        200 * (x.elements[1] - pow(x.elements[0], 2)),
      ]);
    };
    final Vector x0 = Vector.fromList([-1.9, 2.0]);
    final double eta = 0.001;
    final double eps = pow(10, -10).toDouble();

    final Vector result = gradientDescentF(f, gradF, x0, eta, eps);
    final Vector expected = Vector.fromList([1.0, 1.0]);

    expect((result - expected).norm() < eta, isTrue);
  });
}
