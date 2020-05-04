import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:spotify/spotify_io.dart' as spotify;
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:vibrate/vibrate.dart';

import 'package:tempo_dingo/src/config/theme_config.dart';
import 'package:tempo_dingo/src/models/game_model.dart';
import 'package:tempo_dingo/src/models/user_model.dart';
import 'package:tempo_dingo/src/resources/spotify_repository.dart';

SpotifyRepository spotifyRepository = SpotifyRepository();

class Game extends StatefulWidget {
  final UserModel userModel;
  final spotify.Track track;

  const Game(this.userModel, this.track);

  @override
  _GameState createState() => _GameState();
}

class _GameState extends State<Game> {
  UserModel _userModel;
  GameModel _gameModel;

  int _tapCount = 0;
  double _realTempo = 0;
  double _playerTempo = 0;
  double _accuracy = 0;
  double _progressionPercentage = 0;

  AudioCache audioCache = AudioCache();
  AudioPlayer _audioPlayer = AudioPlayer();

  Duration _timeElapsed = Duration.zero;
  DateTime _startTime;
  DateTime _timestamp;
  Timer _timer;

  void _setAccuracy() {
    if (_playerTempo >= _realTempo)
      _accuracy = _realTempo / _playerTempo;
    else
      _accuracy = _playerTempo / _realTempo;
    _accuracy *= 100;
  }

  void _calculateTempo() {
    if (_tapCount == 1) _startTime = DateTime.now();
    if (_tapCount > 3) {
      _timestamp = DateTime.now();
      _timeElapsed = _timestamp.difference(_startTime);
      print(
          "time elapsed: ${_timeElapsed.inSeconds}.${_timeElapsed.inMilliseconds} seconds");
      print("accuracy: ${_accuracy.toStringAsFixed(3)}");
    }
    if (_timeElapsed.inMicroseconds > 0) {
      _playerTempo =
          (((_tapCount - 3) * 60) / _timeElapsed.inMicroseconds) * 1000000;
      print("${_playerTempo.toStringAsFixed(3)} - $_realTempo");
    }
    _setAccuracy();
  }

  void _tap() async {
    print("tapCount: $_tapCount\n\n");
    _tapCount++;
    if (_userModel.vibration) Vibrate.feedback(FeedbackType.impact);
    if (_tapCount == 1) {
      await _audioPlayer
          .play(widget.track.previewUrl, volume: _userModel.volume / 10)
          .then((res) {
        _gameModel.setGameState(GameState.STARTED);
      });
    }
    _calculateTempo();
  }

  void _checkGameOver() {
    if (_tapCount > 0 && !_userModel.isGameOver) {
      _timestamp = DateTime.now();
      _timeElapsed = _timestamp
          .difference(_startTime == null ? DateTime.now() : _startTime);
      print("check game over");
      print(_timeElapsed.inSeconds);
      if (_timeElapsed.inSeconds > 29) {
        print("game is over");
        _userModel.gameOver();
      }
    }
  }

  @override
  void initState() {
    spotifyRepository.getTempo(widget.track.id).then((tempo) {
      setState(() {
        _realTempo = tempo;
      });
    });
    _timer =
        Timer.periodic(Duration(seconds: 1), (Timer t) => _checkGameOver());
    super.initState();
  }

