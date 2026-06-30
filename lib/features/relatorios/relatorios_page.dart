import 'package:flutter/material.dart';
import '../../app/config/injection.dart';
import '../../domain/usecases/GerarRelatoriosUseCase.dart';

class RelatoriosPage extends StatefulWidget {
  const RelatoriosPage({super.key});

  @override
  State<RelatoriosPage> createState() => _RelatoriosPageState();
}

class _RelatoriosPageState extends State<RelatoriosPage> {
  DateTime _inicio = DateTime.now().subtract(const Duration(days: 30));
  DateTime _fim = DateTime.now();
  List<Map<String, dynamic>> _dados = [];
  bool _isLoading = false;

  Future<void> _gerar() async {
    setState(() => _isLoading = true);
    try {
      final resultado = await getIt<GerarRelatoriosUseCase>().execute(_inicio, _fim);
      if (mounted) setState(() => _dados = resultado);
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro ao gerar: $e'), backgroundColor: Colors.red));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Relatórios Gerenciais')),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.deepPurple[50],
            child: Column(
              children: [
                const Text('Selecione o período para análise', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: () async {
                    final picked = await showDateRangePicker(
                      context: context,
                      firstDate: DateTime(2023),
                      lastDate: DateTime(2100),
                      initialDateRange: DateTimeRange(start: _inicio, end: _fim),
                    );
                    if (picked != null) {
                      setState(() {
                        _inicio = picked.start;
                        _fim = picked.end;
                      });
                    }
                  },
                  icon: const Icon(Icons.date_range),
                  label: Text('${_inicio.day}/${_inicio.month}/${_inicio.year} - ${_fim.day}/${_fim.month}/${_fim.year}'),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _gerar,
                    child: _isLoading ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('GERAR INDICADORES'),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _dados.isEmpty && !_isLoading
                ? const Center(child: Text('Nenhum dado encontrado para o período.'))
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _dados.length,
                    itemBuilder: (context, index) {
                      final item = _dados[index];
                      return Card(
                        child: ListTile(
                          leading: const CircleAvatar(child: Icon(Icons.bar_chart)),
                          title: const Text('Total de Empréstimos'),
                          trailing: Text(
                            '${item['totalEmprestimos']}',
                            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.deepPurple),
                          ),
                        ),
                      );
                    },
                  ),
          )
        ],
      ),
    );
  }
}
