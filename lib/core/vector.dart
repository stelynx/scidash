import 'dart:math';

import 'package:scidash/core/matrix.dart';

class Vector {
  Vector.fromList(List<double> elements)
      : _els = List<double>.from(elements, growable: false);

  Vector.zeros(int n) : _els = List<double>.filled(n, 0.0);
  Vector.ones(int n) : _els = List<double>.filled(n, 1.0);

  final List<double> _els;
  List<double> get elements => _els;

  int get size => _els.length;

  Vector subvector(int start, [int? end]) {
    return Vector.fromList(elements.sublist(start, end));
  }

  Vector remove(int i) {
    if (i < 0 || i > size) throw RangeError('Removing index out of range');

    final List<double> newElements = <double>[];
    for (int n = 0; n < size; n++) {
      if (n != i) newElements.add(_els[n]);
    }
    return Vector.fromList(newElements);
  }

  double norm() {
    double n = 0.0;
    _els.forEach((double x) => n += pow(x, 2));
    return sqrt(n);
  }

  Matrix asMatrix() => Matrix.fromRows([this]);

  Vector scale(double x) =>
      Vector.fromList(_els.map<double>((double el) => x * el).toList());

  Vector copy() => Vector.fromList(List<double>.from(elements));

  double dot(Vector v) {
    assert(v.size == this.size);

    double result = 0.0;
    for (int i = 0; i < this.size; i++) {
      result += this[i] * v[i];
    }
    return result;
  }

  Vector operator +(Vector other) {
    assert(this.size == other.size, "Vector dimensions mismatch");

    final List<double> newEls = List<double>.from(this.elements);
    for (int i = 0; i < newEls.length; i++) {
      newEls[i] += other.elements[i];
    }

    return Vector.fromList(newEls);
  }

  Vector operator -(Vector other) {
    assert(this.size == other.size, "Vector dimensions mismatch");

    final List<double> newEls = List<double>.from(this.elements);
    for (int i = 0; i < newEls.length; i++) {
      newEls[i] -= other.elements[i];
    }

    return Vector.fromList(newEls);
  }

  double operator %(Vector v) => this.dot(v);

  double operator [](int i) => _els[i];
  void operator []=(int i, double x) => _els[i] = x;

  @override
  bool operator ==(Object o) {
    if (!(o is Vector)) return false;

    final Vector other = o;
    for (int i = 0; i < size; i++) {
      if (this[i] != other[i]) return false;
    }

    return true;
  }

  @override
  String toString() => 'Vector(${elements.toString()})';
}