  @override
  void dispose() {
    _audioPlayer.stop();
    _timer?.cancel();
    _userModel.exitGame();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(elevation: 0),
      backgroundColor: mainTheme,
      body: ScopedModel<GameModel>(
        model: GameModel(),
        child: ScopedModelDescendant<GameModel>(
          builder: (context, child, gameModel) {
            _gameModel = gameModel;
            _gameModel.setRealTempo(_realTempo);
            return ScopedModel<UserModel>(
              model: widget.userModel,
              child: ScopedModelDescendant<UserModel>(
                builder: (context, child, userModel) {
                  _userModel = userModel;
                  _userModel.addToHistory(widget.track.id);
                  return Column(
                    children: <Widget>[
                      Padding(
                        padding:
                            const EdgeInsets.only(right: 35, left: 35, top: 5),
                        child: _AlbumProgressiveBar(
                            widget.track, _progressionPercentage),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        widget.track.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontFamily: 'Apple-Bold',
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        widget.track.artists.first.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 10),
                      _userModel.isGameOver
                          ? _GameOver(_accuracy)
                          : _TapArea(_tap),
                    ],
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

class _AlbumProgressiveBar extends StatefulWidget {
  final spotify.Track track;
  final double percentage;

  const _AlbumProgressiveBar(this.track, this.percentage);

  @override
  __AlbumProgressiveBarState createState() => __AlbumProgressiveBarState();
}

class __AlbumProgressiveBarState extends State<_AlbumProgressiveBar>
    with TickerProviderStateMixin {
  AnimationController _percentageAnimationController;
  double _percentage = 0.0;
  double _newPercentage = 0.0;
  int _secondsElapsed = 0;
  Timer _timer;
  GameModel _gameModel;

  void _oneSecondElapsed(Timer t) {
    if (_gameModel.gameState == GameState.STARTED) {
      setState(() {
        _percentage = _newPercentage;
        _secondsElapsed++;
        if (_secondsElapsed > 30) _secondsElapsed = 1;
        _newPercentage = _secondsElapsed * 10 / 3;
      });
    }
    _percentageAnimationController.forward(from: 0.0);
  }

  @override
  void initState() {
    setState(() {
      _timer = Timer.periodic(
          Duration(seconds: 1), (Timer t) => _oneSecondElapsed(t));
    });
    _percentageAnimationController =
        AnimationController(vsync: this, duration: Duration(seconds: 1))
          ..addListener(() {
            setState(() {
              _percentage = lerpDouble(_percentage, _newPercentage,
                  _percentageAnimationController.value);
            });
          });
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _percentageAnimationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<GameModel>(
      builder: (context, child, gameModel) {
        _gameModel = gameModel;
        return Container(
          width: 300,
          height: 300,
          child: CustomPaint(
            foregroundPainter: _MyPainter(
              completePercent: _percentage,
              width: 3.0,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(300)),
              child: Image.network(widget.track.album.images.first.url,
                  width: MediaQuery.of(context).size.width),
            ),
          ),
        );
      },
    );
  }
}

class _TapArea extends StatefulWidget {
  final Function() tap;

  const _TapArea(this.tap);

  @override
  __TapAreaState createState() => __TapAreaState();
}

class __TapAreaState extends State<_TapArea> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 320,
      width: 355,
      child: Center(
        child: MaterialButton(
          height: 320,
          minWidth: 355,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
          onPressed: () => widget.tap(),
          child: Text(
            "Tap the screen",
            style: TextStyle(
              color: Color.fromRGBO(77, 83, 105, 0.5),
              fontFamily: 'Apple-Semibold',
            ),
          ),
        ),
      ),
    );
  }
}

class _GameOver extends StatefulWidget {
  final double accuracy;

  const _GameOver(this.accuracy);

  @override
  __GameOverState createState() => __GameOverState();
}

class __GameOverState extends State<_GameOver> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[],
        ),
        Text("Awesome!"),
        Text("${widget.accuracy}%"),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            IconButton(
              onPressed: () {},
              icon: Icon(FeatherIcons.repeat),
              color: Colors.white,
              iconSize: 30,
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.favorite_border),
              color: Colors.white,
              iconSize: 30,
            ),
          ],
        ),
      ],
    );
  }
}

class _MyPainter extends CustomPainter {
  double completePercent;
  double width;

  _MyPainter({this.completePercent, this.width});

  Path getOuterPath(Rect rect, {@required TextDirection textDirection}) {
    assert(textDirection != null,
        'The textDirection argument to $runtimeType.getOuterPath must not be null.');
    return Path()..addRect(rect);
  }

  @override
  void paint(Canvas canvas, Size size) {
    Paint complete = Paint()
      ..color = Colors.white
      ..strokeCap = StrokeCap.square
      ..style = PaintingStyle.stroke
      ..strokeWidth = width;

    double arcAngle = 2 * pi * (completePercent / 100);

    canvas.drawArc(
        Rect.fromLTRB(0, 0, 300, 300), -pi / 2, arcAngle, false, complete);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
