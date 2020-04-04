import 'package:scoped_model/scoped_model.dart';

enum GameState {
  NOT_STARTED,
  STARTED,
  OVER,
}

class GameModel extends Model {
  GameState _gameState = GameState.NOT_STARTED;
  Duration timeElapsed = Duration.zero;
  DateTime startTime;
  DateTime timestamp;
  int tapCount = 0;
  double _myTempo = 0;
  double _realTempo = 0;
  double accuracy = 0;

  get realTempo => _realTempo;
  get gameState => _gameState;

  void setRealTempo(double realTempo) => _realTempo = realTempo;
  void setGameState(GameState state) {
    print(state);
    _gameState = state;
    _realTempo = 420;
    notifyListeners();
  }
}
