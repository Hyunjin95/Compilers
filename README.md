# SnuPL/1

The course project was to implement a simple compiler for the SnuPL/1 language from scratch.

This compiler compiles SnuPL/1 source code to 32-bit Intel assembly code.

The final version of compiler is in [5.Code.Generation/snuplc](https://github.com/hyunjin95/snu-compilers-2016/tree/master/5.Code.Generation/snuplc) and can be tested by typing this command:

```
snuplc $ make all
snuplc $ ./TODO TODO.mod
```

# Project

## 1. Scanning
In this first phase, your job is to implement a scanner for the SnuPL/1 language as specified in the course project overview.

## 2. Parsing
In the second phase of our semester project, we construct a parser for the SnuPL/1 language based on a hand-written predictive parser.

## 3. Semantic Analysis
In this third phase of the project, your job is to perform semantic analysis.
After completing the previous phase your parser prints the parsed input as an abstract syntax tree.

## 4. Intermediate Code Generation
In this fourth phase of the project your task is to convert the abstract syntax tree into our intermediate representation in three-address code form.

## 5. Code Generation
In this fifth and last phase of the project, your task is to convert the IR code into x86 assembly code.
After finalizing this phase, your SnuPL/1 compiler is complete: it takes programs written in SnuPL/1 and outputs assembly code that can be compiled by an assembler into an executable file.
