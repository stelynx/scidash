class Pair<T> {
  const Pair(T left, T right)
      : _l = left,
        _r = right;

  final T _l;
  T get left => _l;

  final T _r;
  T get right => _r;
}
