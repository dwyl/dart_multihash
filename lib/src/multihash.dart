import 'dart:typed_data';

import './multihash/constants.dart';
import 'multihash/varint_utils.dart';
import './multihash/models.dart';

/// Multihash class which allows encoding and decoding
/// hash strings.
class Multihash {
  /// Encodes a digest with a passed hash function type.
  static MultihashInfo encode(String hashType, Uint8List digest, {int? length}) {
    // Checking if hash function type is supported
    if (!supportedHashFunctions.contains(hashType)) {
      throw UnsupportedError('Unsupported hash function type.');
    }

    // Function convention info
    MultiCodec hashInfo = codecTable.firstWhere((obj) => obj.name == hashType);

    // Check if length of digest is correctly defined.
    length ??= digest.length;
    if (length != digest.length) {
      throw RangeError('Digest length has to be equal to the specified length.');
    }

    return MultihashInfo(code: hashInfo.code, name: hashInfo.name, digest: digest, size: length);
  }

  /// Decodes an array of bytes into a multihash object.
  /// See https://cid.ipfs.tech/#bafybeigdyrzt5sfp7udm7hu76uh7y26nf3efuylqabf3oclgtqy55fbzdi to better understand what each varint means.
  static MultihashInfo decode(Uint8List bytes) {
    // Check if the array of bytes is long enough
    // (has to have hash function type, length of digest and digest)
    if (bytes.length < 3) {
      throw RangeError('Multihash must be greater than 3 bytes.');
    }

    // Decode code of hash function type
    var decodedCode = decodeVarint(bytes, null);
    if (!supportedHashCodes.contains(decodedCode.res)) {
      throw UnsupportedError('Multihash unknown function code: 0x${decodedCode.res.toRadixString(16)}');
    }

    bytes = bytes.sublist(decodedCode.numBytesRead);

    // Decode length of digest
    final decodedLen = decodeVarint(bytes, null);
    if (decodedLen.res <= 0) {
      throw RangeError('Multihash invalid length: ${decodedLen.res}');
    }

    // Get digest
    bytes = bytes.sublist(decodedLen.numBytesRead);
    if (bytes.length != decodedLen.res) {
      throw RangeError('Multihash inconsistent length with digest\'s length.');
    }

    // Fetch name of hash function type referring to the code
    String hashName = codecTable.firstWhere((obj) => obj.code == decodedCode.res).name;

    return MultihashInfo(code: decodedCode.res, size: decodedLen.res, name: hashName, digest: bytes);
  }
}

class MultiCodecs {
  static List<MultiCodec> list() => codecTable;
}
