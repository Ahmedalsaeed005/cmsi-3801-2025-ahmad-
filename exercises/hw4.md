- 1
a) abstract
b) enum
c) final
d) sealed 

- 2
1.classes are reference types and structs are value types.
2.classes support inheritance and structs do not.
3.Classes can use deinitializers and structs cannot.
4.Classes are allocated on the heap and structs are usually stored on the stack.

- 3
Swift does not have traditional null references. Instead, it uses optionals
Example:
var name: String? = nil 

- 4
No, you should not allow a List<Dog> to be assigned to a List<Animal> variable. If this were allowed, someone could later insert a different kind of Animal (like a Cat) into that list, which would break the fact that the list is supposed to contain only Dog objects. To keep type safety, a list of a subclass should not be treated as a list of its superclass.

- 5
The name "void" in Swift is strange because "void" usually means "no type," but in Swift it's a unit type that's just an alias for the empty tuple.  Apple says this is because a lot of workers come from C/Objective-C, where "void" means "no meaningful return value."  Although Swift's base type is actually, it keeps the familiar name to make it easier to read.

- 6
A supplier is something that takes no arguments and returns a value.
() -> T

- 7
Yegor Bugayenko didn't agree with Alan Kay's claim that he felt bad about using the word "object."  Bugayenko says that "object" is the right word for software design, but Kay afterward said that the word took attention away from his main idea of message.  At the design level, he says, we pay more attention to how pieces fit together than to what they say to each other, and things work better as building blocks.  He also says that messages makes more sense at the design level, where modules are used instead of single items.

- 8
Class-based OOP uses classes as blueprints, and objects are created as instances of those classes. In contrast, prototype-based OOP has no classes—objects are created by copying or extending an existing object (a prototype), and inheritance happens directly between objects rather than through a class hierarchy.

- 9 
A Java record makes a lot of things for you naturally, like private final fields for each component, a default constructor to set them up, accessor methods for each component, and standard versions of the equals(), hashCode(), and toString().

- 10
Methods,Static fields 