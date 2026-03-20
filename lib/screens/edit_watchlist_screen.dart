import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stock_watch/bloc/watchlist_bloc.dart';
import 'package:stock_watch/bloc/watchlist_event.dart';
import 'package:stock_watch/bloc/watchlist_state.dart';
import 'package:stock_watch/models/stock_model.dart';
import 'package:stock_watch/widgets/stock_tile.dart';

class EditWatchlistScreen extends StatefulWidget {
  const EditWatchlistScreen({super.key});

  @override
  State<EditWatchlistScreen> createState() => _EditWatchlistScreenState();
}

class _EditWatchlistScreenState extends State<EditWatchlistScreen> {
  late List<Stock> _tempStocks;

  @override
  void initState() {
    super.initState();
    // Copy the current list so we can reorder locally before saving
    final state = context.read<WatchlistBloc>().state;
    if (state is WatchlistLoaded) {
      _tempStocks = List.from(state.stocks);
    } else {
      _tempStocks = [];
    }
  }

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final item = _tempStocks.removeAt(oldIndex);
      _tempStocks.insert(newIndex, item);
    });
  }

  void _onSave() {
    context.read<WatchlistBloc>().add(UpdateWatchlist(stocks: _tempStocks));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Watchlist'),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: _onSave,
            child: const Text(
              'Save',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
      body: _tempStocks.isEmpty
          ? const Center(child: Text('No stocks to reorder'))
          : ReorderableListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: _tempStocks.length,
              onReorder: _onReorder,
              itemBuilder: (context, index) {
                final stock = _tempStocks[index];
                return StockTile(
                  key: ValueKey(stock.id),
                  stock: stock,
                );
              },
            ),
    );
  }
}
