import 'package:flutter/material.dart';
import '../../app/config/injection.dart';
import '../../domain/entities/emprestimo.dart';
import '../../domain/entities/livro.dart';
import '../../domain/repositories/emprestimo_repository.dart';
import '../../domain/repositories/livro_repository.dart';
import '../../domain/usecases/RegistrarDevolucaoUseCase.dart';
import '../../domain/usecases/RenovarEmprestimoUseCase.dart';
import '../../core/services/AuthService.dart';
import '../../core/utils/date_helper.dart';

class MeusEmprestimosPage extends StatefulWidget {
  const MeusEmprestimosPage({super.key});

  @override
  State<MeusEmprestimosPage> createState() => _MeusEmprestimosPageState();
}

class _MeusEmprestimosPageState extends State<MeusEmprestimosPage> {
  List<Map<String, dynamic>> _dadosEmprestimos = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _carregarEmprestimos();
  }

  Future<void> _carregarEmprestimos() async {
    setState(() => _isLoading = true);
    final usuarioId = getIt<AuthService>().getUsuarioIdAutenticado();
    if (usuarioId != null) {
      final emprestimos = await getIt<EmprestimoRepository>().getEmprestimosByUsuario(usuarioId);
      final list = <Map<String, dynamic>>[];
      
      for (var emp in emprestimos) {
        final livro = await getIt<LivroRepository>().getLivroById(emp.livroId);
        list.add({
          'emprestimo': emp,
          'livro': livro,
        });
      }
      _dadosEmprestimos = list;
    }
    setState(() => _isLoading = false);
  }

  Future<void> _devolver(int id) async {
    try {
      await getIt<RegistrarDevolucaoUseCase>().execute(id);
      _carregarEmprestimos();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  Future<void> _renovar(int id) async {
    try {
      await getIt<RenovarEmprestimoUseCase>().execute(id);
      _carregarEmprestimos();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Meus Empréstimos')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _dadosEmprestimos.length,
              itemBuilder: (context, index) {
                final emp = _dadosEmprestimos[index]['emprestimo'] as Emprestimo;
                final livro = _dadosEmprestimos[index]['livro'] as Livro?;
                
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(livro?.titulo ?? 'Livro desconhecido'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Status: ${emp.status}'),
                        Text('Previsão: ${DateHelper.formatDateTime(emp.dataPrevisaoDevolucao)}'),
                        if (emp.dataDevolucao != null)
                          Text('Devolvido em: ${DateHelper.formatDateTime(emp.dataDevolucao!)}'),
                      ],
                    ),
                    trailing: emp.status == 'ATIVO' 
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.refresh, color: Colors.blue),
                              onPressed: () => _renovar(emp.id!),
                              tooltip: 'Renovar',
                            ),
                            IconButton(
                              icon: const Icon(Icons.assignment_return, color: Colors.green),
                              onPressed: () => _devolver(emp.id!),
                              tooltip: 'Devolver',
                            ),
                          ],
                        )
                      : null,
                  ),
                );
              },
            ),
    );
  }
}
