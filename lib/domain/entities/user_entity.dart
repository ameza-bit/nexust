class UserEntity {
  final String uid;
  final String? email;
  final String? name;
  final String? photoUrl;

  UserEntity({
    required this.uid,
    this.email,
    this.name,
    this.photoUrl,
  });
}