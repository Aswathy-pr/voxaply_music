// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:musicvoxaplay/screens/models/song_models.dart';

// Future<void> initializeHive() async {
//   try {
//     await Hive.initFlutter();
//     Hive.registerAdapter(SongAdapter());
//     await Hive.openBox<Song>('songsBox');
//     await Hive.openBox<Song>('recentlyPlayed');
//     await Hive.openBox<Song>('mostPlayed');
//     await Hive.openBox<List<String>>('playlistsBox');
//     // await Hive.box<Map<String, List<String>>>('playlistSongsBox');

//     // Initialize playlistsBox with default 'playlists' key if not exists
//     final playlistsBox = Hive.box<List<String>>('playlistsBox');
//     if (playlistsBox.isEmpty) {
//       await playlistsBox.put('playlists', []);
//       print('Initialized playlistsBox with empty playlists list.');
//     }

//     print('Hive initialized.');
//     print('songsBox opened with ${Hive.box<Song>('songsBox').length} songs.');
//     print('recentlyPlayed box opened with ${Hive.box<Song>('recentlyPlayed').length} songs.');
//     print('mostPlayed box opened with ${Hive.box<Song>('mostPlayed').length} songs.');
//     print('playlistsBox opened with ${playlistsBox.length} entries.');
//     // print('playlistSongsBox opened with ${Hive.box<Map<String, List<String>>>('playlistSongsBox').length} entries.');
//   } catch (e) {
//     print('Error initializing Hive: $e');
//     rethrow;
//   }
// }




import 'package:hive_flutter/hive_flutter.dart';
import 'package:musicvoxaplay/screens/models/song_models.dart';

Future<void> initializeHive() async {
  try {
    await Hive.initFlutter();
    Hive.registerAdapter(SongAdapter());
    await Hive.openBox<Song>('songsBox');
    await Hive.openBox<Song>('recentlyPlayed');
    await Hive.openBox<Song>('mostPlayed');
    await Hive.openBox<List<String>>('playlistsBox');
    await Hive.openBox<Map<String, List<String>>>('playlistSongsBox');

    final playlistsBox = Hive.box<List<String>>('playlistsBox');
    if (playlistsBox.isEmpty) {
      await playlistsBox.put('playlists', []);
      print('Initialized playlistsBox with empty playlists list.');
    }

    final playlistSongsBox = Hive.box<Map<String, List<String>>>('playlistSongsBox');
    if (playlistSongsBox.isEmpty) {
      await playlistSongsBox.put('playlistSongs', {});
      print('Initialized playlistSongsBox with empty map.');
    }

    print('Hive initialized.');
    print('songsBox opened with ${Hive.box<Song>('songsBox').length} songs.');
    print('recentlyPlayed box opened with ${Hive.box<Song>('recentlyPlayed').length} songs.');
    print('mostPlayed box opened with ${Hive.box<Song>('mostPlayed').length} songs.');
    print('playlistsBox opened with ${playlistsBox.length} entries.');
    print('playlistSongsBox opened with ${playlistSongsBox.length} entries.');
  } catch (e) {
    print('Error initializing Hive: $e');
    rethrow;
  }
}



