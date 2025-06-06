import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pickleball_app/core/constants/app_enums.dart';
import 'package:pickleball_app/core/services/match/dto/get_match_response.dart';
import 'package:pickleball_app/core/services/user/dto/user_response.dart';
import 'package:pickleball_app/core/services/venue/dto/venues_response.dart';
import 'package:pickleball_app/core/themes/app_colors.dart';
import 'package:pickleball_app/core/widgets/app_text_form_field.dart';
import 'package:pickleball_app/core/widgets/custom_dropdown.dart';
import 'package:pickleball_app/core/widgets/date_picker_field.dart';

class MatchDetailWidget extends StatefulWidget {
  final MatchData match;
  final bool isOwner;
  final List<VenuesResponse> venues;
  final UserResponse referees;
  final TextEditingController titleController;
  final Function(String?)? onTitleChanged;
  final TextEditingController descriptionController;
  final Function(String?)? onDescriptionChanged;
  final TextEditingController matchDateController;
  final Function(DateTime?)? onMatchDateChanged;
  final Function(int?)? onVenueChanged;
  final Function(int?)? onRefereeChanged;
  final Function(MatchCategory?)? onMatchCategoryChanged;
  final Function(TournamentFormant?)? onMatchFormatChanged;
  final Function(MatchWinScore?)? onWinScoreChanged;

  const MatchDetailWidget({
    super.key,
    required this.match,
    required this.isOwner,
    required this.venues,
    required this.referees,
    required this.titleController,
    required this.descriptionController,
    required this.matchDateController,
    this.onTitleChanged,
    this.onDescriptionChanged,
    this.onMatchDateChanged,
    this.onVenueChanged,
    this.onRefereeChanged,
    this.onMatchCategoryChanged,
    this.onMatchFormatChanged,
    this.onWinScoreChanged,
  });

  @override
  State<MatchDetailWidget> createState() => _MatchDetailWidgetState();
}

