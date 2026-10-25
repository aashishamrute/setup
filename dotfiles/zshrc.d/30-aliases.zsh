if [ -x /usr/bin/dircolors ] || command -v dircolors >/dev/null 2>&1; then
  test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
  alias ls='ls --color=auto'
  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
elif [[ "$(uname -s)" == "Darwin" ]]; then
  alias ls='ls -G'
  alias grep='grep --color=auto'
fi

if [ -f ~/.bash_aliases ]; then
  . ~/.bash_aliases
fi
