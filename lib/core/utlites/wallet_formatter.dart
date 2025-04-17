import 'package:flutter/services.dart';

class WalletFormatter {
  static String shortenAddress(String address) {
    if (address.isEmpty) return '';
    if (address.length < 10) return address;
    return '0x${address.substring(0, 6)}...${address.substring(address.length - 4)}';
  }

  static String formatEVMAddress(String address) {
    if (address.isEmpty) return '';

    address = address.trim().toLowerCase();

    if (!address.startsWith('0x')) {
      address = '0x$address';
    }

    if (address.length != 42) {
      throw FormatException('Invalid EVM address length');
    }

    return address;
  }

  static String formatSolanaAddress(String address) {
    if (address.isEmpty) return '';

    address = address.trim();

    if (address.length < 32 || address.length > 44) {
      throw FormatException('Invalid Solana address length');
    }

    final base58Regex = RegExp(r'^[1-9A-HJ-NP-Za-km-z]+$');
    if (!base58Regex.hasMatch(address)) {
      throw FormatException('Invalid Solana address format');
    }

    return address;
  }

  static String formatTronAddress(String address) {
    if (address.isEmpty) return '';

    address = address.trim();

    if (!address.startsWith('T')) {
      address = 'T$address';
    }

    if (address.length != 34) {
      throw FormatException('Invalid Tron address length');
    }

    return address;
  }

  static Future<void> copyToClipboard(String address,
      {Function? onCopied}) async {
    await Clipboard.setData(ClipboardData(text: address));
    if (onCopied != null) {
      onCopied();
    }
  }

  static bool isValidAddress(String address, {required String chainType}) {
    try {
      switch (chainType.toLowerCase()) {
        case 'evm':
        case 'ethereum':
          formatEVMAddress(address);
          return true;
        case 'solana':
          formatSolanaAddress(address);
          return true;
        case 'tron':
          formatTronAddress(address);
          return true;
        default:
          return false;
      }
    } catch (e) {
      return false;
    }
  }
}
