import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:pickleball_app/core/themes/app_colors.dart';
import 'package:pickleball_app/core/widgets/app_bar_widget.dart';
import 'package:pickleball_app/core/widgets/search_bar_widget.dart';
import 'package:pickleball_app/features/setting/bloc/friend/friend_bloc.dart';
import 'package:pickleball_app/features/setting/bloc/friend/friend_event.dart';
import 'package:pickleball_app/features/setting/bloc/friend/friend_state.dart';
import 'package:pickleball_app/features/setting/widgets/add_friend.dart';
import 'package:pickleball_app/features/setting/widgets/user_info.dart';
import 'package:pickleball_app/generated/assets.dart';
import 'package:pickleball_app/router/router.gr.dart';

@RoutePage()
class FriendPage extends StatefulWidget {
  const FriendPage({super.key});

  @override
  State<FriendPage> createState() => _FriendPageState();
}

class _FriendPageState extends State<FriendPage> {
  final TextEditingController _searchController = TextEditingController();
  final ValueNotifier<List<Map<String, dynamic>>> _filteredFriends =
      ValueNotifier([]);

  void _filterFriends(String query, List<Map<String, dynamic>> friends) {
    if (query.isEmpty) {
      _filteredFriends.value = friends;
    } else {
      _filteredFriends.value = friends.where((friend) {
        final name = friend['displayName']!.toLowerCase();
        final email = friend['email']!.toLowerCase();
        final searchQuery = query.toLowerCase();
        return name.contains(searchQuery) || email.contains(searchQuery);
      }).toList();
    }
  }

  @override
  void initState() {
    super.initState();
    final friendBloc = context.read<FriendBloc>();
    friendBloc.add(LoadFriends());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: 'Friends',
        imageIcon: Assets.iconsIcAddFriend,
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) => AddFriend(),
          );
        },
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
            SearchBarWidget(
              controller: _searchController,
              onChanged: (query) {
                final friendBloc = context.read<FriendBloc>();
                if (friendBloc.state is FriendLoaded) {
                  _filterFriends(
                      query, (friendBloc.state as FriendLoaded).friends);
                }
              },
            ),
            Expanded(
              child: BlocBuilder<FriendBloc, FriendState>(
                builder: (context, state) {
                  if (state is FriendLoading) {
                    return Center(
                      child: LoadingAnimationWidget.threeRotatingDots(
                        color: Colors.white,
                        size: 30,
                      ),
                    );
                  } else if (state is FriendLoaded) {
                    _filterFriends(_searchController.text, state.friends);
                    return ValueListenableBuilder<List<Map<String, dynamic>>>(
                      valueListenable: _filteredFriends,
                      builder: (context, filteredFriends, _) {
                        return ListView.builder(
                          itemCount: filteredFriends.length,
                          itemBuilder: (context, index) {
                            final friend = filteredFriends[index];
                            return UserInfo(
                              displayNamePlayer1: friend['displayName']!,
                              avatarUrlPlayer1: friend['avatar'],
                              emailPlayer1: friend['email']!,
                              onPressed: () {
                                context.router.navigate(
                                  UserProfileRoute(userId: friend['friendId']),
                                );
                              },
                              onPressedDelete: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Delete Friend'),
                                      content: Text(
                                          'Are you sure you want to remove ${friend['displayName']} from your friends?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text('Yes'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text('No'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              isFriend: true,
                              gender: friend['gender'],
                              rank: friend['rank']?.toString(),
                            );
                          },
                        );
                      },
                    );
                  } else if (state is FriendError) {
                    return Text('No friends found');
                  } else {
                    return Center(
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text('No friends found'),
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
}
