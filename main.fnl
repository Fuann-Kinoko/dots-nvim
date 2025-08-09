(require-macros :hibiscus.vim)
(import-macros {: dump!} :hibiscus.core)

(color! "habamax")
(g! mapleader " ")

; 非vscode不用开，但是vscode-neovim下不用这个非常之卡
(when vim.g.vscode
	(g! clipboard vim.g.vscode_clipboard))

(set! updatetime 1000)
(set! tabstop 4)
(set! shiftwidth 4)
(set! softtabstop 4)
(set! expandtab true)
(set! smartindent true)
(set! ignorecase true)
(set! smartcase true)
(set! undofile true)
(set! undodir (.. (vim.fn.stdpath "data") "/undodir"))
(map! [nvoic] :<F15> "<nop>")

(each [_ module (ipairs [
	(require :keybindings)
	(require :provider)
	(require :plugins)
	])]
	(module.setup))

:return {}

; 备用方法: 直接运行 lua 文件
; (let [cfg-source (.. (vim.fn.stdpath :config) "/init_LUA.lua")]
; 	(dofile cfg-source))

