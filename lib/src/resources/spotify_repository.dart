import 'package:spotify/spotify_io.dart';

class SpotifyRepository {
  static var credentials = new SpotifyApiCredentials(
      '5213b2fb597f452fbe59572ead70764c', 'ca8813b3d2174e0ab8c55069c18387b3');
  static var spotify = new SpotifyApi(credentials);

  Future<List<Artist>> getArtistsSearchResults(String input) async {
    final List<Artist> list = [];
    var result = await spotify.search.get(input).first(10);

    result.forEach((pages) {
      pages.items.forEach((item) {
        if (item is Artist) list.add(item);
      });
    });

    // print("api artists search '$input': ${list.length} results");
    return list;
  }

  Future<List<Track>> getTrackSearchResults(String input) async {
    final List<Track> list = [];
    var result = await spotify.search.get(input).first(20);

    result.forEach((pages) {
      pages.items.forEach((item) {
        if (item is Track) list.add(item);
      });
    });

    // print("api track search '$input': ${list.length} results");
    return list;
  }

  Future<double> getTempo(String id) async {
    var audioFeature = await spotify.audioFeatures.get(id);

    return audioFeature.tempo;
  }

  Future<List<Track>> getTrackList(List<String> tracksId, String type) async {
    List<Track> tracks = [];
    Track result;

    // print(type);
    for (int i = 0; i < tracksId.length; i++) {
      result = await spotify.tracks.get(tracksId[i]);
      tracks.add(result);
      // print("${result.name}: ${tracksId[i]}");
    }
    return tracks;
  }

  Future<List<Artist>> getArtistsList(List<String> artistsId) async {
    List<Artist> artists = [];
    Artist result;

    for (int i = 0; i < artistsId.length; i++) {
      result = await spotify.artists.get(artistsId[i]);
      artists.add(result);
    }
    return artists;
  }

  Future<List<Track>> getArtistTracks(String artistName, String artistId
      // , List<Track> libraryTracks
      ) async {
    List<Track> tracks = [];
    var results = await spotify.search.get(artistName).first(50);

    // for (int i = 0; i < libraryTracks.length; i++) {
    //   if (libraryTracks[i].artists[0].id == artistId)
    //     tracks.add(libraryTracks[i]);
    // }
    results.forEach((pages) {
      pages.items.forEach((item) {
        if (item is Track) {
          if (item.artists[0].id == artistId) {
            tracks.add(item);
            // for (int i = 0; i < libraryTracks.length; i++)
            // if (item.id == libraryTracks[i].id) tracks.remove(item);
          }
        }
      });
    });
    return tracks;
  }

  Future<List<Track>> getRecommandedTracks(
      List<Artist> libraryArtists, List<Track> tracksLibrary) async {
    List<Track> tracks = [];
    var results;
    double nbResultsWanted = 20 / libraryArtists.length;

    for (int i = 0; i < libraryArtists.length; i++) {
      results = await spotify.search
          .get(libraryArtists[i].name)
          .first(nbResultsWanted.toInt());
      results.forEach((pages) {
        pages.items.forEach((item) {
          if (item is Track && item.previewUrl != null) {
            tracks.add(item);
            for (int i = 0; i < tracksLibrary.length; i++)
              if (item.name == tracksLibrary[i].name) tracks.remove(item);
          }
        });
      });
    }
    return tracks;
  }
}
