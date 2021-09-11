import 'dart:math';

class Complex {
  const Complex(double real, double imaginary)
      : _re = real,
        _im = imaginary;

  Complex.polar(double r, double theta)
      : _re = r * cos(theta),
        _im = r * sin(theta);

  final double _re;
  double get re => _re;
  double get x => _re;

  final double _im;
  double get im => _im;
  double get y => _im;

  double get r => norm();
  double get theta => atan2(_im, _re);

  bool get isReal => _im == 0;
  bool get isImaginary => _re == 0;

  double norm() {
    return sqrt(pow(_re, 2) + pow(_im, 2));
  }

  Complex conjugate() => Complex(_re, -_im);

  Complex scale(double x) => Complex(x * _re, x * _im);

  Complex operator +(Complex other) {
    return Complex(this._re + other._re, this._im + other._im);
  }

  Complex operator -(Complex other) {
    return Complex(this._re - other._re, this._im - other._im);
  }

  Complex operator *(Complex other) {
    return Complex(this._re * other._re - this._im * other._im,
        this._re * other._im + this._im * other._re);
  }

  bool operator ==(Object o) {
    if (!(o is Complex)) return false;

    final Complex other = o;
    return this._re == other._re && this._im == other._im;
  }

  double toDouble() {
    assert(isReal,
        'Complex number with imaginary part cannot be converted to double');

    return _re;
  }

  @override
  String toString() {
    return 'Complex($_re, $_im)';
  }
}
