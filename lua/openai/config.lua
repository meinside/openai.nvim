-- lua/openai/config.lua

local Config = {}

-- default configuration
Config.options = {
  credentialsFilepath = '.config/openai-nvim.json',
  models = {
    --editCode = 'code-davinci-edit-001',
    --completeChat = 'gpt-3.5-turbo',
    editCode = 'xxxx',
    completeChat = 'yyyy',
  },
}

-- setup configuration
function Config.setup(opts)
  opts = opts or {}

  Config.options = vim.tbl_deep_extend('force', {}, Config.options, opts)
end

return Config

