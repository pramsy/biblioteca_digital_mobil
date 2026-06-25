import 'package:flutter/material.dart';
import '../../features/auth/login_page.dart';
import '../../features/dashboard/dashboard_page.dart';
import '../../features/catalogo/livro_form_page.dart';
import '../../features/usuarios/usuario_form_page.dart';
import '../../features/catalogo/catalogo_page.dart';
import '../../features/emprestimos/meus_emprestimos_page.dart';
import '../../features/solicitacoes/solicitacao_form_page.dart';
import '../../features/solicitacoes/lista_solicitacoes_page.dart';
import '../../features/relatorios/relatorios_page.dart';

class AppRoutes {
  static const String login = '/login';
  static const String dashboard = '/dashboard';
  static const String livroForm = '/livro-form';
  static const String usuarioForm = '/usuario-form';
  static const String catalogo = '/catalogo';
  static const String meusEmprestimos = '/meus-emprestimos';
  static const String solicitacaoForm = '/solicitacao-form';
  static const String listaSolicitacoes = '/lista-solicitacoes';
  static const String relatorios = '/relatorios';

  static Map<String, WidgetBuilder> get routes => {
        login: (context) => const LoginPage(),
        dashboard: (context) => const DashboardPage(),
        livroForm: (context) => const LivroFormPage(),
        usuarioForm: (context) => const UsuarioFormPage(),
        catalogo: (context) => const CatalogoPage(),
        meusEmprestimos: (context) => const MeusEmprestimosPage(),
        solicitacaoForm: (context) => const SolicitacaoFormPage(),
        listaSolicitacoes: (context) => const ListaSolicitacoesPage(),
        relatorios: (context) => const RelatoriosPage(),
      };
}
