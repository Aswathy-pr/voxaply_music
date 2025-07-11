import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:musicvoxaplay/screens/models/song_models.dart';
import 'package:musicvoxaplay/screens/search.dart';

class PlaylistPage extends StatefulWidget {
  final String playlistName;

  const PlaylistPage({super.key, required this.playlistName});

  @override
  _PlaylistPageState createState() => _PlaylistPageState();
}

class _PlaylistPageState extends State<PlaylistPage> {
  final TextEditingController _searchController = TextEditingController();
  final Box<Map<String, List<String>>> _playlistSongsBox =
      Hive.box<Map<String, List<String>>>('playlistSongsBox');
  List<String> _songPaths = [];
  List<String> _selectedSongs = [];

  @override
  void initState() {
    super.initState();
    _loadSongs();
  }

  void _loadSongs() {
    final playlistSongs = _playlistSongsBox.get(widget.playlistName) ?? {};
    _songPaths = playlistSongs[widget.playlistName] ?? [];
    setState(() {});
  }

  void _onSearchChanged(String query) {
    setState(() {
      _songPaths =
          (_playlistSongsBox.get(widget.playlistName)?[widget.playlistName] ??
                  [])
              .where((path) => path.toLowerCase().contains(query.toLowerCase()))
              .toList();
    });
  }

  Future<void> _addSongs() async {
    final selectedSongs = await Navigator.push<List<Song>>(
      context,
      MaterialPageRoute(builder: (context) => const Searchpage()),
    );

    if (selectedSongs != null && selectedSongs.isNotEmpty) {
      setState(() {
        final currentSongs =
            _playlistSongsBox.get(widget.playlistName) ??
            {widget.playlistName: []};
        final updatedSongs = currentSongs[widget.playlistName] ?? [];
        for (var song in selectedSongs) {
          if (!updatedSongs.contains(song.path)) {
            updatedSongs.add(song.path);
          }
        }
        currentSongs[widget.playlistName] = updatedSongs;
        _playlistSongsBox.put(widget.playlistName, currentSongs);
        _loadSongs();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Added ${selectedSongs.length} songs to ${widget.playlistName}',
            ),
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.playlistName),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addSongs,
            tooltip: 'Add Songs',
          ),
          if (_selectedSongs.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Saved ${_selectedSongs.length} songs to ${widget.playlistName}',
                    ),
                  ),
                );
                setState(() {
                  _selectedSongs.clear();
                });
              },
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search songs...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onChanged: _onSearchChanged,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _songPaths.length,
                itemBuilder: (context, index) {
                  final path = _songPaths[index];
                  return CheckboxListTile(
                    title: Text(
                      path.split('/').last,
                      style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                    ),
                    value: _selectedSongs.contains(path),
                    onChanged: (bool? value) {
                      setState(() {
                        if (value == true) {
                          _selectedSongs.add(path);
                        } else {
                          _selectedSongs.remove(path);
                        }
                      });
                    },
                    controlAffinity: ListTileControlAffinity.leading,
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
