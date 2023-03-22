-- plugin/openai.lua
--
-- OpenAI plugin for neovim
--
-- last update: 2023.03.22.

-- create user commands
vim.api.nvim_create_user_command(
  'OpenaiCodex',
  function()
    require'openai'.edit_code()
  end,
  { range = true, nargs = 0 }
)
vim.api.nvim_create_user_command(
  'OpenaiComplete',
  function()
    require'openai'.complete_chat()
  end,
  { range = true, nargs = 0 }
)

