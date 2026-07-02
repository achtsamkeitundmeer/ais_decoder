import 'package:ais_decoder/src/utils/bit_array_utils.dart';
import 'package:collection/collection.dart';
import 'package:test/test.dart';

void main() {
  group('isBitSet', () {
    test('works for normal numbers', () {
      // 000000
      expect(isBitSet(0, 0), isFalse);
      expect(isBitSet(0, 1), isFalse);
      expect(isBitSet(0, 2), isFalse);
      expect(isBitSet(0, 3), isFalse);
      expect(isBitSet(0, 4), isFalse);
      expect(isBitSet(0, 5), isFalse);

      // 000001
      expect(isBitSet(1, 0), isTrue);
      expect(isBitSet(1, 1), isFalse);
      expect(isBitSet(1, 2), isFalse);
      expect(isBitSet(1, 3), isFalse);
      expect(isBitSet(1, 4), isFalse);
      expect(isBitSet(1, 5), isFalse);

      // 000010
      expect(isBitSet(2, 0), isFalse);
      expect(isBitSet(2, 1), isTrue);
      expect(isBitSet(2, 2), isFalse);
      expect(isBitSet(2, 3), isFalse);
      expect(isBitSet(2, 4), isFalse);
      expect(isBitSet(2, 5), isFalse);

      // 000100
      expect(isBitSet(4, 0), isFalse);
      expect(isBitSet(4, 1), isFalse);
      expect(isBitSet(4, 2), isTrue);
      expect(isBitSet(4, 3), isFalse);
      expect(isBitSet(4, 4), isFalse);
      expect(isBitSet(4, 5), isFalse);

      // 001000
      expect(isBitSet(8, 0), isFalse);
      expect(isBitSet(8, 1), isFalse);
      expect(isBitSet(8, 2), isFalse);
      expect(isBitSet(8, 3), isTrue);
      expect(isBitSet(8, 4), isFalse);
      expect(isBitSet(8, 5), isFalse);

      // 010000
      expect(isBitSet(16, 0), isFalse);
      expect(isBitSet(16, 1), isFalse);
      expect(isBitSet(16, 2), isFalse);
      expect(isBitSet(16, 3), isFalse);
      expect(isBitSet(16, 4), isTrue);
      expect(isBitSet(16, 5), isFalse);

      // 100000
      expect(isBitSet(32, 0), isFalse);
      expect(isBitSet(32, 1), isFalse);
      expect(isBitSet(32, 2), isFalse);
      expect(isBitSet(32, 3), isFalse);
      expect(isBitSet(32, 4), isFalse);
      expect(isBitSet(32, 5), isTrue);

      // 111111
      expect(isBitSet(63, 0), isTrue);
      expect(isBitSet(63, 1), isTrue);
      expect(isBitSet(63, 2), isTrue);
      expect(isBitSet(63, 3), isTrue);
      expect(isBitSet(63, 4), isTrue);
      expect(isBitSet(63, 5), isTrue);
    });
  });

  group('asInt', () {
    test('full number', () {
      final seven = toBoolList('000111');
      expect(asInt(seven, 0, seven.length), 7);

      final two = toBoolList('10');
      expect(asInt(two, 0, two.length), 2);
    });
    test('sections', () {
      final bitArray = toBoolList('01001000001110');
      expect(asInt(bitArray, 0, 1), 0);
      expect(asInt(bitArray, 0, 2), 1);
      expect(asInt(bitArray, 1, 2), 1);
      expect(asInt(bitArray, 1, 3), 2);
      expect(asInt(bitArray, 1, 4), 4);
      expect(asInt(bitArray, 1, 5), 9);
      expect(asInt(bitArray, 10, 14), 14);
      expect(asInt(bitArray, 10, 13), 7);
    });
    test('RangeError', () {
      final bitArray = toBoolList('01001000001110');
      expect(() => asInt(bitArray, 10, 15), throwsRangeError);
    });
  });

  group('asSignedInt', () {
    test('full number', () {
      final seven = toBoolList('000111');
      expect(asSignedInt(seven, 0, seven.length), 7);

      final minusTwo = toBoolList('10');
      expect(asSignedInt(minusTwo, 0, minusTwo.length), -2);
    });
    test('sections', () {
      final bitArray = toBoolList('01001000001110');
      expect(asSignedInt(bitArray, 0, 1), 0);
      expect(asSignedInt(bitArray, 0, 2), 1);
      expect(asSignedInt(bitArray, 1, 2), -1);
      expect(asSignedInt(bitArray, 1, 3), -2);
      expect(asSignedInt(bitArray, 1, 4), -4);
      expect(asSignedInt(bitArray, 1, 5), -7);
      expect(asSignedInt(bitArray, 10, 14), -2);
      expect(asSignedInt(bitArray, 10, 13), -1);
    });
    test('RangeError', () {
      final bitArray = toBoolList('01001000001110');
      expect(() => asSignedInt(bitArray, 10, 15), throwsRangeError);
    });
  });
}

BoolList toBoolList(String binaryString) {
  final bitArrayLength = binaryString.length;
  final bitArray = BoolList(bitArrayLength);
  for (int i = 0; i < bitArrayLength; ++i) {
    bitArray[i] = binaryString[i] == '1';
  }
  return bitArray;
}

const kExample = '!AIVDM,1,1,,B,B3`e<W@01hJMcvUIe3rWSwnUoP06,0*48';
