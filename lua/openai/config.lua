-- lua/openai/config.lua

local Config = {}

-- default configuration
Config.options = {
  credentialsFilepath = '~/.config/openai-nvim.json',
  models = {
    editCode = 'code-davinci-edit-001',
    completeChat = 'gpt-3.5-turbo',
  },
}

-- override configurations
function Config.override(opts)
  opts = opts or {}

  Config.options = vim.tbl_deep_extend('force', {}, Config.options, opts)
end

return Config

