import 'package:flutter/material.dart';
import 'package:peopleapp_flutter/core/constants/image_constants.dart';
import 'package:peopleapp_flutter/core/widgets/toast_widget.dart';
import 'package:peopleapp_flutter/features/auth/models/social_connect_model.dart';
import 'package:peopleapp_flutter/core/routes/app_path_constants.dart';
import 'package:peopleapp_flutter/core/constants/color_constants.dart';
import 'package:peopleapp_flutter/core/widgets/custom_button.dart';

class SocialConnectionsSheet extends StatefulWidget {
  SocialConnectionsSheet({super.key, required this.onDone});

  final VoidCallback onDone;

  @override
  State<SocialConnectionsSheet> createState() => _SocialConnectionsSheetState();

  showSocialConnections(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => SocialConnectionsSheet(onDone: onDone),
    );
  }
}

class _SocialConnectionsSheetState extends State<SocialConnectionsSheet> {
  final List<SocialModel> socialModels = [];
  var isCompleted = false;
  int count = 1;

  @override
  void initState() {
    super.initState();
    socialModels.addAll([
      SocialModel(
        icon: ImageConstants.youtubeIcon,
        title: 'YouTube',
        subtitle: 'YouTube channel',
        isConnected: false,
        onTap: () => _handleSocialConnect('YouTube'),
      ),
      SocialModel(
        icon: ImageConstants.instagramIcon,
        title: 'Instagram',
        subtitle: 'Instagram',
        isConnected: false,
        onTap: () => _handleSocialConnect('Instagram'),
      ),
      SocialModel(
        icon: ImageConstants.twitterIcon,
        title: 'Twitter',
        subtitle: 'Twitter',
        isConnected: false,
        onTap: () => _handleSocialConnect('Twitter'),
      ),
    ]);
  }

  void _handleSocialConnect(String title) {
    final socialModel =
        socialModels.firstWhere((model) => model.title == title);

    count = socialModels.where((model) => model.isConnected).length;

    setState(() {
      socialModel.isConnected = !socialModel.isConnected;
      isCompleted = (count == (socialModels.length - 1));
    });

    Toast.show('$title connected successfully');

    print("${socialModels.length} ${count} ${isCompleted}");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: ColorConstants.modalBackground,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Text(
                'Connect Social Accounts',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () => _showInfoDialog(context),
                icon: const Icon(
                  Icons.info_outline,
                  color: Colors.white54,
                  size: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          for (var model in socialModels)
            _buildSocialButton(
              icon: model.icon,
              title: model.title,
              subtitle: model.subtitle,
              isConnected: model.isConnected,
              onTap: model.onTap,
            ),
          const SizedBox(height: 42),
          PrimaryButton(
            text: 'Skip',
            isPrimary: false,
            onPressed: () {
              if (!isCompleted) {
                _showSkipDialog();
              } else {
                // Navigator.pushNamed(context, RouteConstants.createTokenScreen);
              }
            },
          ),
          const SizedBox(height: 16),
          PrimaryButton(
            text: 'Done',
            isDisabled: (isCompleted == false),
            onPressed: () {
              widget.onDone();
            },
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  void _showSkipDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: ColorConstants.modalBackground,
          title: const Row(
            children: [
              // Icon(
              //   Icons.warning, // Choose an appropriate icon
              //   color: Colors.yellow, // Change color as needed
              //   size: 24, // Adjust size as needed
              // ),
              // SizedBox(width: 8), // Space between icon and text
              Expanded(
                child: Text(
                  'Skip Social Account Connections',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
          content: const Text(
            'By skipping this step, you will not be able to create your own token until all social accounts are connected.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                // Logic to proceed to create token
                // For example, navigate to the CreateTokenScreen
                Navigator.pushNamed(context, RouteConstants.createTokenScreen);
              },
              child: const Text('Continue'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSocialButton({
    required String icon,
    required String title,
    required String subtitle,
    required bool isConnected,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isConnected
            ? ColorConstants.primaryPurple
            : ColorConstants.darkBackground.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Image.asset(
                  icon,
                  width: 24,
                  height: 24,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        "${isConnected ? 'Connected to your' : 'Connect your'} $subtitle",
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  isConnected ? Icons.check_circle : Icons.arrow_forward_ios,
                  color: isConnected
                      ? Colors.green
                      : Colors.white.withOpacity(0.5),
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: ColorConstants.modalBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Social Connections',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Connect your social media accounts to:',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 16),
              _buildInfoPoint('Verify your social media influence'),
              _buildInfoPoint('Import your follower count'),
              _buildInfoPoint('Share content directly to your accounts'),
              _buildInfoPoint('Manage your token distribution'),
              const SizedBox(height: 24),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Got it',
                  style: TextStyle(
                    color: ColorConstants.primaryPurple,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(
            Icons.check_circle,
            color: ColorConstants.primaryPurple,
            size: 16,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
