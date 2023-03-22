-- lua/openai/util.lua

local M = {}

-- split string with delimiters
--
-- https://stackoverflow.com/questions/19262761/lua-need-to-split-at-comma
function M.split(source, delimiters)
  local elements = {}
  local pattern = '([^'..delimiters..']+)'
  _ = string.gsub(source, pattern, function(value)
    elements[#elements + 1] = value
  end)
  return elements
end

return M

