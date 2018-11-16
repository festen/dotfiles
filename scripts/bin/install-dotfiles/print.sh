#!/bin/sh
RED='\033[00;31m'
GREEN='\033[00;32m'
YELLOW='\033[00;33m'
BLUE='\033[00;34m'
RESET='\033[0m'
BOLD='\033[1m'
DIM='\033[2m'

function title() {
    echo "${BOLD}$@${RESET}"
}

function prompt()  {
    echo "${YELLOW}$@${RESET}"
}
