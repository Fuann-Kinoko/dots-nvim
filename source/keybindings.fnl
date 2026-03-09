(require-macros :hibiscus.vim)

(fn open-relative-path []
  (vim.api.nvim_feedkeys
    (.. ":e " (vim.fn.expand "%:h") "\\")
    :n true))

(fn map-normal-bindings []
  ; 基础移动
  (map! [n] :<A-v> "<C-u>")   ; 上移半页
  (map! [n] :<C-v> "<C-d>")   ; 下移半页
  (map! [n] :J "^")           ; 行首
  (map! [n] :K "$")           ; 行尾
  (map! [n] :<C-q> "<C-v>")   ; 块选择
  ; 剪贴板操作
  (map! [n] :<A-w> "\"+y")    ; 复制到系统剪贴板
  (map! [n] :<C-y> "\"+p")    ; 粘贴系统剪贴板
  ; 实用功能
  (map! [n] :<leader>j "J")   ; 合并下一行
  (map! [n] :<leader><leader> "<Cmd>nohl<CR><Cmd>mode<CR>") ; 清除高亮
  (map! [n] :<leader>sen "<Cmd>e $MYVIMRC/../main.fnl<CR>") ; 编辑器设置
  (map! [n] :<leader>f open-relative-path) ; 预输入当前buffer目录路径
  )

(fn map-visual-bindings []
  (map! [v] :<A-w> "\"+y") 	; 复制到系统粘贴板
  (map! [v] :<C-y> "\"+p") 	; 粘贴系统剪贴板
  (map! [v] :<A-v> "<C-u>") ; 上移半页
  (map! [v] :<C-v> "<C-d>") ; 下移半页
  (map! [v] :J "^") 				; 行首
  (map! [v] :K "$")					; 行尾
  (map! [v] :<C-q> "<C-v>")	; 块选择
  (map! [v] ";" "o")				; 用;来切换首尾
  )

(fn map-insert-bindings []
  (map! [i] :<C-y> "<C-o>:set paste<CR><C-r>+<C-o>:set nopaste<CR>") ; 粘贴系统剪贴板
  )

(fn map-vscode-bindings []
	(when vim.g.vscode
    (augroup! :cursor-fresh-mode
      [[CursorHold :desc "Fresh ghost texts by showing current mode silently in VSCode"]
        * #(when vim.g.vscode
              (vim.cmd "silent! mode"))])

		(map! [n] :<leader>lf "<Cmd>lua require('vscode').call('editor.action.formatDocument')<CR>")
		(map! [n] :<leader>la "<Cmd>lua require('vscode').call('editor.action.quickFix')<CR>")
		(map! [n] :<leader>lr "<Cmd>lua require('vscode').call('editor.action.rename')<CR>")
		(map! [n] :<leader>ls "<Cmd>lua require('vscode').call('workbench.action.gotoSymbol')<CR>")
		(map! [n] :<leader>lS "<Cmd>lua require('vscode').call('workbench.action.showAllSymbols')<CR>")
		(map! [n] :<leader>lR "<Cmd>lua require('vscode').call('editor.action.goToReferences')<CR>")
		(map! [n] :gr "<Cmd>lua require('vscode').call('editor.action.goToReferences')<CR>")
		(map! [n] :gt "<Cmd>lua require('vscode').call('editor.action.peekTypeDefinition')<CR>")
		(map! [n] :<leader>n "<Cmd>lua require('vscode').call('workbench.action.files.newUntitledFile')<CR>")
		(map! [n] :<leader>k "<Cmd>lua require('vscode').call('workbench.action.closeActiveEditor')<CR>")
		(map! [n] :<leader>e "<Cmd>lua require('vscode').call('workbench.view.explorer')<CR>")
		(map! [n] :<leader>set "<Cmd>lua require('vscode').call('workbench.action.openSettingsJson')<CR>")))

(fn setup []
  (map-normal-bindings)
  (map-visual-bindings)
  (map-insert-bindings)
  (map-vscode-bindings))

:return {
  : setup
  :funcs {
    : map-normal-bindings
    : map-visual-bindings
    : map-insert-bindings
    : map-vscode-bindings
  }
}
