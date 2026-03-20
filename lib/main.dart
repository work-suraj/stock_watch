import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stock_watch/bloc/watchlist_bloc.dart';
import 'package:stock_watch/bloc/watchlist_event.dart';
import 'package:stock_watch/screens/watchlist_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stock Watch',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        useMaterial3: true,
      ),
      home: BlocProvider(
        create: (_) => WatchlistBloc()..add(LoadWatchlist()),
        child: const WatchlistScreen(),
      ),
    );
  }
}
