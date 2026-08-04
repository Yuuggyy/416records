import 'package:equatable/equatable.dart';

class EpisodeModel extends Equatable {
  final String id;
  final String title;
  final String description;
  final String videoUrl;
  final String thumbnailUrl;
  final int episodeNumber;
  final DateTime releaseDate;
  final bool isLocked;
  final int durationMinutes;
  final List<String> artistIds;

  const EpisodeModel({
    required this.id,
    required this.title,
    required this.description,
    required this.videoUrl,
    required this.thumbnailUrl,
    required this.episodeNumber,
    required this.releaseDate,
    this.isLocked = false,
    this.durationMinutes = 30,
    this.artistIds = const [],
  });

  factory EpisodeModel.fromJson(Map<String, dynamic> json) {
    return EpisodeModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      videoUrl: json['videoUrl'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String,
      episodeNumber: json['episodeNumber'] as int,
      releaseDate: DateTime.parse(json['releaseDate'] as String),
      isLocked: json['isLocked'] as bool? ?? false,
      durationMinutes: json['durationMinutes'] as int? ?? 30,
      artistIds: (json['artistIds'] as List?)?.cast<String>() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'videoUrl': videoUrl,
      'thumbnailUrl': thumbnailUrl,
      'episodeNumber': episodeNumber,
      'releaseDate': releaseDate.toIso8601String(),
      'isLocked': isLocked,
      'durationMinutes': durationMinutes,
      'artistIds': artistIds,
    };
  }

  @override
  List<Object?> get props =>
      [id, title, description, videoUrl, thumbnailUrl, episodeNumber, releaseDate, isLocked, durationMinutes, artistIds];
}

class ArtistModel extends Equatable {
  final String id;
  final String name;
  final String stageName;
  final String photoUrl;
  final String bio;
  final String genre;
  final int votes;
  final int episodesParticipated;
  final bool isEliminated;

  const ArtistModel({
    required this.id,
    required this.name,
    required this.stageName,
    required this.photoUrl,
    required this.bio,
    required this.genre,
    this.votes = 0,
    this.episodesParticipated = 0,
    this.isEliminated = false,
  });

  factory ArtistModel.fromJson(Map<String, dynamic> json) {
    return ArtistModel(
      id: json['id'] as String,
      name: json['name'] as String,
      stageName: json['stageName'] as String,
      photoUrl: json['photoUrl'] as String,
      bio: json['bio'] as String,
      genre: json['genre'] as String,
      votes: json['votes'] as int? ?? 0,
      episodesParticipated: json['episodesParticipated'] as int? ?? 0,
      isEliminated: json['isEliminated'] as bool? ?? false,
    );
  }

  @override
  List<Object?> get props => [id, name, stageName, photoUrl, votes, isEliminated];
}

class VideoClipModel extends Equatable {
  final String id;
  final String title;
  final String videoUrl;
  final String thumbnailUrl;
  final String artistId;
  final String artistName;
  final int durationSeconds;
  final ClipType type;
  final bool requiresReward;
  final int views;

  const VideoClipModel({
    required this.id,
    required this.title,
    required this.videoUrl,
    required this.thumbnailUrl,
    required this.artistId,
    required this.artistName,
    this.durationSeconds = 120,
    this.type = ClipType.performance,
    this.requiresReward = false,
    this.views = 0,
  });

  @override
  List<Object?> get props => [id, title, videoUrl, thumbnailUrl, artistId, type, requiresReward];
}

enum ClipType {
  performance,
  behindScenes,
  interview,
  excerpt,
  fullEpisode,
}
