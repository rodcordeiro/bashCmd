#!/usr/bin/env bash 
#
# ---------------------------------------------------------------- #  
# Script Name:   ${Path.resolve(path,name)}.sh 
# Description:   Update description about script 
# Linkedin:      https://www.linkedin.com/in/rodrigomcordeiro/ 
# Author:        Rodrigo Cordeiro `,`\
# ---------------------------------------------------------------- # `

set -e

command_update(){
  apt-get update -y
  apt-get upgrade -y
  apt-get --fix-broken install -y
  apt-get --fix-missing install -y
  apt-get update -y
  apt-get upgrade -y
  apt-get check -y
  apt-get dist-upgrade -y
  apt-get update -y
  apt-get upgrade -y
  apt-get autoremove -y
  apt-get autoclean -y
}

command_test(){
    echo "Teste acionado"
}
command_add(){
    echo "Adicionando ${args[@]}"
}
command_help(){
  echo "Shows help message"
  echo "Available commands are ${COMMANDS[@]}"
}
_trim() {
  local it="${1#"${1%%[![:space:]]*}"}"
  echo -e "${it%"${it##*[![:space:]]}"}"
}

_have(){ type "$1" &>/dev/null; }

_jsonstr() {
  _buffer "$@" && return $?
  jq -MRsc <<< "$1"
}

_filter(){
  [[ -n "$1" ]] && return 1
  while IFS= read -ra args; do
    "${FUNCNAME[1]}" "${args[@]}"
  done
}

command=$1
args=("${@:2}")

echo "------------------------------------------"
echo "received: $@"
echo "command: $command"
echo "argumments: ${args[@]}"
echo "Args count: ${#args}"
echo "------------------------------------------"

## Set the array of commands available
while IFS= read -r line; do
  [[ $line =~ ^declare\ -f\ command_ ]] || continue
  COMMANDS+=( "${line##declare -f command_}" )
done < <(declare -F)
COMMANDS=($(LC_COLLATE=C sort < <(printf "%s\n" "${COMMANDS[@]}")))

if [[ -n "$1" ]]; then
  declare cmd="$1"; shift
  for c in "${COMMANDS[@]}"; do
    if [[ $c == "$cmd" ]]; then
      "command_$cmd" "$@"
      exit $?
    fi
  done
else
  command_update
fi

echo $EXE