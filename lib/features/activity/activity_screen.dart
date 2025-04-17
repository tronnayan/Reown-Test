import 'package:flutter/material.dart';
import 'package:peopleapp_flutter/core/constants/color_constants.dart';
import 'package:peopleapp_flutter/core/constants/color_constants.dart';
import '../main/screens/main_screen.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});

  @override
  _ActivityScreenState createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  String selectedFilter = 'All Activity';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(),
        Expanded(
          child: _buildMainContent(),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          const Text(
            'Activity',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          _buildFilterDropdown(),
        ],
      ),
    );
  }

  Widget _buildFilterDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.swap_horiz, color: Colors.white, size: 20),
          const SizedBox(width: 8),
          Text(
            selectedFilter,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 20),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildActivityItem(
          profileUrl: 'assets/default_user.png',
          username: '\$shubhm',
          action: 'bought',
          tokenCount: '2',
          tokenType: 'tokens',
          isPositive: true,
          targetUser: '\$sumit',
          amount: '0.34',
          usdAmount: '-\$3.56',
          timeAgo: '6 mins ago',
        ),
        _buildActivityItem(
          profileUrl: 'assets/default_user.png',
          username: '\$sumit',
          action: 'sold',
          tokenCount: '10',
          tokenType: 'tokens',
          isPositive: false,
          targetUser: '\$tanmay',
          amount: '3.4',
          usdAmount: '-\$35.6',
          timeAgo: '6 mins ago',
        ),
        // Add more activity items here
      ],
    );
  }

  Widget _buildActivityItem({
    required String profileUrl,
    required String username,
    required String action,
    required String tokenCount,
    required String tokenType,
    required bool isPositive,
    required String targetUser,
    required String amount,
    required String usdAmount,
    required String timeAgo,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.only(left: 24, right: 24, top: 18, bottom: 18),
      decoration: BoxDecoration(
        color: ColorConstants.secondaryBackground,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundImage: AssetImage(profileUrl),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                    children: [
                      TextSpan(
                        text: username,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: ' $action '),
                      TextSpan(
                        text: tokenCount,
                        style: TextStyle(
                          color: isPositive ? Colors.green : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(text: ' $tokenType of '),
                      TextSpan(
                        text: targetUser,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const TextSpan(text: ' '),
                      TextSpan(
                        text: 'for $amount \$people ($usdAmount)',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Text(
            timeAgo,
            style: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
