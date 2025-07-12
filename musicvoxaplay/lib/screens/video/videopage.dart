import 'package:flutter/material.dart';
import 'package:musicvoxaplay/screens/models/video_models.dart';
import 'package:musicvoxaplay/screens/services/video_service.dart';

class VideoPage extends StatefulWidget {
  @override
  _VideoPageState createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  List<Video> _videos = [];
  bool _isLoading = false;

  Future<void> _loadVideos() async {
    setState(() => _isLoading = true);
    try {
      final videos = await VideoService.fetchLocalVideos();
      setState(() => _videos = videos);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My Videos')),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _videos.isEmpty
              ? Center(
                  child: ElevatedButton(
                    child: Text('Load Videos'),
                    onPressed: _loadVideos,
                  ),
                )
              : ListView.builder(
                  itemCount: _videos.length,
                  itemBuilder: (context, index) {
                    final video = _videos[index];
                    return ListTile(
                      leading: Icon(Icons.video_library),
                      title: Text(video.title),
                      subtitle: Text(video.path),
                      trailing: Text(video.duration),
                      onTap: () {
                        // Add video playback later
                        print('Playing: ${video.path}');
                      },
                    );
                  },
                ),
    );
  }
}