// lib/providers/navigation_provider.dart
import 'package:flutter/material.dart';

class MainProvider extends ChangeNotifier {
  int _selectedIndex = 0;
  PageController _pageController = PageController();

  int get selectedIndex => _selectedIndex;
  PageController get pageController => _pageController;

  void setIndex(int index) {
    _selectedIndex = index;
    _pageController.jumpToPage(index);
    notifyListeners();
  }

  void updateIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
