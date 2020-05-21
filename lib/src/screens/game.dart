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
import 'package:fl_chart/fl_chart.dart';

import 'package:tempo_dingo/src/config/theme_config.dart';
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

  int _tapCount = 0;
  double _realTempo = 0;
  double _playerTempo = 0;
  double _accuracy = 0;
  List<ChartItem> _accuracyList = [];

  AudioCache audioCache = AudioCache();
  AudioPlayer _audioPlayer = AudioPlayer();

  Duration _timeElapsed = Duration.zero;
  DateTime _musicStartTime;
  DateTime _gameStartTime;
  DateTime _timestamp;
  Timer _timer;

  void _setAccuracy() {
    if (_playerTempo >= _realTempo)
      _accuracy = _realTempo / _playerTempo;
    else
      _accuracy = _playerTempo / _realTempo;
    _accuracy *= 100;
    if (_accuracy > 0) {
      // print("$_accuracy - ${_timeElapsed.inMilliseconds / 1000.0}");
      _accuracyList
          .add(ChartItem(_accuracy, _timeElapsed.inMilliseconds / 1000.0));
    }
  }

  void _calculateTempo() {
    if (_tapCount == 3) _gameStartTime = DateTime.now();
    if (_tapCount > 3) {
      // Start to calculate tempo & accuracy here
      _timestamp = DateTime.now();
      _timeElapsed = _timestamp.difference(_gameStartTime);
      // print(
      //     "time elapsed: ${_timeElapsed.inSeconds}.${_timeElapsed.inMilliseconds} seconds");
      // print("accuracy: ${_accuracy.toStringAsFixed(3)}");
      _playerTempo =
          (((_tapCount - 3) * 60) / _timeElapsed.inMicroseconds) * 1000000;
      print("${_playerTempo.toStringAsFixed(3)} - $_realTempo");
    }
    _setAccuracy();
  }

  void _tap() async {
    // print("tapCount: $_tapCount");
    setState(() => _tapCount++);
    if (_userModel.vibration) Vibrate.feedback(FeedbackType.impact);
    if (_tapCount == 1) {
      await _audioPlayer
          .play(widget.track.previewUrl, volume: _userModel.volume / 10)
          .then((res) => _musicStartTime = DateTime.now());
    }
    _calculateTempo();
  }

  void _checkGameOver() {
    if (_tapCount > 0 && !_userModel.isGameOver) {
      _timestamp = DateTime.now();
      _timeElapsed = _timestamp
          .difference(_gameStartTime == null ? DateTime.now() : _gameStartTime);
      if (_timestamp.difference(_musicStartTime).inSeconds > 29) {
        _userModel.gameOver();
      }
    }
  }

  void _playAgain() {
    _userModel.exitGame();
    setState(() {
      _tapCount = 0;
      _playerTempo = 0;
      _accuracy = 0;
    });
  }

  String _shortenTrackName(String name) {
    List<String> _res = name.split(" (");
    _res = _res.first.split(" -");
    _res = _res.first.split(" /");
    return _res.first;
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
      body: ScopedModel<UserModel>(
        model: widget.userModel,
        child: ScopedModelDescendant<UserModel>(
          builder: (context, child, userModel) {
            _userModel = userModel;
            _userModel.addToHistory(widget.track.id);
            return SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 35, left: 35, top: 5),
                    child: _AlbumProgressiveBar(
                        widget.track, _tapCount > 0 && !_userModel.isGameOver),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    "${_accuracy.round()}% ${_shortenTrackName(widget.track.name)}",
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
                      ? _GameOver(
                          _accuracy,
                          _playAgain,
                          widget.track.id,
                          _accuracyList,
                        )
                      : _TapArea(_tap),
                ],
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
  final bool isPlaying;

  const _AlbumProgressiveBar(this.track, this.isPlaying);

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

  void _oneSecondElapsed(Timer t) {
    if (widget.isPlaying) {
      setState(() {
        _percentage = _newPercentage;
        _secondsElapsed++;
        _newPercentage = _secondsElapsed * 10 / 3;
      });
      _percentageAnimationController.forward(from: 0.0);
    } else {
      // Reset params if game restarts
      setState(() {
        _percentage = 0;
        _newPercentage = 0;
        _secondsElapsed = 0;
      });
    }
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
  final Function() playAgain;
  final String trackId;
  final List<ChartItem> accuracyList;

  const _GameOver(
    this.accuracy,
    this.playAgain,
    this.trackId,
    this.accuracyList,
  );

  @override
  __GameOverState createState() => __GameOverState();
}

class __GameOverState extends State<_GameOver> {
  bool _isLiked;
  static final Widget _star =
      Icon(Icons.star, size: 40, color: Color.fromRGBO(248, 207, 95, 1));
  List<Widget> _starsEarned = [];
  int _nbStars;

  void _countStars() {
    if (widget.accuracy >= 90) _nbStars++;
    if (widget.accuracy >= 97) _nbStars++;
    if (widget.accuracy >= 99) _nbStars++;
  }

  void _rotateStars() {
    if (_nbStars == 2) {
      _starsEarned.add(Transform.rotate(angle: -0.1, child: _star));
      _starsEarned.add(Transform.rotate(angle: 0.1, child: _star));
    } else if (_nbStars == 3) {
      _starsEarned.add(Padding(
        padding: const EdgeInsets.only(top: 5),
        child: Transform.rotate(angle: -0.4, child: _star),
      ));
      _starsEarned.add(_star);
      _starsEarned.add(Padding(
        padding: const EdgeInsets.only(top: 5),
        child: Transform.rotate(angle: 0.4, child: _star),
      ));
    }
  }

  @override
  void initState() {
    _countStars();
    _rotateStars();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<UserModel>(
      builder: (context, child, userModel) {
        userModel.pushGameStats();
        _isLiked = userModel.isFavorite(widget.trackId);
        print("length: ${widget.accuracyList.length}");
        return Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _starsEarned,
            ),
            Text("Awesome!"),
            Text("${widget.accuracy.toStringAsPrecision(5)}%"),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  onPressed: widget.playAgain,
                  icon: Icon(FeatherIcons.repeat),
                  color: Colors.white,
                  iconSize: 30,
                ),
                // IconButton(
                //   onPressed: () {
                //     setState(() {
                //       _showChart = !_showChart;
                //     });
                //   },
                //   icon: Icon(FeatherIcons.barChart),
                //   color: Colors.white,
                //   iconSize: 33,
                // ),
                IconButton(
                  onPressed: () {
                    userModel.likeUnlikeTrack(widget.trackId);
                    setState(() => _isLiked = !_isLiked);
                  },
                  icon: _isLiked
                      ? Icon(Icons.favorite)
                      : Icon(Icons.favorite_border),
                  color: Colors.red,
                  iconSize: 32,
                ),
              ],
            ),
            LineChartSample2(widget.accuracyList),
          ],
        );
      },
    );
  }
}

