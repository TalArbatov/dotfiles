# Dotfiles: workstation, NAS, and MacBook

Shared configuration and machine-specific profiles, managed with Git and GNU Stow.

This README records the working setup established on **24 October 2026**. It is intended for day-to-day use, recovery, and handoff to a future assistant. Configuration files and live command output take precedence if they disagree with this document.

## Start here

- Repository on the Linux machines: `~/dotfiles` (`/home/pio/dotfiles`).
- Workstation: Fedora 43, Hyprland, Kitty, Zsh, outer tmux session `workstation`.
- NAS: Debian 13 Trixie, host `homeserver`, inner tmux session `homelab`.
- Workstation shortcut: `nas` connects through the existing SSH alias `ssh nas` and attaches to `homelab`.
- Outer tmux prefix: **Ctrl+A**. NAS tmux prefix: **Ctrl+B**.
- Workstation desktop modifier: **Super / Windows**. Workstation tmux window selection: **Alt+1…9**.
- Linux Neovim uses `lazy-lock-linux.json`. The MacBook retains `lazy-lock.json` and its original Tree-sitter setup.
- Install only the Stow packages appropriate to the machine. Do not run `stow *`.

The repository is a configuration source, not a complete machine backup. It does not preserve running processes, terminal sessions across reboot, SSH credentials, installed packages, or NAS service data.

## Contents

