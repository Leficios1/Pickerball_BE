import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:pickleball_app/core/services/tournament/dto/create_tournament_request.dart';
import 'package:pickleball_app/core/themes/app_colors.dart';
import 'package:pickleball_app/core/widgets/html_context.dart';
import 'package:pickleball_app/features/tournament_manage/bloc/create_tournament/create_tournament_bloc.dart';
import 'package:pickleball_app/features/tournament_manage/bloc/create_tournament/create_tournament_event.dart';
import 'package:pickleball_app/features/tournament_manage/bloc/create_tournament/create_tournament_state.dart';
import 'package:pickleball_app/features/tournament_manage/bloc/tournaments_bloc.dart';
import 'package:pickleball_app/features/tournament_manage/bloc/tournaments_state.dart';
import 'package:pickleball_app/router/router.gr.dart';

@RoutePage()
class PolicyTournamentPage extends StatefulWidget {
  final CreateTournamentRequest createTournamentRequest;

  const PolicyTournamentPage(
      {super.key, required this.createTournamentRequest});

  @override
  State<PolicyTournamentPage> createState() => _PolicyTournamentPageState();
}

class _PolicyTournamentPageState extends State<PolicyTournamentPage> {
  late ValueNotifier<bool> hasReadRulesNotifier;

  @override
  void initState() {
    super.initState();
    hasReadRulesNotifier = ValueNotifier(false);
  }

  @override
  void dispose() {
    hasReadRulesNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Tournament Policy',
              style: TextStyle(color: Colors.white)),
          backgroundColor: AppColors.primaryColor,
          iconTheme: IconThemeData(color: Colors.white),
        ),
        body: BlocListener<TournamentBloc, TournamentState>(
            listener: (context, state) {
          if (state is TournamentDetailLoading) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Create tournament successfully!')),
            );
            AutoRouter.of(context).popAndPush(DetailTournamentRoute());
          }
        }, child: BlocBuilder<CreateTournamentBloc, CreateTournamentState>(
                builder: (context, state) {
          if (state is CreateTournamentLoading) {
            return Center(
              child: LoadingAnimationWidget.fourRotatingDots(
                color: AppColors.primaryColor,
                size: 50,
              ),
            );
          }
          return Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.all(16),
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.6,
                decoration: BoxDecoration(border: Border.all()),
                child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: HtmlViewWidget(
                      htmlContent: widget.createTournamentRequest.note,
                    )),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  ValueListenableBuilder<bool>(
                    valueListenable: hasReadRulesNotifier,
                    builder: (context, hasReadRules, child) {
                      return Checkbox(
                        value: hasReadRules,
                        onChanged: (value) {
                          hasReadRulesNotifier.value = value ?? false;
                        },
                      );
                    },
                  ),
                  const Text('I have read the rules'),
                ],
              ),
              const SizedBox(height: 16),
              ValueListenableBuilder<bool>(
                valueListenable: hasReadRulesNotifier,
                builder: (context, hasReadRules, child) {
                  return FilledButton(
                    onPressed: hasReadRulesNotifier.value
                        ? () {
                            context.read<CreateTournamentBloc>().add(
                                  CreateTournamentRequestEvent(
                                      widget.createTournamentRequest),
                                );
                          }
                        : null,
                    child: Text(
                      'Create',
                      style: TextStyle(
                        color: hasReadRulesNotifier.value
                            ? Colors.white
                            : Colors.grey.shade500,
                        fontSize: 20,
                      ),
                    ),
                  );
                },
              ),
            ],
          );
        })));
  }
}
