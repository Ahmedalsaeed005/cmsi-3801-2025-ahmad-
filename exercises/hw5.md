# Homework 5 

---

## 1. Explain the meaning of each of the following C declarations.

for example let `n` be some integer constant or macro.

### `double *a[n];`
An array of `n` pointers to `double`.

### `double (*b)[n];`
A pointer to an array of `n` doubles.

### `double (*c[n])();`
An array of `n` pointers to functions returning `double`.

### `double (*d())[n];`
A function returning a pointer to an array of `n` doubles.

---

## 2. In C, when exactly do arrays decay to pointers?

An array expression is converted (“decays”) to a pointer to its first element in almost all value-expression contexts, **except** when:

 It is the operand of `sizeof`.

In the function parameter lists, an array parameters are also adjusted to pointer types.

---

## 3. Give a short description, under 10 words each, of the following, as they are understood in the context of the C language: (a) memory leak, (b) dangling pointer, (c) double free, (d) buffer overflow, (e) stack overflow, (f) wild pointer.

- **Memory leak:** A memory leak is when memory is created but never let go and no pointer is left. .  
- **Dangling pointer:** A pointer to memory that has been freed or is in that case not usable.  
- **Double free:** Calling it free more than once on same allocation.  
- **Buffer overflow:** means writing to more memory than was assigned 
- **Stack overflow:** means that there is more call stack room than is available at runtime.  
- **Wild pointer:**if it has a  Not yet started or corrupted pointer with unpredictable target..

---

## 4. Explain why C++ move constructors and move assignment operators only make sense on r-values and not l-values. You can use a rough code fragment in your explanation.

Move constructors and move assignment operators are designed to **steal resources** (e.g., heap-allocated buffers) from a source object and leave that source in a valid but “empty” or reduced state. This only makes sense for **r-values**, not for **l-values** named objects that will continue to be used.

Typical pattern:

```cpp
class Buffer {
public:
    Buffer(Buffer&& other) noexcept      // move constructor
        : data(other.data), size(other.size) {
        other.data = nullptr;            // steal the resource
        other.size = 0;
    }

    Buffer& operator=(Buffer&& other) noexcept { // move assignment
        if (this != &other) {
            delete[] data;
            data = other.data;
            size = other.size;
            other.data = nullptr;
            other.size = 0;
        }
        return *this;
    }

private:
    char* data;
    std::size_t size;
};




## 5. Why does C++ even have moves, anyway?
- to avaoid any unnecessary deep copies of heavy objects like strings ,buffers nad file handels .
- to express the transfer of an ownership explicitly in the type system .

## 6.What is the rule-of-5 in C++?
1.Destructor .
2.Copy constructor .
3.Copy assignment operator .
4.Move constructor .
5.Move assignment operator .

## 7.What are the three ownership rules of Rust?
1. each one of he rules has 1 owner .
2.whe the owner is out of the image the value therefor is dropped .
3. the owner ship can be moved but not copied and unless there is type implements.

## 8.What are the three borrowing rules of Rust?
1. at anytime you can have any number with a immutable reference or it can have exacly one mutable refrence.
2.References must always point to a valid number.
3.There can only be one changeable reference to a value at a time. Other references cannot be used to access that value.