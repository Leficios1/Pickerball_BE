import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_multi_select_items/flutter_multi_select_items.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:pickleball_app/core/blocs/app_bloc.dart';
import 'package:pickleball_app/core/blocs/app_state.dart';
import 'package:pickleball_app/core/constants/app_enums.dart';
import 'package:pickleball_app/core/themes/app_colors.dart';
import 'package:pickleball_app/core/themes/app_theme.dart';
import 'package:pickleball_app/core/utils/snackbar_helper.dart';
import 'package:pickleball_app/core/widgets/search_bar_widget.dart';
import 'package:pickleball_app/features/match/bloc/match_bloc.dart';
import 'package:pickleball_app/features/match/bloc/match_event.dart';
import 'package:pickleball_app/features/match/bloc/match_state.dart';
import 'package:pickleball_app/features/match/widgets/match_widget.dart';
import 'package:pickleball_app/features/matches/bloc/matches_bloc.dart';
import 'package:pickleball_app/features/matches/bloc/matches_event.dart';
import 'package:pickleball_app/features/matches/bloc/matches_state.dart';
import 'package:pickleball_app/features/matches/widgets/room_dropdown_btn.dart';
import 'package:pickleball_app/router/router.gr.dart';

@RoutePage()
class MatchesScreen extends StatefulWidget {
  const MatchesScreen({super.key});

  @override
  State<MatchesScreen> createState() => _MatchesScreenState();
}

