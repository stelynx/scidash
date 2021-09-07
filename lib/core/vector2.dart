import 'package:scidash/core/vector.dart';

class Vector2 extends Vector {
  Vector2(double x, double y) : super.fromList([x, y]);
  Vector2.fromList(List<double> elements) : super.fromList(elements);

  Vector2.zeros() : super.zeros(2);
  Vector2.ones() : super.ones(2);

  double get x => elements[0];
  double get y => elements[1];

  @override
  int get size => 2;
}
