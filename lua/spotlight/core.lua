local M = {}

M.is_floating = false
M.cur_win = 0

M.user_hl = {}

local function _is_floating(win_id)
  local valid_win, config = pcall(vim.api.nvim_win_get_config, win_id)
  return valid_win and (config.relative == "editor") or (config.relative == "win") or false
end

function M.run(opts)
  vim.api.nvim_create_augroup("spotlight", {})

  vim.api.nvim_create_autocmd("ColorScheme", {
    group = "spotlight",
    callback = function()
      M.user_hl.LazyNormal = vim.api.nvim_get_hl(0, { name = "LazyNormal" })
      M.user_hl.MasonNormal = vim.api.nvim_get_hl(0, { name = "MasonNormal" })

      -- M.user_hl.TelescopePreviewBorder = vim.api.nvim_get_hl(0, { name = "TelescopePreviewBorder" })
      -- M.user_hl.TelescopeResultsBorder = vim.api.nvim_get_hl(0, { name = "TelescopeResultsBorder" })
      --
      -- M.user_hl.TelescopePreviewNormal = vim.api.nvim_get_hl(0, { name = "TelescopePreviewNormal" })
      -- M.user_hl.TelescopeResultsNormal = vim.api.nvim_get_hl(0, { name = "TelescopeResultsNormal" })
      --
      -- M.user_hl.TelescopePreviewTitle = vim.api.nvim_get_hl(0, { name = "TelescopePreviewTitle" })
      -- M.user_hl.TelescopeResultsTitle = vim.api.nvim_get_hl(0, { name = "TelescopeResultsTitle" })
    end,
  })

  vim.api.nvim_create_autocmd({ "WinEnter" }, {
    group = "spotlight",
    callback = function()
      local cur_win = vim.api.nvim_get_current_win()
      local win_id_list = vim.api.nvim_list_wins()
      local is_floating = _is_floating(cur_win)

      if is_floating then
        M.set(cur_win, win_id_list)
        M.is_floating = is_floating
      else
        M.restore(win_id_list)
      end
    end,
  })
end

function M.set(cur_win, win_id_list)
  for _, win_id in ipairs(win_id_list) do
    if _is_floating(win_id) then
      vim.api.nvim_set_option_value(
        "winhl",
        table.concat({
          "NormalFloat:SpotlightNormal",
          "FloatBorder:SpotlightBorder",
          "FloatTitle:SpotlightTitle",
        }, ","),
        -- { scope = "global", win = win_id }
        { win = win_id }
      )

      vim.api.nvim_set_hl(0, "LazyNormal", { link = "SpotlightNormal" })
      vim.api.nvim_set_hl(0, "MasonNormal", { link = "SpotlightNormal" })
    else
      vim.api.nvim_set_option_value(
        "winhl",
        table.concat({
          "Normal:SpotlightNormalNC",
          "WinSeparator:SpotlightWinSeparator",
          "CursorLine:SpotlightCursorLine",
        }, ","),
        { win = win_id }
      )
    end
  end
  M.cur_win = cur_win
  M.data = { true, win_id_list }
end

function M.restore(win_id_list)
  if M.is_floating then
    for _, win_id in ipairs(win_id_list) do
      if win_id ~= M.cur_win then
        vim.api.nvim_set_option_value(
          "winhl",
          table.concat({
            "Normal:Normal",
            "WinSeparator:WinSeparator",
            "CursorLine:CursorLine",
          }, ","),
          { win = win_id }
        )

        vim.api.nvim_set_option_value(
          "winhl",
          table.concat({
            "NormalFloat:NormalFloat",
            "FloatBorder:FloatBorder",
            "FloatTitle:Title",
          }, ","),
          { win = win_id }
        )

        vim.api.nvim_set_hl(0, "LazyNormal", M.user_hl.LazyNormal)
        vim.api.nvim_set_hl(0, "MasonNormal", M.user_hl.MasonNormal)
      end
    end
  end
end

return M