class ChartItem {
  final double accuracy;
  final double time;

  ChartItem(this.accuracy, this.time);
}

class LineChartSample2 extends StatefulWidget {
  final List<ChartItem> list;

  const LineChartSample2(this.list);

  @override
  _LineChartSample2State createState() => _LineChartSample2State();
}

class _LineChartSample2State extends State<LineChartSample2> {
  List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];

  bool showAvg = false;

  List<FlSpot> _buildSpots() {
    List<FlSpot> list = [];

    for (var i = 0; i < widget.list.length; i++) {
      list.add(FlSpot(widget.list[i].time / 3, widget.list[i].accuracy / 10));
      print("time: ${widget.list[i].time} -> ${widget.list[i].time / 3}");
      print(
          "accuarcy: ${widget.list[i].accuracy} -> ${widget.list[i].accuracy / 10}");
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        children: <Widget>[
          AspectRatio(
            aspectRatio: 1.70,
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(18),
                ),
                // color: Color(0xff232d37),
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                    right: 18.0, left: 12.0, top: 24, bottom: 12),
                child: LineChart(
                  mainData(),
                  // showAvg ? avgData() : mainData(),
                ),
              ),
            ),
          ),
          // SizedBox(
          //   width: 60,
          //   height: 34,
          //   child: FlatButton(
          //     onPressed: () {
          //       setState(() {
          //         showAvg = !showAvg;
          //       });
          //     },
          //     child: Text(
          //       'avg',
          //       style: TextStyle(
          //           fontSize: 12,
          //           color:
          //               showAvg ? Colors.white.withOpacity(0.5) : Colors.white),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  LineChartData mainData() {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          textStyle: const TextStyle(
            color: Color(0xff68737d),
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
          getTitles: (value) {
            switch (value.toInt()) {
              case 0:
                return '0s';
              case 5:
                return '15s';
              case 10:
                return '30s';
            }
            return '';
          },
          margin: 8,
        ),
        leftTitles: SideTitles(
          showTitles: true,
          textStyle: const TextStyle(
            color: Color(0xff67727d),
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
          getTitles: (value) {
            switch (value.toInt()) {
              case 5:
                return '50%';
              case 10:
                return '100%';
            }
            return '';
          },
          reservedSize: 28,
          margin: 12,
        ),
      ),
      borderData: FlBorderData(
          show: true,
          border: Border.all(color: const Color(0xff37434d), width: 1)),
      minX: 0,
      maxX: 10,
      minY: 0,
      maxY: 10,
      lineBarsData: [
        LineChartBarData(
          spots: _buildSpots(),
          isCurved: true,
          colors: gradientColors,
          barWidth: 4,
          isStrokeCapRound: true,
          dotData: FlDotData(show: false),
          belowBarData: BarAreaData(
            show: true,
            colors:
                gradientColors.map((color) => color.withOpacity(0.3)).toList(),
          ),
        ),
      ],
    );
  }

  // LineChartData avgData() {
  //   return LineChartData(
  //     lineTouchData: LineTouchData(enabled: false),
  //     gridData: FlGridData(
  //       show: true,
  //       drawHorizontalLine: true,
  //       getDrawingVerticalLine: (value) {
  //         return FlLine(
  //           color: const Color(0xff37434d),
  //           strokeWidth: 1,
  //         );
  //       },
  //       getDrawingHorizontalLine: (value) {
  //         return FlLine(
  //           color: const Color(0xff37434d),
  //           strokeWidth: 1,
  //         );
  //       },
  //     ),
  //     titlesData: FlTitlesData(
  //       show: true,
  //       bottomTitles: SideTitles(
  //         showTitles: true,
  //         reservedSize: 22,
  //         textStyle: const TextStyle(
  //             color: Color(0xff68737d),
  //             fontWeight: FontWeight.bold,
  //             fontSize: 16),
  //         getTitles: (value) {
  //           switch (value.toInt()) {
  //             case 0:
  //               return '0s';
  //             case 5:
  //               return '15s';
  //             case 10:
  //               return '30s';
  //           }
  //           return '';
  //         },
  //         margin: 8,
  //       ),
  //       leftTitles: SideTitles(
  //         showTitles: true,
  //         textStyle: const TextStyle(
  //           color: Color(0xff67727d),
  //           fontWeight: FontWeight.bold,
  //           fontSize: 15,
  //         ),
  //         getTitles: (value) {
  //           switch (value.toInt()) {
  //             case 5:
  //               return '50%';
  //             case 10:
  //               return '100%';
  //           }
  //           return '';
  //         },
  //         reservedSize: 28,
  //         margin: 12,
  //       ),
  //     ),
  //     borderData: FlBorderData(
  //         show: true,
  //         border: Border.all(color: const Color(0xff37434d), width: 1)),
  //     minX: 0,
  //     maxX: 10,
  //     minY: 0,
  //     maxY: 10,
  //     lineBarsData: [
  //       LineChartBarData(
  //         spots: _buildSpots(),
  //         isCurved: true,
  //         colors: [
  //           ColorTween(begin: gradientColors[0], end: gradientColors[1])
  //               .lerp(0.2),
  //           ColorTween(begin: gradientColors[0], end: gradientColors[1])
  //               .lerp(0.2),
  //         ],
  //         barWidth: 5,
  //         isStrokeCapRound: true,
  //         dotData: FlDotData(
  //           show: false,
  //         ),
  //         belowBarData: BarAreaData(show: true, colors: [
  //           ColorTween(begin: gradientColors[0], end: gradientColors[1])
  //               .lerp(0.2)
  //               .withOpacity(0.1),
  //           ColorTween(begin: gradientColors[0], end: gradientColors[1])
  //               .lerp(0.2)
  //               .withOpacity(0.1),
  //         ]),
  //       ),
  //     ],
  //   );
  // }
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
