<!-- Cada use_case tem um documento proprio indicando as várias exceções que podem acontecer. -->

# Remote Authentication Use Case

>## Caso de sucesso (fluxo do happy path)
1. [OK] Sistema valida os dados (estamos enviando o dado para a api com o formato que a api espera receber)
2. [OK] Sistema faz uma requisição para a URL da API de login
3. [OK] Sistema valida os dados recebidos da API
4. [OK] Sistema entrega os dados da conta do usuário

>## Exceção - URL inválida
1. [Ok] Sistema retorna uma mensagem de erro inesperado

> ## Exceção - Dados inválidos
1. [OK] Sistema retorna uma mensagem de erro inesperado

>## Exceção - Resposta inválida
1. [OK] Sistema retorna uma mensagem de erro inesperado

> ## Exceção - Falha no servidor
1. [OK] Sistema retorna uma mensagem de erro inesperado

> ## Excecão Credenciais inválidas
1. [OK] Sistema retorna uma mensagem de erro informando que as credenciais estão erradas