# Neovim tips

## Motion & editing

| Key | Action |
|-----|--------|
| `gf` | open file under cursor |
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

### Navigation & pickers (Telescope, Harpoon, Flash)

| Plugin | Key | Action |
|--------|-----|--------|
| **Telescope** | `<C-p>` | find files (project) |
| **Telescope** |  `<C-t>`, `<Leader>fg` | live grep; **Visual** pre-fills from selection (multi-line → one line); **Normal** empty prompt |
| **Telescope** | `<Leader>fb` | buffers |
| **Telescope** | `<Leader>fs` | LSP document symbols |
| **Harpoon** | `<Leader>a` | add current file |
| **Harpoon** | `<Ctrl+e>` | toggle quick menu |
| **Harpoon** | `<Leader>1` … `<Leader>4` | open slot 1–4 |
| **Harpoon** | `<Leader>hp` / `<Leader>hn` | prev / next harpoon file |
| **Flash** | `zk` | Flash jump (Normal, Visual, Operator-pending) |

In **Harpoon** quick menu (`<Ctrl+e>`): `dd` on a line removes that file; `q` / `Esc` applies and closes.

### LSP (server attached)

| Key | Action |
|-----|--------|
| `gd` | definition |
| `gr` | references |
| `K` | hover docs |
| `<Leader>rn` | rename |
| `<Leader>ca` | code actions |
| `<Leader>f` | format buffer |

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
| `=` | toggle inline diff |
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

Save **MERGED**, exit windows; Git continues.

### blink.cmp

| Key | Action |
|-----|--------|
| `<Enter>` | accept |
| `<Tab>` / `<S-Tab>` | next/prev; snippet fwd/back |
| `<C-space>` | completion / docs |
| `<C-e>` | hide (Harpoon `<C-e>` unchanged outside completion) |

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

After `]` or `[`, second key: **`b`/`B`** buffer, **`q`/`Q`** quickfix, **`c`** comment, **`d`** diagnostic, **`h`** git hunk, etc. e.g. `]b` / `[b`.

### mini.pairs & mini.nvim

**mini.pairs** — auto close (`:h mini.pairs`). Library: **`:h mini.nvim`**.
