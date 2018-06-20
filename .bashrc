if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi
set editing-mode vi
PS1="\[\033[01;32m\]$\[\033[00m\] "
export EDITOR="vim"
export TERMINAL="st"
#export TERMINAL="uxterm"
eval $(keychain --quiet --eval --noask --agents ssh id_rsa) &
#eval `keychain --eval --noask --agents ssh id_rsa`

# smbclient (mount) example
# mount -t cifs //SERVER/sharename /mnt/mountpoint -o user=username,password=password,workgroup=workgroup,ip=serverip

alias o="xdg-open"
alias e="$EDITOR -p"
alias dd="dd status=progress"
alias m="make"
alias axel="axel -n 4 -a"
alias youtube-dl="youtube-dl --external-downloader aria2c"
alias cpr="rsync -a --progress"
alias grep="egrep --color=auto"
alias isis="wine ~/.wine/drive_c/Program\ Files\ \(x86\)/Labcenter\ Electronics/Proteus\ 7\ Professional/BIN/ISIS.EXE"
alias ls="ls --color"
alias l="ls --color"

#export TERM=xterm-256color
export PATH="$HOME/.local/bin/:$PATH"
export PKG_CONFIG_PATH="~/.local/lib/pkgconfig/"
#export PREFIX="~/.local"
# export VIMRUNTIME="/usr/share/vim/vim80:/usr/share/vim/vimfiles:/home/mp/.config/vim/vim80"

# xbps
export PATH="$PATH:$HOME/.local/xbps/usr/bin"
export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$HOME/.local/lib/:$HOME/.local/lib64/"

# lua
#export PATH="$PATH:$HOME/.local/openresty/bin:$HOME/.local/openresty/nginx/sbin" # openresty
#eval `luarocks-5.1 path` # luarocks

# vulkan [Release]
export PATH="$HOME/.local/opt/vulkan/release/bin/:$PATH"
export LD_LIBRARY_PATH="$HOME/.local/opt/vulkan/release/lib64/":$LD_LIBRARY_PATH
export VK_LAYER_PATH="$HOME/.local/opt/vulkan/release/share/vulkan/explicit_layer.d/":$VK_LAYER_PATH
#export PKG_CONFIG_PATH="$HOME/.local/opt/vulkan/release/lib64/pkgconfig/":$PKG_CONFIG_PATH
export PKG_CONFIG_PATH="$HOME/.local/opt/vulkan/release/lib64/pkgconfig/":$PKG_CONFIG_PATH

# vulkan [Debug]
#export PATH="$HOME/.local/opt/vulkan/debug/bin/:$PATH"
#export LD_LIBRARY_PATH="$HOME/.local/opt/vulkan/debug/lib64/":$LD_LIBRARY_PATH
#export VK_LAYER_PATH="$HOME/.local/opt/vulkan/debug/share/vulkan/explicit_layer.d/":$VK_LAYER_PATH
#export PKG_CONFIG_PATH="$HOME/.local/opt/vulkan/debug/lib64/pkgconfig/":$PKG_CONFIG_PATH


PATH="$PATH:$HOME/.local/opt/toolchains/arm-none-eabi/bin" # arm
PATH="$PATH:$HOME/.local/opt/toolchains/msp430/bin" # msp430
PATH="$PATH:$HOME/.local/opt/toolchains/avr/bin" # avr
#PATH="$PATH:$HOME/.local/usr/bin" # arm

export TEXMFCONFIG="$HOME/.config/latex/texmf" # Latex

# Unscrew gentoo classpath crazyness

t() {
	u() {
		for k in "$@"; do
			${k}
		done
	}
	u $@
	st &
	#uxterm &
	#lxterminal &
	#i3-sensible-terminal &
}

k() {
	k() {
		for cmd in "$@"; do
			${cmd}
		done
	}
	k $@
	kitty &
	#uxterm &
	#lxterminal &
	#i3-sensible-terminal &
}

load-keychain() {
	eval $(keychain --quiet --eval --agents ssh id_rsa)
}

# open vim in a adequate layout for t modules
et() {
	module=$1
	cd ~/dev/t/
	vim -c ":e t/$module.h|:bel vsplit tests/$module-t.c|:bel terminal"
}

try-wm() {
	echo $1
	read
	read
	Xephyr -ac -br -noreset -screen 1920x1080 2>/dev/null :2.0 &
	ZEPHYR_PID=$!
	sleep 1
	DISPLAY=:2.0 $1
	kill $ZEPHYR_PID
}

