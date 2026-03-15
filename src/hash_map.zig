//! this module implements a basic HashMap and functions that can
//! interact with it.
//!
//! It's very bare bones. The first draft is going to only have
//! a fixed size. It's not really an actual HashMap yet.
const std = @import("std");

/// global variable for array length before
/// we have the ability to make the HashMap dynamic.
const ARRAY_LENGTH: u8 = 16;

/// this is basically the item we store in the HashMap
/// struct. It just holds an optional key and value.
///
/// Having both values optional feels kinda dumb, but I'm also
/// assigning just a null value to them when initializing
/// the HashMap struct, so it's whatever for now...
const Item = struct {
    key: ?[]const u8,
    value: ?[]const u8,
};

/// The HashMap struct currently just holds a single bucket of items
/// that has a set size. There's no need to do any memory allocations
/// right now, but this should obviously have a dynamic size later.
const HashMap = struct {
    index: u64,
    items: [ARRAY_LENGTH]?Item,

    /// initializes the HashMap with an array of 16 items, with null values.
    pub fn init() HashMap {
        return HashMap{ .index = 0, .items = [_]?Item{null} ** ARRAY_LENGTH };
    }

    /// I don't know if you set the index actually like this. I just calculate
    /// the index by passing the key to the hashing function and then returning
    /// the remainder with ARRAY_LENGTH.
    ///
    /// The Hash probably needs a counter that gets updated with each addition,
    /// because I can't imagine how else we'd keep track of the array length.
    pub fn set(s: *HashMap, key: []const u8, value: []const u8) void {
        const index = HashMap.FNV1_hash(key) % ARRAY_LENGTH;
        s.items[index] = Item{ .key = key, .value = value };
    }

    /// I really know nothing about hashing functions. I found this site that
    ///
    /// Apparently the Fowler–Noll–Vo hash function is pretty simple to implement?
    /// Zig seems to have implemented one but I'll do things for fun here...
    ///
    /// I practically copied this whole function from Wikipedia
    ///
    /// https://en.wikipedia.org/wiki/Fowler%E2%80%93Noll%E2%80%93Vo_hash_function
    pub fn FNV1_hash(key: []const u8) u64 {
        var hash: u64 = 0xcbf29ce484222325;

        for (key) |k| {
            // I don't think there's a reason
            // to use @MulWithOverflow here
            // so I will just wrap it
            hash = hash *% 0x100000001b3;
            hash = hash ^ k;
        }

        return hash;
    }
};

test "Create HashMap and print items..." {
    var s = HashMap.init();

    HashMap.set(&s, "quick", "value");
    HashMap.set(&s, "fox", "value");
    HashMap.set(&s, "hello", "value");
    HashMap.set(&s, "world", "value");
    HashMap.set(&s, "git", "value");
    HashMap.set(&s, "linux", "value");
    HashMap.set(&s, "fedora", "value");
    HashMap.set(&s, "bsd", "value");
    HashMap.set(&s, "firefox", "value");
    HashMap.set(&s, "car", "value");
    HashMap.set(&s, "cat", "value");
    HashMap.set(&s, "keyboard", "value");
    HashMap.set(&s, "jira", "value");
    HashMap.set(&s, "audi", "value");
    HashMap.set(&s, "tree", "value");
    HashMap.set(&s, "bird", "value");

    for (0..s.items.len) |i| {
        std.debug.print("item: {}; {any}\n", .{ i, s.items[i] });
    }
}

test "run data through the Fowler hash function" {
    const s = "foo";

    const hash_result = HashMap.FNV1_hash(s);
    std.debug.print("result of hash: {any}\n", .{hash_result});
}
