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
# ----------------
# Kill GNU screen
alias kscreen="pkill screen"

# Push changes in one command
function gacp
	git add .
	git commit -m "$argv"
	git push origin HEAD
end

# Load ESP-IDF SDK
alias get_idf=". $HOME/esp/esp-idf/export.fish"

# Bypass hotspot throttling
function bypass_hotspot
	sudo iptables -t mangle -A PREROUTING -i wlan0 -j TTL --ttl-inc 1
	sudo iptables -t mangle -I POSTROUTING -o wlan0 -j TTL --ttl-inc 1
	sudo ip6tables -t mangle -A PREROUTING ! -p icmpv6 -i wlan0 -j HL --hl-inc 1
	sudo ip6tables -t mangle -I POSTROUTING ! -p icmpv6 -o wlan0 -j HL --hl-inc 1
end
# ----------------

function fish_greeting
	# Do nothing
end

