import 'dart:async';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';

class ArtistCard extends StatefulWidget {
  final String imgUrl;
  final String artist;

  const ArtistCard(this.imgUrl, this.artist);

  @override
  _ArtistCardState createState() => _ArtistCardState();
}

class _ArtistCardState extends State<ArtistCard> {
  Image _image;

  String _formatString(String str) {
    String newString = str;

    if (newString.length > 13) return newString.substring(0, 13);
    return str;
  }

  Future<Size> _calculateImageDimension() {
    Completer<Size> completer = Completer();

    _image = Image.network(widget.imgUrl);
    _image.image.resolve(ImageConfiguration()).addListener(
      ImageStreamListener((ImageInfo image, bool _) {
        var myImage = image.image;
        Size size = Size(myImage.width.toDouble(), myImage.height.toDouble());
        completer.complete(size);
      }),
    );
    return completer.future;
  }

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
            child: widget.imgUrl != null
                ? FutureBuilder<Size>(
                    future: _calculateImageDimension(),
                    builder: (context, size) {
                      return FittedBox(
                        child: _image,
                        fit: size.data.height > size.data.width
                            ? BoxFit.fitWidth
                            : BoxFit.fitHeight,
                      );
                    },
                  )
                : Container(color: Colors.grey),
          ),
        ),
        const SizedBox(height: 3),
        Text(_formatString(widget.artist)),
      ],
    );
  }
}
