import Foundation

func firstThenLowerCase(of strings: [String], satisfying predicate: (String) -> Bool) -> String? {
    strings.first(where: predicate)?.lowercased()
}

struct Say {
    private let words: [String]

    func and(_ word: String) -> Say {
        Say(words: words + [word])
    }

    var phrase: String {
        words.joined(separator: " ")
    }

    init(words: [String]) {
        self.words = words
    }
}

func say() -> Say {
    Say(words: [])
}

func say(_ word: String) -> Say {
    Say(words: [word])
}

func meaningfulLineCount(_ path: String) async -> Result<Int, Error> {
    let url = URL(fileURLWithPath: path)
    do {
        let handle = try FileHandle(forReadingFrom: url)
        var count = 0
        defer { try? handle.close() }
        for try await line in handle.bytes.lines {
            if !line.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                count += 1
            }
        }
        return .success(count)
    } catch {
        return .failure(error)
    }
}

struct Quaternion: Equatable, CustomStringConvertible {
    let a: Double
    let b: Double
    let c: Double
    let d: Double

    init(a: Double = 0, b: Double = 0, c: Double = 0, d: Double = 0) {
        self.a = a
        self.b = b
        self.c = c
        self.d = d
    }

    var coefficients: [Double] {
        [a, b, c, d]
    }

    var conjugate: Quaternion {
        Quaternion(a: a, b: -b, c: -c, d: -d)
    }

    static let ZERO = Quaternion(a: 0, b: 0, c: 0, d: 0)
    static let I = Quaternion(a: 0, b: 1, c: 0, d: 0)
    static let J = Quaternion(a: 0, b: 0, c: 1, d: 0)
    static let K = Quaternion(a: 0, b: 0, c: 0, d: 1)

    static func + (lhs: Quaternion, rhs: Quaternion) -> Quaternion {
        Quaternion(
            a: lhs.a + rhs.a,
            b: lhs.b + rhs.b,
            c: lhs.c + rhs.c,
            d: lhs.d + rhs.d
        )
    }

    static func * (lhs: Quaternion, rhs: Quaternion) -> Quaternion {
        let a1 = lhs.a, b1 = lhs.b, c1 = lhs.c, d1 = lhs.d
        let a2 = rhs.a, b2 = rhs.b, c2 = rhs.c, d2 = rhs.d
        return Quaternion(
            a: a1 * a2 - b1 * b2 - c1 * c2 - d1 * d2,
            b: a1 * b2 + b1 * a2 + c1 * d2 - d1 * c2,
            c: a1 * c2 - b1 * d2 + c1 * a2 + d1 * b2,
            d: a1 * d2 + b1 * c2 - c1 * b2 + d1 * a2
        )
    }

    var description: String {
        func nonZero(_ x: Double) -> Bool { abs(x) > 0.0 }

        if !nonZero(a) && !nonZero(b) && !nonZero(c) && !nonZero(d) {
            return "0"
        }

        var s = ""

        if nonZero(a) {
            s.append(String(a))
        }

        func appendTerm(_ coeff: Double, _ symbol: String) {
            if !nonZero(coeff) { return }
            let first = s.isEmpty
            let mag = abs(coeff)
            let magStr = mag == 1.0 ? "" : String(mag)
            if first {
                if coeff < 0 {
                    s.append("-" + magStr + symbol)
                } else {
                    s.append(magStr + symbol)
                }
            } else {
                let sign = coeff < 0 ? "-" : "+"
                s.append(sign + magStr + symbol)
            }
        }

        appendTerm(b, "i")
        appendTerm(c, "j")
        appendTerm(d, "k")

        return s
    }
}

indirect enum BinarySearchTree {
    case empty
    case node(left: BinarySearchTree, value: String, right: BinarySearchTree)

    var size: Int {
        switch self {
        case .empty:
            return 0
        case let .node(left, _, right):
            return left.size + 1 + right.size
        }
    }

    func contains(_ v: String) -> Bool {
        switch self {
        case .empty:
            return false
        case let .node(left, value, right):
            if v == value { return true }
            if v < value { return left.contains(v) }
            return right.contains(v)
        }
    }

    func insert(_ v: String) -> BinarySearchTree {
        switch self {
        case .empty:
            return .node(left: .empty, value: v, right: .empty)
        case let .node(left, value, right):
            if v == value { return self }
            if v < value {
                return .node(left: left.insert(v), value: value, right: right)
            } else {
                return .node(left: left, value: value, right: right.insert(v))
            }
        }
    }
}

extension BinarySearchTree: CustomStringConvertible {
    var description: String {
        switch self {
        case .empty:
            return "()"
        case let .node(left, value, right):
            let leftStr: String = {
                if case .empty = left { return "" }
                return left.description
            }()
            let rightStr: String = {
                if case .empty = right { return "" }
                return right.description
            }()
            return "(\(leftStr)\(value)\(rightStr))"
        }
    }
}
