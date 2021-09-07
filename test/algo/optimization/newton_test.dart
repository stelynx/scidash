import 'dart:math';

import 'package:scidash/algo/optimization/newton.dart';
import 'package:scidash/core/matrix.dart';
import 'package:scidash/core/typedefs.dart';
import 'package:scidash/core/vector.dart';
import 'package:test/test.dart';

void main() {
  test('should converge to [1.0, 1.0]', () {
    final ScalarFunction f = (Vector x) {
      return 100.0 * pow((x[1] - pow(x[0], 2)), 2) + pow(1 - x[0], 2);
    };
    final VectorFunction gradF = (Vector x) {
      return Vector.fromList([
        400 * x[0] * (pow(x[0], 2) - x[1]) + 2 * (x[0] - 1),
        200 * (x[1] - pow(x[0], 2)),
      ]);
    };
    final MatrixFunction hessianF = (Vector x) {
      return Matrix.fromRows([
        Vector.fromList([1200 * pow(x[0], 2) - 400 * x[1] + 2, -400 * x[0]]),
        Vector.fromList([-400 * x[0], 200]),
      ]);
    };
    final Vector x0 = Vector.fromList([-1.9, 2.0]);
    final double eta = 0.001;
    final double eps = pow(10, -10).toDouble();

    final Vector result = newtonF(f, gradF, hessianF, x0, eta, eps);
    final Vector expected = Vector.fromList([1.0, 1.0]);

    expect((result - expected).norm() < eta, isTrue);
  });
}
