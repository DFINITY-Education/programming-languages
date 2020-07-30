import Stack "./Stack";

module {

  type Stack = Stack.Stack;

  func program() : Stack {
    var stack = Stack();
    stack.push()
    stack
  }

};
