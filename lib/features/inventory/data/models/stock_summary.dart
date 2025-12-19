import 'stock_item.dart';

class StockSummary {
  final List<StockItem> items;

  const StockSummary({required this.items});

  factory StockSummary.fromJson(dynamic raw) {
    // support: {data:{data:[...]}} or {data:[...]} or [...]
    if (raw is Map<String, dynamic>) {
      final data = raw['data'];
      if (data is Map<String, dynamic>) {
        final list = (data['data'] is List)
            ? data['data'] as List
            : <dynamic>[];
        return StockSummary(
          items: list
              .whereType<Map>()
              .map((e) => StockItem.fromJson(Map<String, dynamic>.from(e)))
              .toList(),
        );
      }
      if (data is List) {
        return StockSummary(
          items: data
              .whereType<Map>()
              .map((e) => StockItem.fromJson(Map<String, dynamic>.from(e)))
              .toList(),
        );
      }
    }
    if (raw is List) {
      return StockSummary(
        items: raw
            .whereType<Map>()
            .map((e) => StockItem.fromJson(Map<String, dynamic>.from(e)))
            .toList(),
      );
    }
    return const StockSummary(items: []);
  }
}
