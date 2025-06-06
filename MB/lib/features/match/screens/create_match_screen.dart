import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:pickleball_app/core/blocs/app_bloc.dart';
import 'package:pickleball_app/core/blocs/app_state.dart';
import 'package:pickleball_app/core/constants/app_enums.dart';
import 'package:pickleball_app/core/constants/app_global.dart';
import 'package:pickleball_app/core/services/match/dto/match_request.dart';
import 'package:pickleball_app/core/services/user/dto/user_response.dart';
import 'package:pickleball_app/core/services/venue/dto/venues_response.dart';
import 'package:pickleball_app/core/themes/app_colors.dart';
import 'package:pickleball_app/core/utils/limited_text_widget.dart';
import 'package:pickleball_app/core/widgets/app_bar_widget.dart';
import 'package:pickleball_app/core/widgets/app_text_form_field.dart';
import 'package:pickleball_app/core/widgets/custom_dropdown.dart';
import 'package:pickleball_app/core/widgets/date_picker_field.dart';
import 'package:pickleball_app/features/match/bloc/create_match/create_match_bloc.dart';
import 'package:pickleball_app/features/match/bloc/create_match/create_match_event.dart';
import 'package:pickleball_app/features/match/bloc/create_match/create_match_state.dart';
import 'package:pickleball_app/features/match/bloc/match_bloc.dart';
import 'package:pickleball_app/features/match/bloc/match_state.dart';
import 'package:pickleball_app/generated/assets.dart';
import 'package:pickleball_app/router/router.gr.dart';
import 'package:intl/intl.dart';

@RoutePage()
class CreateMatchScreen extends StatefulWidget {
  final int type;

  const CreateMatchScreen({super.key, required this.type});

  @override
  _CreateMatchScreenState createState() => _CreateMatchScreenState();
}

