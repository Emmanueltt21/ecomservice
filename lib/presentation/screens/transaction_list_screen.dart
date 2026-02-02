import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ecomservics/presentation/routes/app_routes.dart';

class TransactionListScreen extends StatelessWidget {
  const TransactionListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => context.pop(),
        ),
        title: const Text('Transaction List'),
        actions: [
          IconButton(
            icon: Icon(Icons.tune, color: theme.colorScheme.primary),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Summary Cards
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                _buildSummaryCard(
                  theme,
                  label: 'INCOME',
                  amount: '+\$4,250.00',
                  color: Colors.green,
                  percentage: '+12%',
                  icon: Icons.trending_up,
                ),
                const SizedBox(width: 12),
                _buildSummaryCard(
                  theme,
                  label: 'SPENDING',
                  amount: '-\$1,840.20',
                  color: Colors.red,
                  percentage: '+5%',
                  icon: Icons.trending_down,
                ),
              ],
            ),
          ),
          
          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search transactions, methods...',
                prefixIcon: const Icon(Icons.search),
                fillColor: theme.brightness == Brightness.light ? const Color(0xFFF6F6F8) : theme.colorScheme.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          
          // List
          Expanded(
            child: ListView(
              children: [
                _buildSectionLabel(theme, 'TODAY'),
                _buildTransactionItem(
                  theme,
                  title: 'Refund - Order #8821',
                  subtitle: 'via Stripe • 02:15 PM',
                  amount: '+\$124.50',
                  amountColor: Colors.green,
                  icon: Icons.settings_backup_restore,
                  iconBg: theme.colorScheme.primary.withOpacity(0.1),
                  iconColor: theme.colorScheme.primary,
                ),
                _buildTransactionItem(
                  theme,
                  title: 'Nike Air Max Store',
                  subtitle: 'via Apple Pay • 11:45 AM',
                  amount: '-\$210.00',
                  amountColor: Colors.red,
                  icon: Icons.shopping_bag,
                  iconBg: theme.colorScheme.onSurface.withOpacity(0.05),
                  iconColor: theme.colorScheme.onSurface,
                ),
                
                _buildSectionLabel(theme, 'YESTERDAY'),
                _buildTransactionItem(
                  theme,
                  title: 'Wallet Top-up',
                  subtitle: 'via MOMO • 09:20 PM',
                  amount: '+\$500.00',
                  amountColor: Colors.green,
                  icon: Icons.account_balance_wallet,
                  iconBg: Colors.green.withOpacity(0.1),
                  iconColor: Colors.green,
                ),
                _buildTransactionItem(
                  theme,
                  title: 'Cashback Bonus',
                  subtitle: 'via System • 06:10 PM',
                  amount: '+\$15.25',
                  amountColor: Colors.green,
                  icon: Icons.redeem,
                  iconBg: theme.colorScheme.primary.withOpacity(0.1),
                  iconColor: theme.colorScheme.primary,
                ),
              ],
            ),
          ),
          
          // Bottom Indicator Emulator
          Container(height: 32),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(ThemeData theme, {required String label, required String amount, required Color color, required String percentage, required IconData icon}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: theme.colorScheme.outline.withOpacity(0.1)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: theme.textTheme.labelSmall?.copyWith(color: Colors.grey, fontWeight: FontWeight.bold, letterSpacing: 1)),
            const SizedBox(height: 4),
            Text(amount, style: TextStyle(color: color, fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(icon, size: 14, color: color),
                const SizedBox(width: 4),
                Text(percentage, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionLabel(ThemeData theme, String label) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
      child: Text(
        label, 
        style: theme.textTheme.labelMedium?.copyWith(
          color: Colors.grey, 
          fontWeight: FontWeight.bold, 
          letterSpacing: 1.5,
        ),
      ),
    );
  }

  Widget _buildTransactionItem(ThemeData theme, {
    required String title, 
    required String subtitle, 
    required String amount, 
    required Color amountColor,
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
  }) {
    return ListTile(
      onTap: () {},
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      leading: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: iconBg,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: iconColor),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle, style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey)),
      trailing: Text(amount, style: TextStyle(color: amountColor, fontWeight: FontWeight.bold, fontSize: 16)),
    );
  }
}
