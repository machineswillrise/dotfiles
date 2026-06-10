# Editors and man paging
export EDITOR=emacs
export SUDO_EDITOR=emacs
export PAGER=most

# Use nicer looking alternatives to common utilities
alias grep="rg"
alias ls="eza"

# Commands I frequently type wrong
alias sdkman="sdk"

# Start screen
if status is-interactive
	if not set -q STY
		exec screen -RR
	end
end

# Path
# ----
# JBang
export PATH="$HOME/.jbang/bin:$PATH"

# Raku
export PATH="/usr/share/perl6/site/bin:$PATH"
export PATH="$HOME/.raku/bin:$PATH"

# OpenCode
export PATH="$HOME/.opencode/bin/opencode:$PATH"
# ----

# SDKs
# ----
# Java Card
export ANT_HOME="$HOME/.sdkman/candidates/ant/current"
export JC_TOOLS_HOME="$HOME/javacard/sdk"

alias get_idf=". $HOME/esp/esp-idf/export.fish"
# ----

# Personal aliases
# ----------------
# JBang
alias j!="jbang"

# Use All GCC warnings
alias gcc="gcc -Wall -Wextra -Wpedantic -Werror"

# Custom AI Agent
alias jagent="j! ~/Desktop/Projects/jagent/JAgent.java"

# Kill GNU screen
alias kscreen="pkill screen"

# Commit changes
function gac
	git add .
	git commit -m "$argv"
end

# Push changes in one command
function gacp
	gac
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

# Shell prompt
starship init fish | source
