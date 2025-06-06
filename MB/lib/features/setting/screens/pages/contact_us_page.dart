import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:pickleball_app/core/themes/app_colors.dart';
import 'package:pickleball_app/core/utils/extensions.dart';
import 'package:pickleball_app/core/utils/responsive_utils.dart';
import 'package:pickleball_app/core/widgets/app_bar_widget.dart';
import 'package:pickleball_app/core/widgets/app_text_form_field.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

@RoutePage()
class ContactUsPage extends StatefulWidget {
  const ContactUsPage({super.key});

  @override
  State<ContactUsPage> createState() => _ContactUsPageState();
}

class _ContactUsPageState extends State<ContactUsPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();
  
  bool _isLoading = false;
  
  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    // Get responsive values
    final screenWidth = context.width;
    final contentPadding = screenWidth < 360 ? 12.0 : 16.0;
    final baseTextSize = ResponsiveUtils.getScaledSize(context, screenWidth < 360 ? 14 : 16);
    final iconSize = screenWidth < 360 ? 20.0 : 24.0;
    
    return Scaffold(
      appBar: AppBarWidget(title: 'Contact Us'),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.all(contentPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Get In Touch',
                style: TextStyle(
                  fontSize: baseTextSize * 1.5,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                ),
              ),
              
              SizedBox(height: 8.h),
              
              Text(
                'We\'d love to hear from you. Fill out the form below and we\'ll get back to you as soon as possible.',
                style: TextStyle(
                  fontSize: baseTextSize * 0.95,
                  color: Colors.grey[700],
                ),
              ),
              
              SizedBox(height: 24.h),
              
              // Contact form
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    AppTextFormField(
                      controller: _nameController,
                      labelText: 'Your Name',
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),
                    
                    AppTextFormField(
                      controller: _emailController,
                      labelText: 'Your Email',
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    
                    AppTextFormField(
                      controller: _subjectController,
                      labelText: 'Subject',
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a subject';
                        }
                        return null;
                      },
                    ),
                    
                    AppTextFormField(
                      controller: _messageController,
                      labelText: 'Message',
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.newline,
                      maxLines: 5,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your message';
                        }
                        return null;
                      },
                    ),
                    
                    SizedBox(height: 24.h),
                    
                    // Submit button
                    SizedBox(
                      width: double.infinity,
                      height: screenWidth < 360 ? 48 : 52,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _submitForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                        ),
                        child: _isLoading
                          ? SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              'Send Message',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: baseTextSize,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                      ),
                    ),
                  ],
                ),
              ),
              
              SizedBox(height: 32.h),
              
              // Alternative contact methods
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Other Ways To Contact Us',
                      style: TextStyle(
                        fontSize: baseTextSize * 1.1,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    
                    SizedBox(height: 16.h),
                    
                    _buildContactMethod(
                      icon: FontAwesomeIcons.envelope,
                      title: 'Email',
                      detail: 'support@pickleball-app.com',
                      iconSize: iconSize,
                      baseTextSize: baseTextSize,
                    ),
                    
                    SizedBox(height: 12.h),
                    
                    _buildContactMethod(
                      icon: FontAwesomeIcons.phone,
                      title: 'Phone',
                      detail: '+1 (555) 123-4567',
                      iconSize: iconSize,
                      baseTextSize: baseTextSize,
                    ),
                    
                    SizedBox(height: 12.h),
                    
                    _buildContactMethod(
                      icon: FontAwesomeIcons.locationDot,
                      title: 'Office',
                      detail: '123 Pickleball St, Sports City, SC 12345',
                      iconSize: iconSize,
                      baseTextSize: baseTextSize,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildContactMethod({
    required IconData icon,
    required String title,
    required String detail,
    required double iconSize,
    required double baseTextSize,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: FaIcon(
            icon,
            color: AppColors.primaryColor,
            size: iconSize,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: baseTextSize,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                detail,
                style: TextStyle(
                  fontSize: baseTextSize * 0.9,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
  
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      
      // Simulate API call
      Future.delayed(Duration(seconds: 2), () {
        setState(() => _isLoading = false);
        
        // Show success message
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Message Sent'),
            content: Text('Thank you for your message. We\'ll get back to you soon!'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  // Clear form fields
                  _nameController.clear();
                  _emailController.clear();
                  _subjectController.clear();
                  _messageController.clear();
                },
                child: Text('OK'),
              ),
            ],
          ),
        );
      });
    }
  }
}
