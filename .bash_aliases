alias umount_vqdev='fusermount -u ~/tmp/sshfs_mnt'
alias mount_vqdev='sshfs vqdev:src/ ~/tmp/sshfs_mnt'

export QUILT_PATCHES=debian/patches
export PBUILDER_SRC_DIR_FORMAT=pkg

alias lsl="ls -larth"
# Heh, dumb
alias meow=cat

alias sr=sensors

alias ag=ack-grep
alias gr='grep -rn'

alias cda='cd /home/leecj2/code/autopilot/'
alias cdat='cd /home/leecj2/code/autopilot/trunk'

# Bzr abbrevs.
alias bbranch='bzr branch'
alias bst='bzr status'
alias bpull='bzr pull'
alias bdiff='bzr cdiff'

alias ust-push='function _ust-push(){ bzr push lp:~canonical-platform-qa/ubuntu-sanity-tests/$1; };_ust-push'

alias ipy3="ipython3"

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
  echo $(adb shell system-image-cli -i | grep "current build number"| sed -e "s/.*:\ //" | tr -d '\r')
}


alias reflash_dev='function _f(){ ubuntu-device-flash --developer-mode --password 0000 --channel="ubuntu-touch/devel-proposed" --wipe --revision=$(_current_running_revno); }; _f'
alias pshell="phablet-shell"

alias sa="adb wait-for-device; adb root; adb wait-for-device; adb shell"
alias sd="adb forward tcp:2222 tcp:22; ssh-keygen -f /home/leecj2/.ssh/known_hosts -R [localhost]:2222; ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no phablet@localhost -p 2222"
