# dart_multihash

[![build](https://github.com/dwyl/dart_multihash/actions/workflows/ci.yml/badge.svg)](https://github.com/dwyl/dart_multihash/actions/workflows/ci.yml)
[![codecov](https://codecov.io/gh/dwyl/dart_multihash/branch/main/graph/badge.svg?token=Wvw2y9Kpbp)](https://codecov.io/gh/dwyl/dart_multihash)

This is an implementation of the 
[Multihash](https://github.com/multiformats/multihash)
standard in Dart.
This package provides an extensible representation of cryptographic hashes
and a list of [multicodecs](https://github.com/multiformats/multicodec) for those who find them useful.

# Install

To install `dart_multihash`, 
simply run the following command,
depending on the preferred platform.

```sh
flutter pub add dart_multihash
dart pub add dart_multihash
```

# Usage

This package simply encodes and decodes
hashes with the Multihash standard. 
This is a low-level library. 
So bring your own digest.
To create hashes, you will most likely
need to use a package
like [`crypto`](https://pub.dev/packages/crypto)
to hash a given input.

Here's the standard use of `dart_multihash`,
using the `encode()` and `decode()` functions.

```dart
import 'package:crypto/crypto.dart';

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
```

If we were to inspect `MultihashInfo`, 
we would get access to the following info.

```dart
{
    "code": 0x12, 
    "name": "sha2-256",
    "size": 32,
    "digest": [165, 145, 166, 212, 11, 244, 32, 64, 74, 1, 23, 51, 207, 183, 177, 144, 214, 44, 101, 191, 11, 205, 163, 43, 87, 178, 119, 217, 173, 159, 20, 110],
}
```

This is the info that follows the 
[`Multihash format`](https://multiformats.io/multihash/#the-multihash-format)
standard.

- `digest` is the digest of the multihash.
- `size` is the length of the digest.
- `name` is the name of the hash function.
- `code` is the code of the hash function.

We recommend checking:
https://cid.ipfs.tech/#bafybeigdyrzt5sfp7udm7hu76uh7y26nf3efuylqabf3oclgtqy55fbzdi
to inspect a CID and see these parameters explained.

## Supported Algorithms

The list of canonical algorithms
can be found on the
[multiformat's multicodec](https://github.com/multiformats/multicodec/blob/master/table.csv)
repo.
This package tries to support
as many hash functions as possible.
If you want to check
how many are currently supported, 
do check the [`lib/src/constants.dart`](https://github.com/dwyl/dart_multihash/blob/main/lib/src/multihash/constants.dart)
file for a list of these.

If you want access to these codecs,
you can use `Multicodec.list()`.

```dart
List<MultiCodec> list = MultiCodecs.list();
```

# Contribute

If you have any questions 
or have suggestions on 
how to improve this package,
don't hesitate and 
[open an issue](https://github.com/dwyl/dart_multihash/issues).

# Recommended reading

If you are wanting to know more about Multihashing
why it is needed and how the format works,
check the official guidelines https://multiformats.io/multihash/

If you are looking for a *visual example*
of how Multihash formatting works,
check the following https://github.com/multiformats/multihash#visual-examples

# License

The library is available
under the terms of the 
[MIT License](https://opensource.org/licenses/MIT).

