-- lua/openai.lua
--
-- OpenAI plugin functions
--
-- last update: 2023.03.23.

-- constants
local userAgent = 'meinside/openai-nvim'
local defaultEditInstruction = 'Fix the grammar and spelling mistakes. Do not answer to it.'

-- plugin modules
local ui = require'openai/ui'
local net = require'openai/net'
local config = require'openai/config'

local M = {}

-- setup function for configuration
function M.setup(opts)
  config.override(opts)
end

-- edit given text
--
-- * `params`:
--
--   {
--     input = "some text to edit",
--     instruction = "your instruction here (optional)",
--     return_only = false, -- when true, will not replace or insert text on API responses
--   }
--
-- NOTE: default value of `params.instruction` = 'Fix the grammar and spelling mistakes.'
function M.edit(params)
  params = params or {}
  local input, instruction = params.input, params.instruction

  local start_row, start_col = 0, 0
  local end_row, end_col = 0, 0

  if not input then
    start_row, start_col, end_row, end_col = ui.get_selection()
    input = ui.get_text(start_row, start_col, end_row, end_col)

    if not input then
      ui.error('No visually selected text or function argument for editing.')
      return nil
    end
  end

  local response, err = net.post('v1/edits', {
    model = config.options.models.edit,
    instruction = instruction or defaultEditInstruction,
    input = input,
    user = userAgent,
  })

  local ret = nil
  if response then
    err = net.on_choice(response, function(choice)
      local output = choice.text or 'Text from OpenAI was empty.'

      if not params.return_only then
        if ui.is_valid_range(start_row, start_col, end_row, end_col) then
          ui.replace_text(start_row, start_col, end_row, end_col, output)
          ui.exit_visual_mode()
        else
          ui.insert_text_at_current_cursor(output)
        end
      end

      ret = output
    end)
  end

  if err then
    ui.error(err)
  end

  return ret
end

-- edit given code text with codex
--
-- * `params`:
--
--   {
--     instruction = "your instruction here",
--     input = "some code to edit (optional)",
--     return_only = false, -- when true, will not replace or insert text on API responses
--   }
--
-- NOTE: default value of `params.input` = ''
function M.edit_code(params)
  params = params or {}
  local input = params.input
  local instruction = params.instruction

  local start_row, start_col = 0, 0
  local end_row, end_col = 0, 0

  if not instruction then
    start_row, start_col, end_row, end_col = ui.get_selection()
    instruction = ui.get_text(start_row, start_col, end_row, end_col)

    if not instruction then
      ui.error('No visually selected code text or function argument for editing.')
      return nil
    end
  end

  local response, err = net.post('v1/edits', {
    model = config.options.models.editCode,
    instruction = instruction,
    input = input or '',
    user = userAgent,
  })

  local ret = nil
  if response then
    err = net.on_choice(response, function(choice)
      local output = choice.text or 'Text from OpenAI was empty.'

      if not params.return_only then
        if ui.is_valid_range(start_row, start_col, end_row, end_col) then
          ui.replace_text(start_row, start_col, end_row, end_col, output)
          ui.exit_visual_mode()
        else
          ui.insert_text_at_current_cursor(output)
        end
      end

      ret = output
    end)
  end

  if err then
    ui.error(err)
  end

  return ret
end

-- complete given chat text
--
-- * `params`:
--
--   {
--     input = "your prompt here (optional)",
--     return_only = false, -- when true, will not replace or insert text on API responses
--   }
--
function M.complete_chat(params)
  params = params or {}
  local input = params.input

  local start_row, start_col = 0, 0
  local end_row, end_col = 0, 0

  if not input then
    start_row, start_col, end_row, end_col = ui.get_selection()
    input = ui.get_text(start_row, start_col, end_row, end_col)

    if not input then
      ui.error('No visually selected prompt or function argument for completion.')
      return nil
    end
  end

  local response, err = net.post('v1/chat/completions', {
    model = config.options.models.completeChat,
    messages = { { role = 'user', content = input } },
    user = userAgent,
  })

  local ret = nil
  if response then
    err = net.on_choice(response, function(choice)
      local output = choice.message.content or 'Message content from OpenAI was empty.'

      if not params.return_only then
        if ui.is_valid_range(start_row, start_col, end_row, end_col) then
          ui.replace_text(start_row, start_col, end_row, end_col, output)
          ui.exit_visual_mode()
        else
          ui.insert_text_at_current_cursor(output)
        end
      end

      ret = output
    end)
  end

  if err then
    ui.error(err)
  end

  return ret
end


-- export things
return M

