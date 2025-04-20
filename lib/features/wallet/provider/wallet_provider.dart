import 'package:flutter/material.dart';
import 'package:peopleapp_flutter/features/auth/models/db/user_wallet_model.dart';
import 'package:peopleapp_flutter/features/auth/providers/reown_provider.dart';
import 'package:peopleapp_flutter/features/auth/service/wallet_db_service.dart';
import 'package:reown_appkit/reown_appkit.dart';

class WalletProvider extends ChangeNotifier {
  WalletData? _walletData;
  WalletLoadingState _loadingState = WalletLoadingState.initial;
  String _error = '';
  final ReownProvider _reownProvider;

  WalletProvider(this._reownProvider);

  WalletData? get walletData => _walletData;
  WalletLoadingState get loadingState => _loadingState;
  String get error => _error;
  bool get hasWallet => _walletData != null;
  double get balance => _walletData?.walletBalance ?? 0.0;
  String get currency => _walletData?.currency ?? '';
  String get chainName => _walletData?.chainName ?? '';
  String get walletAddress => _walletData?.walletAddress ?? '';

  Future<void> initializeWallet() async {
    _setLoadingState(WalletLoadingState.loading);
    try {
      await _loadWalletData();
      _setLoadingState(WalletLoadingState.loaded);
    } catch (e) {
      _setError('Failed to initialize wallet: $e');
      _setLoadingState(WalletLoadingState.error);
    }
  }

  // Load wallet data from Hive
  Future<void> _loadWalletData() async {
    try {
      _walletData = HiveService.getWalletData();
      notifyListeners();
    } catch (e) {
      _setError('Error loading wallet data: $e');
      rethrow;
    }
  }

  Future<void> refreshBalance() async {
    if (_walletData == null || !_reownProvider.isWalletConnected) return;

    _setLoadingState(WalletLoadingState.loading);
    try {
      final chainId = _walletData!.chainId;
      final namespace = NamespaceUtils.getNamespaceFromChain(chainId);

      await _reownProvider.fetchWalletBalance(
        _walletData!.walletAddress,
        chainId,
        namespace,
      );

      _walletData = WalletData(
        walletAddress: _walletData!.walletAddress,
        walletBalance: _reownProvider.walletBalance,
        chainId: _walletData!.chainId,
        chainName: _walletData!.chainName,
        currency: _walletData!.currency,
        tokenName: _walletData!.tokenName,
      );

      await HiveService.saveWalletData(_walletData!);
      _setLoadingState(WalletLoadingState.loaded);
    } catch (e) {
      _setError('Error refreshing balance: $e');
      _setLoadingState(WalletLoadingState.error);
    }
  }

  void _setLoadingState(WalletLoadingState state) {
    _loadingState = state;
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

enum WalletLoadingState { initial, loading, loaded, error }
