import { readFileSync } from "node:fs";

function firstThenApply(strings, predicate, func) {
  for (const x of strings) {
    if (predicate(x)) {
      return func(x);
    }
  }
}

function say(firstWord) {
  if (firstWord === undefined) {
    return "";
  }

  const words = [firstWord];

  function inner(nextWord) {
    if (nextWord === undefined) {
      return words.join(" ");
    }
    words.push(nextWord);
    return inner;
  }

  return inner;
}

function* powersGenerator({ ofBase, upTo }) {
  let value = 1;
  while (value <= upTo) {
    yield value;
    value *= ofBase;
  }
}

function meaningfulLineCount(filename) {
  const text = readFileSync(filename, "utf-8");
  let lines = text.split(/\r?\n/);
  if (lines.length > 0 && lines[lines.length - 1] === "") {
    lines.pop();
  }

  let count = 0;
  for (const line of lines) {
    const trimmed = line.trim();
    if (trimmed.startsWith("#")) {
      continue;
    }
    count += 1;
  }

  if (lines.length > 0) {
    const last = lines[lines.length - 1];
    const trimmedLast = last.trim();
    if (trimmedLast === "" && !trimmedLast.startsWith("#")) {
      count -= 1;
    }
  }

  return count;
}

class Quaternion {
  constructor(a, b, c, d) {
    this.a = a;
    this.b = b;
    this.c = c;
    this.d = d;
    Object.freeze(this);
  }

  get coefficients() {
    return [this.a, this.b, this.c, this.d];
  }

  get conjugate() {
    return new Quaternion(this.a, -this.b, -this.c, -this.d);
  }

  plus(other) {
    return new Quaternion(
      this.a + other.a,
      this.b + other.b,
      this.c + other.c,
      this.d + other.d
    );
  }

  times(other) {
    const { a: a1, b: b1, c: c1, d: d1 } = this;
    const { a: a2, b: b2, c: c2, d: d2 } = other;
    return new Quaternion(
      a1 * a2 - b1 * b2 - c1 * c2 - d1 * d2,
      a1 * b2 + b1 * a2 + c1 * d2 - d1 * c2,
      a1 * c2 - b1 * d2 + c1 * a2 + d1 * b2,
      a1 * d2 + b1 * c2 - c1 * b2 + d1 * a2
    );
  }

  toString() {
    const a = this.a;
    const b = this.b;
    const c = this.c;
    const d = this.d;

    const nz = (x) => Math.abs(x) > 0;

    if (!nz(a) && !nz(b) && !nz(c) && !nz(d)) {
      return "0";
    }

    const parts = [];

    if (nz(a)) {
      parts.push(String(a));
    }

    const add = (coeff, sym) => {
      if (!nz(coeff)) return;
      const first = parts.length === 0;
      const sign = coeff < 0 ? "-" : "+";
      const mag = Math.abs(coeff);
      const magStr = mag === 1 ? "" : String(mag);

      if (first) {
        if (coeff < 0) {
          parts.push(`-${magStr}${sym}`);
        } else {
          parts.push(`${magStr}${sym}`);
        }
      } else {
        parts.push(`${sign}${magStr}${sym}`);
      }
    };

    add(b, "i");
    add(c, "j");
    add(d, "k");

    return parts.join("");
  }
}

export { firstThenApply, say, powersGenerator, meaningfulLineCount, Quaternion };
