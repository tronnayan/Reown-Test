import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:peopleapp_flutter/core/constants/color_constants.dart';
import 'package:peopleapp_flutter/core/utlites/wallet_formatter.dart';
import 'package:peopleapp_flutter/features/dashboard/provider/dashboard_provider.dart';
import 'package:peopleapp_flutter/features/main/provider/main_provider.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({
    super.key,
  });

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedFilterIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<DashboardProvider>().initializeWallet();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardProvider>(
        builder: (context, dashboardPrvider, child) {
      return Column(
        children: [
          _buildHeader(
            context: context,
            dashboardProvider: dashboardPrvider,
          ),
          _buildHeaderBanners(),
          const SizedBox(height: 20),
          _buildDashboardFilters(),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const SizedBox(height: 16),
                _buildPostCard(
                  'Sumit Gupta',
                  '@sumit',
                  'Subscribe to Sumit Gupta\'s YouTube channel now and claim my exclusive token instantly! Be part of the journey to financial freedom.',
                  '10 \$umit',
                ),
              ],
            ),
          ),
        ],
      );
    });
  }

  Widget _buildDashboardFilters() {
    final List<String> filters = [
      'Top',
      'Subscribe',
      'Comment',
      'Follow',
      'Like'
    ];

    return SizedBox(
      height: 40,
      child: Padding(
        padding: const EdgeInsets.only(left: 20),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: filters.length,
          itemBuilder: (BuildContext context, int index) {
            final isSelected = index == _selectedFilterIndex;
            final backgroundColor = isSelected
                ? ColorConstants.primaryPurple
                : ColorConstants.secondaryBackground;
            final textColor = isSelected ? Colors.white : Colors.white70;

            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedFilterIndex = index;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                margin: const EdgeInsets.only(right: 10),
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Center(
                  child: Text(
                    filters[index],
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // Widget _walletBalanceCard({required String balance}) {
  //   return Container(
  //     padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
  //     margin: const EdgeInsets.symmetric(horizontal: 16),
  //     decoration: BoxDecoration(
  //       color: ColorConstants.primaryPurple,
  //       borderRadius: BorderRadius.circular(14),
  //     ),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       children: [
  //         Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Text('Wallet Balance'),
  //             const SizedBox(height: 10),
  //             Row(
  //               children: [
  //                 Text(
  //                   balance,
  //                   style: const TextStyle(
  //                     fontSize: 20,
  //                     fontWeight: FontWeight.w700,
  //                     color: Colors.white,
  //                   ),
  //                 ),
  //                 const SizedBox(width: 12),
  //                 CircleAvatar(
  //                   radius: 12,
  //                   backgroundColor: ColorConstants.modalBackground,
  //                   child: Image.asset(
  //                     'assets/images/ic_currency_logo.png',
  //                     height: 12,
  //                   ),
  //                 ),
  //               ],
  //             ),
  //             const Text(
  //               '=100.112',
  //             ),
  //           ],
  //         ),
  //         Container(
  //           padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
  //           decoration: BoxDecoration(
  //             color: ColorConstants.modalBackground,
  //             borderRadius: BorderRadius.circular(12),
  //           ),
  //           child: Row(
  //             children: [
  //               Image.asset(
  //                 'assets/images/ic_recive.png',
  //                 height: 24,
  //               ),
  //               const SizedBox(width: 12),
  //               const Text(
  //                 'Buy \$people',
  //                 style: TextStyle(
  //                   fontSize: 16,
  //                   fontWeight: FontWeight.w800,
  //                   color: Colors.white,
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildHeaderBanners() {
    final List<String> imgList = [
      'assets/images/banner.png',
    ];
    return CarouselSlider(
      options: CarouselOptions(
        height: 100.0,
        autoPlay: true,
        enlargeCenterPage: true,
        aspectRatio: 16 / 9,
        viewportFraction: 0.8,
      ),
      items: imgList
          .map((item) => Container(
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                  child: Image.asset(
                    item,
                    fit: BoxFit.cover,
                    width: 1000.0,
                  ),
                ),
              ))
          .toList(),
    );
  }

  Widget _buildPostCard(
      String name, String handle, String content, String tokens) {
    return Card(
      color: Colors.black,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: const AssetImage('assets/default_user.png'),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      handle,
                      style: const TextStyle(color: ColorConstants.greyText),
                    ),
                  ],
                ),
                const Spacer(),
                const Icon(Icons.more_horiz, color: Colors.white),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              content,
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  tokens,
                  style: const TextStyle(color: ColorConstants.primaryPurple),
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorConstants.primaryPurple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text('Comment'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(
      {required BuildContext context,
      required DashboardProvider dashboardProvider}) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Image.asset('assets/images/people_logo.png', height: 24),
          const Spacer(),
          GestureDetector(
            onTap: () {
              context.read<MainProvider>().setIndex(2);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: ColorConstants.primaryPurple.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Text(
                    WalletFormatter.shortenAddress(
                        dashboardProvider.walletData?.walletAddress ?? ''),
                    style: const TextStyle(color: Colors.white),
                  ),
                  const Icon(Icons.keyboard_arrow_down, color: Colors.white),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
