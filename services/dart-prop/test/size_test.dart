import "package:test/test.dart";
import "../lib/size/size.dart" as sizing;

class TestRig {
  int _in;
  String _out;
  TestRig(int intIn, String strOut){
    _in = intIn;
    _out = strOut;
  }
}

var tests = [
    TestRig(-1, "negative"),
    TestRig(5, "small"),
];

main() {

  setUp(() async {
    // Do async setup stuffs
    print("Testing suite setup finished...");
  });

  for (var testCase in tests) {
    test("Validate sizing library against TestRig", () {
      expect(testCase._out, equals(sizing.Size(testCase._in)));
    });
  }

  tearDown(() async {
    // Do async cleanup stuffs
    print("Testing suite teardown finished...");
  });
}
