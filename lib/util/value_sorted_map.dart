import 'dart:collection';

/// Data structure to allow fast access to entries by key and keeps them sorted by value.
/// Values have to be unique, two different keys cannot have the same value.
class ValueSortedMap<K, V> {
  final Map<K, V> _videoProgressMap = {};
  final SplayTreeSet<V> _videoProgressSortedSet;

  ValueSortedMap({
    int Function(V value1, V value2)? compare,
    bool Function(dynamic potentialKey)? isValidKey,
  }) : _videoProgressSortedSet = SplayTreeSet<V>(compare, isValidKey);

  void putIfAbsent(K key, V value) {
    if (!_videoProgressMap.containsKey(key)) {
      _videoProgressMap[key] = value;
      _videoProgressSortedSet.add(value);
    }
  }

  V? getByKey(K? key) {
    if (key == null) return null;
    return _videoProgressMap[key];
  }

  void put(K key, V value) {
    V? oldValue = _videoProgressMap[key];
    if (_videoProgressMap.containsKey(key)) {
      _videoProgressMap[key] = value;
      _videoProgressSortedSet.remove(oldValue);
      _videoProgressSortedSet.add(value);
    } else {
      putIfAbsent(key, value);
    }
  }

  List<V> getAllSorted() {
    return _videoProgressSortedSet.toList();
  }

  List<V> getFirst(int amount) {
    return _videoProgressSortedSet.take(amount).toList();
  }

  bool containsKey(K key) {
    return _videoProgressMap.containsKey(key);
  }

  bool remove(K key) {
    V? value = _videoProgressMap.remove(key);
    if (value != null) {
      _videoProgressSortedSet.remove(value);
      return true;
    }

    return false;
  }
}
