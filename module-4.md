# Module 4: Branching

Now that you've built a functional stack machine, it's time to add a bit more advanced functionality. What if you want to execute certain operations only *if* a certain condition is true? That's where *branching* comes is, which is just a fancy word for a simple if statement.

This module further expands on the code written in the prior modules thus far. You will add two additional operators, enabling the parser to evaluate “if” statements and implement conditional branching.

## Your Task
In this exercise, you will implement two additional operators, `#branchEq`  and `#branchNeq`, and build out helper functions to process them, ultimately enabling basic branching capability in your stack machine.

### Code Understanding

Our two new operators, `#branchEq`  and `#branchNeq`, will both store two values. The first value is the one that the current expression in the stack is compared to, and the second is an `#int` specifying the number of expressions to skip if the comparison evaluates to true.

Let's take a look at an example:

```
(#val(#int(1))) // 1
(#brancheq(#int(1), #int(2))) // if equal to '1', skip 3 expressions
(#branchneq(#int(1), #int(1))) // if not equal to '1', skip 1 expression
(#op(#add(#val(#int(2))))) // this will be skipped
(#op(#sub(#val(#int(5))))) // this will be skipped
(#op(#add(#val(#int(9))))) // + 9
---
//(#val(#int(10))) 1 + 9 evaluates to 10
```

The second line is equivalent to "if equal to '1,' then skip 3 expressions" (including the second branching statement). Our current value in the stack is 1, so this evaluates to true, skipping the next three expressions (which include the other branch statement, "add 2," and "subtract 5") and ultimately executing "add 9". The third line essentially acts as our "else" in this case; if the value on the stack isn't equal to 1, then we will just skip one line. 

While this functionally is quite limited, it demonstrates how basic branching works and could easily be expanded to accommodate more complicated syntax.

### Specification 

**Task:** Complete the implementation of `evalBranchEq` and `evalBranchNeq` in *src/Main.mo*. Accordingly, you must extend the functionality of `evalOp` in *src/Main.mo* and the `op` type in *src/Types.mo*.

**Things to Consider:**

* Begin by adding your two new operator types in *src/Types.mo*, and call them `#brancheq` and `branchneq`. Both will take in two `Val`s.
* Next, you must add two additional cases in `evalOp` - one for each of the operators you just added. Look at how we've handled other operators for some hints as to how the syntax should look. The `#branchEq` case should make a call to the `evalBranchEq` helper, while the `#branchneq` case should make a call to the `evalBranchNeq` helper.
* Finally, implement the bodies for the `evalBranchEq` and `evalBranchNeq` functions. You may find the `discard` function that we've implemented in the `Stack` class helpful in "skipping" over expressions in the stack

### Testing

The following test should run to completion:

```bash
> dfx deploy
Deploying all canisters.
All canisters have already been created.
Building canisters...
Installing canisters...
Upgrading code for canister StackMachine, with canister_id renrk-eyaaa-aaaaa-aaada-cai

...

> dfx canister call Test run
()
```