class NDArray<T> {
  NDArray(List ndarray) : _els = ndarray {
    _dims = _calculateDimensions(ndarray).reversed.toList();
  }

  final List _els;

  late final List<int> _dims;
  List<int> get dimensions => _dims;
  int get n => _dims.length;

  Type get type => T;

  List<int> _calculateDimensions(List ndarray) {
    if (ndarray.isEmpty) throw RangeError('ndarray is empty');
    if (!(ndarray.first is List)) {
      if (!(ndarray.first is T)) throw TypeError();
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

  @override
  String toString() {
    return 'NDArray<$T>($_els)';
  }
}
