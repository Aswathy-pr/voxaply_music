// import 'package:flutter/material.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:musicvoxaplay/screens/favourites/favourites.dart';
// import 'package:musicvoxaplay/screens/recently played/audio_recently.dart';
// import 'package:musicvoxaplay/screens/widgets/colors.dart';
// import 'package:musicvoxaplay/screens/most played/audio_mostplayed.dart';
// import 'package:musicvoxaplay/screens/models/song_models.dart';
// import 'package:musicvoxaplay/screens/playlist/delete_playlist.dart';

// class AudioContent extends StatefulWidget {
//   final Song? currentSong;

//   const AudioContent({super.key, this.currentSong});

//   @override
//   _AudioContentState createState() => _AudioContentState();
// }

// class _AudioContentState extends State<AudioContent> {
//   final Box<List<String>> _playlistsBox = Hive.box<List<String>>('playlistsBox');
//   final Box<Map<String, List<String>>> _playlistSongsBox = Hive.box<Map<String, List<String>>>('playlistSongsBox');

//   @override
//   void initState() {
//     super.initState();
//     if (_playlistsBox.isEmpty || !_playlistsBox.containsKey('playlists')) {
//       _playlistsBox.put('playlists', []);
//       print('Initialized playlistsBox with empty playlists list.');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           ValueListenableBuilder(
//             valueListenable: _playlistsBox.listenable(),
//             builder: (context, Box<List<String>> box, child) {
//               final playlists = box.get('playlists') ?? [];

//               return LayoutBuilder(
//                 builder: (context, constraints) {
//                   final buttonWidth = (constraints.maxWidth - 10) / 2;

