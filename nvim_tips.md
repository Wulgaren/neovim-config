# Neovim tips

## Motion & editing

- `gf` — open file under cursor
- `gx` — open URL under cursor
- `gd` — go to definition (LSP when available)
- `Ctrl+o` / `Ctrl+i` — jump backward / forward in the jump list
- `f{char}` — find `{char}` forward on the current line
- `o` — insert on the line below

## Change operators

- `c` — change (operator)
- `ciw` — change inner word
- `cib` — change inside `()`
- `ciB` — change inside `{}`

## Search

- `*` — search forward for the word under the cursor
- After searching: `ciw` on a match, then `n` and `.` to repeat the change on the next occurrences

## Marks

- `m` + lowercase letter — buffer-local mark
- `m` + uppercase letter — global mark (file + position)
- `'` + same letter — jump to that mark

## Save & quit

- `ZZ` — write (prompts for path if unnamed) and quit
- `ZQ` — quit current window without writing
- `ZX` — quit Neovim without writing everywhere (all windows/tabs; same as `:qa!`; unsaved buffers discarded)

---

## Window splits

Move to adjacent split

- `<C-w>` twice (`<C-w><C-w>`) also cycles windows.
- `<C-w>h` — left
- `<C-w>j` — down
- `<C-w>k` — up
- `<C-w>l` — right

Non-focused windows use a **dimmer text color** (`NormalNC`) so the active split stands out.

## Split current buffer (another window)

- Horizontal: `<C-w>s` — top/bottom
- Vertical: `<C-w>v` — left/right

---

## Other custom keymaps

- `<C-s>` — write (Normal and Insert)
- `<Esc>` in Normal — also clears search highlight
- `Q` — disabled (no Ex mode)
- `<Leader>sr` — start `:substitute` for whole buffer (Normal) or selection (Visual)
- `<Leader>p` — Visual: paste without overwriting the default register with deleted text
- `<Leader>d` — Normal/Visual: delete to the black-hole register
- `<Leader>pv` — open built-in file explorer (`Ex`)
- `<C-u>` / `<C-d>` / `<C-f>` / `<C-b>` — scroll with cursor centered
- `n` / `N` — next/prev search match, cursor centered
- Visual `J` / `K` — move selection down / up
- `=ap` — reindent a paragraph (`=` on `ap`), cursor restored with mark `a`

---

## Harpoon (`Ctrl+e` menu)

In the quick menu:

- Delete a line (e.g. `dd`) to remove that file from the list
- `q` or `Esc` applies changes and closes

---

## Custom commands, Git, Telescope, plugin keys

*Everything below is specific to this config.*

### Commands

- `:MyTips` — open this file in a horizontal split **below** the current window
- `:WQ` — same idea as `ZZ` (write, or prompt for path, then quit)

### Telescope (live grep & pickers)

- `<C-p>` — find files in the project
- `<Leader>fg / <C-h>` — live grep; in **Visual**, pre-fills the prompt from the **selection** (multi-line text is flattened to one line). **Normal** starts with an empty prompt.
- `<Leader>fb` — buffers
- `<Leader>fs` — LSP document symbols (Telescope)

### Git (vim-fugitive)

Open the summary (`:Git` / `:G` with no args) with `<Leader>gs`. In that buffer, **`g?`** lists fugitive mappings (`:h fugitive-maps`).

**Leaders from any buffer in the repo**

- `<Leader>gs` — `:Git` status
- `<Leader>gd` — `Gdiffsplit`
- `<Leader>gb` — `Git blame` (file)
- `<Leader>gB` — blame current line
- `<Leader>gl` — log current file
- `<Leader>gL` — log / history for current line

**In the `:Git` status buffer — staging**

- `s` — stage (add) the file or hunk under the cursor
- `u` — unstage (reset) the file or hunk under the cursor
- `-` — toggle stage / unstage for the item under the cursor
- `U` — unstage everything
- `X` — discard the change under the cursor (`checkout` / `clean`; an undo hint is echoed)
- `=` — toggle inline diff for the file under the cursor

**In the `:Git` status buffer — commit**

- `cc` — create a commit (opens the message buffer; write and quit to finish)
- `cvc` — commit with `-v` (verbose diff in the template)
- `ca` — amend the last commit and edit the message
- `cva` — amend with `-v`
- `ce` — amend the last commit **without** editing the message
- `cw` — reword the last commit
- `c` alone — pre-fill the command line with `:Git commit ` (add flags or a message, then press Enter)

