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
    try {
      final authService = getIt<AuthService>();
      final usuario = authService.usuarioLogado;
      final repository = getIt<SolicitacaoRepository>();

      if (usuario?.perfil == AppConstants.profileAdmin || 
          usuario?.perfil == AppConstants.profileAdminInicial ||
          usuario?.perfil == AppConstants.profileBibliotecario) {
        _solicitacoes = await repository.getAllSolicitacoes();
      } else {
        _solicitacoes = await repository.getSolicitacoesByUsuario(usuario!.id!);
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro: $e'), backgroundColor: Colors.red));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _responder(Solicitacao solicitacao) async {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Responder Solicitação'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Escreva sua resposta aqui...', border: OutlineInputBorder()),
          maxLines: 4,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('CANCELAR')),
          ElevatedButton(
            onPressed: () async {
              if (controller.text.trim().isEmpty) return;
              await getIt<ResponderSolicitacaoUseCase>().execute(solicitacao.id!, controller.text.trim());
              if (mounted) {
                Navigator.pop(context);
                _carregarSolicitacoes();
              }
            },
            child: const Text('ENVIAR RESPOSTA'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final usuario = getIt<AuthService>().usuarioLogado;
    final isLeitor = usuario?.perfil == AppConstants.profileLeitor;

    return Scaffold(
      appBar: AppBar(title: const Text('Atendimento e Suporte')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _solicitacoes.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.mark_chat_read_outlined, size: 64, color: Colors.grey[300]),
                      const SizedBox(height: 16),
                      Text(isLeitor ? 'Você não enviou solicitações.' : 'Nenhuma solicitação pendente.'),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: _solicitacoes.length,
                  itemBuilder: (context, index) {
                    final sol = _solicitacoes[index];
                    final isAberta = sol.status == AppConstants.statusAberta;
                    
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: ExpansionTile(
                        leading: Icon(
                          isAberta ? Icons.hourglass_empty : Icons.check_circle_outline,
                          color: isAberta ? Colors.orange : Colors.green,
                        ),
                        title: Text(sol.assunto, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text('Status: ${sol.status} • Prioridade: ${sol.prioridade}'),
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Mensagem do Usuário:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                                const SizedBox(height: 4),
                                Text(sol.descricao),
                                if (sol.resposta != null) ...[
                                  const Divider(height: 24),
                                  const Text('Resposta da Administração:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.deepPurple)),
                                  const SizedBox(height: 4),
                                  Text(sol.resposta!),
                                ],
                                if (!isLeitor && isAberta) ...[
                                  const SizedBox(height: 16),
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton.icon(
                                      onPressed: () => _responder(sol),
                                      icon: const Icon(Icons.reply),
                                      label: const Text('RESPONDER AGORA'),
                                    ),
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
      floatingActionButton: isLeitor
          ? FloatingActionButton.extended(
              onPressed: () async {
                final result = await Navigator.pushNamed(context, AppRoutes.solicitacaoForm);
                if (result == true) _carregarSolicitacoes();
              },
              icon: const Icon(Icons.add),
              label: const Text('Nova Solicitação'),
            )
          : null,
    );
  }
}
