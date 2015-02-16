alias umount_vqdev='fusermount -u ~/tmp/sshfs_mnt'
alias mount_vqdev='sshfs vqdev:src/ ~/tmp/sshfs_mnt'

export QUILT_PATCHES=debian/patches
export PBUILDER_SRC_DIR_FORMAT=pkg

alias lsl="ls -larth"

alias ag=ack-grep
alias gr='grep -rn'

alias bbranch='bzr branch'
alias bst='bzr status'
alias bpull='bzr pull'
alias bdiff='bzr cdiff'

alias ust-push='function _ust-push(){ bzr push lp:~canonical-platform-qa/ubuntu-sanity-tests/$1; };_ust-push'

alias ipy3="ipython3"

alias pshell="phablet-shell"

# Helper functions to get emacs running if it needs to be.
function _ensure_emacs_running() {
    if [ ! -e /tmp/emacs$UID/server ]; then
		echo "Starting emacs daemon"
		$(/usr/bin/emacs --daemon)
    fi
}

function _kill_emacs() {
    if [ -e /tmp/emacs$UID/server ]; then
    	$(emacsclient -e "(kill-emacs)")
	fi
}

alias ec='function _ec() { emacsclient -c "$1" & }; _ensure_emacs_running; _ec'

# Phablet actions
function _current_running_revno() {
  echo $(adb shell system-image-cli -i | grep "current build number"| sed -e "s/.*:\ //")
}

alias reflash_dev='echo _current_running_revno'
