import java.io.File
import java.io.IOException
import kotlin.math.abs

fun firstThenLowerCase(strings: List<String>, satisfying: (String) -> Boolean): String? =
    strings.firstOrNull(satisfying)?.lowercase()

data class Say(private val words: List<String>) {
    fun and(word: String): Say = Say(words + word)
    val phrase: String
        get() = words.joinToString(" ")
}

fun say(): Say = Say(emptyList())
fun say(word: String): Say = Say(listOf(word))

@Throws(IOException::class)
fun meaningfulLineCount(filename: String): Long {
    val file = File(filename)
    file.bufferedReader().use { reader ->
        return reader
            .lineSequence()
            .filter { !isCommentLine(it) }
            .count()
            .toLong()
    }
}

private fun isCommentLine(line: String): Boolean {
    for (ch in line) {
        if (!ch.isWhitespace()) {
            return ch == '#'
        }
    }
    return false
}

data class Quaternion(val a: Double, val b: Double, val c: Double, val d: Double) {

    init {
        require(!a.isNaN() && !b.isNaN() && !c.isNaN() && !d.isNaN()) {
            "Coefficients cannot be NaN"
        }
    }

    fun coefficients(): List<Double> = listOf(a, b, c, d)

    fun conjugate(): Quaternion = Quaternion(a, -b, -c, -d)

    operator fun plus(other: Quaternion): Quaternion =
        Quaternion(
            a + other.a,
            b + other.b,
            c + other.c,
            d + other.d
        )

    operator fun times(other: Quaternion): Quaternion {
        val a1 = a
        val b1 = b
        val c1 = c
        val d1 = d
        val a2 = other.a
        val b2 = other.b
        val c2 = other.c
        val d2 = other.d

        return Quaternion(
            a1 * a2 - b1 * b2 - c1 * c2 - d1 * d2,
            a1 * b2 + b1 * a2 + c1 * d2 - d1 * c2,
            a1 * c2 - b1 * d2 + c1 * a2 + d1 * b2,
            a1 * d2 + b1 * c2 - c1 * b2 + d1 * a2
        )
    }

    override fun toString(): String {
        fun nonZero(x: Double) = abs(x) > 0.0

        if (!nonZero(a) && !nonZero(b) && !nonZero(c) && !nonZero(d)) {
            return "0"
        }

        val sb = StringBuilder()

        if (nonZero(a)) {
            sb.append(a.toString())
        }

        fun appendTerm(coeff: Double, symbol: String) {
            if (!nonZero(coeff)) return
            val first = sb.isEmpty()
            val mag = abs(coeff)
            val magStr = if (mag == 1.0) "" else mag.toString()
            if (first) {
                if (coeff < 0) {
                    sb.append("-").append(magStr).append(symbol)
                } else {
                    sb.append(magStr).append(symbol)
                }
            } else {
                val sign = if (coeff < 0) "-" else "+"
                sb.append(sign).append(magStr).append(symbol)
            }
        }

        appendTerm(b, "i")
        appendTerm(c, "j")
        appendTerm(d, "k")

        return sb.toString()
    }

    companion object {
        val ZERO = Quaternion(0.0, 0.0, 0.0, 0.0)
        val I = Quaternion(0.0, 1.0, 0.0, 0.0)
        val J = Quaternion(0.0, 0.0, 1.0, 0.0)
        val K = Quaternion(0.0, 0.0, 0.0, 1.0)
    }
}

sealed interface BinarySearchTree {
    fun size(): Int
    fun contains(v: String): Boolean
    fun insert(v: String): BinarySearchTree

    object Empty : BinarySearchTree {
        override fun size(): Int = 0

        override fun contains(v: String): Boolean = false

        override fun insert(v: String): BinarySearchTree =
            Node(Empty, v, Empty)

        override fun toString(): String = "()"
    }

    data class Node(
        val left: BinarySearchTree,
        val value: String,
        val right: BinarySearchTree
    ) : BinarySearchTree {

        override fun size(): Int = left.size() + 1 + right.size()

        override fun contains(v: String): Boolean {
            val cmp = v.compareTo(value)
            return when {
                cmp == 0 -> true
                cmp < 0  -> left.contains(v)
                else     -> right.contains(v)
            }
        }

        override fun insert(v: String): BinarySearchTree {
            val cmp = v.compareTo(value)
            return when {
                cmp == 0 -> this
                cmp < 0  -> Node(left.insert(v), value, right)
                else     -> Node(left, value, right.insert(v))
            }
        }

        override fun toString(): String {
            val leftStr = if (left === Empty) "" else left.toString()
            val rightStr = if (right === Empty) "" else right.toString()
            return "($leftStr$value$rightStr)"
        }
    }
}
