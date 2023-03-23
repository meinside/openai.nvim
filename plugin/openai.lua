-- plugin/openai.lua
--
-- OpenAI plugin for neovim
--
-- last update: 2023.03.23.

-- create user commands

-- :OpenaiEdit [text-to-fix-grammar-and-spelling]
--
vim.api.nvim_create_user_command(
  'OpenaiEdit',
  function(opts)
    local args = {}
    if #opts.fargs >= 1 then
      args.input = opts.fargs[1]
    end
    args.update_ui = true

    require'openai'.edit(args)
  end,
  { range = true, nargs = '?' }
)

-- :OpenaiCodex [instruction-of-code-generation]
--
vim.api.nvim_create_user_command(
  'OpenaiCodex',
  function(opts)
    local args = {}
    if #opts.fargs >= 1 then
      args.instruction = opts.fargs[1]
    end
    args.update_ui = true

    require'openai'.edit_code(args)
  end,
  { range = true, nargs = '?' }
)

-- :OpenaiComplete [prompt-text]
--
vim.api.nvim_create_user_command(
  'OpenaiComplete',
  function(opts)
    local args = {}
    if #opts.fargs >= 1 then
      args.input = opts.fargs[1]
    end
    args.update_ui = true

    require'openai'.complete_chat(args)
  end,
  { range = true, nargs = '?' }
)

