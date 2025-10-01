from typing import Callable, Iterable, Optional, TypeVar, Generator, List

T = TypeVar("T")
U = TypeVar("U")


def find_and_apply(seq: Iterable[T], pred: Callable[[T], bool], func: Callable[[T], U]) -> Optional[U]:
    for x in seq:
        if pred(x):
            return func(x)
    return None


def successive_powers(*, base: int, limit: int) -> Generator[int, None, None]:
    value = 1
    while value <= limit:
        yield value
        value *= base


def count_valid_lines(filename: str) -> int:
    count = 0
    with open(filename, "r") as f:
        for line in f:
            stripped = line.strip()
            if stripped and not stripped.startswith("#"):
                count += 1
    return count


def say(word: str = ""):
    words: List[str] = []

    def inner(next_word: str = ""):
        nonlocal words
        if next_word == "":
            return " ".join(words)
        words.append(next_word)
        return inner

    if word:
        words.append(word)
    return inner


class Quaternion:
    __slots__ = ("a", "b", "c", "d")

    def __init__(self, a: float, b: float, c: float, d: float):
        object.__setattr__(self, "a", a)
        object.__setattr__(self, "b", b)
        object.__setattr__(self, "c", c)
        object.__setattr__(self, "d", d)

    def coefficients(self) -> List[float]:
        return [self.a, self.b, self.c, self.d]

    def conjugate(self) -> "Quaternion":
        return Quaternion(self.a, -self.b, -self.c, -self.d)

    def __add__(self, other: "Quaternion") -> "Quaternion":
        return Quaternion(self.a + other.a, self.b + other.b, self.c + other.c, self.d + other.d)

    def __mul__(self, other: "Quaternion") -> "Quaternion":
        a1, b1, c1, d1 = self.a, self.b, self.c, self.d
        a2, b2, c2, d2 = other.a, other.b, other.c, other.d
        return Quaternion(
            a1 * a2 - b1 * b2 - c1 * c2 - d1 * d2,
            a1 * b2 + b1 * a2 + c1 * d2 - d1 * c2,
            a1 * c2 - b1 * d2 + c1 * a2 + d1 * b2,
            a1 * d2 + b1 * c2 - c1 * b2 + d1 * a2,
        )

    def __eq__(self, other: object) -> bool:
        if not isinstance(other, Quaternion):
            return NotImplemented
        return self.coefficients() == other.coefficients()

    def __str__(self) -> str:
        return f"{self.a}+{self.b}i+{self.c}j+{self.d}k"

    def __setattr__(self, key, value):
        raise AttributeError("Quaternion objects are immutable")
