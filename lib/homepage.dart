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
import 'package:shared_preferences/shared_preferences.dart';

import 'asset_model.dart';
import 'tile_scheme.dart';
import 'sound_player.dart';
import 'generated/app_localizations.dart';

// custom widgets
import 'widgets/button.dart';
import 'widgets/indicator.dart';
import 'widgets/time_progress.dart';
import 'widgets/message_board.dart';
import 'widgets/game_title.dart';
import 'widgets/language_switcher.dart';

const bool debug =
    String.fromEnvironment('DEBUG_ASSETS', defaultValue: 'false') == 'true';

// Game constants
/// Initial time (in seconds) given to player
const int maxTime = (debug ? 30 : 180);

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
    messageTextKey: "welcomeMessage",
    buttonTextKey: "startButton",
  ),
  running(
    buttonIcon: Icons.pause,
    messageTextKey: "",
    buttonTextKey: "pauseButton",
  ),
  paused(
    buttonIcon: Icons.play_arrow,
    messageTextKey: "pauseMessage",
    buttonTextKey: "resumeButton",
  ),
  gameOver(
    buttonIcon: Icons.play_arrow,
    messageTextKey: "gameOverMessage",
    messageTextAltKey: "gameOverMessageBestScore",
    buttonTextKey: "startButton",
  );

  const GameState({
    required this.buttonTextKey,
    required this.buttonIcon,
    required this.messageTextKey,
    this.messageTextAltKey = '',
  });

  final String buttonTextKey;
  final IconData buttonIcon;
  final String messageTextKey;
  final String messageTextAltKey;

  String getButtonText(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (buttonTextKey) {
      case 'startButton':
        return l10n.startButton;
      case 'pauseButton':
        return l10n.pauseButton;
      case 'resumeButton':
        return l10n.resumeButton;
      default:
        return buttonTextKey;
    }
  }

  String getMessageText(BuildContext context, {bool useAlt = false}) {
    final l10n = AppLocalizations.of(context)!;
    final key = useAlt && messageTextAltKey.isNotEmpty
        ? messageTextAltKey
        : messageTextKey;
    switch (key) {
      case 'welcomeMessage':
        return l10n.welcomeMessage;
      case 'pauseMessage':
        return l10n.pauseMessage;
      case 'gameOverMessage':
        return l10n.gameOverMessage;
      case 'gameOverMessageBestScore':
        return l10n.gameOverMessageBestScore;
      default:
        return key;
    }
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title, this.onLocaleChanged});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;
  final Function(Locale)? onLocaleChanged;

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
  bool _isVolumeOn = false;

  late AnimationController _tileScoringAnimationController;
  late Animation<double> _scaleAnimation;
  List<int> _matchingTiles = [];
  List<int> _notMatchingTiles = [];

  Future<void> _loadBestScore() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _bestScore = prefs.getInt('bestScore') ?? 0;
    });
  }

  Future<void> _saveBestScore(int score) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('bestScore', score);
  }

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

    WidgetsBinding.instance.addPostFrameCallback((_) => _loadBestScore());

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
    if (_isVolumeOn) SoundPlayer.play(Sound.message);
    if (_gameState == GameState.notStarted ||
        _gameState == GameState.gameOver) {
      _startGame();
    } else if (_gameState == GameState.running) {
      _pauseGame();
    } else if (_gameState == GameState.paused) {
      _resumeGame();
    }
  }

  void _onVolumeButtonTap() {
    (_isVolumeOn ? _mute() : _unmute());
  }

  void _onRestartButton() {
    if (_isVolumeOn) SoundPlayer.play(Sound.restart);
    _startGame();
  }

  // Game state changes
  void _updateTime(int seconds) {
    if (_isVolumeOn & (seconds < 6)) SoundPlayer.play(Sound.clock);
    setState(() {
      _timeLeft = seconds;
      _timeProgress = min(1.0, _timeLeft / maxTime);
    });
  }

  void _toggleTile(int index) {
    if (_isVolumeOn) SoundPlayer.play(Sound.tile);
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
      _selectedTiles.clear(); //clean in case of restart
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
        _saveBestScore(_bestScore);
        _isGameCompletedWithBestScore = true;
      }
    });
    if (_isVolumeOn)
      SoundPlayer.play(
        _isGameCompletedWithBestScore ? Sound.endingBest : Sound.ending,
      );
  }

  void _updateBoardAndScore() {
    int matchingLevel = _gameAssets.getMatchingLevel(_selectedTiles);
    if (matchingLevel >= 0) {
      // correct match
      if (_isVolumeOn) SoundPlayer.play(Sound.matchingOK);
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
      if (_isVolumeOn) SoundPlayer.play(Sound.matchingKO);
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

  // volumes handling
  void _mute() {
    SoundPlayer.play(Sound.volume_off);
    setState(() {
      _isVolumeOn = false;
    });
  }

  void _unmute() {
    SoundPlayer.play(Sound.volume_on);
    setState(() {
      _isVolumeOn = true;
    });
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
        actions: [LanguageSwitcher(onLocaleChanged: widget.onLocaleChanged)],
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
                        uiSemantic: AppLocalizations.of(context)!.currentScore,
                      ),
                      TriplexUIIndicator(
                        uiIndicatorText: _formatTime(_timeLeft),
                        uiIndicatorSymbol: Icons.timer,
                        uiSemantic: AppLocalizations.of(context)!.timeLeft,
                      ),
                      TriplexUIIndicator(
                        uiIndicatorText: _formatScore(_bestScore),
                        uiIndicatorSymbol: Icons.emoji_events,
                        uiSemantic: AppLocalizations.of(context)!.bestScore,
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
                          message: _gameState.getMessageText(
                            context,
                            useAlt: _isGameCompletedWithBestScore,
                          ),
                          size: const Size(500, 760),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 20), //empty space
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // Volume button
                    CircleButton(
                      buttonSymbol: (_isVolumeOn
                          ? Icons.volume_off
                          : Icons.volume_up),
                      onTap: () => _onVolumeButtonTap,
                    ),
                    // Main button
                    TriplexButton(
                      buttonSymbol: _gameState.buttonIcon,
                      buttonText: _gameState.getButtonText(context),
                      onTap: () => _onGameButtonTap,
                    ),
                    // Restart button
                    CircleButton(
                      buttonSymbol: Icons.replay,
                      onTap: () => _onRestartButton,
                    ),
                  ],
                ),
                SizedBox(height: 20), //empty space
              ],
            ),
          ),
        ),
      ),
    );
  }
}
