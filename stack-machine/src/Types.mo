module {

  // An expression is either an operator or a singular value
  public type Expr = {
    #op: Op;
    #val: Val;
  };

  // All possible operations in our stack machine
  public type Op = {
    #nop;
    #add: (Val);
    #sub: (Val);
    #concat: (Val);
    #eq: (Val);
    #brancheq: (Val, Val); // To be implemented in Module 4 (branching)
    #branchneq: (Val, Val); // To be implemented in Module 4 (branching)
  };

  // All possible atomic values in our stack machine
  public type Val = {
    #int: Int;
    #str: Text;
    #bool: Bool; // To be implemented in Module 3/4
  };

  /// Helper function that determines if two values are equal (in type and value).
  /// Args:
  ///   |val1|   First value.
  ///   |val2|   Second value.
  /// Returns:
  ///   #val(#bool(True)) when vaues are equal, #val(#bool(False)) otherwisen
  public func valEq(val1: Val, val2: Val) : Bool {
    switch (val1, val2) {
      case (#int(i1), #int(i2)) i1 == i2;
      case (#str(s1), #str(s2)) s1 == s2;
      case (#bool(b1), #bool(b2)) b1 == b2;
      case (_, _) false;
    }
  };

};
