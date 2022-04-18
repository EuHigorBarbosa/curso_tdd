Arquivo de BDD (Behavior Driven Development - visão não técnica) - Para cada Feature eu tenho pelo menos um use case...neste caso o use_case autenticação por API usando internet. Outro caso de uso que poderia existir seria a autenticação local. 
Cada use_case tem um documento proprio indicando as várias exceções que podem acontecer.

Feature: Login
Como um cliente
Quero poder acessar minha conta e me manter logado
Para que eu possa ver e responder enquetes de forma rápida

Centário: Credenciais Válidas
Dado que o cliente informou credenciais válidas
Quando solicitar para fazer login
Entnao o sistema deve enviar o usuário para a tela de pesquisas
E manter o usuário conectado

Cenário: Credenciais Inválidas
Dado que o cliente informou credenciais inválidas
Quando solicitar para fazer login
Então o sistema deve retornar uma mensagem de erro