-- lua/openai/fs.lua


local M = {}

-- constants
M.ConfigFilepath = '.config/openai-nvim.json'

-- read and return openai api credentials
function M.openai_credentials()
  local f = io.open(M.ConfigFilepath, 'r')
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