class _MatchesScreenState extends State<MatchesScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _controller;
  final TextEditingController _searchController = TextEditingController();
  final GlobalKey<RoomDropdownBtnState> _dropdownKey =
      GlobalKey<RoomDropdownBtnState>();
  String _searchQuery = "";
  String _selectedMatchType = "All";
  String _selectedMatchCategory = "All";
  bool _showFilters = false;
  bool isPlayer = false;

  @override
  void initState() {
    super.initState();
    _controller = TabController(vsync: this, length: 2);
    final appBloc = context.read<AppBloc>();
    final state = appBloc.state;
    if (state is AppAuthenticatedPlayer) {
      isPlayer = true;
    } else {
      isPlayer = false;
    }
    context.read<MatchesBloc>().add(LoadAllMatches());
    _resetDropdown();
  }

  void _resetDropdown() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _dropdownKey.currentState != null) {
        _dropdownKey.currentState?.resetDropdown();
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _resetDropdown();

    // Reset tab controller to first tab when returning to screen
    if (_controller.index != 0) {
      _controller.animateTo(0);
      // Reload all matches data
      context.read<MatchesBloc>().add(LoadAllMatches());
    }
  }

  void _navigateToCreateMatch(int type) async {
    _dropdownKey.currentState?.resetDropdown();
    await AutoRouter.of(context).push(CreateMatchRoute(type: type));
  }

  void _navigateToCompetitiveMatch() async {
    _dropdownKey.currentState?.resetDropdown();
    if (isPlayer) {
      AutoRouter.of(context).push(QuickMatchRoute());
    } else {
      SnackbarHelper.showSnackBar(
          'You need to be a player to create a match competitive');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _searchController.dispose();
    super.dispose();
  }

  String _getStatusLabel(int status) {
    switch (status) {
      case 1:
        return MatchStatus.scheduled.label;
      case 2:
        return MatchStatus.ongoing.label;
      case 3:
        return MatchStatus.completed.label;
      case 4:
        return MatchStatus.disabled.label;
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    late bool onTapDetail = false;

    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Matches',
            style: AppTheme.getTheme(context).textTheme.displayMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
          ),
          backgroundColor: AppColors.primaryColor,
          automaticallyImplyLeading: false,
          actions: [
            SizedBox(
              height: 40,
              child: RoomDropdownBtn(
                key: _dropdownKey,
                onSelectSingle: () =>
                    _navigateToCreateMatch(TournamentFormant.single.value),
                onSelectDouble: () =>
                    _navigateToCreateMatch(TournamentFormant.doubles.value),
                onSelectQuickMatch: () => _navigateToCompetitiveMatch(),
              ),
            ),
            const SizedBox(width: 10),
          ],
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: AppColors.defaultGradient,
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: BlocListener<MatchBloc, MatchState>(
            listener: (context, state) {
              if (state is MatchDetailLoading) {
                AutoRouter.of(context).push(DetailMatchRoute());
              }
            },
            child: Column(
              children: [
                // Search and Filters Section
                Container(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                  child: Column(
                    children: [
                      // Search bar with rounded corners
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              child: SearchBarWidget(
                                controller: _searchController,
                                onChanged: (value) {
                                  setState(() {
                                    _searchQuery = value.toLowerCase();
                                  });
                                },
                              ),
                            ),
                          ),
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
                            tooltip:
                                _showFilters ? 'Hide filters' : 'Show filters',
                          ),
                        ],
                      ),

                      // Filters section - collapsible
                      AnimatedSize(
                        duration: const Duration(milliseconds: 300),
                        child: _showFilters
                            ? _buildFilterSection()
                            : const SizedBox(),
                      ),
                      if (!_showFilters &&
                          (_selectedMatchType != 'All' ||
                              _selectedMatchCategory != 'All'))
                        _buildActiveFiltersChips(),
                    ],
                  ),
                ),

                Container(
                  margin: const EdgeInsets.only(top: 8),
                  child: TabBar(
                    controller: _controller,
                    tabs: const [
                      Tab(text: 'All Matches'),
                      Tab(text: 'My Matches'),
                    ],
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.white60,
                    indicatorColor: Colors.white,
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicatorWeight: 3,
                    labelStyle: AppTheme.getTheme(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                    onTap: (index) {
                      if (index == 0) {
                        context.read<MatchesBloc>().add(LoadAllMatches());
                      } else {
                        onTapDetail = true;
                        final appBloc = context.read<AppBloc>();
                        final state = appBloc.state;
                        if (state is AppAuthenticatedPlayer) {
                          context
                              .read<MatchesBloc>()
                              .add(LoadMyMatches(state.userInfo.id));
                        }
                        if (state is AppAuthenticatedSponsor) {
                          context
                              .read<MatchesBloc>()
                              .add(LoadMyMatches(state.userInfo.id));
                        }
                      }
                    },
                  ),
                ),

                // Matches list content
                Expanded(
                  child: Container(
                    child: BlocBuilder<MatchesBloc, MatchesState>(
                      builder: (context, state) {
                        // Loading state
                        if (state is MatchesLoading) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                LoadingAnimationWidget.threeRotatingDots(
                                  color: Colors.white,
                                  size: 40,
                                ),
                              ],
                            ),
                          );
                        }

                        // Error state
                        if (state is MatchesError) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.error_outline,
                                  size: 60,
                                  color: AppColors.primaryColor,
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  'Something went wrong',
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                ElevatedButton.icon(
                                  onPressed: () {
                                    context
                                        .read<MatchesBloc>()
                                        .add(LoadAllMatches());
                                  },
                                  icon: const Icon(Icons.refresh),
                                  label: const Text('Retry'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primaryColor,
                                    foregroundColor: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }

                        // Loaded states
                        if (state is MatchesLoaded ||
                            state is MyMatchesLoaded) {
                          final matches = state is MatchesLoaded
                              ? state.matches
                              : (state as MyMatchesLoaded).matches;

                          // First apply status filter for All Matches tab - only show matches with status=1 (Scheduled)
                          final statusFilteredMatches = _controller.index == 0
                              ? matches
                                  .where((match) =>
                                      match.status ==
                                      MatchStatus.scheduled.value)
                                  .toList()
                              : matches; // Show all matches for My Matches tab

                          final filteredMatches = statusFilteredMatches
                              .where((match) =>
                                  // Search query filter
                                  match.title
                                      .toLowerCase()
                                      .contains(_searchQuery) &&
                                  // Match type filter
                                  (_selectedMatchType == 'All' ||
                                      match.matchFormat ==
                                          (_selectedMatchType == 'Single'
                                              ? 1
                                              : 2)) &&
                                  // Match category filter
                                  (_selectedMatchCategory == 'All' ||
                                      match.matchCategory.toString() ==
                                          _selectedMatchCategory))
                              .toList();

                          // Empty state
                          if (filteredMatches.isEmpty) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    'No matches found',
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    _hasActiveFilters()
                                        ? 'Try changing your filters'
                                        : 'Create your first match',
                                    style: const TextStyle(
                                      color: Colors.black54,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  if (_hasActiveFilters())
                                    ElevatedButton.icon(
                                      onPressed: _resetFilters,
                                      icon: const Icon(Icons.filter_alt_off),
                                      label: const Text('Reset Filters'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.primaryColor,
                                        foregroundColor: Colors.white,
                                      ),
                                    ),
                                ],
                              ),
                            );
                          }
                          // Matches list
                          return ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                            child: ListView.builder(
                              padding: const EdgeInsets.only(top: 8),
                              itemCount: filteredMatches.length,
                              itemBuilder: (context, index) {
                                final match = filteredMatches[index];
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 4,
                                  ),
                                  child: MatchWidget(
                                    title: match.title,
                                    description: match.description,
                                    matchDate: match.matchDate,
                                    status: _getStatusLabel(match.status),
                                    matchFormat: match.matchFormat,
                                    matchCategory: MatchCategory.fromValue(
                                                match.matchCategory)
                                            ?.label ??
                                        '',
                                    refereeName: match.refereeName,
                                    venue: match.venue ?? '',
                                    address: match.venueId?.toString() ?? '',
                                    isOnTap: onTapDetail,
                                    onTap: () {
                                      context
                                          .read<MatchBloc>()
                                          .add(SelectMatch(match.id));
                                    },
                                  ),
                                );
                              },
                            ),
                          );
                        }

                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Widget _buildFilterSection() {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Match Type Filter
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.sports_tennis,
                      color: Colors.white, size: 16),
                  const SizedBox(width: 4),
                  const Text(
                    'Match Type',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const Spacer(),
                  _buildResetButton(),
                ],
              ),
              const SizedBox(height: 8),
              MultiSelectContainer(
                highlightColor: Colors.white,
                singleSelectedItem: true,
                itemsDecoration: MultiSelectDecorations(
                  selectedDecoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withOpacity(0.3)),
                  ),
                ),
                textStyles: const MultiSelectTextStyles(
                  selectedTextStyle: TextStyle(
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                  textStyle: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                itemsPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                items: [
                  MultiSelectCard(value: 'All', label: 'All'),
                  MultiSelectCard(value: 'Single', label: 'Single'),
                  MultiSelectCard(value: 'Doubles', label: 'Doubles'),
                ],
                onChange: (_, selectedItem) {
                  setState(() {
                    _selectedMatchType = selectedItem;
                  });
                },
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Match Category Filter
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.category, color: Colors.white, size: 16),
                  const SizedBox(width: 4),
                  const Text(
                    'Match Category',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: MultiSelectContainer(
                  highlightColor: Colors.white,
                  singleSelectedItem: true,
                  itemsDecoration: MultiSelectDecorations(
                    selectedDecoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withOpacity(0.3)),
                    ),
                  ),
                  textStyles: const MultiSelectTextStyles(
                    selectedTextStyle: TextStyle(
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                    textStyle: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  itemsPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  items: [
                    MultiSelectCard(value: 'All', label: 'All'),
                    MultiSelectCard(
                      value: MatchCategory.tournament.value.toString(),
                      label: MatchCategory.tournament.label,
                    ),
                    MultiSelectCard(
                      value: MatchCategory.competitive.value.toString(),
                      label: MatchCategory.competitive.label,
                    ),
                    MultiSelectCard(
                      value: MatchCategory.custom.value.toString(),
                      label: MatchCategory.custom.label,
                    ),
                  ],
                  onChange: (_, selectedItem) {
                    setState(() {
                      _selectedMatchCategory = selectedItem;
                    });
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActiveFiltersChips() {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 4),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          if (_selectedMatchType != 'All')
            _buildFilterChip(_selectedMatchType, () {
              setState(() {
                _selectedMatchType = 'All';
              });
            }),
          if (_selectedMatchCategory != 'All')
            _buildFilterChip(
              _getCategoryLabel(_selectedMatchCategory),
              () {
                setState(() {
                  _selectedMatchCategory = 'All';
                });
              },
            ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, VoidCallback onTap) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: AppColors.primaryColor,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 4),
            GestureDetector(
              onTap: onTap,
              child: const Icon(
                Icons.close,
                size: 16,
                color: AppColors.primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResetButton() {
    if (!_hasActiveFilters()) return const SizedBox.shrink();

    return GestureDetector(
      onTap: _resetFilters,
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
    );
  }

  bool _hasActiveFilters() {
    return _selectedMatchType != 'All' || _selectedMatchCategory != 'All';
  }

  void _resetFilters() {
    setState(() {
      _selectedMatchType = 'All';
      _selectedMatchCategory = 'All';
    });
  }

  String _getCategoryLabel(String value) {
    if (value == MatchCategory.tournament.value.toString()) {
      return MatchCategory.tournament.label;
    } else if (value == MatchCategory.competitive.value.toString()) {
      return MatchCategory.competitive.label;
    } else if (value == MatchCategory.custom.value.toString()) {
      return MatchCategory.custom.label;
    }
    return value;
  }
}
