import { describe, it } from "node:test";
import { deepEqual, rejects } from "node:assert/strict";
import {
  firstThenApply,
  powers,
  countValidLines,
  box,
  sphere,
  surfaceArea,
  volume,
  emptyBST,
} from "./exercises.js";

describe("firstThenApply", () => {
  const nonEmpty = (s: string) => s !== "";
  const lengthGT3 = (s: string) => s.length > 3;
  const lower = (s: string) => s.toLowerCase();
  const square = (n: number) => n * n;

  it("works on strings and numbers", () => {
    deepEqual(firstThenApply([], nonEmpty, lower), undefined);
    deepEqual(firstThenApply(["", "A", "B"], nonEmpty, lower), "a");
    deepEqual(firstThenApply(["", "A", "ABC"], lengthGT3, lower), undefined);
    deepEqual(firstThenApply(["ABC", "ABCD", "ABCDE"], lengthGT3, lower), "abcd");
    deepEqual(firstThenApply([1, 2, 3], (n) => n > 1, square), 4);
    deepEqual(firstThenApply([1, 2, 3], (n) => n > 3, square), undefined);
  });
});

describe("powers (BigInt generator)", () => {
  it("yields successive powers", () => {
    const g1 = powers(2n);
    deepEqual(g1.next(), { value: 1n, done: false });
    deepEqual(g1.next(), { value: 2n, done: false });
    for (let i = 0; i < 98; i++) g1.next();
    deepEqual(g1.next(), { value: 1267650600228229401496703205376n, done: false });

    const g2 = powers(3n);
    deepEqual(g2.next(), { value: 1n, done: false });
    deepEqual(g2.next(), { value: 3n, done: false });
    deepEqual(g2.next(), { value: 9n, done: false });
    deepEqual(g2.next(), { value: 27n, done: false });
    deepEqual(g2.next(), { value: 81n, done: false });
  });
});

describe("countValidLines", () => {
  it("rejects for missing file", async () => {
    await rejects(countValidLines("NoSuchFile.txt"));
  });
  it("counts a known file", async () => {
    const n = await countValidLines("../../test-data/test-for-line-count.txt");
    deepEqual(n, 5);
  });
});

describe("shapes", () => {
  it("volume and surface area", () => {
    const s = sphere(5);
    const b = box(3, 4, 5);
    deepEqual(volume(s), 523.5987755982989);
    deepEqual(volume(b), 60);
    deepEqual(surfaceArea(s), 314.1592653589793);
    deepEqual(surfaceArea(b), 94);
  });
});

describe("BST (emptyBST factory)", () => {
  it("insert/has/inorder/immutability", () => {
    let t = emptyBST<string>();
    deepEqual(t.size, 0);
    deepEqual(t.has("A"), false);

    t = t.insert("G").insert("B").insert("D").insert("H").insert("A").insert("C").insert("J");
    deepEqual(t.size, 7);
    deepEqual(t.has("J"), true);
    deepEqual(t.has("Z"), false);
    deepEqual([...t.inorder()], ["A", "B", "C", "D", "G", "H", "J"]);

    const t2 = t.insert("F");
    deepEqual(t2.size, 8);
    deepEqual(t.size, 7);
  });
});
