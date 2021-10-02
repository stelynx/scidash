import 'package:scidash/core/matrix.dart';
import 'package:scidash/core/typedefs.dart';
import 'package:scidash/core/vector.dart';

enum QuasiNewtonMethod { bfgs, broyden }

Vector quasiNewtonF(
  ScalarFunction f,
  VectorFunction gradF,
  Vector x0,
  double eta,
  double eps, [
  QuasiNewtonMethod method = QuasiNewtonMethod.bfgs,
]) {
  bool done = false;
  Vector x1 = x0.copy();

  final Matrix Function(Matrix, Matrix, Matrix) step;
  switch (method) {
    case QuasiNewtonMethod.bfgs:
      step = (Matrix inverseHessianF, Matrix deltaX, Matrix deltaGradF) {
        final Matrix differ = (deltaX.transpose() * deltaGradF)
            .scale((deltaX * deltaGradF.transpose())[0][0]);
        return (Matrix.eye(inverseHessianF.nrows) - differ) *
                inverseHessianF *
                (Matrix.eye(inverseHessianF.nrows) - differ).transpose() +
            (deltaX.transpose() * deltaX)
                .scale((deltaX * deltaGradF.transpose())[0][0]);
      };
      break;
    case QuasiNewtonMethod.broyden:
      throw UnimplementedError();
  }

  Matrix inverseHessianF = Matrix.eye(x0.size);

  while (!done) {
    final Vector gradFX1 = gradF(x1);
    final Vector x2 = x1 - (inverseHessianF % gradFX1).scale(eta);

    assert(
      !x2.elements.any((double el) => el.isNaN || el.isInfinite),
      "A NaN or Infinite value encountered",
    );

    final Matrix deltaX = (x2 - x1).asMatrix();
    final Matrix deltaGradF = (gradF(x2) - gradFX1).asMatrix();

    inverseHessianF = step(inverseHessianF, deltaX, deltaGradF);

    done = (x2 - x1).norm() < eps;
    x1 = x2.copy();
  }

  return x1;
}
