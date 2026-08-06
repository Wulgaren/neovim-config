# Neovim tips

## Motion & editing

| Key | Action |
|-----|--------|
| `gf` / `gF` | open **file path** under cursor (`gF`: line number suffix if `:line:` form exists) |
| `gx` | open URL under cursor |
| `gd` | go to definition (LSP when available) |
| `Ctrl+^` | alternate buffer |
| `Ctrl+o` / `Ctrl+i` | jump backward / forward (jump list) |
| `f{char}` / `F{char}` | find char forward / backward on line |
| `;` / `,` | repeat previous `f`/`t`/`F`/`T` |
| `^` / `$` | Start/end of line |
| `R` | Replace mode until `Esc` |
| `o` | insert on line below |
| `ggVG` | select all |
| `ge` / `gE` | backward to **end** of `[count]` previous word / WORD (`dge`, `3cge`, …) |
| `g&` | repeat last `:substitute` on whole buffer (`:help :&`) |
| `J` | Join **next** line into current |
| `C-o` | Add "enter" in Insert Mode|
| `C-u / C-d` | Move up/down by half a page |
| `{ / }` | Move by paragraphs |
| `/ or ?` | Search forwards/backwards |
| `<C-v> then <I/A>` | Visual **block** mode then insert |
| `gi` | Insert in the last place you edited |
| `:g/your_string/d` | delete strings with specific text (:g! - delete ones that don't include the string) |

## Change operators

| Key | Action |
|-----|--------|
| `c` | change (operator) |
| `ciw` | change inner word |
| `cib` / `ciB` | change inside `()` / `{}` |
| `g~` + motion | toggle case (`g~W` — whole WORD) |
| `_` | whole-line motion (with `d`/`c`/`y`, etc.) |

## Undo, redo & repeat

| Key | Action |
|-----|--------|
| `u` | undo |
| `Ctrl+r` | redo |
| `.` | repeat last change (`:help .`) |

## Indent & `=`

| Key | Action |
|-----|--------|
| `>ib` | indent inner `()` |
| `>at` | indent tag block (`<>`) |
| `gg=G` | re-indent buffer |

## Search

| Key | Action |
|-----|--------|
| `*` | search forward for word under cursor |
| `g*` | search forward for word under cursor (includes when word is part of other word) |
| `gn` / `gN` | operate on **next/previous occurrence** (`dgn`, `.`, …) |
| — | after search: `ciw`, then `n` and `.` to repeat on next matches |

## Marks

| Key | Action |
|-----|--------|
| `m` + letter | lowercase: buffer mark; uppercase: global mark |
| `'` + letter | jump to mark |
| `<C-h>` | marks picker (`vim.ui.select`) |

## Save & quit

| Key | Action |
|-----|--------|
| `ZZ` | write (prompt path if unnamed) and quit |
| `ZQ` | quit window without writing |
| `ZX` | quit Neovim without writing everywhere (`:qa!`) |

---

## Window splits

| Key | Action |
|-----|--------|
| `<C-w><C-w>` | cycle windows |
| `<C-w>q` | close window |
| `:bd` | close buffer |
| `<C-w>h` / `j` / `k` / `l` | focus left / down / up / right |
| `<C-w>s` | split horizontal (top/bottom) |
| `<C-w>v` | split vertical (left/right) |
| `<C-w>_` | maximizing vertically |

Non-focused windows use dimmer **NormalNC** so active split stands out.

---

## Other custom keymaps

| Key | Action |
|-----|--------|
| `<C-s>` | write (Normal & Insert) |
| `<Esc>` (Normal) | clear search highlight |
| `Q` | disabled |
| `<Leader>sr` | `:substitute` whole buffer / selection |
| `<Leader>pv` / `<Leader>e` | netrw `Lexplore` — see **File explorer** below |
| `<Leader>ko` | **NeoCodeium** toggle (`:NeoCodeium toggle`; `!` stops Windsurf server) |
| `<C-u>` / `<C-d>` / `<C-f>` / `<C-b>` | scroll, cursor centered |
| `n` / `N` | next/prev match, cursor centered |
| Visual `J` / `K` | move selection down/up |
| `=ap` | reindent paragraph; mark `a` restores cursor |
| `<leader>t` | terminal in Vim — quit with `Esc` then `q` |
| Visual `@l` | add console.log |

---

## Commands, navigation, Git, more

### Commands

| Command | Action |
|---------|--------|
| `:MyTips` | open this file below |
| `:WQ` | like `ZZ` (write or prompt, then quit) |
| `:CatppuccinLight` / `:CatppuccinDark` | builtin catppuccin + readability overrides |

### File explorer (Netrw / `:Lexplore`)

Open with `<Leader>pv` or `<Leader>e`.

| Key | Action |
|-----|--------|
| `%` | create **file** (opens in previous window) |
| `d` | create **folder** (`mkdir`) |
| `Enter` / `o` | open file or directory |
| `D` | delete file or directory |
| `R` | rename |
| `-` | go up one directory |

### Native find / grep / pickers

| Key | Action |
|-----|--------|
| `<C-p>` | fuzzy find files (`:find` + `matchfuzzy` / `rg --files`) |
| `<C-t>` / `<Leader>fg` | ripgrep → quickfix; cursor previews (`pedit`); `<CR>` opens in main window (not preview) |
| `<C-h>` | marks picker |
| `<C-j>` / `<Leader>b` | buffers picker |
| `<Leader>fs` | LSP document symbols → loclist |
| `<Leader>gc` | `:GitSwitch ` — Tab complete branch; unknown name creates |
### LSP (server attached)

| Key | Action |
|-----|--------|
| `gd` | definition |
| `K` | hover docs |
| `gr` | references |
| `<Leader>rn` | rename |
| `<Leader>ca` | code actions |
| `<Leader>f` | format buffer / selection (manual; no format-on-save) |
| `<Leader>d` | buffer diagnostics → loclist |

### Git — vim-fugitive

**From any repo buffer**

| Key | Action |
|-----|--------|
| `<Leader>gs` | `:Git` status |
| `<Leader>gd` | smart `Gvdiffsplit` |
| `<Leader>gb` | `Git blame` (file) |
| `<Leader>gB` | blame current line |
| `<Leader>gl` | log current file |
| `<Leader>gL` | log / history for current line |
| `<Leader>gc` | `:GitSwitch` — Tab complete / create if missing |

**In `:Git` status — staging**

| Key | Action |
|-----|--------|
| `s` | stage |
| `u` | unstage |
| `-` | toggle stage/unstage |
| `U` | unstage all |
| `X` | discard change under cursor |
| `=` | toggle inline diff |
| `dv` / `ds` | vertical / horizontal diff vs index |
| `cc` | commit |

| Key | Action |
|-----|--------|
| **`P`** (Unpushed commit line) | pre-fills `:Git push` |
| `:Git push` / `:Git pull` | anytime |

### Git merge (`nvimdiff`)

Four buffers: **LOCAL**, **BASE**, **REMOTE**, **MERGED**. Work in **MERGED**.

| Command | Meaning |
|---------|---------|
| `:diffg LO` | take hunk from LOCAL |
| `:diffg RE` | take from REMOTE |
| `:diffput MERGED` | from LOCAL/REMOTE/BASE → push into MERGED |

`[c` / `]c` — jump between changes. Save **MERGED**, exit with `:qa`; abort with `:cq`.

### NeoCodeium (Windsurf ghost text)

| Key | Action |
|-----|--------|
| `<Leader>ko` | toggle (`:NeoCodeium! toggle` stops server) |
| `<M-Tab>` (Alt+Tab) | accept **full** suggestion |
| `<M-w>` / `<Tab>` | accept word |
| `<M-l>` | accept line |
