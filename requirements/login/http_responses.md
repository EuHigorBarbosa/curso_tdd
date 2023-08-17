# HTTP

> ## Sucesso
1. Request com verbo http válido (post)
2. Passsar nos headers o content type JSON
3. Chamar request com body correto
4. OK - 200 e resposta com dados
5. No content - 204 e resposta sem dados

> ## Erros
1. Bad request - 400
2. Unauthorized - 401
3. Forbidden - 403
4. Not found - 404
5. Internal server error - 500

> ## Exceção - Status code diferente dos citados acima (qualquer outro erro)
1. Internal server error - 500

> ## Exceção - http request deu alguma exceção
1. Internal server error - 500

> ## Exceção - verbo http inválido
1. Internal server error - 500