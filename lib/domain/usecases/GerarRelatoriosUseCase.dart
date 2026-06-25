import '../repositories/emprestimo_repository.dart';
import '../../core/services/AuthService.dart';
import '../../core/errors/exceptions.dart';
import '../../core/constants/app_constants.dart';

class GerarRelatoriosUseCase {
  final EmprestimoRepository _repository;
  final AuthService _authService;

  GerarRelatoriosUseCase(this._repository, this._authService);

  Future<List<Map<String, dynamic>>> execute(DateTime inicio, DateTime fim) async {
    final usuarioLogado = _authService.usuarioLogado;

    // T-UNIT-REP-001: Somente ADMIN
    if (usuarioLogado?.perfil != AppConstants.profileAdmin &&
        usuarioLogado?.perfil != AppConstants.profileAdminInicial) {
      throw UnauthorizedException('Apenas administradores podem gerar relatórios.');
    }

    return await _repository.getRelatorioDados(inicio, fim);
  }
}
