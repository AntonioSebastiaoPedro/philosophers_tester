# `Philosophers Tester`

## Descrição do Projeto

O `philo_tester.sh` é um script desenvolvido para automatizar testes no projeto **Philosophers** da **Escola 42**, que simula o clássico problema dos filósofos, também conhecido como **O jantar dos filósofos**. Este script cobre uma ampla gama de cenários para verificar aspectos como **deadlocks**, **data races**, **vazamentos de memória**, **cenários em que um filósofo deve morrer**, **cenários em que nenhum filósofo deve morrer** e **tempo de emissão das mensagens de morte**.

O script permite executar todos os testes de uma vez ou apenas testes específicos, de acordo com as necessidades do utilizador.

## Funcionalidades

- **Testes de Deadlocks**: Verifica se o programa congela ou se comporta de forma inconsistente.
- **Testes de Data Races**: Identifica condições de corrida usando ferramentas como Valgrind e DRD.
- **Verificação de vazamentos de memória**: Utiliza Valgrind para detectar problemas relacionados à alocação de memória.
- **Cenários onde nenhum filósofo deve morrer**: Valida o correto comportamento do programa nestes cenários.
- **Cenários onde um filósofo deve morrer**: Verifica se o programa identifica e reporta corretamente a morte de um filósofo.
- **Validação do tempo de emissão das mensagens de morte**: Garante que as mensagens sejam exibidas no tempo correto (10ms no máximo depois da morte do philósofo).

## Pré-requisitos

1. **Executável do projeto**: O script requer o executável `philo` no mesmo diretório.
2. **Ferramentas de análise**: As seguintes ferramentas devem estar instaladas no sistema:
   - **Valgrind**

Certifique-se de que o executável `philo` foi compilado corretamente antes de iniciar os testes.

## Uso

Para rodar o script, certifique-se de que ele tenha permissões de execução. Execute os seguinte comando no terminal:

```bash
chmod +x philo_tester.sh
bash philo_tester.sh [opção] [parâmetros]
```

### Opções Disponíveis

| Opção          | Descrição                                                                                  		     |
|----------------|-----------------------------------------------------------------------------------------------------------|
| `-d`           | Testa **data races** e **deadlocks**.                                                    		     |
| `-l`           | Verifica **vazamentos de memória**.                                                      		     |
| `-s`           | Valida cenários onde **um filósofo deve morrer**.                                        		     |
| `-c tempo`     | Testa cenários onde **nenhum filósofo deve morrer**, aceitando como parâmetro o tempo máximo de execução. |
| `-t`           | Verifica o **tempo de emissão da mensagem de morte**.                                    		     |
| `-a`           | Executa **todos os testes disponíveis**.                                                		     |

### Exemplos de Uso

1. Testar todos os cenários:
   ```bash
   bash philo_tester.sh -a
   ```

2. Verificar deadlocks e data races:
   ```bash
   bash philo_tester.sh -d
   ```

3. Testar cenários onde nenhum filósofo deve morrer por 60 segundos:
   ```bash
   bash philo_tester.sh -c 60
   ```

4. Verificar vazamentos de memória:
   ```bash
   bash philo_tester.sh -l
   ```

## Resultados e Logs

Os resultados de cada teste são exibidos no terminal e armazenados em arquivos temporários durante a execução. Esses arquivos são automaticamente excluídos ao final do script.

### Interpretação dos Resultados

- **✅ Sem problemas detectados**: O programa passou no teste com sucesso.
- **❌ Problema detectado**: Indica falha no teste.

## Contribuições

Contribuições para melhorias no script são bem-vindas! Por favor, envie **pull requests** ou abra **issues** no repositório oficial:

[Philosophers Tester no GitHub](https://github.com/AntonioSebastiaoPedro/philosophers_tester)

---

**Autor:** Antonio Sebastião Pedro <br>
**42 Username:** ansebast <br>
**E-mail:** antoniosebastiaopedro19@outlook.com

🚀 **Bons testes!**