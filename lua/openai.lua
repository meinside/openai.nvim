-- lua/openai.lua
--
-- OpenAI plugin functions
--
-- last update: 2023.03.28.

-- constants
local userAgent = 'meinside/openai-nvim'
local defaultEditTextInstruction = 'Fix the grammar and spelling mistakes. Do not answer to it.'

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

-- edit given code
--
--  * `params`:
--
--   {
--     input = "some code to edit (optional)",
--     instruction = "your instruction here",
--     update_ui = false, -- when true, will replace or insert text in the UI
--   }
--
function M.edit_code(params)
  params = params or {}
  local input, instruction, update_ui = params.input, params.instruction, params.update_ui

  local start_row, start_col = 0, 0
  local end_row, end_col = 0, 0

  -- (1) visual block only => visual block will be `instruction`
  if not instruction then
    start_row, start_col, end_row, end_col = ui.get_selection()
    instruction = ui.get_text(start_row, start_col, end_row, end_col)

    if not instruction then
      ui.error('No visually selected instruction or function argument for text edit.')
      return nil
    end
  else
    if not input then
      -- (2) visual block + command argument => visual block will be `input`, and argument will be `instruction`
      start_row, start_col, end_row, end_col = ui.get_selection()
      input = ui.get_text(start_row, start_col, end_row, end_col)
    end
    -- (3) no visual block + command argument => argument will be `instruction`
  end

  local response, err = net.post('v1/edits', {
    model = config.options.models.editCode,
    instruction = instruction,
    input = input,
    user = userAgent,
  })

  local ret = nil
  if response then
    err = net.on_choice(response, function(choice)
      local output = choice.text or 'Text from OpenAI was empty.'

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

-- edit given text
--
--  * `params`:
--
--   {
--     input = "some text to edit",
--     instruction = "your instruction here (optional)",
--     update_ui = false, -- when true, will replace or insert text in the UI
--   }
--
function M.edit_text(params)
  params = params or {}
  local input, instruction, update_ui = params.input, params.instruction, params.update_ui

  local start_row, start_col = 0, 0
  local end_row, end_col = 0, 0

  -- (1) visual block only => visual block will be `input`
  if not input then
    start_row, start_col, end_row, end_col = ui.get_selection()
    input = ui.get_text(start_row, start_col, end_row, end_col)

    if not input then
      ui.error('No visually selected input or function argument for text edit.')
      return nil
    end
  else
    if not instruction then
      -- (2) visual block + command argument => visual block will be `input`, and argument will be `instruction`
      start_row, start_col, end_row, end_col = ui.get_selection()
      instruction = ui.get_text(start_row, start_col, end_row, end_col)

      if instruction then
        input, instruction = instruction, input
      end
    end
    -- (3) no visual block + command argument => argument will be `input`
  end

  local response, err = net.post('v1/edits', {
    model = config.options.models.editText,
    instruction = instruction or defaultEditTextInstruction,
    input = input,
    user = userAgent,
  })

  local ret = nil
  if response then
    err = net.on_choice(response, function(choice)
      local output = choice.text or 'Text from OpenAI was empty.'

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

-- list models
--
-- * `params`:
--
--   {
--     separator = '\n', -- (optional)
--     update_ui = false, -- when true, will display the result in the UI
--   }
--
function M.list_models(params)
  params = params or {}
  local separator = params.separator or '\n'
  local update_ui = params.update_ui

  local response, err = net.get('v1/models', nil)

  local ret = nil
  if response then
    err = net.on_models(response, function(results)
      local output = ''

      for _, result in ipairs(results) do
        output = output .. result.id ..  separator
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

  if not input then
    local start_row, start_col, end_row, end_col = ui.get_selection()
    input = ui.get_text(start_row, start_col, end_row, end_col)

    if not input then
      ui.error('No visually selected input or function argument for moderation.')
      return nil
    end
  end

  local response, err = net.post('v1/moderations', {
    model = config.options.models.moderation,
    input = input or ''
  })

  local ret = nil
  if response then
    err = net.on_moderation(response, function(result)
      if result.flagged then
        local categories, scores = result.categories, result.category_scores
        ret = 'Given input was flagged for:\n\n' .. vim.inspect(categories) .. '\n\n' .. vim.inspect(scores)
      else
        ret = 'Given input was not flagged.'
      end

      if update_ui then
        ui.info(ret)
      end
    end)
  end

  if err then
    ui.error(err)
  end

  return ret
end


-- export things
return M

