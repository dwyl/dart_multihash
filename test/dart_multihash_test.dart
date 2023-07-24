import 'dart:convert';
import 'dart:typed_data';
import 'package:base32/encodings.dart';
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';
import 'package:test/test.dart';
import 'package:collection/collection.dart';
import 'package:base32/base32.dart';

import 'package:dart_multihash/dart_multihash.dart';

void main() {
  test('testing strings from the Multihash examples', () {
    // Check https://multiformats.io/multihash/#examples
    // for the examples used in this test.

    // sha2-256 - 256 bits (aka sha256)
    Uint8List sha256Array = Uint8List.fromList(hex.decode(
        '122041dd7b6443542e75701aa98a0c235951a28a0d851b11564d20022ab11d2589a8'));
    MultihashInfo decodedSha256 = Multihash.decode(sha256Array);
    expect(decodedSha256.name, equals('sha2-256'));
    expect(decodedSha256.size, equals(0x20));
    expect(decodedSha256.code, equals(0x12));

    // blake2b-512 - 512 bits
    Uint8List blake2b512Array = Uint8List.fromList(hex.decode(
        'c0e40240d91ae0cb0e48022053ab0f8f0dc78d28593d0f1c13ae39c9b169c136a779f21a0496337b6f776a73c1742805c1cc15e792ddb3c92ee1fe300389456ef3dc97e2'));
    MultihashInfo decodedBlake2b512 = Multihash.decode(blake2b512Array);
    expect(decodedBlake2b512.name, equals('blake2b-512'));
    expect(decodedBlake2b512.size, equals(0x40));
    expect(decodedBlake2b512.code, equals(0xb240));
  });

  test('encoding and decoding a string', () {
    String input = "Hello World";

    List<int> bytes = utf8.encode(input); // data being hashed
    Digest digest = sha256.convert(bytes);
    Uint8List inputByteArray = Uint8List.fromList(digest.bytes);

    Uint8List encodedObj =
        Multihash.encode('sha2-256', inputByteArray).toBytes();
    MultihashInfo decodedObj = Multihash.decode(encodedObj);

    Function eq = const ListEquality().equals;
    expect(eq(decodedObj.digest, inputByteArray), true);
  });

  test('encoding with an unsupported hash function type', () {
    String input = "Hello World";

    List<int> bytes = utf8.encode(input); // data being hashed
    Digest digest = sha256.convert(bytes);
    Uint8List inputByteArray = Uint8List.fromList(digest.bytes);

    expect(() => Multihash.encode('invalid_hash_type', inputByteArray),
        throwsA(TypeMatcher<UnsupportedError>()));
  });

  test('encoding with an incorrect length', () {
    String input = "Hello World";

    List<int> bytes = utf8.encode(input); // data being hashed
    Digest digest = sha256.convert(bytes);
    Uint8List inputByteArray = Uint8List.fromList(digest.bytes);

    expect(() => Multihash.encode('sha2-256', inputByteArray, length: 1),
        throwsA(TypeMatcher<RangeError>()));
  });

  test('decoding with insufficient length', () {
    String input = "Hello World";

    List<int> bytes = utf8.encode(input); // data being hashed
    Digest digest = sha256.convert(bytes);
    Uint8List inputByteArray = Uint8List.fromList(digest.bytes);

    Uint8List encodedArray =
        Multihash.encode('sha2-256', inputByteArray).toBytes();
    Uint8List splicedInvalidEncodedArray = encodedArray.sublist(0, 2);

    expect(() => Multihash.decode(splicedInvalidEncodedArray),
        throwsA(TypeMatcher<RangeError>()));
  });

  test('decoding with insufficient length', () {
    String input = "Hello World";

    List<int> bytes = utf8.encode(input); // data being hashed
    Digest digest = sha256.convert(bytes);
    Uint8List inputByteArray = Uint8List.fromList(digest.bytes);

    Uint8List encodedArray =
        Multihash.encode('sha2-256', inputByteArray).toBytes();
    Uint8List splicedInvalidEncodedArray = encodedArray.sublist(0, 2);

    expect(() => Multihash.decode(splicedInvalidEncodedArray),
        throwsA(TypeMatcher<RangeError>()));
  });

  test('decoding with insufficient length', () {
    String input = "Hello World";

    List<int> bytes = utf8.encode(input); // data being hashed
    Digest digest = sha256.convert(bytes);
    Uint8List inputByteArray = Uint8List.fromList(digest.bytes);

    Uint8List encodedArray =
        Multihash.encode('sha2-256', inputByteArray).toBytes();
    Uint8List splicedInvalidEncodedArray = encodedArray.sublist(0, 2);

    expect(() => Multihash.decode(splicedInvalidEncodedArray),
        throwsA(TypeMatcher<RangeError>()));
  });

  test('decoding with unsupported code', () {
    String input = "Hello World";

    List<int> bytes = utf8.encode(input); // data being hashed
    Digest digest = sha256.convert(bytes);
    Uint8List inputByteArray = Uint8List.fromList(digest.bytes);

    Uint8List encodedArray =
        Multihash.encode('sha2-256', inputByteArray).toBytes();
    encodedArray[0] = -1; // adding unsupported code

    expect(() => Multihash.decode(encodedArray),
        throwsA(TypeMatcher<UnsupportedError>()));
  });

  test('decoding with invalid digest length', () {
    String input = "Hello World";

    List<int> bytes = utf8.encode(input); // data being hashed
    Digest digest = sha256.convert(bytes);
    Uint8List inputByteArray = Uint8List.fromList(digest.bytes);

    Uint8List encodedArray =
        Multihash.encode('sha2-256', inputByteArray).toBytes();
    encodedArray[1] = 0; // adding unsupported code

    expect(() => Multihash.decode(encodedArray),
        throwsA(TypeMatcher<RangeError>()));
  });

  test('decoding with incompatible multihash length parameter and digest\'s',
      () {
    String input = "Hello World";

    List<int> bytes = utf8.encode(input); // data being hashed
    Digest digest = sha256.convert(bytes);
    Uint8List inputByteArray = Uint8List.fromList(digest.bytes);

    Uint8List encodedArray =
        Multihash.encode('sha2-256', inputByteArray).toBytes();
    encodedArray[1] = 1; // adding wrong length

    expect(() => Multihash.decode(encodedArray),
        throwsA(TypeMatcher<RangeError>()));
  });

  test('decoding valid CIDv1 ', () {
    // See the inspector of this code in https://cid.ipfs.tech/#bafybeigdyrzt5sfp7udm7hu76uh7y26nf3efuylqabf3oclgtqy55fbzdi.
    String input =
        'bafybeigdyrzt5sfp7udm7hu76uh7y26nf3efuylqabf3oclgtqy55fbzdi';

    // String with the version + multicodec + multihash
    String versionCodecMultihash = input.substring(1);

    // Decode the string
    Uint8List versionCodecMultihashArray = base32.decode(versionCodecMultihash,
        encoding: Encoding.nonStandardRFC4648Lower);

    // Removing the two leading varints (pertaining to the version + multicodec)
    // This leaves the rest of the array with as the multihash
    var multihashArray = versionCodecMultihashArray.sublist(2);

    var decodedObj = Multihash.decode(multihashArray);

    expect(decodedObj.code, equals(0x12));
    expect(decodedObj.name, equals("sha2-256"));
    expect(decodedObj.size, equals(32));
  });
}
