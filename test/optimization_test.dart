import 'package:flutter_test/flutter_test.dart';
import 'package:biblioteca_digital/core/services/CacheService.dart';
import 'package:biblioteca_digital/core/services/JobQueueService.dart';

void main() {
  group('Optimization Tests', () {
    late CacheService cache;
    late JobQueueService queue;

    setUp(() {
      cache = CacheService();
      queue = JobQueueService();
    });

    test('CacheService should save and retrieve data', () {
      cache.save('test_key', 'test_value');
      expect(cache.get<String>('test_key'), 'test_value');
      expect(cache.contains('test_key'), true);
    });

    test('CacheService should clear data', () {
      cache.save('a', 1);
      cache.clear();
      expect(cache.contains('a'), false);
    });

    test('JobQueueService should process jobs sequentially', () async {
      int counter = 0;
      queue.addJob(() async {
        await Future.delayed(const Duration(milliseconds: 10));
        counter++;
      });
      queue.addJob(() async {
        counter++;
      });

      // Wait a bit for async processing
      await Future.delayed(const Duration(milliseconds: 50));
      expect(counter, 2);
    });
  });
}
