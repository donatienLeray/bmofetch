# bmofetch

A neofetch theme inspired by BMO from Adventure Time with a cowsay like speech bubble.\
[more neofetch-themes](https://github.com/Chick2D/neofetch-themes).

![bmofetch](https://github.com/user-attachments/assets/1850e6a3-6ad2-4421-a73b-3259f9b064f1)

## Table of contents

- [bmofetch](#bmofetch)
  - [Requirements](#requirements)
  - [Installation](#installation)
- [bmosay](#bmosay) 
  - [Change the speech bubble text](#change-the-speech-bubble-text)
  - [Input supported](#input-supported)
  - [Roadmap](#roadmap-bmosay)

## Requirements
- Requires [neofetch](https://github.com/dylanaraps/neofetch) to be installed.
- Requires to use [Nerd font](https://www.nerdfonts.com/) in you terminal for the above theme to render the icons correctly. 
  - [how to install NF (personal recommandation)](https://ostechnix.com/install-nerd-fonts-to-add-glyphs-in-your-code-on-linux/) 
  - [more ways to download NF](https://github.com/ryanoasis/nerd-fonts?tab=readme-ov-file#font-installation)
> [!NOTE]
> If the font is **not monospaced** you will perhaps need to change the `GAP_SIZE`-value in the [bmosay](https://github.com/donatienLeray/bmofetch/blob/main/bmosay.sh) and [run it](#change-the-speech-bubble-text) for the speech bubble to overlay correctly.\
> If not using bmosay manually changing the `gap`-value in the [bmofetch.conf](https://github.com/donatienLeray/bmofetch/blob/main/bmofetch.conf) will do the same.

## Installation

1. change to your neofetch themes directory:
```bash
cd ~/.config/neofetch/
```
2. Clone the repository:
```bash
git clone git@github.com:donatienLeray/bmofetch.git
```
3. Run neofetch with the bmofetch.conf file:
```bash
neofetch --config ~/.config/neofetch/bmofetch/bmofetch.conf
```
# bmosay
## Change the speech bubble text

You can change the speech bubble text by running [bmosay.sh](https://github.com/donatienLeray/bmofetch/bmosay.sh) in your terminal:
```bash
 sh path_to_bmofetch/bmosay.sh "your text here"
```
**SYNOPSIS:\
  sh .config/neofetch/bmofetch/bmosay.sh [options] \<argument\>**

**OPTIONS:**\
&nbsp;&nbsp;-v, --verbose&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Enable verbose mode.(prints debug messages)\
&nbsp;&nbsp;-q, --quiet&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp; &nbsp;Suppress output.\
&nbsp;&nbsp;-r, --random &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Specify a file to get a random line from.\
&nbsp;&nbsp;-p, --path &nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Specify the path to the bmofetch directory. If [`bmofetch.conf`](https://github.com/donatienLeray/bmofetch/blob/main/bmofetch.conf) or [`bmofetch.txt`](https://github.com/donatienLeray/bmofetch/blob/main/bmo.txt) are not in the directory they will be copied from \<path-to-bmofetch\> if possible.\
&nbsp;&nbsp;-h, --help &nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Display help message and exit.\
&nbsp;&nbsp;-vq, -qv &nbsp; &nbsp; &nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Enable both verbose and quiet mode. (only prints debug messages)\
&nbsp;&nbsp;-\*\*, -\*\*\*&nbsp; &nbsp; &nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Any combination of r, v, q can be used instead of the above

**EXAMPLES:**
```bash
sh .config/neofetch/bmofetch/bmosay.sh "Hello, world!"
sh .config/neofetch/bmofetch/bmosay.sh -vq --random file.txt
sh .config/neofetch/bmofetch/bmosay.sh -qr file.txt
sh .config/neofetch/bmofetch/bmosay.sh --help
sh .config/neofetch/bmofetch/bmosay.sh -p /path/to/bmofetch "Hello, world!"
```
## Input supported
\+ Supports utf-8 characters.\
\- Newlines and carriage returns are not supported yet.\
\- Multiple spaces as well as leading and trailing spaces are ignored.

## Roadmap bmosay
<details>
  <summary>older</summary>
  <b>&nbsp;|<br />
  ✅ support for compact flags.<br />
  &nbsp;|<br />
  ✅ support input from file.<br />
  &nbsp;|<br />
  ✅ <a href="https://github.com/donatienLeray/bmofetch/issues/3">Working Directory #3</a><br />
  </b>
</details>
    
&nbsp;**|**\
✅ **[Auto-copy on -p #4](https://github.com/donatienLeray/bmofetch/issues/4)**\
&nbsp;**|**\
🛠️ **support multiline input.**\
&nbsp;|\
**▢** make an bmosay installation script.\
&nbsp;|\
**▢** support piping.\
&nbsp;|\
**▢** support [fish completion](https://fishshell.com/docs/current/completions.html).\
&nbsp;|\
**▢** support [zsh completion](https://github.com/zsh-users/zsh/tree/master/Completion).\
&nbsp;|\
**▢** support [bash-completion](https://github.com/scop/bash-completion).
