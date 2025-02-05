class Profile {
  String id;
  String name;
  String email;

  Profile({required this.id, required this.name, required this.email});

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
        id: json['_id'],
        name: json['name'],
        email: json['email'],
      );

  get address => null;

  get phone => null;
}
