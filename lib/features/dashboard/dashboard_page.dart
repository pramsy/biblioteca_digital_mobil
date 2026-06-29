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
    final isLeitor = usuario?.perfil == AppConstants.profileLeitor;

    final canManageUsers = isInitialAdmin || isAdmin;
    final canManageBooks = isInitialAdmin || isAdmin || isBibliotecario;
    final canSeeReports = isInitialAdmin || isAdmin;
    final canRespondRequests = isInitialAdmin || isAdmin || isBibliotecario;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            onPressed: () {
              authService.logout();
              Navigator.of(context).pushReplacementNamed(AppRoutes.login);
            },
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bem-vindo, ${usuario?.nome ?? 'Usuário'}!',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text('Perfil: ${usuario?.perfil ?? ''}'),
            const SizedBox(height: 24),
            
            const Text('Ações do Leitor', style: TextStyle(fontWeight: FontWeight.bold)),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.book),
              title: const Text('Consultar Catálogo'),
              onTap: () => Navigator.pushNamed(context, AppRoutes.catalogo),
            ),
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text('Meus Empréstimos'),
              onTap: () => Navigator.pushNamed(context, AppRoutes.meusEmprestimos),
            ),
            ListTile(
              leading: const Icon(Icons.message),
              title: const Text('Minhas Solicitações'),
              onTap: () => Navigator.pushNamed(context, AppRoutes.listaSolicitacoes),
            ),
            
            if (canManageBooks || canManageUsers) ...[
              const SizedBox(height: 16),
              const Text('Administração', style: TextStyle(fontWeight: FontWeight.bold)),
              const Divider(),
              
              if (canManageBooks)
                ListTile(
                  leading: const Icon(Icons.add_business),
                  title: const Text('Gerenciar Acervo (Livros)'),
                  onTap: () => Navigator.pushNamed(context, AppRoutes.catalogo),
                ),

              ListTile(
                leading: const Icon(Icons.history_edu),
                title: const Text('Gerenciar Empréstimos'),
                onTap: () => Navigator.pushNamed(context, AppRoutes.listaEmprestimos),
              ),

              if (canManageUsers) ...[
                if (isInitialAdmin)
                  ListTile(
                    leading: const Icon(Icons.person_add),
                    title: const Text('Cadastrar Administrador'),
                    onTap: () => Navigator.of(context).pushNamed(
                      AppRoutes.usuarioForm,
                      arguments: AppConstants.profileAdmin,
                    ),
                  ),
                ListTile(
                  leading: const Icon(Icons.person_add_alt_1),
                  title: const Text('Cadastrar Bibliotecário'),
                  onTap: () => Navigator.of(context).pushNamed(
                    AppRoutes.usuarioForm,
                    arguments: AppConstants.profileBibliotecario,
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.people),
                  title: const Text('Gerenciar Usuários'),
                  onTap: () {
                    // Aqui poderia abrir uma lista de usuários para inativar/editar
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Funcionalidade de Listagem de Usuários em desenvolvimento.')),
                    );
                  },
                ),
              ],

              if (canRespondRequests)
                ListTile(
                  leading: const Icon(Icons.list_alt),
                  title: const Text('Atender Solicitações'),
                  onTap: () => Navigator.pushNamed(context, AppRoutes.listaSolicitacoes),
                ),
            ],
            
            if (canSeeReports) ...[
              const SizedBox(height: 16),
              const Text('Relatórios', style: TextStyle(fontWeight: FontWeight.bold)),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.bar_chart),
                title: const Text('Relatórios Gerenciais'),
                onTap: () => Navigator.pushNamed(context, AppRoutes.relatorios),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
