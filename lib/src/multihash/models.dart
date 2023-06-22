/// Class with information regarding the [name]
/// and the [code] that identifies it.
///
/// It holds multiformat convention data used in the `hashTable` constant.
class Codec {
  final int code;
  final String name;

  const Codec({required this.code, required this.name});
}

/// Class that holds information regarding a digest
/// and the referring Multihash information
/// (multicodec name, multicodec code, length of digest and [digest])
///
/// This class is to return information to the user after decoding.
class MultihashInfo extends Codec {
  final List<int> digest;
  final int length;

  const MultihashInfo({required code, required name, required this.digest, required this.length})
      : super(code: code, name: name);
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
