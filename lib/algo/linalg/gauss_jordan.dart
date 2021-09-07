import 'package:scidash/core/matrix.dart';
import 'package:scidash/util/defs/pair.dart';

Pair<Matrix> gaussJordan(Matrix lhs, Matrix rhs) {
  assert(lhs.nrows == rhs.nrows,
      'Matrices lhs and rhs must have the same number of cols');

  final Matrix lhso = lhs.copy();
  final Matrix rhso = rhs.copy();

  for (int i = 0; i < lhso.nrows; i++) {
    // TODO swap rows if lhso[i][i] = 0
    final double k = 1 / lhso[i][i];
    lhso[i] = lhso[i].scale(k);
    rhso[i] = rhso[i].scale(k);

    for (int ii = i + 1; ii < lhso.nrows; ii++) {
      final double k = lhso[ii][i];
      lhso[ii] = lhso[ii] - lhso[i].scale(k);
      rhso[ii] = rhso[ii] - rhso[i].scale(k);
    }
  }

  for (int i = lhso.nrows - 1; i >= 0; i--) {
    for (int ii = i - 1; ii >= 0; ii--) {
      final double k = lhso[ii][i];
      lhso[ii] = lhso[ii] - lhso[i].scale(k);
      rhso[ii] = rhso[ii] - rhso[i].scale(k);
    }
  }

  return Pair<Matrix>(lhso, rhso);
}
