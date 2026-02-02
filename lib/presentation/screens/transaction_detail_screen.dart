import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TransactionDetailScreen extends StatelessWidget {
  const TransactionDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, size: 18),
              onPressed: () => context.pop(),
            ),
          ),
        ),
        title: const Text('Transaction Detail'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 32),
            // Header
            Center(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.check_circle, color: theme.colorScheme.primary, size: 40),
                  ),
                  const SizedBox(height: 16),
                  Text('\$142.50', style: theme.textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold, fontSize: 40)),
                  const SizedBox(height: 8),
                  Text(
                    'PAYMENT SUCCESSFUL', 
                    style: TextStyle(color: theme.colorScheme.primary, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.5),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Receipt Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: _buildReceiptCard(theme),
            ),
            
            const SizedBox(height: 32),
            
            // Actions
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.download, size: 20),
                          SizedBox(width: 8),
                          Text('Download Receipt'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        backgroundColor: theme.colorScheme.surface,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(color: theme.colorScheme.outline.withOpacity(0.1)),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.support_agent, color: theme.colorScheme.primary),
                          const SizedBox(width: 8),
                          Text('Contact Support', style: TextStyle(color: theme.colorScheme.onSurface, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            TextButton(
              onPressed: () {},
              child: Text('Questions? Visit our Help Center', style: TextStyle(color: theme.colorScheme.primary.withOpacity(0.6))),
            ),
            
            // Mini Map Preview
            Padding(
              padding: const EdgeInsets.all(24),
              child: Container(
                height: 120,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  image: const DecorationImage(
                    image: NetworkImage("https://lh3.googleusercontent.com/aida-public/AB6AXuCapsglT7eoTnS47LIp67e_0zN6B4pMcldZ8wLaw0LfEiXtbpNMVA2WFGjzN3fVhZz74CHrvRa8BW5r2Z1rIRxLZDVowqQu3XGHFxZsOuTwGt8v_Dn0Sk6gdvJMSBqO5QWbzWf7M_hoOdh2ZlKaD5dIIgDzVhOpntFEbF571pXlSnL1JmFQR8JWYNGTFKQs8Ts9PjfByaakIWmmWhmGwiRRi8sacjZTdibvLqgsML4N9HPLwg9UUUzK-_Cjzzg63BF6lmkaCU8_xA"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      bottom: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.location_on, color: theme.colorScheme.primary, size: 14),
                            const SizedBox(width: 4),
                            const Text('STORE LOCATION: SOMA DIST.', style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReceiptCard(ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20)],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Transaction Details', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
               // const Divider(height: 32, thickness: 1, dashArray: [4, 4]),
                const Divider(height: 32, thickness: 1),
                _buildMetadataRow('Transaction ID', '#TXN-8829-001'),
                const SizedBox(height: 12),
                _buildMetadataRow('Reference Number', 'REF02913445'),
                const SizedBox(height: 12),
                _buildMetadataRow('Date & Time', 'Oct 24, 2023, 10:30 AM'),
                const SizedBox(height: 12),
                _buildMetadataRow('Payment Method', 'Visa •••• 4242', icon: Icons.credit_card),
                
                const SizedBox(height: 32),
                Text('Order Summary', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                _buildProductRow(
                  name: 'Pro Wireless 2.0', 
                  qty: 1, 
                  price: '\$125.00',
                  imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuCBbWOzkRpTOURLyqJpZCkEYI8kFt-wFxmeN4gC-En9P_HJd11km-BtY7oRpzSpqVymnhWL_UKJuYioqBjb7FBD-Yg-bgMwOLtGeTsXSITr3X4wjAlcKs8AUtNbXsn-9inHq326SKzeVI-UqCAuP-psU__E_8q2rkpsATd5HN6KscUKh61QygW-5Ye_W4WQJJnjUyTri-vaQ8D0VcVZQJtJ6oFPP-1Qoh9V-gQWwNqLJVCRbGMtzqSseaqFH6qM9YuCKe2tfQInCQ',
                ),
                const SizedBox(height: 12),
                _buildProductRow(
                  name: 'Armor Hybrid Case', 
                  qty: 1, 
                  price: '\$17.50',
                  imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuBIxSyIuWR5EXc3C4A8Kyv5alhWE9rlFrYmszAAc0j8Gwntzr8tI_sRUHuOk_bdp4H-UZlRpFsEU9Ys79Sf8f4U6SEE7u_ixcNZ8N9FZyso-zK38zg1_Q2zHe98QBZ8gY5xhUF3xAJPhc-JgX1dofv5nZ9-8QavwPqdcyNnwI9NR1t_RZP53BE-EcF43z-A_iFIyr9EVhQWWGKVPNy2lB6uP3rQgEdzmy_07S-WK2Dj7p-ZE4SRJEjthPKzIqqnfUBtEcAJSoS5dg',
                ),
                
                const Divider(height: 48),
                _buildSummaryRow('Subtotal', '\$142.50'),
                const SizedBox(height: 12),
                _buildSummaryRow('Shipping', 'Free', isFree: true),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total Paid', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                    Text('\$142.50', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: theme.colorScheme.primary)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetadataRow(String label, String value, {IconData? icon}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
        Row(
          children: [
            if (icon != null) ...[
              Icon(icon, size: 16, color: Colors.blue),
              const SizedBox(width: 8),
            ],
            Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          ],
        ),
      ],
    );
  }

  Widget _buildProductRow({required String name, required int qty, required String price, required String imageUrl}) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            image: DecorationImage(image: NetworkImage(imageUrl), fit: BoxFit.cover),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              Text('Qty: $qty', style: const TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
        ),
        Text(price, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
      ],
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isFree = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
        Text(
          value, 
          style: TextStyle(
            fontWeight: FontWeight.bold, 
            fontSize: 13,
            color: isFree ? Colors.green : null,
          ),
        ),
      ],
    );
  }
}

extension on Divider {
  Divider copyWith({List<int>? dashArray}) => this;
}
