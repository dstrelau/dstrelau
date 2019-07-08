function o() {
	FILES=$(ag -l '' $@ | fzf -m --height 80% --preview="head -$LINES {}")
	[ -z $FILES ] || vim -O $(echo $FILES)
}
alias oo='vim -c :Ag!'
alias vs='vim -S .vimsession'

if type lolcat >/dev/null ; then
	alias cat=lolcat
fi

function big() {
	figlet $@ | cat
}
alias fail='figlet FAIL | cat'

alias tf="terraform"
alias ve="aws-vault exec -n dstrelau --"

alias ls='ls -AFG'
alias ll='ls -l'
alias fuck='sudo $(fc -nl -1)'

alias bb='bundle | grep -v Using'
alias b='bundle exec'

alias todo="git grep --untracked -inE '(TODO|FIXME)' ':!vendor'"
alias g='git switch'
alias git='nocorrect hub'
alias gaa='git add --all'
alias gb='git branch'
alias gba='git branch -a'
alias gc='git commit -v'
alias gca='git commit -v -a'
alias gt='git status'
alias ga='git add'
alias gd='git diff'
alias gdt='git difftool -y'
alias gdc='git diff --cached'
alias gf='git fuzzy'
alias tiga='tig --all'
alias up='git up'
# compdef hub=git

alias gv=govendor
function gml() {
	[ -f ./gometalinter.json ] && gometalinter --config gometalinter.json $@ || gometalinter $@
}
alias uuid="ruby -rsecurerandom -e 'print SecureRandom.uuid'"

function llog() {
	lambda="$1"
	shift
	awslogs get -G -S -w /aws/lambda/$lambda $@
}

function nlog() {
	LOG=$(saw groups | grep $1)
	echo $LOG
	saw watch --expand $LOG
}

function cwtail(){
    if [ "$#" -eq 1 ]; then
        echo saw watch --expand $1
        saw watch --expand $1
    else
        saw groups | fzf -m | parallel --verbose --linebuffer saw watch --expand
    fi
}

function asdf() {
	ruby -run -ehttpd . -p ${1:-8000}
}

function dollars() {
	pbpaste | sed 's/\[.*\]/$/' | sed 's/[[:space:]]*(.*)//' | pbcopy
}

function awslocal() {
	case "$1" in
		"sns")
			aws --endpoint-url=http://localhost:4575 $@
			;;
		"sqs")
			aws --endpoint-url=http://localhost:4576 $@
			;;
		"dynamodb")
			aws --endpoint-url=http://localhost:4569 $@
			;;
		*)
			echo >&2 "No endpoint mapping for $1"
			;;
	esac
}

# vim: noet:ft=zsh:ts=4:sw=4
