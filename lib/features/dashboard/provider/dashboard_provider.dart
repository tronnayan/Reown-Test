import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:peopleapp_flutter/features/auth/models/user_wallet_model.dart';
import 'package:peopleapp_flutter/features/auth/service/user_wallet_data_service.dart';

class DashboardProvider extends ChangeNotifier {
  WalletData? _walletData;
  bool _isLoading = false;
  String _error = '';

  WalletData? get walletData => _walletData;
  bool get isLoading => _isLoading;
  String get error => _error;
  bool get hasWallet => _walletData != null;

  Future<void> initializeWallet() async {
    _setLoading(true);
    try {
      await _loadWalletData();
    } catch (e) {
      _setError('Failed to initialize wallet: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> _loadWalletData() async {
    try {
      _walletData = HiveService.getWalletData();
      notifyListeners();
    } catch (e) {
      _setError('Error loading wallet data: $e');
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String message) {
    _error = message;
    notifyListeners();
  }

  void clearError() {
    _error = '';
    notifyListeners();
  }
}
