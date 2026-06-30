import 'package:get_it/get_it.dart';
import '../../core/services/CacheService.dart';
import '../../core/services/JobQueueService.dart';
import '../../core/services/DatabaseService.dart';
import '../../core/services/AuthService.dart';
import '../../core/services/SeedService.dart';
import '../../core/services/NavigationService.dart';
import '../../core/services/AccessibilityService.dart';
import '../../domain/repositories/usuario_repository.dart';
import '../../domain/repositories/livro_repository.dart';
import '../../domain/repositories/solicitacao_repository.dart';
import '../../domain/repositories/emprestimo_repository.dart';
import '../../data/repositories/usuario_repository_impl.dart';
import '../../data/repositories/livro_repository_impl.dart';
import '../../data/repositories/solicitacao_repository_impl.dart';
import '../../data/repositories/emprestimo_repository_impl.dart';
import '../../domain/usecases/CadastrarUsuarioUseCase.dart';
import '../../domain/usecases/AtualizarUsuarioUseCase.dart';
import '../../domain/usecases/InativarUsuarioUseCase.dart';
import '../../domain/usecases/CadastrarLivroUseCase.dart';
import '../../domain/usecases/AtualizarLivroUseCase.dart';
import '../../domain/usecases/InativarLivroUseCase.dart';
import '../../domain/usecases/EnviarSolicitacaoUseCase.dart';
import '../../domain/usecases/ResponderSolicitacaoUseCase.dart';
import '../../domain/usecases/RegistrarEmprestimoUseCase.dart';
import '../../domain/usecases/RegistrarDevolucaoUseCase.dart';
import '../../domain/usecases/RenovarEmprestimoUseCase.dart';
import '../../domain/usecases/GerarRelatoriosUseCase.dart';

final getIt = GetIt.instance;

Future<void> setupInjection() async {
  // Services
  getIt.registerLazySingleton(() => DatabaseService());
  getIt.registerLazySingleton(() => NavigationService());
  getIt.registerLazySingleton(() => AccessibilityService());
  getIt.registerLazySingleton(() => CacheService());
  getIt.registerLazySingleton(() => JobQueueService());

  // Repositories
  getIt.registerLazySingleton<UsuarioRepository>(() => UsuarioRepositoryImpl(getIt()));
  getIt.registerLazySingleton<LivroRepository>(() => LivroRepositoryImpl(getIt(), getIt()));
  getIt.registerLazySingleton<SolicitacaoRepository>(() => SolicitacaoRepositoryImpl(getIt()));
  getIt.registerLazySingleton<EmprestimoRepository>(() => EmprestimoRepositoryImpl(getIt()));

  // Auth & Seed
  getIt.registerLazySingleton(() => AuthService(getIt(), getIt()));
  getIt.registerLazySingleton(() => SeedService(getIt()));

  // Use Cases
  getIt.registerLazySingleton(() => CadastrarUsuarioUseCase(getIt(), getIt()));
  getIt.registerLazySingleton(() => AtualizarUsuarioUseCase(getIt(), getIt()));
  getIt.registerLazySingleton(() => InativarUsuarioUseCase(getIt(), getIt()));
  getIt.registerLazySingleton(() => CadastrarLivroUseCase(getIt(), getIt()));
  getIt.registerLazySingleton(() => AtualizarLivroUseCase(getIt(), getIt()));
  getIt.registerLazySingleton(() => InativarLivroUseCase(getIt(), getIt()));
  getIt.registerLazySingleton(() => EnviarSolicitacaoUseCase(getIt(), getIt()));
  getIt.registerLazySingleton(() => ResponderSolicitacaoUseCase(getIt(), getIt(), getIt()));
  getIt.registerLazySingleton(() => RegistrarEmprestimoUseCase(getIt(), getIt()));
  getIt.registerLazySingleton(() => RegistrarDevolucaoUseCase(getIt(), getIt()));
  getIt.registerLazySingleton(() => RenovarEmprestimoUseCase(getIt(), getIt()));
  getIt.registerLazySingleton(() => GerarRelatoriosUseCase(getIt(), getIt()));
}
