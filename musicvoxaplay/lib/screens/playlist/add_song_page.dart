// import 'package:flutter/material.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:musicvoxaplay/screens/models/song_models.dart';
// import 'package:musicvoxaplay/screens/widgets/appbar.dart';
// import 'package:musicvoxaplay/screens/widgets/colors.dart';

// class AddSongsPage extends StatelessWidget {
//   final String playlistName;
//   final Box<Map<String, List<String>>> playlistSongsBox;

//   const AddSongsPage({
//     super.key, 
//     required this.playlistName, 
//     required this.playlistSongsBox,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final Box<Song> songsBox = Hive.box<Song>('songsBox');
//     final playlistSongs = playlistSongsBox.get(playlistName)?[playlistName] ?? [];

//     return Scaffold(
//       backgroundColor: AppColors.black,
//       appBar: buildAppBar(context, 'Add Songs to $playlistName', showBackButton: true),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'All Songs',
//               style: TextStyle(
//                 color: AppColors.white,
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 20),
//             Expanded(
//               child: ValueListenableBuilder(
//                 valueListenable: songsBox.listenable(),
//                 builder: (context, Box<Song> box, _) {
//                   final songs = box.values.toList();
                  
//                   return ListView.builder(
//                     itemCount: songs.length,
//                     itemBuilder: (context, index) {
//                       final song = songs[index];
//                       final isInPlaylist = playlistSongs.contains(song.path);

//                       return ListTile(
//                         leading: song.artwork != null
//                             ? Image.memory(
//                                 song.artwork!,
//                                 width: 50,
//                                 height: 50,
//                                 fit: BoxFit.cover,
//                               )
//                             : const Icon(Icons.music_note, color: AppColors.white),
//                         title: Text(
//                           song.title,
//                           style: const TextStyle(color: AppColors.white, fontSize: 16),
//                         ),
//                         subtitle: Text(
//                           song.artist,
//                           style: const TextStyle(color: AppColors.grey, fontSize: 14),
//                         ),
//                         trailing: isInPlaylist
//                             ? const Icon(Icons.check, color: AppColors.black)
//                             : null,
//                         onTap: () {
//                           if (!isInPlaylist) {
//                             final updatedSongs = List<String>.from(playlistSongs);
//                             updatedSongs.add(song.path);
//                             playlistSongsBox.put(
//                               playlistName,
//                               {playlistName: updatedSongs},
//                             );
//                             ScaffoldMessenger.of(context).showSnackBar(
//                               SnackBar(
//                                 content: Text('Added "${song.title}" to $playlistName'),
//                               ),
//                             );
//                           } else {
//                             ScaffoldMessenger.of(context).showSnackBar(
//                               SnackBar(
//                                 content: Text('"${song.title}" is already in $playlistName'),
//                               ),
//                             );
//                           }
//                         },
//                       );
//                     },
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }




import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:musicvoxaplay/screens/models/song_models.dart';
import 'package:musicvoxaplay/screens/widgets/appbar.dart';
import 'package:musicvoxaplay/screens/widgets/colors.dart';

class AddSongsPage extends StatefulWidget {
  final String playlistName;
  final Box<Map<String, dynamic>> playlistSongsBox;

  const AddSongsPage({
    super.key, 
    required this.playlistName, 
    required this.playlistSongsBox,
  });

  @override
  State<AddSongsPage> createState() => _AddSongsPageState();
}

