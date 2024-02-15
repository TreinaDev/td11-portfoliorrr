# Portfoliorrr

O Portfoliorrr é uma rede social com funcionalidades de portfólio para pessoas que querem compartilhar o seu trabalho e procurar outros trabalhos, seja para buscar inspiração ou novos conhecimentos.

## Conteúdo

- [Informações técnicas](https://github.com/TreinaDev/td11-portfoliorrr?tab=readme-ov-file#informa%C3%A7%C3%B5es-t%C3%A9cnicas)
- [Como configurar a aplicação](https://github.com/TreinaDev/td11-portfoliorrr?tab=readme-ov-file#como-configurar-a-aplica%C3%A7%C3%A3o)
- [Ver emails enviados em ambiente de desenvolvimento](https://github.com/TreinaDev/td11-portfoliorrr?tab=readme-ov-file#ver-emails-enviados-em-ambiente-de-desenvolvimento)
- [Como visualizar a aplicação no navegador](https://github.com/TreinaDev/td11-portfoliorrr?tab=readme-ov-file#como-visualizar-a-aplica%C3%A7%C3%A3o-no-navegador)
- [Documentação da API](https://github.com/TreinaDev/td11-portfoliorrr?tab=readme-ov-file#documenta%C3%A7%C3%A3o-da-api)

## Informações técnicas

- Versão Ruby: 3.2.2
- Versão Rails: 7.1.2

## Como configurar a aplicação

- Abra a pasta raiz da aplicação em um terminal;
- Instale a biblioteca [libvips](https://github.com/libvips/libvips). No Ubuntu, digite: `sudo apt install libvips`
- Rode o comando `bin/setup` e aguarde sua conclusão;
- Rode o comando `yarn install` (necessário ter `node` instalado em sua máquina);

## Como visualizar a aplicação no navegador

- Siga as instruções de configuração da aplicação
- Rode o comando `bin/dev`;
- Acesse a aplicação através do endereço `http://localhost:4000/`

## Ver emails enviados em ambiente de desenvolvimento

- Siga as instruções de configuração da aplicação;
- Instale localmente a gem `mailcatcher` executando o comando abaixo:
```shell
gem install mailcatcher 
```
- Execute o comando abaixo para iniciar o `mailcatcher`
```shell
mailcatcher
```
- Acesse o MailCatcher através do endereço `http://localhost:1080`. Todos e-mails enviados serão mostrados nessa página, que emula uma caixa de entrada.

## Como rodar os testes da aplicação

- Siga as instruções de configuração da aplicação
- Rode `rake spec`, após ter a aplicação configurada;

## Documentação da API

A documentação da API pode ser consultada [neste link](https://github.com/TreinaDev/td11-portfoliorrr/blob/main/api_doc.md)
