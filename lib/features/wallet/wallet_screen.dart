import 'package:flutter/material.dart';
import '../auth/models/wallet_models.dart';
import '../../core/widgets/wallet_widgets.dart';
import '../main/screens/base_screen.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({Key? key}) : super(key: key);

  @override
  _WalletScreenState createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  double walletBalance = 237.77;
  double socialNetworth = 325.35;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadWalletData();
  }

  Future<void> _loadWalletData() async {
    setState(() => isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      initialIndex: 2, // Setting wallet tab as initial
      child: Column(
        children: [
          WalletBalanceCard(
            balance: walletBalance,
            onBuyTapped: _showBuyDialog,
            onDepositTapped: _showDepositDialog,
            onWithdrawTapped: _showWithdrawDialog,
          ),
          SocialNetworthCard(
            amount: socialNetworth,
            percentageChange: 0.11,
          ),
          const SizedBox(height: 20),
          AssetsTabView(
            tabController: _tabController,
            tokens: _getTokens(),
            nfts: _getNFTs(),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  List<Token> _getTokens() {
    return [
      Token(
        name: 'Sofia Santos',
        symbol: '\$sofia',
        price: 331.89,
        priceChange: 0.11,
        imageUrl: 'assets/default_user.png',
      ),
      Token(
        name: 'Lila Patel',
        symbol: '\$lila',
        price: 331.89,
        priceChange: 0.11,
        imageUrl: 'assets/default_user.png',
      ),
      Token(
        name: 'Ethan Nguyen',
        symbol: '\$ethan',
        price: 331.89,
        priceChange: -2.04,
        imageUrl: 'assets/default_user.png',
      ),
      Token(
        name: 'Ethan Nguyen',
        symbol: '\$ethan',
        price: 331.89,
        priceChange: -2.04,
        imageUrl: 'assets/default_user.png',
      ),
      Token(
        name: 'Ethan Nguyen',
        symbol: '\$ethan',
        price: 331.89,
        priceChange: -2.04,
        imageUrl: 'assets/default_user.png',
      ),
    ];
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
