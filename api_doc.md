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

Retorna um JSON com atributo `data`, cujo valor é a lista com todas as categorias de trabalho. **(Status: 200)**

```json
{
  "data": [
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
}
```

Retorno esperado caso não tenham categorias cadastradas. **(Status: 200)**:

```json
{
  "data": []
}
```

### Erros tratados

Erro interno de servidor **(Status: 500)**

Retorno esperado:

```json
{
  { "error": "Houve um erro interno no servidor ao processar sua solicitação." }
}
```
</details>

## 2. Retornar uma categoria de trabalho

<details>
<summary>GET /api/v1/job_categories/:id</summary>

<br>

### Endpoint

```shell
GET /api/v1/job_categories/:id
```

Retorno esperado caso a requisição seja bem sucedida. **(Status: 200)**

```json
{
  "data": {
    "id": 1,
    "name": "Web Design"
  }
}
```

Retorno esperado caso não encontre a categoria de trabalho. **(Status: 404)**:

```json
{
  "error": "Não encontrado"
}
```

### Erros tratados

Erro interno de servidor **(Status: 500)**

Retorno esperado:

```json
{
  { "error": "Houve um erro interno no servidor ao processar sua solicitação." }
}
```
</details>



## 3. Buscar por usuários na plataforma Portifoliorrr

<details>
<summary>GET /api/v1/profiles</summary>

<br>

### Endpoint

query: Parâmetro que recebe string de nome da categoria ou descrição da categoria de trabalho.

```shell
GET /api/v1/profiles/search=query
```

Retorna uma lista com todos os usuários referentes a busca. **(Status: 200)**

```json
{
  "data": [{ "profile_id": 1,
              "full_name": "João CampusCode Almeida",
              "job_categories": [
                                  { "name": "Web Design",
                                    "description": null },
                                  { "name": "Programador Full Stack",
                                    "description": null },
                                  { "name": "Ruby on Rails",
                                    "description": "Especialista em Rails" }
                                ]
            },
            { "profile_i": 3,
              "full_name": "Gabriel Campos",
              "job_categories": [
                                  { "name": "Web Design",
                                    "description": null },
                                  { "name": "Ruby on Rails",
                                    "description": "faço umas app daora" },
                                  { "name": "Programador Full Stack",
                                    "description": "faço umas app loka"}
                                ]
            }
          ]
}
```

Retorno esperado caso a busca não retorne resultados. **(Status: 200)**:

```json
  []
```

### Erros tratados

Erro interno de servidor **(Status: 500)**

Retorno esperado:

```json
{
  "error": ["Houve um erro interno no servidor ao processar sua solicitação."]
}
```

Resultados para query de busca vazia **(Status: 200)**

Quando a busca é feita sem informar o parâmetro query. Retorna todos os usuários disponíveis para trabalhos. Exemplo de resposta para requisição sem query:

```shell
GET /api/v1/profiles/search?search=

GET /api/v1/profiles/search/
```

Retorno esperado:

```json
{
  "data": [{ "profile_id": 1,
            "full_name": "João CampusCode Almeida",
            "job_categories": [
                                { "name": "Web Design",
                                  "description": null },
                                { "name": "Programador Full Stack",
                                  "description": null },
                                { "name": "Ruby on Rails",
                                  "description": "Especialista em Rails" }
                              ]
            },
            { "profile_id": 2,
              "full_name": "Maria CampusCode Almeida",
              "job_categories": [ { "name": "Web Design",
                                    "description": null },
                                  { "name": "Programador Full Stack",
                                    "description": null },
                                  { "name": "Ruby on Rails", 
                                    "description": "Especialista em Rails" } 
                                ] 
            },
            { "profile_id": 3,
              "full_name": "Gabriel Campos",
              "job_categories": [
                                  { "name": "Web Design",
                                    "description": null },
                                  { "name": "Ruby on Rails",
                                    "description": "faço umas app daora" },
                                  { "name": "Programador Full Stack",
                                    "description": "faço umas app loka" }
                                ]
            }
          ]
}
```
</details>

## 4. Mostrar dados completos do perfil de um usuário

<details>
<summary>GET /api/v1/profiles/:id</summary>

<br>

### Endpoint

Requisição deve incluir id do perfil

```shell
GET /api/v1/profiles/:id
```

Retorno esperado caso a requisição seja bem sucedida. **(Status: 200)**

```json

{
  "data": {
            "profile_id": 1,
            "email": "joao@almeida.com",
            "full_name": "João CampusCode Almeida",
            "cover_letter": "Sou profissional organizado, esforçado e apaixonado pelo que faço",
            "professional_infos": [
                                    { "company": "Campus Code",
                                      "position": "Dev",
                                      "start_date": "2022-12-12",
                                      "end_date": "2023-12-12",
                                      "description": "Muito código",
                                      "current_job": false }
                                  ],
            "education_infos": [
                                  { "institution": "Senai",
                                    "course": "Web dev full stack",
                                    "start_date": "2022-12-12",
                                    "end_date": "2023-12-12" },
                                  { "institution": "Senai",
                                    "course": "Web dev full stack",
                                    "start_date": "2022-12-12",
                                    "end_date": "2023-12-12" }
                                ],
            "job_categories": [
                                  { "name": "Web Design",
                                    "description": "Eu uso o Paint." },
                                  { "name": "Programador Full Stack",
                                    "description": "Prefiro Tailwind." },
                                  { "name": "Ruby on Rails",
                                    "description": "Eu amo Rails." }
                              ]
          }
}
```

### Erros tratados

Erro quando a id informada não é encontrada **(Status: 404)**

Resposta:
```json
{
  "error":"Perfil não existe."
}
```
</details>

## 5. Criar convite para um usuário participar do projeto

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
                  "expiration_date": "2021-12-31"
                }
}
```

Retorno esperado caso a requisição seja bem sucedida. **(Status: 201)**

```json
{
  "data": {
            "invitation_id": 1
          }
}
```

### Erros tratados

Erro para corpo da requisição vazio **(Status: 400)**

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

## 6. Editar status de convite

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

Retorno esperado caso a requisição seja bem sucedida. **(Status: 204)**


### Erros tratados

Erro para corpo da requisição vazio **(Status: 400)**

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

Erro para id de convite inválido **(Status: 404)**

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
