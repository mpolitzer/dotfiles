if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

PS1="\[\033[01;32m\]\$\[\033[00m\] "
export EDITOR="nvim"
export TERMINAL="uxterm"
eval $(keychain --eval --noask --agents ssh id_rsa)
#eval `keychain --eval --noask --agents ssh id_rsa`

# smbclient (mount) example
# mount -t cifs //SERVER/sharename /mnt/mountpoint -o user=username,password=password,workgroup=workgroup,ip=serverip

alias o="xdg-open"
alias e="vim"
#alias e="nvim"
alias dd="dd status=progress"
alias m="make"
alias axel="axel -n 4 -a"
alias youtube-dl="youtube-dl --external-downloader aria2c"
alias cpr="rsync -a --progress"
alias grep="egrep --color=auto"
alias isis="wine ~/.wine/drive_c/Program\ Files\ \(x86\)/Labcenter\ Electronics/Proteus\ 7\ Professional/BIN/ISIS.EXE"
alias l="ls --color"

#export TERM=xterm-256color
export PATH="$HOME/.local/bin/:$PATH"
export PKG_CONFIG_PATH="~/.local/lib/pkgconfig/"

# xbps
export PATH="$PATH:$HOME/.local/xbps/usr/bin"

# lua
#export PATH="$PATH:$HOME/.local/openresty/bin:$HOME/.local/openresty/nginx/sbin" # openresty
eval `luarocks-5.1 path` # luarocks

PATH="$HOME/.local/usr/bin:$PATH" # arm
#PATH="$PATH:$HOME/.local/opt/toolchains/arm-none-eabi/bin" # arm
PATH="$HOME/.local/opt/toolchains/msp430/bin:$PATH" # msp430
PATH="$HOME/.local/opt/toolchains/avr/bin:$PATH" # avr

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

load-keychain() {
	eval $(keychain --quiet --eval --agents ssh id_rsa)
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

