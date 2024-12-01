#!/bin/bash
if [ -f "output.log" ]; then
	rm output.log
fi

if [ ! -f "./philo" ]; then
	echo "🚨 Executável 'philo' não encontrado!"
	exit 1
fi

#===================Testes de vazamento de memória
echo "🔍 Iniciando testes de vazamento de memória para Philosophers..."
test_cases=(
	"2 800 200 200"
	"1 800 200 200"
	"200 800 200 200"
	"5 5000 1000 1000"
	"5 200 100 100"
	"5 800 200 200 10"
	"5 810 200 200 9223372036854775809"
	"1 -92233720368547758099 200 200 10"
	"5 1 1 1"
	"-1 800 200 200"
	"0 800 200 200"
	"200 800 200 200"
)

for case in "${test_cases[@]}"; do
	echo "🧪 Testando caso: ./philo $case"
	timeout 60 valgrind --leak-check=full ./philo $case >leaks.log 2>&1
	leaks_count=$(grep -c "lost" leaks.log)
	if [ $leaks_count -ne 0 ]; then
		echo "❌ Vazamento de memória detectado!"
	else
		echo "✅ Sem vazamentos de memória!"
	fi
	echo ""
done

##===================Testes de cenários onde um filósofo deve morrer
echo "🔍 Testando cenários onde um filósofo deve morrer..."
test_cases=(
	"2 310 200 100"
	"3 400 200 150"
	"4 300 150 150"
	"5 500 200 300"
)

for case in "${test_cases[@]}"; do
	echo "🧪 Testando caso: ./philo $case"
	./philo $case >output.log

	death_message_count=$(grep -c "died" output.log)
	post_death_messages=$(grep -A1 "died" output.log | tail -n +2)

	echo "Resultado:"
	if [ "$death_message_count" -eq 1 ]; then
		echo "✅ Apenas uma mensagem de morte encontrada."
	else
		echo "❌ Número incorreto de mensagens de morte ($death_message_count encontradas)."
	fi

	if [ -z "$post_death_messages" ]; then
		echo "✅ Nenhuma mensagem após a morte."
	else
		echo "❌ Mensagens encontradas após a morte:"
		echo "$post_death_messages"
	fi
	echo ""
done
echo ""

echo "✔️ Testes concluídos!"
