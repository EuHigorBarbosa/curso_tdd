<!-- Cada use_case tem um documento proprio indicando as várias exceções que podem acontecer. -->

# Remote Authentication Use Case

>## Caso de sucesso (fluxo do happy path)
1. Sistema valida os dados
2. Sistema faz uma requisição para a URL da API de login
3. Sistema valida os dados recebidos da API
4. Sistema entrega os dados da conta do usuário

>## Exceção - URL inválida
1. Sistema retorna uma mensagem de erro inesperado

> ## Exceção - Dados inválidos
1. Sistema retorna uma mensagem de erro inesperado

>## Exceção - Resposta inválida
1. Sistema retorna uma mensagem de erro inesperado

> ## Exceção - Falha no servidor
1. Sistema retorna uma mensagem de erro inesperado

> ## Excecão Credenciais inválidas
1. Sistema retorna uma mensagem de erro informando que as credenciais estão erradas