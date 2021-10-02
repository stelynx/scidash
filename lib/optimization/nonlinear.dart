import 'package:scidash/core/typedefs.dart';
import 'package:scidash/core/vector.dart';
import 'package:scidash/optimization/optimization_result.dart';
import 'package:scidash/optimization/optimizer.dart';

enum NonlinearOptimizerMethod {
  gradientDescent,
  newton,
  quasiNewtonWithBFGS,
}

class NonlinearOptimizationProblem {
  NonlinearOptimizationProblem({
    this.f,
    this.gradF,
    this.hessianF,
    required this.x0,
    required this.eta,
    required this.eps,
    this.maxIter = -1,
  });

  final ScalarFunction? f;
  final VectorFunction? gradF;
  final MatrixFunction? hessianF;
  final Vector x0;
  final IterationFunction<double> eta;
  final double eps;
  final int maxIter;
}

class NonlinearOptimizer implements Optimizer {
  NonlinearOptimizer({
    required NonlinearOptimizationProblem problem,
    NonlinearOptimizerMethod method = NonlinearOptimizerMethod.gradientDescent,
  })  : _problem = problem,
        _method = method;

  final NonlinearOptimizationProblem _problem;
  final NonlinearOptimizerMethod _method;

  OptimizationResult? result;

  @override
  void solve() {
    switch (_method) {
      case NonlinearOptimizerMethod.gradientDescent:
        if (_problem.gradF == null) throw ArgumentError.notNull('gradF');
        _gradientSolver(_gradientDescentStep);
        break;
      case NonlinearOptimizerMethod.newton:
        if (_problem.gradF == null) throw ArgumentError.notNull('gradF');
        if (_problem.hessianF == null) throw ArgumentError.notNull('hessianF');
        _gradientSolver(_newtonStep);
        break;
      case NonlinearOptimizerMethod.quasiNewtonWithBFGS:
        if (_problem.gradF == null) throw ArgumentError.notNull('gradF');

        break;
    }
  }

  Vector _gradientDescentStep(Vector x1, int iter) {
    return x1 - _problem.gradF!(x1).scale(_problem.eta(iter));
  }

  Vector _newtonStep(Vector x1, int iter) {
    return x1 -
        (_problem.hessianF!(x1).inverse() % _problem.gradF!(x1))
            .scale(_problem.eta(iter));
  }

  void _gradientSolver(Vector Function(Vector, int) step) {
    bool converged = false;
    Vector x1 = _problem.x0.copy();

    final List<Vector> points = <Vector>[];
    points.add(x1.copy());

    final List<double> costFunctionEvaluations = <double>[];
    if (_problem.f != null) {
      costFunctionEvaluations.add(_problem.f!(x1));
    }

    int i = 0;
    while (!converged && i != _problem.maxIter) {
      final Vector x2 = step(x1, i);
      points.add(x2.copy());
      if (_problem.f != null) {
        costFunctionEvaluations.add(_problem.f!(x2));
      }
      i++;

      if (x2.elements.any((double el) => el.isNaN || el.isInfinite)) break;

      converged = (x2 - x1).norm() < _problem.eps;
      x1 = x2.copy();
    }

    result = OptimizationResult(
      converged: converged,
      steps: i,
      costFunctionEvaluations: costFunctionEvaluations,
      points: points,
    );
  }
}
