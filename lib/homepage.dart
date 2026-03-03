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
import 'package:flutter/services.dart';

// custom models
import 'models/achievement_model.dart';
import 'models/asset_model.dart';
import 'tile_scheme.dart';
import 'sound_player.dart';

// custom widgets
import 'widgets/button.dart';
import 'widgets/indicator.dart';
import 'widgets/time_progress.dart';
import 'widgets/message_board.dart';
import 'widgets/game_title.dart';
import 'widgets/settings_panel.dart';
import 'widgets/tutorial_board.dart';

// custom services
import 'services/share_service.dart';
import 'services/achievement_images.dart';
import 'services/achievement_storages.dart';

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
  notStarted(buttonType: TriplexButtonType.start),
  running(buttonType: TriplexButtonType.pause),
  paused(buttonType: TriplexButtonType.resume, messageId: MessageType.pause),
  gameOver(
    buttonType: TriplexButtonType.start,
    messageId: MessageType.gameOver,
  ),
  bestScore(
    buttonType: TriplexButtonType.start,
    messageId: MessageType.bestScore,
  );

  const GameState({
    required this.buttonType,
    this.messageId = MessageType.none,
  });

  final TriplexButtonType buttonType;
  final MessageType messageId;
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
    required this.title,
    required this.onLocaleChanged,
  });

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;
  final Function(Locale) onLocaleChanged;

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
  late AssetCollection _gameAssets;
  List<int> _selectedTiles = [];
  int _score = 0;
  int _bestScore = 0;
  int _timeLeft = maxTime;
  int _tileScore = 0;
  double _timeProgress = 1.0;
  Timer? _gameTimer;
  bool _isVolumeOn = false;
  bool _isSettingsOn = false; 
  bool _isTutorialOn = true;
  bool _isGeneratingImage = false;
  bool _isEasyMode = false;
  late Achievement _lastBestScoreAchievement;
  Uint8List? _lastBestScoreAchievementImage;

  late AnimationController _tileScoringAnimationController;
  late Animation<double> _scaleAnimation;
  List<int> _matchingTiles = [];
  List<int> _notMatchingTiles = [];

  //for debug only
  late FocusNode _debugFocusNode;

  // load best score for easy or normal session depending _isEasyMode global value
  Future<void> _loadBestScore() async {

    Achievement? bestScoreAchievement = await AchievementStorage.loadAchievement(
    _isEasyMode 
    ? AchievementID.bestScoreEZ 
    : AchievementID.bestScore);

    // up to v1.4.0 best score was only stored in shared preferences and not with achievement format, so we need to handle this particular case for backward compatibility
    if (bestScoreAchievement == null || bestScoreAchievement.criteria['score'] == 0) {
      int cachedBestScore = 0;
      
      if (!_isEasyMode) {
        // try to load best score from shared preferences
        final SharedPreferences preferences = await SharedPreferences.getInstance();
        cachedBestScore = preferences.getInt('bestScore') ?? 0;
        // remove the old bestScore preference
        preferences.remove('bestScore');
      }

      bestScoreAchievement = Achievement(
        id: (_isEasyMode ? AchievementID.bestScoreEZ: AchievementID.bestScore),
        criteria: {'score': cachedBestScore},
        nbTimesUnlocked: cachedBestScore > 0 ? 1 : 0,
        unlockedAt: cachedBestScore > 0 ? DateTime.now() : null,
      );

      if (cachedBestScore > 0) {
        AchievementStorage.updateAchievement(bestScoreAchievement);
      }
    }

    setState(() {
      _bestScore = bestScoreAchievement!.criteria['score'] ?? 0;
      _lastBestScoreAchievement = bestScoreAchievement;
    });
  }

  Future<void> _saveBestScore(Achievement bestScoreAchievement) async {
    AchievementStorage.updateAchievement(bestScoreAchievement);
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

    if (debug) _debugFocusNode = FocusNode();  
    
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
        _gameState == GameState.gameOver ||
        _gameState == GameState.bestScore) {
      _startGame();
    } else if (_gameState == GameState.running) {
      _pauseGame();
    } else if (_gameState == GameState.paused) {
      _resumeGame();
    }
  }

  void _onVolumeToggleSwitch(bool target) {
    (target ? _soundOn() : _soundOff());
  }

  void _onSettingsButtonTap() {
    if (_isVolumeOn) SoundPlayer.play(Sound.message);
    if (_isSettingsOn) {
      _closeSettings();
    } else {
      if (_gameState == GameState.running) _pauseGame();
      _openSettings();
    }
  }

  void _onTutorialSettingEvt() {
    // game is not running normally because we are in Settings
    if (_gameState == GameState.running) return;
    if (_isVolumeOn) SoundPlayer.play(Sound.message);
    setState(() {
      _isSettingsOn = false;
      _isTutorialOn = true;
    });
  }

  void _onEasyModeSettingEvt(bool easyModeOn){
    if (_gameState == GameState.running) return; // can't change mode during game
    if (_gameState == GameState.paused) _endGame();
    setState(() {
      _isEasyMode = !_isEasyMode;
      // we need to reload best score achievement
      _loadBestScore();
      // set last achievement image to null as this is from old mode
      _lastBestScoreAchievementImage = null;
    });
    }

  void _onRestartButton() {
    if (_isVolumeOn) SoundPlayer.play(Sound.restart);
    _startGame();
  }

  void _onShareButtonTap(){
    ShareService.shareAchievement(
        context: context,
        achievement: _lastBestScoreAchievement,
      );
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
      _isSettingsOn = false;
      _isTutorialOn = false;
      _selectedTiles.clear(); //clean in case of restart
      _gameAssets = AssetCollection(factory: _isEasyMode ? AssetsFactory.singletonEasy : AssetsFactory.singleton);
      _gameState = GameState.running;
      _score = 0;
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
      _isSettingsOn = false;
      _isTutorialOn = false;
      _gameState = GameState.running;
      _gameTimer?.cancel();
      _gameTimer = Timer.periodic(
        Duration(seconds: 1),
        (timer) => _onTimerTick(),
      );
    });
  }

  void _endGame() {
    bool bestScoreReached = false;
    setState(() {
      _gameState = GameState.gameOver;
      _selectedTiles.clear();
      _gameTimer?.cancel();
      if (_score > _bestScore) {
        bestScoreReached = true;
        _gameState = GameState.bestScore;
        _bestScore = _score;
        _lastBestScoreAchievement = _lastBestScoreAchievement.copyWith(
          criteria: {'score': _bestScore},
          nbTimesUnlocked: _lastBestScoreAchievement.nbTimesUnlocked + 1,
          unlockedAt: DateTime.now(),
        );
        _generateBestScoreAchievementImage(_lastBestScoreAchievement);
        _saveBestScore(_lastBestScoreAchievement);
      } else if (_bestScore >0 && _lastBestScoreAchievementImage == null) {
        // if we have a best score but no image (e.g., because we are loading an old best score stored before we implemented achievement images), we try to load the image
        _generateBestScoreAchievementImage(_lastBestScoreAchievement);
      } 
    });
    if (_isVolumeOn) {
      SoundPlayer.play(bestScoreReached ? Sound.endingBest : Sound.ending);
    }
  }

  void _generateBestScoreAchievementImage(Achievement bestScoreAchievement){
    // don't generate if achievement is not unlocked of bestSCore is 0;
    if (bestScoreAchievement.criteria['score'] == 0) return;

    setState(() {
      _isGeneratingImage = true;
      AchievementImageService.getAchievementImage(
        achievement: bestScoreAchievement,
      ).then(
        (imageBytes) => setState(() {
          _lastBestScoreAchievementImage = imageBytes;
          _isGeneratingImage = false;
        }),
      );
    });
  }

  void _updateBoardAndScore() {
    int matchingLevel = _gameAssets.getMatchingLevel(_selectedTiles);
    if (matchingLevel >= 0) {
      // correct match
      if (_isVolumeOn) SoundPlayer.play(Sound.matchingOK);
      setState(() {
        _tileScore =
            (_gameAssets.factory!.nbCriteriaPerAsset - matchingLevel) * scoreBonus;
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

  // handle settings panel
  void _openSettings() {
    setState(() {
      _isSettingsOn = true;
    });
  }

  void _closeSettings() {
    setState(() {
      _isSettingsOn = false;
    });
  }

  // volumes handling
  void _soundOff() {
    SoundPlayer.play(Sound.volume_off);
    setState(() {
      _isVolumeOn = false;
    });
  }

  void _soundOn() {
    SoundPlayer.play(Sound.volume_on);
    setState(() {
      _isVolumeOn = true;
    });
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

    final List<Widget> bestScoreExtraWidgets = _lastBestScoreAchievementImage != null 
    ? [
        messageBoardVSpace,
        Container(
        width: 150, height: 150,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.6), blurRadius: 10)],
        ),
        child: Image.memory(_lastBestScoreAchievementImage!, width: 150, height: 150)),
        messageBoardVSpace,
                            // Share button
        ShareButton(onTap: () => _onShareButtonTap()),
      ]
    : [];
    
    Widget content = Scaffold(
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
                        type: TriplexUIIndicatorType.currentScore,
                        value: _score,
                      ),
                      TriplexUIIndicator(
                        type: TriplexUIIndicatorType.timeLeft,
                        value: _timeLeft,
                      ),
                      TriplexUIIndicator(
                        type: TriplexUIIndicatorType.bestScore,
                        value: _bestScore,
                      ),
                    ],
                  ),
                ),
                // Timer
                Padding(
                  padding: EdgeInsets.only(top: 20, bottom: 20),
                  child: TriplexTimeProgressBar(progress: _timeProgress, easyModeOn: _isEasyMode,),
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
                              //print('You tapped on tile $index');
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
                      if (_isTutorialOn)
                        Positioned(top:0, left:0, child: TriplexTutorial())                   
                      else
                        Positioned(top:0, left:0, child: TriplexBoardMessage(
                          message: _gameState.messageId,
                          extra: (_gameState != GameState.paused) ? bestScoreExtraWidgets : [],)
                        ),

                    if (_isSettingsOn)
                      Positioned(
                        top: 0,
                        left: 0,
                        child: SettingsPanel(
                          size: const Size(500, 760),
                          isSoundOn: _isVolumeOn,
                          onSoundTap: (b) => _onVolumeToggleSwitch(b),
                          onLanguageTap: (loc) => widget.onLocaleChanged(loc),
                          onTutorialTap: () => _onTutorialSettingEvt(),
                          onEasyModeTap: (b) => _onEasyModeSettingEvt(b),
                          isEasyModeOn: _isEasyMode,
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 20), //empty space
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CircleButton(
                      type: CircleButtonType.settings,
                      onTap: () => _onSettingsButtonTap,
                    ),
                    // Main button
                    TriplexButton(
                      type: _gameState.buttonType,
                      onTap: () => _onGameButtonTap,
                    ),
                    // Restart button
                    CircleButton(
                      type: CircleButtonType.restart,
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

    if (debug) {
      content = KeyboardListener(
        focusNode: _debugFocusNode,
        autofocus: true,
        onKeyEvent: _handleKeyEvent,
        child: content);
    }

    return content;
  }

  // Debug method to handle keyboard events for testing purposes
  void _handleKeyEvent(KeyEvent event) {
    print("Key: ${event.logicalKey}"); // Log the event for debugging
    if (!debug) return; // Only work in debug mode

    if (event is KeyDownEvent) {
      final isShiftPressed = HardwareKeyboard.instance.isShiftPressed;

      switch (event.logicalKey) {
        case LogicalKeyboardKey.digit1:
          if (isShiftPressed) {
            _adjustScore(-10);
          } else {
            _adjustScore(10);
          }
        case LogicalKeyboardKey.digit2:
          if (isShiftPressed) {
            _adjustTimeLeft(-10);
          } else {
            _adjustTimeLeft(10);
          }
        case LogicalKeyboardKey.digit3:
          if (isShiftPressed) {
            _adjustBestScore(-10);
          } else {
            _adjustBestScore(10);
          }
        case LogicalKeyboardKey.keyR:
          _resetDebugValues();
      }
    }
  }

  // Add these helper methods
  void _adjustScore(int delta) {
    setState(() {
      _score = _score + delta;
    });
  }

  void _adjustTimeLeft(int delta) {
    setState(() {
      _timeLeft = max(0, min(maxTime * 2, _timeLeft + delta));
      _timeProgress = min(1.0, _timeLeft / maxTime);
    });
  }

  void _adjustBestScore(int delta) {
    setState(() {
      _bestScore = max(0, _bestScore + delta);
    });
  }

  void _resetDebugValues() {
    setState(() {
      _score = 0;
      _timeLeft = maxTime;
      _bestScore = 0;
      _timeProgress = 1.0;
    });
  }

}
