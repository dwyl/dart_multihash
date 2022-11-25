import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:dart_cid/src/models.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:collection/collection.dart';

import 'package:dart_cid/dart_multihash.dart';

void main() {
  test('encoding and decoding a string', () {
    String input = "Hello World";

    List<int> bytes = utf8.encode(input); // data being hashed
    Digest digest = sha256.convert(bytes);
    Uint8List inputByteArray = Uint8List.fromList(digest.bytes);

    Uint8List encodedObj = encode('sha2-256', inputByteArray, null);
    MultihashInfo decodedObj = decode(encodedObj);

    var eq = const ListEquality().equals;
    expect(eq(decodedObj.digest, inputByteArray), true);
  });

  test('encoding with an unsupported hash function type', () {
    String input = "Hello World";

    List<int> bytes = utf8.encode(input); // data being hashed
    Digest digest = sha256.convert(bytes);
    Uint8List inputByteArray = Uint8List.fromList(digest.bytes);

    expect(() => encode('invalid_hash_type', inputByteArray, null), throwsA(TypeMatcher<UnsupportedError>()));
  });

  test('encoding with an incorrect length', () {
    String input = "Hello World";

    List<int> bytes = utf8.encode(input); // data being hashed
    Digest digest = sha256.convert(bytes);
    Uint8List inputByteArray = Uint8List.fromList(digest.bytes);

    expect(() => encode('sha2-256', inputByteArray, 1), throwsA(TypeMatcher<RangeError>()));
  });

  test('decoding with insufficient length', () {
    String input = "Hello World";

    List<int> bytes = utf8.encode(input); // data being hashed
    Digest digest = sha256.convert(bytes);
    Uint8List inputByteArray = Uint8List.fromList(digest.bytes);

    Uint8List encodedArray = encode('sha2-256', inputByteArray, null);
    Uint8List splicedInvalidEncodedArray = encodedArray.sublist(0, 2);

    expect(() => decode(splicedInvalidEncodedArray), throwsA(TypeMatcher<RangeError>()));
  });

  test('decoding with insufficient length', () {
    String input = "Hello World";

    List<int> bytes = utf8.encode(input); // data being hashed
    Digest digest = sha256.convert(bytes);
    Uint8List inputByteArray = Uint8List.fromList(digest.bytes);

    Uint8List encodedArray = encode('sha2-256', inputByteArray, null);
    Uint8List splicedInvalidEncodedArray = encodedArray.sublist(0, 2);

    expect(() => decode(splicedInvalidEncodedArray), throwsA(TypeMatcher<RangeError>()));
  });

  test('decoding with insufficient length', () {
    String input = "Hello World";

    List<int> bytes = utf8.encode(input); // data being hashed
    Digest digest = sha256.convert(bytes);
    Uint8List inputByteArray = Uint8List.fromList(digest.bytes);

    Uint8List encodedArray = encode('sha2-256', inputByteArray, null);
    Uint8List splicedInvalidEncodedArray = encodedArray.sublist(0, 2);

    expect(() => decode(splicedInvalidEncodedArray), throwsA(TypeMatcher<RangeError>()));
  });

  test('decoding with unsupported code', () {
    String input = "Hello World";

    List<int> bytes = utf8.encode(input); // data being hashed
    Digest digest = sha256.convert(bytes);
    Uint8List inputByteArray = Uint8List.fromList(digest.bytes);

    Uint8List encodedArray = encode('sha2-256', inputByteArray, null);
    encodedArray[0] = 0; // adding unsupported code

    expect(() => decode(encodedArray), throwsA(TypeMatcher<UnsupportedError>()));
  });

  test('decoding with invalid digest length', () {
    String input = "Hello World";

    List<int> bytes = utf8.encode(input); // data being hashed
    Digest digest = sha256.convert(bytes);
    Uint8List inputByteArray = Uint8List.fromList(digest.bytes);

    Uint8List encodedArray = encode('sha2-256', inputByteArray, null);
    encodedArray[1] = 0; // adding unsupported code

    expect(() => decode(encodedArray), throwsA(TypeMatcher<RangeError>()));
  });

  test('decoding with incompatible multihash length paramenter and digest\'s', () {
    String input = "Hello World";

    List<int> bytes = utf8.encode(input); // data being hashed
    Digest digest = sha256.convert(bytes);
    Uint8List inputByteArray = Uint8List.fromList(digest.bytes);

    Uint8List encodedArray = encode('sha2-256', inputByteArray, null);
    encodedArray[1] = 1; // adding wrong length

    expect(() => decode(encodedArray), throwsA(TypeMatcher<RangeError>()));
  });
}
