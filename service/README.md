# SubSub

Serviço de registro de assinaturas SubSub.

## Pre-requisitos

- Ruby 2.6.3

## Como iniciar o servidor

- `bundle install`
- criar o banco de dados com `rake db:migrate` e provisionar com `rake db:setup`
- `rails server`

### Arquitetura e comentários

O projeto segue as convenções Rails básicas para a criação de uma aplicação REST, sem maiores diferenças.

Para facilitar o desenvolvimento foi utilizado o SQLite como opção de banco.

As classes onde se concentram as lógicas de validação são justamente os modelos, que são:
- `app/models/client.rb` definindo o cliente a ser cadastrado
- `app/models/subscription.rb` definindo uma assinatura de seguro para o cliente
As validações de email e CPF utilizam gemas externas, `cpf_cnpj` e `validators` para simplificar o desenvolvimento.
As validações de IMEI são feitas na mão, e tentam simplificar ao máximo a entrada dos IMEIs, já que apesar
do formato deles serem bem-definidos, o formato exibido pelas interfaces nos celulares não é e pode variar
de fabricante a fabricante.

Todas as validações pedidas foram implementadas, com uma suíte de testes garantindo o funcionamento de cada validação.

O projeto esqueleto foi feito utiliando-se a chave `--api` do gerador de projetos do Rails para reduzir o número de componentes carregados para somente os mais úteis a criação de APIs sem interface direta para humanos.

### Rotas
Todas as rotas aceitam JSON.

- `GET /clients`: lista todos os clientes na base de dados.
    - Resposta:
    ```json
    [
        {
            "id": 1,
            "name": "Hugo da Silva Sauro",
            "cpf": "351.116.040-57",
            "email": "hugo.silva@gmail.com",
            "created_at": "2019-04-28T22:04:29.546Z",
            "updated_at": "2019-04-28T22:49:43.226Z"
        },
        {
            "id": 2,
            "name": "Laura Castelo Costa",
            "cpf": "704.543.630-01",
            "email": "laura2299@hotmail.com",
            "created_at": "2019-04-28T22:04:29.570Z",
            "updated_at": "2019-04-28T22:50:10.317Z"
        }
    ]
    ```
- `GET /clients/:id`: recupera dados de um cliente específico.
    - Rota: `/clients/1`
    - Resposta:
    ```json
    {
        "id": 1,
        "name": "Hugo da Silva Sauro",
        "cpf": "351.116.040-57",
        "email": "hugo.silva@gmail.com",
        "created_at": "2019-04-28T22:04:29.546Z",
        "updated_at": "2019-04-28T22:49:43.226Z"
    }
    ```
- `POST /clients`: registra um novo cliente na base.
    - Payload:
    ```json
    {
        "name": "João Moura",
        "cpf": "439.755.620-21",
        "email": "jm1994@yahoo.com"
    }
    ```
    - Resposta:
    ```json
    {
        "id": 3,
        "name": "João Moura",
        "cpf": "439.755.620-21",
        "email": "jm1994@yahoo.com",
        "created_at": "2019-04-28T22:56:13.344Z",
        "updated_at": "2019-04-28T22:56:13.344Z"
    }
    ```
- `PUT /clients/:id`: atualiza um cliente na base.
    - Rota: `/clients/3`
    - Payload:
    ```json
    {
        "name": "João Moura Coutinho"
    }
    ```
    - Resposta:
    ```json
    {
        "id": 3,
        "name": "João Moura Coutinho",
        "cpf": "439.755.620-21",
        "email": "jm1994@yahoo.com",
        "created_at": "2019-04-28T22:56:13.344Z",
        "updated_at": "2019-04-28T23:04:29.567Z"
    }
    ```
- `DELETE /clients/:id`: remove um cliente da base.
    - Rota: `/clients/3`
- `GET /clients/:id/subscriptions`: lista todas as assinaturas de um dado cliente na base de dados.
    - Rota: `/clients/2/subscriptions`
    - Resposta:
    ```json
    [
        {
            "id": 2,
            "client_id": 2,
            "imei": "35243062483476",
            "phone_model": "Motorola G6 Plus",
            "full_price": "299.9",
            "payments": 6,
            "created_at": "2019-04-28T22:04:29.630Z",
            "updated_at": "2019-04-28T22:04:29.630Z"
        },
        {
            "id": 3,
            "client_id": 2,
            "imei": "10258264255525",
            "phone_model": "Motorola G7 Power",
            "full_price": "499.9",
            "payments": 12,
            "created_at": "2019-04-28T22:04:29.655Z",
            "updated_at": "2019-04-28T22:04:29.655Z"
        }
    ]
    ```
- `POST /clients/:id/subscriptions`: cria nova assinatura para um dado cliente.
    - Rota: `/clients/2/subscriptions`
    - Payload:
    ```json
    {
        "imei": "995671072031854",
        "phone_model": "Motorola G5 Plus",
        "full_price": "199.9",
        "payments": 6
    }
    ```
    - Resposta:
    ```json
    {
        "id": 5,
        "client_id": 2,
        "imei": "99567107203185",
        "phone_model": "Motorola G5 Plus",
        "full_price": "199.9",
        "payments": 6,
        "created_at": "2019-04-28T23:31:07.454Z",
        "updated_at": "2019-04-28T23:31:07.454Z"
    }
    ```
- `GET /subscriptions/:id`: recupera dados de uma assinatura específica.
    - Rota: `/subscriptions/3`
    - Resposta:
    ```json
    {
        "id": 3,
        "client_id": 2,
        "imei": "10258264255525",
        "phone_model": "Motorola G7 Power",
        "full_price": "499.9",
        "payments": 12,
        "created_at": "2019-04-28T22:04:29.655Z",
        "updated_at": "2019-04-28T22:04:29.655Z"
    }
    ```
- `PUT /subscriptions/:id`: atualiza uma assinatura na base.
    - Rota: `/subscriptions/5`
    - Payload:
    ```json
    {
        "full_price": "249.9",
        "payments": 8
    }
    ```
    - Resposta:
    ```json
    {
        "id": 5,
        "client_id": 2,
        "imei": "99567107203185",
        "phone_model": "Motorola G5 Plus",
        "full_price": "249.9",
        "payments": 8,
        "created_at": "2019-04-28T23:31:07.454Z",
        "updated_at": "2019-04-28T23:37:48.332Z"
    }
    ```
- `DELETE /clients/:id`: remove uma assinatura da base.
    - Rota: `/subscriptions/5`
