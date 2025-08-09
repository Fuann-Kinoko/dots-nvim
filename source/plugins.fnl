(require-macros :hibiscus.vim)
(import-macros {: tx! : call-require!} :utils.macros)

(fn bootstrap-lazy []
  (let [lazypath (.. (vim.fn.stdpath :data) "/lazy/lazy.nvim")]
    (when (not (vim.loop.fs_stat lazypath))
      (vim.fn.system [:git :clone "--filter=blob:none" "--branch=stable" "https://github.com/folke/lazy.nvim.git" lazypath]))
    (vim.opt.rtp:prepend lazypath)
    (require :lazy)))
(local lazy (bootstrap-lazy))

(local plugins {})
(macro plugin! [name config]
  `(set (. plugins ,name) ,config))

(plugin! :flash {
  1 "folke/flash.nvim"
  :opts {
    :modes { :char {:keys ["f" "F" "t" "T" ";" "L" ","]} }
  }
  :keys [(tx! "s" #(call-require! :flash :jump) {:mode ["n" "x" "o"] :desc "Flash"})]
  })

(plugin! :mini {
  1 "echasnovski/mini.nvim"
  :version false
  :config (fn []
      (call-require! :mini.ai :setup)
      (call-require! :mini.comment :setup {:mappings {
        :comment "" :comment_line "-" :comment_visual "-"
      }}))
  })

(plugin! :treesitter {
  1 "nvim-treesitter/nvim-treesitter"
  :build ":TSUpdate"
  :main "nvim-treesitter.configs"
  :opts {
    :ensure_installed ["bash" "c" "diff" "html" "lua" "luadoc" "markdown" "markdown_inline" "query" "vim" "vimdoc" "json"]
    :auto_install true
    :highlight {:enable true :additional_vim_regex_highlighting ["ruby"]}
    :indent {:enable false}
    :incremental_selection {
      :enable true
      :keymaps {
        :init_selection false :node_incremental "<M-O>" :scope_incremental false :node_decremental "<M-I>"
      }
    }
  }
  })

(plugin! :tree-climber {
  ; 1 "Fuann-Kinoko/tree-climber-custom.nvim"
  :dir "Z:/Repos/tree-climber-custom.nvim"
  :name "tree-climber-custom"
  :opts {:skip_comments true :highlight true :timeout 300}
  :config (fn [_ opts]
    (let [tc (require :tree-climber-custom)]
      (map! [nxo] :<M-k> #(tc.goto_parent opts))
      (map! [nxo] :<M-j> #(tc.goto_child opts))
      (map! [nxo] :<M-o> #(tc.goto_next_smart opts))
      (map! [nxo] :<M-i> #(tc.goto_prev opts))
      (map! [n]   :<M-O> #(tc.select_node opts))
      (map! [n] "\\<c-k>" #(tc.swap_prev opts))
      (map! [n] "\\<c-j>" #(tc.swap_next opts))))
  })

(plugin! :yanky {
  1 "gbprod/yanky.nvim"
  :opts {
    :highlight {:on_put true :on_yank true :timer 200}
    :system_clipboard {:sync_with_ring false} ; 开启这个会导致在 ssh / windows 切换窗口聚焦时产生极大的延迟
  }
  :config (fn [_ opts]
    (call-require! :yanky :setup opts)
    (map! [nx] :p "<Plug>(YankyPutAfter)")
    (map! [nx] :P "<Plug>(YankyPutBefore)")
    (map! [n] "<A-p>" "<Plug>(YankyPreviousEntry)")
    (map! [n] "<A-n>" "<Plug>(YankyNextEntry)")
  )
})

(local lazy-config {
  :performance {:rtp {:reset false}} })

(fn setup []
  (let [plugins-config
        (icollect [_ v (pairs plugins)]
          v)]
    (lazy.setup plugins-config lazy-config)))

:return {
  : setup
  : plugins
}
