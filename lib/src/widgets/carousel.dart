import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:spotify/spotify.dart' as spotify;
import 'package:tempo_dingo/src/models/user_model.dart';
import 'package:tempo_dingo/src/screens/game.dart';

class Carousel extends StatefulWidget {
  final List<spotify.Track> tracks;

  const Carousel(this.tracks);

  @override
  _CarouselState createState() => _CarouselState();
}

class _CarouselState extends State<Carousel> with TickerProviderStateMixin {
  UserModel _userModel;

  String _shortenTrackName(String name) {
    List<String> _res = name.split(" (");
    _res = _res.first.split(" -");
    _res = _res.first.split(" /");
    return _res.first;
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<UserModel>(
      builder: (context, child, model) {
        _userModel = model;
        return Container(
          height: 350,
          child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(left: 20, right: 5),
            itemCount: widget.tracks.length,
            itemBuilder: (BuildContext context, int index) {
              final spotify.Track track = widget.tracks[index];
              return Padding(
                padding: const EdgeInsets.only(right: 15),
                child: Container(
                  width: 280,
                  height: 350,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(const Radius.circular(20)),
                  ),
                  child: GestureDetector(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Game(_userModel, track))),
                    child: Column(
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.5),
                                spreadRadius: 0.2,
                                blurRadius: 2,
                                offset: Offset(1, 1),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            child: Image.network(track.album.images.first.url,
                                width: MediaQuery.of(context).size.width),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          _shortenTrackName(track.name),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.title,
                        ),
                        const SizedBox(height: 5),
                        Text(
                          track.artists.first.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.body1,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
