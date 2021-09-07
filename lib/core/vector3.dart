import 'package:scidash/core/vector.dart';

class Vector3 extends Vector {
  Vector3(double x, double y, double z) : super.fromList([x, y, z]);
  Vector3.fromList(List<double> elements) : super.fromList(elements);

  Vector3.zeros() : super.zeros(3);
  Vector3.ones() : super.ones(3);

  double get x => elements[0];
  double get y => elements[1];
  double get z => elements[2];

  @override
  int get size => 3;
}
