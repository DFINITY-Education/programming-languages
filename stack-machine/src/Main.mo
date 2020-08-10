import Iter "mo:base/Iter";
import List "mo:base/List";
import Result "mo:base/Result";

import Stack "./Stack";
import Types "./Types";

actor {
  type Expr = Types.Expr;
  type Val = Types.Val;
  type Op = Types.Op;

  // An empty expression that evaluates to nothing
  let NOP: Expr = #op(#nop);
  // The stack that holds queued expressions
  var stack = Stack.Stack();

  /// Evaluates expressions held in the stack.
  /// Returns:
  ///   The final value that the stack evaulates to.
  ///   Possible errors: #err if the final expression in the stack (once evaluated) is not a #val.
  public func eval() : async Result.Result<Val, ()> {
    var currentExpr = NOP;
    while (not stack.isEmpty()) {
      switch (stack.pop()) {
        case (#val v) {
            currentExpr := #val(v);
        };
        case (#op op) {
          stack.push(evalOp(currentExpr, op));
        };
      };
    };
    switch (currentExpr) {
      case (#val v) { #ok(v) };
      case (_) { #err() };
    }
  };

  /// Evaluates single expressions given an operator.
  /// Args:
  ///   |expr|   The operand used with the operator - must be a #val type.
  ///   |op|     The operator to be used (which naturally contains the other operand).
  /// Returns:
  ///   The value resulting from applying the operator to is operands.
  func evalOp(expr: Expr, op: Op) : Expr {
    switch (expr) {
      case (#val v) {
        switch (op) {
          case (#nop) {
            #val(v)
          };
          case (#add(operand)) {
            evalAdd(v, operand)
          };
          case (#sub(operand)) {
            evalSub(v, operand)
          };
          case (#concat(operand)) {
            evalConcat(v, operand)
          };
          case (#eq(operand)) {
            evalEq(v, operand)
          };
          case (#brancheq(operand1, operand2)) {
            evalBranchEq(v, operand1, operand2)
          };
          case (#branchneq(operand1, operand2)) {
            evalBranchNeq(v, operand1, operand2)
          };
        }
      };
      case (_) {
        NOP
      };
    }
  };

  /// Helper function to add two values using pattern matching.
  /// Args:
  ///   |val1|   First value.
  ///   |val2|   Second value.
  /// Returns:
  ///   |val1| + |val2|
  func evalAdd(val1: Val, val2: Val) : Expr {
    switch (val1, val2) {
      case (#int(v1), #int(v2)){
        #val(#int(v1 + v2))
      };
      case (_) {
        NOP
      };
    }
  };

  /// Helper function to subtract two values using pattern matching.
  /// Args:
  ///   |val1|   First value (value subtracted from).
  ///   |val2|   Second value (value subtracted).
  /// Returns:
  ///   |val1| - |val2|
  func evalSub(val1: Val, val2: Val) : Expr {
    switch (val1, val2) {
      case (#int(v1), #int(v2)){
        #val(#int(v1 - v2))
      };
      case (_) {
        NOP
      };
    }
  };

  /// Helper function to concatonate two strings using pattern matching.
  /// Args:
  ///   |val1|   First value.
  ///   |val2|   Second value.
  /// Returns:
  ///   |val1| # |val2|
  func evalConcat(val1: Val, val2: Val) : Expr {
    switch (val1, val2) {
      case (#str(v1), #str(v2)){
        #val(#str(v1 # v2))
      };
      case (_) {
        NOP
      };
    }
  };

  /// Helper function that determines if two values are equal (in type and value).
  /// Args:
  ///   |val1|   First value.
  ///   |val2|   Second value.
  /// Returns:
  ///   #val(#bool(True)) when vaues are equal, #val(#bool(False)) otherwise
  func evalEq(val1: Val, val2: Val) : Expr {
    #val(#bool(Types.valEq(val1, val2)))
  };

  func evalBranchEq(val1: Val, val2: Val, jump: Val) : Expr {
    switch (jump) {
      case (#int(j)) {
        if (Types.valEq(val1, val2)) {
          for (i in Iter.range(0, j)) { stack.discard(); };
        };
        #val(val1)
      };
      case (_) { NOP };
    }
  };

  func evalBranchNeq(val1: Val, val2: Val, jump: Val) : Expr {
    switch (jump) {
      case (#int(j)) {
        if (not Types.valEq(val1, val2)) {
          for (i in Iter.range(0, j)) { stack.discard(); };
        };
        #val(val1)
      };
      case (_) { NOP };
    }
  };

};
