import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:restaurant_app/common/theme/theme.dart';
import 'package:restaurant_app/ui/pages/favorite_screen.dart';
import 'package:restaurant_app/ui/pages/home_screen.dart';
import 'package:restaurant_app/ui/pages/setting_screen.dart';

class HomeBottomNavbar extends StatefulWidget {
  const HomeBottomNavbar({Key? key}) : super(key: key);

  @override
  _HomeBottomNavbarState createState() => _HomeBottomNavbarState();
}

class _HomeBottomNavbarState extends State<HomeBottomNavbar> {
  late PageController _pageController;
  int _selectedPage = 0;

  final List<Widget> _page = const [
    HomeScreen(),
    FavoriteScreen(),
    SettingsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedPage = index;
      _pageController.jumpToPage(index);
    });
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        onPageChanged: (index) {
          setState(() {
            _selectedPage = index;
          });
        },
        controller: _pageController,
        children: _page,
      ),
      bottomNavigationBar: FlashyTabBar(
        selectedIndex: _selectedPage,
        showElevation: false,
        onItemSelected: (index) => _onItemTapped(index),
        items: [
          FlashyTabBarItem(
            activeColor: yellowColor,
            inactiveColor: greyColor,
            icon: const Icon(Iconsax.home),
            title: const Text('Home'),
          ),
          FlashyTabBarItem(
            activeColor: yellowColor,
            inactiveColor: greyColor,
            icon: const Icon(Iconsax.star),
            title: const Text('Favorite'),
          ),
          FlashyTabBarItem(
            activeColor: yellowColor,
            inactiveColor: greyColor,
            icon: const Icon(Iconsax.setting),
            title: const Text('Settings'),
          ),
        ],
      ),
    );
  }
}
