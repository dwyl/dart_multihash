import 'package:dart_multihash/dart_multihash.dart';
import 'package:test/test.dart';

void main() {
  test('list multicodecs', () {
    List<MultiCodec> list = MultiCodecs.list();

    expect(list.length, isNot(equals(0)));
  });
}