//                   return Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // Row 1: Favourites and Recently Played
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Expanded(
//                             child: _buildPlaylistItem(
//                               context: context,
//                               icon: Icons.favorite,
//                               label: 'Favourites',
//                               onTap: () {
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (context) => const Favourites(),
//                                   ),
//                                 );
//                               },
//                               height: 70,
//                             ),
//                           ),
//                           const SizedBox(width: 10),
//                           Expanded(
//                             child: _buildPlaylistItem(
//                               context: context,
//                               icon: Icons.history,
//                               label: 'Recently Played',
//                               onTap: () {
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (context) => const RecentlyPlayedPage(),
//                                   ),
//                                 );
//                               },
//                               height: 70,
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 20),
//                       // Row 2: First two playlists (if any)
//                       if (playlists.isNotEmpty)
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Expanded(
//                               child: _buildPlaylistItem(
//                                 context: context,
//                                 icon: Icons.playlist_play,
//                                 label: playlists[0],
//                                 onTap: () {
//                                   ScaffoldMessenger.of(context).showSnackBar(
//                                     SnackBar(
//                                       content: Text('Tapped ${playlists[0]}'),
//                                     ),
//                                   );
//                                 },
//                                 height: 70,
//                               ),
//                             ),
//                             if (playlists.length > 1) const SizedBox(width: 10),
//                             if (playlists.length > 1)
//                               Expanded(
//                                 child: _buildPlaylistItem(
//                                   context: context,
//                                   icon: Icons.playlist_play,
//                                   label: playlists[1],
//                                   onTap: () {
//                                     ScaffoldMessenger.of(context).showSnackBar(
//                                       SnackBar(
//                                         content: Text('Tapped ${playlists[1]}'),
//                                       ),
//                                     );
//                                   },
//                                   height: 70,
//                                 ),
//                               ),
//                           ],
//                         ),
//                       const SizedBox(height: 20),
//                       // Row 3: Most Played and third playlist (if any)
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           SizedBox(
//                             width: buttonWidth,
//                             child: _buildPlaylistItem(
//                               context: context,
//                               icon: Icons.play_circle,
//                               label: 'Most Played',
//                               onTap: () {
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (context) => const MostPlayed(),
//                                   ),
//                                 );
//                               },
//                               height: 70,
//                             ),
//                           ),
//                           const SizedBox(width: 10),
//                           if (playlists.length > 2)
//                             Expanded(
//                               child: _buildPlaylistItem(
//                                 context: context,
//                                 icon: Icons.playlist_play,
//                                 label: playlists[2],
//                                 onTap: () {
//                                   ScaffoldMessenger.of(context).showSnackBar(
//                                     SnackBar(
//                                       content: Text('Tapped ${playlists[2]}'),
//                                     ),
//                                   );
//                                 },
//                                 height: 70,
//                               ),
//                             ),
//                         ],
//                       ),
//                     ],
//                   );
//                 },
//               );
//             },
//           ),
//           const SizedBox(height: 30),
//           Text(
//             'My Playlist',
//             style: Theme.of(context).textTheme.bodyLarge!.copyWith(
//               fontSize: 22,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           const SizedBox(height: 20),
//           _buildPlaylistItem(
//             context: context,
//             icon: Icons.add,
//             label: 'Create New Playlist',
//             onTap: () async {
//               final playlists = _playlistsBox.get('playlists') ?? [];
//               if (playlists.length >= 3) {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(content: Text('Maximum 3 playlists allowed')),
//                 );
//                 return;
//               }

//               final newPlaylistName = await _showCreatePlaylistDialog(context);
//               if (newPlaylistName != null && newPlaylistName.isNotEmpty) {
//                 if (!playlists.contains(newPlaylistName)) {
//                   _playlistsBox.put('playlists', [...playlists, newPlaylistName]);
//                   if (widget.currentSong != null) {
//                     final songPath = widget.currentSong!.path;
//                     final playlistSongs = _playlistSongsBox.get(newPlaylistName) ?? {newPlaylistName: []};
//                     if (!playlistSongs[newPlaylistName]!.contains(songPath)) {
//                       playlistSongs[newPlaylistName]!.add(songPath);
//                       _playlistSongsBox.put(newPlaylistName, playlistSongs);
//                       print('Added song "${widget.currentSong!.title}" to $newPlaylistName');
//                     }
//                   }
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(
//                       content: Text('Created playlist: $newPlaylistName'),
//                     ),
//                   );
//                 } else {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(content: Text('Playlist already exists')),
//                   );
//                 }
//               }
//             },
//             height: 70,
//           ),
//           const SizedBox(height: 20),
//           _buildPlaylistItem(
//             context: context,
//             icon: Icons.delete,
//             label: 'Delete Playlist',
//             onTap: () async {
//               final playlists = _playlistsBox.get('playlists') ?? [];
//               if (playlists.isEmpty) {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(content: Text('No playlists to delete')),
//                 );
//                 return;
//               }
//               showDialog(
//                 context: context,
//                 builder: (context) => DeletePlaylistDialog(
//                   playlists: playlists,
//                   onDelete: (deletedPlaylist) {
//                     if (deletedPlaylist != null) {
//                       setState(() {});
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(
//                           content: Text('Deleted playlist: $deletedPlaylist'),
//                         ),
//                       );
//                     }
//                   },
//                 ),
//               );
//             },
//             height: 70,
//           ),
//         ],
//       ),
//     );
//   }

//   Future<String?> _showCreatePlaylistDialog(BuildContext context) async {
//     String playlistName = '';
//     return showDialog<String>(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Create New Playlist'),
//         content: TextField(
//           onChanged: (value) => playlistName = value,
//           decoration: const InputDecoration(hintText: 'Enter playlist name'),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Cancel'),
//           ),
//           TextButton(
//             onPressed: () {
//               if (playlistName.isNotEmpty) {
//                 Navigator.pop(context, playlistName);
//               }
//             },
//             child: const Text('Create'),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildPlaylistItem({
//     required BuildContext context,
//     required IconData icon,
//     required String label,
//     required VoidCallback onTap,
//     double? height,
//     double? width,
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         height: height ?? 50,
//         width: width,
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//         decoration: BoxDecoration(
//           color: AppColors.grey.withOpacity(0.2),
//           borderRadius: BorderRadius.circular(8),
//         ),
//         child: Row(
//           children: [
//             Icon(
//               icon,
//               color: Theme.of(context).textTheme.bodyLarge!.color,
//               size: 24,
//             ),
//             const SizedBox(width: 16),
//             Expanded(
//               child: Text(
//                 label,
//                 style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 18),
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
import 'package:musicvoxaplay/screens/favourites/favourites.dart';
import 'package:musicvoxaplay/screens/recently played/audio_recently.dart';
import 'package:musicvoxaplay/screens/widgets/colors.dart';
import 'package:musicvoxaplay/screens/most played/audio_mostplayed.dart';
import 'package:musicvoxaplay/screens/models/song_models.dart';
import 'package:musicvoxaplay/screens/playlist/delete_playlist.dart';
import 'package:musicvoxaplay/screens/playlist/playlist_detail_page.dart'; // New import

class AudioContent extends StatefulWidget {
  final Song? currentSong;

  const AudioContent({super.key, this.currentSong});

  @override
  _AudioContentState createState() => _AudioContentState();
}

class _AudioContentState extends State<AudioContent> {
  final Box<List<String>> _playlistsBox = Hive.box<List<String>>('playlistsBox');
  final Box<Map<String, List<String>>> _playlistSongsBox = Hive.box<Map<String, List<String>>>('playlistSongsBox');

  @override
  void initState() {
    super.initState();
    if (_playlistsBox.isEmpty || !_playlistsBox.containsKey('playlists')) {
      _playlistsBox.put('playlists', []);
      print('Initialized playlistsBox with empty playlists list.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ValueListenableBuilder(
            valueListenable: _playlistsBox.listenable(),
            builder: (context, Box<List<String>> box, child) {
              final playlists = box.get('playlists') ?? [];

              return LayoutBuilder(
                builder: (context, constraints) {
                  final buttonWidth = (constraints.maxWidth - 10) / 2;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Row 1: Favourites and Recently Played
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: _buildPlaylistItem(
                              context: context,
                              icon: Icons.favorite,
                              label: 'Favourites',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const Favourites(),
                                  ),
                                );
                              },
                              height: 70,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _buildPlaylistItem(
                              context: context,
                              icon: Icons.history,
                              label: 'Recently Played',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const RecentlyPlayedPage(),
                                  ),
                                );
                              },
                              height: 70,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      // Row 2: First two playlists (if any)
                      if (playlists.isNotEmpty)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: _buildPlaylistItem(
                                context: context,
                                icon: Icons.playlist_play,
                                label: playlists[0],
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => PlaylistDetailPage(playlistName: playlists[0]),
                                    ),
                                  );
                                },
                                height: 70,
                              ),
                            ),
                            if (playlists.length > 1) const SizedBox(width: 10),
                            if (playlists.length > 1)
                              Expanded(
                                child: _buildPlaylistItem(
                                  context: context,
                                  icon: Icons.playlist_play,
                                  label: playlists[1],
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => PlaylistDetailPage(playlistName: playlists[1]),
                                      ),
                                    );
                                  },
                                  height: 70,
                                ),
                              ),
                          ],
                        ),
                      const SizedBox(height: 20),
                      // Row 3: Most Played and third playlist (if any)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: buttonWidth,
                            child: _buildPlaylistItem(
                              context: context,
                              icon: Icons.play_circle,
                              label: 'Most Played',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const MostPlayed(),
                                  ),
                                );
                              },
                              height: 70,
                            ),
                          ),
                          const SizedBox(width: 10),
                          if (playlists.length > 2)
                            Expanded(
                              child: _buildPlaylistItem(
                                context: context,
                                icon: Icons.playlist_play,
                                label: playlists[2],
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => PlaylistDetailPage(playlistName: playlists[2]),
                                    ),
                                  );
                                },
                                height: 70,
                              ),
                            ),
                        ],
                      ),
                    ],
                  );
                },
              );
            },
          ),
          const SizedBox(height: 30),
          Text(
            'My Playlist',
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          _buildPlaylistItem(
            context: context,
            icon: Icons.add,
            label: 'Create New Playlist',
            onTap: () async {
              final playlists = _playlistsBox.get('playlists') ?? [];
              if (playlists.length >= 3) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Maximum 3 playlists allowed')),
                );
                return;
              }

              final newPlaylistName = await _showCreatePlaylistDialog(context);
              if (newPlaylistName != null && newPlaylistName.isNotEmpty) {
                if (!playlists.contains(newPlaylistName)) {
                  _playlistsBox.put('playlists', [...playlists, newPlaylistName]);
                  if (widget.currentSong != null) {
                    final songPath = widget.currentSong!.path;
                    final playlistSongs = _playlistSongsBox.get(newPlaylistName) ?? {newPlaylistName: []};
                    if (!playlistSongs[newPlaylistName]!.contains(songPath)) {
                      playlistSongs[newPlaylistName]!.add(songPath);
                      _playlistSongsBox.put(newPlaylistName, playlistSongs);
                      print('Added song "${widget.currentSong!.title}" to $newPlaylistName');
                    }
                  }
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Created playlist: $newPlaylistName'),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Playlist already exists')),
                  );
                }
              }
            },
            height: 70,
          ),
          const SizedBox(height: 20),
          _buildPlaylistItem(
            context: context,
            icon: Icons.delete,
            label: 'Delete Playlist',
            onTap: () async {
              final playlists = _playlistsBox.get('playlists') ?? [];
              if (playlists.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('No playlists to delete')),
                );
                return;
              }
              showDialog(
                context: context,
                builder: (context) => DeletePlaylistDialog(
                  playlists: playlists,
                  onDelete: (deletedPlaylist) {
                    if (deletedPlaylist != null) {
                      setState(() {});
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Deleted playlist: $deletedPlaylist'),
                        ),
                      );
                    }
                  },
                ),
              );
            },
            height: 70,
          ),
        ],
      ),
    );
  }

  Future<String?> _showCreatePlaylistDialog(BuildContext context) async {
    String playlistName = '';
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create New Playlist'),
        content: TextField(
          onChanged: (value) => playlistName = value,
          decoration: const InputDecoration(hintText: 'Enter playlist name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (playlistName.isNotEmpty) {
                Navigator.pop(context, playlistName);
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaylistItem({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    double? height,
    double? width,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height ?? 50,
        width: width,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.grey.withOpacity(0.2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: Theme.of(context).textTheme.bodyLarge!.color,
              size: 24,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}