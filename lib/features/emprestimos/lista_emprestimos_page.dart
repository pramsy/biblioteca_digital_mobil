import 'package:flutter/material.dart';
import '../../app/config/injection.dart';
import '../../domain/entities/emprestimo.dart';
import '../../domain/entities/livro.dart';
import '../../domain/entities/usuario.dart';
import '../../domain/repositories/emprestimo_repository.dart';
import '../../domain/repositories/livro_repository.dart';
import '../../domain/repositories/usuario_repository.dart';
import '../../core/utils/date_helper.dart';

class ListaEmprestimosPage extends StatefulWidget {
  const ListaEmprestimosPage({super.key});

  @override
  State<ListaEmprestimosPage> createState() => _ListaEmprestimosPageState();
}

class _ListaEmprestimosPageState extends State<ListaEmprestimosPage> {
  List<Map<String, dynamic>> _dadosEmprestimos = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _carregarEmprestimos();
  }

  Future<void> _carregarEmprestimos() async {
    setState(() => _isLoading = true);
    try {
      final emprestimos = await getIt<EmprestimoRepository>().getAllEmprestimos();
      final list = <Map<String, dynamic>>[];
      
      for (var emp in emprestimos) {
        final livro = await getIt<LivroRepository>().getLivroById(emp.livroId);
        final usuario = await getIt<UsuarioRepository>().getUsuarioById(emp.usuarioId);
        list.add({
          'emprestimo': emp,
          'livro': livro,
          'usuario': usuario,
        });
      }
      if (mounted) setState(() => _dadosEmprestimos = list);
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro: $e'), backgroundColor: Colors.red));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gestão de Empréstimos')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _dadosEmprestimos.isEmpty
              ? const Center(child: Text('Nenhum empréstimo registrado no sistema.'))
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: _dadosEmprestimos.length,
                  itemBuilder: (context, index) {
                    final emp = _dadosEmprestimos[index]['emprestimo'] as Emprestimo;
                    final livro = _dadosEmprestimos[index]['livro'] as Livro?;
                    final usuario = _dadosEmprestimos[index]['usuario'] as Usuario?;
                    final isAtivo = emp.status == 'ATIVO';
                    
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        title: Text(livro?.titulo ?? 'Livro desconhecido', style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Leitor: ${usuario?.nome ?? 'Desconhecido'}'),
                            Text('Status: ${emp.status}', style: TextStyle(color: isAtivo ? Colors.green : Colors.grey, fontWeight: FontWeight.bold)),
                            Text('Devolução prevista: ${DateHelper.formatDateTime(emp.dataPrevisaoDevolucao)}'),
                          ],
                        ),
                        trailing: isAtivo ? const Icon(Icons.pending_actions, color: Colors.orange) : const Icon(Icons.check_circle, color: Colors.blue),
                      ),
                    );
                  },
                ),
    );
  }
}
