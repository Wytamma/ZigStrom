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

