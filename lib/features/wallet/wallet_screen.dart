import 'package:flutter/material.dart';
import 'package:peopleapp_flutter/core/constants/color_constants.dart';
import 'package:peopleapp_flutter/features/auth/providers/reown_provider.dart';
import 'package:peopleapp_flutter/features/wallet/models/wallet_models.dart';
import 'package:peopleapp_flutter/features/wallet/provider/wallet_provider.dart';
import '../../core/widgets/wallet_widgets.dart';
import '../main/screens/main_screen.dart';
import 'package:provider/provider.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({Key? key}) : super(key: key);

  @override
  _WalletScreenState createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late TabController _tabController;
  List<Token> _walletTokens = [];
  bool _isLoadingTokens = false;
  bool _isInitializing = true;
  bool _hasInitialized = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _initializeWallet();
  }

  Future<void> _initializeWallet() async {
    if (_hasInitialized) return;
    
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final reownProvider = context.read<ReownProvider>();
      
      // Initialize ReownProvider if not already initialized
      if (!reownProvider.isInitialized) {
        await reownProvider.initializeService(context);
      }
      
      // Initialize WalletProvider
      context.read<WalletProvider>().initializeWallet();
      
      // Wait a bit for wallet connection to be properly established
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Fetch wallet tokens if connected
      if (reownProvider.isWalletConnected) {
        await _fetchWalletTokens();
      }
      
      // Set initialization complete
      if (mounted) {
        setState(() {
          _isInitializing = false;
          _hasInitialized = true;
        });
      }
    });
  }

  Future<void> _fetchWalletTokens() async {
    if (!mounted) return;
    
    setState(() {
      _isLoadingTokens = true;
    });

    try {
      final reownProvider = context.read<ReownProvider>();
      final tokenData = await reownProvider.fetchWalletTokens();
      
      if (mounted) {
        setState(() {
          _walletTokens = tokenData.map((tokenMap) => Token(
            name: tokenMap['name'] as String,
            symbol: tokenMap['symbol'] as String,
            price: (tokenMap['balance'] as double),
            priceChange: (tokenMap['priceChange'] as double),
            imageUrl: tokenMap['imageUrl'] as String,
          )).toList();
          _isLoadingTokens = false;
        });
      }
    } catch (e) {
      debugPrint('[WalletScreen] Error fetching tokens: $e');
      if (mounted) {
        setState(() {
          _isLoadingTokens = false;
        });
      }
    }
  }

  Future<void> _refreshWallet() async {
    setState(() {
      _walletTokens.clear();
      _hasInitialized = false;
      _isInitializing = true;
    });
    await _initializeWallet();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin
    
    return Consumer<ReownProvider>(builder: (context, reownProvider, child) {
      // Only fetch tokens if we haven't initialized and wallet is connected
      if (!_hasInitialized && !_isInitializing) {
        _initializeWallet();
      }

      // Show loading state during initialization
      if (_isInitializing) {
        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                color: ColorConstants.primaryPurple,
              ),
              SizedBox(height: 16),
              Text(
                'Fetching wallet...',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        );
      }

      return Column(
        children: [
          WalletBalanceCard(
            reownProvider: reownProvider,
            onBuyTapped: _showBuyDialog,
            onDepositTapped: _showDepositDialog,
            onWithdrawTapped: _showWithdrawDialog,
            isWalletConnected: reownProvider.isWalletConnected,
            onConnectWalletTapped: () {
              reownProvider.connectWallet(context);
            },
          ),
          SocialNetworthCard(
            reownProvider: reownProvider,
            percentageChange: 0.11,
          ),
          const SizedBox(height: 20),
          AssetsTabView(
            tabController: _tabController,
            tokens: _getTokens(),
            nfts: _getNFTs(),
            isLoadingTokens: _isLoadingTokens,
            onRefresh: _refreshWallet,
          ),
          const SizedBox(height: 20),
        ],
      );
    });
  }

  List<Token> _getTokens() {
    if (_walletTokens.isNotEmpty) {
      return _walletTokens;
    }
    
    // Return empty list if no tokens loaded yet
    return [];
  }

  List<NFT> _getNFTs() {
    return [
      NFT(
        id: '10',
        name: 'PPL SPORT',
        imageUrl: 'assets/images/sample_nft.png',
        description: 'Lorem ipsum dolor sit amet',
      ),
      NFT(
        id: '102',
        name: 'PPL SPEAKER',
        imageUrl: 'assets/images/sample_nft.png',
        description: 'Lorem ipsum dolor sit amet',
      ),
    ];
  }

  void _showDepositDialog() {
    showDialog(
      context: context,
      builder: (context) => const DepositDialog(),
    );
  }

  void _showWithdrawDialog() {
    showDialog(
      context: context,
      builder: (context) => const WithdrawDialog(),
    );
  }

  void _showBuyDialog() {
    showDialog(
      context: context,
      builder: (context) => const BuyDialog(),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
