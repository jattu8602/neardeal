import 'package:flutter/material.dart';

class ProductRoomSelectionScreen extends StatefulWidget {
  const ProductRoomSelectionScreen({super.key});

  @override
  State<ProductRoomSelectionScreen> createState() =>
      _ProductRoomSelectionScreenState();
}

class _ProductRoomSelectionScreenState
    extends State<ProductRoomSelectionScreen> {
  String? selectedOption;

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
                Icons.shopping_bag_outlined,
                size: 80,
                color: Colors.deepPurple,
              ),
              const SizedBox(height: 32),
              const Text(
                'What are you looking for?',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text(
                'Select what you want to buy',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              _buildOptionCard(
                title: 'Products',
                icon: Icons.inventory_2_outlined,
                description: 'Buy various products',
                value: 'products',
              ),
              const SizedBox(height: 16),
              _buildOptionCard(
                title: 'Rooms',
                icon: Icons.room_outlined,
                description: 'Book rooms and spaces',
                value: 'rooms',
              ),
              const SizedBox(height: 48),
              ElevatedButton(
                onPressed: selectedOption == null
                    ? null
                    : () {
                        Navigator.pushNamed(context, '/google-auth');
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Continue',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionCard({
    required String title,
    required IconData icon,
    required String description,
    required String value,
  }) {
    final isSelected = selectedOption == value;
    return InkWell(
      onTap: () {
        setState(() {
          selectedOption = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? Colors.deepPurple : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(16),
          color: isSelected ? Colors.deepPurple.shade50 : Colors.white,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 40,
              color: isSelected ? Colors.deepPurple : Colors.grey,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.deepPurple : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: Colors.deepPurple,
                size: 28,
              ),
          ],
        ),
      ),
    );
  }
}
