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

There are no private feilds in Zig so we're not using getters like the Cpp version. 

https://github.com/ziglang/zig/issues/9909#issuecomment-942686366

There are no hidden allocations in Zig so we're passing allocators explicitly!

## 3.0 Creating Trees

Zig is very similar to the Cpp version just need to pass around the allocator!

Errors must be handle explicitly in Zig or bubbled up. The compiler will trigger a build error if you ignore a returned error. So we add try statements before anything that can fail. 

In Zig `std.ArrayList`, is a struct wrapper. You cannot index a struct directly. So you need to access the items within the struct. ArrayList looks like this:

```
pub fn ArrayList(comptime T: type) type {
    return struct {
        items: []T,          // This is the actual slice you can index!
        capacity: usize,
        allocator: Allocator,
        
        // ... methods like append(), init() ...
    };
}
```
## 4.0 Creating a Tree Manipulator

In Zig we have to be much more eexplicit about mem managment. Because the TreeManip struct holds the Tree we need to make sure we're not leaking memory.

In TreeManip.createTestTree we heap allocate a Tree on the heap and store it in the TreeManip.tree. 

```zig
const tree = try gpa.create(Tree);
tree.* = .{};
self.tree = tree;
```

```zig
pub fn deinit(self: *Self, allocator: std.mem.Allocator) void {
    // dealocate the tree
    if (self.tree) |tree| {
        tree.deinit(allocator);
        allocator.destroy(tree);
        self.tree = null;
    }
}
```

I also added build on save and a check step to the Zig build graph https://zigtools.org/zls/guides/build-on-save/

## 5.0 

Boost is a collection of C++ libraries. Zig doesn't have a direct equivalent to Boost, but we can use the zig standard library and other third-party libraries to achieve similar functionality. For the Cpp build we can add Boost with the Zig build system.

```bash
cd src-cpp/libraries
wget https://www.boost.org/releases/1.71.0
tar -xzf boost_1_71_0.tar.gz
```

Then we can add the Boost root directory to the include search path 

```zig
cpp_exe.root_module.addIncludePath(b.path("src-cpp/libraries/boost_1_71_0"));
```

Zig doesn't have strings so we build our newick string as a array  `var newick_buf: std.ArrayList(u8) = .empty; try newick_buf.append(gpa, '(');` and return by pass ownership back to the calling scope `newick_buf.toOwnedSlice(gpa)`.

We also use ArrayList for the node stack as it has the necessary methods https://zig.guide/standard-library/stacks/.

We need to make sure that we take pointers to values we dont own. In the Create test tree method we were previously taking local copies of tree nodes that were going out of scope when the function returned leaving dangling pointers. I've update the code to use pointers so the tree still owns them.



 





