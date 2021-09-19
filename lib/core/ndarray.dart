import 'package:scidash/core/complex.dart';

class NDArray<T> {
  NDArray(List ndarray) : _els = ndarray {
    _dims = _calculateDimensions(ndarray).reversed.toList();
  }

  final List _els;

  late final List<int> _dims;
  List<int> get dimensions => _dims;
  int get n => _dims.length;

  Type get type => T;

  NDArray slice(List<List<int>> ranges) {
    assert(ranges.length == n,
        'length of ranges does not equal number of dimensions');
    throw UnimplementedError();
  }

  List<int> _calculateDimensions(List ndarray) {
    if (ndarray.isEmpty) throw RangeError('ndarray is empty');
    if (ndarray.first is! List) {
      if (ndarray.first is! T) throw TypeError();
      return [ndarray.length];
    }

    final List<int> firstChildDimensions = _calculateDimensions(ndarray.first);
    for (int i = 1; i < ndarray.length; i++) {
      final List<int> childDimensions = _calculateDimensions(ndarray[i]);
      for (int j = 0; j < firstChildDimensions.length; j++) {
        if (firstChildDimensions[j] != childDimensions[j])
          throw ArgumentError('array dimensions mismatch');
      }
    }
    firstChildDimensions.add(ndarray.length);
    return firstChildDimensions;
  }

  void _traverseAndOperateOnElementWith(T Function(T) f, [List? l]) {
    if (l == null) l = _els;

    if (l.first is! List) {
      for (int i = 0; i < l.length; i++) {
        l[i] = f(l[i]);
      }
      return;
    }

    for (List child in l) _traverseAndOperateOnElementWith(f, child);
  }

  @override
  bool operator ==(Object o) {
    if (o is! NDArray) return false;

    final NDArray other = o;
    return other._els == this._els;
  }

  @override
  String toString() {
    return 'NDArray<$T>($_els)';
  }
}

class NDDoubleArray extends NDArray<double> {
  NDDoubleArray(List ndarray) : super(ndarray);

  NDDoubleArray scale(double x) {
    _traverseAndOperateOnElementWith((double el) => el * x);
    return this;
  }

  NDDoubleArray operator +(NDDoubleArray other) {
    throw UnimplementedError();
  }

  NDDoubleArray operator -(NDDoubleArray other) {
    throw UnimplementedError();
  }

  NDDoubleArray operator *(NDDoubleArray other) {
    throw UnimplementedError();
  }

  NDDoubleArray operator /(NDDoubleArray other) {
    throw UnimplementedError();
  }

  NDDoubleArray operator [](List<int> indices) {
    throw UnimplementedError();
  }

  void operator []=(List<int> indices, double newValue) {
    throw UnimplementedError();
  }

  @override
  String toString() {
    return 'NDDoubleArray($_els)';
  }
}
