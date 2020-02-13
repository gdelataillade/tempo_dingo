import 'package:flutter/material.dart';

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
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white),
        color: Colors.white,
        borderRadius: BorderRadius.all(const Radius.circular(100)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: Image.network(widget.imgUrl),
      ),
    );
  }
}
