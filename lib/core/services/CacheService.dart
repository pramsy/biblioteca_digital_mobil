class CacheService {
  final Map<String, dynamic> _cache = {};

  void save(String key, dynamic value) {
    _cache[key] = value;
  }

  T? get<T>(String key) {
    return _cache[key] as T?;
  }

  void remove(String key) {
    _cache.remove(key);
  }

  void clear() {
    _cache.clear();
  }

  bool contains(String key) => _cache.containsKey(key);
}
