import 'dart:ui';

class SocialModel {
  final String icon;
  final String title;
  final String subtitle;
  bool isConnected;
  VoidCallback onTap;
  SocialModel({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isConnected,
    required this.onTap,
  });
}
