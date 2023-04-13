-- lua/openai/fs.lua
--
-- last update: 2023.04.13.

-- dependencies
local path = require'plenary/path'

-- plugin modules
local config = require'openai/config'

local M = {}

-- read and return openai api credentials
function M.openai_credentials()
  local f = io.open(path:new(config.options.credentialsFilepath):expand(), 'r')

  if f ~= nil then
    local str = f:read('*a')
    io.close(f)
    local parsed = vim.json.decode(str)

    if parsed.api_key and parsed.org_id then
      return parsed.api_key, parsed.org_id
    end
  end

  return nil, nil
end

return M

