import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pickleball_app/core/constants/app_enums.dart';
import 'package:pickleball_app/core/constants/app_strings.dart';
import 'package:pickleball_app/core/utils/fetch_provinces.dart';
import 'package:pickleball_app/features/authentication/bloc/authentication/authentication_bloc.dart';
import 'package:pickleball_app/features/authentication/bloc/authentication/authentication_state.dart';
import 'package:pickleball_app/features/authentication/bloc/role/role_bloc.dart';
import 'package:pickleball_app/features/authentication/bloc/role/role_event.dart';

class FormRegisterPlayer extends StatefulWidget {
  const FormRegisterPlayer({super.key});

  @override
  State<FormRegisterPlayer> createState() => _FormRegisterPlayerState();
}

class _FormRegisterPlayerState extends State<FormRegisterPlayer> {
  List<dynamic> provinces = [];
  List<dynamic> districts = [];
  String? selectedProvince;
  String? selectedDistrict;
  final ProvinceService provinceService = ProvinceService();
  final ValueNotifier<String> roleRegisterNotifier =
      ValueNotifier(AppStrings.roleRegister);
  final ValueNotifier<bool> isFormValidNotifier = ValueNotifier(false);

  int? userInfo;

  @override
  void initState() {
    super.initState();
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
    isFormValidNotifier.value =
        selectedProvince != null && selectedDistrict != null;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) {
        if (state is AuthenticationRegisterSuccess) {
          userInfo = state.userId;
        }

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 16),
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
                  ? const Text("Please select a province first")
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
              _buildTips(),
              const SizedBox(height: 16),
              Center(
                child: ValueListenableBuilder<bool>(
                  valueListenable: isFormValidNotifier,
                  builder: (context, isValid, child) {
                    return ValueListenableBuilder<String>(
                      valueListenable: roleRegisterNotifier,
                      builder: (context, value, child) {
                        return FilledButton(
                          onPressed: isValid && userInfo != null
                              ? () {
                                  context.read<RoleBloc>().add(
                                        RegisterRoleRequested(
                                          role: RoleUser.player.value,
                                          id: userInfo!,
                                          province: selectedProvince!,
                                          city: selectedDistrict!,
                                          context: context,
                                        ),
                                      );
                                }
                              : null,
                          child: Text(value,
                              style: TextStyle(
                                  fontSize: 16,
                                  color: isValid ? Colors.white : Colors.grey)),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTips() {
    return Text(
      'Tips: ${AppStrings.playerTips}',
      style: const TextStyle(
        fontSize: 16,
        fontStyle: FontStyle.italic,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
