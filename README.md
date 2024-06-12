# Projeto Ye

O Projeto Ye é uma aplicação voltada para a área da saúde, acessível para pessoas de todas as idades.

## Repositório Ye-gestao-em-saude

Este repositório contém todas as telas programadas em Dart utilizando o framework Flutter. Variáveis sensíveis são armazenadas localmente em um arquivo `.env`. A consulta de dados do banco, o envio de e-mails e consultas à inteligência artificial não são processados neste código.

> **OBS:** A aplicação apenas envia requisições ao servidor onde está hospedada a API em Python.

## Repositório [yee_api](https://github.com/leonardocardenuto/yee_api)

Assim como o repositório anterior, este também encapsula variáveis-chave em um arquivo `.env`. Ele é responsável por toda a lógica de consulta a dados externos e disparo de e-mails.

---

## Telas de autenticação
![Login](https://github.com/RaphaelKameoka/Ye-gestao-em-saude/assets/133376318/40b14ef5-dcb8-452a-a784-c97dd1979e07)
![Erro no login](https://github.com/RaphaelKameoka/Ye-gestao-em-saude/assets/133376318/ca4b83d4-b3d4-4d37-a679-0f10110e3bc8)
![criar conta](https://github.com/RaphaelKameoka/Ye-gestao-em-saude/assets/133376318/df1af252-2693-4bc3-b1ba-3cb3437f3c2c)
![código de confirmação](https://github.com/RaphaelKameoka/Ye-gestao-em-saude/assets/133376318/4e19c5c6-e054-431b-9cce-66eaf01286e2)
![redefinir senha](https://github.com/RaphaelKameoka/Ye-gestao-em-saude/assets/133376318/27ae0bc8-2692-4c43-9634-104684c670ca)

Ao abrir o aplicativo, o usuário se depara com uma tela de login, onde pode inserir nome de usuário/email e senha, criar uma nova conta ou recuperar senha. Caso credenciais incorretas sejam fornecidas, uma tela de erro é mostrada.

### Funcionamento

Os dados inseridos pelo usuário são enviados a uma API em Python que está integrada com o sistema de bancos de dados da NEON. Os inputs são comparados com os dados do banco de dados e, caso sejam iguais, o usuário é liberado para prosseguir. Caso contrário uma tela de alerta com o erro é mostrada ao usuário.

---

## Tela de exames
![Tela de exames](https://github.com/RaphaelKameoka/Ye-gestao-em-saude/assets/133376318/016b63dc-697a-48e1-b1f5-06b6a8dc1d30)

Após a autenticação bem-sucedida, o paciente é direcionado para a tela de exames, que contém as seguintes funções:

- Inserir um novo exame realizado (enviando uma imagem)
- Verificar os valores das últimas aferições
- Trocar a foto de perfil
- Mostrar valores de referência
  
No quadro de últimas aferições, os valores são coloridos de acordo com a normalidade ou não do exame. Se o exame estiver muito alterado (em níveis perigosos), um alerta é mostrado na tela.

### Funcionamento

A partir do nome de usuário ou email, são chamadas rotas da API tanto para obter os dados quanto para enviá-los ao banco de dados. A função de inserir novos exames utiliza IA: a foto é transformada em base64 e enviada para a API, onde é convertida em imagem novamente, lida por uma IA que extrai as informações necessárias e insere no banco de dados.

---

## Chat com a IA
![Chat com a IA](https://github.com/RaphaelKameoka/Ye-gestao-em-saude/assets/133376318/9d460a9a-ea1c-4e7d-8fc3-1146bac1f272)

Um chat de texto com uma inteligência artificial que responde perguntas feitas pelo usuário.

### Funcionamento

As perguntas são classificadas em categorias, que possuem scripts pré-escritos para consultas no banco de dados, dar respostas humanizadas ou até indicar hospitais mais próximos.

---

## Histórico
![Tela de histórico 1](https://github.com/RaphaelKameoka/Ye-gestao-em-saude/assets/133376318/40aa14a9-09fa-4e21-a8f7-2a80e5cb203c)
![Tela de histórico 2](https://github.com/RaphaelKameoka/Ye-gestao-em-saude/assets/133376318/5f6506c4-38be-4532-a5a5-5bef89664926)

A tela de histórico permite a visualização de todos os valores de exames anteriormente realizados e cadastrados. O usuário pode escolher qual exame deseja visualizar a partir de um dropdown.

---

## Medicamentos
![Tela de medicamentos 1](https://github.com/RaphaelKameoka/Ye-gestao-em-saude/assets/133376318/7ab740ec-6538-4069-b31c-25e6c30fbad0)
![Tela de medicamentos 2](https://github.com/RaphaelKameoka/Ye-gestao-em-saude/assets/133376318/c2d5b556-831d-4d96-921d-642fe0f74f05)

Na tela de medicação, os usuários encontram uma lista de medicamentos cadastrados por eles, com informações como o nome do remédio, período de consumo e intervalo entre as doses. Para cadastrar um novo medicamento, basta clicar no "+" no lado inferior da tela, e um formulário aparecerá para ser preenchido.

### Funcionamento

Ao ser invocada, a tela faz uma requisição para a API, que retorna todos os medicamentos do usuário em formato de lista de dicionários. A partir dessa estrutura, é criada uma coluna com todos os valores necessários para o usuário se informar sobre sua agenda de medicamentos. Após preenchido o formulário, a API, conectada com o Google Agenda, pede permissão ao usuário e insere alarmes nos horários de tomar o remédio.

---

## Consultas
![Tela de consultas](https://github.com/RaphaelKameoka/Ye-gestao-em-saude/assets/133376318/ae9359b4-5217-4b66-8a9c-d522b22f20f9)

Uma tela muito semelhante à de medicamentos, onde podem ser visualizadas e cadastradas consultas futuras. Após cadastradas, são inseridos lembretes no Google Agenda.

### Funcionamento

Ao abrir a tela, uma requisição é feita para a API que retorna todos os exames e consultas futuros do usuário. A partir daí, o usuário pode visualizar e adicionar novas consultas, que serão automaticamente registradas no Google Agenda.
