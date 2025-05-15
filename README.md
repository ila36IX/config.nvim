# kickstart.nvim

## Introduction

Hello neovim I start to feel you, again.
I'll build my own small simple neovim laboratory

## links to consider
[Learn lua](https://learnxinyminutes.com/lua/)
[Config vim using Lua](https://learnxinyminutes.com/lua/)


### Install External Dependencies

External Requirements:
- Basic utils: `git`, `make`, `unzip`, C Compiler (`gcc`)
- [ripgrep](https://github.com/BurntSushi/ripgrep#installation)
- Clipboard tool (xclip/xsel/win32yank or other depending on platform)
- A [Nerd Font](https://www.nerdfonts.com/): optional, provides various icons
  - if you have it set `vim.g.have_nerd_font` in `init.lua` to true
- Language Setup:
  - If you want to write Typescript, you need `npm`
  - If you want to write Golang, you will need `go`
  - etc.


```sh
git clone https://github.com/ila36IX/config.nvim.git "${XDG_CONFIG_HOME:-$HOME/.config}"/nvim
```
