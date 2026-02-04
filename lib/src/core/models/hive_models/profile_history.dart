import 'package:hive_ce/hive.dart';

part 'profile_history.g.dart';

@HiveType(typeId: 2)
class CacheProfileModel {
  CacheProfileModel({
    this.id,
    this.email,
    this.firstName,
    this.lastName,
    this.picture,
    this.verified,
    this.emailVerified,
    this.profileCreated,
  });
  @HiveField(1)
  final String? id;
  @HiveField(2)
  String? email;
  @HiveField(3)
  String? firstName;
  @HiveField(4)
  String? lastName;
  @HiveField(5)
  String? picture;
  @HiveField(6)
  bool? verified;
  @HiveField(7)
  bool? emailVerified;
  @HiveField(8)
  bool? profileCreated;
}
