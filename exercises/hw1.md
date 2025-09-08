1.
Filtering involves choosing only the items from a list that meet a specific condition (a true/false evaluation), while maintaining their original sequence.
code example:
nums = [1, 2, 3, 4, 5, 6]
evens = list(filter(lambda n: n % 2 == 0, nums))  # [2, 4, 6]

2.
numbers_cubed = numbers .^ 3

3.
In programming languages, the practical aspects of how language features are utilized to achieve objectives include considerations such as performance trade-offs, tooling, idioms, readability and maintainability, interoperability, debugging, and the ways in which actual users leverage features beyond formal syntax and semantics.  A concise course note states, “practical aspects of how constructs may be utilized to reach goals.”

4.
- x!2 → elementwise mod 2 (remainders), so a booleanish vector where odd→1, even→0. (In K, dyadic ! is modulo; see K examples of ! in modular contexts.)
- & (monadic where) on that vector returns the indices of non-zeros (i.e., indices of odd elements).
- x[ ... ] → indexing into x with those positions; selects the odd elements. (Indexing/apply rules.)
- ^2 → square each selected element (power operator is vectorized).
- +/ → sum-reduce (the / adverb reduces with +).

5.
Encapsulation, interfaces, polymorphism, and inheritance (though composition is preferable) are fundamental concepts in today's paradigm, which organizes state and activity into objects. 

 The original notion (Alan Kay/Smalltalk) was object messaging, encapsulation (hiding state/process), and extreme late binding. Classes weren't the focus.  Kay: “OOP to me means only messaging, local retention and protection and hiding of state-process, and extreme late-binding of all things.”

 6.
 1, ᐊ — U+140A CANADIAN SYLLABICS A
 2, ᐃ — U+1403 CANADIAN SYLLABICS I
 3, ᓐ — U+14D0 CANADIAN SYLLABICS N (final)
 4, ᖓ — U+1593 CANADIAN SYLLABICS NGA
 5, ᐃ — U+1403 CANADIAN SYLLABICS I (again)

 7.
-  Control flow: the order a thread executes statements (sequence, conditionals, loops, function calls, exceptions).

-  Concurrency: organizing a program as numerous jobs that may advance simultaneously (threads, async/await, actors); decomposition/coordination, not simply order.  Parallelism is when many cores perform tasks concurrently.

8.
Machine language: raw binary opcodes executed by the CPU (e.g., 0b1001000100001111); not human-readable.

Assembly language: a human-readable 1:1 (mostly) mnemonic form of machine code with labels and directives; an assembler translates it to machine code.
code example: 
    addi x5, x0, 7      # x5 = 7
    addi x6, x0, 35     # x6 = 35
    add  x7, x5, x6     # x7 = x5 + x6 = 42

9.
this code in rust:
fn f(n: i64) -> i64 {
    if n % 2 == 0 {
        3 * n + 1   // if n is even
    } else {
        4 * n - 3   // if n is odd
    }
}

fn main() {
    for n in 0..6 {
        println!("{n} -> {}", f(n));
    }
}

10.
Epic Games released a Verse its a new programming language, along with the Unreal Editor for Fortnite  to the public in 2023.The team behind the project includes Haskell founder Simon Peyton Jones and Epic creator Tim Sweeney.Similar to Fortnite game categories, Verse was created to make it easier to create networked, concurrent, and interactive experiences in the Unreal environment.Its description states that it is a functional-logic language that blends.
Functional programming is characterized by pure functions, immutability, and computation based on expressions.Logic programming involves relationships, constraints, and goal-directed execution.By merging these paradigms, Verse provides a deterministic and safe foundation for considering complex behaviors in time-sensitive, distributed, and multiplayer contexts.Its goal is to enable programmers to write precise, legible, and maintainable code for large-scale interactive environments.