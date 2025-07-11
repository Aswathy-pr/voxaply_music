import 'package:flutter/material.dart';
import 'package:musicvoxaplay/screens/widgets/appbar.dart'; // Verify this file exists
import 'package:musicvoxaplay/screens/widgets/colors.dart';

class PlaylistDetailPage extends StatelessWidget {
  final String playlistName;

  const PlaylistDetailPage({super.key, required this.playlistName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
     appBar: buildAppBar(context, 'new playlist' , showBackButton: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Songs in Playlist',
              style: TextStyle(
                color: AppColors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            // Card-like container for song list placeholder
            
            const Spacer(),
            // Elevated button for Add New Songs
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Add New Songs functionality to be implemented')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.red,
                foregroundColor: AppColors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.add, size: 24),
                  SizedBox(width: 8),
                  Text(
                    'Add New Songs',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16), // Added for bottom padding
          ],
        ),
      ),
    );
  }
}