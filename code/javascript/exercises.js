
function findAndApply(seq, pred, func) {
  for (const x of seq) {
    if (pred(x)) {
      return func(x);
    }
  }
  return null;
}


function* successivePowers({ base, limit }) {
  let value = 1;
  while (value <= limit) {
    yield value;
    value *= base;
  }
}


import fs from "fs";

function countValidLines(filename) {
  const content = fs.readFileSync(filename, "utf-8").split("\n");
  return content.filter(
    (line) => line.trim() !== "" && !line.trim().startsWith("#")
  ).length;
}


function say(word) {
  const words = [];
  function inner(nextWord) {
    if (nextWord === undefined) {
      return words.join(" ");
    }
    words.push(nextWord);
    return inner;
  }
  if (word !== undefined) {
    words.push(word);
  }
  return inner;
}


class Quaternion {
  constructor(a, b, c, d) {
    this.a = a;
    this.b = b;
    this.c = c;
    this.d = d;
    Object.freeze(this); 
  }

  coefficients() {
    return [this.a, this.b, this.c, this.d];
  }

  conjugate() {
    return new Quaternion(this.a, -this.b, -this.c, -this.d);
  }

  add(other) {
    return new Quaternion(
      this.a + other.a,
      this.b + other.b,
      this.c + other.c,
      this.d + other.d
    );
  }

  multiply(other) {
    const { a: a1, b: b1, c: c1, d: d1 } = this;
    const { a: a2, b: b2, c: c2, d: d2 } = other;
    return new Quaternion(
      a1 * a2 - b1 * b2 - c1 * c2 - d1 * d2,
      a1 * b2 + b1 * a2 + c1 * d2 - d1 * c2,
      a1 * c2 - b1 * d2 + c1 * a2 + d1 * b2,
      a1 * d2 + b1 * c2 - c1 * b2 + d1 * a2
    );
  }

  equals(other) {
    return (
      this.a === other.a &&
      this.b === other.b &&
      this.c === other.c &&
      this.d === other.d
    );
  }

  toString() {
    return `${this.a}+${this.b}i+${this.c}j+${this.d}k`;
  }
}

export {
  findAndApply,
  successivePowers,
  countValidLines,
  say,
  Quaternion,
};
