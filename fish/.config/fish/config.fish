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
export PATH="$PATH:~/.jbang/bin"

# Raku
export PATH="$PATH:/usr/share/perl6/site/bin"
export PATH="$PATH:~/.raku/bin:$PATH"

# OpenCode
export PATH="$PATH:~/.opencode/bin/opencode"

# Grok
export PATH="$PATH:~/.grok/bin/grok"
# ----

# SDKs
# ----
# Java
export JAVA_HOME="$HOME/.sdkman/candidates/java/21-tem"

# Java Card
export ANT_HOME="$HOME/.sdkman/candidates/ant/current"
export JC_TOOLS_HOME="$HOME/javacard/sdk"

# ESP-IDF
alias get_idf=". $HOME/esp/esp-idf/export.fish"
# ----

# C# stuff
#-------------
export DOTNET_CLI_TELEMETRY_OPTOUT="true"
export SSL_CERT_DIR="$HOME/.aspnet/dev-certs/trust:/usr/lib/ssl/certs"
# ------------

# Personal aliases
# ----------------
# Java
alias java="java --enable-preview --source 21"

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
