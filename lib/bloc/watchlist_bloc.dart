import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stock_watch/bloc/watchlist_event.dart';
import 'package:stock_watch/bloc/watchlist_state.dart';
import 'package:stock_watch/models/stock_model.dart';

class WatchlistBloc extends Bloc<WatchlistEvent, WatchlistState> {
  WatchlistBloc() : super(WatchlistInitial()) {
    on<LoadWatchlist>(_onLoadWatchlist);
    on<ReorderWatchlist>(_onReorderWatchlist);
    on<UpdateWatchlist>(_onUpdateWatchlist);
  }

  void _onLoadWatchlist(LoadWatchlist event, Emitter<WatchlistState> emit) {
    emit(WatchlistLoaded(stocks: List.from(mockStocks)));
  }

  void _onReorderWatchlist(ReorderWatchlist event, Emitter<WatchlistState> emit) {
    final currentState = state;
    if (currentState is WatchlistLoaded) {
      final stocks = List<Stock>.from(currentState.stocks);

      var newIndex = event.newIndex;
      if (newIndex > event.oldIndex) {
        newIndex -= 1;
      }

      final item = stocks.removeAt(event.oldIndex);
      stocks.insert(newIndex, item);

      emit(WatchlistLoaded(stocks: stocks));
    }
  }

  void _onUpdateWatchlist(UpdateWatchlist event, Emitter<WatchlistState> emit) {
    emit(WatchlistLoaded(stocks: event.stocks));
  }
}
