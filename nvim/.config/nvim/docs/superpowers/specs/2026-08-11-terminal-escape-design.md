# Terminal escape mappings

## Scope

Add terminal-mode key mappings in `lua/config/keybinds.lua`.

## Behavior

- Pressing `<Esc>` in a Neovim terminal buffer exits terminal input mode by sending `<C-\\><C-n>`.
- Pressing `jj` in terminal input mode sends the same sequence.
- Existing Insert and Normal mode mappings remain unchanged.

## Implementation

Use two global `vim.keymap.set("t", ...)` mappings beside the existing insert-mode escape mapping. Each mapping includes a descriptive label.

## Validation

Load Neovim configuration without Lua errors. In a `:terminal` buffer, verify both `<Esc>` and `jj` switch from terminal input mode to Normal mode.
