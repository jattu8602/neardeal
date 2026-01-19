import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class MobileNumberScreen extends StatefulWidget {
  const MobileNumberScreen({super.key});

  @override
  State<MobileNumberScreen> createState() => _MobileNumberScreenState();
}

class _MobileNumberScreenState extends State<MobileNumberScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _submitPhoneNumber() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        Navigator.pushNamed(context, '/notifications');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(
                Icons.phone_android_outlined,
                size: 80,
                color: Colors.deepPurple,
              ),
              const SizedBox(height: 32),
              const Text(
                'Enter your mobile number',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              Form(
                key: _formKey,
                child: IntlPhoneField(
                  controller: _phoneController,
                  initialCountryCode: 'IN', // India by default
                  flagsButtonPadding: const EdgeInsets.only(left: 10),
                  dropdownIconPosition: IconPosition.trailing,
                  decoration: InputDecoration(
                    labelText: 'Mobile Number *',
                    hintText: '8602074069',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade50,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    counterText: '',
                  ),
                  validator: (phone) {
                    // Mobile number is required
                    if (phone == null || phone.number.isEmpty) {
                      return 'Mobile number is required';
                    }
                    // Validate that mobile number has at least 10 digits
                    final digitsOnly = phone.number.replaceAll(RegExp(r'[^\d]'), '');
                    if (digitsOnly.length < 10) {
                      return 'Mobile number must be at least 10 digits';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.phone,
                  inputFormatters: [],
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _isLoading ? null : _submitPhoneNumber,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text(
                        'Continue',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
