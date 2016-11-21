# Lazinize turns OCaml into Haskell

OCaml evaluation strategy is called *call by value*, or more generally
*eager evalulation*. Haskell one is called *call by name*, or more
precisely *call by need*, or more generally *lazy evaluation*.

In *call by value* strategy, arguments of a function call are
evaluated *before* the function body evaluation. In *call by name*
strategy, arguments are evaluated once they are used during the
function body evaluation. *call by value* is more efficient while
*call by name* avoids code to diverge.

For instance, such expression:

```haskell
omega = (\x -> x x) (\x -> x x)
foo(x, y) = y 
```

Will diverge in OCaml while it will not in Haskell.

## Lazinize

Lazinize show you how to transform OCaml evalution strategy into
Haskell one. It models a minimalistic pure functional programming
language:

```ocaml
type term = TVar of int
	  | TLam of term
	  | TApp of term * term
```

where values are closure:

```ocaml
type value = VClos of term * env
and env = value list
```

The function `be_lazy` transforms a `term` into another one, but lazinized.

## Examples

```
let _ = 
  let omega = (TApp (TLam (TApp (TVar 1, TVar 1)), 
		     TLam (TApp (TVar 1, TVar 1)))) in
  let t = TApp (TLam (TLam (TVar 1)), omega) in
  exec t
```

This example shows that the execution does not diverge as excepted in
*call by value* languages.

## License

CallByValue is made under the terms of the MIT license.
