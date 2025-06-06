import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pickleball_app/core/constants/app_enums.dart';
import 'package:pickleball_app/core/models/models.dart';
import 'package:pickleball_app/features/setting/bloc/friend/friend_bloc.dart';
import 'package:pickleball_app/features/setting/bloc/friend/friend_state.dart';
import 'package:pickleball_app/features/setting/widgets/user_info.dart';

class FriendListPopup extends StatelessWidget {
  final Function(int, String, String) onFriendSelected;
  final Tournament tournament;

  const FriendListPopup({super.key, required this.onFriendSelected, required this.tournament});

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> friends;
    return AlertDialog(
      title: Text('Friends List'),
      content: BlocBuilder<FriendBloc, FriendState>(
        builder: (context, state) {
          if (state is FriendLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is FriendLoaded) {
            if (tournament.isMinRanking == null || tournament.isMaxRanking == null) {
              friends = state.friends;
            } else if (tournament.type == 'DoublesMale') {
              if (state.user.gender == Gender.male.label) {
                friends = state.friends.where((friend) {
                  return int.parse(friend['rank'].toString()) >= int.parse(tournament.isMinRanking!) &&
                      int.parse(friend['rank'].toString()) <= int.parse(tournament.isMaxRanking!) &&
                      friend['gender'] == Gender.male.label;
                }).toList();
              } else {
                friends = [];
              }
            } else if (tournament.type == 'DoublesFemale') {
              if (state.user.gender == Gender.female.label) {
                friends = state.friends.where((friend) {
                  return int.parse(friend['rank'].toString()) >= int.parse(tournament.isMinRanking!) &&
                      int.parse(friend['rank'].toString()) <= int.parse(tournament.isMaxRanking!) &&
                      friend['gender'] == Gender.female.label;
                }).toList();
              } else {
                friends = [];
              }
            } else if (tournament.type == 'DoublesMix') {
              if (state.user.gender == Gender.female.label) {
                friends = state.friends.where((friend) {
                  return int.parse(friend['rank'].toString()) >= int.parse(tournament.isMinRanking!) &&
                      int.parse(friend['rank'].toString()) <= int.parse(tournament.isMaxRanking!) &&
                      friend['gender'] == Gender.male.label;
                }).toList();
              } else if (state.user.gender == Gender.male.label) {
                friends = state.friends.where((friend) {
                  return int.parse(friend['rank'].toString()) >= int.parse(tournament.isMinRanking!) &&
                      int.parse(friend['rank'].toString()) <= int.parse(tournament.isMaxRanking!) &&
                      friend['gender'] == Gender.female.label;
                }).toList();
              } else {
                friends = [];
              }
            } else {
              friends = [];
            }
            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,
              width: MediaQuery.of(context).size.width,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: friends.length,
                itemBuilder: (context, index) {
                  final friend = friends[index];
                  return UserInfo(
                    displayNamePlayer1: friend['displayName'],
                    avatarUrlPlayer1: friend['avatar'],
                    emailPlayer1: friend['email'],
                    gender: friend['gender'],
                    rank: RankLevel.fromValue(friend['rank'])!.label,
                    onPressed: () {
                      onFriendSelected(friend['friendId'], friend['avatar'],
                          friend['displayName']);
                      Navigator.of(context).pop();
                    },
                  );
                },
              ),
            );
          } else if (state is FriendError) {
            return Text(state.message);
          } else {
            return Text('No friends found');
          }
        },
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Close'),
        ),
      ],
    );
  }
}

void showFriendListPopup(
    BuildContext context, Tournament tournament, Function(int, String, String) onFriendSelected) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return SizedBox(
        child: FriendListPopup(onFriendSelected: onFriendSelected, tournament: tournament,),
      );
    },
  );
}
