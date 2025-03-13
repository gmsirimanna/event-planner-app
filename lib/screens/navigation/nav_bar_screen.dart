import 'package:event_planner/screens/more/more_screen.dart';
import 'package:event_planner/screens/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../../provider/nav_bar_provider.dart';
import '../../utils/images.dart';

class NavBarScreen extends StatelessWidget {
  const NavBarScreen({super.key});

  final List<Widget> _screens = const [
    HomeScreen(),
    MoreScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<NavBarProvider>(
      builder: (context, navProvider, child) {
        return Scaffold(
          body: IndexedStack(
            index: navProvider.currentNavIndex,
            children: _screens,
          ),
          bottomNavigationBar: Theme(
            data: Theme.of(context).copyWith(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              hoverColor: Colors.transparent,
            ),
            child: BottomNavigationBar(
              currentIndex: navProvider.currentNavIndex,
              onTap: (index) {
                navProvider.setNavBarIndex(index);
                FocusManager.instance.primaryFocus?.unfocus(); // Hide keyboard when switching tabs
              },
              backgroundColor: Colors.black,
              selectedItemColor: Colors.white, // Active tab color
              unselectedItemColor: Colors.grey, // Inactive tab color
              showUnselectedLabels: true,
              elevation: 0,
              type: BottomNavigationBarType.fixed,
              items: [
                BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    Images.home_icon,
                    color: navProvider.currentNavIndex == 0 ? Colors.white : Colors.grey,
                  ),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    Images.more_icon,
                    color: navProvider.currentNavIndex == 1 ? Colors.white : Colors.grey,
                  ),
                  label: 'More',
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