1. [Scope and maintenance principles](#scope-and-maintenance-principles)
2. [Machine inventory](#machine-inventory)
3. [Repository packages](#repository-packages)
4. [Git and Stow](#git-and-stow)
5. [Installation and machine profiles](#installation-and-machine-profiles)
6. [Everyday terminal workflow](#everyday-terminal-workflow)
7. [Navigation reference](#navigation-reference)
8. [Clipboard and scrollback](#clipboard-and-scrollback)
9. [tmux configuration and appearance](#tmux-configuration-and-appearance)
10. [Neovim](#neovim)
11. [Updating and validating changes](#updating-and-validating-changes)
12. [Troubleshooting and recovery](#troubleshooting-and-recovery)
13. [Coverage gaps and backlog](#coverage-gaps-and-backlog)
14. [Guidance for future assistants](#guidance-for-future-assistants)
15. [References](#references)

## Scope and maintenance principles

The goal is consistent workflows across machines without forcing every machine to have identical settings.

- Keep common behavior shared; use explicit machine profiles for differences.
- Preserve the MacBook's existing behavior when changing Linux workflows.
- Make small changes and verify them on the affected machine before distributing them.
- Inspect existing files and links before replacing them.
- Keep unrelated changes out of a commit.
- Prefer documented, compatible tool versions over upgrading everything to satisfy one plugin.
- Treat optional health warnings as information until a required feature is affected.
- Document prerequisites that are not installed by Stow.
- Keep secrets, private keys, generated plugin directories, caches, and machine data outside the repository.

This repository documents terminal/editor/desktop configuration. The broader homelab knowledge base should link here for these details; NAS service architecture, Docker deployments, storage, and data backup belong in that broader documentation.

## Machine inventory

These are observed versions from this setup session, not promises about the newest available releases.

| Component | Workstation | NAS | MacBook |
| --- | --- | --- | --- |
| OS | Fedora 43 | Debian 13 Trixie | macOS; version not inspected here |
| User | `pio` | `pio` | Not inspected here |
| Desktop | Hyprland 0.54.3 | Accessed remotely | macOS desktop |
| Terminal | Kitty | Rendered by the connecting workstation's terminal | Kitty used previously; current config not inspected |
| Shell | Zsh | Zsh | Existing shared workflow; current details not inspected |
| tmux | 3.7c, executable and running server verified | Upgraded to 3.7c from official Trixie Backports; server restarted | Current version not inspected |
| Neovim | 0.11.6 | Official 0.11.6 archive installed separately from Debian's package | Current version not inspected |
| Tree-sitter CLI | 0.25.10 | Version not recorded here | Version not inspected |
| Node.js | 22.22.0 observed | Node.js and npm installed; exact versions not recorded | Not inspected |
| Local clipboard tool | `/usr/bin/wl-copy` | OSC 52 through SSH/tmux; no NAS desktop clipboard required | Existing `pbcopy` bindings retained |

The workstation and NAS fixes were reported working. The MacBook was not directly retested during this session; its existing configuration path was deliberately preserved.

### NAS installation details

- tmux package installed: `3.7c-1~bpo13+1`, from `trixie-backports`.
- Backports source file: `/etc/apt/sources.list.d/trixie-backports.sources`.
- Old tmux executable retained at `~/.local/libexec/tmux-3.5a` as a migration fallback. It is not the normal launcher.
- Neovim archive installation: `/opt/neovim-0.11.6`.
- Neovim launcher: `/usr/local/bin/nvim`, linked to `/opt/neovim-0.11.6/bin/nvim`.
- Debian's `/usr/bin/nvim` was 0.10.4 and remains a separate package-managed installation.

The `/opt` Neovim installation needs an explicit future update process; ordinary APT updates do not manage that installation.

## Repository packages

Each top-level package contains paths relative to the target home directory.

| Package | Important contents / targets | Intended use |
| --- | --- | --- |
| `tmux` | `.tmux.conf` → `~/.tmux.conf` | Shared tmux foundation |
| `tmux-workstation` | `.tmux.local.conf` → `~/.tmux.local.conf` | Fedora workstation overrides |
| `tmux-nas` | `.tmux.local.conf` → `~/.tmux.local.conf` | NAS overrides |
| `nvim` | `.config/nvim/` → `~/.config/nvim/` | Shared editor config with Linux compatibility selection |
| `kitty-workstation` | `.config/kitty/kitty.conf` | Workstation Kitty configuration |
| `hyprland-workstation` | `.config/hypr/configs/Keybinds.conf`; `.config/hypr/UserConfigs/UserKeybinds.conf` | Workstation desktop modifier and bindings |
| `workstation-tools` | `.local/bin/nas` | Workstation NAS launcher |
| `zsh` | Contents need a separate inventory | Existing shell package; do not assume active on every machine |

`tmux-workstation` and `tmux-nas` both target the same filename. Install **one**, according to the machine.

A root-level file named `test` was present in the inventory. Its purpose has not been established. It is not part of the documented installation procedure.

### Important shared files

| File in repository | Role |
| --- | --- |
| `tmux/.tmux.conf` | Shared tmux settings and plugins; loads the selected profile at the end |
| `tmux-workstation/.tmux.local.conf` | Local clipboard, scrolling, appearance, and workstation theme overrides |
| `tmux-nas/.tmux.local.conf` | NAS clipboard, scrolling, Ctrl+B prefix, and compact status bar |
| `nvim/.config/nvim/init.lua` | Leaders, `jk` insert-mode escape, and configuration entry points |
| `nvim/.config/nvim/lua/config/lazy.lua` | lazy.nvim bootstrap and OS-dependent lockfile selection |
| `nvim/.config/nvim/lua/plugins/treesitter.lua` | Linux compatibility branch and original non-Linux configuration |
| `nvim/.config/nvim/lazy-lock-linux.json` | Linux plugin revisions |
| `nvim/.config/nvim/lazy-lock.json` | Original non-Linux plugin revisions, retained for the MacBook |

## Git and Stow

**Git synchronizes repository files. Stow connects those files to the paths applications read.**

For example, the workstation's `~/.tmux.conf` points to `~/dotfiles/tmux/.tmux.conf`. Editing through either path edits the same underlying file.

Stow does not merge two configuration files, resolve their differing contents, synchronize between machines, or install software. Shared-plus-profile behavior works because tmux explicitly sources both files.

Stow may link a whole directory or individual files depending on what already exists in the target. Use `readlink -f` to discover the actual destination; do not rely solely on whether the final file itself looks like a symlink.

### Stow command reference

```sh
# Preview an installation; -n performs no changes.
stow -n -v -d ~/dotfiles -t "$HOME" tmux

# Install a package's links.
stow -v -d ~/dotfiles -t "$HOME" tmux

# Reconcile an installed package after its layout changes.
stow -R -d ~/dotfiles -t "$HOME" tmux

# Remove links owned by a package, leaving repository files in place.
stow -D -d ~/dotfiles -t "$HOME" tmux
```

A pull that changes an already-linked file normally needs no Stow refresh. New files or a changed package layout may require restowing. Reload or restart the affected application separately.

If Stow reports a conflict with a regular local file, inspect and back it up first. Do not use `--adopt` without understanding that it moves existing target files into the repository and can change repository contents.

## Installation and machine profiles

### Before installing on any machine

1. Ensure Git and GNU Stow are installed.
2. Clone this repository to `~/dotfiles` using its actual remote URL. The remote URL is intentionally not guessed in this document.
3. Install the required applications and dependencies separately.
4. Inspect existing configuration files, including files reached through directory symlinks.
5. Run the relevant Stow command in preview mode first.
6. Resolve conflicts by comparison and backup, then run the actual command.
7. Validate the active links and application behavior.

Useful inspection commands:

```sh
git -C ~/dotfiles remote -v
git -C ~/dotfiles status --short
ls -l ~/.tmux.conf ~/.tmux.local.conf
readlink -f ~/.config/nvim/init.lua
readlink -f ~/.config/kitty/kitty.conf
```

### Workstation packages

Preview:

```sh
stow -n -v -d ~/dotfiles -t "$HOME" \
  tmux tmux-workstation nvim \
  kitty-workstation hyprland-workstation workstation-tools
```

After resolving any reported conflicts:

```sh
stow -v -d ~/dotfiles -t "$HOME" \
  tmux tmux-workstation nvim \
  kitty-workstation hyprland-workstation workstation-tools
```

This is the intended package selection, not a complete unattended workstation bootstrap. Kitty themes and Hyprland's surrounding configuration/scripts still require the external files described under coverage gaps.

Confirm that `~/.local/bin` is on the shell's PATH:

```sh
command -v nas
```

Expected launcher path: `/home/pio/.local/bin/nas`. In Zsh, run `rehash` after installing a new executable if necessary. If the command is still missing, inspect PATH before changing shell files.

### NAS packages

Preview, then install after resolving conflicts:

```sh
stow -n -v -d ~/dotfiles -t "$HOME" tmux tmux-nas nvim
stow -v -d ~/dotfiles -t "$HOME" tmux tmux-nas nvim
```

If the workstation profile was mistakenly installed on the NAS, switch explicitly:

```sh
stow -D -d ~/dotfiles -t "$HOME" tmux-workstation
stow -d ~/dotfiles -t "$HOME" tmux-nas
```

Inspect `~/.tmux.local.conf` to confirm the NAS profile is selected before reloading.

### MacBook

Keep its existing Stow package selection. The MacBook's complete active package inventory has not been inspected here, so this document does not prescribe a fresh Mac installation command.

- Do not install `tmux-workstation`, `tmux-nas`, `kitty-workstation`, `hyprland-workstation`, or `workstation-tools` on it as part of a Linux rollout.
- Shared tmux retains the original `pbcopy` bindings and Ctrl+A prefix.
- No new tmux local profile is required on the MacBook for these Linux fixes.
- Non-Linux Neovim retains `lazy-lock.json` and the existing newer Tree-sitter API configuration.
- Pulling downloads files; selecting workstation packages or updating shared plugin revisions is a separate action.

Future edits to genuinely shared settings can still affect the MacBook. Profiles are a boundary to maintain, not a blanket guarantee that every future repository change is isolated.

### Shell configuration caveat

The workstation's `~/.zshrc` was observed as a regular file, not a Stow symlink. The presence of a `zsh` directory in the repository does not prove that its configuration is active. Inspect and compare before stowing it.

## Everyday terminal workflow

### What each layer does

| Layer | Responsibility |
| --- | --- |
| Hyprland | Desktop windows, workspaces, and desktop keybindings |
| Kitty | Terminal rendering, font, terminal keyboard/mouse events, desktop clipboard access |
| Zsh | Shell prompt, commands, aliases, functions, and PATH |
| Local tmux | Persistent local sessions, windows, panes, and scrollback |
| SSH | Connection to the NAS |
| NAS tmux | Persistent NAS sessions, windows, panes, and scrollback |

Kitty and tmux have different jobs. Keeping tmux does not remove the need for a terminal emulator. Kitty was retained; no Alacritty migration is part of this setup.

### Opening a workstation terminal

The workstation Kitty configuration contains:

```conf
shell /usr/bin/env -u TMUX tmux new-session -A -s workstation
```

New Kitty terminals attach to `workstation`, or create it if absent. Clearing inherited `TMUX` lets a newly launched emulator attach even when its launcher inherited a tmux environment.

Multiple Kitty terminals attached to the same session share its active tmux window. They are multiple views of the same session, not independent workspaces. Use tmux windows/panes for the current workflow; independent views would need a separately designed session arrangement.

To create or attach manually from a plain local terminal:

```sh
tmux new-session -A -s workstation
```

An explicit plain-shell escape hatch from an existing terminal is:

```sh
kitty /bin/zsh
```

This supplies a command for that Kitty launch instead of using the configured tmux startup command.

### Connecting to the NAS

From a local tmux window, run:

```sh
nas
```

The launcher stored at `workstation-tools/.local/bin/nas` is:

```sh
#!/bin/sh
exec ssh -t nas 'tmux new-session -A -s homelab'
```

`ssh nas` remains the ordinary SSH connection. `nas` additionally attaches to the named remote tmux session. The SSH host alias must already be configured; its address, user, keys, and authentication settings are not supplied by this launcher.

To create a dedicated local NAS window: press **Ctrl+A**, release, then **c**; type `nas` in the new shell.

### Leaving and reconnecting

- **Ctrl+B, d** detaches NAS tmux. With the launcher, the remote command finishes and SSH returns to the local tmux window.
- **Ctrl+A, d** detaches local tmux. A Kitty terminal whose direct child is tmux will normally close when that client exits.
- Closing a terminal or losing SSH does not normally terminate the detached tmux sessions.
- Reconnect with Kitty or `nas` to return to the named session.
- Reboots, server termination, or killing a session do terminate its running processes. Persistent sessions are not reboot restoration or backups.
- `exit` ends the current shell/pane; it is different from detaching.

## Navigation reference

In this table, a comma means press the prefix, release it, then press the following key. Letters are lowercase unless shown otherwise.

| Action | Workstation / outer tmux | NAS / inner tmux |
| --- | --- | --- |
| Prefix | Ctrl+A | Ctrl+B |
| New tmux window | Ctrl+A, c | Ctrl+B, c |
| Window chooser | Ctrl+A, w | Ctrl+B, w |
| Session chooser | Ctrl+A, s | Ctrl+B, s |
| Window number | Alt+1…9, or Ctrl+A, number | Ctrl+B, number |
| Next / previous window | Ctrl+A, n / p | Ctrl+B, n / p |
| Previous active window | Ctrl+A, Tab | Ctrl+B, Tab |
| Split into left/right panes | Ctrl+A, `\|` | Ctrl+B, `\|` |
| Split into top/bottom panes | Ctrl+A, `-` | Ctrl+B, `-` |
| Move between panes | Ctrl+A, h / j / k / l | Ctrl+B, h / j / k / l |
| Resize panes | Ctrl+A, H / J / K / L | Ctrl+B, H / J / K / L |
| Enter copy mode | Ctrl+A, `[` | Ctrl+B, `[` |
| Reload config | Ctrl+A, r | Ctrl+B, r |
| Detach | Ctrl+A, d | Ctrl+B, d |

For resizing, the bindings are repeatable; use the configured repeat interval rather than assuming modifier-held desktop behavior. Inspect `tmux list-keys` for the exact active binding.

Alt+numbers are consumed by outer tmux, so they are not the direct NAS window-switching shortcut when nested. Use the NAS prefix and number.

The workstation's Super key is reserved for Hyprland's configured desktop operations. Existing explicit Alt+Tab behavior was left alone. Previously, Kitty mapped Super+numbers to Alt+numbers; those nine mappings were removed so Super can reach the desktop.

## Clipboard and scrollback

### The three buffers to distinguish

| Buffer | Typical use |
| --- | --- |
| Desktop clipboard | Browser Ctrl+C/Ctrl+V; terminal Ctrl+Shift+C/Ctrl+Shift+V |
| Primary selection | Usually text selected with the mouse, pasted with middle click where supported |
| tmux paste buffer | tmux's own copied text; can be synchronized to the terminal clipboard |

Middle click and Ctrl+V need not paste the same content. Copying into tmux's buffer alone does not prove the desktop clipboard was updated.

### Mouse copying in tmux

`mouse on` lets tmux handle selection and scrolling. The Linux profiles bind mouse release to:

```tmux
bind -T copy-mode MouseDragEnd1Pane send-keys -X copy-selection-and-cancel
bind -T copy-mode-vi MouseDragEnd1Pane send-keys -X copy-selection-and-cancel
```

Drag to select text, then release. The selection is copied and copy mode exits; the highlight disappearing on release is intentional.

For terminal-native selection bypassing tmux mouse handling, hold **Shift** while dragging in Kitty, then use **Ctrl+Shift+C**. This operates on Kitty's terminal view, which is distinct from tmux's stored pane history.

### Keyboard copying

1. Enter copy mode with the appropriate prefix followed by `[`.
2. Move to the start of the desired text using arrow keys or vi motions.
3. Press lowercase **v** to begin selection.
4. Move to the end.
5. Press lowercase **y** or **Enter** to copy and exit.

Do not hold the mouse while following this keyboard procedure. Pressing `v` starts a new selection at the current cursor; it does not confirm an earlier mouse selection.

Paste into a browser with **Ctrl+V**. Paste into Kitty with **Ctrl+Shift+V**. Inside a terminal, plain Ctrl+C is normally an interrupt and plain Ctrl+V can have shell/editor-specific meaning.

### Copying through nested tmux and SSH

The intended path is: NAS tmux sends an OSC 52 clipboard request through SSH; workstation tmux accepts and forwards it; Kitty updates the workstation clipboard.

The workstation profile uses `set -s set-clipboard on` so inner clipboard requests can be accepted. The NAS profile also uses `on` in the current setup. Linux keyboard copy bindings use `copy-selection-and-cancel`, avoiding the Mac-only `pbcopy` command.

The shared configuration still contains `pbcopy`; later Linux profile bindings override it. This is intentional until the duplicate-settings cleanup is done.

### Scrolling and long selections

The `0/460`-style indicator is a scrollback-position/history indicator, not a maximum number of lines that can be copied. The common history limit is 100000 lines; existing panes can retain the limit they had when created.

The earlier selection failure occurred when scrolling down to the live screen exited copy mode. The saved Linux wheel bindings enter copy mode without that forced exit and only cancel at the bottom when no selection is active:

```tmux
bind-key -n WheelUpPane if-shell -F \
    '#{||:#{alternate_on},#{||:#{pane_in_mode},#{mouse_any_flag}}}' \
    'send-keys -M' 'copy-mode'

bind-key -T copy-mode-vi WheelDownPane \
    'select-pane; send-keys -X -N 5 scroll-down; if-shell -F "#{&&:#{==:#{scroll_position},0},#{==:#{selection_present},0}}" "send-keys -X cancel"'
```

The WheelDown command sequence is intentionally quoted as one argument. An earlier incorrectly escaped shell command installed only part of the binding and broke scrolling down. Prefer editing the configuration file and sourcing it over repeatedly translating this binding into shell quoting.

## tmux configuration and appearance

### Loading order

The shared configuration ends with:

```tmux
source-file -q ~/.tmux.local.conf
```

The selected profile therefore overrides earlier shared settings, including keyboard copy bindings. The MacBook can continue without this optional profile.

The common file currently initializes TPM before its final machine-profile source. Despite the existing “TPM must remain last” comment, there are settings after it. This ordering is relevant to the theme override and is a known cleanup item.

### Common behavior recorded in the shared file

- Ctrl+A prefix and a binding to send a literal prefix.
- Mouse support, focus events, 100000-line history, and zero escape delay.
- Window and pane numbering starts at 1; windows renumber after removal.
- Automatic window names, with application-driven renaming disabled.
- New windows/splits start in the active pane's directory.
- vi-style copy mode and h/j/k/l pane navigation.
- `tmux-256color` for panes, Kitty RGB features, extended keys, and passthrough.
- Status bar at the bottom and activity monitoring.
- TPM, tmux-sensible, and Dracula (`dracula/tmux#v3.2.0`).

Use the actual current file when checking an exact option. The repository has not yet undergone the planned duplicate-settings cleanup.

### Workstation appearance

The outer status bar retains Dracula styling. Battery output was removed because this is a desktop PC. Its selected modules are:

```tmux
set -g @dracula-plugins "cwd ram-usage time"
```

The workstation profile reruns `~/.tmux/plugins/tmux/dracula.tmux` after setting the modules. This currently works but duplicates theme initialization and is scheduled for simplification.

The former 63% reading was not confirmed to be a meaningful workstation battery reading; its exact source was not diagnosed. Do not document it as a real PC battery level.

### NAS appearance

The NAS uses a compact, flat status bar with cyan accents, machine/session identity, current directory, and a Ctrl+B reminder. It omits battery, AC, and a second clock because the workstation's outer bar already supplies time.

The flat design also avoids depending on angled Powerline separators in the nested bar. Glyph rendering ultimately depends on the local terminal/font; a remote graphics-driver update is not the default remedy for missing separator glyphs.

### Versions and reloads

```sh
tmux -V
tmux display-message -p '#{version}'
tmux source-file ~/.tmux.conf
```

`tmux -V` reports the executable version; `#{version}` reports the connected server version. After a package upgrade, the existing server can keep running the old binary. Sourcing configuration does not replace that server.

Lowercase `tmux -v` enables logging; it is not the version flag. `tmux --version` is not the supported version command used here.

During the NAS upgrade, a tar operation was allowed to finish before the old tmux server was terminated and replaced. Repeat that process only after checking running work. `kill-server` closes all sessions and is not a routine reload command.

## Neovim

### Configuration entry points

`init.lua` sets Space as leader/local leader and maps insert-mode `jk` to Escape, then loads:

```lua
require("config.options")
require("config.keymaps")
require("config.lazy")
```

lazy.nvim imports plugin specifications from `lua/plugins/`.

### OS-dependent plugin versions

The current lazy.nvim setup selects its lockfile with:

```lua
require("lazy").setup("plugins", {
  lockfile = vim.fn.stdpath("config")
    .. (vim.fn.has("linux") == 1 and "/lazy-lock-linux.json" or "/lazy-lock.json"),
})
```

Both Fedora and Debian satisfy this Linux check. It is an OS distinction, not a hostname-specific profile. Other non-Linux systems would use the original path too; Windows support has not been tested.

The pending workstation plugin revisions were copied into the Linux lockfile. The original shared lockfile was returned to its committed version so those updates would not silently become MacBook updates.

In Neovim, verify the active file with:

```vim
:lua print(require("lazy.core.config").options.lockfile)
```

Use `:Lazy restore` to align installed plugins with the selected lockfile. Use a targeted command such as `:Lazy update nvim-treesitter` when intentionally updating one plugin. Review lockfile changes before committing them.

Separate lockfiles describe different intended plugin versions; they do not install external tools or guarantee compatibility after an arbitrary Neovim upgrade.

### Tree-sitter compatibility

The previously selected `main` rewrite required Neovim 0.12 nightly and Tree-sitter CLI 0.26.1+, while the workstation had Neovim 0.11.6 and CLI 0.25.10.

The Linux configuration now selects `master` and uses `require("nvim-treesitter.configs").setup`. That branch is provided for compatibility with Neovim 0.10/0.11 and CLI versions up to 0.25.x. It is frozen; it is not a permanent upgrade path to Neovim 0.12.

The MacBook retains its previous newer-API configuration. Its actual tool versions and compatibility were not re-audited here. Preserving that path is not a claim that every upstream requirement has been independently verified on the MacBook.

The configured language list remains:

`javascript`, `typescript`, `tsx`, `html`, `css`, `json`, `lua`, `bash`, `yaml`, `toml`, `markdown`, `markdown_inline`.

Linux uses `ensure_installed` with highlighting enabled and `auto_install = false`. Other languages may already be installed locally. The non-Linux configuration keeps its original explicit FileType highlighting autocmd.

There is a transitional warning if Linux loads the new configuration while the old plugin checkout is still installed. Follow it with `:Lazy update nvim-treesitter`, then restart. A warning that persists after restoration needs investigation rather than dismissal.

### Mason and external dependencies

The NAS's remaining startup errors came from Mason trying to install `vtsls` and `eslint-lsp` without `npm`. Installing Node.js/npm and running the following resolved those errors:

```vim
:MasonInstall vtsls eslint-lsp
```

Mason installs editor tooling; those tools can still need external runtimes or compilers. The npm `neovim` provider package is a different optional integration from the npm command Mason uses for JavaScript tooling.

The prior health report included missing Go, Cargo, Ruby, Composer, PHP, Java, Julia, and LuaRocks. Install them only for tools that actually require them. Lazy explicitly reported that no installed plugin needed LuaRocks, so its missing hererocks environment was left alone.

blink.cmp's dynamically enabled-source notice and which-key's informational mapping overlaps did not require changes. Specialized YAML filetype warnings remain reviewable if actual Docker Compose, GitLab, or Helm language-server behavior fails; they were not individually resolved here.

### Health checks

```vim
:checkhealth
:checkhealth nvim-treesitter
:Mason
:MasonLog
```

To export an active health buffer:

```vim
:lua vim.fn.writefile(vim.api.nvim_buf_get_lines(0, 0, -1, false), "/tmp/nvim-health.txt")
```

Then, in a terminal on the same machine:

```sh
rg -n -C 5 'ERROR|WARNING' /tmp/nvim-health.txt
```

If ripgrep is unavailable, use `grep -n -C 5 -E 'ERROR|WARNING' /tmp/nvim-health.txt`.

### Python parser conflict resolved on the workstation

After the branch change, Python highlighting failed on an invalid `except*` node. Updating the parser alone did not fix it. Neovim found these two files in order:

1. `~/.local/share/nvim/site/parser/python.so`
2. `~/.local/share/nvim/lazy/nvim-treesitter/parser/python.so`

The first parser shadowed the newly updated compatible one. With Neovim closed, it was moved into a unique backup directory under `~/.local/state/dotfiles-backups/python-parser.*`. Restarting Neovim resolved the error.

This was a workstation-local runtime repair, not a tracked configuration change. Do not automatically delete or move every parser on another machine. Inspect its actual search results first:

```vim
:lua print(vim.inspect(vim.api.nvim_get_runtime_file("parser/python.*", true)))
```

## Updating and validating changes

### Normal Git workflow

```sh
git -C ~/dotfiles status --short
git -C ~/dotfiles diff
```

Stage explicit relevant paths, inspect the staged diff, and check formatting:

```sh
git -C ~/dotfiles diff --cached
git -C ~/dotfiles diff --cached --check
```

Commit with a description of the resulting behavior, then push. On another machine, inspect local changes before using `git pull --ff-only`. Stop and compare if local edits or divergence prevent the pull; do not force-reset to bypass them.

A clean working tree only establishes that local files match the current commit. Check push output or `git status -sb` to establish whether commits reached the remote.

### Applying updates on the NAS

1. Save and close running Neovim instances so an old instance cannot rewrite a lockfile during migration.
2. Inspect repository status and pull the intended commit.
3. Restow only if links/package layout require it.
4. Open Neovim and confirm `lazy-lock-linux.json` is selected.
5. Run `:Lazy restore`, wait for completion, and restart.
6. Run `:TSUpdate`, wait for parser installation, and restart.
7. Run the targeted Tree-sitter health check and open a representative source file.

During this session the NAS rollout was followed by a report of no errors. Keep per-machine validation explicit on future changes.

### Validation checklist

| Area | Check |
| --- | --- |
| Local startup | A new Kitty terminal reports `workstation` with `tmux display-message -p '#S'` |
| NAS launcher | `nas` attaches to `homelab`; Ctrl+B, d returns locally |
| Desktop keys | Super reaches Hyprland; Alt+numbers selects outer tmux windows |
| Copy | Mouse release copies; paste into the browser succeeds |
| Long selection | Scroll down across the live screen during a selection without losing it early |
| Normal scroll | Scroll up and down; bottom exits copy mode when no selection is active |
| NAS copy | Copy inside remote tmux and paste into the workstation browser |
| Prefixes | Ctrl+A acts locally; Ctrl+B acts on the NAS |
| Status bars | Workstation shows one clock and no battery; NAS shows compact identity and no duplicate clock |
| Editor | Clean startup, targeted health check, and highlighting in a representative JS/TS file |
| Git | Intended files committed; remote synchronized; unrelated files untouched |

## Troubleshooting and recovery

### Copying only works while holding the mouse

Check which layer handles the selection. For tmux copying, release should trigger the saved MouseDragEnd binding. For Kitty-native copying, hold Shift while selecting and use Ctrl+Shift+C.

Run these on the affected tmux server:

```sh
tmux show-options -s set-clipboard
tmux show-options -gv mouse
tmux list-keys -T copy-mode-vi | grep -E 'MouseDrag|Wheel|copy-pipe|copy-selection'
tmux info | grep 'Ms:'
```

`Ms` is the terminal clipboard capability. Verify the outer server too when the problem occurs inside the NAS. Changing only the inner configuration cannot repair every outer forwarding issue.

### A Linux copy binding still calls pbcopy

Inspect the link and the final shared-config lines:

```sh
ls -l ~/.tmux.conf ~/.tmux.local.conf
tail -n 5 ~/.tmux.conf
tmux list-keys -T copy-mode-vi | grep -E 'Enter|copy-pipe|copy-selection'
```

The selected Linux profile must be sourced after the shared bindings. Reload the affected server after correcting the file/link.

### Unsupported tmux option

The NAS's old tmux 3.5a rejected `copy-mode-selection-style` and the `spaces` value for pane borders. Temporary NAS overrides removed those settings; tmux was subsequently upgraded to 3.7c.

Check both executable and server versions before treating an option error as a Stow problem. Verify that the NAS profile is installed rather than the workstation profile.

### Scrolling down stops working

Inspect the complete active WheelDown binding. It must include scrolling and the conditional cancel, not only `select-pane`. Use the saved quoted command sequence under clipboard/scrollback. Test alternate-screen applications separately because their mouse events are deliberately forwarded.

### An SSH terminal reports an unknown terminal type

Kitty's external terminal type is typically `xterm-kitty`; tmux panes use `tmux-256color` from this configuration. Check `echo "$TERM"` in the relevant layer and whether its terminfo is installed on the host:

```sh
infocmp "$TERM"
```

Do not globally overwrite TERM to hide the error. Supply appropriate terminfo or use a supported connection setup after inspecting the actual host. The exact terminfo bootstrap is a remaining documentation task.

### A new Kitty window mirrors another window

That is expected when both attach to the same `workstation` session. This is not a lost terminal or an SSH error. Revisit the session model only if independent physical terminal views become a requirement.

### A parser/query error survives TSUpdate

Restart Neovim, inspect `nvim_get_runtime_file` for that parser, and compare search order with the active plugin branch. Preserve conflicting files in a backup outside runtimepath before removing them from discovery. Also inspect custom query files if the parser itself is correct.

### Rollback

Inspect `git log` and the relevant diff first. For a published change, use a new revert commit so history remains understandable. Preserve uncommitted work before a rollback.

Restoring a configuration commit does not automatically restore installed plugins or parsers. After choosing a compatible config/lockfile pair, use `:Lazy restore`, rebuild/update its parsers, and restart.

Known local backup locations from this session:

- `~/.local/state/dotfiles-backups/nvim-*`: lazy.lua and the original pending lockfile.
- `~/.local/state/dotfiles-backups/treesitter-*`: earlier Tree-sitter configuration.
- `~/.local/state/dotfiles-backups/python-parser.*`: shadowing workstation Python parser.
- `~/.config/kitty/kitty.conf.before-tmux-startup`: Kitty config before automatic tmux attachment.
- `.before-super-alt` files were created during the desktop modifier change; inspect their actual locations before relying on them.

Backups are local recovery aids, not automatically replicated by Git. When backing up a configuration symlink, copy its contents (for example, `cp -L`) if the goal is an independent historical copy; another symlink to the live target is not a snapshot.

## Coverage gaps and backlog

### Current limitations

| Gap | Consequence / next action |
| --- | --- |
| Kitty includes `./kitty-themes/01-Wallust.conf` | A fresh checkout lacks a documented source/generation process for the theme |
| Only two Hyprland keybinding files were added | Full Hyprland includes, scripts, themes, and dependency graph still need inventory |
| Workstation `.zshrc` is a regular file | Shell behavior is not yet proven reproducible from the `zsh` package |
| SSH alias `nas` exists outside the launcher | Document a sanitized Host template and its required identity/connection setup |
| Manual NAS Neovim installation | Document verified installation/update procedure and runtime provenance |
| tmux plugins live outside tracked files | TPM/plugin installation and theme version verification need a tested bootstrap |
| Fonts/terminfo not fully inventoried | Fresh-machine glyph rendering and terminal capabilities may differ |
| Frozen Tree-sitter compatibility branch | A future Neovim 0.12 migration needs coordinated API, CLI, parser, and lockfile work |
| Non-Linux editor versions not inspected | MacBook compatibility still needs a separate read-only audit before changing its behavior |
| Unknown root `test` file | Identify purpose before retaining or removing |

### Next work, in order

1. **Commit this baseline documentation.** Keep the current working behavior available as a reference.
2. **Simplify tmux.** Inspect the complete common/profile files and active options; consolidate clipboard settings; keep machine overrides explicit; remove duplicate Dracula initialization only after preserving the final appearance. Test workstation and NAS before publishing. Preserve MacBook behavior.
3. **Complete configuration coverage.** Inventory referenced Kitty/Hyprland files and shell entry points. Decide for each whether it is shared source, a machine profile, generated output, or an external dependency. Keep generated theme ownership clear.
4. **Document and test bootstrap.** Record required package versions, plugin setup, fonts, terminfo, SSH alias setup, and PATH. Start with dry-run checks; a fully unattended installer is not implemented yet.
5. **Update this README to the final layout.** Remove stale duplication notes when the actual cleanup is complete and record validation per machine.

Clipboard history, more desktop UI polish, session restoration across reboot, and independent terminal-view layouts can be considered later. They are not installed or configured merely by being listed here.

## Guidance for future assistants

Read this document, then inspect the repository and the actual machine before editing.

1. Establish which machine and tmux layer a command runs on. The same username/home path on both Linux hosts does not identify the host.
2. Check Git status, active symlinks, selected profile, executable versions, and running-server versions.
3. Distinguish verified state from plans and historical workarounds. Recent observed output wins over this dated snapshot.
4. Preserve MacBook behavior. Do not install Linux Stow packages there or write Linux plugin revisions into its lockfile.
5. Make scoped changes and inspect the resulting diff. Do not rewrite unrelated shell/editor settings or add optional toolchains just to clear warnings.
6. Verify actual features: mouse copy, browser paste, long selection, both scroll directions, nesting, keys, status bars, and editor startup/highlighting.
7. Check active jobs before any session/server termination. No routine reload requires killing tmux.
8. Treat upstream `main` branches as potentially incompatible; read the requirements of the installed/pinned revision.
9. Keep reusable configuration knowledge here and link from the broader homelab knowledge base. Do not duplicate service/storage documentation into this repository without a reason.
10. Update documentation when behavior, dependencies, or file ownership changes. Never label unimplemented automation or untested restoration as complete.

## References

These sources explain tool behavior. The machine-specific inventory and decisions above come from observed configuration and troubleshooting in this setup session.

- [GNU Stow manual](https://www.gnu.org/software/stow/manual/)
- [tmux getting started](https://github.com/tmux/tmux/wiki/Getting-Started)
- [tmux clipboard guide](https://github.com/tmux/tmux/wiki/Clipboard)
- [Kitty configuration](https://sw.kovidgoyal.net/kitty/conf/)
- [OpenSSH ssh manual](https://man.openbsd.org/ssh.1)
- [lazy.nvim commands](https://lazy.folke.io/usage)
- [lazy.nvim lockfiles](https://lazy.folke.io/usage/lockfile)
- [Tree-sitter compatibility branch](https://github.com/nvim-treesitter/nvim-treesitter/blob/master/README.md)
- [Debian Backports instructions](https://backports.debian.org/Instructions/)

For offline help, use `man stow`, `man tmux`, `man ssh`, and Neovim's installed help for the exact tool versions on that machine.
