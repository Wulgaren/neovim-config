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
| `;` | repeat previous `f`/`t`/`F`/`T` |
| `,` | same, opposite direction |
| `R` | Replace mode until `Esc` |
| `o` | insert on line below |
| `ggVG` | select all |
| `ge` / `gE` | backward to **end** of `[count]` previous word / WORD (`dge`, `3cge`, …) |
| `g&` | repeat last `:substitute` on whole buffer (`:help :&`) |
| `J` | Join **next** line into current |
| `C-o` | Add "enter" in Insert Mode|
| `C-u / C-d` | Move up/down by half a page |
| `/ or ?` | Search forwards/backwards |
| `<C-v> then <I/A>` | Visual **block** mode then insert |


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
| `gn` / `gN` | operate on **next/previous occurrence** (`dgn`, `.`, … ; see **`g*`** block under Motion above) |
| — | after search: `ciw`, then `n` and `.` to repeat on next matches |

## Marks

| Key | Action |
|-----|--------|
| `m` + letter | lowercase: buffer mark; uppercase: global mark |
| `'` + letter | jump to mark |

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
| `<C-w>h` / `j` / `k` / `l` | focus left / down / up / right |
| `<C-w>s` | split horizontal (top/bottom) |
| `<C-w>v` | split vertical (left/right) |

Non-focused windows use dimmer **NormalNC** so active split stands out.

---

## Other custom keymaps

| Key | Action |
|-----|--------|
| `<C-s>` | write (Normal & Insert) |
| `<Esc>` (Normal) | clear search highlight |
| `Q` | disabled |
| `<Leader>sr` | `:substitute` whole buffer / selection |
| `<Leader>p` | Visual: paste without overwritting default register |
| `<Leader>d` | delete without overwritting default register |
| `<Leader>pv` | built-in explorer (`Ex`) |
| `<Leader>ko` | **NeoCodeium** toggle on/off (`:NeoCodeium toggle` — completions only; no server stop) |
| `<C-u>` / `<C-d>` / `<C-f>` / `<C-b>` | scroll, cursor centered |
| `n` / `N` | next/prev match, cursor centered |
| Visual `J` / `K` | move selection down/up |
| `=ap` | reindent paragraph; mark `a` restores cursor |

---

## Commands, navigation plugins, Git, more

### Commands

| Command | Action |
|---------|--------|
| `:MyTips` | open this file below (`render-markdown` styling like other `.md`) |
| `:wq` | like `ZZ` (write or prompt, then quit) |

### Telescope

| Plugin | Key | Action |
|--------|-----|--------|
| **Telescope** | `<C-p>` | find files (project) |
| **Telescope** |  `<C-t>`, `<Leader>fg` | live grep (empty prompt) |
| **Telescope** |  `<C-h>` | list of marks | 
| **Telescope** | `<Leader>fb` | buffers |
| **Telescope** | `<Leader>fs` | LSP document symbols |


### LSP (server attached)

| Key | Action |
|-----|--------|
| `gd` | definition |
| `gr` | references |
| `K` | hover docs |
| `<Leader>rn` | rename |
| `<Leader>ca` | code actions |
| `<Leader>f` | format buffer |
| `<Leader>dd` | view inline errors (use :q to quit out of the Diagnostic window) |

### Git — vim-fugitive

**From any repo buffer**

| Key | Action |
|-----|--------|
| `<Leader>gs` | `:Git` status |
| `<Leader>gd` | `Gdiffsplit` |
| `<Leader>gb` | `Git blame` (file) |
| `<Leader>gB` | blame current line |
| `<Leader>gl` | log current file |
| `<Leader>gL` | log / history for current line |

**In `:Git` status — staging**

| Key | Action |
|-----|--------|
| `s` | stage |
| `u` | unstage |
| `-` | toggle stage/unstage |
| `U` | unstage all |
| `X` | discard change under cursor |
| `=` | toggle inline diff — **`=`** again on same line collapses |
| `dv` / `ds` | vertical / horizontal diff vs index (cursor on file line) |
| `cc` | commit (edit message buffer; `wq` to finish) |

| Key | Action |
|-----|--------|
| **`P`** (Unpushed commit line) | pre-fills `:Git push` |
| `:Git push` / `:Git pull` | anytime |
| `gp` / `gP` | jump Unpushed / Unpulled (`:h fugitive_gp`) |

### Git merge (`nvimdiff`)

Four buffers: **LOCAL**, **BASE**, **REMOTE**, **MERGED**. Work in **MERGED**.

| Command | Meaning |
|---------|---------|
| `:diffg LO` | take hunk from LOCAL |
| `:diffg RE` | take from REMOTE |
| `:diffput MERGED` | from LOCAL/REMOTE/BASE → push into MERGED |

`[c / ]c` - to jump between changes.

Save **MERGED**, exit windows; Git continues.

### blink.cmp & NeoCodeium

| Key | Action |
|-----|--------|
| `<Enter>` | accept completion item, else newline |
| `<Down>` / `<Up>` | next/prev item; snippet forward/back; fallback (same roles **Tab** / **Shift+Tab** used to have) |
| `<C-e>` | show or hide completion menu (and documentation) |

**NeoCodeium** (ghost-text AI)

| Key | Action |
|-----|--------|
| `<Leader>ko` | toggle (`:NeoCodeium toggle`; add **`!`** → `:NeoCodeium! toggle` to stop Windsurf server) |
| `<M-Tab>` (Alt+Tab) | accept **full** suggestion | 
| `<M-w> / <Tab>` | accept word |
| `<M-l>` | accept line |


### mini.surround (`:h mini-surround`)

Prefix **`sa`** add, **`sd`** delete, **`sr`** replace; **`sf`/`sF`** find, **`sh`** highlight. Next char = kind:

| Char | Meaning |
|------|---------|
| `( )`, `[ ]`, `{ }`, `< >` | one bracket — e.g. `saiw}` → `{ ... }`, `saiw)` → `( ... )`, `saiw>` → `< ... >` |
| **`t`** | tag — `saiwt`, type `div` → `<div>...</div>` |
| **`f`** | function call wrap `name(...)` |
| **`?`** | interactive left/right |

**Examples:** `saiw}`, `saiw)`, `saiwt`; Visual + `sa}`; `sd}`; `sr)}`.

### mini.ai (`:h mini-ai`, `:h MiniAi-builtin-textobjects`)

**Prefixes:** `i`/`a` inside/around; `in`/`an` next; `il`/`al` last; `g[`/`g]` jump to `a` edges.

**Useful:** `af`/`if` function call; `a`/`i`+bracket; `at`/`it` tag; `a?`/`i?` user prompt. Full list: `:h MiniAi-builtin-textobjects`.

### mini.comment

| Key | Action |
|-----|--------|
| `gc` | operator (e.g. `gcip`) |
| `gcc` | current line |

### mini.bracketed (`:h mini.bracketed`)

After `]` or `[`, second key picks a target — e.g. **`b`/`B`** buffer, **`m`/`M`** comment block (this config; default upstream is **`c`**), **`q`/`Q`** quickfix, **`d`/`D`** diagnostic, **`x`/`X`** conflict markers, etc. Examples: `]b` / `[b`, `]m` / `[m`.

### mini.pairs & mini.nvim

**mini.pairs** — auto close (`:h mini.pairs`). Library: **`:h mini.nvim`**.
