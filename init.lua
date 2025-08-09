local function bootstrap(url, ref)
  local name = url:gsub(".*/", "")
  local path = vim.fn.stdpath("data") .. "/lazy/" .. name
  vim.opt.rtp:prepend(path)

  if vim.fn.isdirectory(path) == 0 then
    print(name .. ": installing in data dir...")

    vim.fn.system {"git", "clone", url, path}
    if ref then
      vim.fn.system {"git", "-C", path, "checkout", ref}
    end

    vim.cmd "redraw"
    print(name .. ": finished installing")
  end
end

local function my_tangerine()
  local path = "Z:/Repos/tangerine.nvim/"
  vim.opt.rtp:prepend(path)
end

-- my_tangerine()
bootstrap("https://github.com/Fuann-Kinoko/tangerine.nvim") -- custom fork
bootstrap("https://github.com/udayvir-singh/hibiscus.nvim")
require "tangerine".setup {
  vimrc  = vim.fn.stdpath [[config]] .. "/main.fnl",
  source = vim.fn.stdpath [[config]] .. "/source",
  target = vim.fn.stdpath [[config]] .. "/lua",

  -- compile files in &rtp
  rtpdirs = {
    "ftplugin",
  },

  compiler = {
    -- disable popup showing compiled files
    verbose = false,
    -- compile every time changes are made to fennel files or on entering vim
    hooks = { "onsave", "oninit" },
    float = false,
  },
  eval = {float = true},
}
