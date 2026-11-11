# Add every completion dir to fpath BEFORE the single compinit call.
typeset -U fpath
for _d in "$HOME/.docker/completions" "$HOME/.zfunc"; do
  [[ -d "$_d" ]] && fpath=("$_d" $fpath)
done
unset _d

# Run compinit once. Do a full security check (compaudit) only when the dump
# is more than 24h old; otherwise trust the cached dump (-C), which is much faster.
autoload -Uz compinit
_zcompdump="${ZDOTDIR:-$HOME}/.zcompdump"
_stale=( $_zcompdump(N.mh+24) )
if [[ ! -f $_zcompdump || -n $_stale ]]; then
  compinit -d "$_zcompdump" && touch "$_zcompdump"
else
  compinit -C -d "$_zcompdump"
fi
unset _zcompdump _stale

zinit cdreplay -q

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'
