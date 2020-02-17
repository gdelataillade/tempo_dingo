import 'package:flutter/material.dart';
import 'package:tempo_dingo/src/config/theme_config.dart';

class ArtistCard extends StatefulWidget {
  final String imgUrl;
  final String artist;

  const ArtistCard(this.imgUrl, this.artist);

  @override
  _ArtistCardState createState() => _ArtistCardState();
}

class _ArtistCardState extends State<ArtistCard> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white),
            color: Colors.white,
            borderRadius: BorderRadius.all(const Radius.circular(100)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                spreadRadius: 0.5,
                blurRadius: 5,
                offset: Offset(1, 1),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: Image.network(widget.imgUrl),
          ),
        ),
        const SizedBox(height: 3),
        Text(widget.artist),
      ],
    );
  }
}
