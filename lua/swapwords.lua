local M = {}

function M.swap_words_in_selection(args)
  local start_row = args.line1
  local end_row = args.line2

  local lines = vim.fn.getline(start_row, end_row)
  local selection = table.concat(lines, "\n")
  local words1 = args.fargs[1]
  local words2 = args.fargs[2]

  local tmp_marker = '__TMP__'
  while selection:find(tmp_marker) do
    tmp_marker = tmp_marker .. '_'
  end

  selection = selection:gsub(words1, tmp_marker)
  selection = selection:gsub(words2, words1)
  selection = selection:gsub(tmp_marker, words2)

  lines = vim.split(selection, "\n")
  vim.fn.setline(start_row, lines)
end

vim.api.nvim_create_user_command(
  'SwapWords',
  function(args)
    if #args.fargs ~= 2 then
      print("SwapWords requires exactly 2 arguments.")
      return
    end
    M.swap_words_in_selection(args)
  end,
  { nargs = "*", range = true }
)

return M
