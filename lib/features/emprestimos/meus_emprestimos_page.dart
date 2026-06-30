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
    try {
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
        if (mounted) setState(() => _dadosEmprestimos = list);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao carregar seus empréstimos: $e'), backgroundColor: Colors.red[800]),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _devolver(int id) async {
    try {
      await getIt<RegistrarDevolucaoUseCase>().execute(id);
      _carregarEmprestimos();
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString()), backgroundColor: Colors.red));
    }
  }

  Future<void> _renovar(int id) async {
    try {
      await getIt<RenovarEmprestimoUseCase>().execute(id);
      _carregarEmprestimos();
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString()), backgroundColor: Colors.red));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Meus Empréstimos')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _dadosEmprestimos.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.history_outlined, size: 64, color: Colors.grey[400]),
                      const SizedBox(height: 16),
                      const Text('Você não possui empréstimos registrados.', style: TextStyle(fontSize: 16)),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: _dadosEmprestimos.length,
                  itemBuilder: (context, index) {
                    final emp = _dadosEmprestimos[index]['emprestimo'] as Emprestimo;
                    final livro = _dadosEmprestimos[index]['livro'] as Livro?;
                    final isAtivo = emp.status == 'ATIVO';
                    
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        title: Text(livro?.titulo ?? 'Livro desconhecido', style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 8),
                            _buildInfoRow(Icons.info_outline, 'Status: ${emp.status}', color: isAtivo ? Colors.green : Colors.grey),
                            _buildInfoRow(Icons.calendar_today, 'Previsão: ${DateHelper.formatDateTime(emp.dataPrevisaoDevolucao)}'),
                            if (emp.dataDevolucao != null)
                              _buildInfoRow(Icons.check_circle_outline, 'Devolvido em: ${DateHelper.formatDateTime(emp.dataDevolucao!)}', color: Colors.blue),
                          ],
                        ),
                        trailing: isAtivo 
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    _buildActionButton(Icons.refresh, 'Renovar', Colors.blue, () => _renovar(emp.id!)),
                                    const SizedBox(width: 8),
                                    _buildActionButton(Icons.assignment_return_outlined, 'Devolver', Colors.green, () => _devolver(emp.id!)),
                                  ],
                                ),
                              ],
                            )
                          : const Icon(Icons.done_all, color: Colors.blue),
                      ),
                    );
                  },
                ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.only(top: 4.0),
      child: Row(
        children: [
          Icon(icon, size: 14, color: color ?? Colors.grey[600]),
          const SizedBox(width: 6),
          Text(text, style: TextStyle(color: color ?? Colors.grey[800], fontSize: 13)),
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label, Color color, VoidCallback onPressed) {
    return Semantics(
      label: '$label empréstimo',
      child: IconButton(
        icon: Icon(icon, color: color),
        onPressed: onPressed,
        style: IconButton.styleFrom(
          backgroundColor: color.withOpacity(0.1),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }
}
