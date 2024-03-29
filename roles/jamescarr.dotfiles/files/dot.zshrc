export ZSH=/Users/jamescarr/.oh-my-zsh

ZSH_THEME="amuse"

plugins=(git)

# User configuration
export PATH="$PATH:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
source $ZSH/oh-my-zsh.sh

###################################################
# Virtualenvwrapper
###################################################
export WORKON_HOME=$HOME/.virtualenvs
export PROJECT_HOME=$HOME/Projects
source /usr/local/bin/virtualenvwrapper.sh


###################################################
# Aliases
###################################################

# docker
alias b2d='boot2docker up && $(boot2docker shellinit)'
alias dcu='docker-compose up'
alias dcud='docker-compose up -d'
alias dcr='docker-compose run'
alias dm='docker-machine'
alias dml='docker-machine ls'
alias dmcv='docker-machine create --driver virtualbox'
alias dme='eval "$(docker-machine env default)"'

# aws
alias s3='aws s3'
alias ec2='aws ec2'

# git
alias gpl='git pull'
alias gc='git commit -am'
alias zgc='git commit --author="James Carr <james.r.carr@gmail.com>" -am'

# misc
alias j="jobs -l"
alias l.l='ls -1A | grep "^\." | xargs ls -lhGF'
alias ll="ls -lhF"
alias ls="ls -GF"
alias top="top -ocpu -Orsize"

# vagrant
alias v=vagrant
alias vu='vagrant up'
alias vp='vagrant provision'
alias vh='vagrant halt'

# RVM
export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting
export PATH="$PATH:$HOME/bin" # Add RVM to PATH for scripting

# configure zsh autojump
[[ -s `brew --prefix`/etc/autojump.zsh ]] && . `brew --prefix`/etc/autojump.zsh

###################################################
# ZSH Variables
###################################################
export ZDOTDIR=~/.zsh
export ZSH_SECRET_HOME=${ZDOTDIR}/secret
export ZSH_SECRET_VARIABLES=${ZSH_SECRET_HOME}/variables.zsh

# Import Secret Variables
if [[ -e ${ZSH_SECRET_VARIABLES} ]]; then
    source ${ZSH_SECRET_VARIABLES}
fi

###################################################
# AWS Functions
###################################################

function awsenv() {
   export AWS_DEFAULT_PROFILE=$1
   export AWS_PROFILE=$1
}

function instances_by_role() {
  zparseopts -D -E -A opts -- o:
  output=${opts[-o]:-"table"}

  role=${1}
  aws --output table ec2 describe-instances --query 'Reservations[].Instances[].[InstanceId,PrivateIpAddress,Tags[?Key==`Name`].Value|[0]]' \
      --filters "Name=tag:role,Values=$role"

}

function aws-instances-describe() {
    zparseopts -D -E -A opts -- o:
    output=${opts[-o]:-"table"}

    name=${1}
    query=(
        "Reservations[].Instances[]"
        ".{"
        "Name             : Tags[?Key == \`Name\`].Value | [0],"
        "State            : State.Name,"
        "LaunchTime       : LaunchTime,"
        "PublicIpAddress  : PublicIpAddress,"
        "PrivateIpAddress : PrivateIpAddress,"
        "ImageId          : ImageId,"
        "InstanceType     : InstanceType"
        "}"
    )

    aws --output ${output} \
        ec2 describe-instances \
        --filters "Name=tag:Name,Values=*${name}*" \
        --query "${query}"
}


###################################################
# Docker Machine Functions
###################################################

function dms() {
  name=${1:=default}

  docker-machine start $name
}

function dme() {
  name=${1:=default}

  eval $(docker-machine env $name)
}
function dmc() {
  name=${1}

  docker-machine create --driver virtualbox $name
}

function vdu() {
  name=${1}

  vagrant destroy -f $name && vagrant up $name
}

awsenv default
