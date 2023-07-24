import 'dart:math' show pow;
import 'dart:typed_data';

import 'package:buffer/buffer.dart';

/// Maximum safe integer in JavaScript. (2^53)
const _maxIntegerJS = 9007199254740991;

/// Util class used to fetch the leading variable integer of a stream/array of bytes.
///
/// [res] refers to the leading byte converted to an integer
/// and [numBytesRead] refers to the number of bytes that it occupies in the array of bytes.
class DecodedVarInt {
  final int res;
  final int numBytesRead;

  DecodedVarInt({required this.res, required this.numBytesRead});
}

/// Converts an int value to a varint (in Dart this is expressed as Uint8List - an array of bytes)
/// This is an implementation of varint (changed for unsigned ints) based of https://github.com/fmoo/python-varint/blob/master/varint.py
/// that is changed for unsigned integers.
Uint8List encodeVarint(int value) {
  // Ensure that the value is within JavaScript's safe integer range.
  if (value < 0 || value >= _maxIntegerJS) {
    throw ArgumentError.value(
      value,
      'value',
      'must be a non-negative integer less than $_maxIntegerJS',
    );
  }

  ByteDataWriter writer = ByteDataWriter();

  do {
    int temp = value & 0x7F; // 0x7F = 01111111

    value = value >> 7; // unsigned bit-right shift

    if (value != 0) {
      temp |= 0x80;
    }

    writer.writeUint8(temp.toInt());
  } while (value != 0);

  return writer.toBytes();
}

/// Receives a buffer [buf] and decodes the first leading varint.
///
/// Adapted from https://github.com/multiformats/js-multihash.
DecodedVarInt decodeVarint(Uint8List buf, int? nOffset) {
  int res = 0;
  int offset = nOffset ?? 0;
  int shift = 0;
  int counter = offset;
  int b;
  int l = buf.length;
  int bytesReadCounter = 0;

  do {
    if (counter >= l || shift > 49) {
      throw RangeError('Could not decode varint.');
    }

    b = buf[counter++];

    if (shift < 28) {
      res += (b & 0x7F) << shift;
    } else {
      res += (b & 0x7F) * pow(2, shift).toInt();
    }

    shift += 7;
  } while (b >= 0x80);

  bytesReadCounter = counter - offset;

  return DecodedVarInt(res: res, numBytesRead: bytesReadCounter);
}
