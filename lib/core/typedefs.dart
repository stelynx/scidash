import 'package:scidash/core/matrix.dart';
import 'package:scidash/core/vector.dart';

typedef ScalarFunction = double Function(Vector);
typedef VectorFunction = Vector Function(Vector);
typedef MatrixFunction = Matrix Function(Vector);
typedef IterationFunction<T> = T Function(int);
