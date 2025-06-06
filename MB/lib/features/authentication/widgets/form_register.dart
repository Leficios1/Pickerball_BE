import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:phone_input/phone_input_package.dart';
import 'package:pickleball_app/core/constants/app_enums.dart';
import 'package:pickleball_app/core/constants/app_regex.dart';
import 'package:pickleball_app/core/constants/app_strings.dart';
import 'package:pickleball_app/core/themes/app_colors.dart';
import 'package:pickleball_app/core/utils/limited_text_widget.dart';
import 'package:pickleball_app/core/utils/snackbar_helper.dart';
import 'package:pickleball_app/core/widgets/app_text_form_field.dart';
import 'package:pickleball_app/core/widgets/custom_dropdown.dart';
import 'package:pickleball_app/core/widgets/date_picker_field.dart';
import 'package:pickleball_app/features/authentication/bloc/authentication/authentication_bloc.dart';
import 'package:pickleball_app/features/authentication/bloc/authentication/authentication_event.dart';
import 'package:pickleball_app/features/authentication/bloc/authentication/authentication_state.dart';
import 'package:pickleball_app/router/router.gr.dart';

class FormRegister extends StatefulWidget {
  const FormRegister({super.key});

  @override
  _FormRegisterState createState() => _FormRegisterState();
}

