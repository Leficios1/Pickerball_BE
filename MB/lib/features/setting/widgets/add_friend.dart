import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:pickleball_app/core/themes/app_colors.dart';
import 'package:pickleball_app/core/widgets/app_bar_widget.dart';
import 'package:pickleball_app/core/widgets/search_bar_widget.dart';
import 'package:pickleball_app/features/setting/bloc/friend/add_friend_bloc.dart';
import 'package:pickleball_app/features/setting/bloc/friend/add_friend_event.dart';
import 'package:pickleball_app/features/setting/bloc/friend/add_friend_state.dart';
import 'package:pickleball_app/features/setting/widgets/user_info.dart';
import 'package:pickleball_app/router/router.gr.dart';

class AddFriend extends StatefulWidget {
  const AddFriend({super.key});

  @override
  _AddFriendState createState() => _AddFriendState();
}

class _AddFriendState extends State<AddFriend> {
  final TextEditingController _searchController = TextEditingController();
  final ValueNotifier<List<Map<String, dynamic>>> _filteredPlayers =
      ValueNotifier([]);
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AddFriendBloc>().add(LoadAllPlayers());
    });
  }

  void _filterPlayers(String query, List<Map<String, dynamic>> players) {
    if (query.isEmpty) {
      _filteredPlayers.value = List.from(players);
    } else {
      _filteredPlayers.value = players.where((player) {
        final name = player['displayName']!.toLowerCase();
        final email = player['email']!.toLowerCase();
        final searchQuery = query.toLowerCase();
        return name.contains(searchQuery) || email.contains(searchQuery);
      }).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: 'Add Friend',
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: AppColors.defaultGradient,
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(16),
              child: SearchBarWidget(
                controller: _searchController,
                onChanged: (query) {
                  final addFriendBloc = context.read<AddFriendBloc>();
                  if (addFriendBloc.state is AllPlayersLoaded) {
                    _filterPlayers(query,
                        (addFriendBloc.state as AllPlayersLoaded).players);
                  }
                },
              ),
            ),
            Expanded(
              child: BlocConsumer<AddFriendBloc, AddFriendState>(
                listener: (context, state) {
                  if (state is AllPlayersLoaded && !_isInitialized) {
                    _filterPlayers('', state.players);
                    _isInitialized = true;
                  }
                },
                builder: (context, state) {
                  if (state is AddFriendLoading) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          LoadingAnimationWidget.threeRotatingDots(
                            color: Colors.white,
                            size: 40,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Loading players...',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    );
                  } else if (state is AllPlayersLoaded) {
                    return ValueListenableBuilder<List<Map<String, dynamic>>>(
                      valueListenable: _filteredPlayers,
                      builder: (context, filteredPlayers, _) {
                        if (filteredPlayers.isEmpty) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.person_search,
                                  size: 64,
                                  color: Colors.white,
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'No players found',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Try a different search term',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                        return ListView.builder(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          itemCount: filteredPlayers.length,
                          itemBuilder: (context, index) {
                            final player = filteredPlayers[index];
                            return UserInfo(
                              displayNamePlayer1: player['displayName']!,
                              avatarUrlPlayer1: player['avatar']!,
                              emailPlayer1: player['email']!,
                              onPressed: () {
                                context.router.navigate(
                                  UserProfileRoute(userId: player['playerId']),
                                );
                              },
                              onPressedDelete: () {},
                              onPressedAdd: () {
                                _showAddFriendConfirmation(context, player);
                              },
                              isAdded: true,
                              rankingPlayer1: player['ranking'],
                              gender: player['gender'],
                            );
                          },
                        );
                      },
                    );
                  } else if (state is AddFriendError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 64,
                            color: Colors.red[400],
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Error: ${state.message}',
                            style: TextStyle(
                              color: Colors.red[800],
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              context.read<AddFriendBloc>().add(LoadAllPlayers());
                            },
                            child: Text('Try Again'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryColor,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 16),
                          Text('Please wait...'),
                        ],
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddFriendConfirmation(BuildContext context, Map<String, dynamic> player) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Friend'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Are you sure you want to add ${player['displayName']} as a friend?'),
              SizedBox(height: 16),
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(player['avatar']!),
                    radius: 20,
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          player['displayName']!,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          player['email']!,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                context.read<AddFriendBloc>().add(AddFriendEv(
                  friendId: player['playerId'],
                ));
                Navigator.pop(context);
              },
              child: Text('Add Friend', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
              ),
            ),
          ],
        );
      },
    );
  }
}
