import 'dart:typed_data';

import 'varint_utils.dart';

/// Class with information regarding the [name]
/// and the [code] that identifies it.
///
/// It holds multiformat convention data used in the `codecTable` constant.
class MultiCodec {
  final int code;
  final String name;

  const MultiCodec({required this.code, required this.name});
}

/// Class that holds information regarding a digest
/// and the referring Multihash information.
///
/// [digest] is the digest of the multihash.
/// [size] is the length of the digest.
/// [name] is the name of the hash function.
/// [code] is the code of the hash function.
class MultihashInfo {
  final List<int> digest;
  final int size;
  final String name;
  final int code;

  const MultihashInfo(
      {required this.code,
      required this.name,
      required this.digest,
      required this.size});

  /// Builds the array of bytes with hash function type, length of digest and digest.
  Uint8List toBytes() {
    var b = BytesBuilder();
    b.add(encodeVarint(code));
    b.add(encodeVarint(size));
    b.add(digest);

    return b.toBytes();
  }
}