**Push / pull**

- **`P`** (capital **P**) on a commit line in the **Unpushed** section — pre-fills `:Git push` for that commit (you still run it)
- Any time: **`:Git push`**, **`:Git pull`** (or `:G push`, `:G pull`)
- `gp` / `gP` — jump to an entry in the Unpushed / Unpulled section (`:h fugitive_gp`)

### Harpoon

- `<Leader>a` — add current file to the list
- `<Ctrl+e>` — toggle quick menu
- `<Leader>1` … `<Leader>4` — open harpoon slot 1–4
- `<Leader>hp` / `<Leader>hn` — previous / next harpoon file

### Flash

- `zk` — Flash jump (Normal, Visual, Operator-pending)

### LSP (when a server is attached)

- `gd` — go to definition
- `gr` — references
- `K` — hover documentation
- `<Leader>rn` — rename symbol
- `<Leader>ca` — code actions
- `<Leader>f` — format buffer

### blink.cmp (completion)

- `<CR>` — accept (or fallback)
- `<Tab>` / `<S-Tab>` — next / previous item; snippet forward/back; else fallback
- `<C-space>` — show completion / documentation
- `<C-e>` — hide completion (or fallback) *Harpoon’s `<C+e>` is not overwritten — blink only handles completion contexts.*

### mini.surround (`:h mini-surround`)

Prefix **`sa`** (add), **`sd`** (delete), **`sr`** (replace), plus **`sf`/`sF`** (find) and **`sh`** (highlight). The **next character** picks the *kind* of surrounding:

| Key / idea | Meaning |
|------------|---------|
| `( )`, `[ ]`, `{ }`, `< >` | Balanced pair; use **one** bracket char. Example: **`saiw}`** wraps the inner word in **`{ ... }`**. **`saiw)`** → `( ... )`. **`saiw>`** → `< ... >` (angle bracket pair, not HTML unless you use `t`). |
| **`t`** | **Tag**. Example: **`saiwt`** prompts for a name—type **`div`** and you get **`<div>...</div>`**. Works with a motion or Visual selection + `sa` then `t`. |
| **`f`** | **Function call**—prompts for a name, wraps as **`name(...)`**. |
| **`?`** | **Interactive**—you type left and right parts yourself (any pair). |

**Examples**

- **`saiw}`** — wrap inner word in `{}`
- **`saiw)`** — wrap inner word in `()`
- **`saiwt`** → type `div` — wrap in `<div>...</div>`
- Visual select lines, then **`sa}`** — wrap the selection in `{}`
- **`sd}`** — delete nearest `{ ... }` surrounding
- **`sr)}`** — replace `(...)` with `{ ... }`

### mini.ai (`:h mini-ai`, `:h MiniAi-builtin-textobjects`)

Extends **`a`…** (around) and **`i`…** (inside) textobjects for operators and Visual mode (`d`, `c`, `y`, `v`, etc.).

**Prefixes**

- **`i`** / **`a`** — default *inside* / *around* (includes whitespace rules per builtin)
- **`in` / `an`** — *next* instance of the textobject ahead
- **`il` / `al`** — *last* (previous) instance
- **`g[` / `g]`** — jump to the **left / right edge** of the `a` textobject

**Examples you will use a lot**

- **`af` / `if`** — a **function call** (the whole call vs. inside the parentheses)
- **`a` / `i` + bracket** — same idea as built-in `i(` but mini adds aliases and “balanced” variants; see help for `aB`, etc.
- **`at` / `it`** — a **tag** (e.g. HTML element, inside vs. including tags)
- **`a?` / `i?`** — **user prompt**: mini asks what to select (pattern / description)

Full lists and treesitter-based objects: **`:h MiniAi-builtin-textobjects`** and **`:h MiniAi.gen_spec`**.

### mini.comment

- **`gc`** — comment/uncomment as an operator (e.g. **`gcip`** for inner paragraph)
- **`gcc`** — comment/uncomment current line (`:h mini.comment`)

### mini.bracketed (`:h mini.bracketed`)

After **`]`** or **`[`**, a second key jumps within the buffer—**`b` / `B`** buffer, **`q` / `Q`** quickfix/location, **`c`** comment, **`d`** diagnostic, **`h`** git hunk, and more. Example: **`]b`** next buffer, **`[b`** previous.

### mini.pairs & mini.nvim

- **mini.pairs** — inserts closing pairs automatically (`:h mini.pairs`)
- Library-wide notes: **`:h mini.nvim`**
