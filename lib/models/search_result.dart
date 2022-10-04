import 'song.dart';
import 'album.dart';
import 'artist.dart';

class SearchResult {
  final List<Album> albums;
  final List<Artist> artists;
  final List<Song> songs;

  const SearchResult({
    required this.albums,
    required this.artists,
    required this.songs,
  });
}
