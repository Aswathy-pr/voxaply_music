import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as p;
import 'package:musicvoxaplay/screens/models/video_models.dart'; // Ensure this import exists

class VideoService {
  static Future<List<Video>> fetchLocalVideos() async { // Must match exact name
    final result = await FilePicker.platform.pickFiles(
      type: FileType.video,
      allowMultiple: true,
    );
    if (result == null) return [];
    
    return result.files.map((file) => Video(
      title: p.basenameWithoutExtension(file.name),
      path: file.path!,
      duration: '00:00',
    )).toList();
  }
}