class _FormRegisterState extends State<FormRegister> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController firstNameController;
  late final TextEditingController lastNameController;
  late final TextEditingController secondNameController;
  late final TextEditingController emailController;
  late final TextEditingController passwordController;
  late final TextEditingController confirmPasswordController;
  late final TextEditingController dateOfBirthController;
  late final PhoneController phoneController;
  final ValueNotifier<bool> passwordNotifier = ValueNotifier(true);
  final ValueNotifier<bool> confirmPasswordNotifier = ValueNotifier(true);
  final ValueNotifier<bool> fieldValidNotifier = ValueNotifier(false);

  Gender? selectedGender;
  late StackRouter _stackRouter;

  @override
  void initState() {
    super.initState();
    initializeControllers();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _stackRouter = AutoRouter.of(context);
  }

  @override
  void dispose() {
    disposeControllers();
    super.dispose();
  }

  void initializeControllers() {
    firstNameController = TextEditingController()
      ..addListener(controllerListener);
    lastNameController = TextEditingController()
      ..addListener(controllerListener);
    secondNameController = TextEditingController()
      ..addListener(controllerListener);
    emailController = TextEditingController()..addListener(controllerListener);
    passwordController = TextEditingController()
      ..addListener(controllerListener);
    confirmPasswordController = TextEditingController()
      ..addListener(controllerListener);
    dateOfBirthController = TextEditingController()
      ..addListener(controllerListener);
    phoneController =
        PhoneController(PhoneNumber(isoCode: IsoCode.VN, nsn: ''));
  }

  void disposeControllers() {
    firstNameController.dispose();
    lastNameController.dispose();
    secondNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    dateOfBirthController.dispose();
    phoneController.dispose();
  }

  void controllerListener() {
    final String email = emailController.text;
    final String password = passwordController.text;
    final String confirmPassword = confirmPasswordController.text;

    if (AppRegex.emailRegex.hasMatch(email) &&
        AppRegex.passwordRegex.hasMatch(password) &&
        password == confirmPassword) {
      fieldValidNotifier.value = true;
    } else {
      fieldValidNotifier.value = false;
    }
  }

  Future<void> _selectDateOfBirth(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      setState(() {
        dateOfBirthController.text =
            DateFormat('yyyy-MM-dd').format(pickedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) async {
        if (state is AuthenticationRegisterSuccess) {
          SnackbarHelper.showSnackBar(AppStrings.registrationComplete);
          await Future.delayed(const Duration(seconds: 3));
          _stackRouter.push(RegisterRoleRoute());
        } else if (state is AuthenticationRegisterFailure) {
          SnackbarHelper.showSnackBar(state.message);
        }
      },
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  AppTextFormField(
                    controller: firstNameController,
                    labelText: 'First Name (*)',
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your first name';
                      }
                      return null;
                    },
                  ),
                  AppTextFormField(
                    controller: lastNameController,
                    labelText: 'Last Name (*)',
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your last name';
                      }
                      return null;
                    },
                  ),
                  AppTextFormField(
                    controller: secondNameController,
                    labelText: 'Second Name (*)',
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your second name';
                      }
                      return null;
                    },
                  ),
                  AppTextFormField(
                    controller: emailController,
                    labelText: 'Email (*)',
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!AppRegex.emailRegex.hasMatch(value)) {
                        return 'Invalid email address';
                      }
                      return null;
                    },
                  ),
                  PhoneInput(
                    showArrow: true,
                    shouldFormat: true,
                    validator: PhoneValidator.compose(
                        [PhoneValidator.required(), PhoneValidator.valid()]),
                    flagShape: BoxShape.circle,
                    showFlagInInput: true,
                    decoration: InputDecoration(
                      labelText: 'Phone Number (*)',
                      border: const OutlineInputBorder(),
                    ),
                    countrySelectorNavigator: CountrySelectorNavigator.dialog(),
                    controller: phoneController,
                  ),
                  SizedBox(height: 20),
                  ValueListenableBuilder(
                    valueListenable: passwordNotifier,
                    builder: (_, passwordObscure, __) {
                      return AppTextFormField(
                        obscureText: passwordObscure,
                        controller: passwordController,
                        labelText: 'Password (*)',
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.visiblePassword,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          if (!AppRegex.passwordRegex.hasMatch(value)) {
                            return 'Invalid password';
                          }
                          return null;
                        },
                        suffixIcon: IconButton(
                          onPressed: () =>
                              passwordNotifier.value = !passwordObscure,
                          icon: Icon(
                            passwordObscure
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            size: 20,
                            color: Colors.black,
                          ),
                        ),
                      );
                    },
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.info,
                        color: AppColors.primaryColor,
                        size: 20,
                      ),
                      Flexible(
                        child: LimitedTextWidget(
                          maxLines: 3,
                          content:
                              'The password must be at least 8 characters long.',
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.info,
                        color: AppColors.primaryColor,
                        size: 20,
                      ),
                      Flexible(
                        child: LimitedTextWidget(
                          maxLines: 2,
                          content:
                              'It should include at least one uppercase letter and one special character.',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ValueListenableBuilder(
                    valueListenable: confirmPasswordNotifier,
                    builder: (_, confirmPasswordObscure, __) {
                      return AppTextFormField(
                        obscureText: confirmPasswordObscure,
                        controller: confirmPasswordController,
                        labelText: 'Confirm Password (*)',
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.visiblePassword,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please confirm your password';
                          }
                          if (value != passwordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                        suffixIcon: IconButton(
                          onPressed: () => confirmPasswordNotifier.value =
                              !confirmPasswordObscure,
                          icon: Icon(
                            confirmPasswordObscure
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            size: 20,
                            color: Colors.black,
                          ),
                        ),
                      );
                    },
                  ),
                  DatePickerField(
                    controller: dateOfBirthController,
                    onTap: () => _selectDateOfBirth(context),
                    labelText: 'Date of Birth (*)',
                  ),
                  CustomDropdown<Gender>(
                    selectedValue: selectedGender,
                    onChanged: (gender) =>
                        setState(() => selectedGender = gender),
                    items: Gender.values,
                    label: 'Select Gender (*)',
                    getLabel: (gender) => gender.label,
                  ),
                  const SizedBox(height: 20),
                  ValueListenableBuilder(
                    valueListenable: fieldValidNotifier,
                    builder: (_, isValid, __) {
                      return FilledButton(
                        onPressed: isValid
                            ? () {
                                if (_formKey.currentState!.validate()) {
                                  context.read<AuthenticationBloc>().add(
                                        RegisterRequested(
                                          context: context,
                                          email: emailController.text,
                                          password: passwordController.text,
                                          firstName: firstNameController.text,
                                          lastName: lastNameController.text,
                                          secondName: secondNameController.text,
                                          dateOfBirth:
                                              dateOfBirthController.text,
                                          gender: selectedGender!.label,
                                          phoneNumber:
                                              '+${phoneController.value!.countryCode}${phoneController.value!.nsn}',
                                        ),
                                      );
                                }
                              }
                            : null,
                        child: Text('Register',
                            style: TextStyle(
                                fontSize: 16,
                                color: isValid ? Colors.white : Colors.grey)),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
