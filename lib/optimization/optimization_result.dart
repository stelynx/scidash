import 'package:scidash/core/vector.dart';

class OptimizationResult {
  const OptimizationResult({
    required this.converged,
    required this.steps,
    required this.costFunctionEvaluations,
    required this.points,
  });

  final bool converged;
  final int steps;
  final List<double>? costFunctionEvaluations;
  final List<Vector> points;
}
