# Load CachyOS config
source /usr/share/cachyos-fish-config/cachyos-config.fish

# Add JBang to environment
alias j!=jbang
export PATH="$HOME/.jbang/bin:$PATH"

# Editors and man paging
export EDITOR=emacs
export SUDO_EDITOR=emacs
export PAGER=most

# Use nicer looking alternatives to common utilities
alias grep="rg"
alias cat="bat"
alias ls="exa"

# Commands I frequently type wrong
alias sdkman="sdk"

# Sourcehut SSH agent
eval "$(ssh-agent -c)" > /dev/null

# Start screen
if status is-interactive
	if not set -q STY
		exec screen -RR
	end
end

# Personal aliases
alias kscreen="pkill screen"

function gacp
	git add .
	git commit -m "$argv"
	git push origin HEAD
end

function fish_greeting
	# Do nothing
end

