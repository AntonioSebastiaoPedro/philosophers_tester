# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    philo_tester.sh                                    :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: ansebast <ansebast@student.42luanda.com    +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2024/12/01 13:23:47 by ansebast          #+#    #+#              #
#    Updated: 2024/12/06 08:48:18 by ansebast         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

#!/bin/bash
BLACK="\e[30m"
R="\e[31m"
G="\e[32m"
Y="\e[33m"
B="\e[34m"
M="\e[35m"
C="\e[36m"
W="\e[37m"
RESET="\e[0m"
BOLT="\e[1m"

usage() {
	echo -e "$BOLT$C=========================================$RESET"
	echo -e "$BOLT$Y Lista de opcões do programa:$RESET"
	echo -e "$BOLT$C=========================================$RESET\n"

	echo -e "$BOLT$G  -d:$RESET$W Verifica$R data races$RESET e$R deadlocks$RESET"
	echo -e "$BOLT$G  -l:$RESET$W Verifica$R vazamentos de memória$RESET"
	echo -e "$BOLT$G  -s:$RESET$W Verifica cenários onde$R um filósofo deve morrer$RESET"
	echo -e "$BOLT$G  -c tempo:$RESET$W Verifica cenários onde$G nenhum filósofo deve morrer$RESET"
	echo -e "$BOLT$G  -t:$RESET$W Verifica$B o tempo de emissão da mensagem de morte$RESET"
	echo -e "$BOLT$G  -a tempo:$RESET$W Executa todos os tipos de testes$RESET\n"

	echo -e "$BOLT$C=========================================$RESET"
	echo -e "$BOLT Exemplo: ./philo_tester.sh -c 60"
	echo -e "$BOLT$C=========================================$RESET"

	exit 127
}

redirect_output() {
	local log_file="$1"
	exec 3>&1
	exec 4>&2
	exec 1>>"$log_file"
	exec 2>>"$log_file"
}

restore_output() {
	exec 1>&3 3>&-
	exec 2>&4 4>&-
}

progress_bar() {
	total=$1
	current=$2
	width=50
	progress=$(((current * width) / total))
	remaining=$((width - progress))

	printf "\r["
	for i in $(seq 0 $(($progress - 1))); do
		printf "$G#$RESET"
	done
	for i in $(seq 0 $(($remaining - 1))); do
		printf "$R-$RESET"
	done
	printf "] %d%%" $(((current * 100) / total))
}

run_progress_bar() {
	total=100
	for i in $(seq 1 $total); do
		progress_bar $total $i
	done
	rm -f leaks.log output.log valgrind.log drd.log temp_output.log
}

cleanup() {
	restore_output
	echo -e "\n\n$R A encerrar execução do$BOLT$W Philosophers Tester$RESET$R. e Limpar recursos...$RESET"
	run_progress_bar
	echo -e "\n"
	exit 124
}

if [ "$#" -eq 0 ] || { [ "$1" != "-a" ] && [ "$1" != "-l" ] && [ "$1" != "-d" ] && [ "$1" != "-s" ] && [ "$1" != "-c" ] && [ "$1" != "-t" ]; }; then
	usage
elif { [ "$1" == "-a" ] || [ "$1" == "-c" ]; } && { [ "$#" != 2 ] || [ $(echo "$2" | grep -qE '^-?[0-9]+$') ]; }; then
	echo -e "$BOLT$C=========================================$RESET"
	echo -e "$BOLT Exemplo: ./philo_tester.sh $1 60"
	echo -e "$BOLT$C=========================================$RESET"
	exit 127
fi

if [ ! -f "./philo" ]; then
	echo -e "🚨 $RED Executável $BOLT'philo'$RESTE$RED não encontrado!"
	exit 1
fi

trap cleanup SIGINT