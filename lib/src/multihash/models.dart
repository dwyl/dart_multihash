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

  const MultihashInfo({required this.code, required this.name, required this.digest, required this.size});
}

/// Util class used to fetch the leading variable integer of a stream/array of bytes.
///
/// [res] refers to the leading byte converted to an integer
/// and [numBytesRead] refers to the number of bytes that it occupies in the array of bytes.
class DecodedVarInt {
  final int res;
  final int numBytesRead;

  DecodedVarInt({required this.res, required this.numBytesRead});
}
