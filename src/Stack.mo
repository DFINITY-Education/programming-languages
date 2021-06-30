import List "mo:base/List";

import Types "./Types"

module {

  type Expr = Types.Expr;

  public class Stack() {
    var localStack = List.nil<Expr>();

    public func push(expr: Expr) {
      localStack := List.push(expr, localStack);
    };

    public func pop() : Expr {
      switch (localStack) {
        case (null) {
          #op(#nop)
        };
        case (?(h, t)) {
          localStack := t;
          h
        };
      }
    };

    public func discard() {
      switch (localStack) {
        case (?(h, t)) {
          localStack := t;
        };
        case (_) {};
      }
    };

    public func isEmpty() : Bool {
      List.isNil(localStack)
    };
  };

};
