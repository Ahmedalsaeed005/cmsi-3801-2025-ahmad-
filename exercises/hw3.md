- 1
 Haskell - 
data Tree a = Empty | Node (Tree a) a (Tree a)

TypeScript - 
type Tree<A> =
  | { readonly tag: "empty" }
  | { readonly tag: "node"; readonly left: Tree<A>; readonly value: A; readonly right: Tree<A> };

- 2
Base: a^0 = 1
Step: a^(n+1) = a * a^n

- 3 
a -  
Inhabitants of 1 and 0
1 (unit type): exactly one inhabitant (e.g.., () in Haskell, {} in TS as nominal unit).
0 (void/empty type): no inhabitants (in Haskell Void, in TS never).

b - 
Inhabitants of product and sum

Product A × B: all pairs (a, b) with a : A and b : B.
Sum A + B: all tagged values Left a with a : A or Right b with b : B

- 4
 a -
 Inhabitants of Bool × Unit
 Product Bool × Unit: pairs (b, u) with b ∈ {True, False}, u = ().
Inhabitants: (True, ()), (False, ()) → two.
 b -
 Inhabitants of Bool → Unit
 Function Bool → Unit: functions from a two-element set to a one-element set.
Only the constant function λ_. () → one inhabitant. 

- 5
Grapheme clusters ≠ code points/units: a “character” may be multiple code points (emoji/combining marks), so naive indexing/slicing is wrong.

Indexing cost: grapheme boundaries require scanning; O(1) indexing is a fiction.

Normalization pitfalls: canonically equivalent strings may differ byte-wise; case-folding is locale-sensitive.

Leaky encodings: APIs expose UTF-8/16/code-point details, causing length/slice/compare bugs.

Better model: treat text as opaque with iterators over graphemes, explicit normalization, and locale-aware ops.

- 6 
No in the simply-typed λ-calculus (and HM/System F without recursive types).
Typing x x forces x : τ → σ and x : τ simultaneously, yielding τ ≃ τ → σ, an unsolvable recursive constraint. It’s the classic untypable self-application (Ω).

- 7
Using the characteristic function χ_A : X → Bool:
x∈/A  <-->  ¬χA​(x)
Equivalently, with a predicate A : X → Bool, write ¬ A(x).

- 8
A pure function is deterministic (same inputs → same output) and has no observable side effects (no I/O, mutation, hidden state, or time dependence).
We care because purity gives referential transparency, enabling equational reasoning, simpler tests, parallelization, memoization, and stronger compiler optimizations.

- 9
By the type system: pure code has type a; effectful code is typed in effectful contexts (e.g., IO a, State s a, Except e a, etc.).
Monads sequence effects (do-notation), and you cannot escape effects into purity (IO a → a is disallowed), so purity is enforced at compile time.

- 10
& : it extends a shape with more members
type Animal = { eat(): void };
type Dog = Animal & { bark(): void }; 
const d: Dog = { eat(){}, bark(){} };
const a: Animal = d; // substitutable

| : represents alternatives and requires narrowing before use.
