import 'package:flutter/material.dart';
import 'package:tempo_dingo/src/widgets/artist_card.dart';
import 'package:tempo_dingo/src/widgets/track_card.dart';

Widget artist = ArtistCard(
  "https://i.scdn.co/image/14ce65949a921e76421a0164c17f9ebe0a8d76e8",
  "Jimi Hendrix",
);

List<Widget> artists = [
  artist,
  artist,
  artist,
  artist,
  artist,
  artist,
  artist,
  artist,
  artist,
  artist,
  artist,
  artist,
  artist,
  artist,
];

Widget card1 = TrackCard(
  "https://i.scdn.co/image/ab67616d0000b27319dcd95d28b63d10164327f2",
  "Little Wing",
  "Jimi Hendrix",
  "123123123",
);

Widget card2 = TrackCard(
  "https://i.scdn.co/image/4dd3a9aa1a8dc5b9a49397caa67aff6ae8e7b642",
  "Someday",
  "The Strokes",
  "123123123",
);

List<Widget> tracks = [
  card1,
  card2,
  card1,
  card2,
  card1,
  card2,
  card1,
  card2,
  card1,
  card2,
  card1,
  card2,
  card1,
  card2,
  card1,
  card2,
  card1,
  card2,
  card1,
  card2,
  card1,
  card2,
];
