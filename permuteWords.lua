local list = require('permuteWordsList')

function split(s, delimiter)
  local result = {};
  for match in (s..delimiter):gmatch("(.-)"..delimiter) do
    table.insert(result, match);
  end
  return result;
end

local dictionary = {}

local file = io.open('/usr/share/dict/words')

for line in file:lines() do
  dictionary[line:upper()] = true
end

local text = 'In the beginning the Universe was created This had made many people very angry and has been widely regarded as a bad move'
local thing = text:upper()
if thing then

  dictionary = {}
  local splitArray = split(thing, ' ')
  for _, v in pairs(splitArray) do
    dictionary[v] = true
  end
end

local query = {
  box = 4, -- 1 is top of sheet
  x =     'a', -- across
  x_end = 'f',
  -- y =      2, -- from top 1-5
  direction = 'across'
}

local startSet = {
  }

local endSet = {
  }

local logLetters = true

query.len = query.x_end:byte() - (query.x):byte() + 1
query.x = query.x:byte() - ('a'):byte() + 1
print(query.len)
-- print(('m'):byte() - ('a'):byte() + 1)

local function getLettersFrom(boxIndex, x)
  local o = ''
  local box = list[boxIndex == 0 and 7 or boxIndex]
  for i = 1, 5 do
    if box[i][x] then
      o = o .. box[i][x]
    end
  end
  return o
end

local function makeUnique(letters)
  local t = {}
  for i in letters:gmatch('.') do
    t[i] = true
  end
  local o = ''

  for k, _ in pairs(t) do
    if k ~= ' ' then
      o = o .. k
    end
  end
  return o
end

local letterSet = {}
-- hack in stuff here lol
-- and add to the len below
for _, v in ipairs(startSet) do
  table.insert(letterSet, v)
end

for i = 1, query.len do
  local x = query.x + i - 1
  local letters = getLettersFrom(query.box, x) .. getLettersFrom(query.box - 1, x)
  table.insert(letterSet, makeUnique(letters))
  if logLetters then print(makeUnique(letters)) end
end

print('starting point:', letterSet[1])
for _, v in ipairs(endSet) do
  table.insert(letterSet, v)
end

-- hack in stuff here lol
-- table.insert(letterSet, 'ECLTSOH')
query.len = query.len + #startSet + #endSet

local recurse
local answer = ''
recurse = function(v, depth)
  if depth > query.len then
    if dictionary[v] then
      answer = answer .. ' ' .. v
    end
  else
    for i in (letterSet[depth]):gmatch('.') do
      recurse(v .. i, depth + 1)
    end
  end
end

recurse('', 1)

print(answer)
