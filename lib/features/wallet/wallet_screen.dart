import 'package:flutter/material.dart';
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
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<WalletProvider>().initializeWallet();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WalletProvider>(builder: (context, walletProvider, child) {
      return Column(
        children: [
          WalletBalanceCard(
            walletProvider: walletProvider,
            onBuyTapped: _showBuyDialog,
            onDepositTapped: _showDepositDialog,
            onWithdrawTapped: _showWithdrawDialog,
          ),
          SocialNetworthCard(
            walletProvider: walletProvider,
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
      );
    });
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
