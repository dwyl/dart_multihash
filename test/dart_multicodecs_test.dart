
import 'package:dart_multihash/dart_multihash.dart';
import 'package:dart_multihash/src/multihash/models.dart';
import 'package:test/test.dart';

void main() {
  test('list multicodecs', () {
    List<MultiCodec> list = MultiCodecs.list();

    expect(list.length, isNot(equals(0)));
  });
}
