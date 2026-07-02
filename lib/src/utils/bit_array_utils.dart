import 'package:collection/collection.dart';

/// Decodes an encoded AIS payload (fields[5]) into a bit array.
///
/// The bits are decoded as follows.
/// - Each character in [encoded] represents six bits, ordered from msb to lsb.
/// - The returned BoolList is the concatenation of these bits in that order,
///   i.e. the msb of the first character is at index position 0,
///   the lsb at position 5, etc.
/// For example, if [encoded] has two characters with bits [abcdef] and
/// [ABCDEF], resp., then the returned BoolList will contain the bits as
/// [abcdefABCDEF].
/// For example, [f], which is byte0 & 0x01, will end up at index position 5.
BoolList decodeToBitArray(String encoded) {
  final bitArrayLength = encoded.length * 6;
  final bitArray = BoolList(bitArrayLength);
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

/// Parses the bits from start (inclusive) to end (exclusive) as an unsigned
/// integer.
int asInt(BoolList bitArray, int start, int end) {
  if (bitArray.length <= start ||
      bitArray.length < end ||
      start >= end ||
      start < 0 ||
      end < 0) {
    throw RangeError(
        'Invalid start and end values: length ${bitArray.length}, start $start, end $end');
  }
  int value = 0;
  for (int i = start; i < end; ++i) {
    value <<= 1;
    value |= bitArray[i] ? 1 : 0;
  }
  return value;
}

/// Parses the bits from start (inclusive) to end (exclusive) as a signed
/// integer (using two's complement representation).
int asSignedInt(BoolList bitArray, int start, int end) {
  int value = asInt(bitArray, start, end);
  int bitLength = end - start;

  // If MSB is 1, it's negative (two's complement)
  if (value >= (1 << (bitLength - 1))) {
    value = value - (1 << bitLength);
  }
  return value;
}

String bitArrayToString(BoolList bitArray) {
  final buf = StringBuffer();
  for (int i = 0; i < bitArray.length; ++i) {
    buf.write(bitArray[i] ? '1' : '0');
  }
  return buf.toString();
}

/// Checks if a bit is set in an int value.
bool isBitSet(int value, int bitIndex) {
  return (value & (1 << bitIndex)) != 0;
}
