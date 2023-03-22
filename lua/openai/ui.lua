-- lua/openai/ui.lua

-- plugin modules
local util = require'openai/util'

local M = {}

-- show error notification
function M.error(str)
  vim.notify(str, vim.log.levels.ERROR)
end

-- check if given range is valid or not
function M.is_valid_range(start_row, start_col, end_row, end_col)
  return not ((start_row == 0 and start_col == 0) or (end_row == 0 and end_col == 0))
end

-- get selected range from visual block
function M.get_selection()
    local start_row, start_col = unpack(vim.api.nvim_buf_get_mark(0, '<'))
    local end_row, end_col = unpack(vim.api.nvim_buf_get_mark(0, '>'))

    return start_row, start_col, end_row, end_col
end

-- get text from range
function M.get_text(start_row, start_col, end_row, end_col)
  local n_lines = math.abs(end_row - start_row) + 1
  local lines = vim.api.nvim_buf_get_lines(0, start_row - 1, end_row, false)

  if #lines <= 0 then
    return nil
  else
    lines[1] = string.sub(lines[1], start_col, -1)
    if n_lines == 1 then
      lines[n_lines] = string.sub(lines[n_lines], 1, end_col - start_col + 1)
    else
      lines[n_lines] = string.sub(lines[n_lines], 1, end_col)
    end
    return table.concat(lines, '\n')
  end
end

-- clear and replace text at given range
function M.replace_text(start_row, start_col, end_row, end_col, text)
  vim.api.nvim_buf_set_text(0, start_row - 1, start_col, end_row - 1, end_col, {})
  vim.api.nvim_buf_set_text(0, start_row - 1, start_col, start_row - 1, start_col, { unpack(util.split(text, '\n')) })
end

-- exit visual mode
-- NOTE: XXX: not working as my intention - selected visual block is not cleared
function M.exit_visual_mode()
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<esc>', true, false, true), 'x', false)
  vim.api.nvim_feedkeys('gv', 'x', false)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<esc>', true, false, true), 'x', false)
end

return M

