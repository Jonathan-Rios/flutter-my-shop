<h1 align="center">Flutter - My Meals</h1>

<p align="center">

<div align="center">

  ![Last commit](https://img.shields.io/github/last-commit/Jonathan-Rios/flutter-my-shop?color=4DA1CD 'Last commit') &nbsp;
  ![Repo size](https://img.shields.io/github/repo-size/Jonathan-Rios/flutter-my-shop?color=4DA1CD 'Repo size') &nbsp;
  ![Languages](https://img.shields.io/github/languages/count/Jonathan-Rios/flutter-my-shop?color=4DA1CD 'Languages') &nbsp;
    <img 
      alt="License"
      src="https://img.shields.io/static/v1?label=license&message=MIT&color=E51C44&labelColor=0A1033"
    />
  </p>
  
</div>

<br>

<h3 align="center">Imagem prévia da aplicação: criando usuário e comprando</h3>

<div align="center">
  <img src=".github/project-preview_01.gif?style=flat" alt="Cover" width="350" height="650">
</div>

<h3 align="center">Imagem prévia da aplicação: acessando com usuário e adicionando um novo produto</h3>

<div align="center">
  <img src=".github/project-preview_02.gif?style=flat" alt="Cover" width="350" height="650">
</div>


<br>

## 💻 Projeto
Descrição do projeto:
Essa aplicação foi desenvolvida para estudos seguindo os ensinamentos do **[curso](https://www.udemy.com/course/curso-flutter/)** de Flutter.

O projeto é uma loja que possui:
  * Criação de usuário
  * Autenticação
  * Listagem de produtos
  * Favoritar produtos e filtrar pelos favoritos.
  * Adicionar, remover itens do Carrinho
  * Adicionar, editar e remover produtos

Nele é abordado:
  * Gerenciamento de estado
  * Utilização de CRUD com REST API (Firebase)
  * Criação de usuários com autenticação
  * Conteúdos exclusivos entre usuários

 
## 🧪 Tecnologias

Esse projeto foi desenvolvido com as seguintes tecnologias:

- [Flutter](https://flutter.dev/)
- [Dart](https://dart.dev/)
- [Firebase](https://firebase.google.com/)


## 🚀 Como executar

Clone o projeto e acesse a pasta do mesmo.

```bash
$ git clone https://github.com/Jonathan-Rios/flutter-my-shop.git

$ cd flutter-my-shop
```

Para iniciá-lo deverá ter um ambiente configurado com um dispositivo ou emulador para exibir, também é possível rodar no navegador, em caso de dúvidas este é o [link](https://docs.flutter.dev/get-started/install) da documentação de configuração.

Será necessário também uma api criada no FireBase, com Provedores de login por e-mail/senha habilitada.

Regras utilizadas no Firebase:

```javascript
{
  "rules": {
    "orders": {
      "$uid": {
        ".write": "$uid === auth.uid",
        ".read": "$uid === auth.uid",
      },
    },
    "userFavorites": {
    	"$uid": {
      	".write": "$uid === auth.uid",
        ".read": "$uid === auth.uid",
      },
    },
    "products": {
        ".write": "auth != null",
        ".read": "auth != null",
    }
  }
}
```

Uma vez configurado e com o dispositivo selecionado, rode o comando no terminal com as Envs obtidas no Firebase:
```bash

# Iniciar o projeto
$ flutter run lib/main.dart --dart-define=BASE_URL=LINK_DA_SUA_API_FIREBASE --dart-define=WEB_API_KEY=SUA_WEB_API_KEY

```

## 📝 License

Esse projeto está sob a licença MIT. Veja o arquivo [LICENSE](./LICENSE.md) para mais detalhes.

<br />
 
---
<br />

<a href="https://github.com/Jonathan-Rios">
 <img src="https://github.com/Jonathan-Rios.png" width="100px;" alt="" style="border-radius:50%" />
 <br />
 <sub><b>Jonathan Rios Sousa</b></sub></a>

💠 NeverStopLearning 💠
 

[![Linkedin Badge](https://img.shields.io/badge/-Jonathan-blue?style=flat-square&logo=Linkedin&logoColor=white&link=https://www.linkedin.com/in/jonathan-rios-sousa-19b3431b6/)](https://www.linkedin.com/in/jonathan-rios-sousa-19b3431b6/) 
[![Gmail Badge](https://img.shields.io/badge/-jonathan.riosousa@gmail.com-c14438?style=flat-square&logo=Gmail&logoColor=white&link=mailto:jonathan.riosousa@gmail.com)](mailto:jonathan.riosousa@gmail.com)