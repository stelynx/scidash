import 'package:scidash/algo/linalg/gauss_jordan.dart';
import 'package:scidash/core/matrix.dart';
import 'package:scidash/core/vector.dart';
import 'package:scidash/util/defs/pair.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

import '../../test_utils.dart';

void main() {
  test('should throw assertion error if matrices have different rows', () {
    final Matrix lhs = Matrix.fromRows([
      Vector.fromList([1, 2, 3]),
      Vector.fromList([4, 5, 6]),
      Vector.fromList([7, 8, 10]),
    ]);
    final Matrix rhs = Matrix.fromRows([
      Vector.fromList([1, 2, 3]),
      Vector.fromList([4, 5, 6]),
      Vector.fromList([7, 8, 10]),
      Vector.fromList([7, 8, 10]),
    ]);

    expect(() => gaussJordan(lhs, rhs), throwsA(isA<AssertionError>()));
  });

  test('should leave an identity as lhso if lhs is square', () {
    final Matrix lhs = Matrix.fromRows([
      Vector.fromList([1, 2, 3]),
      Vector.fromList([4, 5, 6]),
      Vector.fromList([7, 8, 10]),
    ]);
    final Matrix rhs = Matrix.eye(3);

    final Pair<Matrix> result = gaussJordan(lhs, rhs);

    expect(result.left, equals(Matrix.eye(3)));
  });

  test('should compute lhs and rhs correctly (both square)', () {
    final Matrix lhs = Matrix.fromRows([
      Vector.fromList([1, 2, 3]),
      Vector.fromList([4, 5, 6]),
      Vector.fromList([7, 8, 10]),
    ]);
    final Matrix rhs = Matrix.eye(3);

    final Pair<Matrix> result = gaussJordan(lhs, rhs);

    final Matrix expectedLeft = Matrix.eye(3);
    final Matrix expectedRight = Matrix.fromRows([
      Vector.fromList([-2 / 3, -4 / 3, 1]),
      Vector.fromList([-2 / 3, 11 / 3, -2]),
      Vector.fromList([1, -2, 1]),
    ]);
    expectMatricesAlmostEqual(result.left, expectedLeft);
    expectMatricesAlmostEqual(result.right, expectedRight);
  });
}
