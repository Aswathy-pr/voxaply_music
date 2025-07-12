// import 'package:flutter/material.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:musicvoxaplay/screens/favourites/favourites.dart';
// import 'package:musicvoxaplay/screens/recently played/audio_recently.dart';
// import 'package:musicvoxaplay/screens/widgets/colors.dart';
// import 'package:musicvoxaplay/screens/most played/audio_mostplayed.dart';
// import 'package:musicvoxaplay/screens/models/song_models.dart';
// import 'package:musicvoxaplay/screens/playlist/delete_playlist.dart';
// import 'package:musicvoxaplay/screens/playlist/playlist_detail_page.dart';

// class AudioContent extends StatefulWidget {
//   final Song? currentSong;

//   const AudioContent({super.key, this.currentSong});

//   @override
//   _AudioContentState createState() => _AudioContentState();
// }

// class _AudioContentState extends State<AudioContent> {
//   final Box<List<String>> _playlistsBox = Hive.box<List<String>>(
//     'playlistsBox',
//   );
//   late Box<Map<String, List<String>>> _playlistSongsBox;

//   @override
//   void initState() {
//     super.initState();
//     if (Hive.isBoxOpen('playlistSongsBox')) {
//       _playlistSongsBox = Hive.box<Map<String, List<String>>>(
//         'playlistSongsBox',
//       );
//     } else {
//       print('Warning: playlistSongsBox not open, opening now...');
//       Hive.openBox<Map<String, List<String>>>('playlistSongsBox').then((box) {
//         _playlistSongsBox = box;
//         setState(() {});
//       });
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
//                                     builder: (context) =>
//                                         const RecentlyPlayedPage(),
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
//                                   Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                       builder: (context) => PlaylistDetailPage(
//                                         playlistName: playlists[0],
//                                         playlistSongsBox: _playlistSongsBox,
//                                       ),
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
//                                     Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                         builder: (context) =>
//                                             PlaylistDetailPage(
//                                               playlistName: playlists[1],
//                                               playlistSongsBox:
//                                                   _playlistSongsBox,
//                                             ),
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
//                                   Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                       builder: (context) => PlaylistDetailPage(
//                                         playlistName: playlists[1],
//                                         playlistSongsBox: _playlistSongsBox,
//                                       ),
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
//                   await _playlistsBox.put('playlists', [
//                     ...playlists,
//                     newPlaylistName,
//                   ]);
//                   if (widget.currentSong != null &&
//                       Hive.isBoxOpen('playlistSongsBox')) {
//                     final songPath = widget.currentSong!.path;
//                     final playlistSongs =
//                         _playlistSongsBox.get(newPlaylistName) ??
//                         {newPlaylistName: []};
//                     if (!playlistSongs[newPlaylistName]!.contains(songPath)) {
//                       playlistSongs[newPlaylistName]!.add(songPath);
//                       await _playlistSongsBox.put(
//                         newPlaylistName,
//                         playlistSongs,
//                       );
//                       print(
//                         'Added song "${widget.currentSong!.title}" to $newPlaylistName',
//                       );
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
//                 style: Theme.of(
//                   context,
//                 ).textTheme.bodyLarge!.copyWith(fontSize: 18),
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
import 'package:musicvoxaplay/screens/recently%20played/audio_recently.dart';
import 'package:musicvoxaplay/screens/widgets/colors.dart';
import 'package:musicvoxaplay/screens/most%20played/audio_mostplayed.dart';
import 'package:musicvoxaplay/screens/models/song_models.dart';
import 'package:musicvoxaplay/screens/playlist/delete_playlist.dart';
import 'package:musicvoxaplay/screens/playlist/playlist_detail_page.dart';

class AudioContent extends StatefulWidget {
  final Song? currentSong;
  const AudioContent({super.key, this.currentSong});

  @override
  State<AudioContent> createState() => _AudioContentState();
}

class _AudioContentState extends State<AudioContent> {
  late final Box<List<String>> _playlistsBox;
  late final Box<Map<String, dynamic>> _playlistSongsBox;
  bool _isInitializing = true;

  @override
  void initState() {
    super.initState();
    _initializeHiveBoxes();
  }

  Future<void> _initializeHiveBoxes() async {
    try {
      _playlistsBox = await Hive.openBox<List<String>>('playlistsBox');
      _playlistSongsBox = await Hive.openBox<Map<String, dynamic>>('playlistSongsBox');
      await _migrateOldPlaylistFormat();
    } catch (e) {
      debugPrint('Error initializing Hive boxes: $e');
    } finally {
      if (mounted) {
        setState(() => _isInitializing = false);
      }
    }
  }