class _MatchDetailWidgetState extends State<MatchDetailWidget> {
  @override
  Widget build(BuildContext context) {
    final DateFormat formatter = DateFormat('HH:mm dd-MM-yyyy');
    bool isEdit = !widget.isOwner;
    if(widget.match.matchCategory == MatchCategory.competitive.value){
      isEdit = true;
    }else{
    }
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: AppTextFormField(
                controller: widget.titleController,
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.text,
                labelText: 'Title',
                autofocus: false,
                readOnly: isEdit,
                onChanged: widget.isOwner
                    ? (value) {
                        setState(() {
                          widget.onTitleChanged?.call(value);
                        });
                      }
                    : null,
              ),
            ),
            const Divider(height: 20, thickness: 1),
            AppTextFormField(
              controller: widget.descriptionController,
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.text,
              labelText: 'Description',
              readOnly: isEdit,
              autofocus: false,
              onChanged: widget.isOwner
                  ? (value) {
                      setState(() {
                        widget.onDescriptionChanged?.call(value);
                      });
                    }
                  : null,
            ),
            AppTextFormField(
                textInputAction: TextInputAction.done,
                labelText: 'Status',
                keyboardType: TextInputType.text,
                readOnly: true,
                controller: TextEditingController(text: MatchStatus.fromValue(widget.match.status)!.label)),
            const SizedBox(height: 12),
            DatePickerField(
              controller: widget.matchDateController,
              onTap: !isEdit
                  ? () async {
                      final DateTime? pickedDate = await showDatePicker(
                        context: context,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );

                      if (pickedDate != null) {
                        setState(() {
                          widget.matchDateController.text =
                              pickedDate.toString();
                          widget.onMatchDateChanged?.call(pickedDate);
                        });
                      }
                    }
                  : () {},
              labelText: 'Match Date',
              readOnly: isEdit,
            ),
            CustomDropdown<int>(
              selectedValue: widget.match.refereeId,
              onChanged: widget.isOwner
                  ? (value) {
                setState(() {
                  widget.onRefereeChanged?.call(value);
                });
              }
                  : null,
              items: widget.referees.data.map((referee) => referee.id).toList(),
              label: 'Referee',
              getLabel: (value) {
                final referee = widget.referees.data
                    .firstWhere((referee) => referee.id == value);
                return '${referee.firstName} ${referee.lastName} ${referee.secondName ?? ''}';
              },
              itemBuilder: (context, item) {
                final referee = widget.referees.data.firstWhere((referee) => referee.id == item);
                return Padding(
                  padding: const EdgeInsets.only(left: 5, right: 5),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 5, right: 5),
                      child: Row(
                        children: [
                          // Avatar
                          CircleAvatar(
                            radius: 30,
                            backgroundImage: referee.avatarUrl != null && referee.avatarUrl!.isNotEmpty
                                ? NetworkImage(referee.avatarUrl!)
                                : null,
                            backgroundColor: Colors.grey[200],
                            child: referee.avatarUrl == null || referee.avatarUrl!.isEmpty
                                ? const Icon(Icons.person, color: Colors.grey, size: 30)
                                : null,
                          ),
                          const SizedBox(width: 16),

                          // Referee details
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Name
                                Text(
                                  '${referee.firstName} ${referee.lastName} ${referee.secondName ?? ''}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 6),

                                // Email
                                Row(
                                  children: [
                                    Icon(
                                      Icons.email_outlined,
                                      size: 16,
                                      color: Colors.grey[700],
                                    ),
                                    const SizedBox(width: 6),
                                    Expanded(
                                      child: Text(
                                        referee.email,
                                        style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),

                                // Phone
                                Row(
                                  children: [
                                    Icon(
                                      Icons.phone_outlined,
                                      size: 16,
                                      color: Colors.grey[700],
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      referee.phoneNumber,
                                      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),

                                // Gender
                                if (referee.gender != null)
                                  Row(
                                    children: [
                                      Icon(
                                        referee.gender?.toLowerCase() == 'male' ? Icons.male : Icons.female,
                                        size: 16,
                                        color: referee.gender?.toLowerCase() == 'male' ? Colors.blue : Colors.pink,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        referee.gender ?? 'Unknown',
                                        style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
            CustomDropdown<int>(
              selectedValue: widget.match.venueId,
              onChanged: widget.isOwner
                  ? (value) {
                setState(() {
                  widget.onVenueChanged?.call(value);
                });
              }
                  : null,
              items: widget.venues.map((venue) => venue.id).toList(),
              label: 'Venue',
              getLabel: (value) => widget.venues.isNotEmpty
                  ? widget.venues.firstWhere((venue) => venue.id == value, orElse: () => widget.venues.first).name
                  : 'Unknown Venue',
              itemBuilder: (context, item) {
                final venue = widget.venues.firstWhere((venue) => venue.id == item);
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Image Section
                        ClipRRect(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                          child: Image.network(
                            venue.urlImage,
                            height: 180,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        // Info Section
                        Padding(
                          padding: const EdgeInsets.only(left: 5, right: 5),
                          child: Row(
                            children: [
                              // Name and Address
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      venue.name,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.location_on,
                                          size: 16,
                                          color: AppColors.primaryColor,
                                        ),
                                        const SizedBox(width: 6),
                                        Expanded(
                                          child: Text(
                                            formatAddressFor3Lines(venue.address),
                                            style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              // Venue ID Circle
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: AppColors.primaryColor,
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    '${venue.id}',
                                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            CustomDropdown<int>(
              selectedValue: widget.match.matchCategory,
              onChanged: widget.isOwner
                  ? (value) {
                      setState(() {
                        widget.onMatchCategoryChanged
                            ?.call(MatchCategory.fromValue(value));
                      });
                    }
                  : null,
              items: MatchCategory.values
                  .where((category) =>
                      category == MatchCategory.competitive ||
                      category == MatchCategory.custom)
                  .map((e) => e.value) // Convert to list of integers
                  .toList(),
              label: 'Match Category',
              getLabel: (value) => MatchCategory.fromValue(value)!.label,
              readOnly: isEdit,
            ),
            CustomDropdown<int>(
              selectedValue: widget.match.matchFormat,
              onChanged: widget.isOwner
                  ? (value) {
                      setState(() {
                        widget.onMatchFormatChanged
                            ?.call(TournamentFormant.fromValue(value));
                      });
                    }
                  : null,
              items: TournamentFormant.values.map((e) => e.value).toList(),
              label: 'Match Format',
              getLabel: (value) => TournamentFormant.fromValue(value)!.subLabel,
              readOnly: isEdit,
            ),
            CustomDropdown<int>(
              selectedValue: widget.match.winScore,
              onChanged: widget.isOwner
                  ? (value) {
                      setState(() {
                        widget.onWinScoreChanged
                            ?.call(MatchWinScore.fromValue(value));
                      });
                    }
                  : null,
              items: MatchWinScore.values.map((e) => e.value).toList(),
              label: 'Win Score',
              getLabel: (value) => MatchWinScore.fromValue(value)!.label,
              readOnly: isEdit,
            ),
          ],
        ),
      ),
    );
  }
  String formatAddressFor3Lines(String address) {
    if (address.length <= 75) {
      List<String> lines = [];
      for (int i = 0; i < address.length; i += 25) {
        int end = i + 25;
        if (end > address.length) end = address.length;
        lines.add(address.substring(i, end));
        if (lines.length == 3) break;
      }
      return lines.join('\n');
    } else {
      // If address is longer than 60 chars (3 lines of 20), add ellipsis
      return address.substring(0, 72) + '...';
    }
  }
}
