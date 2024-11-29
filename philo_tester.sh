#!/bin/bash

rm output.log
if [ ! -f "./philo" ]; then
    echo "🚨 Executável 'philo' não encontrado!"
    exit 1
fi

# Teste 1: Vazamento de memória
echo "🔍 Testando vazamento de memória:"
echo "Teste: ./philo 4 800 200 200"
valgrind --leak-check=full --error-exitcode=1 ./philo 4 800 200 200 > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "❌ Vazamento de memória detectado!"
else
    echo "✅ Sem vazamentos de memória!"
fi
# Teste 2: Temporização de morte
echo "🔍 Testando temporização de morte:"
start_time=$(date +%s%3N)
./philo 4 310 200 200 > output.log &
#sleep 2
end_time=$(date +%s%3N)
elapsed=$((end_time - start_time))
if [ $elapsed -le 810 ]; then
    echo "✅ Tempo de morte dentro do limite (<= 10ms)!"
else
    echo "❌ Tempo de morte excedeu o limite!"
fi
> output.log
# Teste 3: Verificar consumo
echo "🔍 Testando se cada filósofo comeu o suficiente:"
echo "5 800 200 200 "
n_philo=(5)
time_die=(810)
time_eat=(200)
time_sleep=(200)
n_eat=(10)
./philo $n_philo $time_die $time_eat $time_sleep $n_eat > output.log
for i in $(seq 1 5); do
    count=$(grep -c "$i is eating" output.log)
    if [ $count -lt $n_eat ]; then
        echo "❌ Filósofo $i não comeu $n_eat vezes!"
    else
        echo "✅ Filósofo $i comeu pelo menos $n_eat vezes!"
    fi
done
> output.log
# Teste 4: Diversos parâmetros
echo "🔍 Testando diversos parâmetros..."
./philo 1 810 200 200 10 > /dev/null && echo "✅ 1 Filósofo testado com sucesso!"
./philo 2 810 200 200 10 > /dev/null && echo "✅ 2 Filósofos testados com sucesso!"
./philo 5 810 200 200 10 > /dev/null && echo "✅ 5 Filósofos testados com sucesso!"
