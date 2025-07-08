import 'package:flutter/material.dart';
import 'package:musicvoxaplay/screens/models/song_models.dart';
import 'package:musicvoxaplay/screens/widgets/bottom_navigationbar.dart';
import 'package:musicvoxaplay/screens/services/song_service.dart';
import 'package:musicvoxaplay/screens/widgets/appbar.dart';
import 'package:musicvoxaplay/screens/audio/audio_fullscreen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:musicvoxaplay/screens/widgets/colors.dart';
import 'package:musicvoxaplay/screens/audio/audio_playermanager.dart';
import 'package:musicvoxaplay/screens/song%20menu/song_menubar.dart';
import 'package:just_audio/just_audio.dart';
import 'package:musicvoxaplay/screens/song menu/playnext_service.dart';




class AudioPage extends StatefulWidget {
  const AudioPage({super.key});

  @override
  _AudioPageState createState() => _AudioPageState();
}

class _AudioPageState extends State<AudioPage> {
  late Future<List<Song>> _songsFuture;
  int _currentIndex = 0;
  final SongService _songService = SongService();
  Song? _currentlyPlayingSong;
  bool _isPlaying = false;
  final AudioPlayer _audioPlayer = AudioPlayerManager().player;
  late final PlayNextService _playNextService;

  @override
  void initState() {
    super.initState();
    _songsFuture = _songService.fetchSongsFromDevice();
    _playNextService = PlayNextService(songService: _songService, audioPlayer: _audioPlayer);
    _setupAudioPlayerListeners();
  }

  void _setupAudioPlayerListeners() {
    _audioPlayer.playingStream.listen((playing) {
      if (mounted) {
        setState(() {
          _isPlaying = playing;
        });
      }
    });
_audioPlayer.currentIndexStream.listen((index) async {
  if (index != null && mounted) {
    final songs = AudioPlayerManager().songs;
    if (index < songs.length) {
      setState(() {
        _currentlyPlayingSong = songs[index];
      });
      await _songService.incrementPlayCount(songs[index]);
    }
  }
});
  }

  void _onTabTapped(int index) {
    if (index == _currentIndex) return;
    setState(() {
      _currentIndex = index;
    });
    if (index != 0) {
      _audioPlayer.pause();
    }
  }

  Future<void> _togglePlayPause() async {
    try {
      if (_isPlaying) {
        await _audioPlayer.pause();
      } else {
        await _audioPlayer.play();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error toggling playback: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: buildAppBar(context, 'All audios'),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: FutureBuilder<List<Song>>(
                  future: _songsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
 
                     return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Error loading songs',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _songsFuture = _songService.fetchSongsFromDevice();
                                });
                              },
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      );
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'No valid songs found',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () async {
                                await Permission.audio.request();
                                setState(() {
                                  _songsFuture = _songService.fetchSongsFromDevice();
                                });
                              },
                              child: const Text('Try again'),
                            ),
                          ],
                        ),
                      );
                    }

                    final songs = snapshot.data!;
                    return ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: songs.length,
                      itemBuilder: (context, index) {
                        final song = songs[index];
                        final isPlayable = song.path.isNotEmpty;
                        final isCurrentSong = _currentlyPlayingSong?.path == song.path;

                        return Container(
                          color: isCurrentSong ? AppColors.red.withOpacity(0.3) : Colors.transparent,
                          child: ListTile(
                            leading: song.artwork != null
                                ? Image.memory(
                                    song.artwork!,
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                  )
                                : const Icon(
                                    Icons.music_note,
                                    size: 50,
                                    color: AppColors.grey,
                                  ),
                            title: Text(
                              song.title,
                              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                    color: isPlayable ? Theme.of(context).textTheme.bodyLarge!.color : AppColors.grey,
                                  ),
                            ),
                            subtitle: Text(
                              song.artist,
                              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    color: isPlayable ? Theme.of(context).textTheme.bodyMedium!.color : AppColors.grey,
                                  ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.more_horiz,
                                    color: AppColors.grey,
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => SongMenuPage(
                                          song: song,
                                           // Added playlist parameter
                                          audioPlayer: _audioPlayer,
                                          songService: _songService,
                                          playNextService: _playNextService,
                                        ),
                                      ),
                                    ).then((_) {
                                      // Refresh songs list after returning from SongMenuPage
                                      setState(() {
                                        _songsFuture = _songService.fetchSongsFromDevice();
                                      });
                                    });
                                  },
                                ),
                              ],
                            ),
                            onTap: isPlayable
                                ? () async {
                                    try {
                                      await AudioPlayerManager().setPlaylist(
                                        songs,
                                        initialIndex: index,
                                      );
                                      await _audioPlayer.play();
                                      setState(() {
                                        _currentlyPlayingSong = song;
                                        _isPlaying = true;
                                      });
                                      await _songService.incrementPlayCount(song);
                                      await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => AudioFullScreen(
                                            song: song,
                                            songs: songs,
                                          ),
                                        ),
                                      );
                                    } catch (e) {
                                      if (mounted) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Error playing song: $e')),
                                        );
                                      }
                                    }
                                  }
                                : null,
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
            if (_currentlyPlayingSong != null)
              GestureDetector(
                onTap: () async {
                  final songs = await _songsFuture;
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AudioFullScreen(
                        song: _currentlyPlayingSong!,
                        songs: songs,
                      ),
                    ),
                  );
                },
                child: Container(
                  height: 70,
                  color: AppColors.darkGrey,
                  child: ListTile(
                    leading: _currentlyPlayingSong!.artwork != null
                        ? Image.memory(
                            _currentlyPlayingSong!.artwork!,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          )
                        : const Icon(
                            Icons.music_note,
                            size: 40,
                            color: AppColors.white,
                          ),
                    title: Text(
                      _currentlyPlayingSong!.title,
                      style: Theme.of(context).textTheme.bodyLarge,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      _currentlyPlayingSong!.artist,
                      style: Theme.of(context).textTheme.bodyMedium,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(
                            _isPlaying ? Icons.pause : Icons.play_arrow,
                            color: AppColors.white,
                          ),
                          onPressed: _togglePlayPause,
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: AppColors.white),
                          onPressed: () {
                            _audioPlayer.stop();
                            setState(() {
                              _currentlyPlayingSong = null;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: buildBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        context: context,
      ),
    );
  }

  @override
  void dispose() {
    _audioPlayer.playingStream.drain();
    _audioPlayer.currentIndexStream.drain();
    super.dispose();
  }
}