% Functional Programming lecture notes.
% Piyush P Kurur
m4_define(`lec',`m4_esyscmd(SCRIPTS/lecture `$1')')

Each lecture is a self contained [literate Haskell] program.  Hence you
can directly compile the code and run.

1. lec(Introduction)
2. lec(Warming up)
3. lec(More on pattern matching)
4. lec(Sieve of Eratosthenes)
5. lec(Fibonacci series)
6. lec(Folding lists)
7. lec(Data types)
8. lec(An expression evaluator)
9. lec(Lambda calculus)
10. lec(Modules)
11. lec(Towards type inference)
12. lec(Unification algorithm)

[literate haskell]: <http://www.haskell.org/haskellwiki/Literate_programming>
	  "Literate Haskell Programming"
m4_include(MACROS/update-time.m4)
