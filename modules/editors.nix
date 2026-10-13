{ pkgs, ... }:

{
  home.file.".config/nvim/init.lua".text = ''
    vim.opt.number = true
    vim.opt.cursorline = true
    vim.opt.relativenumber = true
    vim.opt.wrap = true
    vim.opt.linebreak = true
    vim.opt.breakindent = true
    vim.opt.showbreak = ">> "
    vim.opt.clipboard = "unnamedplus"
    vim.opt.termguicolors = true
    vim.opt.completeopt = { "menu", "menuone", "noselect" }
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1
    vim.opt.smartcase = true
    vim.opt.ignorecase = true
    vim.opt.fillchars = { eob = " " }

    -- Detect CRLF files that were read as Unix files (common when using WSL).
    -- Marking these buffers as DOS prevents carriage returns from appearing as ^M.
    vim.api.nvim_create_autocmd("BufReadPost", {
      group = vim.api.nvim_create_augroup("detect_dos_line_endings", { clear = true }),
      pattern = "*",
      callback = function()
        if vim.fn.search("\\r") > 0 then
          vim.opt_local.fileformat = "dos"
        end
      end,
    })

    vim.cmd.packadd("onedark.nvim")
    require("onedark").setup({ style = "dark", transparent = false, term_colors = true })
    require("onedark").load()

    vim.g.mapleader = " "
    vim.keymap.set("n", "<leader>gg", function()
      vim.pack.add({
        { src = "https://github.com/kdheepak/lazygit.nvim" },
      }, { load = true })
      vim.cmd.LazyGit()
    end, { desc = "Open LazyGit" })
    vim.keymap.set("n", "<leader>e", "<cmd>Oil<cr>", { desc = "Open Oil file explorer" })
    vim.keymap.set("n", "<leader>cd", "<cmd>Oil<cr>", { desc = "Open Oil file explorer" })
    vim.keymap.set("n", "<leader>a", function() require("harpoon"):list():add() end, { desc = "Harpoon add file" })
    vim.keymap.set("n", "<leader>h", function()
      local harpoon = require("harpoon")
      harpoon.ui:toggle_quick_menu(harpoon:list())
    end, { desc = "Harpoon menu" })
    for index = 1, 4 do
      vim.keymap.set("n", "<leader>" .. index, function()
        require("harpoon"):list():select(index)
      end, { desc = "Harpoon select file " .. index })
    end
    vim.keymap.set("i", "jj", "<Esc>", { desc = "Exit insert mode" })
    vim.api.nvim_create_autocmd("TermOpen", {
      group = vim.api.nvim_create_augroup("terminal_keys", { clear = true }),
      callback = function(args)
        if vim.bo[args.buf].filetype == "lazygit" then return end
        vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { buffer = args.buf, desc = "Exit terminal mode" })
        vim.keymap.set("t", "jj", "<C-\\><C-n>", { buffer = args.buf, desc = "Exit terminal mode" })
      end,
    })
    vim.keymap.set("x", "<C-h>", "<cmd>TmuxNavigateLeft<cr>", { silent = true })
    vim.keymap.set("x", "<C-j>", "<cmd>TmuxNavigateDown<cr>", { silent = true })
    vim.keymap.set("x", "<C-k>", "<cmd>TmuxNavigateUp<cr>", { silent = true })
    vim.keymap.set("x", "<C-l>", "<cmd>TmuxNavigateRight<cr>", { silent = true })
    vim.keymap.set("n", "<leader>w", "<cmd>w<cr>", { desc = "Save file" })
    vim.keymap.set("n", "<leader>q", "<cmd>q<cr>", { desc = "Quit" })
    vim.keymap.set("n", "<leader>r", "<cmd>e!<cr>", { desc = "Reload file" })
    vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, { desc = "Show diagnostic" })
    vim.keymap.set("n", "<leader>ff", function() require("fff").find_files() end, { desc = "FFF find files" })
    vim.keymap.set("n", "<leader>fg", function() require("fff").live_grep() end, { desc = "FFF live grep" })
    vim.keymap.set("n", "<leader>fr", function() require("fff").resume() end, { desc = "FFF resume last picker" })
    vim.keymap.set("n", "-", function()
      local directory = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":h")
      if directory == "" then directory = vim.fn.getcwd() end
      require("fff").find_files_in_dir(directory)
    end, { desc = "FFF find in current directory" })
    vim.keymap.set("n", "<leader>gs", function() require("fff").live_grep_under_cursor() end, { desc = "FFF grep word" })
    vim.keymap.set("x", "<leader>gs", function() require("fff").live_grep_under_cursor() end, { desc = "FFF grep selection" })

    local function packadd(package) vim.cmd.packadd(package) end
    packadd("fff.nvim")
    packadd("plenary.nvim")
    packadd("oil-nvim")
    packadd("harpoon")
    packadd("mini.nvim")
    packadd("blink.cmp")
    packadd("nvim-treesitter")
    packadd("smear-cursor.nvim")
    packadd("lualine.nvim")
    packadd("vim-tmux-navigator")
    require("oil").setup({ keymaps = { ["H"] = "actions.toggle_hidden" } })
    require("harpoon"):setup()
    require("mini.surround").setup()
    require("blink.cmp").setup({
      keymap = {
        preset = "default",
        ["<CR>"] = { "select_and_accept", "fallback" },
        ["<Tab>"] = { "select_and_accept", "fallback" },
      },
    })
    require("smear_cursor").setup()
    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("treesitter_highlight", { clear = true }),
      pattern = { "javascript", "javascriptreact", "lua", "rust", "typescript", "typescriptreact" },
      callback = function() pcall(vim.treesitter.start) end,
    })
    vim.api.nvim_create_autocmd({ "BufNewFile", "BufReadPre" }, {
      group = vim.api.nvim_create_augroup("load_gitsigns", { clear = true }),
      once = true,
      callback = function()
        packadd("gitsigns.nvim")
        require("gitsigns").setup({ signs = {
          add = { text = "+" }, change = { text = "~" }, delete = { text = "_" },
          topdelete = { text = "^" }, changedelete = { text = "~" }, untracked = { text = "+" },
        } })
      end,
    })

    local mode_names = { n = "NORMAL", i = "INSERT", v = "VISUAL", V = "V-LINE", ["\22"] = "V-BLOCK", R = "REPLACE", c = "COMMAND", t = "TERMINAL" }
    local function mode_name()
      local mode = vim.api.nvim_get_mode().mode
      return mode_names[mode:sub(1, 1)] or mode:upper()
    end
    local function current_directory() return vim.fn.fnamemodify(vim.fn.getcwd(), ":~") end
    vim.opt.laststatus = 0
    require("lualine").setup({
      options = { section_separators = "", component_separators = "" },
      sections = {}, inactive_sections = {},
      winbar = { lualine_a = { mode_name }, lualine_b = {{ "filename", path = 1, cond = function() return vim.bo.filetype ~= "oil" end }}, lualine_c = {}, lualine_x = {}, lualine_y = {}, lualine_z = { current_directory } },
      inactive_winbar = { lualine_a = { mode_name }, lualine_b = {{ "filename", path = 1, cond = function() return vim.bo.filetype ~= "oil" end }}, lualine_c = {}, lualine_x = {}, lualine_y = {}, lualine_z = { current_directory } },
    })

    local function on_attach(client, buffer)
      local options = { noremap = true, silent = true, buffer = buffer }
      vim.keymap.set("n", "gd", vim.lsp.buf.definition, options)
      vim.keymap.set("n", "gr", vim.lsp.buf.references, options)
      vim.keymap.set("n", "K", vim.lsp.buf.hover, options)
      vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, options)
      vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, options)
      if client:supports_method("inlayHint/resolve") then
        vim.lsp.inlay_hint.enable(true, { bufnr = buffer })
      end
    end
    vim.lsp.config("rust_analyzer", { cmd = { "rust-analyzer" }, filetypes = { "rust" }, root_markers = { "Cargo.toml", "rust-project.json", ".git" }, on_attach = on_attach })
    vim.lsp.config("ts_ls", { cmd = { "typescript-language-server", "--stdio" }, filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" }, root_markers = { "tsconfig.json", "jsconfig.json", "package.json", ".git" }, on_attach = on_attach })
    vim.lsp.enable({ "rust_analyzer", "ts_ls" })
  '';

  home.file.".local/share/nvim/site/pack/themes/start/onedark.nvim".source = pkgs.vimPlugins.onedark-nvim;
  home.file.".local/share/nvim/site/pack/plugins/start/blink.cmp".source = pkgs.vimPlugins.blink-cmp;
  home.file.".local/share/nvim/site/pack/plugins/start/oil-nvim".source = pkgs.vimPlugins.oil-nvim;

  home.file.".config/zed/settings.json".text = ''
  {
      "cursor_animation": {
	  "enabled": true
      },
      "seed_search_query_from_cursor": "selection",
      "file_finder": {
	  "include_ignored": "all"
      },
      "use_smartcase_search": true,
      "wsl_connections": [
	  {
	      "distro_name": "Ubuntu-24.04",
	      "user": null,
	      "projects": [
		  {
		      "paths": ["/home/amaan/projects"]
		  },
		  {
		      "paths": ["/home/amaan/projects/./"]
		  },
		  {
		      "paths": ["/home/amaan/projects/amaan-personal-website"]
		  },
		  {
		      "paths": ["/home/amaan/projects/happy-computers-website"]
		  },
		  {
		      "paths": ["/home/amaan/projects/poof"]
		  },
		  {
		      "paths": ["/home/amaan/projects/the-search-thing"]
		  },
		  {
		      "paths": ["/home/amaan/projects/typesafe-yave/./"]
		  },
		  {
		      "paths": ["/home/amaan/projects/yave"]
		  },
		  {
		      "paths": ["/home/amaan/projects/yave-website"]
		  }
	      ]
	  }
      ],
      "centered_layout": {
	  "left_padding": 0.2,
	  "right_padding": 0.2
      },
      "bottom_dock_layout": "full",
      "buffer_font_weight": 400.0,
      "buffer_line_height": "standard",
      "vim": {
	  "cursor_shape": {},
	  "show_edit_predictions_in_normal_mode": false,
	  "use_regex_search": true,
	  "use_smartcase_find": true,
	  "toggle_relative_line_numbers": true
      },
      "gutter": {
	  "min_line_number_digits": 4
      },
      "cursor_blink": false,
      "show_whitespaces": "selection",
      "markdown_preview_font_size": 14.0,
      "buffer_font_size": 16.0,
      // "buffer_font_family": "FiraCode Nerd Font Mono",
      // "buffer_font_family": "Ubuntu Mono",
      // "buffer_font_family": "JetBrains Mono",
      "buffer_font_family": "Iosevka Term",
      "command_aliases": {
	  "aa": "agent::ToggleFocus",
	  "ee": "editor::ToggleFocus",
	  "rw": "workspace::Reload",
	  "cp": "workspace::CloseProject",
	  "gd": "git::Diff",
	  "gs": "git::Switch",
	  "gp": "git::Push",
	  "gc": "git::Commit"
      },
      "ui_font_size": 16.0,
      "ui_font_family": "Iosevka Term",
      "agent_buffer_font_size": 16.0,
      "agent_ui_font_size": 16.0,
      "context_servers": {},
      "icon_theme": {
	  "mode": "dark",
	  "light": "Colored Zed Icons Theme Dark",
	  "dark": "Zed (Default)"
      },
      "ui_font_weight": 400.0,
      "outline_panel": {
	  "dock": "left"
      },
      "collaboration_panel": {
	  "dock": "left"
      },
      "show_edit_predictions": true,
      "edit_predictions": {
	  "mode": "subtle",
	  "provider": "zed"
      },
      "diff_view_style": "split",
      "cli_default_open_behavior": "existing_window",
      "agent": {
	  "thinking_display": "always_collapsed",
	  "terminal_init_command": "",
	  "tool_permissions": {
	      "tools": {
		  "mcp:mcp-server-exa-search:web_fetch_exa": {
		      "default": "allow"
		  },
		  "mcp:mcp-server-exa-search:web_search_exa": {
		      "default": "allow"
		  },
		  "search_web": {
		      "default": "allow"
		  },
		  "terminal": {
		      "default": "allow",
		      "always_allow": [
			  {
			      "pattern": "^jj\\b"
			  }
		      ]
		  },
		  "mcp:fff:multi_grep": {
		      "default": "allow"
		  },
		  "mcp:fff:grep": {
		      "default": "allow"
		  },
		  "mcp:fff:find_files": {
		      "default": "allow"
		  }
	      }
	  },
	  "inline_assistant_model": {
	      "provider": "zed.dev",
	      "model": "gpt-5.5",
	      "enable_thinking": false
	  },
	  "default_model": {
	      "provider": "zed.dev",
	      "model": "gpt-5.6-terra",
	      "enable_thinking": true,
	      "effort": "medium"
	  },
	  "dock": "right",
	  "sidebar_side": "left",
	  "favorite_models": [],
	  "model_parameters": []
      },
      "search": {
	  "include_ignored": false
      },
      "soft_wrap": "editor_width",
      "relative_line_numbers": "wrapped",
      "git_panel": {
	  "dock": "left"
      },
      "terminal": {
	  // "font_family": "JetBrainsMono Nerd Font",
	  "font_family": "Iosevka Term",
	  "dock": "bottom",
	  "font_weight": 300.0,
	  "font_size": 14.0
      },
      "project_panel": {
	  "indent_size": 16.0,
	  "entry_spacing": "standard",
	  "hide_hidden": false,
	  "dock": "left"
      },
      "telemetry": {
	  "diagnostics": false,
	  "metrics": false
      },
      "session": {
	  "trust_all_worktrees": false
      },
      "vim_mode": true,
      "agent_servers": {
	  "pi-acp": {
	      "favorite_config_option_values": {
		  "model": ["openai/gpt-5.6-sol", "openai/gpt-5.6-luna"]
	      },
	      "type": "registry",
	      "default_config_options": {
		  "model": "openai/gpt-5.6-sol"
	      }
	  },
	  "codex-acp": {
	      "default_config_options": {
		  "model": "gpt-5.3-codex"
	      },
	      "type": "registry"
	  },
	  "claude-acp": {
	      "default_config_options": {
		  "mode": "bypassPermissions"
	      },
	      "type": "registry"
	  },
	  "cursor": {
	      "favorite_config_option_values": {
		  "model": ["grok-4.5", "composer-2.5"]
	      },
	      "default_config_options": {
		  "fast": "false",
		  "mode": "agent",
		  "model": "grok-4.5"
	      },
	      "type": "registry"
	  }
      },
      "format_on_save": "on",
      "lsp": {
	  "vtsls": {
	      "settings": {
		  "typescript": {
		      "updateImportsOnFileMove": {
			  "enabled": "always"
		      }
		  },
		  "javascript": {
		      "updateImportsOnFileMove": {
			  "enabled": "always"
		      }
		  }
	      },
	      "enable_lsp_tasks": true
	  }
      },
      "languages": {
	  "Markdown": {
	      "format_on_save": "off",
	      "prettier": {
		  "allowed": false
	      }
	  },
	  "TypeScript": {
	      "code_actions_on_format": {
		  "source.fixAll.oxc": true
	      },
	      "languages": [
		  "typescript-ls",
		  "!vtsls",
		  "!typescript-language-server",
		  "..."
	      ],
	      "inlay_hints": {
		  "enabled": true
	      },
	      "format_on_save": "on",
	      "prettier": {
		  "allowed": false
	      },
	      "formatter": []
	  },
	  "TSX": {
	      "code_actions_on_format": {
		  "source.fixAll.oxc": true
	      },
	      "languages": [
		  "typescript-ls",
		  "!vtsls",
		  "!typescript-language-server",
		  "..."
	      ],
	      "format_on_save": "on",
	      "prettier": {
		  "allowed": false
	      },
	      "formatter": []
	  },
	  "JavaScript": {
	      "code_actions_on_format": {
		  "source.fixAll.oxc": true
	      },
	      "format_on_save": "on",
	      "prettier": {
		  "allowed": false
	      },
	      "formatter": []
	  }
      },
      "theme": {
	  "mode": "dark",
	  "light": "Ayu Light",
	  // "dark": "Gruvbox Dark Soft",
	  "dark": "One Dark"
	  // "dark": "Gruvbox Dark Soft"
      },
      "language_servers": ["ty", "!basedpyright", "!eslint", "oxlint", "..."],
      "file_scan_exclusions": [
	  "**/.git",
	  "**/.svn",
	  "**/.hg",
	  "**/.jj",
	  "**/CVS",
	  "**/.DS_Store",
	  "**/Thumbs.db",
	  "**/.classpath",
	  "**/.settings",
	  "**/node_modules",
	  "**/target"
      ]
  }
  '';

  home.file.".config/zed/keymap.json".text = ''
    [
        {
            "context": "Workspace",
            "bindings": {
                "ctrl-alt-n": "workspace::ToggleCenteredLayout"
            }
        },
        {
            "context": "Workspace",
            "bindings": {
                "ctrl t": "workspace::NewCenterTerminal"
            }
        },
        {
            "context": "Workspace",
            "bindings": {
                "ctrl f t": [
                    "workspace::SendKeystrokes",
                    "alt-ctrl-shift-f11 alt-ctrl-shift-f12 ctrl-alt-enter"
                ],
                "alt-ctrl-shift-f11": ["pane::SplitRight", { "mode": "EmptyPane" }],
                "alt-ctrl-shift-f12": "workspace::ActivatePaneRight",
                "ctrl-alt-enter": "workspace::NewCenterTerminal"
            }
        },
        {
            "context": "Workspace && vim_mode == normal && !menu && !AgentPanel && !Terminal",
            "bindings": {
                "f f": ["task::Spawn", { "task_name": "fff" }]
            }
        },
        {
            "context": "Editor && vim_mode == normal && !menu ",
            "bindings": {
                "ctrl-h": "workspace::ActivatePaneLeft",
                "ctrl-j": "workspace::ActivatePaneDown",
                "ctrl-k": "workspace::ActivatePaneUp",
                "ctrl-l": "workspace::ActivatePaneRight",
                "ctrl-shift-h": "workspace::MovePaneLeft",
                "ctrl-shift-l": "workspace::MovePaneRight",
                "ctrl-shift-k": "workspace::MovePaneUp",
                "ctrl-shift-j": "workspace::MovePaneDown"
            }
        },
        {
            "context": "Terminal",
            "bindings": {
                "ctrl-h": "workspace::ActivatePaneLeft",
                "ctrl-j": "workspace::ActivatePaneDown",
                "ctrl-k": "workspace::ActivatePaneUp",
                "ctrl-l": "workspace::ActivatePaneRight",
                "ctrl-shift-h": "workspace::MovePaneLeft",
                "ctrl-shift-l": "workspace::MovePaneRight",
                "ctrl-shift-k": "workspace::MovePaneUp",
                "ctrl-shift-j": "workspace::MovePaneDown"
            }
        },
        {
            "context": "Dock",
            "bindings": {
                "ctrl-h": "workspace::ActivatePaneLeft",
                "ctrl-j": "workspace::ActivatePaneDown",
                "ctrl-k": "workspace::ActivatePaneUp",
                "ctrl-l": "workspace::ActivatePaneRight"
            }
        },
        {
            "context": "Editor && vim_mode == normal && !menu",
            "bindings": {
                "s a": ["workspace::SendKeystrokes", "y s"],
                "s d": ["workspace::SendKeystrokes", "d s"],
                "s r": ["workspace::SendKeystrokes", "c s"]
            }
        },
        {
            "context": "Editor && vim_mode == visual && !menu",
            "bindings": {
                "s a": "vim::PushAddSurrounds"
            }
        },
        {
            "context": "Editor && vim_mode == insert",
            "bindings": {
                "j j": "vim::NormalBefore"
            }
        },
        {
            "context": "Editor && mode == full",
            "bindings": {
                "ctrl-w l": "agent::AddSelectionToThread"
            }
        }
    ]
  '';

  home.file.".config/zed/tasks.json".text = ''
    [
      { "label": "lg", "command": "cd \"$(git rev-parse --show-toplevel)\" && lazygit", "reveal_target": "center", "hide": "always", "show_summary": false, "show_command": false, "save": "none" },
      { "label": "fff", "command": "root=\"''${ZED_WORKTREE_ROOT:-.}\"; zed \"$(fff-tui --column --group files \"$root\")\"", "shell": { "program": "sh" }, "hide": "always", "allow_concurrent_runs": true, "use_new_terminal": true }
    ]
  '';
}
