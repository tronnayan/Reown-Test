import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:peopleapp_flutter/core/constants/color_constants.dart';
import 'package:peopleapp_flutter/features/auth/providers/reown_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../features/wallet/models/wallet_models.dart';

class CustomTabIndicator extends Decoration {
  final Color color;
  final double radius;

  const CustomTabIndicator({
    required this.color,
    this.radius = 6.0,
  });

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _CustomPainter(
      color: color,
      radius: radius,
      onChange: onChanged,
    );
  }
}

class _CustomPainter extends BoxPainter {
  final Color color;
  final double radius;

  _CustomPainter({
    required this.color,
    required this.radius,
    VoidCallback? onChange,
  }) : super(onChange);

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final Rect rect = offset & configuration.size!;
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, Radius.circular(radius)),
      paint,
    );
  }
}

class WalletBalanceCard extends StatelessWidget {
  final ReownProvider reownProvider;
  final VoidCallback onBuyTapped;
  final VoidCallback onDepositTapped;
  final VoidCallback onWithdrawTapped;
  final VoidCallback onConnectWalletTapped;
  final bool isWalletConnected;

  const WalletBalanceCard({
    Key? key,
    required this.reownProvider,
    required this.onBuyTapped,
    required this.onDepositTapped,
    required this.onWithdrawTapped,
    required this.isWalletConnected,
    required this.onConnectWalletTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return !isWalletConnected
        ? Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: ColorConstants.secondaryBackground,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: ColorConstants.primaryPurple.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Column(
              children: [
                Image.asset(
                  'assets/icons/wallet_connect.png',
                  width: 60,
                  height: 60,
                  // If the asset doesn't exist, you can use a placeholder icon
                  errorBuilder: (context, error, stackTrace) => Icon(
                    Icons.account_balance_wallet_outlined,
                    size: 60,
                    color: ColorConstants.primaryPurple,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Connect Your Wallet',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Connect your wallet to view your balance and make transactions',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 24),
                GestureDetector(
                  onTap: onConnectWalletTapped,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: ColorConstants.primaryPurple,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      'Connect Wallet',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        : Column(
            children: [
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.only(
                    left: 18, right: 18, top: 18, bottom: 18),
                decoration: BoxDecoration(
                  color: ColorConstants.primaryPurple,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Wallet Balance',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Row(
                          children: [
                            Text(
                              reownProvider.walletBalance.toStringAsFixed(2),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 32,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'SOL',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 8),
                          ],
                        ),
                        const SizedBox(width: 4),
                        Image.asset(
                          'assets/icons/people_logo_wallet.png',
                          width: 32,
                          height: 32,
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 8),
                          decoration: BoxDecoration(
                            color: ColorConstants.darkBackground,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: GestureDetector(
                            onTap: onBuyTapped,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.asset(
                                  'assets/icons/download_icon.png',
                                  width: 16,
                                  height: 16,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  'Buy \$people',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    // Text(
                    //   '=63.00905',
                    //   style: TextStyle(
                    //     color: Colors.white.withOpacity(0.7),
                    //     fontSize: 16,
                    //   ),
                    // ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: onDepositTapped,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            color: ColorConstants.secondaryBackground,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/icons/download_icon.png',
                                width: 28,
                                height: 28,
                              ),
                              const SizedBox(width: 12),
                              const Text(
                                'Deposit',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: GestureDetector(
                        onTap: onWithdrawTapped,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            color: ColorConstants.secondaryBackground,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/icons/upload_icon.png',
                                width: 28,
                                height: 28,
                              ),
                              const SizedBox(width: 12),
                              const Text(
                                'Withdraw',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          );
  }
}

class _ActionButton extends StatelessWidget {
  final String icon;
  final String label;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            icon,
            width: 20,
            height: 20,
            color: Colors.white,
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class SocialNetworthCard extends StatelessWidget {
  final ReownProvider reownProvider;
  final double percentageChange;

  const SocialNetworthCard({
    Key? key,
    required this.reownProvider,
    required this.percentageChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: ColorConstants.secondaryBackground,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.trending_up,
                      color: Colors.green[300],
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Portfolio Value',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                FutureBuilder<double>(
                  future: reownProvider.calculateTotalPortfolioValue(),
                  builder: (context, snapshot) {
                    final totalValue = snapshot.data ?? 0.0;
                    return Text(
                      '\$${totalValue.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  },
                ),
                Row(
                  children: [
                    Icon(
                      percentageChange > 0
                          ? Icons.arrow_drop_up
                          : Icons.arrow_drop_down,
                      color: percentageChange > 0 ? Colors.green : Colors.red,
                    ),
                    Text(
                      '${percentageChange.toStringAsFixed(2)}% today',
                      style: TextStyle(
                        color: percentageChange > 0 ? Colors.green : Colors.red,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(6),
                bottomRight: Radius.circular(6),
              ),
              child: SizedBox(
                width: 150,
                child: Image.asset(
                  'assets/icons/social_worth.png',
                  alignment: Alignment.centerRight,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AssetsTabView extends StatelessWidget {
  final TabController tabController;
  final List<Token> tokens;
  final List<NFT> nfts;
  final bool isLoadingTokens;
  final VoidCallback? onRefresh;

  const AssetsTabView({
    Key? key,
    required this.tabController,
    required this.tokens,
    required this.nfts,
    this.isLoadingTokens = false,
    this.onRefresh,
  }) : super(key: key);

  // Helper method to format large numbers
  String _formatBalance(double balance) {
    if (balance == 0) return '0';
    
    if (balance >= 1000000000) {
      // Billions
      return '${(balance / 1000000000).toStringAsFixed(2)}B';
    } else if (balance >= 1000000) {
      // Millions
      return '${(balance / 1000000).toStringAsFixed(2)}M';
    } else if (balance >= 1000) {
      // Thousands
      return '${(balance / 1000).toStringAsFixed(2)}K';
    } else if (balance >= 1) {
      // Regular numbers
      return balance.toStringAsFixed(4);
    } else {
      // Very small numbers
      return balance.toStringAsFixed(8);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(left: 16, right: 16),
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: ColorConstants.secondaryBackground,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: ColorConstants.secondaryBackground,
                borderRadius: BorderRadius.circular(6),
              ),
              child: TabBar(
                controller: tabController,
                tabs: const [
                  Tab(text: 'Tokens'),
                  Tab(text: 'NFTs'),
                ],
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white,
                labelStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                indicator: const CustomTabIndicator(
                  color: ColorConstants.primaryPurple,
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                padding: EdgeInsets.zero,
                labelPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                indicatorPadding: EdgeInsets.all(2),
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: tabController,
                children: [
                  _buildTokensList(),
                  _buildNFTsGrid(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTokensList() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              const Text(
                'Token Name',
                style: TextStyle(
                  color: Color(0X60FFFFFF),
                  fontSize: 12,
                ),
              ),
              const Spacer(),
              const Text(
                'Balance',
                style: TextStyle(
                  color: Color(0X60FFFFFF),
                  fontSize: 12,
                ),
              ),
              const SizedBox(width: 60),
              const Text(
                '24H change',
                style: TextStyle(
                  color: Color(0X60FFFFFF),
                  fontSize: 12,
                ),
              ),
              if (onRefresh != null) ...[
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: onRefresh,
                  child: const Icon(
                    Icons.refresh,
                    color: Color(0X60FFFFFF),
                    size: 16,
                  ),
                ),
              ],
            ],
          ),
        ),
        Expanded(
          child: isLoadingTokens
              ? const Center(
                  child: CircularProgressIndicator(
                    color: ColorConstants.primaryPurple,
                  ),
                )
              : tokens.isEmpty
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.account_balance_wallet_outlined,
                            size: 48,
                            color: Colors.white54,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'No tokens found',
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Connect your wallet to view tokens',
                            style: TextStyle(
                              color: Colors.white38,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: tokens.length,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemBuilder: (context, index) {
                        final token = tokens[index];
                        return Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Colors.white.withOpacity(0.05),
                                width: 1,
                              ),
                            ),
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 20,
                                backgroundColor: Colors.grey[800],
                                child: token.imageUrl.startsWith('http')
                                    ? ClipOval(
                                        child: Image.network(
                                          token.imageUrl,
                                          width: 40,
                                          height: 40,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) {
                                            return Container(
                                              width: 40,
                                              height: 40,
                                              decoration: BoxDecoration(
                                                color: Colors.grey[800],
                                                shape: BoxShape.circle,
                                              ),
                                              child: Center(
                                                child: Text(
                                                  token.symbol.isNotEmpty 
                                                      ? token.symbol.substring(0, 1).toUpperCase()
                                                      : '?',
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                          loadingBuilder: (context, child, loadingProgress) {
                                            if (loadingProgress == null) return child;
                                            return Container(
                                              width: 40,
                                              height: 40,
                                              decoration: BoxDecoration(
                                                color: Colors.grey[800],
                                                shape: BoxShape.circle,
                                              ),
                                              child: const Center(
                                                child: SizedBox(
                                                  width: 20,
                                                  height: 20,
                                                  child: CircularProgressIndicator(
                                                    strokeWidth: 2,
                                                    color: Colors.white54,
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      )
                                    : token.imageUrl.startsWith('assets')
                                        ? ClipOval(
                                            child: Image.asset(
                                              token.imageUrl,
                                              width: 40,
                                              height: 40,
                                              fit: BoxFit.cover,
                                              errorBuilder: (context, error, stackTrace) {
                                                return Text(
                                                  token.symbol.isNotEmpty 
                                                      ? token.symbol.substring(0, 1).toUpperCase()
                                                      : '?',
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                  ),
                                                );
                                              },
                                            ),
                                          )
                                        : Text(
                                            token.symbol.isNotEmpty 
                                                ? token.symbol.substring(0, 1).toUpperCase()
                                                : '?',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                flex: 3,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      token.name,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      token.symbol,
                                      style: const TextStyle(
                                        color: Color(0xFF666666),
                                        fontSize: 13,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                flex: 2,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      _formatBalance(token.price),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      token.symbol,
                                      style: const TextStyle(
                                        color: Color(0xFF666666),
                                        fontSize: 12,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              SizedBox(
                                width: 60,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Icon(
                                      token.priceChange > 0
                                          ? Icons.arrow_drop_up
                                          : Icons.arrow_drop_down,
                                      color: token.priceChange > 0
                                          ? const Color(0xFF4CAF50)
                                          : const Color(0xFFE53935),
                                      size: 16,
                                    ),
                                    Flexible(
                                      child: Text(
                                        '${token.priceChange.abs().toStringAsFixed(1)}%',
                                        style: TextStyle(
                                          color: token.priceChange > 0
                                              ? const Color(0xFF4CAF50)
                                              : const Color(0xFFE53935),
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
        ),
      ],
    );
  }

  Widget _buildNFTsGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1,
      ),
      itemCount: nfts.length,
      itemBuilder: (context, index) {
        final nft = nfts[index];
        return Container(
          decoration: BoxDecoration(
            color: ColorConstants.darkBackground,
            borderRadius: BorderRadius.circular(12),
            image: DecorationImage(
              image: AssetImage(nft.imageUrl),
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                bottom: 8,
                left: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '#${nft.id} ${nft.name}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class DepositDialog extends StatelessWidget {
  const DepositDialog({Key? key}) : super(key: key);

  void _copyToClipboard(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text)).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Address copied to clipboard'),
          duration: Duration(seconds: 2),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    const walletAddress = '0xdc933c28d8d79c4170c3e68c92';
    return Dialog(
      backgroundColor: ColorConstants.darkBackground,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Deposit',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Send token to the address below to fund your wallet for ticket purchases',
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _buildDropdownField('Asset', 'USDC'),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildDropdownField('Network', 'TRC20'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Wallet Address',
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      walletAddress,
                      style: const TextStyle(color: Colors.white),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.copy_all_rounded,
                            color: Colors.white70),
                        onPressed: () =>
                            _copyToClipboard(context, walletAddress),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF7662E7),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        onPressed: () =>
                            _copyToClipboard(context, walletAddress),
                        child: const Text(
                          'Copy',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white70),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(value, style: const TextStyle(color: Colors.white)),
              const Icon(Icons.keyboard_arrow_down, color: Colors.white),
            ],
          ),
        ),
      ],
    );
  }
}

class WithdrawDialog extends StatefulWidget {
  const WithdrawDialog({Key? key}) : super(key: key);

  @override
  State<WithdrawDialog> createState() => _WithdrawDialogState();
}

class _WithdrawDialogState extends State<WithdrawDialog> {
  final TextEditingController _amountController = TextEditingController();
  bool isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF1A1A1A),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Withdraw',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Wallet Balance',
              style: TextStyle(color: Colors.white70),
            ),
            const Text(
              '234 \$people',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Withdrawal Amount',
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _amountController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.black,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: BorderSide.none,
                ),
                hintText: 'Enter amount',
                hintStyle: TextStyle(color: Colors.grey[600]),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isProcessing ? null : () => _handleWithdraw(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorConstants.primaryPurple,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                child: isProcessing
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        'Withdraw',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleWithdraw() async {
    setState(() => isProcessing = true);
    await Future.delayed(const Duration(seconds: 2)); // Simulate API call
    if (mounted) {
      setState(() => isProcessing = false);
      Navigator.pop(context);
      _showSuccessDialog();
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: const Color(0xFF1A1A1A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Column(
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 48,
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Success!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Withdrawal Successful',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BuyDialog extends StatefulWidget {
  const BuyDialog({Key? key}) : super(key: key);

  @override
  State<BuyDialog> createState() => _BuyDialogState();
}

class _BuyDialogState extends State<BuyDialog> {
  final TextEditingController _amountController = TextEditingController();
  bool isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF1A1A1A),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Buy \$people',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _amountController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Amount in USD',
                labelStyle: TextStyle(color: Colors.grey[400]),
                filled: true,
                fillColor: Colors.grey[900],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                prefixIcon:
                    const Icon(Icons.attach_money, color: Colors.white70),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 24),
            const Text(
              'You will receive:',
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '\$people',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '≈ 234.5',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorConstants.primaryPurple,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: isProcessing
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'Buy Now',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
