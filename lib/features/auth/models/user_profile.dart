class UserProfile {
  final int id;
  final String fullName;
  final String? displayPicture;
  final String? twitterUsername;
  final String? walletAddress;

  UserProfile({
    required this.id,
    required this.fullName,
    this.displayPicture,
    this.twitterUsername,
    this.walletAddress
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    print('🟣 UserProfile Raw JSON: $json');
    
    return UserProfile(
      id: json['id'] ?? 0,
      fullName: json['full_name'] ?? 'Nayan',
      displayPicture: json['display_picture'],
      twitterUsername: json['twitter_username'],
      walletAddress: json['wallet_address'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'display_picture': displayPicture,
      'twitter_username': twitterUsername,
      'wallet_address': walletAddress,
    };
  }

  String get displayName => fullName.isNotEmpty ? fullName : 'User $id';
} 