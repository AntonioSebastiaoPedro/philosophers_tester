# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    philo_tester.sh                                    :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: ansebast <ansebast@student.42luanda.com    +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2024/12/01 13:23:47 by ansebast          #+#    #+#              #
#    Updated: 2024/12/06 08:51:17 by ansebast         ###   ########.fr        #
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

##===================Teste de cenários para Data Races
if [ "$1" = "-a" ] || [ "$1" = "-d" ]; then
	test_cases=(
		"$(shuf -i 1-179 -n 1) $(shuf -i 400-800 -n 1) $(shuf -i 60-800 -n 1) $(shuf -i 60-800 -n 1) 1"
		"$(shuf -i 1-179 -n 1) $(shuf -i 400-800 -n 1) $(shuf -i 60-800 -n 1) $(shuf -i 60-800 -n 1)"
		"$(shuf -i 1-179 -n 1) $(shuf -i 400-800 -n 1) $(shuf -i 60-800 -n 1) $(shuf -i 60-800 -n 1) 1"
		"$(shuf -i 1-179 -n 1) $(shuf -i 400-800 -n 1) $(shuf -i 60-800 -n 1) $(shuf -i 60-800 -n 1)"
		"$(shuf -i 1-179 -n 1) $(shuf -i 400-800 -n 1) $(shuf -i 60-800 -n 1) $(shuf -i 60-800 -n 1) 1"
		"$(shuf -i 1-179 -n 1) $(shuf -i 400-800 -n 1) $(shuf -i 60-800 -n 1) $(shuf -i 60-800 -n 1)"
		"$(shuf -i 1-179 -n 1) $(shuf -i 400-800 -n 1) $(shuf -i 60-800 -n 1) $(shuf -i 60-800 -n 1) 1"
		"5 60 200 200 1000"
		"77 800 600 200 1000"
		"91 777 523 257"
		"3 600 300 300 1000"
		"47 800 400 400 1000"
		"2 100 100 100 1000"
		"1 800 100 100 1000"
		"2 310 2000 100 1000"
		"3 400 2000 150"
		"4 300 3000 150 1000"
		"5 500 2000 300 1000"
		"10 200 200 200"
		"100 120 65 65"
		"179 800 400 400"
		"5 1000 1000 1000 100"
		"4 310 200 200"
		"5 410 200 200"
		"3 600 300 300"
		"7 401 200 200"
	)
	echo -e "$BOLT$C==========================================================$RESET"
	echo -e "🔍 A Testar cenários para Deadlocks..."
	echo -e "$BOLT$C==========================================================$RESET\n"
	for case in "${test_cases[@]}"; do
		echo "🧪 Caso de teste: ./philo $case"
		redirect_output "output.log"
		timeout 5 stdbuf -oL ./philo $case
		restore_output
		if [ $? -eq 124 ]; then
			echo -e "❌ Deadlock detectado (programa travou ou demorou demais).\n"
		else
			echo -e "✅ Sem deadlock detectado.\n"
		fi
	done
	echo -e "\n"

	echo -e "$BOLT$C==========================================================$RESET"
	echo -e "🔍 A Testar cenários para Data Races com Helgrind..."
	echo -e "$BOLT$C==========================================================$RESET\n"

	for case in "${test_cases[@]}"; do
		echo "🧪 Caso de teste: ./philo $case"
		redirect_output "valgrind.log"
		valgrind --tool=helgrind ./philo $case
		restore_output
		if grep -q "data race" valgrind.log; then
			echo -e "❌ Possível Data Race detectado!\n"
		else
			echo -e "✅ Sem Data Races detectados.\n"
		fi
	done
	echo -e "\n"

	echo -e "$BOLT$C=====================================================$RESET"
	echo -e "🔍 A Testar cenários para Data Races com DRD..."
	echo -e "$BOLT$C=====================================================$RESET\n"
	for case in "${test_cases[@]}"; do
		echo "🧪 caso: ./philo $case"

		redirect_output "drd.log"
		valgrind --tool=drd --check-stack-var=yes ./philo $case
		restore_output
		if grep -q "Conflicting" drd.log; then
			echo "❌ Data Race detectado!"
		else
			echo "✅ Sem Data Races detectados."
		fi
		echo -e "\n"
	done
	rm -f output.log valgrind.log drd.log
	echo -e "\n"
fi