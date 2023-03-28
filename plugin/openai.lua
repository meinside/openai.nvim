-- plugin/openai.lua
--
-- OpenAI plugin for neovim
--
-- last update: 2023.03.28.

local openai = require'openai'

--------------------------------
-- create user commands
--

-- :OpenaiCompleteChat [prompt-text]
--
vim.api.nvim_create_user_command(
  'OpenaiCompleteChat',
  function(opts)
    local args = { update_ui = true }
    if #opts.fargs >= 1 then
      args.prompt = opts.fargs[1]
    end

    openai.complete_chat(args)
  end,
  { range = true, nargs = '?' }
)

-- :OpenaiEditCode [instruction-for-code]
--
--  > visual block only => visual block will be `instruction`
--  > visual block + command argument => visual block will be `input` (code), and argument will be `instruction`
--  > no visual block + command argument => argument will be `instruction`
--
vim.api.nvim_create_user_command(
  'OpenaiEditCode',
  function(opts)
    local args = { update_ui = true }
    if #opts.fargs >= 1 then
      args.instruction = opts.fargs[1]
    end

    openai.edit_code(args)
  end,
  { range = true, nargs = '?' }
)

-- :OpenaiEditText [text-to-fix-grammar-or-spelling]
--
--  > visual block only => visual block will be `input`
--  > visual block + command argument => visual block will be `input`, and argument will be `instruction`
--  > no visual block + command argument => argument will be `input`
--
vim.api.nvim_create_user_command(
  'OpenaiEditText',
  function(opts)
    local args = { update_ui = true }
    if #opts.fargs >= 1 then
      args.input = opts.fargs[1]
    end

    openai.edit_text(args)
  end,
  { range = true, nargs = '?' }
)

-- :OpenaiModels
--
vim.api.nvim_create_user_command(
  'OpenaiModels',
  function()
    local args = { update_ui = true }

    openai.list_models(args)
  end,
  { range = false, nargs = 0 }
)

-- :OpenaiModerate [input-text]
--
vim.api.nvim_create_user_command(
  'OpenaiModerate',
  function(opts)
    local args = { update_ui = true }
    if #opts.fargs >= 1 then
      args.input = opts.fargs[1]
    end

    openai.moderate(args)
  end,
  { range = true, nargs = '?' }
)

