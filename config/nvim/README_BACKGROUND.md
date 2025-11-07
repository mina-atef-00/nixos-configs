To apply the transparent background changes with Catppuccin Mocha theme:

1. Open Neovim
2. Run the command: `:LazySync`
3. This will apply the configuration changes and update your theme settings

The configuration in lua/plugins/theme.lua sets:
- transparent_background = true for the catppuccin theme
- Various UI elements (Normal, NormalFloat, FloatBorder, NeoTreeNormal, etc.) to have no background
- This should make your Neovim background match your terminal's background

The Catppuccin Mocha Mauve theme is now configured with transparent backgrounds. If you want to use a different flavor of Catppuccin, change "flavour = 'mocha'" to 'latte', 'frappe', or 'macchiato' in the theme.lua file.