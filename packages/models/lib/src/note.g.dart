// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NoteAdapter extends TypeAdapter<Note> {
  @override
  final int typeId = 1;

  @override
  Note read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Note(
      url: fields[0] as String,
      forksUrl: fields[1] as String,
      commitsUrl: fields[2] as String,
      id: fields[3] as String,
      nodeId: fields[4] as String,
      gitPullUrl: fields[5] as String,
      gitPushUrl: fields[6] as String,
      htmlUrl: fields[7] as String,
      files: (fields[8] as Map).cast<String, NoteFile>(),
      isPublic: fields[9] as bool,
      createdAt: fields[10] as DateTime,
      updatedAt: fields[11] as DateTime,
      description: fields[12] as String,
      comments: fields[13] as int,
      user: fields[14] as dynamic,
      commentsEnabled: fields[15] as bool,
      commentsUrl: fields[16] as String,
      owner: fields[17] as Owner,
      truncated: fields[18] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Note obj) {
    writer
      ..writeByte(19)
      ..writeByte(0)
      ..write(obj.url)
      ..writeByte(1)
      ..write(obj.forksUrl)
      ..writeByte(2)
      ..write(obj.commitsUrl)
      ..writeByte(3)
      ..write(obj.id)
      ..writeByte(4)
      ..write(obj.nodeId)
      ..writeByte(5)
      ..write(obj.gitPullUrl)
      ..writeByte(6)
      ..write(obj.gitPushUrl)
      ..writeByte(7)
      ..write(obj.htmlUrl)
      ..writeByte(8)
      ..write(obj.files)
      ..writeByte(9)
      ..write(obj.isPublic)
      ..writeByte(10)
      ..write(obj.createdAt)
      ..writeByte(11)
      ..write(obj.updatedAt)
      ..writeByte(12)
      ..write(obj.description)
      ..writeByte(13)
      ..write(obj.comments)
      ..writeByte(14)
      ..write(obj.user)
      ..writeByte(15)
      ..write(obj.commentsEnabled)
      ..writeByte(16)
      ..write(obj.commentsUrl)
      ..writeByte(17)
      ..write(obj.owner)
      ..writeByte(18)
      ..write(obj.truncated);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NoteAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class NoteFileAdapter extends TypeAdapter<NoteFile> {
  @override
  final int typeId = 2;

  @override
  NoteFile read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NoteFile(
      filename: fields[0] as String,
      type: fields[1] as String,
      language: fields[2] as String?,
      rawUrl: fields[3] as String,
      size: fields[4] as int,
    );
  }

  @override
  void write(BinaryWriter writer, NoteFile obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.filename)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.language)
      ..writeByte(3)
      ..write(obj.rawUrl)
      ..writeByte(4)
      ..write(obj.size);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NoteFileAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class OwnerAdapter extends TypeAdapter<Owner> {
  @override
  final int typeId = 3;

  @override
  Owner read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Owner(
      login: fields[0] as String,
      id: fields[1] as int,
      nodeId: fields[2] as String,
      avatarUrl: fields[3] as String,
      gravatarId: fields[4] as String,
      url: fields[5] as String,
      htmlUrl: fields[6] as String,
      followersUrl: fields[7] as String,
      followingUrl: fields[8] as String,
      gistsUrl: fields[9] as String,
      starredUrl: fields[10] as String,
      subscriptionsUrl: fields[11] as String,
      organizationsUrl: fields[12] as String,
      reposUrl: fields[13] as String,
      eventsUrl: fields[14] as String,
      receivedEventsUrl: fields[15] as String,
      type: fields[16] as String,
      userViewType: fields[17] as String,
      siteAdmin: fields[18] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Owner obj) {
    writer
      ..writeByte(19)
      ..writeByte(0)
      ..write(obj.login)
      ..writeByte(1)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.nodeId)
      ..writeByte(3)
      ..write(obj.avatarUrl)
      ..writeByte(4)
      ..write(obj.gravatarId)
      ..writeByte(5)
      ..write(obj.url)
      ..writeByte(6)
      ..write(obj.htmlUrl)
      ..writeByte(7)
      ..write(obj.followersUrl)
      ..writeByte(8)
      ..write(obj.followingUrl)
      ..writeByte(9)
      ..write(obj.gistsUrl)
      ..writeByte(10)
      ..write(obj.starredUrl)
      ..writeByte(11)
      ..write(obj.subscriptionsUrl)
      ..writeByte(12)
      ..write(obj.organizationsUrl)
      ..writeByte(13)
      ..write(obj.reposUrl)
      ..writeByte(14)
      ..write(obj.eventsUrl)
      ..writeByte(15)
      ..write(obj.receivedEventsUrl)
      ..writeByte(16)
      ..write(obj.type)
      ..writeByte(17)
      ..write(obj.userViewType)
      ..writeByte(18)
      ..write(obj.siteAdmin);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OwnerAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