  Future<void> _migrateOldPlaylistFormat() async {
    final keys = _playlistSongsBox.keys.toList();
    for (final key in keys) {
      final data = _playlistSongsBox.get(key);
      if (data is Map<String, List<String>>) {
        await _playlistSongsBox.put(key, {
          'songs': data[key] ?? [],
          'createdAt': DateTime.now().toString(),
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isInitializing) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ValueListenableBuilder(
                valueListenable: _playlistsBox.listenable(),
                builder: (context, Box<List<String>> box, _) {
                  final playlists = box.get('playlists', defaultValue: [])!;
                  return LayoutBuilder(
                    builder: (context, constraints) {
                      final halfWidth = constraints.maxWidth / 2 - 8;
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // First Row
                          _buildPlaylistRow(
                            context: context,
                            constraints: constraints,
                            children: [
                              _buildPlaylistButton(
                                context: context,
                                icon: Icons.favorite,
                                label: 'Favourites',
                                onTap: () => _navigateTo(const Favourites()),
                                width: halfWidth,
                              ),
                              _buildPlaylistButton(
                                context: context,
                                icon: Icons.history,
                                label: 'Recently Played',
                                onTap: () => _navigateTo(const RecentlyPlayedPage()),
                                width: halfWidth,
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          
                          // Playlist Rows
                          if (playlists.isNotEmpty) ...[
                            _buildPlaylistRow(
                              context: context,
                              constraints: constraints,
                              children: [
                                _buildPlaylistButton(
                                  context: context,
                                  icon: Icons.playlist_play,
                                  label: playlists[0],
                                  onTap: () => _navigateToPlaylist(playlists[0]),
                                  width: playlists.length > 1 ? halfWidth : constraints.maxWidth,
                                ),
                                if (playlists.length > 1)
                                  _buildPlaylistButton(
                                    context: context,
                                    icon: Icons.playlist_play,
                                    label: playlists[1],
                                    onTap: () => _navigateToPlaylist(playlists[1]),
                                    width: halfWidth,
                                  ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            _buildPlaylistRow(
                              context: context,
                              constraints: constraints,
                              children: [
                                _buildPlaylistButton(
                                  context: context,
                                  icon: Icons.play_circle,
                                  label: 'Most Played',
                                  onTap: () => _navigateTo(const MostPlayed()),
                                  width: playlists.length > 2 ? halfWidth : constraints.maxWidth,
                                ),
                                if (playlists.length > 2)
                                  _buildPlaylistButton(
                                    context: context,
                                    icon: Icons.playlist_play,
                                    label: playlists[2],
                                    onTap: () => _navigateToPlaylist(playlists[2]),
                                    width: halfWidth,
                                  ),
                              ],
                            ),
                          ],
                          
                          // My Playlist Section
                          const SizedBox(height: 30),
                          Text(
                            'My Playlist',
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20),
                          _buildPlaylistButton(
                            context: context,
                            icon: Icons.add,
                            label: 'Create New Playlist',
                            onTap: _handleCreatePlaylist,
                          ),
                          const SizedBox(height: 20),
                          _buildPlaylistButton(
                            context: context,
                            icon: Icons.delete,
                            label: 'Delete Playlist',
                            onTap: _handleDeletePlaylist,
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlaylistRow({
    required BuildContext context,
    required BoxConstraints constraints,
    required List<Widget> children,
  }) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: constraints.maxWidth),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: children,
      ),
    );
  }

  Widget _buildPlaylistButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    double? width,
  }) {
    return SizedBox(
      width: width,
      height: 70,
      child: Card(
        color: AppColors.grey.withOpacity(0.2),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Icon(icon, size: 24, color: Theme.of(context).iconTheme.color),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    label,
                    style: Theme.of(context).textTheme.bodyLarge,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _navigateTo(Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  void _navigateToPlaylist(String playlistName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PlaylistDetailPage(
          playlistName: playlistName,
          playlistSongsBox: _playlistSongsBox,
        ),
      ),
    );
  }

  Future<void> _handleCreatePlaylist() async {
    try {
      final playlists = _playlistsBox.get('playlists', defaultValue: [])!;
      if (playlists.length >= 3) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Maximum 3 playlists allowed')),
        );
        return;
      }

      final newPlaylistName = await _showCreatePlaylistDialog();
      if (newPlaylistName == null || newPlaylistName.isEmpty) return;

      if (playlists.contains(newPlaylistName)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Playlist already exists')),
        );
        return;
      }

      await _playlistsBox.put('playlists', [...playlists, newPlaylistName]);
      
      if (widget.currentSong != null) {
        await _playlistSongsBox.put(newPlaylistName, {
          'songs': [widget.currentSong!.path],
          'createdAt': DateTime.now().toString(),
        });
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Created playlist: $newPlaylistName')),
        );
      }
    } catch (e) {
      debugPrint('Error creating playlist: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to create playlist')),
        );
      }
    }
  }

  Future<void> _handleDeletePlaylist() async {
    try {
      final playlists = _playlistsBox.get('playlists', defaultValue: [])!;
      if (playlists.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No playlists to delete')),
        );
        return;
      }

      final deletedPlaylist = await showDialog<String>(
  context: context,
  builder: (context) => DeletePlaylistDialog(
    playlists: playlists,
    onDelete: (deletedName) async {
      if (deletedName != null && mounted) {
        await _playlistSongsBox.delete(deletedName);
        await _playlistsBox.put('playlists', 
          playlists.where((name) => name != deletedName).toList());
        return true;
      }
      return false;
    },
  ),
);

      if (deletedPlaylist != null && mounted) {
        await _playlistSongsBox.delete(deletedPlaylist);
        await _playlistsBox.put('playlists', 
          playlists.where((name) => name != deletedPlaylist).toList());
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Deleted playlist: $deletedPlaylist')),
        );
        setState(() {});
      }
    } catch (e) {
      debugPrint('Error deleting playlist: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to delete playlist')),
        );
      }
    }
  }

  Future<String?> _showCreatePlaylistDialog() async {
    String playlistName = '';
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create New Playlist'),
        content: TextField(
          autofocus: true,
          onChanged: (value) => playlistName = value,
          decoration: const InputDecoration(
            hintText: 'Enter playlist name',
            border: OutlineInputBorder(),
          ),
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

  @override
  void dispose() {
    _playlistsBox.close();
    _playlistSongsBox.close();
    super.dispose();
  }
}