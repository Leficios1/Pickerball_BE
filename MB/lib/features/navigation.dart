import 'package:auto_route/auto_route.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pickleball_app/core/blocs/app_bloc.dart';
import 'package:pickleball_app/core/blocs/app_state.dart';
import 'package:pickleball_app/core/themes/app_colors.dart';
import 'package:pickleball_app/router/router.gr.dart';

@RoutePage()
class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<StatefulWidget> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  late List<PageRouteInfo> routers = [];
  late List icons = [];

  @override
  void initState() {
    super.initState();
    final appBloc = context.read<AppBloc>();
    final appState = appBloc.state;
    final isAuthenticated =
        appState is AppAuthenticatedPlayer || appState is AppAuthenticatedSponsor;
    routers = isAuthenticated
        ? [
      HomeRoute(),
      RankRoute(),
      MatchesRoute(),
      TournamentManageRoute(),
      SettingRoute()
    ]
        : [HomeRoute(), RankRoute(), SettingRoute()];
    icons = isAuthenticated
        ? [
      Icons.home,
      Icons.bar_chart,
      Icons.stadium,
      Icons.tour_sharp,
      Icons.settings,
    ]
        : [
      Icons.home,
      Icons.bar_chart,
      Icons.settings,
    ];
  }

  @override
  Widget build(BuildContext context) {
    return AutoTabsRouter(
      routes: routers,
      transitionBuilder: (context, child, animation) =>
          FadeTransition(opacity: animation, child: child),
      builder: (context, child) {
        final tabsRouter = AutoTabsRouter.of(context);

        if (tabsRouter.activeIndex >= icons.length) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            tabsRouter.setActiveIndex(0);
          });
        }

        return Scaffold(
          body: child,
          bottomNavigationBar: CurvedNavigationBar(
            index: tabsRouter.activeIndex,
            height: 60.0,
            items: List.generate(
              icons.length,
                  (index) => Icon(
                icons[index],
                size: 30,
                color: tabsRouter.activeIndex == index
                    ? Colors.white
                    : Colors.grey,
              ),
            ),
            color: Colors.white,
            buttonBackgroundColor: AppColors.primaryColor,
            backgroundColor: Colors.white,
            animationCurve: Curves.easeInOut,
            animationDuration: const Duration(milliseconds: 300),
            onTap: (index) {
              if (index < icons.length) {
                tabsRouter.setActiveIndex(index);
              }
            },
            letIndexChange: (index) => true,
          ),
        );
      },
    );
  }
}
