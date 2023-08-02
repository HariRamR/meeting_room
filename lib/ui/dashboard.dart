import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../blocs/dashboard/dashboard_bloc.dart';
import '../res/constants.dart';
import 'home_screen.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final PageController controller = PageController(initialPage: 0);

  var pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    var bloc = BlocProvider.of<DashboardBloc>(context);

    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Constants.primaryDarkClr,
          bottomNavigationBar: BottomNavigationBar(
            onTap: (pos) {
              controller.jumpToPage(pos);
              pageIndex = pos;
              bloc.add(BottomNavEvent(pos));
            },
            showSelectedLabels: false,
            showUnselectedLabels: false,
            selectedItemColor: Constants.selectedColor,
            unselectedItemColor: Constants.bottomNavIconClr,
            backgroundColor: Constants.primaryClr,
            iconSize: Constants.d20,
            currentIndex: pageIndex,
            items: const [
              BottomNavigationBarItem(
                  icon: FaIcon(
                    FontAwesomeIcons.house,
                  ),
                  label: Constants.empty
              ),
              BottomNavigationBarItem(
                  icon: FaIcon(
                    FontAwesomeIcons.ticketSimple,
                  ),
                  label: Constants.empty
              ),
              BottomNavigationBarItem(
                  icon: FaIcon(
                    FontAwesomeIcons.solidFaceFrown,
                  ),
                  activeIcon: FaIcon(
                    FontAwesomeIcons.solidFaceSmile,
                  ),
                  label: Constants.empty
              ),
            ],
          ),
          body: SafeArea(
            child: PageView(
              controller: controller,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                HomeScreen(),
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(Constants.d16),
                    child: Text(
                      "You haven't booked any ticket, let's book now!!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: Constants.d20,
                          color: Constants.secondaryTextClr,
                      ),
                    ),
                  ),
                ),
                const Center(
                  child: Text(
                    "Profile",
                    style: TextStyle(
                        fontSize: Constants.d20, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
