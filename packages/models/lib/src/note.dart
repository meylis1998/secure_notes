import 'package:hive/hive.dart';

part 'note.g.dart';

@HiveType(typeId: 1)
class Note {
  @HiveField(0)
  final String url;

  @HiveField(1)
  final String forksUrl;

  @HiveField(2)
  final String commitsUrl;

  @HiveField(3)
  final String id;

  @HiveField(4)
  final String nodeId;

  @HiveField(5)
  final String gitPullUrl;

  @HiveField(6)
  final String gitPushUrl;

  @HiveField(7)
  final String htmlUrl;

  @HiveField(8)
  final Map<String, NoteFile> files;

  @HiveField(9)
  final bool isPublic;

  @HiveField(10)
  final DateTime createdAt;

  @HiveField(11)
  final DateTime updatedAt;

  @HiveField(12)
  final String description;

  @HiveField(13)
  final int comments;

  @HiveField(14)
  final dynamic user;

  @HiveField(15)
  final bool commentsEnabled;

  @HiveField(16)
  final String commentsUrl;

  @HiveField(17)
  final Owner owner;

  @HiveField(18)
  final bool truncated;

  const Note({
    required this.url,
    required this.forksUrl,
    required this.commitsUrl,
    required this.id,
    required this.nodeId,
    required this.gitPullUrl,
    required this.gitPushUrl,
    required this.htmlUrl,
    required this.files,
    required this.isPublic,
    required this.createdAt,
    required this.updatedAt,
    required this.description,
    required this.comments,
    this.user,
    required this.commentsEnabled,
    required this.commentsUrl,
    required this.owner,
    required this.truncated,
  });

  static List<Note> listFromJson(list) =>
      List<Note>.from(list.map((x) => Note.fromJson(x)));

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      url: json['url'] as String,
      forksUrl: json['forks_url'] as String,
      commitsUrl: json['commits_url'] as String,
      id: json['id'] as String,
      nodeId: json['node_id'] as String,
      gitPullUrl: json['git_pull_url'] as String,
      gitPushUrl: json['git_push_url'] as String,
      htmlUrl: json['html_url'] as String,
      files: (json['files'] as Map<String, dynamic>).map(
        (key, value) =>
            MapEntry(key, NoteFile.fromJson(value as Map<String, dynamic>)),
      ),
      isPublic: json['public'] as bool,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      description: json['description'] as String,
      comments: json['comments'] as int,
      user: json['user'],
      commentsEnabled: json['comments_enabled'] as bool,
      commentsUrl: json['comments_url'] as String,
      owner: Owner.fromJson(json['owner'] as Map<String, dynamic>),
      truncated: json['truncated'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'forks_url': forksUrl,
      'commits_url': commitsUrl,
      'id': id,
      'node_id': nodeId,
      'git_pull_url': gitPullUrl,
      'git_push_url': gitPushUrl,
      'html_url': htmlUrl,
      'files': files.map((key, file) => MapEntry(key, file.toJson())),
      'public': isPublic,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'description': description,
      'comments': comments,
      'user': user,
      'comments_enabled': commentsEnabled,
      'comments_url': commentsUrl,
      'owner': owner.toJson(),
      'truncated': truncated,
    };
  }
}

@HiveType(typeId: 2)
class NoteFile {
  @HiveField(0)
  final String filename;

  @HiveField(1)
  final String type;

  @HiveField(2)
  final String? language;

  @HiveField(3)
  final String rawUrl;

  @HiveField(4)
  final int size;

  const NoteFile({
    required this.filename,
    required this.type,
    this.language,
    required this.rawUrl,
    required this.size,
  });

  factory NoteFile.fromJson(Map<String, dynamic> json) {
    return NoteFile(
      filename: json['filename'] as String,
      type: json['type'] as String,
      language: json['language'] as String?,
      rawUrl: json['raw_url'] as String,
      size: json['size'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'filename': filename,
      'type': type,
      'language': language,
      'raw_url': rawUrl,
      'size': size,
    };
  }
}

@HiveType(typeId: 3)
class Owner {
  @HiveField(0)
  final String login;

  @HiveField(1)
  final int id;

  @HiveField(2)
  final String nodeId;

  @HiveField(3)
  final String avatarUrl;

  @HiveField(4)
  final String gravatarId;

  @HiveField(5)
  final String url;

  @HiveField(6)
  final String htmlUrl;

  @HiveField(7)
  final String followersUrl;

  @HiveField(8)
  final String followingUrl;

  @HiveField(9)
  final String gistsUrl;

  @HiveField(10)
  final String starredUrl;

  @HiveField(11)
  final String subscriptionsUrl;

  @HiveField(12)
  final String organizationsUrl;

  @HiveField(13)
  final String reposUrl;

  @HiveField(14)
  final String eventsUrl;

  @HiveField(15)
  final String receivedEventsUrl;

  @HiveField(16)
  final String type;

  @HiveField(17)
  final String userViewType;

  @HiveField(18)
  final bool siteAdmin;

  const Owner({
    required this.login,
    required this.id,
    required this.nodeId,
    required this.avatarUrl,
    required this.gravatarId,
    required this.url,
    required this.htmlUrl,
    required this.followersUrl,
    required this.followingUrl,
    required this.gistsUrl,
    required this.starredUrl,
    required this.subscriptionsUrl,
    required this.organizationsUrl,
    required this.reposUrl,
    required this.eventsUrl,
    required this.receivedEventsUrl,
    required this.type,
    required this.userViewType,
    required this.siteAdmin,
  });

  factory Owner.fromJson(Map<String, dynamic> json) {
    return Owner(
      login: json['login'] as String,
      id: json['id'] as int,
      nodeId: json['node_id'] as String,
      avatarUrl: json['avatar_url'] as String,
      gravatarId: json['gravatar_id'] as String,
      url: json['url'] as String,
      htmlUrl: json['html_url'] as String,
      followersUrl: json['followers_url'] as String,
      followingUrl: json['following_url'] as String,
      gistsUrl: json['gists_url'] as String,
      starredUrl: json['starred_url'] as String,
      subscriptionsUrl: json['subscriptions_url'] as String,
      organizationsUrl: json['organizations_url'] as String,
      reposUrl: json['repos_url'] as String,
      eventsUrl: json['events_url'] as String,
      receivedEventsUrl: json['received_events_url'] as String,
      type: json['type'] as String,
      userViewType: json['user_view_type'] as String,
      siteAdmin: json['site_admin'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'login': login,
      'id': id,
      'node_id': nodeId,
      'avatar_url': avatarUrl,
      'gravatar_id': gravatarId,
      'url': url,
      'html_url': htmlUrl,
      'followers_url': followersUrl,
      'following_url': followingUrl,
      'gists_url': gistsUrl,
      'starred_url': starredUrl,
      'subscriptions_url': subscriptionsUrl,
      'organizations_url': organizationsUrl,
      'repos_url': reposUrl,
      'events_url': eventsUrl,
      'received_events_url': receivedEventsUrl,
      'type': type,
      'user_view_type': userViewType,
      'site_admin': siteAdmin,
    };
  }
}
