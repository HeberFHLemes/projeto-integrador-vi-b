# Arquitetura

Para o desenvolvimento do aplicativo, utilizamos a documentação oficial do _framework_ Flutter como
referência, especialmente suas recomendações para a organização da arquitetura e 
dos componentes de uma aplicação.

## Camadas

Conforme as recomendações da documentação, estruturamos o aplicativo em duas camadas principais: 
Apresentação (_Presentation_ / UI) e Dados (_Data_). 
Além delas, adicionamos uma camada intermediária de Domínio (_Domain_ / _Logic_), responsável por 
concentrar os modelos e contratos utilizados pelas demais camadas.

A camada de Apresentação contém as telas (_Pages_), os componentes visuais (_Widgets_) 
e os componentes responsáveis pelo gerenciamento de estado e pela comunicação entre a interface e 
as demais camadas (_ViewModels_).

A camada de Domínio contém as entidades e os modelos que representam os conceitos da aplicação, 
além dos contratos dos repositórios (_Repositories_). 
Esses contratos definem as operações disponibilizadas para a camada de Apresentação, 
sem expor detalhes de implementação ou persistência.

Por fim, a camada de Dados contém as implementações dos contratos definidos no Domínio, 
bem como os componentes responsáveis pelo acesso e persistência dos dados, 
incluindo os modelos utilizados nessa camada.

## Estrutura de pacotes

As funcionalidades estão presentes no diretório `features/`, sendo divididas em camadas. Em cada
funcionalidade, na camada apropriada, estão presentes telas, componentes visuais, regras de negócio,
etc.

Componentes reutilizados entre diferentes funcionalidades (_features_), que não fazem referência
a uma funcionalidade específica, estão presentes em `core/`. Neste pacote, há os componentes
responsáveis pela configuração e acesso ao banco de dados, 
componentes de formatação ou utilitários e componentes visuais, como os _layouts_ e os botões, 
todos utilizados por diferentes funcionalidades.

A composição, configuração de rotas, da injeção de dependências e do tema do aplicativo, além
das localizações suportadas, está presente em `app/`.

## Padrão MVVM (Model-View-ViewModel)

Para organizar a camada de Apresentação, adotamos o padrão arquitetural MVVM (Model-View-ViewModel),
separando a interface visual da lógica responsável por gerenciar seu estado e coordenar as operações.

No aplicativo, essa organização é representada pelos seguintes componentes:

**View**: representada pelas _Pages_ e seus _Widgets_, 
é responsável pela construção da interface e pela interação com o usuário, 
apresentando os estados disponibilizados pelo ViewModel.

**ViewModel**: responsável por manter e gerenciar o estado da interface, além de coordenar as operações 
solicitadas pela View, utilizando os contratos disponibilizados pela camada de Domínio. 
No aplicativo, utilizamos `ChangeNotifier` para notificar a interface sobre alterações de estado.

**Model**: representa os dados e conceitos utilizados pela aplicação. 
No projeto, essa responsabilidade está distribuída principalmente
entre as entidades e os modelos definidos nas camadas de Domínio e de Dados.

A comunicação entre a View e o ViewModel ocorre por meio de chamadas 
aos métodos disponibilizados pelo ViewModel e da observação de suas alterações de estado.
Para isso, utilizamos `ListenableBuilder`, que permite reconstruir os componentes da interface 
quando o ViewModel notifica uma alteração por meio do método `notifyListeners()`.

Dessa forma, a View não precisa conhecer os detalhes de execução das operações ou de acesso aos dados,
enquanto o ViewModel não depende diretamente dos componentes visuais.

## Fontes consultadas
- [Guia para arquitetura de aplicativos Flutter](https://docs.flutter.dev/app-architecture/guide)
- [Command Pattern em Flutter](https://docs.flutter.dev/app-architecture/design-patterns/command)