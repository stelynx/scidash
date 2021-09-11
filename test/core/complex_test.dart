import 'dart:math';

import 'package:scidash/core/complex.dart';
import 'package:test/test.dart';

void main() {
  group('Complex.polar', () {
    test('should calculate re and im correctly', () {
      final Complex z = Complex.polar(1, pi / 3);

      expect(z.re, closeTo(0.5, pow(10, -10)));
      expect(z.im, equals(sqrt(3) / 2));
    });
  });

  group('get re', () {
    test('should return real part', () {
      final Complex z = Complex(1, 2);

      expect(z.re, equals(1));
    });
  });

  group('get x', () {
    test('should return real part', () {
      final Complex z = Complex(1, 2);

      expect(z.re, equals(1));
    });
  });

  group('get im', () {
    test('should return imaginary part', () {
      final Complex z = Complex(1, 2);

      expect(z.im, equals(2));
    });
  });

  group('get y', () {
    test('should return imaginary part', () {
      final Complex z = Complex(1, 2);

      expect(z.im, equals(2));
    });
  });

  group('get r', () {
    test('should return norm of a vector', () {
      final Complex z = Complex(1, 1);

      expect(z.r, equals(sqrt(2)));
    });
  });

  group('get theta', () {
    test('should return correct angle in 1st quadrant', () {
      final Complex z = Complex(1, 1);

      expect(z.theta, equals(pi / 4));
    });

    test('should return correct angle in 2nd quadrant', () {
      final Complex z = Complex(-1, 1);

      expect(z.theta, equals(3 * pi / 4));
    });

    test('should return correct angle in 3rd quadrant', () {
      final Complex z = Complex(-1, -1);

      expect(z.theta, equals(-3 * pi / 4));
    });

    test('should return correct angle in 4th quadrant', () {
      final Complex z = Complex(1, -1);

      expect(z.theta, equals(-pi / 4));
    });
  });

  group('isReal', () {
    test('should return true if imaginary part is 0', () {
      final Complex z = Complex(1, 0);

      expect(z.isReal, isTrue);
    });

    test('should return false if imaginary part is not 0', () {
      final Complex z = Complex(1, 1);

      expect(z.isReal, isFalse);
    });
  });

  group('isImaginary', () {
    test('should return true if real part is 0', () {
      final Complex z = Complex(0, 1);

      expect(z.isImaginary, isTrue);
    });

    test('should return false if real part is not 0', () {
      final Complex z = Complex(1, 1);

      expect(z.isImaginary, isFalse);
    });
  });

  group('norm', () {
    test('should return distance from origin', () {
      final Complex z = Complex(3, 4);

      expect(z.norm(), equals(5));
    });
  });

  group('conjugate', () {
    test('should negate imaginary component', () {
      final Complex z = Complex(3, 4);
      final Complex conjugated = Complex(3, -4);

      expect(z.conjugate(), equals(conjugated));
    });
  });

  group('scale', () {
    test('should multiply real and imaginary part with scaling factor', () {
      final Complex z = Complex(3, 4);

      final Complex result = z.scale(2.5);
      final Complex expected = Complex(2.5 * 3, 2.5 * 4);
      expect(result, equals(expected));
    });
  });

  group('operator +', () {
    test('should sum complex numbers by parts', () {
      final Complex z1 = Complex(3, 4);
      final Complex z2 = Complex(5, -2);

      final Complex expected = Complex(3 + 5, 4 - 2);
      expect(z1 + z2, equals(expected));
    });
  });

  group('operator -', () {
    test('should subtract complex numbers by parts', () {
      final Complex z1 = Complex(3, 4);
      final Complex z2 = Complex(5, -2);

      final Complex expected = Complex(3 - 5, 4 + 2);
      expect(z1 - z2, equals(expected));
    });
  });

  group('operator *', () {
    test('should multiply complex numbers as expected', () {
      final Complex z1 = Complex(3, 4);
      final Complex z2 = Complex(5, -2);

      final Complex expected = Complex(23, 14);
      expect(z1 * z2, equals(expected));
    });
  });

  group('toDouble', () {
    test('should throw assertion error if imaginary part not 0', () {
      final Complex z = Complex(3, 4);

      expect(z.toDouble, throwsA(isA<AssertionError>()));
    });

    test('should return real part as double if imaginary part is 0', () {
      final Complex z = Complex(3.5, 0);

      expect(z.toDouble(), isA<double>());
      expect(z.toDouble(), equals(3.5));
    });
  });

  group('toString', () {
    test('should return string representation', () {
      final Complex z = Complex(42.0, 37.1);

      expect(z.toString(), equals('Complex(${z.re}, ${z.im})'));
    });
  });
}
