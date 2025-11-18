first_then_apply = function(seq, pred, func)
  for _, x in ipairs(seq) do
    if pred(x) then
      return func(x)
    end
  end
  return nil
end

powers_generator = function(base, limit)
  return coroutine.create(function()
    local value = 1
    while value <= limit do
      coroutine.yield(value)
      value = value * base
    end
  end)
end

say = function(word)
  if word == nil then
    return ""
  end
  local words = { word }
  local function inner(nextWord)
    if nextWord == nil then
      return table.concat(words, " ")
    end
    table.insert(words, nextWord)
    return inner
  end
  return inner
end

meaningful_line_count = function(filename)
  local file, err = io.open(filename, "r")
  if not file then
    error(err, 2)
  end

  local lines = {}
  for line in file:lines() do
    table.insert(lines, line)
  end
  file:close()

  local count = 0
  for _, line in ipairs(lines) do
    local stripped = line:gsub("^%s*", "")
    if not stripped:match("^#") then
      count = count + 1
    end
  end

  local n = #lines
  if n > 0 then
    local last = lines[n]
    local trimmed_last = last:match("^%s*(.-)%s*$")
    local stripped_last = last:gsub("^%s*", "")
    if trimmed_last == "" and not stripped_last:match("^#") then
      count = count - 1
    end
  end

  return count
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

local function is_nonzero(x)
  return math.abs(x) > 0
end

local function num_to_str(x)
  if x == math.floor(x) then
    return string.format("%.1f", x)
  else
    return tostring(x)
  end
end

function Quaternion:__tostring()
  local a, b, c, d = self.a, self.b, self.c, self.d

  if not (is_nonzero(a) or is_nonzero(b) or is_nonzero(c) or is_nonzero(d)) then
    return "0"
  end

  local parts = {}

  if is_nonzero(a) then
    table.insert(parts, num_to_str(a))
  end

  local function add(coeff, sym)
    if not is_nonzero(coeff) then
      return
    end
    local first = (#parts == 0)
    local sign = coeff < 0 and "-" or "+"
    local mag = math.abs(coeff)
    local mag_str = mag == 1 and "" or num_to_str(mag)

    if first then
      if coeff < 0 then
        table.insert(parts, "-" .. mag_str .. sym)
      else
        table.insert(parts, mag_str .. sym)
      end
    else
      table.insert(parts, sign .. mag_str .. sym)
    end
  end

  add(b, "i")
  add(c, "j")
  add(d, "k")

  return table.concat(parts)
end
