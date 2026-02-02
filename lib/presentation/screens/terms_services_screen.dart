import 'package:flutter/material.dart';
import 'package:ecomservics/presentation/widgets/static_content_screen.dart';

class TermsServicesScreen extends StatelessWidget {
  const TermsServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const StaticContentScreen(
      title: 'Terms & Services',
      content: '''
Terms of Service

By using the EcomService application, you agree to the following terms and conditions:

1. Acceptance of Terms
By accessing or using our app, you acknowledge that you have read, understood, and agree to be bound by these terms.

2. User Accounts
You are responsible for maintaining the confidentiality of your account and password. You agree to notify us of any unauthorized use.

3. Purchasing
All purchases made through the app are subject to product availability and our right to refuse or cancel orders.

4. Pricing
We reserve the right to change prices at any time without prior notice.

5. Prohibited Conduct
Users agree not to use the app for any unlawful purpose or to interfere with the operation of the app.

6. Limitation of Liability
EcomService shall not be liable for any indirect, incidental, or consequential damages resulting from the use of our services.

7. Modifications to Terms
We reserve the right to modify these terms at any time. Your continued use of the app signifies acceptance of the updated terms.
''',
    );
  }
}
