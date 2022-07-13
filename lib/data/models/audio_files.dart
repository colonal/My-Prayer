import 'dart:convert';

class AudioFiles {
  final int id;
  final int chapterId;
  final int fileSize;
  final String audioUrl;
  AudioFiles({
    required this.id,
    required this.chapterId,
    required this.fileSize,
    required this.audioUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'chapterId': chapterId,
      'fileSize': fileSize,
      'audioUrl': audioUrl,
    };
  }

  factory AudioFiles.fromMap(Map<String, dynamic> map) {
    return AudioFiles(
      id: map['id']?.toInt() ?? 0,
      chapterId: map['chapter_id']?.toInt() ?? 0,
      fileSize: map['file_size']?.toInt() ?? 0,
      audioUrl: map['audio_url'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory AudioFiles.fromJson(String source) =>
      AudioFiles.fromMap(json.decode(source));
}
