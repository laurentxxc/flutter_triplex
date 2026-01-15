// Copyright (c) 2026 Laurent Vincent. All rights reserved.
//
// Triplex - A Flutter-based matching game.
// Licensed under the MIT License.
// See LICENSE file in the project root for full license text.
//
// This file is part of Triplex, a puzzle game where players match tiles based on attributes.

import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

import 'asset_model.dart';
import 'tile_scheme.dart';

// custom widgets
import 'widgets/button.dart';
import 'widgets/indicator.dart';
import 'widgets/time_progress.dart';
import 'widgets/message_board.dart';
import 'widgets/game_title.dart';

const String introMessage = '''
🎉 Welcome to Triplex 🎉

In this game, you have limited time to find matching triplets of tiles based on their attributes.
Each tile has different attributes (e.g. representation, size, color, background).

Select three tiles to form a match.

You have a valid match if, for each attribute, the three tiles are either all the same or all different.
The goal is to find as many valid matches as possible before time runs out!

Good luck and have fun! 🍀
''';

const String pauseMessage = '''
The game is paused.

Take a break ☕️ and resume when you're ready!
''';

const String gameOverMessage = '''
Game Over! Time's up.

Try to beat your best score next time!

😜
''';

const String gameOverMessageBestScore = '''
Game Over! Time's up.

Congratulation ! You make the best score this time.

🎉
''';

// Game constants
/// Initial time (in seconds) given to player
const int maxTime = 180;

/// Score penalty per tile in case of wrong match
const int scorePenalty = -1;

/// Score bonus per different attribute value per tile in case of correct match
const int scoreBonus = 1;

/// Extra time (in seconds) awarded per correct match
const int timeExtra = 10;

//UI constants
/// UI size constraints
const double uiWidth = 500;
const double iconSize = 40;

//UI Colors
const Color mainThemeColor = Colors.deepPurple;
const Color tileSelectionColor = Colors.orange;

enum GameState {
  notStarted(
    buttonIcon: Icons.play_arrow,
    buttonText: "Start",
    messageText: introMessage,
  ),
  running(buttonIcon: Icons.pause, buttonText: "Pause", messageText: ""),
  paused(
    buttonIcon: Icons.play_arrow,
    buttonText: "Resume",
    messageText: pauseMessage,
  ),
  gameOver(
    buttonIcon: Icons.play_arrow,
    buttonText: "Start",
    messageText: gameOverMessage, 
    messageTextAlt: gameOverMessageBestScore,
  );

  const GameState({
    required this.buttonText,
    required this.buttonIcon,
    required this.messageText,
    this.messageTextAlt = ''
  });

  final String buttonText;
  final IconData buttonIcon;
  final String messageText;
  final String messageTextAlt;
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  // Game logic
  // List<TriplexTile> _tiles = [
  //   for (var i = 0; i < 24; i++)
  //       TriplexTile(i: i, onTap: () => _onTileSelected()),
  // ];

  GameState _gameState = GameState.notStarted;
  AssetCollection _gameAssets = AssetCollection();
  List<int> _selectedTiles = [];
  int _score = 0;
  int _bestScore = 0;
  int _timeLeft = maxTime;
  int _tileScore = 0;
  double _timeProgress = 1.0;
  Timer? _gameTimer;
  bool _isGameCompletedWithBestScore = false;

  late AnimationController _tileScoringAnimationController;
  late Animation<double> _scaleAnimation;
  List<int> _matchingTiles = [];
  List<int> _notMatchingTiles = [];

  @override
  void initState() {
    _tileScoringAnimationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.5,
    ).animate(_tileScoringAnimationController);

