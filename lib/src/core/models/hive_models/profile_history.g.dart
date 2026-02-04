// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_history.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CacheProfileModelAdapter extends TypeAdapter<CacheProfileModel> {
  @override
  final int typeId = 2;

  @override
  CacheProfileModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CacheProfileModel(
      id: fields[1] as String?,
      email: fields[2] as String?,
      firstName: fields[3] as String?,
      lastName: fields[4] as String?,
      picture: fields[5] as String?,
      verified: fields[6] as bool?,
      emailVerified: fields[7] as bool?,
      profileCreated: fields[8] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, CacheProfileModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(1)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.email)
      ..writeByte(3)
      ..write(obj.firstName)
      ..writeByte(4)
      ..write(obj.lastName)
      ..writeByte(5)
      ..write(obj.picture)
      ..writeByte(6)
      ..write(obj.verified)
      ..writeByte(7)
      ..write(obj.emailVerified)
      ..writeByte(8)
      ..write(obj.profileCreated);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CacheProfileModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
