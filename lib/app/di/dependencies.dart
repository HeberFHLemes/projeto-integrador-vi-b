import 'package:agendados/features/agendamento/data/agendamento_repository_impl.dart';
import 'package:agendados/features/agendamento/domain/agendamento_repository.dart';
import 'package:agendados/features/agendamento/presentation/viewmodels/agenda_view_model.dart';
import 'package:get_it/get_it.dart';

import '../../core/database/database_helper.dart';
import '../../features/agendamento/presentation/viewmodels/cadastro_agendamento_view_model.dart';
import '../../features/cliente/data/cliente_repository_impl.dart';
import '../../features/cliente/domain/cliente_repository.dart';
import '../../features/cliente/presentation/viewmodels/atualizacao_cliente_view_model.dart';
import '../../features/cliente/presentation/viewmodels/cadastro_cliente_view_model.dart';
import '../../features/cliente/presentation/viewmodels/cliente_view_model.dart';
import '../../features/cliente/presentation/viewmodels/ficha_cliente_view_model.dart';
import '../../features/servicos/domain/servico_repository.dart';
import '../../features/servicos/data/servico_repository_impl.dart';
import '../../features/servicos/presentation/viewmodels/atualizacao_servico_view_model.dart';
import '../../features/servicos/presentation/viewmodels/cadastro_servico_view_model.dart';
import '../../features/servicos/presentation/viewmodels/servicos_view_model.dart';

final getIt = GetIt.instance;

/// Registro das dependências da aplicação utilizando GetIt.
void registerDependencies() {
  // Clientes
  getIt.registerLazySingleton<ClienteRepository>(
    () => ClienteRepositoryImpl(
      databaseHelper: DatabaseHelper.instance,
    ),
  );

  getIt.registerFactory<ClienteViewModel>(
    () => ClienteViewModel(getIt<ClienteRepository>()),
  );

  getIt.registerFactory<CadastroClienteViewModel>(
    () => CadastroClienteViewModel(getIt<ClienteRepository>()),
  );

  getIt.registerFactory<FichaClienteViewModel>(
    () => FichaClienteViewModel(getIt<ClienteRepository>()),
  );

  getIt.registerFactory<AtualizacaoClienteViewModel>(
    () => AtualizacaoClienteViewModel(getIt<ClienteRepository>()),
  );

  // Servicos
  getIt.registerLazySingleton<ServicoRepository>(
    () => ServicoRepositoryImpl(
      databaseHelper: DatabaseHelper.instance,
    ),
  );

  getIt.registerFactory<ServicosViewModel>(
    () => ServicosViewModel(getIt<ServicoRepository>())
  );

  getIt.registerFactory<CadastroServicoViewModel>(
    () => CadastroServicoViewModel(getIt<ServicoRepository>())
  );

  getIt.registerFactory<AtualizacaoServicoViewModel>(
    () => AtualizacaoServicoViewModel(getIt<ServicoRepository>())
  );

  // Agendamentos
  getIt.registerLazySingleton<AgendamentoRepository>(
    () => AgendamentoRepositoryImpl(
      databaseHelper: DatabaseHelper.instance,
    ),
  );

  getIt.registerFactory<AgendaViewModel>(
    () => AgendaViewModel(getIt<AgendamentoRepository>())
  );

  getIt.registerFactory<CadastroAgendamentoViewModel>(
    () => CadastroAgendamentoViewModel(
      agendamentoRepository: getIt<AgendamentoRepository>(),
      clienteRepository: getIt<ClienteRepository>(),
      servicoRepository: getIt<ServicoRepository>(),
    ),
  );
}