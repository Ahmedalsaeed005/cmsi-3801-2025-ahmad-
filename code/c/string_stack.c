#include <stdlib.h>
#include <string.h>
#include <stdbool.h>
#include "string_stack.h"

#define INITIAL_CAPACITY 16

struct _Stack {
    char **elements;
    int capacity;
    int size;
};

static bool grow_if_needed(struct _Stack *s) {
    if (s->size < s->capacity) return true;
    if (s->capacity >= MAX_CAPACITY) return false;

    int new_cap = s->capacity * 2;
    if (new_cap > MAX_CAPACITY) new_cap = MAX_CAPACITY;

    char **new_arr = realloc(s->elements, sizeof(char*) * new_cap);
    if (!new_arr) return false;

    s->elements = new_arr;
    s->capacity = new_cap;
    return true;
}

static void shrink_if_needed(struct _Stack *s) {
    if (s->capacity <= INITIAL_CAPACITY) return;
    if (s->size > s->capacity / 4) return;

    int new_cap = s->capacity / 2;
    if (new_cap < INITIAL_CAPACITY) new_cap = INITIAL_CAPACITY;

    char **new_arr = realloc(s->elements, sizeof(char*) * new_cap);
    if (!new_arr) return;

    s->elements = new_arr;
    s->capacity = new_cap;
}

stack_response create(void) {
    stack_response r;

    struct _Stack *s = malloc(sizeof(struct _Stack));
    if (!s) {
        r.code = out_of_memory;
        r.stack = NULL;
        return r;
    }

    s->elements = malloc(sizeof(char*) * INITIAL_CAPACITY);
    if (!s->elements) {
        free(s);
        r.code = out_of_memory;
        r.stack = NULL;
        return r;
    }

    s->capacity = INITIAL_CAPACITY;
    s->size = 0;

    r.code = success;
    r.stack = s;
    return r;
}

int size(const stack s) {
    return s ? s->size : 0;
}

bool is_empty(const stack s) {
    return !s || s->size == 0;
}

bool is_full(const stack s) {
    return s && s->size == MAX_CAPACITY;
}

response_code push(stack s, char *item) {
    if (!s || !item) return out_of_memory;

    size_t len = strlen(item);
    if (len >= MAX_ELEMENT_BYTE_SIZE) return stack_element_too_large;

    if (s->size == MAX_CAPACITY) return stack_full;

    if (!grow_if_needed(s)) return out_of_memory;

    char *copy = malloc(len + 1);
    if (!copy) return out_of_memory;
    memcpy(copy, item, len + 1);

    s->elements[s->size++] = copy;

    return success;
}

string_response pop(stack s) {
    string_response r;

    if (!s || s->size == 0) {
        r.code = stack_empty;
        r.string = NULL;
        return r;
    }

    char *stored = s->elements[s->size - 1];
    s->size--;

    shrink_if_needed(s);

    size_t len = strlen(stored);
    char *out = malloc(len + 1);
    if (!out) {
        free(stored);
        r.code = out_of_memory;
        r.string = NULL;
        return r;
    }

    memcpy(out, stored, len + 1);
    free(stored);

    r.code = success;
    r.string = out;
    return r;
}

void destroy(stack *ps) {
    if (!ps || !*ps) return;

    struct _Stack *s = *ps;

    for (int i = 0; i < s->size; i++) {
        free(s->elements[i]);
    }

    free(s->elements);
    free(s);

    *ps = NULL;
}
