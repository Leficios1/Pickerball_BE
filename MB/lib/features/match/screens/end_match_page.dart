import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pickleball_app/core/services/match/dto/end_match_request.dart';
import 'package:pickleball_app/core/themes/app_colors.dart';
import 'package:pickleball_app/core/widgets/app_bar_widget.dart';
import 'package:pickleball_app/core/widgets/app_text_form_field.dart';
import 'package:pickleball_app/features/match/bloc/match_bloc.dart';
import 'package:pickleball_app/features/match/bloc/match_event.dart';
import 'package:pickleball_app/features/match/bloc/match_state.dart';
import 'package:pickleball_app/router/router.gr.dart';

@RoutePage()
class EndMatchPage extends StatefulWidget {
  final int team1Score;
  final int team2Score;
  final int matchId;
  final String title;

  const EndMatchPage({
    super.key,
    required this.team1Score,
    required this.team2Score,
    required this.matchId,
    required this.title,
  });

  @override
  State<EndMatchPage> createState() => _EndMatchPageState();
}

class _EndMatchPageState extends State<EndMatchPage> {
  late TextEditingController _urlMatchController;

  @override
  void initState() {
    super.initState();
    _urlMatchController = TextEditingController();
  }

  @override
  void dispose() {
    _urlMatchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(title: 'End Match'),
      body: BlocListener<MatchBloc, MatchState>(
        listener: (context, state) {
          if (state is MatchDetailLoading) {
            AutoRouter.of(context).popAndPush(DetailMatchRoute());
          }
        },
        child: Center(
          child: Padding(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: const Text(
                    '🏁 Match Finished!',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  '🎾 The match "${widget.title}" has officially ended with the following result:',
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                const Text(
                  '🏆 Final Score:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                Row(
                  children: [
                    Text(
                      '✅ Team 1: ',
                      style: const TextStyle(fontSize: 16),
                    ),
                    Text(
                      widget.team1Score.toString(),
                      style: const TextStyle(
                          fontSize: 16,
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      ' points',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      '✅ Team 2: ',
                      style: const TextStyle(fontSize: 16),
                    ),
                    Text(
                      widget.team2Score.toString(),
                      style: const TextStyle(
                          fontSize: 16,
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      ' points',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  '📌 Match ID: #${widget.matchId}',
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 24),
                const Text(
                  '🔥 It was an intense and exciting match! Let’s look back at the highlights and get ready for the upcoming games!',
                  style: TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                AppTextFormField(
                  textInputAction: TextInputAction.done,
                  labelText: 'Match URL',
                  keyboardType: TextInputType.url,
                  controller: _urlMatchController,
                ),
                Text('* Example: https://www.youtube.com/watch?v=example',
                    style: TextStyle(fontSize: 12, color: Colors.grey)),
                const SizedBox(height: 24),
                Align(
                    alignment: Alignment.center,
                    child: FilledButton(
                        onPressed: () {
                          context.read<MatchBloc>().add(EndMatch(
                              request: EndMatchRequest(
                                  matchId: widget.matchId,
                                  team1Score: widget.team1Score,
                                  team2Score: widget.team2Score,
                                  urlMatch: _urlMatchController.text.isEmpty
                                      ? null
                                      : _urlMatchController.text)));
                        },
                        child: Text(
                          'Submit',
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        )))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
