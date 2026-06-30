import 'package:flutter/material.dart';
import '../../app/config/injection.dart';
import '../../core/services/AuthService.dart';
import '../../app/routes/app_routes.dart';
import '../../core/constants/app_constants.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = getIt<AuthService>();
    final usuario = authService.usuarioLogado;

    final isInitialAdmin = usuario?.perfil == AppConstants.profileAdminInicial;
    final isAdmin = usuario?.perfil == AppConstants.profileAdmin;
    final isBibliotecario = usuario?.perfil == AppConstants.profileBibliotecario;

    final canManageUsers = isInitialAdmin || isAdmin;
    final canManageBooks = isInitialAdmin || isAdmin || isBibliotecario;
    final canSeeReports = isInitialAdmin || isAdmin;
    final canRespondRequests = isInitialAdmin || isAdmin || isBibliotecario;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          Semantics(
            label: 'Encerrar sessão e sair do aplicativo',
            child: IconButton(
              onPressed: () {
                authService.logout();
                Navigator.of(context).pushReplacementNamed(AppRoutes.login);
              },
              icon: const Icon(Icons.logout_rounded),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 0,
              color: Colors.deepPurple[50],
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.deepPurple,
                      child: Text(
                        usuario?.nome.substring(0, 1).toUpperCase() ?? 'U',
                        style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Olá, ${usuario?.nome ?? 'Usuário'}!',
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Perfil: ${usuario?.perfil ?? ''}',
                            style: TextStyle(color: Colors.deepPurple[700]),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            _buildSectionTitle('Serviços do Leitor'),
            _buildActionTile(
              context, 
              icon: Icons.auto_stories_outlined, 
              title: 'Consultar Catálogo', 
              subtitle: 'Veja os livros disponíveis para empréstimo',
              route: AppRoutes.catalogo,
            ),
            _buildActionTile(
              context, 
              icon: Icons.history_outlined, 
              title: 'Meus Empréstimos', 
              subtitle: 'Acompanhe prazos e realize devoluções',
              route: AppRoutes.meusEmprestimos,
            ),
            _buildActionTile(
              context, 
              icon: Icons.contact_support_outlined, 
              title: 'Minhas Solicitações', 
              subtitle: 'Envie dúvidas e veja as respostas',
              route: AppRoutes.listaSolicitacoes,
            ),
            
            if (canManageBooks || canManageUsers) ...[
              const SizedBox(height: 16),
              _buildSectionTitle('Administração do Sistema'),
              
              if (canManageBooks)
                _buildActionTile(
                  context, 
                  icon: Icons.library_add_outlined, 
                  title: 'Gerenciar Acervo', 
                  subtitle: 'Adicione, edite ou remova exemplares',
                  route: AppRoutes.catalogo,
                ),

              if (canManageUsers) ...[
                if (isInitialAdmin)
                  _buildActionTile(
                    context, 
                    icon: Icons.admin_panel_settings_outlined, 
                    title: 'Cadastrar Administrador', 
                    subtitle: 'Crie novos perfis de gestão total',
                    route: AppRoutes.usuarioForm,
                    args: AppConstants.profileAdmin,
                  ),
                _buildActionTile(
                  context, 
                  icon: Icons.badge_outlined, 
                  title: 'Cadastrar Bibliotecário', 
                  subtitle: 'Adicione responsáveis pelo acervo',
                  route: AppRoutes.usuarioForm,
                  args: AppConstants.profileBibliotecario,
                ),
              ],

              if (canRespondRequests)
                _buildActionTile(
                  context, 
                  icon: Icons.rate_review_outlined, 
                  title: 'Atender Solicitações', 
                  subtitle: 'Responda pedidos dos leitores',
                  route: AppRoutes.listaSolicitacoes,
                ),
              
              _buildActionTile(
                context, 
                icon: Icons.list_alt_rounded, 
                title: 'Gerenciar Empréstimos', 
                subtitle: 'Visualize todas as locações ativas',
                route: AppRoutes.listaEmprestimos,
              ),
            ],
            
            if (canSeeReports) ...[
              const SizedBox(height: 16),
              _buildSectionTitle('Indicadores'),
              _buildActionTile(
                context, 
                icon: Icons.analytics_outlined, 
                title: 'Relatórios Gerenciais', 
                subtitle: 'Acompanhe estatísticas de uso',
                route: AppRoutes.relatorios,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
      ),
    );
  }

  Widget _buildActionTile(BuildContext context, {
    required IconData icon, 
    required String title, 
    required String subtitle, 
    required String route,
    Object? args,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, color: Colors.deepPurple),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
        trailing: const Icon(Icons.chevron_right, size: 20),
        onTap: () => Navigator.pushNamed(context, route, arguments: args),
      ),
    );
  }
}
