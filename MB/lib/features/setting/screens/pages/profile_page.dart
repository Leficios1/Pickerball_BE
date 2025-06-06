import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:pickleball_app/core/services/user/dto/update_user_request.dart';
import 'package:pickleball_app/core/themes/app_colors.dart';
import 'package:pickleball_app/core/utils/snackbar_helper.dart';
import 'package:pickleball_app/core/widgets/app_text_form_field.dart';
import 'package:pickleball_app/core/widgets/date_picker_field.dart';
import 'package:pickleball_app/features/setting/bloc/profile/profile_bloc.dart';
import 'package:pickleball_app/features/setting/bloc/profile/profile_event.dart';
import 'package:pickleball_app/features/setting/bloc/profile/profile_state.dart';
import 'package:pickleball_app/features/setting/bloc/settings_bloc.dart';
import 'package:pickleball_app/router/router.gr.dart';

import '../../../../core/constants/app_global.dart';

@RoutePage()
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isEditing = false;
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController secondNameController;
  String? avatarUrl;

  String? _initialFirstName;
  String? _initialLastName;
  String? _initialSecondName;
  String? _initialAvatarUrl;

  String? _changeFirstName;
  String? _changeLastName;
  String? _changeSecondName;
  String? _changeAvatarUrl;

  final ValueNotifier<bool> _isEditableNotifier = ValueNotifier<bool>(false);


  @override
  void initState() {
    super.initState();
    context.read<ProfileBloc>().add(LoadProfile());
    firstNameController = TextEditingController();
    lastNameController = TextEditingController();
    secondNameController = TextEditingController();
  }

  void _checkForChanges() {
    bool hasChanges = false;

    if (_changeFirstName != null && _changeFirstName != _initialFirstName) {
      hasChanges = true;
    }
    if (_changeLastName != null && _changeLastName != _initialLastName) {
      hasChanges = true;
    }
    if (_changeSecondName != null && _changeSecondName != _initialSecondName) {
      hasChanges = true;
    }
    if (_changeAvatarUrl != null && _changeAvatarUrl != _initialAvatarUrl) {
      hasChanges = true;
    }

    _isEditableNotifier.value = hasChanges;
  }
  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      String? uploadedUrl = await globalCloudinaryService.uploadImage(File(image.path));
      if (uploadedUrl != null) {
        setState(() {
          _changeAvatarUrl = uploadedUrl;
        });
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => AutoRouter.of(context).popAndPush(SettingRoute()),
        ),
        backgroundColor: AppColors.primaryColor,
      ),
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoading) {
            return Center(
              child: LoadingAnimationWidget.threeRotatingDots(
                color: AppColors.primaryColor,
                size: 50,
              ),
            );
          } else if (state is ProfileLoaded) {
            final userInfo = state.user;
            var displayName = '${userInfo.firstName} ${userInfo.lastName} ${userInfo.secondName ?? ''}';
            avatarUrl = userInfo.avatarUrl ?? "";
            _initialFirstName = userInfo.firstName;
            _initialLastName = userInfo.lastName;
            _initialSecondName = userInfo.secondName;
            _initialAvatarUrl = userInfo.avatarUrl;

            if (_changeFirstName != null) {
              firstNameController.text = _changeFirstName!;
            } else {
              firstNameController.text = _initialFirstName ?? '';
            }

            if (_changeLastName != null) {
              lastNameController.text = _changeLastName!;
            } else {
              lastNameController.text = _initialLastName ?? '';
            }

            if (_changeSecondName != null) {
              secondNameController.text = _changeSecondName!;
            } else {
              secondNameController.text = _initialSecondName ?? '';
            }

            if (_changeAvatarUrl != null) {
              _initialAvatarUrl = _changeAvatarUrl;
            }else{
              _initialAvatarUrl = userInfo.avatarUrl;
            }

            return SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: double.maxFinite,
                    height: 200,
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: isEditing ? pickImage : null,
                            child: CircleAvatar(
                              radius: 50,
                              backgroundImage: NetworkImage(
                                _changeAvatarUrl ?? _initialAvatarUrl ?? '',
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            displayName,
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppTextFormField(
                          textInputAction: TextInputAction.done,
                          labelText: 'Email',
                          keyboardType: TextInputType.emailAddress,
                          controller: TextEditingController(text: userInfo.email),
                          readOnly: true,
                        ),
                        AppTextFormField(
                          textInputAction: TextInputAction.done,
                          labelText: 'Last Name',
                          keyboardType: TextInputType.text,
                          controller: lastNameController,
                          readOnly: !isEditing,
                          onChanged: (value) {
                            setState(() {
                              _changeLastName = value;
                              _checkForChanges();
                            });
                          },
                        ),
                        AppTextFormField(
                          textInputAction: TextInputAction.done,
                          labelText: 'Second Name',
                          keyboardType: TextInputType.text,
                          controller: secondNameController,
                          readOnly: !isEditing,
                          onChanged: (value) {
                            setState(() {
                              _changeSecondName = value;
                              _checkForChanges();
                            });
                          },
                        ),
                        AppTextFormField(
                          textInputAction: TextInputAction.done,
                          labelText: 'Phone Number',
                          keyboardType: TextInputType.phone,
                          controller: TextEditingController(text: userInfo.phoneNumber),
                          readOnly: true,
                        ),
                        DatePickerField(
                          controller: TextEditingController(
                              text: userInfo.dateOfBirth != null
                                  ? DateFormat('yyyy-MM-dd').format(userInfo.dateOfBirth!)
                                  : 'Not provided'
                          ),
                          labelText: 'Date of Birth',
                          readOnly: true, onTap: () {  },
                        ),
                        AppTextFormField(
                          textInputAction: TextInputAction.done,
                          labelText: 'Gender',
                          keyboardType: TextInputType.text,
                          controller: TextEditingController(
                              text: userInfo.gender?.toString() ?? 'Not provided'
                          ),
                          readOnly: true,
                        ),
                        if(userInfo.userDetails != null) ...[
                          AppTextFormField(
                            textInputAction: TextInputAction.done,
                            labelText: 'Player Level',
                            keyboardType: TextInputType.text,
                            controller: TextEditingController(
                                text: userInfo.userDetails!.experienceLevel.toString()
                            ),
                            readOnly: true,
                          ),
                          AppTextFormField(
                            textInputAction: TextInputAction.done,
                            labelText: 'Player Point',
                            keyboardType: TextInputType.number,
                            controller: TextEditingController(
                                text: userInfo.userDetails!.rankingPoint.toString()
                            ),
                            readOnly: true,
                          ),
                          AppTextFormField(
                            textInputAction: TextInputAction.done,
                            labelText: 'Address',
                            keyboardType: TextInputType.text,
                            controller: TextEditingController(
                                text: '${userInfo.userDetails!.province}, ${userInfo.userDetails!.city}'
                            ),
                            readOnly: true,
                          ),
                        ],
                        if(userInfo.sponsorDetails != null) ...[
                          AppTextFormField(
                            textInputAction: TextInputAction.done,
                            labelText: 'Company Name',
                            keyboardType: TextInputType.text,
                            controller: TextEditingController(
                                text: userInfo.sponsorDetails!.companyName
                            ),
                            readOnly: true,
                          ),
                          AppTextFormField(
                            textInputAction: TextInputAction.done,
                            labelText: 'Contact Email',
                            keyboardType: TextInputType.emailAddress,
                            controller: TextEditingController(
                                text: userInfo.sponsorDetails!.contactEmail
                            ),
                            readOnly: true,
                          ),
                          AppTextFormField(
                            textInputAction: TextInputAction.done,
                            labelText: 'Social',
                            keyboardType: TextInputType.url,
                            controller: TextEditingController(
                                text: userInfo.sponsorDetails!.urlSocial
                            ),
                            readOnly: true,
                          ),
                        ],
                      ],
                    ),
                  ),
                  Center(
                    child: Container(
                      width: double.infinity,
                      margin: const EdgeInsets.all(20),
                      child: ValueListenableBuilder<bool>(
                        valueListenable: _isEditableNotifier,
                        builder: (context, isEditable, _) {
                          return ElevatedButton(
                            onPressed: isEditing
                                ? (isEditable
                                ? () {
                                  context.read<ProfileBloc>().add(EditProfile(
                                      context: context,
                                      request: UpdateUserRequest(
                                        avatarUrl: _changeAvatarUrl,
                                        firstName: _changeFirstName,
                                        lastName: _changeLastName,
                                        secondName: _changeSecondName,
                                      )));
                              SnackbarHelper.showSnackBar('Information saved successfully!');
                              setState(() {
                                isEditing = false;
                              });
                            }
                                : null)
                                : () {
                              setState(() {
                                isEditing = true;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryColor,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 40,
                                vertical: 10,
                              ),
                              textStyle: TextStyle(color: Colors.white),
                            ),
                            child: Text(
                              isEditing ? "Save now" : "Edit Info",
                              style: TextStyle(
                                fontSize: 18,
                                color: isEditing
                                    ? (isEditable ? Colors.white : Colors.grey)
                                    : Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        },
                      )
                    ),
                  ),
                ],
              ),
            );
          } else if (state is ProfileError) {
            return Center(child: Text(state.message));
          }
          return const Center(child: Text("Unable to load profile."));
        },
      ),
    );
  }
}