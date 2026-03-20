import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stock_watch/bloc/watchlist_bloc.dart';
import 'package:stock_watch/bloc/watchlist_state.dart';
import 'package:stock_watch/screens/edit_watchlist_screen.dart';
import 'package:stock_watch/widgets/stock_tile.dart';

class WatchlistScreen extends StatelessWidget {
  const WatchlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Watchlist'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BlocProvider.value(
                    value: context.read<WatchlistBloc>(),
                    child: const EditWatchlistScreen(),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<WatchlistBloc, WatchlistState>(
        builder: (context, state) {
          if (state is WatchlistInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is WatchlistLoaded) {
            if (state.stocks.isEmpty) {
              return const Center(child: Text('No stocks in your watchlist'));
            }

            return ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: state.stocks.length,
              itemBuilder: (context, index) {
                return StockTile(stock: state.stocks[index]);
              },
            );
          }

          return const Center(child: Text('Something went wrong'));
        },
      ),
    );
  }
}
