import java.io.BufferedReader;
import java.io.FileReader;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.function.Predicate;
import java.util.stream.Stream;

public final class Exercises {

    private Exercises() {
    }

    // ---------------------------------------------------------------------
    // firstThenLowerCase
    // ---------------------------------------------------------------------
    public static Optional<String> firstThenLowerCase(
            List<String> strings,
            Predicate<String> predicate
    ) {
        return strings.stream()
                .filter(predicate)
                .findFirst()
                .map(String::toLowerCase);
    }

    // ---------------------------------------------------------------------
    // say(...) -> Say object with .and(...) and .phrase()
    // ---------------------------------------------------------------------
    public static final class Say {
        private final List<String> words;

        private Say(List<String> words) {
            this.words = List.copyOf(words);
        }

        public Say and(String word) {
            List<String> next = new ArrayList<>(words.size() + 1);
            next.addAll(words);
            next.add(word);
            return new Say(next);
        }

        public String phrase() {
            return String.join(" ", words);
        }
    }

    public static Say say() {
        return new Say(List.of());
    }

    public static Say say(String firstWord) {
        return new Say(List.of(firstWord));
    }

    // ---------------------------------------------------------------------
    // meaningfulLineCount
    // ---------------------------------------------------------------------
    public static int meaningfulLineCount(String filename) throws IOException {
        try (BufferedReader reader = new BufferedReader(new FileReader(filename))) {
            Stream<String> lines = reader.lines();
            long count = lines.filter(line -> !isCommentLine(line)).count();
            return (int) count;
        } catch (FileNotFoundException e) {
            // Let FileNotFoundException propagate so the test sees it
            throw e;
        }
    }

    // A "comment line" is one whose first non-whitespace char is '#'
    private static boolean isCommentLine(String line) {
        int i = 0;
        while (i < line.length() && Character.isWhitespace(line.charAt(i))) {
            i++;
        }
        if (i < line.length() && line.charAt(i) == '#') {
            return true;
        }
        return false;
    }
}

// =====================================================================
// Quaternion (record, immutable, with ZERO/I/J/K, plus/times/conjugate/toString)
// =====================================================================

record Quaternion(double a, double b, double c, double d) {

    static final Quaternion ZERO = new Quaternion(0.0, 0.0, 0.0, 0.0);
    static final Quaternion I    = new Quaternion(0.0, 1.0, 0.0, 0.0);
    static final Quaternion J    = new Quaternion(0.0, 0.0, 1.0, 0.0);
    static final Quaternion K    = new Quaternion(0.0, 0.0, 0.0, 1.0);

    Quaternion {
        if (Double.isNaN(a) || Double.isNaN(b) || Double.isNaN(c) || Double.isNaN(d)) {
            throw new IllegalArgumentException("Coefficients cannot be NaN");
        }
    }

    List<Double> coefficients() {
        return List.of(a, b, c, d);
    }

    Quaternion conjugate() {
        return new Quaternion(a, -b, -c, -d);
    }

    Quaternion plus(Quaternion other) {
        return new Quaternion(
                this.a + other.a,
                this.b + other.b,
                this.c + other.c,
                this.d + other.d
        );
    }

    Quaternion times(Quaternion other) {
        double a1 = this.a;
        double b1 = this.b;
        double c1 = this.c;
        double d1 = this.d;
        double a2 = other.a;
        double b2 = other.b;
        double c2 = other.c;
        double d2 = other.d;

        return new Quaternion(
                a1 * a2 - b1 * b2 - c1 * c2 - d1 * d2,
                a1 * b2 + b1 * a2 + c1 * d2 - d1 * c2,
                a1 * c2 - b1 * d2 + c1 * a2 + d1 * b2,
                a1 * d2 + b1 * c2 - c1 * b2 + d1 * a2
        );
    }

    private static boolean nonZero(double x) {
        return Math.abs(x) > 0.0;
    }

    @Override
    public String toString() {
        double a = this.a;
        double b = this.b;
        double c = this.c;
        double d = this.d;

        if (!nonZero(a) && !nonZero(b) && !nonZero(c) && !nonZero(d)) {
            return "0";
        }

        StringBuilder sb = new StringBuilder();

        if (nonZero(a)) {
            sb.append(Double.toString(a));
        }

        appendTerm(sb, b, "i");
        appendTerm(sb, c, "j");
        appendTerm(sb, d, "k");

        return sb.toString();
    }

    private static void appendTerm(StringBuilder sb, double coeff, String symbol) {
        if (!nonZero(coeff)) {
            return;
        }
        boolean first = sb.length() == 0;
        double mag = Math.abs(coeff);
        String magStr = (mag == 1.0) ? "" : Double.toString(mag);

        if (first) {
            if (coeff < 0) {
                sb.append("-").append(magStr).append(symbol);
            } else {
                sb.append(magStr).append(symbol);
            }
        } else {
            String sign = coeff < 0 ? "-" : "+";
            sb.append(sign).append(magStr).append(symbol);
        }
    }
}

// =====================================================================
// BinarySearchTree (sealed interface + Empty + Node)
// =====================================================================

sealed interface BinarySearchTree permits Empty, Node {
    int size();
    boolean contains(String value);
    BinarySearchTree insert(String value);
}

final class Empty implements BinarySearchTree {

    Empty() {
    }

    @Override
    public int size() {
        return 0;
    }

    @Override
    public boolean contains(String value) {
        return false;
    }

    @Override
    public BinarySearchTree insert(String value) {
        return new Node(new Empty(), value, new Empty());
    }

    @Override
    public String toString() {
        return "()";
    }
}

final class Node implements BinarySearchTree {

    private final BinarySearchTree left;
    private final String value;
    private final BinarySearchTree right;

    Node(BinarySearchTree left, String value, BinarySearchTree right) {
        this.left = left;
        this.value = value;
        this.right = right;
    }

    @Override
    public int size() {
        return left.size() + 1 + right.size();
    }

    @Override
    public boolean contains(String v) {
        int cmp = v.compareTo(value);
        if (cmp == 0) {
            return true;
        } else if (cmp < 0) {
            return left.contains(v);
        } else {
            return right.contains(v);
        }
    }

    @Override
    public BinarySearchTree insert(String v) {
        int cmp = v.compareTo(value);
        if (cmp == 0) {
            return this;
        } else if (cmp < 0) {
            return new Node(left.insert(v), value, right);
        } else {
            return new Node(left, value, right.insert(v));
        }
    }

    @Override
    public String toString() {
        String leftStr = (left instanceof Empty) ? "" : left.toString();
        String rightStr = (right instanceof Empty) ? "" : right.toString();
        return "(" + leftStr + value + rightStr + ")";
    }
}
