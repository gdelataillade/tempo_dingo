import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:spotify/spotify_io.dart' as spotify;
import 'package:tempo_dingo/src/models/user_model.dart';

class Carousel extends StatefulWidget {
  final List<spotify.Track> tracks;

  const Carousel(this.tracks);

  @override
  _CarouselState createState() => _CarouselState();
}

class _CarouselState extends State<Carousel> with TickerProviderStateMixin {
  UserModel _userModel;

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<UserModel>(
      builder: (context, child, model) {
        _userModel = model;
        return Container(
          height: 400,
          child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(left: 20, right: 5),
            itemCount: widget.tracks.length,
            itemBuilder: (BuildContext context, int index) {
              final spotify.Track track = widget.tracks[index];

              return Container(
                width: 250,
                padding: const EdgeInsets.only(right: 15),
                child: Column(
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      child: Image.network(track.album.images.first.url,
                          width: MediaQuery.of(context).size.width),
                    )
                  ],
                ),
              );
              // return ListTile(
              //   leading: Container(
              //     width: 150,
              //     height: 300,
              //     decoration: BoxDecoration(
              //       color: Colors.white,
              //     ),
              //     child: Row(
              //       children: <Widget>[],
              //     ),
              //   ),
              // );
            },
          ),
        );
      },
    );
  }
}
