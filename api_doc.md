# Documentação da API de Categorias de trabalho

Abaixo, uma descrição dos endpoints disponíveis.


## 1. Listar todas as categorias de trabalho

### Endpoint

```shell
GET /api/v1/job_categories
```

Retorna a lista com todas as categorias de trabalho. (Status: 200)

```json
]
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

## 2. Buscar por usuários na plataforma Portifoliorrr através dos campos `job_category.name` e `profile_job_category.description` 

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