import 'package:flutter/material.dart';
import 'package:peopleapp_flutter/core/constants/color_constants.dart';
import 'package:peopleapp_flutter/features/activity/activity_screen.dart';
import 'package:peopleapp_flutter/features/dashboard/dashboard_screen.dart';
import 'package:peopleapp_flutter/features/main/provider/main_provider.dart';
import 'package:peopleapp_flutter/features/more/more_screen.dart';
import 'package:peopleapp_flutter/features/wallet/wallet_screen.dart';
import 'package:reown_appkit/modal/appkit_modal_impl.dart';
import '../../explore/explore_screen.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatelessWidget {
  final ReownAppKitModal? appKitModal;
  const MainScreen({super.key, this.appKitModal});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MainProvider(),
      child: Consumer<MainProvider>(
        builder: (context, mainProvider, _) {
          return Scaffold(
            backgroundColor: ColorConstants.darkBackground,
            body: Padding(
              padding: const EdgeInsets.only(top: 40),
              child: PageView(
                physics: const NeverScrollableScrollPhysics(),
                controller: mainProvider.pageController,
                onPageChanged: (index) => mainProvider.updateIndex(index),
                children: [
                  DashboardScreen(),
                  ExploreScreen(),
                  WalletScreen(),
                  ActivityScreen(),
                  MoreScreen(),
                ],
              ),
            ),
            bottomNavigationBar: Container(
              height: 80,
              decoration: BoxDecoration(
                color: ColorConstants.darkBackground,
                border: Border(
                  top: BorderSide(
                    color: Colors.white.withOpacity(0.1),
                  ),
                ),
              ),
              child: Theme(
                data: Theme.of(context).copyWith(
                  canvasColor: ColorConstants.darkBackground,
                ),
                child: BottomNavigationBar(
                  currentIndex: mainProvider.selectedIndex,
                  onTap: (index) => mainProvider.setIndex(index),
                  backgroundColor: ColorConstants.darkBackground,
                  selectedItemColor: ColorConstants.primaryPurple,
                  unselectedItemColor: Colors.white.withOpacity(0.5),
                  type: BottomNavigationBarType.fixed,
                  items: [
                    BottomNavigationBarItem(
                      icon: Image.asset(
                        'assets/icons/home_icon.png',
                        height: 24,
                        color: mainProvider.selectedIndex == 0
                            ? ColorConstants.primaryPurple
                            : Colors.white.withOpacity(0.5),
                      ),
                      label: 'Home',
                    ),
                    BottomNavigationBarItem(
                      icon: Image.asset(
                        'assets/icons/explore_icon.png',
                        height: 24,
                        color: mainProvider.selectedIndex == 1
                            ? ColorConstants.primaryPurple
                            : Colors.white.withOpacity(0.5),
                      ),
                      label: 'Explore',
                    ),
                    BottomNavigationBarItem(
                      icon: Image.asset(
                        'assets/icons/wallet_icon.png',
                        height: 24,
                        color: mainProvider.selectedIndex == 2
                            ? ColorConstants.primaryPurple
                            : Colors.white.withOpacity(0.5),
                      ),
                      label: 'Wallet',
                    ),
                    BottomNavigationBarItem(
                      icon: Image.asset(
                        'assets/icons/activity_icon.png',
                        height: 24,
                        color: mainProvider.selectedIndex == 3
                            ? ColorConstants.primaryPurple
                            : Colors.white.withOpacity(0.5),
                      ),
                      label: 'Activity',
                    ),
                    BottomNavigationBarItem(
                      icon: Image.asset(
                        'assets/icons/more_icon.png',
                        height: 24,
                        color: mainProvider.selectedIndex == 4
                            ? ColorConstants.primaryPurple
                            : Colors.white.withOpacity(0.5),
                      ),
                      label: 'More',
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
