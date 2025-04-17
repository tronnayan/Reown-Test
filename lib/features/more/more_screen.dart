import 'package:flutter/material.dart';
import 'package:peopleapp_flutter/features/auth/screens/login_screen.dart';
import 'package:peopleapp_flutter/features/auth/screens/splash_screen.dart';
import 'package:peopleapp_flutter/more_screens/bookmarks_screen.dart';
import 'package:peopleapp_flutter/more_screens/messages_screen.dart';
import 'package:peopleapp_flutter/more_screens/profile_screen.dart';
import 'package:peopleapp_flutter/more_screens/refer_and_earn_screen.dart';
import 'package:peopleapp_flutter/more_screens/spin_wheel_screen.dart';
import 'package:peopleapp_flutter/more_screens/support_screen.dart';
import 'package:peopleapp_flutter/core/constants/color_constants.dart';
import '../../core/routes/app_routes.dart';
import '../main/screens/main_screen.dart';

class MoreScreen extends StatefulWidget {
  const MoreScreen({super.key});

  @override
  _MoreScreenState createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 24, top: 12, bottom: 12),
          child: Text(
            'More',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: _buildMainContent(),
        ),
      ],
    );
  }

  Widget _buildMainContent() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      children: [
        const SizedBox(height: 12),
        _buildMenuItem(
          icon: 'assets/icons/profile_icon.png',
          title: 'Profile',
          onTap: () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => const ProfileScreen())),
        ),
        _buildMenuItem(
          icon: 'assets/icons/messages_icon.png',
          title: 'Messages',
          onTap: () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => MessagesScreen())),
        ),
        _buildMenuItem(
          icon: 'assets/icons/refer_earn_icon.png',
          title: 'Refer & Earn',
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const ReferAndEarnScreen())),
        ),
        const SizedBox(height: 12),
        _buildMenuItem(
          icon: 'assets/icons/spin_wheel_icon.png',
          title: 'Spin wheel',
          onTap: () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => const SpinWheelScreen())),
        ),
        const SizedBox(height: 12),
        _buildMenuItem(
          icon: 'assets/icons/bookmark_icon.png',
          title: 'Bookmarks',
          onTap: () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => const BookmarksScreen())),
        ),
        _buildMenuItem(
          icon: 'assets/icons/support_icon.png',
          title: 'Support',
          onTap: () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => const SupportScreen())),
        ),
        const SizedBox(height: 12),
        _buildMenuItem(
          icon: 'assets/icons/log_out_icon.png',
          title: 'Log out',
          onTap: _handleLogout,
          showArrow: false,
        ),
      ],
    );
  }

  Widget _buildMenuItem({
    required String icon,
    required String title,
    required VoidCallback onTap,
    bool showArrow = true,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 28),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.white.withOpacity(0.1),
              width: 1,
            ),
          ),
        ),
        child: Row(
          children: [
            Image.asset(
              icon,
              width: 24,
              height: 24,
              color: ColorConstants.primaryPurple,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
            if (showArrow)
              const Icon(
                Icons.chevron_right,
                color: ColorConstants.primaryPurple,
                size: 24,
              ),
          ],
        ),
      ),
    );
  }

  void _handleLogout() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: ColorConstants.secondaryBackground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: const Text(
            'Logout',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            'Are you sure you want to log out?',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.6),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                // Handle logout logic here
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SplashPage()));
              },
              child: const Text(
                'Logout',
                style: TextStyle(
                  color: ColorConstants.primaryPurple,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