    super.initState();
  }

  // UI Widget trigger events
  void _onTileTap(int index) {
    if (_gameState != GameState.running) return;
    _toggleTile(index);
    if (_selectedTiles.length == 3) _updateBoardAndScore();
  }

  void _onTimerTick() {
    if (_timeLeft > 0) {
      _updateTime(_timeLeft - 1);
    } else {
      // Time's up - end the game
      _endGame();
    }
  }

  void _onGameButtonTap() {
    if (_gameState == GameState.notStarted ||
        _gameState == GameState.gameOver) {
      _startGame();
    } else if (_gameState == GameState.running) {
      _pauseGame();
    } else if (_gameState == GameState.paused) {
      _resumeGame();
    }
  }

  // Game state changes
  void _updateTime(int seconds) {
    setState(() {
      _timeLeft = seconds;
      _timeProgress = min(1.0, _timeLeft / maxTime);
    });
  }

  void _toggleTile(int index) {
    setState(() {
      if (!_selectedTiles.contains(index)) {
        _selectedTiles.add(index);
      } else {
        _selectedTiles.remove(index);
      }
    });
  }

  void _startGame() {
    setState(() {
      // init game assets
      _gameAssets = AssetCollection();
      _gameState = GameState.running;
      _score = 0;
      _isGameCompletedWithBestScore = false;
      _timeLeft = maxTime;
      _timeProgress = 1.0;
      _gameTimer?.cancel();
      _gameTimer = Timer.periodic(
        Duration(seconds: 1),
        (timer) => _onTimerTick(),
      );
    });
  }

  void _pauseGame() {
    setState(() {
      _gameState = GameState.paused;
      _gameTimer?.cancel();
      _selectedTiles.clear();
    });
  }

  void _resumeGame() {
    setState(() {
      _gameState = GameState.running;
      _gameTimer?.cancel();
      _gameTimer = Timer.periodic(
        Duration(seconds: 1),
        (timer) => _onTimerTick(),
      );
    });
  }

  void _endGame() {
    setState(() {
      _gameState = GameState.gameOver;
      _selectedTiles.clear();
      _gameTimer?.cancel();
      if (_score > _bestScore) {
        _bestScore = _score;
        _isGameCompletedWithBestScore = true;
      }
    });
  }

  void _updateBoardAndScore() {
    int matchingLevel = _gameAssets.getMatchingLevel(_selectedTiles);
    if (matchingLevel >= 0) {
      // correct match
      setState(() {
        _tileScore =
            (AssetsFactory.nbCriteriaPerAsset - matchingLevel) * scoreBonus;
        _score += _tileScore * _selectedTiles.length;
        _timeLeft = min(maxTime, _timeLeft + timeExtra);
        _timeProgress = min(1.0, _timeLeft / maxTime);
        // update matched tiles with random new assets making sure there is always a possible match
        _matchingTiles = List.from(_selectedTiles);
        _tileScoringAnimationController.reset();
        _tileScoringAnimationController.forward().then(
          (_) => setState(() {
            _gameAssets.updateCollection(_matchingTiles);
            _tileScoringAnimationController.reverse().then(
              (_) => setState(() => _matchingTiles.clear()),
            );
          }),
        );
        _selectedTiles.clear();
      });
    } else {
      // wrong match
      setState(() {
        _notMatchingTiles = List.from(_selectedTiles);
        _score += scorePenalty;
        _selectedTiles.clear();
        _tileScoringAnimationController.reset();
        _tileScoringAnimationController.forward().then(
          (_) => setState(() => _notMatchingTiles.clear()),
        );
      });
    }
  }

  // Heplers for building UI
  String _formatTime(int seconds) {
    int min = seconds ~/ 60;
    int sec = seconds % 60;
    return '${min.toString().padLeft(2, '0')}:${sec.toString().padLeft(2, '0')}';
  }

  String _formatScore(int score) {
    if (score >= 0) {
      return score.toString().padLeft(4, '0');
    } else {
      return "-" + (score * -1).toString().padLeft(3, '0');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textPointStyle = theme.textTheme.displaySmall!.copyWith(
      fontSize: 40,
      color: tileSelectionColor,
      fontWeight: FontWeight.bold,
    );

    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: theme.colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: GameTitle(title: widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: FittedBox(
          fit: BoxFit.contain,
          child: SizedBox(
            width: uiWidth,
            //height: maxHeight,
            child: Column(
              //mainAxisAlignment: .start,
              //verticalDirection: VerticalDirection.down,
              children: [
                // score display
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TriplexUIIndicator(
                        uiIndicatorText: _formatScore(_score),
                        uiIndicatorSymbol: Icons.sports_score,
                        uiSemantic: 'Current score',
                      ),
                      TriplexUIIndicator(
                        uiIndicatorText: _formatTime(_timeLeft),
                        uiIndicatorSymbol: Icons.timer,
                        uiSemantic: 'Time left',
                      ),
                      TriplexUIIndicator(
                        uiIndicatorText: _formatScore(_bestScore),
                        uiIndicatorSymbol: Icons.emoji_events,
                        uiSemantic: 'Best score',
                      ),
                    ],
                  ),
                ),
                // Timer
                Padding(
                  padding: EdgeInsets.only(top: 20, bottom: 20),
                  child: TriplexTimeProgressBar(progress: _timeProgress),
                ),
                // Play grid
                Stack(
                  fit: StackFit.passthrough,
                  children: [
                    // base widget
                    ScrollConfiguration(
                      behavior: ScrollConfiguration.of(
                        context,
                      ).copyWith(scrollbars: false, overscroll: false),
                      child: GridView.builder(
                        shrinkWrap: true,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                            ),
                        itemCount: 24,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              // Handle tile tap
                              _onTileTap(index);
                              print('You tapped on tile $index');
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: (_selectedTiles.contains(index)
                                      ? tileSelectionColor
                                      : theme.colorScheme.primary),
                                  width: 10,
                                ),
                                color: theme.colorScheme.primaryContainer,
                              ),
                              child: Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: AnimatedBuilder(
                                      animation: _scaleAnimation,
                                      builder: (context, child) =>
                                          Transform.scale(
                                            scale:
                                                _matchingTiles.contains(index)
                                                ? _scaleAnimation.value
                                                : 1.0,
                                            child: child,
                                          ),
                                      child: Opacity(
                                        opacity: _matchingTiles.contains(index)
                                            ? 1.6 - _scaleAnimation.value
                                            : 1,
                                        child: (_gameState == GameState.running
                                            ? TileView.fromAsset(
                                                _gameAssets.assetAt(index),
                                              )
                                            : TileView.empty()),
                                      ),
                                    ),
                                  ),
                                  // Overlay for card for points
                                  if (_matchingTiles.contains(index))
                                    AnimatedBuilder(
                                      animation: _scaleAnimation,
                                      builder: (context, child) =>
                                          Transform.scale(
                                            scale: _scaleAnimation.value,
                                            child: child,
                                          ),
                                      child: Center(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                            bottom: 10,
                                          ),
                                          child: Text(
                                            '+$_tileScore',
                                            style: textPointStyle,
                                          ),
                                        ),
                                      ),
                                    ),
                                  // Overlay for wrong tile indication
                                  if (_notMatchingTiles.contains(index))
                                    AnimatedBuilder(
                                      animation: _scaleAnimation,
                                      builder: (context, child) =>
                                          Transform.scale(
                                            scale: 2.5 - _scaleAnimation.value,
                                            child: child,
                                          ),
                                      child: Center(
                                        child: Icon(
                                          Icons.cancel,
                                          weight: 10,
                                          shadows: [
                                            Shadow(
                                              color: theme
                                                  .colorScheme
                                                  .primaryContainer,
                                              blurRadius: 10,
                                            ),
                                          ],
                                          size: 70,
                                          color: Colors.red.shade900,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    // Overlay message
                    if (_gameState != GameState.running)
                      Positioned(
                        top: 0,
                        left: 0,
                        child: TriplexBoardMessage(
                          message: (_isGameCompletedWithBestScore ? _gameState.messageTextAlt: _gameState.messageText),
                          size: const Size(500, 760),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 20), //empty space
                TriplexButton(
                  buttonSymbol: _gameState.buttonIcon,
                  buttonText: _gameState.buttonText,
                  onTap: () => _onGameButtonTap,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
