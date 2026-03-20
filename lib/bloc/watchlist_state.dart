import 'package:equatable/equatable.dart';
import 'package:stock_watch/models/stock_model.dart';

abstract class WatchlistState extends Equatable {
  @override
  List<Object?> get props => [];
}

class WatchlistInitial extends WatchlistState {}

class WatchlistLoaded extends WatchlistState {
  final List<Stock> stocks;

  WatchlistLoaded({required this.stocks});

  @override
  List<Object?> get props => [stocks];
}
