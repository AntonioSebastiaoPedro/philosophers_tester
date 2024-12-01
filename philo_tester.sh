#!/bin/bash

rm output.log
if [ ! -f "./philo" ]; then
    echo "🚨 Executável 'philo' não encontrado!"
    exit 1
fi

#Testando cenários onde um filósofo deve morrer
echo "🔍 Testando cenários onde um filósofo deve morrer..."

test_cases=(
    "2 310 200 100"
    "3 400 200 150"
    "4 300 150 150"
    "5 500 200 300"
)

for case in "${test_cases[@]}"; do
    echo "🧪 Testando caso: ./philo $case"
    ./philo $case > output.log

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

echo "✔️ Testes concluídos!"


