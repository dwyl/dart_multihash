import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:dart_multihash/src/models.dart';
import 'package:dart_multihash/src/varintUtils.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:collection/collection.dart';

import 'package:dart_multihash/dart_multihash.dart';

void main() {
  test('encoding varint', () {
    int value = 1000;
    Uint8List expected_output = Uint8List.fromList([232, 7]); // decimal 1000 is equivalent to [232, 7] in bytes array

    Uint8List output = encodeVarint(value);

    var eq = const ListEquality().equals;
    expect(eq(expected_output, output), true);
  });

  test('decoding varint', () {

    // The following is input byte array and the correspondent value.
    int inputValue = 3463580742760;
    Uint8List inputValueInByteArray = Uint8List.fromList([232, 232, 255, 235, 230, 100]);

    var output = decodeVarint(inputValueInByteArray, null);

    expect(output.res, equals(inputValue));
  });

  test('decoding varint invalid varint (out of bounds)', () {
    Uint8List input = Uint8List.fromList([232, 232, 255, 235, 230, 150]); // this varint is not finished being defined
    expect(() => decodeVarint(input, null), throwsA(TypeMatcher<RangeError>()));
  });
}
