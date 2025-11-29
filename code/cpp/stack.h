#ifndef STACK_H
#define STACK_H

#include <stdexcept>
#include <string>
#include <memory>

#define MAX_CAPACITY 32768
#define INITIAL_CAPACITY 16

using std::unique_ptr;

template <typename T>
class Stack {
    unique_ptr<T[]> elements;
    int capacity;
    int top;

    Stack(const Stack&) = delete;
    Stack& operator=(const Stack&) = delete;
    Stack(Stack&&) = delete;
    Stack& operator=(Stack&&) = delete;

public:
    Stack()
        : elements(new T[INITIAL_CAPACITY]),
          capacity(INITIAL_CAPACITY),
          top(0) {}

    int size() const {
        return top;
    }

    bool is_empty() const {
        return top == 0;
    }

    bool is_full() const {
        return top == MAX_CAPACITY;
    }

    void push(const T& value) {
        if (is_full()) {
            throw std::overflow_error("Stack has reached maximum capacity");
        }

        if (top == capacity) {
            int new_cap = capacity * 2;
            if (new_cap > MAX_CAPACITY) new_cap = MAX_CAPACITY;
            reallocate(new_cap);
        }

        elements[top++] = value;
    }

    T pop() {
        if (is_empty()) {
            throw std::underflow_error("cannot pop from empty stack");
        }

        T value = elements[--top];

        if (capacity > INITIAL_CAPACITY && top <= capacity / 4) {
            int new_cap = capacity / 2;
            if (new_cap < INITIAL_CAPACITY) new_cap = INITIAL_CAPACITY;
            if (new_cap != capacity) reallocate(new_cap);
        }

        return value;
    }

private:
    void reallocate(int new_capacity) {
        unique_ptr<T[]> new_elements(new T[new_capacity]);
        for (int i = 0; i < top; i++) {
            new_elements[i] = elements[i];
        }
        elements.swap(new_elements);
        capacity = new_capacity;
    }
};

#endif
