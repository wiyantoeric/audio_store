class UserProfile {
  String? fullName;
  String? address;
  String? phone;

  UserProfile({
    required this.fullName,
    required this.address,
    required this.phone,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      fullName: json['full_name'],
      address: json['address'],
      phone: json['phone'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'full_name': fullName,
      'address': address,
      'phone': phone,
    };
  }
}
