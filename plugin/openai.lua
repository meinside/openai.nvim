-- plugin/openai.lua
--
-- OpenAI plugin for neovim
--
-- last update: 2023.03.24.

--------------------------------
-- create user commands
--

-- :OpenaiCompleteChat [prompt-text]
--
vim.api.nvim_create_user_command(
  'OpenaiCompleteChat',
  function(opts)
    local args = {}
    if #opts.fargs >= 1 then
      args.prompt = opts.fargs[1]
    end
    args.update_ui = true

    require'openai'.complete_chat(args)
  end,
  { range = true, nargs = '?' }
)

-- :OpenaiModels
--
vim.api.nvim_create_user_command(
  'OpenaiModels',
  function()
    local args = {
      update_ui = true,
    }

    require'openai'.list_models(args)
  end,
  { range = false, nargs = 0 }
)

-- :OpenaiModerate [input-text]
--
vim.api.nvim_create_user_command(
  'OpenaiModerate',
  function(opts)
    local args = {}
    if #opts.fargs >= 1 then
      args.input = opts.fargs[1]
    end
    args.update_ui = true

    require'openai'.moderate(args)
  end,
  { range = true, nargs = '?' }
)

