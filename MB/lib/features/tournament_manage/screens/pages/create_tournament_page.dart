import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pickleball_app/core/blocs/app_bloc.dart';
import 'package:pickleball_app/core/blocs/app_state.dart';
import 'package:pickleball_app/core/constants/app_enums.dart';
import 'package:pickleball_app/core/constants/app_global.dart';
import 'package:pickleball_app/core/constants/app_strings.dart';
import 'package:pickleball_app/core/services/tournament/dto/create_tournament_request.dart';
import 'package:pickleball_app/core/themes/app_colors.dart';
import 'package:pickleball_app/core/utils/fetch_provinces.dart';
import 'package:pickleball_app/core/utils/note_html.dart';
import 'package:pickleball_app/core/widgets/app_bar_widget.dart';
import 'package:pickleball_app/core/widgets/app_text_form_field.dart';
import 'package:pickleball_app/core/widgets/custom_dropdown.dart';
import 'package:pickleball_app/core/widgets/date_picker_field.dart';
import 'package:pickleball_app/router/router.gr.dart';

@RoutePage()
class CreateTournamentPage extends StatefulWidget {
  const CreateTournamentPage({super.key});

  @override
  _CreateTournamentPageState createState() => _CreateTournamentPageState();
}

class _CreateTournamentPageState extends State<CreateTournamentPage>
    with RouteAware {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _maxPlayerController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _totalPrizeController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _socialController = TextEditingController();
  final TextEditingController _entryFeeController = TextEditingController();
  final ValueNotifier<bool> _isFormValid = ValueNotifier(false);
  XFile? _bannerImage;
  String? _bannerUrl;
  MatchFormat? _selectedFormat;
  RankLevel? _selectedMinRanking;
  RankLevel? _selectedMaxRanking;
  bool _isFree = true;
  bool _rankLimit = false;
  final ImagePicker _picker = ImagePicker();
  List<dynamic> provinces = [];
  List<dynamic> districts = [];
  String? selectedProvince;
  String? selectedDistrict;
  final ProvinceService provinceService = ProvinceService();

  @override
  void initState() {
    super.initState();
    _nameController.text = 'Ultimate Pickleball Championship';
    _maxPlayerController.addListener(_validateForm);
    _descriptionController.text = '''
  The ${_nameController.text} is an electrifying tournament where players from all skill levels come together to compete, showcase their talent, and push their limits. With top-tier facilities, passionate competitors, and an enthusiastic audience, this event promises intense matches and unforgettable moments.

Join us for an exciting journey to crown the Pickleball Champion and claim your share of the grand prize pool! Whether you're playing or cheering from the stands, this is an event you don’t want to miss! 🏆🏓🔥''';
    _totalPrizeController.addListener(_validateForm);
    _startDateController.addListener(_validateForm);
    _endDateController.addListener(_validateForm);
    _socialController.text = 'https://';
    _entryFeeController.addListener(_validateForm);
    fetchProvinces();
  }

  Future<void> fetchProvinces() async {
    try {
      final fetchedProvinces = await provinceService.fetchProvinces();
      setState(() {
        provinces = fetchedProvinces;
      });
    } catch (e) {
      print(e);
    }
  }

  void updateDistricts(String provinceName) {
    final selected = provinces.firstWhere((p) => p['name'] == provinceName);
    setState(() {
      selectedProvince = provinceName;
      districts = selected['districts'];
      selectedDistrict = null;
    });
    validateForm();
  }

  void validateForm() {
    setState(() {
      _isFormValid.value = _formKey.currentState?.validate() ?? false;
    });
  }

  @override
  Future<bool> _onWillPop() async {
    final router = AutoRouter.of(context);
    router.replace(TournamentManageRoute());
    return false;
  }

  @override
  void didPopNext() {}

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _bannerImage = image;
        _uploadImage();
      });
    }
  }

  Future<void> _uploadImage() async {
    if (_bannerImage != null) {
      final url =
          await globalCloudinaryService.uploadImage(File(_bannerImage!.path));
      setState(() {
        _bannerUrl = url;
        _validateForm();
      });
    }
  }

  void _validateForm() {
    bool isValid = _formKey.currentState?.validate() ?? false;

    if (_startDateController.text.isNotEmpty && _endDateController.text.isNotEmpty) {
      List<String> startParts = _startDateController.text.split('-');
      List<String> endParts = _endDateController.text.split('-');

      DateTime startDate = DateTime(
          int.parse(startParts[0]),
          int.parse(startParts[1]),
          int.parse(startParts[2])
      );

      DateTime endDate = DateTime(
          int.parse(endParts[0]),
          int.parse(endParts[1]),
          int.parse(endParts[2])
      );

      if (startDate.isBefore(DateTime.now())) {
        isValid = false;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Start date must be in the future")),
        );
      }
      if (endDate.isBefore(startDate)) {
        isValid = false;
      }
    }

    _isFormValid.value = isValid;
  }

  @override
  Widget build(BuildContext context) {
    final appBloc = context.read<AppBloc>();
    final appState = appBloc.state;
    String contactEmail = '';
    String contactPhone = '';

    if (appState is AppAuthenticatedSponsor) {
      contactEmail = appState.userInfo.email;
      contactPhone = appState.userInfo.phoneNumber;
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Tournament', style: TextStyle(color: Colors.white),),
        backgroundColor: AppColors.primaryColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            AutoRouter.of(context).replace(TournamentManageRoute());
          },
        ),
      ),
      body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    height: 100,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      image: _bannerUrl != null
                          ? DecorationImage(
                              image: NetworkImage(_bannerUrl!),
                              fit: BoxFit.fill,
                            )
                          : null,
                    ),
                    child: _bannerUrl == null
                        ? Icon(
                            Icons.add_a_photo,
                            size: 50,
                            color: Colors.white,
                          )
                        : null,
                  ),
                ),
                const SizedBox(height: 16),
                AppTextFormField(
                  controller: _nameController,
                  labelText: 'Title (*)',
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                ),
                SwitchListTile(
                  title: const Text('Rank Limit'),
                  value: _rankLimit,
                  onChanged: (value) {
                    setState(() {
                      _rankLimit = value;
                      _validateForm();
                    });
                  },
                ),
                if (_rankLimit) ...[
                  CustomDropdown<RankLevel>(
                    selectedValue: _selectedMinRanking,
                    onChanged: (value) {
                      setState(() {
                        _selectedMinRanking = value;
                        _validateForm();
                      });
                    },
                    items: RankLevel.values,
                    label: 'Min Ranking (*)',
                    getLabel: (rank) => rank.label,
                  ),
                  CustomDropdown<RankLevel>(
                    selectedValue: _selectedMaxRanking,
                    onChanged: (value) {
                      setState(() {
                        _selectedMaxRanking = value;
                        _validateForm();
                      });
                    },
                    items: RankLevel.values,
                    label: 'Max Ranking (*)',
                    getLabel: (rank) => rank.label,
                  ),
                ],
                SwitchListTile(
                  title: const Text('Is Free'),
                  value: _isFree,
                  onChanged: (value) {
                    setState(() {
                      _isFree = value;
                      _validateForm();
                    });
                  },
                ),
                if (_isFree == false) ...[
                  AppTextFormField(
                    controller: _entryFeeController,
                    labelText: 'Entry Fee (*)',
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                  )
                ],
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: "Select Province",
                    border: OutlineInputBorder(),
                  ),
                  value: selectedProvince,
                  items: provinces.map<DropdownMenuItem<String>>((province) {
                    return DropdownMenuItem<String>(
                      value: province['name'],
                      child: Text(province['name']),
                    );
                  }).toList(),
                  onChanged: (value) {
                    updateDistricts(value!);
                  },
                ),
                const SizedBox(height: 16),
                districts.isEmpty
                    ? const Text("Please select a province first",
                        style: TextStyle(color: Colors.red))
                    : DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          labelText: "Select District",
                          border: OutlineInputBorder(),
                        ),
                        value: selectedDistrict,
                        items:
                            districts.map<DropdownMenuItem<String>>((district) {
                          return DropdownMenuItem<String>(
                            value: district['name'],
                            child: Text(district['name']),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedDistrict = value;
                          });
                          validateForm();
                        },
                      ),
                const SizedBox(height: 16),
                AppTextFormField(
                  controller: _maxPlayerController,
                  labelText: 'Max Player (*)',
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the number of players';
                    }
                    final int? number = int.tryParse(value);
                    if (number == null || number < 16) {
                      return 'The number of players must be at least 16';
                    }
                    if ((number & (number - 1)) != 0) {
                      return 'The number of players must be a power of 2 (e.g., 16, 32, 64, 128)';
                    }
                    return null;
                  },
                ),
                AppTextFormField(
                  controller: _descriptionController,
                  labelText: 'Description',
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  maxLines: 3,
                ),
                AppTextFormField(
                  controller: _totalPrizeController,
                  labelText: 'Total Prize (*)',
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                ),
                DatePickerField(
                  controller: _startDateController,
                  labelText: 'Start Date (*)',
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(), // Restrict past dates
                      lastDate: DateTime(2101),
                    );
                    if (pickedDate != null) {
                      String formattedDate = "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
                      _startDateController.text = formattedDate;
                      _validateForm();
                    }
                  },
                ),

                DatePickerField(
                  controller: _endDateController,
                  labelText: 'End Date (*)',
                  onTap: () async {
                    if (_startDateController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Please select start date first")),
                      );
                      return;
                    }

                    List<String> dateParts = _startDateController.text.split('-');
                    DateTime startDate = DateTime(
                        int.parse(dateParts[0]),
                        int.parse(dateParts[1]),
                        int.parse(dateParts[2])
                    );

                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: startDate.add(const Duration(days: 1)),
                      firstDate: startDate.add(const Duration(days: 1)), // Must be after start date
                      lastDate: DateTime(2101),
                    );

                    if (pickedDate != null) {
                      String formattedDate = "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
                      _endDateController.text = formattedDate;
                      _validateForm();
                    }
                  },
                ),
                CustomDropdown<MatchFormat>(
                  selectedValue: _selectedFormat,
                  onChanged: (value) {
                    setState(() {
                      _selectedFormat = value;
                      _validateForm();
                    });
                  },
                  items: MatchFormat.values,
                  label: 'Type (*)',
                  getLabel: (format) => format.label,
                ),
                AppTextFormField(
                  controller: _socialController,
                  labelText: 'Social',
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 16),
                ValueListenableBuilder<bool>(
                  valueListenable: _isFormValid,
                  builder: (context, isValid, child) {
                    return FilledButton(
                      onPressed: isValid
                          ? () {
                              final creatTournamentRequest =
                                  CreateTournamentRequest(
                                name: _nameController.text,
                                location:
                                    '${selectedProvince!}, ${selectedDistrict!}',
                                maxPlayer: int.parse(_maxPlayerController.text),
                                description: _descriptionController.text,
                                note: generateTournamentPolicy(
                                    name: _nameController.text,
                                    location:
                                        '${selectedProvince!}, ${selectedDistrict!}',
                                    startDate: DateTime.parse(
                                        _startDateController.text),
                                    endDate:
                                        DateTime.parse(_endDateController.text),
                                    isFree: _isFree,
                                    entryFee: _entryFeeController.text,
                                    type: MatchFormat.fromValue(
                                            _selectedFormat!.value)!
                                        .label,
                                    maxPlayer:
                                        int.parse(_maxPlayerController.text),
                                    totalPrize: double.parse(
                                        _totalPrizeController.text),
                                    isMinRanking:
                                        _selectedMinRanking?.value.toString(),
                                    isMaxRanking:
                                        _selectedMaxRanking?.value.toString(),
                                    social: _socialController.text,
                                    contactEmail: contactEmail,
                                    contactPhone: contactPhone),
                                totalPrize:
                                    int.parse(_totalPrizeController.text),
                                startDate:
                                    DateTime.parse(_startDateController.text),
                                endDate:
                                    DateTime.parse(_endDateController.text),
                                social: _socialController.text,
                                entryFee: _entryFeeController.text.isNotEmpty
                                    ? double.parse(_entryFeeController.text)
                                    : null,
                                isFree: _isFree,
                                isMinRanking: _selectedMinRanking?.value,
                                isMaxRanking: _selectedMaxRanking?.value,
                                banner: _bannerUrl ?? AppStrings.bannerUrl,
                                type: _selectedFormat!.value,
                              );
                              AutoRouter.of(context).popAndPush(PolicyTournamentRoute(
                                  createTournamentRequest:
                                      creatTournamentRequest));
                            }
                          : null,
                      child: Text(
                        'Next',
                        style: TextStyle(
                          fontSize: 16,
                          color: isValid ? Colors.white : Colors.grey,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          )),
    );
  }
}
