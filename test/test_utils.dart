import 'dart:math';

import 'package:scidash/core/matrix.dart';
import 'package:scidash/core/vector.dart';
import 'package:test/test.dart';

const double epsilon = 0.0000000001;

void expectMatricesAlmostEqual(Matrix actual, Matrix expected,
    [double eps = epsilon]) {
  assert(actual.nrows == expected.nrows && actual.ncols == expected.ncols,
      'sizes: actual ${actual.size} != expected ${expected.size}');

  for (int i = 0; i < actual.nrows; i++) {
    expectVectorsAlmostEqual(actual[i], expected[i], eps);
  }
}

void expectVectorsAlmostEqual(Vector actual, Vector expected,
    [double eps = epsilon]) {
  assert(actual.size == expected.size, '${actual.size} != ${expected.size}');

  for (int i = 0; i < actual.size; i++) {
    expect(actual[i], closeTo(expected[i], eps));
  }
}
