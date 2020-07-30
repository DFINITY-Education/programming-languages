import Iter "mo:base/Iter";
import List "mo:base/List";
import Result "mo:base/Result";

import Stack "./Stack";
import Types "./Types";

actor {
  type Expr = Types.Expr;
  type Val = Types.Val;
  type Op = Types.Op;

  let NOP: Expr = #op(#nop);
  var stack = Stack.Stack();

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

  func evalSub(val1: Val, val2: Val) : Expr {
    switch (val1, val2) {
      case (#int(v1), #int(v2)){
        #val(#int(v1 + v2))
      };
      case (_) {
        NOP
      };
    }
  };

  func evalConcat(val1: Val, val2: Val) : Expr {
    switch (val1, val2) {
      case (#int(v1), #int(v2)){
        #val(#int(v1 + v2))
      };
      case (_) {
        NOP
      };
    }
  };

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
