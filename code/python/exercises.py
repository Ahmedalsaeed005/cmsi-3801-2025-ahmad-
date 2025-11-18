from typing import Callable, Iterable, Optional, TypeVar, Generator, List

T = TypeVar("T")
U = TypeVar("U")


def first_then_apply(
    strings: Iterable[T],
    predicate: Callable[[T], bool],
    function: Callable[[T], U],
) -> Optional[U]:
    for x in strings:
        if predicate(x):
            return function(x)
    return None


def say(word: str | None = None):
    if word is None:
        return ""

    words: List[str] = [word]

    def inner(next_word: str | None = None):
        nonlocal words
        if next_word is None:
            return " ".join(words)
        words.append(next_word)
        return inner

    return inner


def powers_generator(*, base: int, limit: int) -> Generator[int, None, None]:
    value = 1
    while value <= limit:
        yield value
        value *= base


def meaningful_line_count(filename: str) -> int:
    with open(filename, "r", encoding="utf-8") as f:
        lines = f.readlines()

    count = 0
    for line in lines:
        if line.lstrip().startswith("#"):
            continue
        count += 1

    if lines:
        last = lines[-1]
        if last.strip() == "" and not last.lstrip().startswith("#"):
            count -= 1

    return count


class Quaternion:
    __slots__ = ("a", "b", "c", "d")

    def __init__(
        self,
        a: float = 0.0,
        b: float = 0.0,
        c: float = 0.0,
        d: float = 0.0,
    ):
        self.a = float(a)
        self.b = float(b)
        self.c = float(c)
        self.d = float(d)

    @property
    def coefficients(self) -> tuple[float, float, float, float]:
        return (self.a, self.b, self.c, self.d)

    @property
    def conjugate(self) -> "Quaternion":
        return Quaternion(self.a, -self.b, -self.c, -self.d)

    def __add__(self, other: "Quaternion") -> "Quaternion":
        return Quaternion(
            self.a + other.a,
            self.b + other.b,
            self.c + other.c,
            self.d + other.d,
        )

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
        return self.coefficients == other.coefficients

    def __str__(self) -> str:
        a, b, c, d = self.a, self.b, self.c, self.d

        def nz(x: float) -> bool:
            return abs(x) > 0.0

        if not any(nz(x) for x in (a, b, c, d)):
            return "0"

        parts: List[str] = []

        if nz(a):
            parts.append(str(a))

        def add(coeff: float, sym: str):
            if not nz(coeff):
                return
            first = len(parts) == 0
            sign = "-" if coeff < 0 else "+"
            mag = abs(coeff)
            m = "" if mag == 1.0 else str(mag)
            if first:
                if coeff < 0:
                    parts.append(f"-{m}{sym}")
                else:
                    parts.append(f"{m}{sym}")
            else:
                parts.append(f"{sign}{m}{sym}")

        add(b, "i")
        add(c, "j")
        add(d, "k")

        return "".join(parts)
