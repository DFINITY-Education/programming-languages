module {

  public type Expr = {
    #op: Op;
    #val: Val;
  };

  public type Op = {
    #nop;
    #add: (Val);
    #sub: (Val);
    #concat: (Val);
    #eq: (Val);
    #brancheq: (Val, Val); // To be implemented in Module 3 (typing)
    #branchneq: (Val, Val); // To be implemented in Module 3 (typing)
  };

  public type Val = {
    #int: Int;
    #str: Text;
    #bool: Bool;
  };

  public func valEq(val1: Val, val2: Val) : Bool {
    switch (val1, val2) {
      case (#int(i1), #int(i2)) i1 == i2;
      case (#str(s1), #str(s2)) s1 == s2;
      case (#bool(b1), #bool(b2)) b1 == b2;
      case (_, _) false;
    }
  };

};
