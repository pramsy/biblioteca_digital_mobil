import 'package:flutter/material.dart';
import '../../app/config/injection.dart';
import '../../domain/entities/solicitacao.dart';
import '../../domain/repositories/solicitacao_repository.dart';
import '../../domain/usecases/ResponderSolicitacaoUseCase.dart';
import '../../core/services/AuthService.dart';
import '../../core/constants/app_constants.dart';
import '../../app/routes/app_routes.dart';

class ListaSolicitacoesPage extends StatefulWidget {
  const ListaSolicitacoesPage({super.key});

  @override
  State<ListaSolicitacoesPage> createState() => _ListaSolicitacoesPageState();
}

class _ListaSolicitacoesPageState extends State<ListaSolicitacoesPage> {
  List<Solicitacao> _solicitacoes = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _carregarSolicitacoes();
  }

  Future<void> _carregarSolicitacoes() async {
    setState(() => _isLoading = true);
    final authService = getIt<AuthService>();
    final usuario = authService.usuarioLogado;
    final repository = getIt<SolicitacaoRepository>();

    if (usuario?.perfil == AppConstants.profileAdmin || 
        usuario?.perfil == AppConstants.profileAdminInicial ||
        usuario?.perfil == AppConstants.profileEditor) {
      _solicitacoes = await repository.getAllSolicitacoes();
    } else {
      _solicitacoes = await repository.getSolicitacoesByUsuario(usuario!.id!);
    }
    setState(() => _isLoading = false);
  }

  Future<void> _responder(Solicitacao solicitacao) async {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Responder Solicitação'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Digite a resposta...'),
          maxLines: 3,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('CANCELAR')),
          ElevatedButton(
            onPressed: () async {
              await getIt<ResponderSolicitacaoUseCase>().execute(solicitacao.id!, controller.text);
              if (mounted) {
                Navigator.pop(context);
                _carregarSolicitacoes();
              }
            },
            child: const Text('RESPONDER'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final usuario = getIt<AuthService>().usuarioLogado;
    final canRespond = usuario?.perfil != AppConstants.profileLeitor;

    return Scaffold(
      appBar: AppBar(title: const Text('Solicitações')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _solicitacoes.length,
              itemBuilder: (context, index) {
                final sol = _solicitacoes[index];
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ExpansionTile(
                    title: Text(sol.assunto),
                    subtitle: Text('Status: ${sol.status} - Prioridade: ${sol.prioridade}'),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Descrição:', style: TextStyle(fontWeight: FontWeight.bold)),
                            Text(sol.descricao),
                            if (sol.resposta != null) ...[
                              const Divider(),
                              const Text('Resposta:', style: TextStyle(fontWeight: FontWeight.bold)),
                              Text(sol.resposta!),
                            ],
                            if (canRespond && sol.status == AppConstants.statusAberta) ...[
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () => _responder(sol),
                                child: const Text('RESPONDER'),
                              ),
                            ]
                          ],
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: usuario?.perfil == AppConstants.profileLeitor
          ? FloatingActionButton(
              onPressed: () async {
                final result = await Navigator.pushNamed(context, AppRoutes.solicitacaoForm);
                if (result == true) _carregarSolicitacoes();
              },
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
