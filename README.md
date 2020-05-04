# Iugu | Desafio - Sistema de Contas bancárias

## Desafio

<https://github.com/iugu/accounting_challenge>

## Gemas adicionais sobre a stack rails

- jwt - Json Web Token (JWT) para autenticação baseada em token
- bcrypt - gerar senhas seguras
- pry - debuggar a aplicação
- rspec-rails - Testes `(docker-compose run web bundle exec rspec)`
- database_cleaner-active_record - para limpar o banco de dados a cada execução do teste
- factory_bot_rails - suporte para instancias de classes durante o teste
- faker - gerar dados aleatórios

## Git

padrão de mensagens: <http://karma-runner.github.io/4.0/dev/git-commit-msg.html>

exemplo:

```bash
<type>(<scope>): <subject>
```

## Requisitos Opcionais

- Docker (recomendado: version 19.03.8)
- Docker-compose (recomendo: version 1.25.4)

## Setup

1. `docker-compose build`
2. `docker-compose up -d`
3. `docker-compose start db`
4. `docker-compose exec web bundle exec rake db:create db:migrate`

## Test

```
docker-compose run web bundle exec rspec
```

--------------------------------------------------------------------------------

## Criando um cliente

```
POST http://localhost:3000/customers
params:
{
    "customer": {
        "name": "Steve J",
        "email": "steve@honors.com.br",
        "document": "874.730.280-14",
        "password": "123123123"
    }
}
```

## Autenticando cliente com JWT

```
POST http://localhost:3000/auth
params:
{
    "authentication": {
        "email": "steve@honors.com.br",
        "password": "123123123"
    }
}
```

retorno:

```json
{
    "token": "eyJhbGciOiJIUzI1NiJ9.eyJjdXN0b21lcl9pZCI6MX0.HWWJSLQWp4tJnx3ewQcA52ZjLJ-Dd7k95VZx0mA2qsQ"
}
```

## Criando uma conta para o cliente

```
POST http://localhost:3000/accounts

headers:
Authorization : "Token"

params:
{
    "account": {
        "id": "123456" (opcional),
        "name": "Padrao",
        "balance": "200,00" (reias)
    }
}
```

retorno:

```json
{
    "id": "123456",
    "token": "eyJhbGciOiJIUzI1NiJ9.eyJjdXN0b21lcl9pZCI6MX0.HWWJSLQWp4tJnx3ewQcA52ZjLJ-Dd7k95VZx0mA2qsQ"
}
```

## Transferir valor entre contas

```
POST http://localhost:3000/transfer

headers:
Authorization : "Token"

{
    "movement": {
        "source_account_id": "1588614267",
        "destination_account_id": "123456",
        "amount": "20,00"
    }
}
```

retorno:

```json
{
    "message": "transfer successfully"
}
```

retorno caso a conta de origem não exista:

```json
{
    "error": "source account not exist"
}
```

retorno caso a conta de destino não exista:

```json
{
    "error": "destination account not exist"
}
```

retorno caso a conta origem não tenha saldo para transação:

```json
{
    "error": "source account has no available limit"
}
```

## Consultando o saldo de uma conta

```
GET http://localhost:3000/balance/123456(account_id)

headers:
Authorization : "Token"
```

retorno:

```json
{
    "balance": "R$150,00"
}
```
