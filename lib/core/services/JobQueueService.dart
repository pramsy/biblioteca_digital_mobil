import 'dart:async';

class JobQueueService {
  final _queue = <Future<void> Function()>[];
  bool _isProcessing = false;

  void addJob(Future<void> Function() job) {
    _queue.add(job);
    if (!_isProcessing) {
      _processNext();
    }
  }

  Future<void> _processNext() async {
    if (_queue.isEmpty) {
      _isProcessing = false;
      return;
    }

    _isProcessing = true;
    final job = _queue.removeAt(0);
    
    try {
      await job();
    } catch (e) {
      // Log error internally without blocking
      print('JobQueue Error: $e');
    }

    _processNext();
  }
}
