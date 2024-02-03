local M = {}

local function generate_unique_marker(selection)
  local tmp_marker = '__TMP__'
  while selection:find(tmp_marker) do
    tmp_marker = tmp_marker .. '_'
  end
  return tmp_marker
end

local function swap_words_in_text(text, word1, word2)
  local tmp_marker = generate_unique_marker(text)
  text = text:gsub(word1, tmp_marker)
  text = text:gsub(word2, word1)
  text = text:gsub(tmp_marker, word2)
  return text
end

function M.swap_words_in_selection(args)
  local start_row, end_row = args.line1, args.line2

  if start_row > end_row or start_row < 1 then
    return nil, "Invalid range. Ensure that the start line is before the end line and they exist."
  end

  local lines = vim.fn.getline(start_row, end_row)
  local selection = table.concat(lines, "\n")
  local words1, words2 = args.fargs[1], args.fargs[2]

  if not selection:find(words1) and not selection:find(words2) then
    print("Neither of the words to swap were found in the selection.")
    return
  end

  local swapped_text = swap_words_in_text(selection, words1, words2)
  local new_lines = vim.split(swapped_text, "\n")
  vim.fn.setline(start_row, new_lines)
end

vim.api.nvim_create_user_command(
  'SwapWords',
  function(args)
    if #args.fargs ~= 2 then
      print("SwapWords requires exactly 2 arguments. Example usage: :SwapWords word1 word2")
      return
    end
    M.swap_words_in_selection(args)
  end,
  { nargs = "*", range = true }
)

return M
