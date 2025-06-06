import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:pickleball_app/core/blocs/app_bloc.dart';
import 'package:pickleball_app/core/blocs/app_state.dart';
import 'package:pickleball_app/core/constants/app_strings.dart';
import 'package:pickleball_app/core/models/models.dart';
import 'package:pickleball_app/core/themes/app_colors.dart';
import 'package:pickleball_app/core/themes/app_theme.dart';
import 'package:pickleball_app/core/widgets/app_bar_widget.dart';
import 'package:pickleball_app/core/widgets/search_bar_widget.dart';
import 'package:pickleball_app/features/tournament_manage/bloc/tournaments_bloc.dart';
import 'package:pickleball_app/features/tournament_manage/bloc/tournaments_event.dart';
import 'package:pickleball_app/features/tournament_manage/bloc/tournaments_state.dart';
import 'package:pickleball_app/features/tournament_manage/widgets/tournament_widget.dart';
import 'package:pickleball_app/router/router.gr.dart';

import '../../../core/constants/app_enums.dart';

@RoutePage()
class TournamentManageScreen extends StatefulWidget {
  const TournamentManageScreen({super.key});

  @override
  State<TournamentManageScreen> createState() => _TournamentManageScreenState();
}

class _TournamentManageScreenState extends State<TournamentManageScreen>
    with RouteAware, TickerProviderStateMixin {
  late final TabController _controller;
  final TextEditingController _searchController = TextEditingController();
  String searchQuery = "";
  String selectedTournamentType = "All"; // Added for filtering
  bool isPlayer = true;
  StackRouter? _stackRouter;
  bool _showFilters = false; // Added for filter toggle

  @override
  void initState() {
    super.initState();
    context.read<TournamentBloc>().add(LoadAllTournaments());
    final appBloc = context.read<AppBloc>();
    final appState = appBloc.state;
    if (appState is AppAuthenticatedPlayer) {
      isPlayer = true;
    } else if (appState is AppAuthenticatedSponsor) {
      isPlayer = false;
    }
    _controller = TabController(length: isPlayer ? 3 : 2, vsync: this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (mounted) {
      _stackRouter = AutoRouter.of(context);
      _stackRouter?.addListener(_onRouteChanged);
    }
  }

  void _onRouteChanged() {
    if (_stackRouter?.current.name == MainNavigation.name) {
      context.read<TournamentBloc>().add(LoadAllTournaments());
    }
  }

  @override
  void didPopNext() {
    context.read<TournamentBloc>().add(LoadAllTournaments());
  }

  @override
  void dispose() {
    _controller.dispose();
    _searchController.dispose();
    if (mounted) {
      _stackRouter?.removeListener(_onRouteChanged);
    }
    super.dispose();
  }

  Widget _buildSearchBar() {
    return SearchBarWidget(
      controller: _searchController,
      onChanged: (value) {
        setState(() {
          searchQuery = value.toLowerCase();
        });
      },
    );
  }

  Widget _buildFilterSection() {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.category, color: Colors.white, size: 16),
              const SizedBox(width: 4),
              const Text(
                'Tournament Type',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const Spacer(),
              if (selectedTournamentType != "All")
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedTournamentType = "All";
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.refresh, color: Colors.white, size: 12),
                        SizedBox(width: 4),
                        Text(
                          'Reset',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          DropdownButton<String>(
            value: selectedTournamentType,
            dropdownColor: AppColors.primaryColor,
            items: [
              const DropdownMenuItem(value: "All", child: Text("All")),
              ...MatchFormat.values.map((format) {
                return DropdownMenuItem(
                  value: format.label.toString(),
                  child: Text(format.subLabel),
                );
              }),
            ],
            onChanged: (value) {
              setState(() {
                selectedTournamentType = value!;
              });
            },
            style: const TextStyle(color: Colors.white),
            icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return TabBar(
      controller: _controller,
      tabs: [
        const Tab(text: 'Tournaments'),
        Tab(text: isPlayer ? 'Participated' : 'Sponsored'),
        if (isPlayer) const Tab(text: 'Requested'),
      ],
      labelColor: Colors.white,
      unselectedLabelColor: Colors.grey,
      indicatorColor: Colors.white,
      indicatorSize: TabBarIndicatorSize.tab,
      indicatorWeight: isPlayer?3:2,
      labelStyle: AppTheme.getTheme(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
    );
  }

  Widget _buildTournamentList(
      List<Tournament> tournaments, List<Map<String, dynamic>> numberPlayers) {
    final filteredTournaments = tournaments.where((tournament) {
      final matchesSearchQuery = tournament.name.toLowerCase().contains(searchQuery);
      final matchesTypeFilter = selectedTournamentType == "All" ||
          tournament.type == selectedTournamentType;
      return matchesSearchQuery && matchesTypeFilter;
    }).toList();

    if (filteredTournaments.isEmpty) {
      return Center(
      child: Card(
        elevation: 0, // No shadow
        color: Colors.white,
        shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
          Icon(
            Icons.event_busy,
            size: 60,
            color: AppColors.primaryColor,
          ),
          SizedBox(height: 16),
          Text(
            'No tournaments found',
            style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryColor,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Try adjusting your filters or search terms',
            textAlign: TextAlign.center,
            style: TextStyle(
            fontSize: 14,
            color: Colors.grey,
            ),
          ),
          ],
        ),
        ),
      ),
      );
    }

    return ListView.builder(
      itemCount: filteredTournaments.length,
      itemBuilder: (context, index) {
        final tournament = filteredTournaments[index];
        bool isWebsite =
            Uri.tryParse(tournament.banner)?.hasAbsolutePath ?? false;
        return TournamentWidget(
          onTap: () {
            context.read<TournamentBloc>().add(SelectTournament(tournament.id));
          },
          title: tournament.name,
          location: tournament.location,
          maxPlayers:
              '${numberPlayers[index]['numberPlayer']}/${tournament.maxPlayer}',
          description: null,
          startDate: tournament.startDate,
          endDate: tournament.endDate,
          type: tournament.type,
          status: tournament.status,
          note: tournament.note,
          banner: isWebsite ? tournament.banner : AppStrings.bannerUrl,
          isMaxRanking: tournament.isMaxRanking,
          isMinRanking: tournament.isMinRanking,
          isFree: tournament.isFree,
          entryFee: tournament.entryFee,
          totalPrize: tournament.totalPrize,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TournamentBloc, TournamentState>(
      listener: (context, state) {
        if (state is TournamentDetailLoading) {
          AutoRouter.of(context).push(DetailTournamentRoute());
        }
      },
      child: BlocBuilder<TournamentBloc, TournamentState>(
          builder: (context, state) {
        List<Tournament> tournaments = [];
        List<Tournament> myTournaments = [];
        if (state is TournamentLoading) {
          return Center(
              child: LoadingAnimationWidget.threeRotatingDots(
            color: AppColors.primaryColor,
            size: 30,
          ));
        } else if (state is TournamentLoaded) {
          tournaments = state.allTournaments;
          myTournaments = state.myTournaments;
          return Scaffold(
            appBar: AppBarWidget(
              title: 'Tournaments',
              isPlayer: isPlayer,
              automaticallyImplyLeading: false,
            ),
            body: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: AppColors.defaultGradient,
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(child: _buildSearchBar()),
                        IconButton(
                          icon: Icon(
                            _showFilters
                                ? Icons.filter_list_off
                                : Icons.filter_list,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            setState(() {
                              _showFilters = !_showFilters;
                            });
                          },
                          tooltip: _showFilters ? 'Hide filters' : 'Show filters',
                        ),// Adjusted layout
                      ],
                    ),
                    if (_showFilters) _buildFilterSection(), // Show filters conditionally
                    _buildTabBar(),
                    Expanded(
                      child: state is TournamentLoading
                          ? Center(
                              child: LoadingAnimationWidget.threeRotatingDots(
                                color: Colors.white,
                                size: 30,
                              ),
                            )
                          : state is TournamentError
                              ? Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Icon(
                                        Icons.hourglass_empty,
                                        size: 80,
                                        color: Colors.white,
                                      ),
                                    ],
                                  ),
                                )
                              : TabBarView(
                                  controller: _controller,
                                  children: [
                                    _buildTournamentList(
                                        tournaments, state.numberPlayers),
                                    _buildTournamentList(myTournaments,
                                        state.myTournamentNumberPlayers),
                                    if (isPlayer &&
                                        state.requestJoinTournaments != null &&
                                        state.numberPlayersRequest != null) ...[
                                      _buildTournamentList(
                                          state.requestJoinTournaments!,
                                          state.numberPlayersRequest!),
                                    ]
                                  ],
                                ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      }),
    );
  }
}
