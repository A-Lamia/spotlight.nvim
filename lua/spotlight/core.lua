local M = {
  is_floating = false,
  cur_win = 0,
}

local function _is_floating(win_id)
  local valid_win, config = pcall(vim.api.nvim_win_get_config, win_id)
  return valid_win and (config.relative == "editor") or (config.relative == "win") or false
end

function M.run(opts)
  vim.api.nvim_create_augroup("spotlight", {})

  vim.api.nvim_create_autocmd("ColorScheme", {
    group = "spotlight",
    callback = function()
    end,
  })
  vim.api.nvim_create_autocmd({ "WinEnter" }, {
    group = "spotlight",
    callback = function()
      M.on_window_enter(opts)
    end,
  })
end

function M.on_window_enter(opts)
  local cur_win = vim.api.nvim_get_current_win()
  local win_id_list = vim.api.nvim_list_wins()
  local is_floating = _is_floating(cur_win)

  if is_floating then
    M.apply_hl(cur_win, win_id_list, opts)

    M.is_floating = is_floating
    M.cur_win = cur_win
  else
    M.restore_hl(win_id_list, opts)
  end
end

function M.apply_hl(cur_win, win_id_list, opts)
  for _, win_id in ipairs(win_id_list) do
    if _is_floating(win_id) then
      vim.api.nvim_set_option_value(
        "winhl",
        table.concat(opts.replaced_hl.float, ","),
        { win = win_id }
      )

    else
      vim.api.nvim_set_option_value(
        "winhl",
        table.concat(opts.replaced_hl.window, ","),
        { win = win_id }
      )
    end
  end
end

function M.restore_hl(win_id_list, opts)
  local restored = vim.list_extend(opts.restored_hl.float, opts.restored_hl.window)
  if M.is_floating then
    for _, win_id in ipairs(win_id_list) do
      if win_id ~= M.cur_win then
        vim.api.nvim_set_option_value("winhl", table.concat(restored, ","), { win = win_id })
      end
    end
  end
end

return M
