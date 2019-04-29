# SubSubAdmin

Interface simples para o serviço de registro de assinaturas SubSub.

## Pre-requisitos

- Ruby 2.6.3
- Serviço SubSub já iniciado

## Como iniciar o servidor

- `bundle install`
- `rails server`

### Configurar endpoint

O endpoint do serviço de registros a ser consultado precisa ser configurado no Rails.
O valor default configurado em `config/application.rb` é `http://localhost:3001`.

### Arquitetura e comentários

A maior parte do projeto é _boilerplate_ para redirecionar as chamadas devidas ao serviço externo de registros.
A classe responsável por realizer as chamadas de fato é nomeada `SubSub`, e se encontra em `app/services/sub_sub.rb`.
A classe é simples, e apenas faz chamadas as rotas do endpoint do serviço externo, utilizando a gema `http.rb` para
executar as requisições em HTTP.

A classe retorna em todos os métodos dois valores:
- um booleano dizendo se a operação foi bem-sucedida
    - se sim, o segundo valor é a entidade criada, atualizada, ou uma coleção de entidades recuperadas
    - se não, o segundo valor é uma classe encapsulando os erros, que pode ser utilizada para adicionar os erros
    a uma instância compatível com o ActiveModel

Para os DTOs foi utilizado o ActiveModel, para facilitar o tratamento de erros e poder reutilizar o maquinário do Rails no _boilerplate_,
mas a aplicação em si não depende de nenhum banco de dados interno.

Existem algumas melhorias de performance, como utilizar um pool de instâncias de serviços para minimizar o descarte de conexões, que podem ser feitas em um futuro momento.

Não foi possível criar uma suíte de testes a tempo para o componente de chamada ao serviço SubSub.