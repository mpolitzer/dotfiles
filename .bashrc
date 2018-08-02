[[ $- != *i* ]] && return

export EDITOR="vim"
export TERMINAL="st"
eval $(keychain --quiet --eval --noask --agents ssh id_rsa)

# make vim respect XDG
export VIMINIT='let $MYVIMRC="$XDG_CONFIG_HOME/vim/vimrc" | source $MYVIMRC'

export PATH="/home/m/.local/bin/":$PATH
export PKG_CONFIG_PATH="~/.local/lib/pkgconfig/":$PKG_CONFIG_PATH

## vulkan [Release]
#export PATH="$HOME/.local/opt/vulkan/release/bin/:$PATH"
#export LD_LIBRARY_PATH="$HOME/.local/opt/vulkan/release/lib64/":$LD_LIBRARY_PATH
#export VK_LAYER_PATH="$HOME/.local/opt/vulkan/release/share/vulkan/explicit_layer.d/":$VK_LAYER_PATH
#export PKG_CONFIG_PATH="$HOME/.local/opt/vulkan/release/lib64/pkgconfig/":$PKG_CONFIG_PATH

## vulkan [Debug]
#export PATH="$HOME/.local/opt/vulkan/debug/bin/:$PATH"
#export LD_LIBRARY_PATH="$HOME/.local/opt/vulkan/debug/lib64/":$LD_LIBRARY_PATH
#export VK_LAYER_PATH="$HOME/.local/opt/vulkan/debug/share/vulkan/explicit_layer.d/":$VK_LAYER_PATH
#export PKG_CONFIG_PATH="$HOME/.local/opt/vulkan/debug/lib64/pkgconfig/":$PKG_CONFIG_PATH

t() {
	u() {
		for k in "$@"; do
			${k}
		done
	}
	u $@
	st &
}

load-keychain() {
	eval $(keychain --quiet --eval --agents ssh id_rsa)
}

