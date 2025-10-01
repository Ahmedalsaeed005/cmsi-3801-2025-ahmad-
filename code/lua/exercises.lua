
function find_and_apply(seq, pred, func)
  for _, x in ipairs(seq) do
    if pred(x) then
      return func(x)
    end
  end
  return nil
end


function successive_powers(base, limit)
  return coroutine.wrap(function()
    local value = 1
    while value <= limit do
      coroutine.yield(value)
      value = value * base
    end
  end)
end


function count_valid_lines(filename)
  local file = io.open(filename, "r")
  if not file then return 0 end

  local count = 0
  for line in file:lines() do
    local trimmed = line:match("^%s*(.-)%s*$") -- trim spaces
    if trimmed ~= "" and not trimmed:match("^#") then
      count = count + 1
    end
  end

  file:close()
  return count
end


function say(word)
  local words = {}
  local function inner(nextWord)
    if nextWord == nil then
      return table.concat(words, " ")
    else
      table.insert(words, nextWord)
      return inner
    end
  end
  if word ~= nil then
    table.insert(words, word)
  end
  return inner
end


Quaternion = {}
Quaternion.__index = Quaternion

function Quaternion.new(a, b, c, d)
  local self = setmetatable({}, Quaternion)
  self.a = a
  self.b = b
  self.c = c
  self.d = d
  return self
end

function Quaternion:coefficients()
  return { self.a, self.b, self.c, self.d }
end

function Quaternion:conjugate()
  return Quaternion.new(self.a, -self.b, -self.c, -self.d)
end

function Quaternion.__add(q1, q2)
  return Quaternion.new(
    q1.a + q2.a,
    q1.b + q2.b,
    q1.c + q2.c,
    q1.d + q2.d
  )
end

function Quaternion.__mul(q1, q2)
  local a1, b1, c1, d1 = q1.a, q1.b, q1.c, q1.d
  local a2, b2, c2, d2 = q2.a, q2.b, q2.c, q2.d
  return Quaternion.new(
    a1 * a2 - b1 * b2 - c1 * c2 - d1 * d2,
    a1 * b2 + b1 * a2 + c1 * d2 - d1 * c2,
    a1 * c2 - b1 * d2 + c1 * a2 + d1 * b2,
    a1 * d2 + b1 * c2 - c1 * b2 + d1 * a2
  )
end

function Quaternion.__eq(q1, q2)
  return q1.a == q2.a and q1.b == q2.b and q1.c == q2.c and q1.d == q2.d
end

function Quaternion:__tostring()
  return string.format("%g+%gi+%gj+%gk", self.a, self.b, self.c, self.d)
end
