import 'package:flutter/material.dart';
import 'package:ecomservics/presentation/widgets/static_content_screen.dart';

class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const StaticContentScreen(
      title: 'About App',
      content: '''
Welcome to EcomService!

EcomService is your one-stop destination for premium electronics and lifestyle products. Our mission is to provide the best shopping experience with a focus on quality, reliability, and customer satisfaction.

Version: 2.4.1
Build: 120
Developed by: Kottland Team

We are constantly working to improve our application. If you have any feedback or suggestions, please feel free to reach out to our support team.

Features:
• Real-time inventory tracking
• Secure checkout process
• Order history & status updates
• Personalized theme and language settings

Thank you for choosing EcomService!
''',
    );
  }
}