class _AddSongsPageState extends State<AddSongsPage> {
  late Box<Song> songsBox;
  List<String> playlistSongs = [];
  bool showRecentlyPlayed = false;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    songsBox = Hive.box<Song>('songsBox');
    _loadPlaylistSongs();
  }

  void _loadPlaylistSongs() {
    final playlistData = widget.playlistSongsBox.get(widget.playlistName);
    if (playlistData != null && playlistData['songs'] is List) {
      setState(() {
        playlistSongs = List<String>.from(playlistData['songs']);
      });
    }
  }

  List<Song> _filterSongs(List<Song> allSongs) {
    // Apply search filter
    var filtered = allSongs.where((song) =>
      song.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
      song.artist.toLowerCase().contains(searchQuery.toLowerCase())
    ).toList();

    // Apply recently played filter
    if (showRecentlyPlayed) {
      filtered = filtered.where((song) => song.playedAt != null).toList();
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: buildAppBar(context, 'Add Songs to ${widget.playlistName}', showBackButton: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search bar
            TextField(
              onChanged: (value) => setState(() => searchQuery = value),
              decoration: InputDecoration(
                hintText: 'Search songs...',
                hintStyle: TextStyle(color: AppColors.grey),
                prefixIcon: Icon(Icons.search, color: AppColors.white),
                filled: true,
                fillColor: AppColors.grey.withOpacity(0.2),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
              style: TextStyle(color: AppColors.white),
            ),
            const SizedBox(height: 16),
            
            // Recently played toggle
            Row(
              children: [
                Checkbox(
                  value: showRecentlyPlayed,
                  onChanged: (value) => setState(() => showRecentlyPlayed = value ?? false),
                  fillColor: MaterialStateProperty.resolveWith<Color>(
                    (states) => states.contains(MaterialState.selected) 
                        ? AppColors.red 
                        : AppColors.grey,
                  ),
                ),
                const Text(
                  'Recently played',
                  style: TextStyle(color: AppColors.white),
                ),
                const Spacer(),
                Text(
                  '${playlistSongs.length} songs in playlist',
                  style: TextStyle(color: AppColors.grey),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Songs list
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: songsBox.listenable(),
                builder: (context, Box<Song> box, _) {
                  final allSongs = box.values.toList();
                  final displayedSongs = _filterSongs(allSongs);
                  
                  return displayedSongs.isEmpty
                      ? Center(
                          child: Text(
                            searchQuery.isEmpty 
                                ? 'No songs available'
                                : 'No matching songs found',
                            style: TextStyle(color: AppColors.grey),
                          ),
                        )
                      : ListView.builder(
                          itemCount: displayedSongs.length,
                          itemBuilder: (context, index) {
                            final song = displayedSongs[index];
                            final isInPlaylist = playlistSongs.contains(song.path);

                            return Card(
                              margin: const EdgeInsets.only(bottom: 8),
                              color: AppColors.grey.withOpacity(0.1),
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                                leading: song.artwork != null
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(4),
                                        child: Image.memory(
                                          song.artwork!,
                                          width: 50,
                                          height: 50,
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    : Container(
                                        width: 50,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          color: AppColors.grey.withOpacity(0.3),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: Icon(
                                          Icons.music_note,
                                          color: AppColors.white,
                                        ),
                                      ),
                                title: Text(
                                  song.title,
                                  style: TextStyle(
                                    color: AppColors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      song.artist,
                                      style: TextStyle(color: AppColors.grey),
                                    ),
                                    if (song.playedAt != null)
                                      Text(
                                        'Played ${song.playedAt!.toString().split(' ')[0]}',
                                        style: TextStyle(
                                          color: AppColors.red.withOpacity(0.8),
                                          fontSize: 12,
                                        ),
                                      ),
                                  ],
                                ),
                                trailing: IconButton(
                                  icon: Icon(
                                    isInPlaylist ? Icons.check : Icons.add,
                                    color: isInPlaylist ? AppColors.black: AppColors.red,
                                    size: 24,
                                  ),
                                  onPressed: () async {
                                    final updatedSongs = List<String>.from(playlistSongs);
                                    if (isInPlaylist) {
                                      updatedSongs.remove(song.path);
                                    } else {
                                      updatedSongs.add(song.path);
                                    }
                                    
                                    await widget.playlistSongsBox.put(
                                      widget.playlistName,
                                      {
                                        ...widget.playlistSongsBox.get(widget.playlistName) ?? {},
                                        'songs': updatedSongs,
                                        'updatedAt': DateTime.now().toString(),
                                      },
                                    );
                                    
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          isInPlaylist
                                              ? 'Removed from playlist'
                                              : 'Added to playlist',
                                        ),
                                        duration: const Duration(seconds: 1),
                                      ),
                                    );
                                    
                                    setState(() => playlistSongs = updatedSongs);
                                  },
                                ),
                              ),
                            );
                          },
                        );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}