# ZigStrom 

A trad code Zig rewrite of Paul Lewis' [Strom Tutoiral](https://stromtutorial.github.io/).

I'm working through the strom tutoiral and writing this in Zig as I go. I will try to tag releases for each of the major steps (although I'll probably have to go back as the code diverges).


## 1.0 Setting Up A Build System

https://ziglang.org/documentation/master/#Zig-Build-System
https://ziglang.org/learn/build-system/
https://alwint3r.medium.com/using-zigs-build-system-for-c-projects-in-2025-e451ba9bfc46

```bash
curl https://www.zvm.app/install.sh | bash
```

```bash
zvm i 0.16.0
```

```bash
zig build
```

## 2.0 Node and Tree Classes

Zig doesn't have OOP so we need to use structs instead of Classes. 

https://ziglang.org/documentation/master/#struct

Zig also doesn't use header files so we include Node interface and implementation in a single file.

