autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search # Up
bindkey "^[[B" down-line-or-beginning-search # Down

# ZPlug
export ZPLUG_HOME=$HOMEBREW_PREFIX/opt/zplug
source $ZPLUG_HOME/init.zsh
# zplug "dracula/zsh", as:theme

# Added by Toolbox App
export PATH="$PATH:/Users/jasonchen/Library/Application
Support/JetBrains/Toolbox/scripts"
eval "$(/opt/homebrew/bin/brew shellenv)"

###
# Git 
###

# Autoload zsh add-zsh-hook and vcs_info functions
autoload -Uz add-zsh-hook vcs_info

# Enable substitution in the prompt
setopt prompt_subst

# Run vcs_info just before a prompt is displayed (precmd)
add-zsh-hook precmd vcs_info

# Multi-line prompt: first line is path & Git info, second line is prompt indicator
PROMPT='%F{blue}%~%f %F{magenta}${vcs_info_msg_0_}%f
%F{yellow}% ❯ %f'

# Optional: right prompt with time
RPROMPT='%F{yellow}[%D{%L:%M:%S}]%f'

# Enable checking for (un)staged changes, enabling use of %u and %c
zstyle ':vcs_info:*' check-for-changes true

# Custom strings for unstaged (*) and staged (+) changes
zstyle ':vcs_info:*' unstagedstr ' *'
zstyle ':vcs_info:*' stagedstr ' +'

# Format for Git info
zstyle ':vcs_info:git:*' formats '(%b%u%c)'
zstyle ':vcs_info:git:*' actionformats '(%b|%a%u%c)'

# Case-insensitive with smart-case tab completion.  Only case sensitive if uppercase is used.
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=* l:|=*'

###
# For versions of ruby older than 3.0
# https://stackoverflow.com/questions/69012676/install-older-ruby-versions-on-a-m1-macbook
###

export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init - zsh)"

export RUBY_CONFIGURE_OPTS="--with-openssl-dir=$(brew --prefix openssl@1.1)"
export LDFLAGS="-L/opt/homebrew/opt/readline/lib:$LDFLAGS"
export CPPFLAGS="-I/opt/homebrew/opt/readline/include:$CPPFLAGS"
export PKG_CONFIG_PATH="/opt/homebrew/opt/readline/lib/pkgconfig:$PKG_CONFIG_PATH"
export optflags="-Wno-error=implicit-function-declaration"
export LDFLAGS="-L/opt/homebrew/opt/libffi/lib:$LDFLAGS"
export CPPFLAGS="-I/opt/homebrew/opt/libffi/include:$CPPFLAGS"
export PKG_CONFIG_PATH="/opt/homebrew/opt/libffi/lib/pkgconfig:$PKG_CONFIG_PATH"

###
# direnv
###

eval "$(direnv hook zsh)"

# pnpm
export PNPM_HOME="/Users/jasonchen/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# Go
export GOPATH=$HOME/go
export PATH=$PATH:/Users/jasonchen/go/bin
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin

###
# Aliases
###
alias ll="ls -al"
alias lzg="lazygit"
alias lzd="lazydocker"
alias lt="npx localtunnel --subdomain jsnchn --port"
alias air="~/go/bin/air"

###
# mise-en-place
###
eval "$(mise activate zsh)"
