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

	starship init fish | source
end

# Personal scripts
# ----------------
# Custom AI Agent
alias jagent="jbang ~/.config/scripts/JAgent.java"

# Android Music Manager
alias music_manager="java ~/.config/scripts/MusicManager.java"
# -----------------

# Path
# ----
# JBang
export PATH="$PATH:~/.jbang/bin"

# Raku
export PATH="$PATH:/usr/share/perl6/site/bin"
export PATH="$PATH:~/.raku/bin"

# OpenCode
export PATH="$PATH:~/.opencode/bin/opencode"
# ----

# SDKs
# ----
# Java
export JAVA_HOME="$HOME/.sdkman/candidates/java/21-tem"

# Java Card
export ANT_HOME="$HOME/.sdkman/candidates/ant/current"
export JC_TOOLS_HOME="$HOME/javacard/sdk"
alias gp="java -jar $HOME/javacard/gp.jar"

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
# JBang
alias j!="jbang"

# Use All GCC warnings
alias gcc="gcc -Wall -Wextra -Wpedantic -Werror"

# Kill GNU screen
alias kscreen="pkill screen"

# Commit changes
function gac -a commit_msg
	git add .
	git commit -m $commit_msg
end

# Push changes in one command
function gacp
	gac $argv
	git push origin HEAD
end

# Bypass hotspot throttling
function bypass_hotspot
	sudo iptables -t mangle -A PREROUTING -i wlan0 -j TTL --ttl-inc 1
	sudo iptables -t mangle -I POSTROUTING -o wlan0 -j TTL --ttl-inc 1
	sudo ip6tables -t mangle -A PREROUTING ! -p icmpv6 -i wlan0 -j HL --hl-inc 1
	sudo ip6tables -t mangle -I POSTROUTING ! -p icmpv6 -o wlan0 -j HL --hl-inc 1
end

# MultiHop VPN in non-fourteen eyes countries
function unglow
	ivpn firewall -on
	set -l safe_exit_servers \
		"cz1.wg.ivpn.net"  \
		"bg1.wg.ivpn.net"  \
		"gr1.wg.ivpn.net"  \
		"rs1.wg.ivpn.net"  \
		"ro1.wg.ivpn.net"  \

	set -l count (count $safe_exit_servers)
	while true
		set -l ex1 (random 1 $count)
		set -l ex2 (random 1 (math $count - 1))
		if test $ex2 != $ex1
			ivpn connect -exit_svr $safe_exit_servers[$ex1] $safe_exit_servers[$ex2]
			break
		end
	end
end

function glow
	ivpn firewall -off
	ivpn disconnect
end
# ----------------

function fish_greeting
	# Do nothing
end
