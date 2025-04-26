import 'package:flutter/material.dart';
import 'package:peopleapp_flutter/core/routes/app_path_constants.dart';
import 'package:peopleapp_flutter/core/routes/app_routes.dart';
import 'package:peopleapp_flutter/core/services/get_it_service.dart';
import 'package:peopleapp_flutter/features/auth/providers/reown_provider.dart';
import 'package:peopleapp_flutter/features/dashboard/dashboard_screen.dart';
import 'package:peopleapp_flutter/features/auth/screens/widgets/bottomsheets/auth_bottomseets.dart';
import 'package:peopleapp_flutter/core/constants/color_constants.dart';
import 'package:peopleapp_flutter/core/widgets/custom_button.dart';
import 'package:provider/provider.dart';
import 'package:reown_appkit/reown_appkit.dart';

class CreateTokenScreen extends StatefulWidget {
  const CreateTokenScreen({super.key});

  @override
  State<CreateTokenScreen> createState() => _CreateTokenScreenState();
}

class _CreateTokenScreenState extends State<CreateTokenScreen> {
  // ReownProvider reownProvider = getIt<ReownProvider>();
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await context.read<ReownProvider>().initializeService(context);

      // AuthBottomSheets.showSocialConnectionsBottomSheet(context, onDone: () {
      //   Navigator.pop(context);
      // });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ReownProvider>(builder: (context, provider, child) {
      // WidgetsBinding.instance.addPostFrameCallback((_) async {
      //   if (provider.isLoading && !provider.isWalletConnected) {
      //     showLoadingDialog(context);
      //   } else if (!provider.isLoading && provider.isWalletConnected) {
      //     WidgetsBinding.instance.addPostFrameCallback((_) {
      //       Navigator.of(context, rootNavigator: true).pop(); // Dismiss dialog
      //     });
      //   }
      // });
      return Scaffold(
        backgroundColor: ColorConstants.darkBackground,
        resizeToAvoidBottomInset: false,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.only(
                  top: 64,
                  bottom: 246,
                  left: 24,
                  right: 24,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Create\nYour Token',
                      style: TextStyle(
                        fontSize: 36,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Choose a unique, catchy token name (max 6 words) that represents you or your brand. Once set, it cannot be changed.',
                      style: TextStyle(
                        fontSize: 16,
                        color: ColorConstants.greyText,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 38),
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: AssetImage('assets/default_user.png'),
                    ),
                    const SizedBox(height: 36),
                    Center(
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 96),
                        child: TextField(
                          controller: provider.tokenNameController,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: ColorConstants.secondaryBackground,
                            hintText: '\$people',
                            hintStyle: const TextStyle(
                              color: ColorConstants.greyText,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 16),
                          ),
                        ),
                      ),
                    ),

                    // Display wallet details when connected
                    if (provider.isWalletConnected) ...[
                      const SizedBox(height: 24),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: ColorConstants.secondaryBackground,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            const Text(
                              'Wallet Details',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Network: ${provider.appKitModal?.selectedChain?.name ?? "Unknown"}',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Address: ${_shortenAddress(provider.walletAddress)}',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Balance: ${provider.walletBalance.toStringAsFixed(4)} ${provider.appKitModal?.selectedChain?.currency ?? ""}',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              _bottom(provider),
            ],
          ),
        ),
      );
    });
  }

  Widget _bottom(ReownProvider provider) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: provider.isLoading
          ? const CircularProgressIndicator(
              color: ColorConstants.primaryPurple,
            )
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (provider.appKitModal != null) ...[
                  AppKitModalConnectButton(
                    appKit: provider.appKitModal!,
                    custom: SizedBox.shrink(),
                  ),
                  AppKitModalAccountButton(
                    appKit: provider.appKitModal!,
                    context: context,
                    appKitModal: provider.appKitModal!,
                    custom: SizedBox.shrink(),
                  ),
                ],
                PrimaryButton(
                  text: _getButtonText(provider.connectionStatus),
                  isPrimary: true,
                  onPressed: () async {
                    try {
                      await provider.connectWallet(context);
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content:
                              Text('Failed to connect wallet: ${e.toString()}'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                ),
                const SizedBox(height: 16),
                PrimaryButton(
                  text: 'Skip',
                  isPrimary: false,
                  onPressed: () {
                    provider.appKitModal!.disconnect();
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => const DashboardScreen()));
                  },
                ),
                const SizedBox(height: 36),
              ],
            ),
    );
  }

  void _showSuccessDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: ColorConstants.modalBackground,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/ic_success_modal.png',
                    height: 120,
                  ),
                  const Text(
                    'Success!',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'Your token has been created successfully.',
                    style: TextStyle(
                      fontSize: 16,
                      color: ColorConstants.greyText,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  PrimaryButton(
                    text: 'Continue',
                    isPrimary: true,
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const DashboardScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  String _shortenAddress(String address) {
    if (address.length < 10) return address;
    return '${address.substring(0, 6)}...${address.substring(address.length - 4)}';
  }

  String _getButtonText(ConnectionStatus status) {
    switch (status) {
      case ConnectionStatus.connected:
        {
          return 'Create Token';
        }
      case ConnectionStatus.expired:
        return 'Reconnect Wallet';
      case ConnectionStatus.disconnected:
        return 'Connect Wallet';
      default:
        return 'Connect Wallet';
    }
  }

  void showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // Makes dialog non-dismissible
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: ColorConstants.darkBackground,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(
                color: ColorConstants.primaryPurple,
              ),
              const SizedBox(height: 16),
              const Text(
                'Connecting Wallet...',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
