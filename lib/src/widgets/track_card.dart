import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tempo_dingo/src/config/theme_config.dart';
import 'package:tempo_dingo/src/models/user_model.dart';
import 'package:vibrate/vibrate.dart';

class TrackCard extends StatefulWidget {
  final String imgUrl;
  final String track;
  final String artist;
  final String trackId;
  final int popularity;

  const TrackCard(
    this.imgUrl,
    this.track,
    this.artist,
    this.trackId,
    this.popularity,
  );

  @override
  _TrackCardState createState() => _TrackCardState();
}

class _TrackCardState extends State<TrackCard> {
  bool _isPurshased = false;
  bool _isLiked = false;
  int _price = 0;

  void _setPrice() {
    double price;

    price = (widget.popularity + 1) / 5;
    _price = price.toInt() + 1;
  }

  String _shortenTrackName(String name) {
    List<String> _res = name.split(" (");
    _res = _res.first.split(" -");
    _res = _res.first.split(" /");
    return _res.first;
  }

  @override
  void initState() {
    _setPrice();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      width: MediaQuery.of(context).size.width - 60,
      height: 65,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(const Radius.circular(15)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              boxShadow: [
                BoxShadow(
                  color: mainTheme.withOpacity(0.3),
                  spreadRadius: 0.5,
                  blurRadius: 5,
                  offset: Offset(1, 1),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.network(widget.imgUrl, width: 65, height: 65),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width - 165,
            padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Flexible(
                  child: Text(
                    _shortenTrackName(widget.track),
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                    maxLines: 1,
                    style: TextStyle(
                      color: mainTheme,
                      fontSize: 17,
                      fontFamily: 'Apple-Semibold',
                    ),
                  ),
                ),
                Text(
                  widget.artist,
                  overflow: TextOverflow.clip,
                  softWrap: false,
                  maxLines: 1,
                  style: TextStyle(
                    color: mainTheme,
                    fontSize: 15,
                    fontFamily: 'Apple',
                  ),
                ),
              ],
            ),
          ),
          ScopedModelDescendant<UserModel>(
            builder: (context, child, model) {
              _isPurshased = model.isPurshased(widget.trackId);
              _isLiked = model.isFavorite(widget.trackId);
              return Padding(
                padding: const EdgeInsets.only(right: 10),
                child: _isPurshased
                    ? GestureDetector(
                        onTap: () {
                          if (model.vibration)
                            Vibrate.feedback(FeedbackType.impact);
                          setState(() => _isLiked = !_isLiked);
                          model.likeUnlikeTrack(widget.trackId);
                        },
                        child: Icon(
                          model.isFavorite(widget.trackId)
                              ? Icons.favorite
                              : Icons.favorite_border,
                          size: 35,
                          color: Colors.red,
                        ),
                      )
                    : GestureDetector(
                        onTap: () => print("purshase"),
                        child: Row(
                          children: <Widget>[
                            Text("$_price", style: TextStyle(color: mainTheme)),
                            Icon(Icons.star,
                                color: Color.fromRGBO(248, 207, 95, 1)),
                          ],
                        ),
                      ),
              );
            },
          ),
        ],
      ),
    );
  }
}
