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
    vim.opt.guicursor = "n-v-c-sm:block,i-ci-ve:block,r-cr-o:hor20,t:block-blinkon500-blinkoff500-TermCursor"
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1
    vim.opt.smartcase = true
    vim.opt.ignorecase = true
    vim.opt.fillchars = { eob = " " }
    vim.cmd.colorscheme("gruvbox")

    vim.g.mapleader = " "
    vim.keymap.set("n", "<leader>e", "<cmd>Neotree filesystem toggle<cr>", { desc = "Toggle file tree" })
    vim.keymap.set("n", "<leader>cd", "<cmd>Neotree filesystem toggle<cr>", { desc = "Toggle file tree" })
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
    vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
    vim.keymap.set("t", "jj", "<C-\\><C-n>", { desc = "Exit terminal mode" })
    vim.keymap.set("x", "<C-h>", "<cmd>TmuxNavigateLeft<cr>", { silent = true })
    vim.keymap.set("x", "<C-j>", "<cmd>TmuxNavigateDown<cr>", { silent = true })
    vim.keymap.set("x", "<C-k>", "<cmd>TmuxNavigateUp<cr>", { silent = true })
    vim.keymap.set("x", "<C-l>", "<cmd>TmuxNavigateRight<cr>", { silent = true })
    vim.keymap.set("n", "<leader>w", "<cmd>w<cr>", { desc = "Save file" })
    vim.keymap.set("n", "<leader>q", "<cmd>q<cr>", { desc = "Quit" })
    vim.keymap.set("n", "<leader>r", "<cmd>e!<cr>", { desc = "Reload file" })
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

    local function interrupt_opencode()
      require("opencode").command("session.interrupt")
    end
    vim.keymap.set("n", "<leader>oi", interrupt_opencode, { desc = "Interrupt OpenCode" })
    vim.keymap.set({ "n", "x" }, "<leader>oa", function() require("opencode").ask("@this: ") end, { desc = "Ask OpenCode" })
    vim.keymap.set({ "n", "x" }, "<leader>ox", function() require("opencode").select() end, { desc = "Select OpenCode action" })
    vim.keymap.set({ "n", "x" }, "go", function() return require("opencode").operator("@this ") end, { desc = "Append range to OpenCode", expr = true })
    vim.keymap.set("n", "goo", function() return require("opencode").operator("@this ") .. "_" end, { desc = "Append line to OpenCode", expr = true })
    vim.keymap.set("n", "<S-C-u>", function() require("opencode").command("session.half.page.up") end, { desc = "Scroll OpenCode up" })
    vim.keymap.set("n", "<S-C-d>", function() require("opencode").command("session.half.page.down") end, { desc = "Scroll OpenCode down" })
    vim.api.nvim_create_autocmd("TermOpen", {
      group = vim.api.nvim_create_augroup("opencode_terminal_keys", { clear = true }),
      pattern = "*",
      callback = function(args)
        if not vim.api.nvim_buf_get_name(args.buf):lower():find("opencode", 1, true) then return end
        vim.keymap.set("t", "<C-c>", interrupt_opencode, { buffer = args.buf, desc = "Interrupt OpenCode" })
        vim.keymap.set("t", "<Esc>", function()
          local job_id = vim.b[args.buf].terminal_job_id
          if job_id then vim.api.nvim_chan_send(job_id, "\27") end
        end, { buffer = args.buf, desc = "Send Escape to OpenCode" })
      end,
    })

    vim.pack.add({
      { src = "https://github.com/nickjvandyke/opencode.nvim", version = vim.version.range("*") },
    })
    local function packadd(package) vim.cmd.packadd(package) end
    packadd("fff.nvim")
    packadd("plenary.nvim")
    packadd("nui.nvim")
    packadd("neo-tree.nvim")
    packadd("harpoon")
    packadd("mini.nvim")
    packadd("nvim-treesitter")
    packadd("smear-cursor.nvim")
    packadd("lualine.nvim")
    packadd("vim-tmux-navigator")
    require("neo-tree").setup({})
    require("harpoon"):setup()
    require("mini.surround").setup()
    require("smear_cursor").setup()
    vim.api.nvim_create_autocmd("VimEnter", {
      group = vim.api.nvim_create_augroup("open_neo_tree_on_empty_start", { clear = true }),
      callback = function()
        if #vim.api.nvim_list_uis() == 0 or vim.fn.argc() ~= 0 or vim.api.nvim_buf_get_name(0) ~= "" then return end
        vim.cmd.Neotree()
      end,
    })
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
      winbar = { lualine_a = { mode_name }, lualine_b = {{ "filename", path = 1, cond = function() return vim.bo.filetype ~= "neo-tree" end }}, lualine_c = {}, lualine_x = {}, lualine_y = {}, lualine_z = { current_directory } },
      inactive_winbar = { lualine_a = { mode_name }, lualine_b = {{ "filename", path = 1, cond = function() return vim.bo.filetype ~= "neo-tree" end }}, lualine_c = {}, lualine_x = {}, lualine_y = {}, lualine_z = { current_directory } },
    })

    local function on_attach(_, buffer)
      local options = { noremap = true, silent = true, buffer = buffer }
      vim.keymap.set("n", "gd", vim.lsp.buf.definition, options)
      vim.keymap.set("n", "gr", vim.lsp.buf.references, options)
      vim.keymap.set("n", "K", vim.lsp.buf.hover, options)
      vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, options)
      vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, options)
    end
    vim.lsp.config("rust_analyzer", { cmd = { "rust-analyzer" }, filetypes = { "rust" }, root_markers = { "Cargo.toml", "rust-project.json", ".git" }, on_attach = on_attach })
    vim.lsp.config("ts_ls", { cmd = { "typescript-language-server", "--stdio" }, filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" }, root_markers = { "tsconfig.json", "jsconfig.json", "package.json", ".git" }, on_attach = on_attach })
    vim.lsp.enable({ "rust_analyzer", "ts_ls" })
  '';

  home.file.".config/nvim/colors/gruvbox.vim".source = "${pkgs.vimPlugins.gruvbox}/colors/gruvbox.vim";

  home.file.".config/zed/settings.json".text = ''
    {
      "bottom_dock_layout": "full",
      "buffer_font_weight": 400.0,
      "buffer_line_height": "standard",
      "vim": {
        "cursor_shape": { "insert": "inherit" },
        "show_edit_predictions_in_normal_mode": false,
        "use_regex_search": true,
        "use_smartcase_find": true,
        "toggle_relative_line_numbers": true
      },
      "gutter": { "min_line_number_digits": 4 },
      "cursor_blink": false,
      "show_whitespaces": "selection",
      "markdown_preview_font_size": 22.0,
      "buffer_font_size": 22.0,
      "buffer_font_family": "Iosevka Term",
      "ui_font_size": 22.0,
      "ui_font_family": "Iosevka Term",
      "agent_buffer_font_size": 20.0,
      "agent_ui_font_size": 24.0,
      "command_aliases": {
        "aa": "agent::ToggleFocus",
        "ee": "editor::ToggleFocus",
        "rw": "workspace::Reload",
        "cp": "workspace::CloseProject",
        "gd": "git::Diff",
        "gs": "git::Switch",
        "gp": "git::Push"
      },
      "icon_theme": { "mode": "dark", "light": "Colored Zed Icons Theme Dark", "dark": "Zed (Default)" },
      "outline_panel": { "dock": "left" },
      "collaboration_panel": { "dock": "left" },
      "show_edit_predictions": true,
      "edit_predictions": { "mode": "subtle", "provider": "zed" },
      "diff_view_style": "split",
      "cli_default_open_behavior": "existing_window",
      "agent": {
        "dock": "right",
        "sidebar_side": "left",
        "favorite_models": [],
        "model_parameters": [],
        "default_model": { "provider": "zed.dev", "model": "gpt-5.6-terra", "enable_thinking": true, "effort": "medium" }
      },
      "search": { "include_ignored": false },
      "soft_wrap": "editor_width",
      "relative_line_numbers": "wrapped",
      "git_panel": { "dock": "left" },
      "terminal": { "font_family": "Iosevka Term", "dock": "bottom", "font_weight": 300.0, "font_size": 21.0 },
      "project_panel": { "indent_size": 16.0, "entry_spacing": "standard", "hide_hidden": false, "dock": "left" },
      "telemetry": { "diagnostics": false, "metrics": false },
      "session": { "trust_all_worktrees": false },
      "vim_mode": true,
      "format_on_save": "on",
      "languages": {
        "Markdown": { "format_on_save": "off", "prettier": { "allowed": false } },
        "TypeScript": {
          "inlay_hints": { "enabled": true },
          "language_servers": ["typescript-ls", "!vtsls", "!typescript-language-server", "!eslint", "..."],
          "format_on_save": "on",
          "prettier": { "allowed": false }
        },
        "TSX": { "language_servers": ["typescript-ls", "!vtsls", "!typescript-language-server", "!eslint", "..."], "format_on_save": "on", "prettier": { "allowed": false } },
        "JavaScript": { "language_servers": ["!eslint", "..."], "format_on_save": "on", "prettier": { "allowed": false } }
      },
      "theme": { "mode": "dark", "dark": "One Dark" },
      "language_servers": ["ty", "!basedpyright", "!eslint", "oxlint", "..."],
      "file_scan_exclusions": ["**/.DS_Store", "**/node_modules", "**/target"]
    }
  '';

  home.file.".config/zed/keymap.json".text = ''
    [
      { "context": "Workspace", "bindings": {
        "ctrl t": ["workspace::SendKeystrokes", "alt-ctrl-shift-f11 alt-ctrl-shift-f12 ctrl-alt-enter"],
        "alt-ctrl-shift-f11": ["pane::SplitRight", { "mode": "EmptyPane" }],
        "alt-ctrl-shift-f12": "workspace::ActivatePaneRight",
        "ctrl-alt-enter": "workspace::NewCenterTerminal"
      } },
      { "context": "Workspace && vim_mode == normal && !menu && !AgentPanel && !Terminal", "bindings": { "f f": ["task::Spawn", { "task_name": "fff" }] } },
      { "context": "Editor && vim_mode == normal && !menu", "bindings": { "s a": ["workspace::SendKeystrokes", "y s"], "s d": ["workspace::SendKeystrokes", "d s"], "s r": ["workspace::SendKeystrokes", "c s"], "space p": "command_palette::Toggle", "space g": "workspace::NewSearch", "space w": "workspace::Save", "space f": "file_finder::Toggle" } },
      { "context": "Terminal", "bindings": { "space f": "file_finder::Toggle" } },
      { "context": "Editor && vim_mode == insert", "bindings": { "j j": "vim::NormalBefore" } },
      { "context": "Editor && vim_mode", "bindings": { "ctrl-w v": "pane::SplitRight" } },
      { "context": "Editor && mode == full", "bindings": { "ctrl-l": "agent::AddSelectionToThread" }, "unbind": { "ctrl->": "agent::AddSelectionToThread" } }
    ]
  '';

  home.file.".config/zed/tasks.json".text = ''
    [
      { "label": "lg", "command": "cd \"$(git rev-parse --show-toplevel)\" && lazygit", "reveal_target": "center", "hide": "always", "show_summary": false, "show_command": false, "save": "none" },
      { "label": "fff", "command": "root=\"''${ZED_WORKTREE_ROOT:-.}\"; zed \"$(fff-tui --column --group files \"$root\")\"", "shell": { "program": "sh" }, "hide": "always", "allow_concurrent_runs": true, "use_new_terminal": true }
    ]
  '';
}
