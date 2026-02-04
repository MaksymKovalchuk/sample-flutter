import 'package:sample/src/core/models/base/base_model.dart';

class ProfileModel extends BaseModel {
  ProfileModel({
    this.email = "",
    this.firstName = "",
    this.lastName = "",
    this.birthDate = "",
    this.address = "",
    this.phone = "",
    this.phoneVerified = false,
  });

  String? email;
  String? firstName;
  String? lastName;
  String? birthDate;
  String? address;
  String? phone;
  bool phoneVerified;

  @override
  fromJson(Map<String, dynamic>? json) {
    if (json == null) throw const FormatException("Null JSON");

    return ProfileModel(
      email: json['email'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      birthDate: json['birth_date'],
      address: json['address'],
      phone: json['phone'],
      phoneVerified: json['verified'],
    );
  }

  @override
  Map<String, dynamic>? toJson() => null;
}
