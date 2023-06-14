class UserData {
  String displayName;
  String email;
  String zipcode;

  UserData(this.displayName, this.email, this.zipcode);

  Map<String, dynamic> toJson() => {
        'displayName': displayName,
        'email': email,
        'zipcode': zipcode,
      };
}
