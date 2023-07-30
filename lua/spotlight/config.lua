local M = {}

M.default = {}
  replaced_hl = {
    float = {
      "NormalFloat:SpotlightNormal",
      "FloatBorder:SpotlightBorder",
      "FloatTitle:SpotlightTitle",
    },
    window = {
      "Normal:SpotlightNormalNC",
      "WinSeparator:SpotlightWinSeparator",
      "CursorLine:SpotlightCursorLine",
    },
  },
  restored_hl = {
    float = {
      "Normal:Normal",
      "WinSeparator:WinSeparator",
      "CursorLine:CursorLine",
    },
    window = {
      "NormalFloat:NormalFloat",
      "FloatBorder:FloatBorder",
      "FloatTitle:Title",
    },
  },
}

return M
