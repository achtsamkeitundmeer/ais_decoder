import 'package:ais_decoder/src/utils/convert_char_to_bin.dart';
import 'package:bit_array/bit_array.dart';
import 'package:test/test.dart';

void main() {
  group('isBitSet', () {
    test('works for normal numbers', () {
      expect(isBitSet(0, 0), isFalse);
      expect(isBitSet(0, 1), isFalse);
      expect(isBitSet(0, 2), isFalse);
      expect(isBitSet(0, 3), isFalse);
      expect(isBitSet(0, 4), isFalse);
      expect(isBitSet(0, 5), isFalse);
      expect(isBitSet(1, 0), isTrue);
      expect(isBitSet(1, 1), isFalse);
      expect(isBitSet(1, 2), isFalse);
      expect(isBitSet(1, 3), isFalse);
      expect(isBitSet(1, 4), isFalse);
      expect(isBitSet(1, 5), isFalse);
      expect(isBitSet(2, 0), isFalse);
      expect(isBitSet(2, 1), isTrue);
      expect(isBitSet(2, 2), isFalse);
      expect(isBitSet(2, 3), isFalse);
      expect(isBitSet(2, 4), isFalse);
      expect(isBitSet(2, 5), isFalse);
      expect(isBitSet(4, 0), isFalse);
      expect(isBitSet(4, 1), isFalse);
      expect(isBitSet(4, 2), isTrue);
      expect(isBitSet(4, 3), isFalse);
      expect(isBitSet(4, 4), isFalse);
      expect(isBitSet(4, 5), isFalse);
      expect(isBitSet(8, 0), isFalse);
      expect(isBitSet(8, 1), isFalse);
      expect(isBitSet(8, 2), isFalse);
      expect(isBitSet(8, 3), isTrue);
      expect(isBitSet(8, 4), isFalse);
      expect(isBitSet(8, 5), isFalse);
      expect(isBitSet(16, 0), isFalse);
      expect(isBitSet(16, 1), isFalse);
      expect(isBitSet(16, 2), isFalse);
      expect(isBitSet(16, 3), isFalse);
      expect(isBitSet(16, 4), isTrue);
      expect(isBitSet(16, 5), isFalse);
      expect(isBitSet(32, 0), isFalse);
      expect(isBitSet(32, 1), isFalse);
      expect(isBitSet(32, 2), isFalse);
      expect(isBitSet(32, 3), isFalse);
      expect(isBitSet(32, 4), isFalse);
      expect(isBitSet(32, 5), isTrue);
    });
  });
  group('Verify bit array-based decoding against existing implementation', () {
    test('Existing decoding of example', () {
      final String encoded = kExample.split(',')[5];
      final String binaryString = makeBinaryString(encoded);
      print('Binary string: $binaryString');
      expect(binaryString.length, 168);
      final BitArray bitArray = decodeToBitArray(encoded);
      final String bitArrayAsString = bitArrayToString(bitArray);
      print('Bit array:     $bitArrayAsString');
      expect(bitArrayAsString.substring(0, 168), equals(binaryString));
    });
  });

  group('Performance', () {
    final String encoded = kExample.split(',')[5];
    final iterations = 1000;
    test('Old method', () {
      for (int i = 0; i < 100; ++i) {
        final _ = makeBinaryString(encoded);
      }
      final stopwatch = Stopwatch()..start();
      for (int i = 0; i < iterations; ++i) {
        final _ = makeBinaryString(encoded);
      }
      stopwatch.stop();
      print(
          'Old method: average ${stopwatch.elapsedMicroseconds / iterations} μs');
    });
    test('New method', () {
      for (int i = 0; i < 100; ++i) {
        final _ = decodeToBitArray(encoded);
      }
      final stopwatch = Stopwatch()..start();
      for (int i = 0; i < iterations; ++i) {
        final _ = decodeToBitArray(encoded);
      }
      stopwatch.stop();
      print(
          'New method: average ${stopwatch.elapsedMicroseconds / iterations} μs');
    });
  });
}

String makeBinaryString(String encoded) {
  String binary = '';

  for (String char in encoded.split('')) {
    binary += convertCharToBinary(char);
  }
  return binary;
}

BitArray decodeToBitArray(String encoded) {
  final bitArrayLength = encoded.length * 6;
  final bitArray = BitArray(bitArrayLength);
  for (int i = 0; i < encoded.length; ++i) {
    final bitOffset = 6 * i + 5;
    int asciiValue = encoded.codeUnitAt(i);
    int aisValue = asciiValue - 48;
    if (aisValue > 40) {
      aisValue -= 8;
    }
    for (int bitIndex = 0; bitIndex < 6; ++bitIndex) {
      bool val = isBitSet(aisValue, bitIndex);
      bitArray[bitOffset - bitIndex] = val;
    }
  }
  return bitArray;
}

bool isBitSet(int value, int bitIndex) {
  return (value & (1 << bitIndex)) != 0;
}

String bitArrayToString(BitArray bitArray) {
  final buf = StringBuffer();
  for (int i = 0; i < bitArray.length; ++i) {
    buf.write(bitArray[i] ? '1' : '0');
  }
  return buf.toString();
}

const kExample = '!AIVDM,1,1,,B,B3`e<W@01hJMcvUIe3rWSwnUoP06,0*48';
