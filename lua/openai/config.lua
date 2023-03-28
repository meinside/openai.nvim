-- lua/openai/config.lua
--
-- last update: 2023.03.28.

local Config = {}

-- default configuration
Config.options = {
  credentialsFilepath = '~/.config/openai-nvim.json',
  models = {
    completeChat = 'gpt-3.5-turbo',
    editCode = 'code-davinci-edit-001',
    editText = 'text-davinci-edit-001',
    moderation = 'text-moderation-latest',
  },
}

-- override configurations
function Config.override(opts)
  opts = opts or {}

  Config.options = vim.tbl_deep_extend('force', {}, Config.options, opts)
end

return Config

