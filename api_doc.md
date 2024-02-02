# Documentação da API de Categorias de trabalho

Abaixo, uma descrição dos endpoints disponíveis.


## 1. Listar todas as categorias de trabalho

<details>
<summary>GET /api/v1/job_categories</summary>

<br>

### Endpoint

```shell
GET /api/v1/job_categories
```

Retorna a lista com todas as categorias de trabalho. (Status: 200)

```json
[
    {
        "id": 1,
        "name": "Web Design"
    },
    {
        "id": 2,
        "name": "Programador Full Stack"
    },
    {
        "id": 3,
        "name": "Ruby on Rails"
    }
]
```

Retorno esperado caso não tenham categorias cadastradas. (Status: 200):

```json
  []
```

### Erros tratados

Erro interno de servidor (Status: 500)

Retorno esperado:

```json
{
  { "error": "Houve um erro interno no servidor ao processar sua solicitação." }
}
```
</details>

## 2. Buscar por usuários na plataforma Portifoliorrr através dos campos `job_category.name` e `profile_job_category.description`

<details>
<summary>GET /api/v1/profiles/search?search=query</summary>

<br>

### Endpoint

query: Parâmetro que recebe string a ser buscada nos campos listados no título.

```shell
GET /api/v1/profiles/search?search=query
```

Retorna uma lista com todos os usuários referentes a busca. (Status: 200)

```json
[
  {
      "user_id": 1,
      "full_name": "João CampusCode Almeida",
      "job_categories": [
          {
            "title": "Web Design",
            "description": null
          },
          {
            "title": "Programador Full Stack",
            "description": null
          },
          {
            "title": "Ruby on Rails",
            "description": null
          }
      ]
  },
  {
      "user_id": 3,
      "full_name": "Gabriel Campos",
      "job_categories": [
          {
            "title": "Web Design",
            "description": null
          },
          {
            "title": "Ruby on Rails",
            "description": "faço umas app daora"
          },
          {
            "title": "Programador Full Stack",
            "description": "faço umas app loka"
          }
      ]
  }
]
```

Retorno esperado caso a busca não retorne resultados. (Status: 200):

```json
  []
```

### Erros tratados

Erro interno de servidor (Status: 500)

Retorno esperado:

```json
{
  "error": ["Houve um erro interno no servidor ao processar sua solicitação."]
}
```

Erro para query de busca vazia (Status: 400)

Este erro acontece quando a busca é feita sem informar o parâmetro obrigatório query. Exemplos de buscas que retornarão este erro:

```shell
GET /api/v1/profiles/search?search=

GET /api/v1/profiles/search/
```

Retorno esperado:

```json
{
"error": "É necessário fornecer um parâmetro de busca"
}
```
</details>

## 3. Criar convite para um usuário participar do projeto

<details>
<summary>POST /api/v1/invitations/</summary>

<br>

### Endpoint


```shell
POST /api/v1/invitations
```

Corpo da requisição:

```json
{
  "invitation": {
    "profile_id": 3,
    "project_title": "Projeto Cola?Bora!",
    "project_description": "Projeto Legal",
    "project_category": "Tecnologia",
    "colabora_invitation_id": 1,
    "message": "Venha participar do meu projeto!",
    "expiration_date": "2021-12-31",
    "status": "pending"
  }
}
```

Retorno esperado caso a requisição seja bem sucedida. (Status: 201)

```json
{
  "data": {
    "invitation_id": 1
  }
}
```

### Erros tratados

Erro para corpo da requisição vazio (Status: 400)

Resposta:
```json
{
  "error": "Houve um erro ao processar sua solicitação."
}
```

Este erro acontece quando a requisição é feita sem informar o corpo da requisição. Exemplo de requisição que retornará este erro:

campos vazios

```json
{}
```
id de usuário inválido

```json
{
  "invitation": {
    "profile_id": 999999999999999,
      etc...
  }
}
```

</details>

## 4. Editar status de convite

<details>
<summary>PATCH /api/v1/invitations/:id</summary>

<br>

### Endpoint

```shell
PATCH /api/v1/invitations/:id
```

Corpo da requisição:

```json
{
  "invitation": {
    "status": "accepted"
  }
}
```

Retorno esperado caso a requisição seja bem sucedida. (Status: 204)


### Erros tratados

Erro para corpo da requisição vazio (Status: 400)

Resposta:
```json
{
  "error": "Houve um erro ao processar sua solicitação."
}
```

Este erro acontece quando a requisição é feita sem informar o corpo da requisição. Um exemplo de requisição que retornará este erro:

```json
{}
```

Outro exemplo de requisição que retornará este erro:

```json
{
  "invitation": {
    "status": "XXXinvalid_statusXXX"
  }
}
```

Erro para id de convite inválido (Status: 404)

Este erro acontece quando a requisição é feita com um id de convite que não existe. Exemplo de requisição que retornará este erro:

```shell
PATCH /api/v1/invitations/999999999999999
```

Retorno esperado:

```json
{
  "error": "Não encontrado"
}
```

</details>
