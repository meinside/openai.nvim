-- lua/openai/util.lua
--
-- last update: 2023.03.23.

local Util = {}

-- split string with delimiters
--
-- https://stackoverflow.com/questions/19262761/lua-need-to-split-at-comma
function Util.split(source, delimiters)
  local elements = {}
  local pattern = '([^'..delimiters..']+)'
  _ = string.gsub(source, pattern, function(value)
    elements[#elements + 1] = value
  end)
  return elements
end

return Util

