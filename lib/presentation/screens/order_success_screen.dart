import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ecomservics/presentation/routes/app_routes.dart';

class OrderSuccessScreen extends StatelessWidget {
  const OrderSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => context.go(AppRoutes.home),
        ),
        title: const Text('Order Status'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  children: [
                    const SizedBox(height: 48),
                    // Success Icon
                    _buildSuccessIcon(theme),
                    const SizedBox(height: 32),
                    Text(
                      'Thank you for your purchase!',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        "Your order has been placed successfully. We'll notify you once it's on its way.",
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.6)),
                      ),
                    ),
                    const SizedBox(height: 40),
                    
                    // Order Details Summary Card
                    _buildOrderIDCard(theme),
                    const SizedBox(height: 32),
                    
                    // Tracking Steps
                    _buildTrackingStep(theme, title: 'Order Placed', subtitle: 'Today, 2:30 PM', completed: true, active: false, last: false),
                    _buildTrackingStep(theme, title: 'Processing', subtitle: 'Expected by tomorrow', completed: false, active: true, last: false),
                    _buildTrackingStep(theme, title: 'Shipped', subtitle: 'Usually within 2-3 days', completed: false, active: false, last: true),
                  ],
                ),
              ),
            ),
            
            // Bottom Actions
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () => context.push(AppRoutes.orderHistory),
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.greenAccent[700],
                        shadowColor: Colors.green.withOpacity(0.3),
                      ),
                      child: const Text('View Order Details'),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () => context.go(AppRoutes.home),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: theme.colorScheme.onSurface.withOpacity(0.05),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: Text(
                        'Return to Homepage', 
                        style: TextStyle(color: theme.colorScheme.onSurface, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuccessIcon(ThemeData theme) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
        ),
        Container(
          width: 70,
          height: 70,
          decoration: const BoxDecoration(
            color: Colors.green,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.check, color: Colors.white, size: 40),
        ),
      ],
    );
  }

  Widget _buildOrderIDCard(ThemeData theme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('ORDER ID', style: theme.textTheme.labelMedium?.copyWith(color: Colors.grey, letterSpacing: 1.2)),
                Text('#ECS-99283', style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold)),
              ],
            ),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('PAYMENT METHOD', style: theme.textTheme.labelMedium?.copyWith(color: Colors.grey, letterSpacing: 1.2)),
                Row(
                  children: [
                    const Icon(Icons.credit_card, size: 16),
                    const SizedBox(width: 8),
                    Text('Visa •••• 4242', style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrackingStep(ThemeData theme, {required String title, required String subtitle, required bool completed, required bool active, required bool last}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: completed ? Colors.green : (active ? Colors.transparent : Colors.transparent),
                border: active ? Border.all(color: Colors.green, width: 2) : (completed ? null : Border.all(color: theme.colorScheme.outline.withOpacity(0.2), width: 2)),
              ),
              child: completed 
                ? const Icon(Icons.check, color: Colors.white, size: 16) 
                : (active ? Center(child: Container(width: 10, height: 10, decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle))) : null),
            ),
            if (!last)
              Container(
                width: 2,
                height: 40,
                color: completed ? Colors.green : theme.colorScheme.outline.withOpacity(0.1),
              ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title, 
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: (completed || active) ? theme.colorScheme.onBackground : theme.colorScheme.onSurface.withOpacity(0.4),
                ),
              ),
              Text(
                subtitle, 
                style: theme.textTheme.bodySmall?.copyWith(
                  color: (completed || active) ? theme.colorScheme.onSurface.withOpacity(0.6) : theme.colorScheme.onSurface.withOpacity(0.3),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
