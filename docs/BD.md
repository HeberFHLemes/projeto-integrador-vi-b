# Banco de dados

Para a persistência dos dados com um banco de dados local, utilizaremos o banco de dados [SQLite](https://sqlite.org/), realizando a implementação de acordo com a modelagem abaixo.

## Modelo Entidade-Relacionamento

Diagrama ER (modelo lógico) desenvolvido com a ferramenta **brModelo** ([https://www.sis4.com/](https://www.sis4.com/)).

![Diagrama ER](diagramas/diagrama_er.webp)

### Comentários sobre a modelagem

- Os tipos dos dados foram definidos com base no uso do SQLite como banco de dados.

- Valores monetários serão representados em centavos, por isso a escolha do tipo de dado **INTEGER** para eles.

- A tabela **Atendimento** representará a realização de um agendamento. Ela conterá o valor cobrado para evitar que uma alteração no preço de um serviço também altere qual foi o valor cobrado em agendamentos antigos.

- Ainda na tabela **Atendimento**, sua chave primária será também a referência ao agendamento (chave estrangeira). Assim, haverá apenas um atendimento para cada agendamento realizado.

- A coluna **observacoes** na tabela **Agendamento** será um campo opcional.

- Números de telefone e datas (com horários) serão representados com o tipo **TEXT**, sendo que suas formatações serão abordadas na seção seguinte.

## Implementação