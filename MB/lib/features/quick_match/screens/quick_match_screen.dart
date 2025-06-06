import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:pickleball_app/core/blocs/app_bloc.dart';
import 'package:pickleball_app/core/blocs/app_state.dart';
import 'package:pickleball_app/core/constants/app_enums.dart';
import 'package:pickleball_app/core/themes/app_colors.dart';
import 'package:pickleball_app/core/themes/app_theme.dart';
import 'package:pickleball_app/core/utils/snackbar_helper.dart';
import 'package:pickleball_app/core/widgets/app_bar_widget.dart';
import 'package:pickleball_app/features/quick_match/bloc/quick_match_bloc.dart';
import 'package:pickleball_app/features/quick_match/bloc/quick_match_event.dart';
import 'package:pickleball_app/features/quick_match/bloc/quick_match_state.dart';
import 'package:pickleball_app/router/router.gr.dart';

@RoutePage()
class QuickMatchScreen extends StatefulWidget {
  const QuickMatchScreen({super.key});

  @override
  _QuickMatchScreenState createState() => _QuickMatchScreenState();
}

class _QuickMatchScreenState extends State<QuickMatchScreen> with RouteAware {
  bool _isSearchingInitiated = false;
  bool _isConnecting = false;
  StackRouter? _stackRouter;

  @override
  void initState() {
    super.initState();
    // Load user info when screen initializes
    context.read<QuickMatchBloc>().add(LoadUserInfoEvent());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Reset state and reload user info when returning to this screen
    if (mounted) {
      _stackRouter = AutoRouter.of(context);
      _stackRouter?.addListener(_onRouteChanged);
    }
  }

  void _onRouteChanged() {
    if (_stackRouter?.current.name == QuickMatchRoute.name && mounted) {
      context.read<QuickMatchBloc>().add(LoadUserInfoEvent());
    }
  }

  @override
  void dispose() {
    // Clean up resources when widget is disposed
    _stackRouter?.removeListener(_onRouteChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: 'Quick Match',
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: AppColors.defaultGradient,
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: BlocConsumer<QuickMatchBloc, QuickMatchState>(
          listener: (context, state) {
            if (!mounted) return; // Prevent accessing state if widget is unmounted

            if (state is QuickMatchError) {
              setState(() {
                _isSearchingInitiated = false;
                _isConnecting = false;
              });
              SnackbarHelper.showSnackBar(state.message);
            } else if (state is QuickMatchCancelled) {
              if (mounted) {
                setState(() {
                  _isSearchingInitiated = false;
                  _isConnecting = false;
                });
                SnackbarHelper.showSnackBar('Match search cancelled');
                // Add this line to reload user info after cancellation
                context.read<QuickMatchBloc>().add(LoadUserInfoEvent());
              }
            } else if (state is QuickMatchSearching) {
              setState(() {
                _isConnecting = true;
              });
            } else if (state is QuickMatchFound) {
              setState(() {
                _isConnecting = false;
                _isSearchingInitiated = true;
              });
              SnackbarHelper.showSnackBar('Match found! Creating match room...');
              // Navigate to match detail screen after a short delay
              Future.delayed(Duration(seconds: 2), () {
                if (mounted) {
                  AutoRouter.of(context).push(DetailMatchRoute());
                }
              });
            }
          },
          builder: (context, state) {
            if (state is QuickMatchSearching && _isSearchingInitiated) {
              return _buildSearchingUI();
            } else if (state is LoadUserInfo) {
              return _buildMatchInfoUI(context, state);
            } else {
              return Center(
                child: LoadingAnimationWidget.threeRotatingDots(
                  color: Colors.white,
                  size: 40,
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildMatchInfoUI(BuildContext context, LoadUserInfo state) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Player Information
          _buildInfoRow(context, 'Player:', state.userName),
          const SizedBox(height: 16),

          // City Information
          _buildInfoRow(context, 'City:', state.city),
          const SizedBox(height: 16),

          // Match Format Information
          _buildInfoRow(context, 'Match Format:', TournamentFormant.fromValue(state.matchFormat)!.subLabel),
          const SizedBox(height: 16),

          // Ranking Information
          _buildInfoRow(context, 'Ranking:', RankLevel.fromValue(state.ranking)!.label),
          const SizedBox(height: 32),

          // Find Match Button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _isConnecting
                  ? null
                  : () {
                      setState(() => _isSearchingInitiated = true);
                      context.read<QuickMatchBloc>().add(
                            StartQuickMatch(
                              city: state.city,
                              matchFormat: state.matchFormat,
                              ranking: state.ranking,
                              context: context,
                            ),
                          );
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _isConnecting
                  ? LoadingAnimationWidget.threeRotatingDots(
                      color: AppColors.primaryColor,
                      size: 24,
                    )
                  : Text(
                      'Find Match',
                      style: TextStyle(
                        color: AppColors.primaryColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchingUI() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          LoadingAnimationWidget.threeRotatingDots(
            color: Colors.white,
            size: 50,
          ),
          const SizedBox(height: 24),
          Text(
            _isConnecting ? 'Connecting to server...' : 'Searching for match...',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: () {
              context.read<QuickMatchBloc>().add(CancelQuickMatch());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: AppColors.primaryColor,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
