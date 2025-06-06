import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:pickleball_app/core/blocs/app_bloc.dart';
import 'package:pickleball_app/core/themes/app_colors.dart';
import 'package:pickleball_app/core/themes/app_theme.dart';
import 'package:pickleball_app/core/widgets/app_bar_widget.dart';
import 'package:pickleball_app/core/widgets/emptyStateCard.dart';
import 'package:pickleball_app/features/match/bloc/match_bloc.dart';
import 'package:pickleball_app/features/match/bloc/match_state.dart';
import 'package:pickleball_app/features/setting/bloc/settings_bloc.dart';
import 'package:pickleball_app/features/setting/bloc/settings_event.dart';
import 'package:pickleball_app/features/setting/bloc/settings_state.dart';
import 'package:pickleball_app/features/setting/widgets/notification_widget.dart';
import 'package:pickleball_app/features/tournament_manage/bloc/tournaments_bloc.dart';
import 'package:pickleball_app/features/tournament_manage/bloc/tournaments_state.dart';
import 'package:pickleball_app/router/router.gr.dart';

@RoutePage()
class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  Timer? _timer;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Initial load
    context.read<SettingsBloc>().add(LoadAllNotifications());
    _startAutoRefresh();
  }

  void _startAutoRefresh() {
    _timer = Timer.periodic(const Duration(seconds: 30), (timer) {
      if (mounted) {
        context.read<SettingsBloc>().add(LoadAllNotifications());
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications', style: AppTheme.getTheme(context).textTheme.displayMedium?.copyWith(
            color: Colors.white
        ),),
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<SettingsBloc>().add(LoadAllNotifications());
            },
          ),
        ],
        backgroundColor: AppColors.primaryColor,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<SettingsBloc>().add(LoadAllNotifications());
          return Future.delayed(const Duration(milliseconds: 1000));
        },
        child: Container(
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: AppColors.defaultGradient,
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: MultiBlocListener(
            listeners: [
              BlocListener<MatchBloc, MatchState>(
                  listener: (context, state){
                    if (state is MatchDetailLoading) {
                      AutoRouter.of(context).push(DetailMatchRoute());
                    }
                  }),
              BlocListener<TournamentBloc, TournamentState>(listener: (context, state){
                if (state is TournamentDetailLoading) {
                  AutoRouter.of(context).push(DetailTournamentRoute());
                }
              })
            ],
            child: BlocBuilder<SettingsBloc, SettingsState>(
              builder: (context, state) {
                if (state is SettingsLoading) {
                  return  Center(
                      child: LoadingAnimationWidget.threeRotatingDots(
                        color: AppColors.primaryColor,
                        size: 30,
                      ));
                } else if (state is SettingsLoaded) {
                  final notifications = state.notifications;
                  if (notifications.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          EmptyStateCard(
                              icon: Icons.notifications_off,
                              title: 'No Notifications',
                              description: 'You have no notifications at this time.'),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    controller: _scrollController,
                    itemCount: notifications.length,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemBuilder: (context, index) {
                      return NotificationItemWidget(
                        notification: notifications[index],
                      );
                    },
                  );
                } else if (state is SettingsError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline, size: 48, color: Colors.red),
                        const SizedBox(height: 16),
                        Text('Error: ${state.message}'),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            context.read<SettingsBloc>().add(LoadAllNotifications());
                          },
                          child: const Text('Try Again'),
                        ),
                      ],
                    ),
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ),

      ),
    );
  }
}