class PersonalDataM {
  String id;
  String username;
  String? name;
  String? email;
  String? dob;
  String? profileUrl;
  PersonalDataM({
    required this.id,
    required this.username,
    this.name,
    this.email,
    this.dob,
    this.profileUrl,
  });
}
