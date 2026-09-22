{ pkgs, ... }:

{
  home.file.".zshrc".text = ''
    export ZSH="$HOME/.oh-my-zsh"
    ZSH_THEME="robbyrussell"
    plugins=(git)
    source $ZSH/oh-my-zsh.sh
    source ${pkgs.zsh-autosuggestions}/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
    PROMPT="%(?:%{$fg_bold[green]%}%1{➜%} :%{$fg_bold[red]%}%1{➜%} ) %{$fg[cyan]%}%c%{$reset_color%} "

    typeset -U path PATH
    HISTFILE="$HOME/.zsh_history"
    HISTSIZE=10000
    SAVEHIST=10000
    setopt append_history
    setopt share_history
    setopt hist_ignore_dups
    setopt hist_ignore_space

    if [ -x /usr/bin/dircolors ]; then
      test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
      alias ls='ls --color=auto'
      alias grep='grep --color=auto'
      alias fgrep='fgrep --color=auto'
      alias egrep='egrep --color=auto'
    fi

    alias ll='ls -alF'
    alias la='ls -A'
    alias l='ls -CF'
    [ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"
    export PATH="$HOME/.local/bin:$PATH"
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
    command -v zoxide >/dev/null 2>&1 && eval "$(zoxide init zsh)"
    export BUN_INSTALL="$HOME/.bun"
    export PATH="$BUN_INSTALL/bin:$PATH"
    export PNPM_HOME="/home/amaan/.local/share/pnpm"
    case ":$PATH:" in
      *":$PNPM_HOME/bin:"*) ;;
      *) export PATH="$PNPM_HOME/bin:$PATH" ;;
    esac
    export PATH="$PATH:/opt/nvim/"
    export PATH="$HOME/.local/share/pi-node/node-v22.23.2-linux-x64/bin:$PATH"
    [ -f "$HOME/.atuin/bin/env" ] && . "$HOME/.atuin/bin/env"
    export PATH="$HOME/.atuin/bin:$PATH"
    command -v atuin >/dev/null 2>&1 && eval "$(atuin init zsh)"

    alias lg='lazygit'
    alias cls='clear'
    alias nrd='npm run dev'
    alias p='pnpm'
    alias t='tmux'
    alias piq='ollama launch pi --model qwen3.5:latest'
    alias brd='bun run dev'

    autoload -U compinit
    compinit
    source <(jj util completion zsh)

    function y() {
      local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
      command yazi "$@" --cwd-file="$tmp"
      IFS= read -r cwd < "$tmp"
      [ "$cwd" != "$PWD" ] && [ -d "$cwd" ] && builtin cd -- "$cwd"
      command rm -f -- "$tmp"
    }
    export PATH=/home/amaan/.opencode/bin:$PATH
    export PATH="$HOME/.local/go/bin:$PATH"
    export ZIG_LOCAL_CACHE_DIR="/tmp/zig-cache-''${USER:-user}-stream_proxy"
    [ -s "/home/amaan/.bun/_bun" ] && source "/home/amaan/.bun/_bun"

    sops-init() {
      local recipient
      recipient=$(age-keygen -y ~/.config/sops/age/keys.txt)
      cat > .sops.yaml <<EOF
    creation_rules:
      - path_regex: secrets/.*\.(yaml|yml|json|env)$
        age: $recipient
      - path_regex: \.env(\..*)?$
        age: $recipient
    EOF
      echo ".sops.yaml created"
    }
  '';



}
