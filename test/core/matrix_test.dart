import 'package:scidash/algo/linalg/gauss_jordan.dart';
import 'package:scidash/core/matrix.dart';
import 'package:scidash/core/vector.dart';
import 'package:scidash/util/defs/pair.dart';
import 'package:test/test.dart';

void main() {
  group('Matrix.zeros', () {
    test('should correctly construct matrix of zeros of given size', () {
      final int nrows = 2;
      final int ncols = 3;
      final Matrix m = Matrix.zeros(nrows, ncols);

      for (int i = 0; i < nrows; i++) {
        expect(m[i], equals(Vector.zeros(ncols)));
      }
    });
  });

  group('Matrix.ones', () {
    test('should correctly construct matrix of ones of given size', () {
      final int nrows = 2;
      final int ncols = 3;
      final Matrix m = Matrix.ones(nrows, ncols);

      for (int i = 0; i < nrows; i++) {
        expect(m[i], equals(Vector.ones(ncols)));
      }
    });
  });

  group('Matrix.eye', () {
    test('should construct a square matrix', () {
      final int size = 10;
      final Matrix m = Matrix.eye(size);

      expect(m.isSquare, isTrue);
      expect(m.size, equals([size, size]));
    });

    test('should correctly construct matrix of zeros of given size', () {
      final int size = 3;
      final Matrix m = Matrix.eye(size);

      for (int i = 0; i < size; i++) {
        expect(m[i][i], equals(1));
        m[i][i] = 0;
        expect(m[i], equals(Vector.zeros(size)));
      }
    });
  });

  group('get rows', () {
    test('should return list of rows', () {
      final List<Vector> rows = [
        Vector.fromList([1, 2, 3]),
        Vector.fromList([4, 5, 6]),
      ];
      final Matrix m = Matrix.fromRows(rows);

      expect(m.rows, equals(rows));
    });
  });

  group('get size', () {
    test('should return correct size', () {
      final Matrix m = Matrix.fromRows([
        Vector.fromList([1, 2, 3]),
        Vector.fromList([4, 5, 6]),
      ]);

      expect(m.size, equals([2, 3]));
    });
  });

  group('get nrows', () {
    test('should get correct number of rows', () {
      final Matrix m1 = Matrix.fromRows([
        Vector.fromList([1, 2]),
        Vector.fromList([3, 4]),
        Vector.fromList([5, 6]),
      ]);

      expect(m1.nrows, equals(3));
    });
  });

  group('get ncols', () {
    test('should get correct number of cols', () {
      final Matrix m1 = Matrix.fromRows([
        Vector.fromList([1, 2]),
        Vector.fromList([3, 4]),
        Vector.fromList([5, 6]),
      ]);

      expect(m1.ncols, equals(2));
    });
  });

  group('get isSquare', () {
    test('should return true for square matrix', () {
      final Matrix m1 = Matrix.fromRows([
        Vector.fromList([1, 2]),
        Vector.fromList([3, 4]),
      ]);

      expect(m1.isSquare, isTrue);
    });

    test('should return false for nonsquare matrix', () {
      final Matrix m1 = Matrix.fromRows([
        Vector.fromList([1, 2]),
        Vector.fromList([3, 4]),
        Vector.fromList([5, 6]),
      ]);

      expect(m1.isSquare, isFalse);
    });
  });

  group('get isNotSquare', () {
    test('should return false for square matrix', () {
      final Matrix m1 = Matrix.fromRows([
        Vector.fromList([1, 2]),
        Vector.fromList([3, 4]),
      ]);

      expect(m1.isNotSquare, isFalse);
    });

    test('should return false for nonsquare matrix', () {
      final Matrix m1 = Matrix.fromRows([
        Vector.fromList([1, 2]),
        Vector.fromList([3, 4]),
        Vector.fromList([5, 6]),
      ]);

      expect(m1.isNotSquare, isTrue);
    });
  });

  group('isSingular', () {
    test('should throw assertion error if matrix is not square', () {
      final Matrix m = Matrix.fromRows([
        Vector.fromList([1, 2]),
        Vector.fromList([3, 4]),
        Vector.fromList([5, 6]),
      ]);

      expect(m.isSingular, throwsA(isA<AssertionError>()));
    });

    test('should return false if matrix is not singular', () {
      final Matrix m = Matrix.fromRows([
        Vector.fromList([1, 2, 3]),
        Vector.fromList([4, 5, 6]),
        Vector.fromList([7, 8, 10]),
      ]);

      expect(m.isSingular(), isFalse);
    });

    test('should return true if matrix is singular', () {
      final Matrix m = Matrix.fromRows([
        Vector.fromList([1, 2, 3]),
        Vector.fromList([4, 5, 6]),
        Vector.fromList([7, 8, 9]),
      ]);

      expect(m.isSingular(), isTrue);
    });
  });

  group('submatrix', () {
    test('should throw a RangeError if i1 out of range', () {
      final Matrix m = Matrix.fromRows([
        Vector.fromList([1, 2, 3, 4]),
        Vector.fromList([3, 4, 5, 6]),
        Vector.fromList([5, 6, 7, 8]),
      ]);

      expect(() => m.submatrix(-1, 0, 2, 1), throwsRangeError);
    });

    test('should throw a RangeError if j1 out of range', () {
      final Matrix m = Matrix.fromRows([
        Vector.fromList([1, 2, 3, 4]),
        Vector.fromList([3, 4, 5, 6]),
        Vector.fromList([5, 6, 7, 8]),
      ]);

      expect(() => m.submatrix(0, -1, 2, 1), throwsRangeError);
    });

    test('should throw a RangeError if i2 out of range', () {
      final Matrix m = Matrix.fromRows([
        Vector.fromList([1, 2, 3, 4]),
        Vector.fromList([3, 4, 5, 6]),
        Vector.fromList([5, 6, 7, 8]),
      ]);

      expect(() => m.submatrix(0, 0, 10, 1), throwsRangeError);
    });

    test('should throw a RangeError if j2 out of range', () {
      final Matrix m = Matrix.fromRows([
        Vector.fromList([1, 2, 3, 4]),
        Vector.fromList([3, 4, 5, 6]),
        Vector.fromList([5, 6, 7, 8]),
      ]);

      expect(() => m.submatrix(0, 0, 2, 10), throwsRangeError);
    });

    test('should throw a RangeError if i1 greater than i2', () {
      final Matrix m = Matrix.fromRows([
        Vector.fromList([1, 2, 3, 4]),
        Vector.fromList([3, 4, 5, 6]),
        Vector.fromList([5, 6, 7, 8]),
      ]);

      expect(() => m.submatrix(1, 0, 0, 1), throwsRangeError);
    });

    test('should throw a RangeError if j1 greater than j2', () {
      final Matrix m = Matrix.fromRows([
        Vector.fromList([1, 2, 3, 4]),
        Vector.fromList([3, 4, 5, 6]),
        Vector.fromList([5, 6, 7, 8]),
      ]);

      expect(() => m.submatrix(0, 2, 2, 1), throwsRangeError);
    });

    test('should return a correct submatrix when indexed as expected', () {
      final Matrix m = Matrix.fromRows([
        Vector.fromList([1, 2, 3, 4]),
        Vector.fromList([3, 4, 5, 6]),
        Vector.fromList([5, 6, 7, 8]),
      ]);

      final Matrix submatrix = m.submatrix(1, 1, 2, 4);
      final Matrix expected = Matrix.fromRows([
        Vector.fromList([4, 5, 6]),
      ]);

      expect(submatrix, equals(expected));
    });
  });

  group('slice', () {
    test('should throw a RangeError if i out of range', () {
      final Matrix m = Matrix.fromRows([
        Vector.fromList([1, 2, 3, 4]),
        Vector.fromList([3, 4, 5, 6]),
        Vector.fromList([5, 6, 7, 8]),
      ]);

      expect(() => m.slice(5, 0), throwsRangeError);
    });

    test('should throw a RangeError if j out of range', () {
      final Matrix m = Matrix.fromRows([
        Vector.fromList([1, 2, 3, 4]),
        Vector.fromList([3, 4, 5, 6]),
        Vector.fromList([5, 6, 7, 8]),
      ]);

      expect(() => m.slice(1, 10), throwsRangeError);
    });

    test('should return matrix slice if i and j in range', () {
      final Matrix m = Matrix.fromRows([
        Vector.fromList([1, 2, 3, 4]),
        Vector.fromList([3, 4, 5, 6]),
        Vector.fromList([5, 6, 7, 8]),
      ]);

      final Matrix slice = m.slice(1, 2);
      final Matrix expected = Matrix.fromRows([
        Vector.fromList([1, 2, 4]),
        Vector.fromList([5, 6, 8])
      ]);

      expect(slice, equals(expected));
    });

    test('should not modify initial matrix', () {
      final Matrix m = Matrix.fromRows([
        Vector.fromList([1, 2, 3, 4]),
        Vector.fromList([3, 4, 5, 6]),
        Vector.fromList([5, 6, 7, 8]),
      ]);
      final List<int> size = m.size;

      m.slice(1, 2);

      expect(m.size, equals(size));
    });
  });

  group('det', () {
    test('should throw assertion error if matrix is not square', () {
      final Matrix m = Matrix.fromRows([
        Vector.fromList([1, 2]),
        Vector.fromList([3, 4]),
        Vector.fromList([5, 6]),
      ]);

      expect(() => m.det(), throwsA(isA<AssertionError>()));
    });

    test('should correctly compute determinant of square matrix', () {
      final Matrix m = Matrix.fromRows([
        Vector.fromList([1, 2, 3]),
        Vector.fromList([4, 5, 6]),
        Vector.fromList([7, 8, 10]),
      ]);

      expect(m.det(), equals(-3));
    });
  });

  group('transpose', () {
    test('should correctly transpose square matrix', () {
      final Matrix m1 = Matrix.fromRows([
        Vector.fromList([1, 2]),
        Vector.fromList([3, 4]),
      ]);

      final Matrix m1t = Matrix.fromRows([
        Vector.fromList([1, 3]),
        Vector.fromList([2, 4]),
      ]);

      expect(m1.transpose(), equals(m1t));
    });

    test('should correctly transpose nonsquare matrix', () {
      final Matrix m1 = Matrix.fromRows([
        Vector.fromList([1, 2]),
        Vector.fromList([3, 4]),
        Vector.fromList([5, 6]),
      ]);

      final Matrix m1t = Matrix.fromRows([
        Vector.fromList([1, 3, 5]),
        Vector.fromList([2, 4, 6]),
      ]);

      expect(m1.transpose(), equals(m1t));
    });
  });

  group('inverse', () {
    test('should throw assertion error if matrix is not square', () {
      final Matrix m = Matrix.fromRows([
        Vector.fromList([1, 2]),
        Vector.fromList([3, 4]),
        Vector.fromList([5, 6]),
      ]);

      expect(() => m.inverse(), throwsA(isA<AssertionError>()));
    });

    test('should throw assertion error if matrix is singular', () {
      final Matrix m = Matrix.fromRows([
        Vector.fromList([1, 2, 3]),
        Vector.fromList([4, 5, 6]),
        Vector.fromList([7, 8, 9]),
      ]);

      expect(() => m.inverse(), throwsA(isA<AssertionError>()));
    });

    test('should compute inverse correctly if matrix is invertible', () {
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
  });

  group('row', () {
    test('should return correct row', () {
      final Matrix m1 = Matrix.fromRows([
        Vector.fromList([1, 2]),
        Vector.fromList([3, 4]),
        Vector.fromList([5, 6]),
      ]);

      expect(m1.row(1), equals(Vector.fromList([3, 4])));
    });
  });

  group('col', () {
    test('should return correct col', () {
      final Matrix m1 = Matrix.fromRows([
        Vector.fromList([1, 2]),
        Vector.fromList([3, 4]),
        Vector.fromList([5, 6]),
      ]);

      expect(m1.col(1), equals(Vector.fromList([2, 4, 6])));
    });
  });

  group('scale', () {
    test('should correctly multiply matrix with double scalar', () {
      final Matrix m1 = Matrix.fromRows([
        Vector.fromList([1, 2]),
        Vector.fromList([3, 4]),
        Vector.fromList([5, 6]),
      ]);

      final Matrix scaled = Matrix.fromRows([
        Vector.fromList([2, 4]),
        Vector.fromList([6, 8]),
        Vector.fromList([10, 12]),
      ]);

      expect(m1.scale(2), equals(scaled));
    });
  });

  group('dotL', () {
    test(
      'should throw assertion error if vector size and ncols mismatch',
      () {
        final Vector v = Vector.ones(3);
        final Matrix m = Matrix.eye(2);

        expect(() => m.dotL(v), throwsA(isA<AssertionError>()));
      },
    );

    test('should correctly multiply matrix with vector from right', () {
      final Vector v = Vector.ones(3);
      final Matrix m = Matrix.eye(3).scale(4);

      expect(m.dotL(v), equals(Vector.ones(3).scale(4)));
    });
  });

  group('dotR', () {
    test(
      'should throw assertion error if vector size and ncols mismatch',
      () {
        final Vector v = Vector.ones(3);
        final Matrix m = Matrix.eye(2);

        expect(() => m.dotR(v), throwsA(isA<AssertionError>()));
      },
    );

    test('should correctly multiply matrix with vector from right', () {
      final Vector v = Vector.ones(3);
      final Matrix m = Matrix.eye(3).scale(4);

      expect(m.dotR(v), equals(Vector.ones(3).scale(4)));
    });
  });

  group('operator +', () {
    test('should correctly sum square matrices', () {
      final Matrix m1 = Matrix.fromRows([
        Vector.fromList([1, 2]),
        Vector.fromList([3, 4]),
      ]);

      final Matrix m2 = Matrix.fromRows([
        Vector.fromList([5, 6]),
        Vector.fromList([7, 8]),
      ]);

      final Matrix sum = Matrix.fromRows([
        Vector.fromList([6, 8]),
        Vector.fromList([10, 12]),
      ]);

      expect(m1 + m2, equals(sum));
    });

    test('should correctly sum nonsquare matrices', () {
      final Matrix m1 = Matrix.fromRows([
        Vector.fromList([1, 2]),
        Vector.fromList([3, 4]),
        Vector.fromList([5, 6]),
      ]);

      final Matrix m2 = Matrix.fromRows([
        Vector.fromList([7, 8]),
        Vector.fromList([9, 10]),
        Vector.fromList([11, 12]),
      ]);

      final Matrix sum = Matrix.fromRows([
        Vector.fromList([8, 10]),
        Vector.fromList([12, 14]),
        Vector.fromList([16, 18]),
      ]);

      expect(m1 + m2, equals(sum));
    });

    test('should throw error on dimension mismatch', () {
      final Matrix m1 = Matrix.fromRows([
        Vector.fromList([1, 2]),
        Vector.fromList([3, 4]),
      ]);

      final Matrix m2 = Matrix.fromRows([
        Vector.fromList([5, 6]),
        Vector.fromList([7, 8]),
        Vector.fromList([9, 10]),
      ]);

      expect(() => m1 + m2, throwsA(isA<AssertionError>()));
    });
  });

  group('operator -', () {
    test('should correctly diff square matrices', () {
      final Matrix m1 = Matrix.fromRows([
        Vector.fromList([1, 2]),
        Vector.fromList([3, 4]),
      ]);

      final Matrix m2 = Matrix.fromRows([
        Vector.fromList([5, 6]),
        Vector.fromList([7, 8]),
      ]);

      final Matrix diff = Matrix.fromRows([
        Vector.fromList([-4, -4]),
        Vector.fromList([-4, -4]),
      ]);

      expect(m1 - m2, equals(diff));
    });

    test('should correctly diff nonsquare matrices', () {
      final Matrix m1 = Matrix.fromRows([
        Vector.fromList([1, 2]),
        Vector.fromList([3, 4]),
        Vector.fromList([5, 6]),
      ]);

      final Matrix m2 = Matrix.fromRows([
        Vector.fromList([7, 8]),
        Vector.fromList([9, 10]),
        Vector.fromList([11, 12]),
      ]);

      final Matrix diff = Matrix.fromRows([
        Vector.fromList([-6, -6]),
        Vector.fromList([-6, -6]),
        Vector.fromList([-6, -6]),
      ]);

      expect(m1 - m2, equals(diff));
    });

    test('should throw error on dimension mismatch', () {
      final Matrix m1 = Matrix.fromRows([
        Vector.fromList([1, 2]),
        Vector.fromList([3, 4]),
      ]);

      final Matrix m2 = Matrix.fromRows([
        Vector.fromList([5, 6]),
        Vector.fromList([7, 8]),
        Vector.fromList([9, 10]),
      ]);

      expect(() => m1 - m2, throwsA(isA<AssertionError>()));
    });
  });

  group('operator *', () {
    test('should correctly multiply square matrices', () {
      final Matrix m1 = Matrix.fromRows([
        Vector.fromList([1, 2]),
        Vector.fromList([3, 4]),
      ]);

      final Matrix m2 = Matrix.fromRows([
        Vector.fromList([5, 6]),
        Vector.fromList([7, 8]),
      ]);

      final Matrix prod = Matrix.fromRows([
        Vector.fromList([19, 22]),
        Vector.fromList([43, 50]),
      ]);

      expect(m1 * m2, equals(prod));
    });

    test('should correctly multiply matrices of different sizes', () {
      final Matrix m1 = Matrix.fromRows([
        Vector.fromList([1, 2]),
        Vector.fromList([3, 4]),
      ]);

      final Matrix m2 = Matrix.fromRows([
        Vector.fromList([5, 6, 9]),
        Vector.fromList([7, 8, 10]),
      ]);

      final Matrix prod = Matrix.fromRows([
        Vector.fromList([19, 22, 29]),
        Vector.fromList([43, 50, 67]),
      ]);

      expect(m1 * m2, equals(prod));
    });

    test('should throw error on dimension mismatch', () {
      final Matrix m1 = Matrix.fromRows([
        Vector.fromList([1, 2]),
        Vector.fromList([3, 4]),
      ]);

      final Matrix m2 = Matrix.fromRows([
        Vector.fromList([5, 6]),
        Vector.fromList([7, 8]),
        Vector.fromList([9, 10]),
      ]);

      expect(() => m1 * m2, throwsA(isA<AssertionError>()));
    });
  });

  group('operator %', () {
    test(
      'should throw assertion error if vector size and ncols mismatch',
      () {
        final Vector v = Vector.ones(3);
        final Matrix m = Matrix.eye(2);

        expect(() => m % v, throwsA(isA<AssertionError>()));
      },
    );

    test('should correctly multiply matrix with vector from right', () {
      final Vector v = Vector.ones(3);
      final Matrix m = Matrix.eye(3).scale(4);

      expect(m % v, equals(Vector.ones(3).scale(4)));
    });
  });

  group('operator []', () {
    test('should get correct element when index in range', () {
      final Vector v = Vector.fromList([4, 5, 6]);
      final Matrix m = Matrix.fromRows([
        Vector.fromList([1, 2, 3]),
        v
      ]);
      expect(m[1], equals(v));
    });

    test('should throw RangeError when index out of range', () {
      final Matrix m = Matrix.fromRows([
        Vector.fromList([1, 2, 3])
      ]);
      expect(() => m[1], throwsRangeError);
    });
  });

  group('operator []=', () {
    test(
      'should throw ArgumentError if setting vector with wrong number of elements',
      () {
        final Matrix m = Matrix.fromRows([
          Vector.fromList([1, 2, 3]),
          Vector.fromList([4, 5, 6]),
        ]);

        expect(
          () => m[1] = Vector.ones(4),
          throwsA(isA<ArgumentError>()),
        );
      },
    );

    test('should throw RangeError if index out of range', () {
      final Matrix m = Matrix.fromRows([
        Vector.fromList([1, 2, 3]),
        Vector.fromList([4, 5, 6]),
      ]);

      expect(() => m[2] = Vector.ones(3), throwsRangeError);
    });

    test(
      'should correctly set element when index in range and correct number of elements',
      () {
        final Matrix m = Matrix.fromRows([
          Vector.fromList([1, 2, 3]),
          Vector.fromList([4, 5, 6]),
        ]);
        final Vector newVector = Vector.fromList([7, 7, 7]);

        m[1] = newVector;

        expect(m[1], equals(newVector));
      },
    );
  });
}

void expectMatricesAlmostEqual(Matrix left, Matrix expectedLeft) {}
