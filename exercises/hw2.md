- 1
disregards the  type of promises.A type T variable may really have "no value," in which case each dereference must be verified at the  runtime.This is the opposite of the very point of promises.Security flaws and null-dereference crashes are among the most prevalent errors in all languages.Not in the region.  The  "No value" is not a valid domain member .  Absence seems to be equivalent to T when encoded as a special pointer.complexity that proliferates.   Every API either fails in odd ways or has guarded if (x == null) tests.There are better alternatives available.Lack is obvious and can be checked by the type system if it is a non-null values and maybe types (Option<T>, Optional\T>, T?)are used.

- 2
Hoare referred to his null as his "billion-dollar error."  Because it made the  implementation easy and data structures convenient it is easy sentinel for list ends , and because languages and compilers lacked rich type machinery which are sum types, non-null types, flow analysis, so to express possibly absent values cleanly, he added it (in the 1960s, while designing pointer/reference features).  Dijkstra objected, but time constraints and practicality prevailed over perfect design. 

- 3
Correct value: 3**35 = 50031545098999707 an exact integer.
Python returns the exact integer, because they are arbitrary precision.
JavaScript evaluates numbers as IEEE-754 double-precision floats (53 bits of precision).Near 5×10^16, doubles can’t represent every integer; the spacing between representable integers is 8. The exact result (…9707) is not representable, so it is rounded to the nearest representable double (50031545098999712). When that double is printed with JavaScript’s “shortest round-trip” formatting, you typically see 50031545098999710 even though the stored value is 50031545098999712.
Bottom line: Python is right (exact). JavaScript shows a rounded value due to floating-point precision and its decimal-printing algorithm.