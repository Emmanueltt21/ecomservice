import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ecomservics/presentation/routes/app_routes.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  int _selectedPaymentMethod = 0; // 0: Card, 1: Mobile, 2: COD

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => context.pop(),
        ),
        title: const Text('Checkout'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Progress Indicator
            _buildProgressIndicator(context),
            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Delivery Address Section
                  _buildSectionHeader(context, 'Delivery Address', action: 'Pick on Map'),
                  _buildAddressCard(context),
                  const SizedBox(height: 12),
                  _buildMapPreview(),
                  
                  const SizedBox(height: 32),
                  
                  // Payment Method Section
                  _buildSectionHeader(context, 'Payment Method'),
                  _buildPaymentMethod(
                    context, 
                    index: 0,
                    title: 'Credit or Debit Card', 
                    subtitle: 'Secure payment via Stripe',
                    icon: Icons.credit_card,
                  ),
                  _buildPaymentMethod(
                    context, 
                    index: 1,
                    title: 'Mobile Wallet', 
                    subtitle: 'Orange Money / MOMO',
                    icon: Icons.account_balance_wallet_outlined,
                  ),
                  _buildPaymentMethod(
                    context, 
                    index: 2,
                    title: 'Cash on Delivery', 
                    subtitle: 'Pay when you receive',
                    icon: Icons.payments_outlined,
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Promo Code Section
                  _buildSectionLabel(context, 'PROMO CODE'),
                  _buildPromoCodeField(context),
                  
                  const SizedBox(height: 24),
                  
                  // Order Summary Section
                  _buildOrderSummary(context),
                  const SizedBox(height: 120), // Bottom padding for fixed button
                ],
              ),
            ),
          ],
        ),
      ),
      bottomSheet: _buildBottomAction(context),
    );
  }

  Widget _buildProgressIndicator(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(height: 8, width: 8, decoration: BoxDecoration(color: primary, shape: BoxShape.circle)),
          Container(height: 4, width: 40, decoration: BoxDecoration(color: primary, borderRadius: BorderRadius.circular(2))),
          Container(height: 8, width: 8, decoration: BoxDecoration(color: primary, shape: BoxShape.circle)),
          Container(height: 4, width: 40, decoration: BoxDecoration(color: Theme.of(context).colorScheme.outline.withOpacity(0.2), borderRadius: BorderRadius.circular(2))),
          Container(height: 8, width: 8, decoration: BoxDecoration(color: Theme.of(context).colorScheme.outline.withOpacity(0.2), shape: BoxShape.circle)),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, {String? action}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
          if (action != null)
            TextButton(
              onPressed: () {},
              child: Text(action, style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold)),
            ),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(BuildContext context, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        label, 
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildAddressCard(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.location_on, color: theme.colorScheme.primary),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Home', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  Text(
                    '123 Innovation Drive, Silicon Valley, CA 94043, USA',
                    style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.6)),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () {}, 
              icon: Icon(Icons.edit_outlined, color: theme.colorScheme.onSurface.withOpacity(0.4)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMapPreview() {
    return Container(
      height: 120,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(16),
        image: const DecorationImage(
          image: NetworkImage("https://lh3.googleusercontent.com/aida-public/AB6AXuAsKqBTsAJf1syA8yziQAcQ0bP4-2LigDaEOj60QT5tdSmNznH4qozPzyXl0L4ubFhTUYPaO8e4kKMrSx15FSU_f51jA4CdpCkfURgIcg3pc_tWhHBogv5CeGdDaBGq354C50LTcj3m-lJFYoFkupPfonlfrse-8SjgGML5iSAz3GHDqodCdNGdn6nUh4pwmVtbAkXUzz-ktfUhHQTDP1BBTnATQClSxjAs_6kA70pqJpa5yr2IEkstz3udRSFOr4JPmEVzDXWFdg"),
          fit: BoxFit.cover,
        ),
      ),
      child: Center(
        child: Icon(Icons.location_on, color: Theme.of(context).colorScheme.primary, size: 40),
      ),
    );
  }

  Widget _buildPaymentMethod(BuildContext context, {required int index, required String title, required String subtitle, required IconData icon}) {
    final theme = Theme.of(context);
    final isSelected = _selectedPaymentMethod == index;
    
    return GestureDetector(
      onTap: () => setState(() => _selectedPaymentMethod = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.cardTheme.color,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? theme.colorScheme.primary : (theme.brightness == Brightness.light ? const Color(0xFFF0F0F0) : Colors.white10),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected ? [BoxShadow(color: theme.colorScheme.primary.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4))] : null,
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: theme.colorScheme.onSurface.withOpacity(0.6)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  Text(subtitle, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.6))),
                ],
              ),
            ),
            Container(
              height: 20,
              width: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? theme.colorScheme.primary : theme.colorScheme.outline.withOpacity(0.5),
                  width: 2,
                ),
              ),
              child: isSelected 
                  ? Center(child: Container(width: 10, height: 10, decoration: BoxDecoration(color: theme.colorScheme.primary, shape: BoxShape.circle))) 
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPromoCodeField(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Expanded(
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Enter coupon code',
              fillColor: theme.brightness == Brightness.light ? Colors.white : theme.colorScheme.surface,
            ),
          ),
        ),
        const SizedBox(width: 12),
        SizedBox(
          height: 56,
          child: TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
              padding: const EdgeInsets.symmetric(horizontal: 24),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            child: Text('Apply', style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }

  Widget _buildOrderSummary(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Order Summary', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            _buildSummaryRow('Subtotal', '\$249.00'),
            const SizedBox(height: 12),
            _buildSummaryRow('Shipping', 'Free', isFree: true),
            const SizedBox(height: 12),
            _buildSummaryRow('Estimated Tax', '\$12.45'),
            const Divider(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                Text('\$261.45', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: theme.colorScheme.primary)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isFree = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey)),
        Text(
          value, 
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isFree ? Colors.green : null,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomAction(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        border: Border(top: BorderSide(color: theme.colorScheme.outline.withOpacity(0.1))),
      ),
      child: FractionallySizedBox(
        widthFactor: 1.0,
        child: FilledButton(
          onPressed: () => context.go(AppRoutes.orderSuccess),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text('Place Order'),
              SizedBox(width: 8),
              Icon(Icons.arrow_forward, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
