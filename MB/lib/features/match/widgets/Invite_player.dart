import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:pickleball_app/core/models/models.dart';
import 'package:pickleball_app/core/services/friend/dto/friend_response.dart';
import 'package:pickleball_app/core/themes/app_colors.dart';
import 'package:pickleball_app/core/themes/app_theme.dart';
import 'package:pickleball_app/features/match/bloc/invite_player_bloc/invite_player_bloc.dart';
import 'package:pickleball_app/features/match/bloc/invite_player_bloc/invite_player_event.dart';
import 'package:pickleball_app/features/match/bloc/invite_player_bloc/invite_player_state.dart';
import 'package:pickleball_app/features/match/widgets/player_info.dart';
import 'package:pickleball_app/features/setting/widgets/user_info.dart';

class AddPlayerPopup extends StatefulWidget {
  final int matchId;

  const AddPlayerPopup({super.key, required this.matchId});

  @override
  State<AddPlayerPopup> createState() => _AddPlayerPopupState();
}

class _AddPlayerPopupState extends State<AddPlayerPopup> {
  String _selectedOption = 'Option 1';
  List<User> friends = [];
  List<User> players = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    context.read<InvitePlayerBloc>().add(LoadFriends(type: _selectedOption));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.all(16.0),
      content: Container(
        width: MediaQuery.of(context).size.width * 0.75,
        height: MediaQuery.of(context).size.height * 0.6,
        padding: EdgeInsets.all(16.0),
        child: BlocBuilder<InvitePlayerBloc, InvitePlayerState>(
            builder: (context, state) {
          if (state is InvitePlayerError) {
            return Center(
              child: Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.people, size: 60, color: Colors.blueAccent),
                    SizedBox(height: 20),
                    Text(
                      'No friends found. Please add a friend.',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,  // Căn giữa văn bản
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),  // Padding cho nút
                        textStyle: TextStyle(fontSize: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),  // Bo góc cho nút
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.add, size: 24),
                          SizedBox(width: 10),
                          Text('Add Friend'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          else if (state is FriendsLoaded) {
            friends = state.friends ?? [];
            players = state.users ?? [];
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    width: MediaQuery.of(context).size.width - 40,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: AppColors.primaryColor,
                    ),
                    child: Center(
                      child: Text('Select Player',
                          style: AppTheme.getTheme(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              )),
                    ),
                  ),
                ),
                Expanded(
                  child: _selectedOption == 'Option 1'
                      ? ListView.builder(
                          itemCount: friends.length,
                          itemBuilder: (context, index) {
                            return UserInfo(
                              displayNamePlayer1:
                                  '${friends[index].firstName}, ${friends[index].lastName} ${friends[index].secondName ?? ''} ',
                              avatarUrlPlayer1:
                                  friends[index].avatarUrl.toString(),
                              emailPlayer1: friends[index].email.toString(),
                              rank: friends[index]
                                  .userDetails!
                                  .experienceLevel
                                  .toString(),
                              gender: friends[index].gender,
                              onPressed: () {
                                context.read<InvitePlayerBloc>().add(
                                      AddPlayer(
                                        matchId: widget.matchId,
                                        playerRecieveId: friends[index].id,
                                      ),
                                    );
                              },
                            );
                          },
                        )
                      : ListView.builder(
                          itemCount: players.length,
                          itemBuilder: (context, index) {
                            return PlayerInfo(
                              avatarUrl: players[index].avatarUrl.toString(),
                              displayName: players[index].firstName.toString(),
                              onTap: () {
                                context.read<InvitePlayerBloc>().add(
                                      AddPlayer(
                                        matchId: widget.matchId,
                                        playerRecieveId: players[index].id,
                                      ),
                                    );
                              },
                            );
                          },
                        ),
                ),
                SizedBox(
                  height: 10,
                ),
                FilledButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Close',
                        style: AppTheme.getTheme(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            )))
              ],
            );
          } else {
            return Center(
              child: LoadingAnimationWidget.threeRotatingDots(
                  color: AppColors.primaryColor, size: 30),
            );
          }
        }),
      ),
    );
  }
}
