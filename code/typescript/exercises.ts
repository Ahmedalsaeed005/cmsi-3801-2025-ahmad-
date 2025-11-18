import { readFile } from "node:fs/promises";

export function firstThenApply<A, B>(
  xs: ReadonlyArray<A>,
  p: (a: A) => boolean,
  f: (a: A) => B
): B | undefined {
  const hit = xs.find(p);
  return hit === undefined ? undefined : f(hit);
}

export function* powers(base: bigint): Generator<bigint, void, void> {
  let v = 1n;
  while (true) {
    yield v;
    v *= base;
  }
}

export async function countValidLines(path: string): Promise<number> {
  const text = await readFile(path, { encoding: "utf8" });
  let lines = text.split(/\r?\n/);
  if (lines.length > 0 && lines[lines.length - 1] === "") {
    lines.pop();
  }

  let count = 0;
  for (const line of lines) {
    const trimmed = line.trim();
    if (trimmed.startsWith("#")) continue;
    count += 1;
  }

  return count;
}

export type Box = Readonly<{ kind: "box"; w: number; h: number; d: number }>;
export type Sphere = Readonly<{ kind: "sphere"; r: number }>;
export type Shape = Box | Sphere;

export function box(w: number, h: number, d: number): Shape {
  return Object.freeze({ kind: "box", w, h, d } as const);
}

export function sphere(r: number): Shape {
  return Object.freeze({ kind: "sphere", r } as const);
}

export function surfaceArea(s: Shape): number {
  switch (s.kind) {
    case "box":
      return 2 * (s.w * s.h + s.w * s.d + s.h * s.d);
    case "sphere":
      return 4 * Math.PI * s.r * s.r;
  }
}

export function volume(s: Shape): number {
  switch (s.kind) {
    case "box":
      return s.w * s.h * s.d;
    case "sphere":
      return (4 / 3) * Math.PI * s.r * s.r * s.r;
  }
}

export function showShape(s: Shape): string {
  return s.kind === "box" ? `Box(${s.w},${s.h},${s.d})` : `Sphere(${s.r})`;
}

export function equalShape(a: Shape, b: Shape): boolean {
  if (a.kind !== b.kind) return false;
  return a.kind === "box"
    ? a.w === (b as Box).w && a.h === (b as Box).h && a.d === (b as Box).d
    : a.r === (b as Sphere).r;
}

export type Comparator<T> = (a: T, b: T) => number;

export interface BST<T> extends Iterable<T> {
  readonly size: number;
  has(x: T): boolean;
  insert(x: T): BST<T>;
  inorder(): Iterable<T>;
  toString(): string;
}

type Ord = number | string | bigint | Date;

function isOrd(x: unknown): x is Ord {
  return (
    typeof x === "number" ||
    typeof x === "string" ||
    typeof x === "bigint" ||
    x instanceof Date
  );
}

function defaultComparator<T>(a: T, b: T): number {
  if (isOrd(a) && isOrd(b)) {
    return a < b ? -1 : a > b ? 1 : 0;
  }
  throw new TypeError(
    "Default comparator supports number|string|bigint|Date. Provide a custom comparator."
  );
}

export function emptyBST<T>(cmp?: Comparator<T>): BST<T> {
  return new EmptyImpl<T>(cmp ?? (defaultComparator as Comparator<T>));
}

class EmptyImpl<T> implements BST<T> {
  readonly #cmp: Comparator<T>;

  constructor(cmp: Comparator<T>) {
    this.#cmp = cmp;
    Object.freeze(this);
  }

  get size(): number {
    return 0;
  }

  has(_x: T): boolean {
    return false;
  }

  insert(x: T): BST<T> {
    return new NodeImpl<T>(this.#cmp, this, x, this);
  }

  *inorder(): Iterable<T> {}

  [Symbol.iterator](): Iterator<T> {
    return this.inorder()[Symbol.iterator]();
  }

  toString(): string {
    return "()";
  }
}

class NodeImpl<T> implements BST<T> {
  readonly #cmp: Comparator<T>;
  readonly #left: BST<T>;
  readonly #right: BST<T>;
  readonly #value: T;

  constructor(cmp: Comparator<T>, left: BST<T>, value: T, right: BST<T>) {
    this.#cmp = cmp;
    this.#left = left;
    this.#right = right;
    this.#value = value;
    Object.freeze(this);
  }

  get size(): number {
    return this.#left.size + 1 + this.#right.size;
  }

  has(x: T): boolean {
    const k = this.#cmp(x, this.#value);
    if (k === 0) return true;
    return k < 0 ? this.#left.has(x) : this.#right.has(x);
  }

  insert(x: T): BST<T> {
    const k = this.#cmp(x, this.#value);
    if (k === 0) return this;
    if (k < 0) {
      return new NodeImpl(this.#cmp, this.#left.insert(x), this.#value, this.#right);
    }
    return new NodeImpl(this.#cmp, this.#left, this.#value, this.#right.insert(x));
  }

  *inorder(): Iterable<T> {
    yield* this.#left;
    yield this.#value;
    yield* this.#right;
  }

  [Symbol.iterator](): Iterator<T> {
    return this.inorder()[Symbol.iterator]();
  }

  toString(): string {
    const leftStr = this.#left instanceof EmptyImpl ? "" : this.#left.toString();
    const rightStr = this.#right instanceof EmptyImpl ? "" : this.#right.toString();
    return `(${leftStr}${String(this.#value)}${rightStr})`;
  }
}
