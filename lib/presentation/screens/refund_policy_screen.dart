import 'package:flutter/material.dart';
import 'package:ecomservics/presentation/widgets/static_content_screen.dart';

class RefundPolicyScreen extends StatelessWidget {
  const RefundPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const StaticContentScreen(
      title: 'Refund Policy',
      content: '''
Refund & Return Policy

We want you to be completely satisfied with your purchase. If you are not happy, we are here to help.

Returns
• You have 30 calendar days to return an item from the date you received it.
• To be eligible for a return, your item must be unused and in the same condition that you received it.
• Your item must be in the original packaging.

Refunds
• Once we receive your item, we will inspect it and notify you that we have received your returned item.
• If your return is approved, we will initiate a refund to your original method of payment.
• You will receive the credit within a certain amount of days, depending on your card issuer's policies.

Shipping
• You will be responsible for paying for your own shipping costs for returning your item.
• Shipping costs are non-refundable.

Damaged Items
If you receive a damaged or defective item, please contact us immediately for a replacement or refund.
''',
    );
  }
}
