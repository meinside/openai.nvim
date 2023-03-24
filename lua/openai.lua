-- lua/openai.lua
--
-- OpenAI plugin functions
--
-- last update: 2023.03.24.

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

-- complete given chat text
--
-- * `params`:
--
--   {
--     prompt = "your prompt here",
--     update_ui = false, -- when true, will replace or insert text in the UI
--   }
--
function M.complete_chat(params)
  params = params or {}
  local prompt, update_ui = params.prompt, params.update_ui

  local start_row, start_col = 0, 0
  local end_row, end_col = 0, 0

  if not prompt then
    start_row, start_col, end_row, end_col = ui.get_selection()
    prompt = ui.get_text(start_row, start_col, end_row, end_col)

    if not prompt then
      ui.error('No visually selected prompt or function argument for chat completion.')
      return nil
    end
  end

  local response, err = net.post('v1/chat/completions', {
    model = config.options.models.completeChat,
    messages = { { role = 'user', content = prompt } },
    user = userAgent,
  })

  local ret = nil
  if response then
    err = net.on_choice(response, function(choice)
      local output = choice.message.content or 'Message content from OpenAI was empty.'

      if update_ui then
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

-- moderate given input
--
-- * `params`:
--
--   {
--     input = "your input text for moderation",
--     update_ui = false, -- when true, will display the result in the UI
--   }
--
function M.moderate(params)
  params = params or {}
  local input, update_ui = params.input, params.update_ui

  local response, err = net.post('v1/moderations', {
    model = config.options.models.moderation,
    input = input or ''
  })

  local ret = nil
  if response then
    err = net.on_moderation(response, function(result)
      local output = nil

      if result.flagged then
        local categories, scores = result.categories, result.scores
        output = 'Given input was flagged for:\n\n' .. vim.inspect(categories) .. '\n\n' .. vim.inspect(scores)
      else
        output = 'Given input was not flagged.'
      end

      if update_ui then
        ui.info(output)
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

