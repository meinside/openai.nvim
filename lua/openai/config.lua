-- lua/openai/config.lua
--
-- last update: 2023.04.13.

local M = {}

-- default configuration
M.options = {
  credentialsFilepath = '~/.config/openai-nvim.json',
  models = {
    completeChat = 'gpt-3.5-turbo',
    editCode = 'code-davinci-edit-001',
    editText = 'text-davinci-edit-001',
    moderation = 'text-moderation-latest',
  },
  timeout = 60 * 1000, -- will timeout in 60 seconds
}

-- override configurations
function M.override(opts)
  opts = opts or {}

  M.options = vim.tbl_deep_extend('force', {}, M.options, opts)
end

return M

