local M = {}
M.config = require "spotlight.config"

function M.setup(opts)
  M.config = vim.tbl_deep_extend("force", M.config.default, opts or {})

  local core = require "spotlight.core"
  core.run(M.config)
end
return M
