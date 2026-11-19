# vim-config

Plugin-free Vim setup (Vim 9.x, macOS). Uses only built-in options, netrw and Vim's bundled packages (`matchit`, `editorconfig`, `cfilter`).

## Install

```sh
git clone https://github.com/Avarile/vim-config.git ~/vim-config
ln -sf ~/vim-config/vimrc ~/.vimrc
```

Machine-specific overrides go in `~/.vimrc.local` (not tracked).

## Keys (leader = Space)

| Key | Action |
|---|---|
| `␣w` / `␣q` | save / quit |
| `␣e` | file tree (netrw) |
| `␣f` | `:find` file recursively |
| `␣b` | list buffers and jump |
| `␣g` | grep project |
| `␣␣` | previous file |
| `[b` `]b` / `[q` `]q` | prev/next buffer / quickfix |
| `Ctrl-h/j/k/l` | move between splits |
| `Esc Esc` | clear search highlight |
| `J` / `K` (visual) | move lines down / up |
| `␣p` (visual) | paste without clobbering register |
| `␣tw` `␣tn` `␣ts` `␣tl` | toggle wrap / relative numbers / spell / listchars |
| `␣ve` / `␣vr` | edit / reload vimrc |
| `:w!!` | save with sudo |
