import Stack "../src/Main";
import Types "../src/Types";

actor {

  func basicTest() {};

  // Helpers

  func setup() {};
  func tearDown() {};

  // Test Hook

  let tests = [basicTest];

  public func run() {
    for (test in tests.vals()) {
      setup();
      await test();
      tearDown();
    };
  };

};
