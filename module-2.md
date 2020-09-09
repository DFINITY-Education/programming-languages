# Module 2: Simple Stack Machine

Implement a basic stack machine that parses through a limited set of expressions and evaluates them to produce the expected result, as per the example below:
```
(#val(#int(1))) // 1
(#op(#add(#val(#int(2))))) // + 2
---
(#val(#int(3)) // Evaluates to 3
```

## Background
A **stack machine** is a computer that uses a _last-in, first-out_ stack, meaning that the element most recently added to the top of the stack is the first to be evaluated. Many programming languages use stack machines under the hood to keep track of expressions and sequentially evaluate them. As a result, understanding how a simple stack machine is implemented will give you a better sense of how common languages manage the subroutines and method calls that they are composed of. 

A stack machine begins by (1) taking the topmost value of the stack along with (2) the operator and other operand from the second-most place. These terms are popped off the stack, evaluated, and then the resulting value is popped back on the top of the stack. Here’s an example with the expression `1 + 1 * 2`

```
1
+ 1
* 2
```
The 1 + 1 evaluates to 2, which is pushed to the top of the stack:
```
2
* 2
```
2 * 2 evaluates to 4, which is again pushed to the top of the stack. At this point, the stack recognizes that there are no more expressions to evaluate and returns the final value, 4. 
```
4
```

## Your Task
In this exercise, you will implement a simple stack machine like the one described above. This machine will perform most basic operations, like addition, subtraction, multiplication, and division, and you will have the opportunity to extend the functionality in modules 3 and 4.

### Code Understanding
Let’s start by taking a look at _src/Types.mo_, which contains all of the relevant types for our stack machine.  The most basic atomic unit in our machine is a `#val`, or value, which preliminarily can take the form of an integer, boolean, or string. We’ve limited our machine to these three values for simplicity, but you could extend functionality by adding more value types. Next, an `#op`, or operator, represents an action that’s paired with a value. Operators range from addition and subtraction to `if` statements. Additionally, operators may only work with certain types (i.e. you cannot add a boolean and an integer), but this functionality need not be represented in our _Types.mo_ file (instead, it’s implemented in the evaluator itself - see [Module 3](#module-3.md)). Finally, an `#Expr`, or expression, is the largest “unit” in our stack machine, composed of either an `#Op` or a `#Val`.

Now let’s take a look at the implementation of our stack in _src/Stack.mo_. Here, you’ll find relevant helper functions for manipulating the stack, which is just implemented as a `List` in Motoko. You can `push` and `pop` elements from the top of the stack as well as `discard` the head of the stack or check if the stack `isEmpty`.

Every element in our stack must be an expression type, and each element should only have one operator to maintain the simplicity of the stack machine. We will move from the top of the stack to the bottom, evaluating expressions to their values and then placing their simplified form at the top of the stack again for further evaluation. Let’s take a look at how our machine would represent 2 + 3 on the stack:
```
(#val(#int(2))) // 2
(#op(#add(#val(#int(3))))) // + 3
```
The stack machine will start the with the integer 2,  sees that it’s a `#val`, and use that as the starting value. Next, it will look to the second element in the stack, the operator `#add` and the operand 3, 

Finally, let’s turn to the file where our evaluator is held: _src/Main.mo_. The type `NOP` is a placeholder for times when an expression contains no operator (such as at the top of the stack) - you can see how this is implemented in some of the other provided helper functions. `eval`, left to be implemented by you, is the main function driving the stack machine. `eval` iteratively evaluates expressions held in the `stack`, ultimately returning a single value upon completion. 

`evalOp`, used as a helper function within `eval`, takes in an `expr` and `op` and pattern matches the operator to a known operation (addition, subtraction, etc.). It then calls a corresponding helper function associated with that operation, such as `evalAdd` or `evalSub`, ultimately returning the simplified value.

### Specification
**Task:** Complete the implementation of the `eval` method, which iteratively evaluates expressions held in the `stack` and ultimately returns a single value upon completion. In this module, there is no need to modify `Program.mo`, `Stack.mo`, or `Types.mo` (though some of these files may require modification in later modules).

**Things To Consider:**
* Every stack will start with a “seed” value. That is, a singular value (without an operation) that all other lines in the stack will build upon. In the example above for `2 + 3`, `2` was our seed value. As a result, `eval` should distinctly handle `#val`s and `#op`s as it pops them off the stack. A `#val` will only every occur at the topmost position in the stack - `#val`s occurring later in the stack will be wrapped in `#op`s, as a lone value has no context and can not be interpreted.
* `eval` should continue running until the stack is empty, at which point the current value should be returned.
* Make sure to call `evalOp` to evaluate each item that you remove from the stack. 

### Testing
The following test should run to completion:
```bash
> dfx build
Building canisters...

> dfx canister install --all
"StackMachine" canister created with canister id: "ic:..."
"Test" canister created with canister id: "ic:..."
...

> dfx canister call Test run
()
```
