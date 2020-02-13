import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:tempo_dingo/src/config/theme_config.dart';

class TrackCard extends StatefulWidget {
  final String imgUrl;
  final String track;
  final String artist;
  final Function() likeTrack;

  const TrackCard(
    this.imgUrl,
    this.track,
    this.artist,
    this.likeTrack,
  );

  @override
  _TrackCardState createState() => _TrackCardState();
}

class _TrackCardState extends State<TrackCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 15),
      width: MediaQuery.of(context).size.width - 60,
      height: 65,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(const Radius.circular(15)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.network(widget.imgUrl, width: 65, height: 65),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Text(
                  widget.track,
                  style: TextStyle(
                    color: mainTheme,
                    fontSize: 20,
                    fontFamily: 'Apple-Semibold',
                  ),
                ),
                Text(
                  widget.artist,
                  style: TextStyle(
                    color: mainTheme,
                    fontSize: 15,
                    fontFamily: 'Apple',
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: GestureDetector(
              onTap: widget.likeTrack,
              child: Icon(
                FeatherIcons.heart,
                size: 35,
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
