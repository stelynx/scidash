import 'package:scidash/algo/linalg/gauss_jordan.dart';
import 'package:scidash/core/vector.dart';

class Matrix {
  Matrix.fromRows(List<Vector> rows)
      : _rows = rows.map((Vector e) => e.copy()).toList();

  Matrix.zeros(int nrows, int ncols)
      : assert(nrows > 0 && ncols > 0),
        _rows = List<Vector>.filled(nrows, Vector.zeros(ncols));

  Matrix.ones(int nrows, int ncols)
      : assert(nrows > 0 && ncols > 0),
        _rows = List<Vector>.filled(nrows, Vector.ones(ncols));

  Matrix.eye(int size)
      : assert(size > 0),
        _rows = List<Vector>.generate(size, (int i) {
          final Vector col = Vector.zeros(size);
          col[i] = 1;
          return col;
        });

  List<Vector> _rows;
  List<Vector> get rows => _rows;

  List<int> get size => <int>[nrows, ncols];
  int get nrows => _rows.length;
  int get ncols => _rows[0].size;

  bool get isSquare => nrows == ncols;
  bool get isNotSquare => nrows != ncols;

  bool isSingular() => this.det() == 0;

  Matrix copy() =>
      Matrix.fromRows(rows.map<Vector>((Vector v) => v.copy()).toList());

  Matrix submatrix(int i1, int j1, int i2, int j2) {
    return Matrix.fromRows(this
        .rows
        .sublist(i1, i2)
        .map<Vector>((Vector row) => row.subvector(j1, j2))
        .toList());
  }

  Matrix slice(int i, int j) {
    final List<Vector> newRows = List<Vector>.from(this.rows);
    newRows.removeAt(i);
    return Matrix.fromRows(
        newRows.map<Vector>((Vector row) => row.copy().remove(j)).toList());
  }

  double det() {
    assert(this.isSquare, 'Determinant of nonsquare matrix is undefined');

    if (this.nrows == 1 && this.ncols == 1) return this[0][0];

    double result = 0;
    for (int j = 0; j < ncols; j++) {
      result += (j % 2 == 0 ? 1 : -1) * this[0][j] * this.slice(0, j).det();
    }

    return result;
  }

  Matrix transpose() {
    final List<Vector> cols = <Vector>[];
    for (int j = 0; j < ncols; j++) {
      final List<double> col = <double>[];
      for (int i = 0; i < nrows; i++) {
        col.add(_rows[i][j]);
      }
      cols.add(Vector.fromList(col));
    }
    return Matrix.fromRows(cols);
  }

  Matrix inverse() {
    assert(!isSingular(), 'Inverse of singular matrix is undefined');

    return gaussJordan(this, Matrix.eye(this.nrows)).right;
  }

  Vector row(int i) {
    return this[i];
  }

  Vector col(int j) {
    final List<double> col = <double>[];
    for (int i = 0; i < nrows; i++) {
      col.add(this[i][j]);
    }
    return Vector.fromList(col);
  }

  Matrix scale(double x) {
    final List<Vector> rows = <Vector>[];
    _rows.forEach(
      (Vector row) => rows.add(
        Vector.fromList(
          row.elements.map<double>((double e) => x * e).toList(),
        ),
      ),
    );
    return Matrix.fromRows(rows);
  }

  Vector dotL(Vector v) {
    assert(v.size == this.nrows, 'Vector must be of size nrows');

    final Vector result = Vector.zeros(this.ncols);
    for (int j = 0; j < this.ncols; j++) {
      for (int i = 0; i < this.nrows; i++) {
        result[j] += this[i][j] * v[i];
      }
    }
    return result;
  }

  Vector dotR(Vector v) {
    assert(v.size == this.ncols, 'Vector must be of size ncols');

    return Vector.fromList(_rows.map<double>((Vector row) => row % v).toList());
  }

  Matrix operator +(Matrix other) {
    assert(this.nrows == other.nrows && this.ncols == other.ncols,
        "Matrix dimensions mismatch");

    final List<Vector> rowsResult = <Vector>[];
    for (int i = 0; i < nrows; i++) {
      rowsResult.add(this[i] + other[i]);
    }

    return Matrix.fromRows(rowsResult);
  }

  Matrix operator -(Matrix other) {
    assert(this.nrows == other.nrows && this.ncols == other.ncols,
        "Matrix dimensions mismatch");

    final List<Vector> rowsResult = <Vector>[];
    for (int i = 0; i < nrows; i++) {
      rowsResult.add(this[i] - other[i]);
    }

    return Matrix.fromRows(rowsResult);
  }

  Matrix operator *(Matrix other) {
    assert(this.ncols == other.nrows,
        "LHS matrix ncols do not match RHS matrix nrows");

    final List<Vector> rowsResult = <Vector>[];
    for (int i = 0; i < nrows; i++) {
      final List<double> row = List.filled(other.ncols, 0.0);
      for (int j = 0; j < other.ncols; j++) {
        for (int k = 0; k < ncols; k++) {
          row[j] += this[i][k] * other[k][j];
        }
      }
      rowsResult.add(Vector.fromList(row));
    }

    return Matrix.fromRows(rowsResult);
  }

  Vector operator %(Vector v) => this.dotR(v);

  Vector operator [](int i) => _rows[i];
  void operator []=(int i, Vector v) {
    if (v.size != ncols)
      throw ArgumentError.value(
        v,
        'Dimension mismatch',
        'Trying to add vector of size ${v.size} into matrix with $ncols cols',
      );

    _rows[i] = v.copy();
  }

  @override
  bool operator ==(Object o) {
    if (!(o is Matrix)) return false;

    final Matrix other = o;
    if (this.nrows != other.nrows || this.ncols != other.ncols) return false;
    for (int i = 0; i < nrows; i++) {
      for (int j = 0; j < ncols; j++) {
        if (this[i][j] != other[i][j]) return false;
      }
    }
    return true;
  }

  @override
  String toString() {
    String s = 'Matrix(\n';
    for (int i = 0; i < nrows; i++) {
      s += _rows[i].toString() + '\n';
    }
    return s + ')';
  }
}
