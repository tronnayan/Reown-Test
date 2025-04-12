import 'package:flutter/material.dart';
import 'package:peopleapp_flutter/core/constants/color_constants.dart';
import 'package:peopleapp_flutter/features/activity/activity_screen.dart';
import 'package:peopleapp_flutter/features/home/dashboard_screen.dart';
import 'package:peopleapp_flutter/features/more/more_screen.dart';
import 'package:peopleapp_flutter/features/wallet/wallet_screen.dart';
import '../../explore/explore_screen.dart';
import 'package:provider/provider.dart';
import '../../auth/providers/auth_provider.dart';
import '../../../core/routes/app_routes.dart';
import 'package:peopleapp_flutter/core/constants/color_constants.dart';

class BaseScreen extends StatefulWidget {
  final Widget child;
  final int initialIndex;
  final bool hideHeader;

  const BaseScreen(
      {super.key,
      required this.child,
      this.initialIndex = 0,
      this.hideHeader = false});

  @override
  BaseScreenState createState() => BaseScreenState();
}

class BaseScreenState extends State<BaseScreen> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    final paddingTop = MediaQuery.of(context).padding.top;
    final paddingBottom = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: ColorConstants.darkBackground,
      extendBody: true,
      body: Column(
        children: [
          SizedBox(height: paddingTop),
          widget.hideHeader ? const SizedBox(height: 0) : _buildHeader(),
          Expanded(child: widget.child),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(paddingBottom),
    );
  }

  Widget _buildHeader() {
    final authProvider = Provider.of<AuthProvider>(context, listen: true);
    final userProfile = authProvider.userProfile;

    String formatWalletAddress(String? address) {
      print('🟣 Wallet Address in formatter: $address');
      if (address == null || address.isEmpty) return '---';
      if (address.length < 10) return address;
      return '${address.substring(0, 6)}...${address.substring(address.length - 4)}';
    }

    print('🟣 Current UserProfile: ${userProfile?.toJson()}');

    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Image.asset('assets/images/people_logo.png', height: 24),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: ColorConstants.primaryPurple.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Text(
                  formatWalletAddress(userProfile?.walletAddress),
                  style: const TextStyle(color: Colors.white),
                ),
                const Icon(Icons.keyboard_arrow_down, color: Colors.white),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav(double paddingBottom) {
    return Container(
      color: ColorConstants.darkBackground,
      child: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          decoration: BoxDecoration(
            color: ColorConstants.darkBackground,
            border: Border(
              top: BorderSide(
                color: Colors.white.withOpacity(0.1),
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                  'assets/icons/home_icon.png', 'Home', _selectedIndex == 0,
                  () {
                setState(() => _selectedIndex = 0);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const DashboardScreen()));
              }),
              _buildNavItem('assets/icons/explore_icon.png', 'Explore',
                  _selectedIndex == 1, () {
                setState(() => _selectedIndex = 1);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ExploreScreen()));
              }),
              _buildNavItem(
                  'assets/icons/wallet_icon.png', 'Wallet', _selectedIndex == 2,
                  () {
                setState(() => _selectedIndex = 2);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const WalletScreen()));
              }),
              _buildNavItem('assets/icons/activity_icon.png', 'Activity',
                  _selectedIndex == 3, () {
                setState(() => _selectedIndex = 3);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ActivityScreen()));
              }),
              _buildNavItem(
                  'assets/icons/more_icon.png', 'More', _selectedIndex == 4,
                  () {
                setState(() => _selectedIndex = 4);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const MoreScreen()));
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
      String imagePath, String label, bool isActive, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            imagePath,
            width: 24,
            height: 24,
            color: isActive
                ? ColorConstants.primaryPurple
                : ColorConstants.greyText,
          ),
          Text(
            label,
            style: TextStyle(
              color: isActive
                  ? ColorConstants.primaryPurple
                  : ColorConstants.greyText,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
