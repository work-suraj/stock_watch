# Stock Watch

A simple Flutter stock watchlist app with drag-and-drop reordering, built using the BLoC pattern for state management.

## What This App Does

- Displays a list of stocks with their name, current price, and daily change percentage
- Lets users reorder stocks via drag-and-drop on a separate Edit screen
- Saves the new order back to the main screen when the user taps "Save"
- Uses a single shared BLoC instance across both screens

## Screenshots

| Main Watchlist | Edit (Drag & Drop) |
|---|---|
| View-only list with stock details | Long-press to drag and reorder |

## Tech Stack

| Tool | Purpose |
|---|---|
| Flutter | UI framework |
| flutter_bloc (^8.1.3) | State management using the BLoC pattern |
| equatable (^2.0.5) | Simplifies state comparison in BLoC |

## Project Structure

```
lib/
 ┣ models/
 ┃ ┗ stock_model.dart           # Stock data class + mock data
 ┣ bloc/
 ┃ ┣ watchlist_event.dart       # BLoC events (Load, Reorder, Update)
 ┃ ┣ watchlist_state.dart       # BLoC states (Initial, Loaded)
 ┃ ┗ watchlist_bloc.dart        # BLoC logic — handles all events
 ┣ screens/
 ┃ ┣ watchlist_screen.dart      # Main screen — view-only stock list
 ┃ ┗ edit_watchlist_screen.dart  # Edit screen — reorderable list + Save
 ┣ widgets/
 ┃ ┗ stock_tile.dart            # Reusable stock card widget
 ┗ main.dart                    # App entry point + BLoC provider setup
```

## Approach

### Why this architecture?

I kept things intentionally simple. There's no repository layer, no dependency injection, and no unnecessary abstraction. The goal was to write clean, readable code that's easy to follow and easy to explain — the kind of code a mid-level Flutter developer would write on a real project.

### Data Model

`Stock` is a plain Dart class with four fields: `id`, `name`, `price`, and `changePercentage`. Mock data (10 stocks) is defined as a top-level list in the same file. No JSON serialization needed since we're working with hardcoded data.

### State Management (BLoC)

A single `WatchlistBloc` manages the entire app state. It handles three events:

| Event | What it does |
|---|---|
| `LoadWatchlist` | Loads the mock stock list and emits `WatchlistLoaded` |
| `ReorderWatchlist` | Removes item from old index, inserts at new index, emits updated list |
| `UpdateWatchlist` | Replaces the entire stock list (used when Edit screen saves changes) |

There are only two states:

| State | When it's active |
|---|---|
| `WatchlistInitial` | Before data is loaded (shows a loading spinner) |
| `WatchlistLoaded` | After data is loaded (holds the current stock list) |

`Equatable` is used on states so that BLoC can properly compare them and avoid emitting duplicate states.

### Two-Screen Flow

**Main Screen (`WatchlistScreen`)**
- A `StatelessWidget` that uses `BlocBuilder` to display stocks in a regular `ListView`
- No drag-and-drop here — it's view-only
- Has an edit icon in the AppBar that navigates to the Edit screen

**Edit Screen (`EditWatchlistScreen`)**
- A `StatefulWidget` that copies the current stock list into local state (`_tempStocks`) on init
- Uses `ReorderableListView.builder` for drag-and-drop
- Reordering updates local state only (via `setState`) — the BLoC is not touched during dragging
- When the user taps "Save", it dispatches `UpdateWatchlist` with the reordered list and pops back
- If the user presses the back button without saving, changes are discarded

### Sharing the BLoC Between Screens

The BLoC is created once in `main.dart` using `BlocProvider`. When navigating to the Edit screen, the same instance is passed using `BlocProvider.value`:

```dart
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (_) => BlocProvider.value(
      value: context.read<WatchlistBloc>(),
      child: const EditWatchlistScreen(),
    ),
  ),
);
```

This ensures both screens share the same BLoC. When the Edit screen dispatches `UpdateWatchlist`, the Main screen's `BlocBuilder` picks up the new state and rebuilds automatically.

### Reorder Logic

Flutter's `ReorderableListView` passes a `newIndex` that assumes the dragged item is still in the list. So when moving an item downward, we subtract 1 from `newIndex` before inserting:

```dart
if (newIndex > oldIndex) {
  newIndex -= 1;
}
final item = list.removeAt(oldIndex);
list.insert(newIndex, item);
```

### UI

`StockTile` is a reusable widget shared by both screens. It shows:
- A colored arrow icon (green for positive, red for negative change)
- Stock name and price
- Change percentage in a colored badge

## Data Flow Diagram

```
main.dart
  └─ BlocProvider(create: WatchlistBloc)
       │
       └─ WatchlistScreen (view-only)
            │  BlocBuilder listens for WatchlistLoaded
            │
            │  User taps Edit icon
            │  └─ Navigator.push with BlocProvider.value(same bloc)
            │
            └─ EditWatchlistScreen
                 │  initState: copies stocks into local _tempStocks
                 │  User drags items: setState updates _tempStocks
                 │  User taps Save:
                 │    └─ dispatch UpdateWatchlist(_tempStocks)
                 │    └─ Navigator.pop()
                 │
                 └─ WatchlistScreen rebuilds with new order
```

## Edge Cases Handled

- **Reordering to the same position** — the index adjustment logic handles this gracefully
- **Empty stock list** — both screens show a "no stocks" message instead of a blank screen
- **Back without saving** — local changes in the Edit screen are discarded since they only exist in `_tempStocks`
- **UI updates after navigation** — `BlocBuilder` on the Main screen automatically rebuilds when the bloc emits a new state

## How to Run

```bash
# Get dependencies
flutter pub get

# Run on a connected device or emulator
flutter run

# Build a release APK
flutter build apk --release --no-tree-shake-icons
```

The release APK is output to:
```
build/app/outputs/flutter-apk/app-release.apk
```

## Requirements

- Flutter SDK >= 2.19.6
- Dart SDK >= 2.19.6