class _CreateMatchScreenState extends State<CreateMatchScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _matchDateController = TextEditingController();

  final DateFormat _dateFormat = DateFormat('MM/dd/yyyy hh:mm a');

  MatchCategory? _selectedMatchCategory;
  MatchPrivate? _selectedMatchPrivate;
  MatchWinScore? _selectedWinScore;
  int? _selectedRefereeId;
  int? _selectedVenueId;
  String? _validationErrorMessage; // Add this field to store error messages

  final ValueNotifier<bool> fieldValidNotifier = ValueNotifier(false);
  List<VenuesResponse> _venues = [];
  UserResponse _referees = UserResponse(message: '', data: []);

  @override
  void initState() {
    super.initState();
    _titleController.addListener(_validateForm);
    _matchDateController.addListener(_validateForm);
    _descriptionController.text = 'Bring extra rackets and water bottles.';
    _titleController.text =
        'The fighting ${widget.type == TournamentFormant.single.value ? TournamentFormant.single.label : TournamentFormant.doubles.label} room of ';
    
    DateTime tomorrow = DateTime.now().add(const Duration(days: 1));
    _matchDateController.text = _dateFormat.format(tomorrow);
    
    _selectedMatchCategory = MatchCategory.custom;
    _selectedMatchPrivate = MatchPrivate.public;

    _loadVenues();
    _loadReferees();
  }

  void _loadVenues() async {
    try {
      final venues = await globalVenueService.getAllVenues();
      setState(() {
        _venues = venues;
      });
    } catch (e) {
      // Handle error
      debugPrint('Failed to load venues: $e');
    }
  }

  void _loadReferees() async {
    try {
      final referees = await globalUserService.getAllReferees();
      setState(() {
        _referees = referees;
      });
    } catch (e) {
      // Handle error
      debugPrint('Failed to load referees: $e');
    }
  }

  void _validateForm() {
    bool isValid = _formKey.currentState?.validate() ?? false;
    bool allRequiredFieldsFilled = _selectedMatchCategory != null &&
        _selectedMatchPrivate != null &&
        _selectedWinScore != null;

    try {
      DateTime selectedDate = _dateFormat.parse(_matchDateController.text);
      DateTime now = DateTime.now();
      if (selectedDate.isBefore(now)) {
        // Store message instead of showing SnackBar directly
        _validationErrorMessage = "Match date must be in the future";
        isValid = false;
      } else {
        _validationErrorMessage = null;
      }
    } catch (e) {
      // Store message instead of showing SnackBar directly
      _validationErrorMessage = "Invalid date format";
      isValid = false;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        // Show any stored validation message safely after initialization
        if (_validationErrorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(_validationErrorMessage!)),
          );
          _validationErrorMessage = null;
        }
        
        if (_selectedMatchCategory == MatchCategory.competitive &&
            _selectedMatchPrivate != MatchPrivate.private) {
          setState(() {
            _selectedMatchPrivate = MatchPrivate.private;
          });
        } else if (_selectedMatchCategory == MatchCategory.custom &&
            _selectedMatchPrivate != MatchPrivate.public) {
          setState(() {
            _selectedMatchPrivate = MatchPrivate.public;
          });
        }

        fieldValidNotifier.value = isValid && allRequiredFieldsFilled;
      }
    });
  }

  Future<void> _pickDateTime() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now().add(const Duration(days: 1)),
      lastDate: DateTime(2101),
    );
    
    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      
      if (pickedTime != null) {
        final DateTime combinedDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );
        
        setState(() {
          _matchDateController.text = _dateFormat.format(combinedDateTime);
          print('Selected date: ${_matchDateController.text}');
        });
        _validateForm();
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _matchDateController.dispose();
    super.dispose();
  }

  void _createMatch(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final appState = context.read<AppBloc>().state;
      if (appState is AppAuthenticatedPlayer ||
          appState is AppAuthenticatedSponsor) {
        int userId = (appState as dynamic).userInfo.id;
        if (_selectedMatchCategory != null &&
            _selectedMatchPrivate != null &&
            _selectedWinScore != null) {
          final matchRequest = CreateMatchRequest(
            title: _titleController.text,
            description: _descriptionController.text,
            matchDate: _dateFormat.parse(_matchDateController.text),
            matchCategory: _selectedMatchCategory!.value,
            isPublic: _selectedMatchPrivate!.value == 1 ? true : false,
            winScore: _selectedWinScore!.index,
            refereeId: _selectedRefereeId,
            venueId: _selectedVenueId,
            status: MatchStatus.scheduled.value,
            matchFormat: widget.type,
            roomOnwer: userId,
            player1Id: userId,
          );

          context.read<CreateMatchBloc>().add(CreateMatch(match: matchRequest));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Please fill all required fields")),
          );
        }
      }
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarWidget(title: 'Create Match'),
        body: BlocListener<MatchBloc, MatchState>(listener: (context, state) {
          if (state is MatchDetailLoading) {
            AutoRouter.of(context).popAndPush(DetailMatchRoute());
          }
        }, child: BlocBuilder<CreateMatchBloc, CreateMatchState>(
            builder: (context, state) {
          if (state is CreateMatchLoading) {
            return Container(
              color: Colors.white,
              child: Center(
                child: LoadingAnimationWidget.threeRotatingDots(
                  color: AppColors.primaryColor,
                  size: 30,
                ),
              ),
            );
          } else {
            return SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Center(
                    child: Column(
                      children: [
                        Image.asset(
                          Assets.imagesPickerCreate,
                          width: MediaQuery.of(context).size.width,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              AppTextFormField(
                                controller: _titleController,
                                labelText: 'Title of Match (*)',
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                validator: (value) => value!.isEmpty
                                    ? 'This field is required'
                                    : null,
                              ),
                              AppTextFormField(
                                controller: _descriptionController,
                                labelText: 'Description',
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                              ),
                              DatePickerField(
                                controller: _matchDateController,
                                labelText: 'Match Date & Time (*)',
                                onTap: _pickDateTime,
                              ),
                              CustomDropdown<MatchCategory>(
                                selectedValue: _selectedMatchCategory,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedMatchCategory = value;
                                    _selectedMatchPrivate =
                                        value == MatchCategory.competitive
                                            ? MatchPrivate.private
                                            : MatchPrivate.public;
                                  });
                                  _validateForm();
                                },
                                items: MatchCategory.values
                                    .where((category) =>
                                        category == MatchCategory.custom)
                                    .toList(),
                                label: 'Match Category (*)',
                                getLabel: (item) => item.label,
                              ),
                              CustomDropdown<MatchPrivate>(
                                selectedValue: _selectedMatchPrivate,
                                items: MatchPrivate.values,
                                label: 'Open to Everyone (*)',
                                getLabel: (item) => item.label,
                                readOnly: true,
                                onChanged: null,
                              ),
                              CustomDropdown<MatchWinScore>(
                                selectedValue: _selectedWinScore,
                                onChanged: (value) {
                                  setState(() => _selectedWinScore = value);
                                  _validateForm();
                                },
                                items: MatchWinScore.values,
                                label: 'Win Score (*)',
                                getLabel: (item) => item.label,
                              ),
                              CustomDropdown<int>(
                                selectedValue: _selectedRefereeId,
                                onChanged: (value) {
                                  setState(() => _selectedRefereeId = value);
                                },
                                items: _referees.data
                                    .map((referee) => referee.id)
                                    .toList(),
                                label: 'Referee',
                                getLabel: (value) {
                                  final referee = _referees.data
                                      .firstWhere((referee) => referee.id == value);
                                  return '${referee.firstName} ${referee.lastName} ${referee.secondName ?? ''}';
                                },
                                itemBuilder: (context, item) {
                                  final referee = _referees.data.firstWhere((referee) => referee.id == item);
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
                                selectedValue: _selectedVenueId,
                                onChanged: (value) {
                                  setState(() => _selectedVenueId = value);
                                },
                                items: _venues.map((venue) => venue.id).toList(),
                                label: 'Venue',
                                getLabel: (item) {
                                  final venue = _venues.firstWhere((venue) => venue.id == item);
                                  return venue.name;
                                },
                                itemBuilder: (context, item) {
                                  final venue = _venues.firstWhere((venue) => venue.id == item);
                                  return Padding(
                                    padding: const EdgeInsets.only(left: 5, right: 5),
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
                              const SizedBox(height: 20),
                              ValueListenableBuilder<bool>(
                                valueListenable: fieldValidNotifier,
                                builder: (_, isValid, __) {
                                  return FilledButton(
                                    onPressed: isValid
                                        ? () => _createMatch(context)
                                        : null,
                                    child: Text('Create Match',
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: isValid
                                                ? Colors.white
                                                : Colors.grey)),
                                  );
                                },
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
        })));
  }
}
