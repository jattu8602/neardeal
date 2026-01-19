import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationPermissionScreen extends StatefulWidget {
  const NotificationPermissionScreen({super.key});

  @override
  State<NotificationPermissionScreen> createState() =>
      _NotificationPermissionScreenState();
}

class _NotificationPermissionScreenState
    extends State<NotificationPermissionScreen> {
  bool _isLoading = false;

  Future<void> _requestNotificationPermission() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Request notification permission
      final status = await Permission.notification.request();

      // Save onboarding completion
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('onboarding_completed', true);

      if (mounted) {
        if (status.isGranted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Notification permission granted!'),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Notification permission denied'),
              backgroundColor: Colors.orange,
            ),
          );
        }

        // Navigate to home screen
        Navigator.pushReplacementNamed(context, '/home');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _skipNotification() async {
    // Save onboarding completion
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_completed', true);

    if (mounted) {
      Navigator.pushReplacementNamed(context, '/home');
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
                Icons.notifications_outlined,
                size: 80,
                color: Colors.deepPurple,
              ),
              const SizedBox(height: 32),
              const Text(
                'Enable Notifications',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text(
                'Get notified about new deals, offers, and updates',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.deepPurple.shade50,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    _buildFeature(
                      icon: Icons.local_offer,
                      text: 'Exclusive deals and discounts',
                    ),
                    const SizedBox(height: 16),
                    _buildFeature(
                      icon: Icons.schedule,
                      text: 'Time-sensitive offers',
                    ),
                    const SizedBox(height: 16),
                    _buildFeature(
                      icon: Icons.info_outline,
                      text: 'Important updates',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 48),
              ElevatedButton(
                onPressed: _isLoading ? null : _requestNotificationPermission,
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
                        'Enable Notifications',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: _isLoading ? null : _skipNotification,
                child: const Text(
                  'Maybe Later',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeature({required IconData icon, required String text}) {
    return Row(
      children: [
        Icon(icon, color: Colors.deepPurple, size: 24),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }
}
