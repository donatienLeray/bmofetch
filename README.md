# bmofetch

A neofetch theme inspired by BMO from Adventure Time with a cowsay like speech bubble.\
You can find the complete neofetch-themes repository at: https://github.com/Chick2D/neofetch-themes

![bmofetch](https://github.com/user-attachments/assets/1850e6a3-6ad2-4421-a73b-3259f9b064f1)

- [bmofetch](#bmofetch)
  - [Installation](#installation)
- [bmosay](#bmosay) 
  - [Change the speech bubble text](#change-the-speech-bubble-text)
  - [Input supported](#input-supported)
  - [Roadmap](#roadmap-bmosay)


## Installation
Requires [neofetch](https://github.com/dylanaraps/neofetch) to be installed.

1. change to your neofetch themes directory:
```bash
cd ~/.config/neofetch/
```
2. Clone the repository:
```bash
git clone
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
&nbsp;&nbsp;-h, --help &nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Display help message and exit.\
&nbsp;&nbsp;-vq, -qv &nbsp; &nbsp; &nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Enable both verbose and quiet mode. (only prints debug messages)\
&nbsp;&nbsp;-\*\*, -\*\*\*&nbsp; &nbsp; &nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Any combination of r, v, q can be used instead of the above

**EXAMPLES:**
```bash
sh .config/neofetch/bmofetch/bmosay.sh "Hello, world!"\
sh .config/neofetch/bmofetch/bmosay.sh -vq --random file.txt\
sh .config/neofetch/bmofetch/bmosay.sh -qr file.txt\
sh .config/neofetch/bmofetch/bmosay.sh --help
```
## Input supported
\+ supports utf-8 characters.\
\- newlines and carriage returns are not supported yet.\
\- multiple spaces as well as leading and trailing spaces are ignored.

## Roadmap bmosay
- [ ] support multiline input.
- [ ] make an bmosay installation script.
- [ ] support piping.
- [ ] support [fish completion](https://fishshell.com/docs/current/completions.html).
- [ ] support [zsh completion](https://github.com/zsh-users/zsh/tree/master/Completion).
- [ ] support [bash-completion](https://github.com/scop/bash-completion).
