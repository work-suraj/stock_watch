import 'package:stock_watch/models/stock_model.dart';

abstract class WatchlistEvent {}

class LoadWatchlist extends WatchlistEvent {}

class ReorderWatchlist extends WatchlistEvent {
  final int oldIndex;
  final int newIndex;

  ReorderWatchlist({required this.oldIndex, required this.newIndex});
}

class UpdateWatchlist extends WatchlistEvent {
  final List<Stock> stocks;

  UpdateWatchlist({required this.stocks});
}
