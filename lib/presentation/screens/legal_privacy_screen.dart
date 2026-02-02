import 'package:flutter/material.dart';
import 'package:ecomservics/presentation/widgets/static_content_screen.dart';

class LegalPrivacyScreen extends StatelessWidget {
  const LegalPrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const StaticContentScreen(
      title: 'Legal & Privacy',
      content: '''
Privacy Policy

Your privacy is important to us. This policy explains how we collect, use, and protect your personal information.

1. Information We Collect
We collect information you provide directly to us, such as when you create an account, place an order, or contact us.

2. How We Use Information
We use your information to process orders, provide customer support, and improve our services.

3. Data Security
We implement industry-standard security measures to protect your data. However, no method of transmission over the internet is 100% secure.

4. Cookies
We use cookies to enhance your browsing experience and analyze app traffic.

5. Third-Party Services
We may use third-party services for payments and analytics. These providers have their own privacy policies.

Legal Information
All content in this app is owned by Kottland Team or its licensors. Unauthorized use is prohibited.

Last Updated: February 2026
''',
    );
  }
}
