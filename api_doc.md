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
{
  "message": "Não há categorias de trabalho cadastradas. Contate um admin do Portfoliorrr."
}
```

### Erros tratados

Erro interno de servidor (Status: 500)

Retorno esperado:

```json
{ 
  "error": ["Houve um erro interno no servidor ao processar sua solicitação."]
}
```