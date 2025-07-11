import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:musicvoxaplay/screens/models/song_models.dart';
import 'package:musicvoxaplay/screens/widgets/appbar.dart';
import 'package:musicvoxaplay/screens/widgets/colors.dart';

class AddSongsPage extends StatelessWidget {
  final String playlistName;
  final Box<Map<String, List<String>>> playlistSongsBox;

  const AddSongsPage({super.key, required this.playlistName, required this.playlistSongsBox});

  @override
  Widget build(BuildContext context) {
    final Box<Song> songsBox = Hive.box<Song>('songsBox');

    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: buildAppBar(context, 'Add Songs to $playlistName', showBackButton: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'All Songs',
              style: TextStyle(
                color: AppColors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: songsBox.length,
                itemBuilder: (context, index) {
                  final song = songsBox.getAt(index);
                  if (song == null) return const SizedBox.shrink();
                  final isInPlaylist = (playlistSongsBox.get(playlistName)?[playlistName] ?? []).contains(song.path);

                  return ListTile(
                    title: Text(
                      song.title,
                      style: const TextStyle(color: AppColors.white, fontSize: 16),
                    ),
                    subtitle: Text(
                      song.artist,
                      style: const TextStyle(color: AppColors.grey, fontSize: 14),
                    ),
                    trailing: isInPlaylist
                        ? const Icon(Icons.check, color: AppColors.black)
                        : null,
                    onTap: isInPlaylist
                        ? null
                        : () {
                            final currentSongs = playlistSongsBox.get(playlistName)?[playlistName] ?? [];
                            if (!currentSongs.contains(song.path)) {
                              currentSongs.add(song.path);
                              playlistSongsBox.put(playlistName, {playlistName: currentSongs});
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Added "${song.title}" to $playlistName')),
                              );
                              Navigator.pop(context);
                            }
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