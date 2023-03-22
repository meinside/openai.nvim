-- lua/openai.lua
--
-- OpenAI plugin functions
--
-- last update: 2023.03.22.

-- constants
local userAgent = 'meinside/openai-nvim'

-- plugin modules
local ui = require'openai/ui'
local net = require'openai/net'
local config = require'openai/config'

local M = {}

-- setup function for configuration
function M.setup(opts)
  config.override(opts)
end

-- edit given code text with codex
function M.edit_code(text)
  local start_row, start_col = 0, 0
  local end_row, end_col = 0, 0

  if not text then
    start_row, start_col, end_row, end_col = ui.get_selection()
    text = ui.get_text(start_row, start_col, end_row, end_col)

    if not text then
      ui.error('No visually selected code text for editing.')
      return nil
    end
  end

  local response, err = net.post('v1/edits', {
    model = config.options.models.editCode,
    instruction = text,
    user = userAgent,
  })

  if response then
    err = net.on_choice(response, function(choice)
      local output = choice.text or 'Text from OpenAI was empty.'

      if ui.is_valid_range(start_row, start_col, end_row, end_col) then
        ui.replace_text(start_row, start_col, end_row, end_col, output)

        ui.exit_visual_mode()
      end

      return output
    end)
  end

  if err then
    ui.error(err)
  end

  ui.exit_visual_mode()

  return nil
end

-- complete given chat text
function M.complete_chat(text)
  local start_row, start_col = 0, 0
  local end_row, end_col = 0, 0

  if not text then
    start_row, start_col, end_row, end_col = ui.get_selection()
    text = ui.get_text(start_row, start_col, end_row, end_col)

    if not text then
      ui.error('No visually selected prompt for completion.')
      return nil
    end
  end

  local response, err = net.post('v1/chat/completions', {
    model = config.options.models.completeChat,
    messages = { { role = 'user', content = text } },
    user = userAgent,
  })

  if response then
    err = net.on_choice(response, function(choice)
      local output = choice.message.content or 'Message content from OpenAI was empty.'

      if ui.is_valid_range(start_row, start_col, end_row, end_col) then
        ui.replace_text(start_row, start_col, end_row, end_col, output)

        ui.exit_visual_mode()
      end

      return output
    end)
  end

  if err then
    ui.error(err)
  end

  ui.exit_visual_mode()

  return nil
end


-- export things
return M

