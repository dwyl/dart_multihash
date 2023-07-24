import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:dart_multihash/dart_multihash.dart';

// String we want to hash and encode with Multihash.
String input = "Hello World";

// Converting the input string to an array of bytes
List<int> bytes = utf8.encode(input);

// Hashing the string using the SHA-256 algorithm using the `crypto` package
Digest digest = sha256.convert(bytes);
Uint8List inputByteArray = Uint8List.fromList(digest.bytes);

// Encoding the hash digest with the Multihash standard.
MultihashInfo encodedObj = Multihash.encode('sha2-256', inputByteArray);
Uint8List encodedBytes = encodedObj.toBytes();

// If we want to decode a Multihash-encoded hash, simply use `decode`.
MultihashInfo decodedObj = Multihash.decode(encodedBytes);
