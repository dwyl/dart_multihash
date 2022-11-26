import 'dart:convert';
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';
import 'package:dart_multihash/src/models.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:dart_multihash/dart_multihash.dart';

void main() {
  test('testing strings from the Multihash examples', () {
    // Check https://multiformats.io/multihash/#examples
    // for the examples used in this test.

    // sha2-256 - 256 bits (aka sha256)
    Uint8List sha256_array = Uint8List.fromList(hex.decode('122041dd7b6443542e75701aa98a0c235951a28a0d851b11564d20022ab11d2589a8'));
    MultihashInfo decoded_sha256 = Multihash.decode(sha256_array);
    expect(decoded_sha256.hashFunctionName, equals('sha2-256'));
    expect(decoded_sha256.length, equals(0x20));
    expect(decoded_sha256.code, equals(0x12));

    // blake2b-512 - 512 bits
    Uint8List blake2b_512_array = Uint8List.fromList(hex.decode(
        'c0e40240d91ae0cb0e48022053ab0f8f0dc78d28593d0f1c13ae39c9b169c136a779f21a0496337b6f776a73c1742805c1cc15e792ddb3c92ee1fe300389456ef3dc97e2'));
    MultihashInfo decoded_blake2b_512 = Multihash.decode(blake2b_512_array);
    expect(decoded_blake2b_512.hashFunctionName, equals('blake2b-512'));
    expect(decoded_blake2b_512.length, equals(0x40));
    expect(decoded_blake2b_512.code, equals(0xb240));
  });

  test('encoding and decoding a string', () {
    String input = "Hello World";

    List<int> bytes = utf8.encode(input); // data being hashed
    Digest digest = sha256.convert(bytes);
    Uint8List inputByteArray = Uint8List.fromList(digest.bytes);

    Uint8List encodedObj = Multihash.encode('sha2-256', inputByteArray);
    MultihashInfo decodedObj = Multihash.decode(encodedObj);

    expect(listEquals(decodedObj.digest, inputByteArray), true);
  });

  test('encoding with an unsupported hash function type', () {
    String input = "Hello World";

    List<int> bytes = utf8.encode(input); // data being hashed
    Digest digest = sha256.convert(bytes);
    Uint8List inputByteArray = Uint8List.fromList(digest.bytes);

    expect(() => Multihash.encode('invalid_hash_type', inputByteArray), throwsA(TypeMatcher<UnsupportedError>()));
  });

  test('encoding with an incorrect length', () {
    String input = "Hello World";

    List<int> bytes = utf8.encode(input); // data being hashed
    Digest digest = sha256.convert(bytes);
    Uint8List inputByteArray = Uint8List.fromList(digest.bytes);

    expect(() => Multihash.encode('sha2-256', inputByteArray, length: 1), throwsA(TypeMatcher<RangeError>()));
  });

  test('decoding with insufficient length', () {
    String input = "Hello World";

    List<int> bytes = utf8.encode(input); // data being hashed
    Digest digest = sha256.convert(bytes);
    Uint8List inputByteArray = Uint8List.fromList(digest.bytes);

    Uint8List encodedArray = Multihash.encode('sha2-256', inputByteArray);
    Uint8List splicedInvalidEncodedArray = encodedArray.sublist(0, 2);

    expect(() => Multihash.decode(splicedInvalidEncodedArray), throwsA(TypeMatcher<RangeError>()));
  });

  test('decoding with insufficient length', () {
    String input = "Hello World";

    List<int> bytes = utf8.encode(input); // data being hashed
    Digest digest = sha256.convert(bytes);
    Uint8List inputByteArray = Uint8List.fromList(digest.bytes);

    Uint8List encodedArray = Multihash.encode('sha2-256', inputByteArray);
    Uint8List splicedInvalidEncodedArray = encodedArray.sublist(0, 2);

    expect(() => Multihash.decode(splicedInvalidEncodedArray), throwsA(TypeMatcher<RangeError>()));
  });

  test('decoding with insufficient length', () {
    String input = "Hello World";

    List<int> bytes = utf8.encode(input); // data being hashed
    Digest digest = sha256.convert(bytes);
    Uint8List inputByteArray = Uint8List.fromList(digest.bytes);

    Uint8List encodedArray = Multihash.encode('sha2-256', inputByteArray);
    Uint8List splicedInvalidEncodedArray = encodedArray.sublist(0, 2);

    expect(() => Multihash.decode(splicedInvalidEncodedArray), throwsA(TypeMatcher<RangeError>()));
  });

  test('decoding with unsupported code', () {
    String input = "Hello World";

    List<int> bytes = utf8.encode(input); // data being hashed
    Digest digest = sha256.convert(bytes);
    Uint8List inputByteArray = Uint8List.fromList(digest.bytes);

    Uint8List encodedArray = Multihash.encode('sha2-256', inputByteArray);
    encodedArray[0] = 0; // adding unsupported code

    expect(() => Multihash.decode(encodedArray), throwsA(TypeMatcher<UnsupportedError>()));
  });

  test('decoding with invalid digest length', () {
    String input = "Hello World";

    List<int> bytes = utf8.encode(input); // data being hashed
    Digest digest = sha256.convert(bytes);
    Uint8List inputByteArray = Uint8List.fromList(digest.bytes);

    Uint8List encodedArray = Multihash.encode('sha2-256', inputByteArray);
    encodedArray[1] = 0; // adding unsupported code

    expect(() => Multihash.decode(encodedArray), throwsA(TypeMatcher<RangeError>()));
  });

  test('decoding with incompatible multihash length paramenter and digest\'s', () {
    String input = "Hello World";

    List<int> bytes = utf8.encode(input); // data being hashed
    Digest digest = sha256.convert(bytes);
    Uint8List inputByteArray = Uint8List.fromList(digest.bytes);

    Uint8List encodedArray = Multihash.encode('sha2-256', inputByteArray);
    encodedArray[1] = 1; // adding wrong length

    expect(() => Multihash.decode(encodedArray), throwsA(TypeMatcher<RangeError>()));
  });
}
