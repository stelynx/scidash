import 'package:scidash/core/matrix.dart';
import 'package:scidash/core/vector.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('Vector.zeros', () {
    test('should correctly construct vector of given size with zeros', () {
      int n = 4;
      final Vector v = Vector.zeros(n);

      expect(v.size, equals(n));
      expect(v.elements, equals(List<double>.filled(n, 0)));
    });
  });

  group('Vector.ones', () {
    test('should correctly construct vector of given size with ones', () {
      int n = 4;
      final Vector v = Vector.ones(n);

      expect(v.size, equals(n));
      expect(v.elements, equals(List<double>.filled(n, 1)));
    });
  });

  group('get elements', () {
    test('should return list of elements', () {
      final List<double> els = [1, 2, 3];
      final Vector v = Vector.fromList(els);

      expect(v.elements, equals(els));
    });
  });

  group('get size', () {
    test('should return correct size', () {
      final List<double> els = [1, 2, 3];
      final Vector v = Vector.fromList(els);

      expect(v.size, equals(els.length));
    });
  });

  group('subvector', () {
    test('should throw RangeError if start out of range', () {
      final Vector v = Vector.fromList([0, 1, 2, 3, 4, 5, 6, 7]);

      expect(() => v.subvector(10), throwsRangeError);
    });

    test('should throw RangeError if end out of range', () {
      final Vector v = Vector.fromList([0, 1, 2, 3, 4, 5, 6, 7]);

      expect(() => v.subvector(0, 10), throwsRangeError);
    });

    test('should throw RangeError if start greater than end', () {
      final Vector v = Vector.fromList([0, 1, 2, 3, 4, 5, 6, 7]);

      expect(() => v.subvector(5, 4), throwsRangeError);
    });

    test('should return subvector if range is ok', () {
      final Vector v = Vector.fromList([0, 1, 2, 3, 4, 5, 6, 7]);

      expect(v.subvector(1, 5), equals(Vector.fromList([1, 2, 3, 4])));
    });
  });

  group('remove', () {
    test('should throw RangeError if i out of range', () {
      final Vector v = Vector.fromList([0, 1, 2, 3, 4, 5, 6, 7]);

      expect(() => v.remove(10), throwsRangeError);
    });

    test('should return new vector with missing element at given index', () {
      final Vector v = Vector.fromList([0, 1, 2, 3, 4, 5, 6, 7]);

      final Vector result = v.remove(5);
      final Vector expected = Vector.fromList([0, 1, 2, 3, 4, 6, 7]);
      expect(result, equals(expected));
    });
  });

  group('norm', () {
    test('should return correct norm of a vector', () {
      final Vector v = Vector.fromList([3, 4]);

      expect(v.norm(), equals(5));
    });
  });

  group('asMatrix', () {
    test('should return matrix with single row', () {
      final Vector v = Vector.fromList([1, 2, 3]);

      expect(
        v.asMatrix(),
        equals(Matrix.fromRows([
          Vector.fromList([1, 2, 3])
        ])),
      );
    });
  });

  group('scale', () {
    test('should correctly scale the vector', () {
      final Vector v = Vector.fromList([1, 2, 3]);
      final double a = 2.5;

      final Vector vScaled = Vector.fromList([a * v[0], a * v[1], a * v[2]]);
      expect(v.scale(a), equals(vScaled));
    });
  });

  group('dot', () {
    test('should throw assertion error if vectors size mismatch', () {
      final Vector v1 = Vector.zeros(3);
      final Vector v2 = Vector.zeros(4);

      expect(() => v1.dot(v2), throwsA(isA<AssertionError>()));
    });

    test('should correctly compute dot product if sizes match', () {
      final Vector v1 = Vector.fromList([1, 2, 3]);
      final Vector v2 = Vector.fromList([4, 5, 6]);

      expect(v1.dot(v2), equals(32));
    });
  });

  group('operator +', () {
    test(
      'should throw assertion error if vectors are of different size',
      () {
        final Vector v1 = Vector.fromList([1, 2]);
        final Vector v2 = Vector.fromList([1, 2, 3]);

        expect(() => v1 + v2, throwsA(isA<AssertionError>()));
      },
    );

    test('should correctly sum vectors of same size', () {
      final Vector v1 = Vector.fromList([1, 2, 3]);
      final Vector v2 = Vector.fromList([4, 5, 6]);
      final Vector sum = Vector.fromList([
        v1[0] + v2[0],
        v1[1] + v2[1],
        v1[2] + v2[2],
      ]);

      expect(v1 + v2, equals(sum));
    });
  });

  group('operator -', () {
    test(
      'should throw assertion error if vectors are of different size',
      () {
        final Vector v1 = Vector.fromList([1, 2]);
        final Vector v2 = Vector.fromList([1, 2, 3]);

        expect(() => v1 - v2, throwsA(isA<AssertionError>()));
      },
    );

    test('should correctly subtract vectors of same size', () {
      final Vector v1 = Vector.fromList([1, 2, 3]);
      final Vector v2 = Vector.fromList([4, 5, 6]);
      final Vector diff = Vector.fromList([
        v1[0] - v2[0],
        v1[1] - v2[1],
        v1[2] - v2[2],
      ]);

      expect(v1 - v2, equals(diff));
    });
  });

  group('operator %', () {
    test('should throw assertion error if vectors size mismatch', () {
      final Vector v1 = Vector.zeros(3);
      final Vector v2 = Vector.zeros(4);

      expect(() => v1 % v2, throwsA(isA<AssertionError>()));
    });

    test('should correctly compute dot product if sizes match', () {
      final Vector v1 = Vector.fromList([1, 2, 3]);
      final Vector v2 = Vector.fromList([4, 5, 6]);

      expect(v1 % v2, equals(32));
    });
  });

  group('operator []', () {
    test('should throw RangeError if index out of range', () {
      final Vector v1 = Vector.fromList([1, 2, 3]);

      expect(() => v1[3], throwsRangeError);
    });

    test('should return correct element when index in range', () {
      final Vector v1 = Vector.fromList([1, 2, 3]);

      expect(v1[1], equals(2));
    });
  });

  group('operator []=', () {
    test('should throw RangeError if index out of range', () {
      final Vector v1 = Vector.fromList([1, 2, 3]);

      expect(() => v1[3] = 4, throwsRangeError);
    });

    test('should correctly set element when index in range', () {
      final Vector v1 = Vector.fromList([1, 2, 3]);

      v1[1] = 10;

      expect(v1[1], equals(10));
    });
  });
}
