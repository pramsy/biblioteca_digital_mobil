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

    final isAdmin = usuario?.perfil == AppConstants.profileAdmin || 
                    usuario?.perfil == AppConstants.profileAdminInicial;
    final isEditor = usuario?.perfil == AppConstants.profileEditor;

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
            
            const Text('Ações Rápidas', style: TextStyle(fontWeight: FontWeight.bold)),
            const Divider(),
            
            // Ações para todos
            ListTile(
              leading: const Icon(Icons.book),
              title: const Text('Consultar Catálogo'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text('Meus Empréstimos'),
              onTap: () {},
            ),
            
            // Ações específicas de Admin/Editor
            if (isAdmin || isEditor) ...[
              const SizedBox(height: 16),
              const Text('Administração', style: TextStyle(fontWeight: FontWeight.bold)),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.add_business),
                title: const Text('Cadastrar Livro'),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.people),
                title: const Text('Gerenciar Usuários'),
                onTap: () {},
              ),
            ],
            
            if (isAdmin) ...[
              ListTile(
                leading: const Icon(Icons.bar_chart),
                title: const Text('Relatórios Gerenciais'),
                onTap: () {},
              ),
            ],
          ],
        ),
      ),
    );
  }
}
