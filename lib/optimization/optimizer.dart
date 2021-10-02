import 'package:scidash/optimization/optimization_result.dart';

abstract class Optimizer {
  OptimizationResult? get result;

  void solve();
}
