import 'package:scidash/core/ndarray.dart';
import 'package:test/test.dart';

void main() {
  group('NDArray', () {
    group('_calculateDimensions', () {
      test('should throw range error if part of ndarray is empty', () {
        final List<List<int>> l = [
          [],
          [1, 2, 3]
        ];

        expect(() => NDArray<int>(l), throwsRangeError);
      });

      test('should throw ArgumentError if child dimensions mismatch', () {
        final List<List<int>> l = [
          [2, 3],
          [1, 2, 3]
        ];

        expect(() => NDArray<int>(l), throwsArgumentError);
      });

      test(
        'should throw TypeError if supplied and required types do not match',
        () {
          final List<List<int>> l = [
            [1, 2, 3],
            [1, 2, 3]
          ];

          expect(() => NDArray<String>(l), throwsA(isA<TypeError>()));
        },
      );

      test(
        'should allow NDArray construction and calculate dimensions correctly',
        () {
          final List<List<List<int>>> l = [
            [
              [1, 1, 1, 1],
              [1, 1, 1, 1],
              [1, 1, 1, 1]
            ],
            [
              [2, 2, 2, 2],
              [2, 2, 2, 2],
              [2, 2, 2, 2]
            ]
          ];

          final NDArray<int> ndarray = NDArray<int>(l);
          expect(ndarray.n, equals(3));
          expect(ndarray.dimensions, equals([2, 3, 4]));
        },
      );
    });

    group('get dimensions', () {
      test(
        'should return dimensions of NDArray',
        () {
          final List<List<List<int>>> l = [
            [
              [1, 1, 1, 1],
              [1, 1, 1, 1],
              [1, 1, 1, 1]
            ],
            [
              [2, 2, 2, 2],
              [2, 2, 2, 2],
              [2, 2, 2, 2]
            ]
          ];

          final NDArray<int> ndarray = NDArray<int>(l);
          expect(ndarray.dimensions, equals([2, 3, 4]));
        },
      );
    });

    group('get n', () {
      test(
        'should return number of axes of NDArray',
        () {
          final List<List<List<int>>> l = [
            [
              [1, 1, 1, 1],
              [1, 1, 1, 1],
              [1, 1, 1, 1]
            ],
            [
              [2, 2, 2, 2],
              [2, 2, 2, 2],
              [2, 2, 2, 2]
            ]
          ];

          final NDArray<int> ndarray = NDArray<int>(l);
          expect(ndarray.n, equals(3));
        },
      );
    });

    group('get type', () {
      test('should return the type of ndarray as provided by user', () {
        final List<List<List<int>>> l = [
          [
            [1, 1, 1, 1],
            [1, 1, 1, 1],
            [1, 1, 1, 1]
          ],
          [
            [2, 2, 2, 2],
            [2, 2, 2, 2],
            [2, 2, 2, 2]
          ]
        ];

        final NDArray<int> ndarray = NDArray<int>(l);

        expect(ndarray.type, equals(int));
      });
    });

    group('toString', () {
      test('should return desired string representation', () {
        final List<List<List<int>>> l = [
          [
            [1, 1, 1, 1],
            [1, 1, 1, 1],
            [1, 1, 1, 1]
          ],
          [
            [2, 2, 2, 2],
            [2, 2, 2, 2],
            [2, 2, 2, 2]
          ]
        ];

        final NDArray<int> ndarray = NDArray<int>(l);
        print(ndarray);
        expect(
          ndarray.toString(),
          equals(
              'NDArray<int>([[[1, 1, 1, 1], [1, 1, 1, 1], [1, 1, 1, 1]], [[2, 2, 2, 2], [2, 2, 2, 2], [2, 2, 2, 2]]])'),
        );
      });
    });
  });

  group('NDDoubleArray', () {
    group('NDArray extension', () {
      test('should succeed if T is double', () {
        final List<List<List<double>>> l = [
          [
            [1, 1, 1, 1],
            [1, 1, 1, 1],
            [1, 1, 1, 1]
          ],
          [
            [2, 2, 2, 2],
            [2, 2, 2, 2],
            [2, 2, 2, 2]
          ]
        ];

        final NDDoubleArray _ = NDDoubleArray(l);
      });
    });

    group('scale', () {
      test('should correctly scale the ndarray', () {
        final List<List<List<double>>> l = [
          [
            [1, 1, 1, 1],
            [1, 1, 1, 1],
            [1, 1, 1, 1]
          ],
          [
            [2, 2, 2, 2],
            [2, 2, 2, 2],
            [2, 2, 2, 2]
          ]
        ];
        final List<List<List<double>>> lExpected = [
          [
            [2, 2, 2, 2],
            [2, 2, 2, 2],
            [2, 2, 2, 2]
          ],
          [
            [4, 4, 4, 4],
            [4, 4, 4, 4],
            [4, 4, 4, 4]
          ]
        ];

        final NDDoubleArray ndda = NDDoubleArray(l).scale(2);
        final NDDoubleArray nddaExpected = NDDoubleArray(lExpected);

        expect(ndda, equals(nddaExpected));
      });
    });

    group('toString', () {
      test('should return desired string representation', () {
        final List<List<List<int>>> l = [
          [
            [1, 1, 1, 1],
            [1, 1, 1, 1],
            [1, 1, 1, 1]
          ],
          [
            [2, 2, 2, 2],
            [2, 2, 2, 2],
            [2, 2, 2, 2]
          ]
        ];

        final NDArray<int> ndarray = NDArray<int>(l);
        print(ndarray);
        expect(
          ndarray.toString(),
          equals(
              'NDArray<int>([[[1, 1, 1, 1], [1, 1, 1, 1], [1, 1, 1, 1]], [[2, 2, 2, 2], [2, 2, 2, 2], [2, 2, 2, 2]]])'),
        );
      });
    });
  });
}
