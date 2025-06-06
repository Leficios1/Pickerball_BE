import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pickleball_app/core/constants/app_enums.dart';
import 'package:pickleball_app/core/constants/app_global.dart';
import 'package:pickleball_app/core/constants/app_strings.dart';
import 'package:pickleball_app/core/widgets/app_text_form_field.dart';
import 'package:pickleball_app/core/widgets/image_picker_widget.dart';
import 'package:pickleball_app/features/authentication/bloc/role/role_bloc.dart';
import 'package:pickleball_app/features/authentication/bloc/role/role_event.dart';

import '../bloc/authentication/authentication_bloc.dart';
import '../bloc/authentication/authentication_state.dart';

class FormRegisterSponsor extends StatefulWidget {
  const FormRegisterSponsor({super.key});

  @override
  _FormRegisterSponsorState createState() => _FormRegisterSponsorState();
}

class _FormRegisterSponsorState extends State<FormRegisterSponsor> {
  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _contactEmailController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _urlSocialController = TextEditingController();
  final TextEditingController _urlSocial1Controller = TextEditingController();
  final ValueNotifier<bool> _isFormValid = ValueNotifier(false);
  XFile? _logoImage;
  int? userInfo;
  String? _logoImageUrl;

  @override
  void initState() {
    super.initState();
    _companyNameController.addListener(_validateForm);
    _contactEmailController.addListener(_validateForm);
    _descriptionController.addListener(_validateForm);
    _urlSocialController.addListener(_validateForm);
  }

  void _validateForm() {
    _isFormValid.value = _companyNameController.text.isNotEmpty &&
        _contactEmailController.text.isNotEmpty &&
        _descriptionController.text.isNotEmpty &&
        _urlSocialController.text.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) {
        if (state is AuthenticationRegisterSuccess) {
          userInfo = state.userId;
        }
        return SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Form(
            child: Column(
              children: <Widget>[
                Text(AppStrings.sponsorContent,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                ImagePickerWidget(
                  image: _logoImage,
                  onImagePicked: (image) {
                    setState(() async {
                      _logoImageUrl = await globalCloudinaryService.uploadImage(
                        File(image!.path),);
                    });
                  },
                ),
                const SizedBox(height: 16),
                AppTextFormField(
                  controller: _companyNameController,
                  labelText: 'Company Name *',
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  readOnly: false,
                ),
                AppTextFormField(
                    controller: _contactEmailController,
                    labelText: 'Contact Email *',
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    readOnly: false),
                AppTextFormField(
                    controller: _descriptionController,
                    labelText: 'Description *',
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    readOnly: false),
                AppTextFormField(
                    controller: _urlSocialController,
                    labelText: 'Social URL *',
                    keyboardType: TextInputType.url,
                    textInputAction: TextInputAction.next,
                    readOnly: false),
                AppTextFormField(
                    controller: _urlSocial1Controller,
                    labelText: 'Additional Social URL',
                    keyboardType: TextInputType.url,
                    textInputAction: TextInputAction.next,
                    readOnly: false),
                const SizedBox(height: 16),
                Text('Note: ${AppStrings.sponsorNote}',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                Center(
                  child: ValueListenableBuilder<bool>(
                    valueListenable: _isFormValid,
                    builder: (context, isValid, child) {
                      return FilledButton(
                        onPressed: isValid && userInfo != null
                            ? () {
                                context.read<RoleBloc>().add(
                                      RegisterRoleRequested(
                                        role: RoleUser.sponsor.value,
                                        id: userInfo!,
                                        companyURL: _logoImageUrl,
                                        companyName:
                                            _companyNameController.text,
                                        contactEmail:
                                            _contactEmailController.text,
                                        description:
                                            _descriptionController.text,
                                        socialMedia: _urlSocialController.text,
                                        additionalSocialMedia:
                                            _urlSocial1Controller
                                                    .text.isNotEmpty
                                                ? _urlSocial1Controller.text
                                                : null,
                                        context: context,
                                      ),
                                    );
                              }
                            : null,
                        child: Text(AppStrings.roleRegister,
                            style: TextStyle(
                                fontSize: 16,
                                color: isValid ? Colors.white : Colors.grey)),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
