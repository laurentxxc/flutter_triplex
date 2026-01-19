# Triplex : Simple Tile Matching Game

A simple tile matching game made with [Flutter](https://flutter.dev).
Objective was to understand by myself how efficient Flutter is.

## Game rules
In this game, you have limited time to find matching triplets of tiles based on their attributes.
Each tile has different attributes (e.g. representation, size, color, background).

Select three tiles to form a match.

You have a valid match if, for each attribute, the three tiles are either all the same or all different.
The goal is to find as many valid matches as possible before time runs out!

For each matching tiles, a time bonus is given.
The more different attributes you have in the matching tiles, the more points you will score.
Yes, if the three tiles are the same then they are matching indeed but it to easy so no points will be given (only the time bonus).
On the contrary, if the tiles are not matching then negative points will be given (try to think better next time when selecting tiles...)

## Game architecture overview
The game is built using Flutter and follows a simple architecture:

- **Model**: `asset_model.dart` contains the core logic for tiles and matching. It defines `Asset` (tile attributes), `AssetCollection` (board state), and `AssetsFactory` (generation and validation of matches).
- **View**: UI components are in `widgets/` (e.g., `TriplexButton` for actions, `TriplexUIIndicator` for scores, `TriplexTimeProgressBar` for timer, `TriplexBoardMessage` for overlays) and `tile_scheme.dart` (`TileView` for rendering tiles).
- **Controller**: `homepage.dart` manages game state, user interactions, and logic (e.g., selection, scoring, timer).
- **Main**: `main.dart` sets up the app and theme.

The game uses stateful widgets for real-time updates, animations for tile changes, and custom widgets for reusability.

## Current limitations
- No data persistence (scores/best scores reset on app restart).
- Fixed board size (24 tiles in 4x6 grid)
- Single tile theme.

## Author
I am Laurent and I like playing with new languages, computer technologies and coding agents.
You can access my resume at https://webresume-lxxc.vercel.app.