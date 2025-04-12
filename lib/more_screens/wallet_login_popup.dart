import 'package:flutter/material.dart';
import 'package:peopleapp_flutter/core/constants/color_constants.dart';
import 'package:peopleapp_flutter/core/widgets/custom_button.dart';

class WalletLoginPopup extends StatelessWidget {
  final Function(String) onWalletSelected;

  const WalletLoginPopup({
    super.key,
    required this.onWalletSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: ColorConstants.darkBackground,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Wallet Login',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _WalletOption(
              icon: 'assets/icons/metamask.png',
              name: 'Metamask',
              status: 'Detected',
              onTap: () => onWalletSelected('Metamask'),
            ),
            _WalletOption(
              icon: 'assets/icons/coinbase.png',
              name: 'Coinbase Wallet',
              status: 'Detected',
              onTap: () => onWalletSelected('Coinbase Wallet'),
            ),
            _WalletOption(
              icon: 'assets/icons/walletconnect.png',
              name: 'walletconnect',
              status: 'Detected',
              onTap: () => onWalletSelected('WalletConnect'),
            ),
            const SizedBox(height: 16),
            const Text(
              'By connecting a wallet, you agree to the',
              style: TextStyle(color: ColorConstants.greyText, fontSize: 12),
            ),
            TextButton(
              onPressed: () {},
              child: const Text(
                'terms and conditions',
                style: TextStyle(
                  color: ColorConstants.primaryPurple,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WalletOption extends StatelessWidget {
  final String icon;
  final String name;
  final String status;
  final VoidCallback onTap;

  const _WalletOption({
    required this.icon,
    required this.name,
    required this.status,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
      leading: Image.asset(icon, width: 32, height: 32),
      title: Text(
        name,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
      trailing: Text(
        status,
        style: TextStyle(
          color: status == 'Detected'
              ? ColorConstants.greyText
              : ColorConstants.primaryPurple,
          fontSize: 14,
        ),
      ),
    );
  }
}
