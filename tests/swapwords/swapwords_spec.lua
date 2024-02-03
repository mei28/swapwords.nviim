local your_plugin = require('swapwords')
local eq = assert.are.same

describe('swap_words', function()
  -- swap_wordsのテスト前に一度だけ実行される
  before_each(function()
    -- 必要に応じて初期化処理
  end)

  it('swaps two words in a single line', function()
    -- 1行にある2つの単語をスワップするケースをテスト
    -- バッファを設定
    vim.api.nvim_buf_set_lines(0, 0, -1, false, { "first second" })
    -- swap_wordsを実行
    your_plugin.swap_words_in_selection({ line1 = 1, line2 = 1, fargs = { "first", "second" } })
    -- 結果を検証
    local result = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    eq(result, { "second first" })
  end)

  it('swaps two words across multiple lines', function()
    -- 複数行にまたがって2つの単語をスワップするケースをテスト
    vim.api.nvim_buf_set_lines(0, 0, -1, false, { "first line", "second line" })
    your_plugin.swap_words_in_selection({ line1 = 1, line2 = 2, fargs = { "first", "second" } })
    local result = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    eq(result, { "second line", "first line" })
  end)

  it('swaps the same word multiple times in a single line', function()
    vim.api.nvim_buf_set_lines(0, 0, -1, false, { "first first first" })
    your_plugin.swap_words_in_selection({ line1 = 1, line2 = 1, fargs = { "first", "second" } })
    local result = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    eq(result, { "second second second" })
  end)

  it('is case-sensitive', function()
    vim.api.nvim_buf_set_lines(0, 0, -1, false, { "First second" })
    your_plugin.swap_words_in_selection({ line1 = 1, line2 = 1, fargs = { "First", "second" } })
    local result = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    eq(result, { "second First" })
  end)

  it('handles special characters correctly', function()
    vim.api.nvim_buf_set_lines(0, 0, -1, false, { "first-line, second-line." })
    your_plugin.swap_words_in_selection({ line1 = 1, line2 = 1, fargs = { "first", "second" } })
    local result = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    eq(result, { "second-line, first-line." })
  end)

  it('does nothing if the words are not found', function()
    vim.api.nvim_buf_set_lines(0, 0, -1, false, { "third fourth" })
    your_plugin.swap_words_in_selection({ line1 = 1, line2 = 1, fargs = { "first", "second" } })
    local result = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    eq(result, { "third fourth" })
  end)
end)
