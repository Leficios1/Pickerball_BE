import 'package:flutter/material.dart';
import 'package:pickleball_app/core/themes/app_colors.dart';

class TeamHeadersWidget extends StatelessWidget {
  const TeamHeadersWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 40,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Center(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Text('Home Team',
                        style: const TextStyle(
                            fontSize: 16,
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Text('Away Team',
                        style: const TextStyle(
                            fontSize: 16,
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
