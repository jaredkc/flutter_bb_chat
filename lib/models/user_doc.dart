import 'package:json_annotation/json_annotation.dart';

part 'user_doc.g.dart';

@JsonSerializable()
class UserDoc {
  final String? email;
  final String? displayName;
  final String? imageURL;

  UserDoc({
    required this.email,
    required this.displayName,
    required this.imageURL,
  });

  factory UserDoc.fromJson(Map<String, dynamic> json) =>
      _$UserDocFromJson(json);

  Map<String, dynamic> toJson() => _$UserDocToJson(this);
}
