import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ecomservics/presentation/routes/app_routes.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  int _selectedFilterIndex = 0;
  final List<String> _filters = ['All Orders', 'Delivered', 'Processing', 'Cancelled'];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go(AppRoutes.home);
            }
          },
        ),
        title: const Text('Order History'),
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          // Filter Chips
          _buildFilters(theme),
          
          // Orders List
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              children: [
                _buildOrderCard(
                  theme,
                  orderId: '#ORD-88291',
                  status: 'Delivered',
                  statusColor: Colors.green,
                  date: 'Oct 24, 2023 • 3 Items',
                  price: '\$124.00',
                  imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuCxDrJpjkTcuuZlKSWhJB9RAJcs9VsoY2vmep-WzBc5Imtk95GQDbqfLhm4oVpTJsaXrqhpS7FCLau7yoEBD_mXvEXC6o1KRbTh8rZRBdc_NrFEPZeIFl3-EyDe8BQLVc3FGMVmdT9J6J-rcJ3wWXRhdRiQRiaPrdYsXR3tF5jycms1mZ-CZQI1QR1j44NONoDfyO-ujoverq_I9Fo8HFOMd7rtDrKIAshHhWzeEuSN3i_0zQd62xUVY5p16f87hyQLyPFu9rU4gQ',
                ),
                _buildOrderCard(
                  theme,
                  orderId: '#ORD-88245',
                  status: 'Cancelled',
                  statusColor: Colors.red,
                  date: 'Oct 18, 2023 • 1 Item',
                  price: '\$56.50',
                  imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuC1Y_AKFs6QnTbIFn1QC0LOiXigAqXirjm-NUfs_fEtGLGThJAjhzXNEyYW_a22RTPjXo7tiqJEmCojwXVSkajK5aV86PUOVX658boJRLxhS9U0jNidUteAy_Rpyl1JbgKgwY99WFI-FUNbqgt9jTXysDNGJ2i-70B9J6lezl0F-d9IqjlUdPef6HiVnkIosWHt_kT6BF6HS8m9d2-Lupi0zWXEsB2kQzng2F0rCujQSP_xXST4vdvxqUtIM_xr6V-y1iPah3Iavw',
                  isCancel: true,
                ),
                _buildOrderCard(
                  theme,
                  orderId: '#ORD-88190',
                  status: 'Processing',
                  statusColor: Colors.orange,
                  date: 'Oct 12, 2023 • 2 Items',
                  price: '\$210.00',
                  imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuDOvtE4Ap6oyqEdlqXKLizjhJGIuLf_uGfy7jeIe1r9P1WkuZ61IQKt2z2wsF0KxbQwBUXCuhW0ISZmhbGMX2b2UI7X8tp3E1fveQ9nzJR_3CLz6Effl9BXBKDqGy3_kgpBPPHV2jfHPTXN0cc13eAqiswcNV_JotpZ8cfS3hektiGcy-qP_XvK0SFX0Sz5cw_3IKK_HmSCymHw3eXvhbiSqsoBcdT5vtZVRCVJwy3OMg_5kemKIXjXj6hnOGeAaaqIGOCWhP7vsw',
                  isTrackable: true,
                ),
              ],
            ),
          ),
          
          // Load More
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: TextButton(
              onPressed: () {},
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Load more history', style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.bold)),
                  const Icon(Icons.expand_more, size: 20),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildFilters(ThemeData theme) {
    return SizedBox(
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        itemCount: _filters.length,
        itemBuilder: (context, index) {
          final isSelected = _selectedFilterIndex == index;
          return GestureDetector(
            onTap: () => setState(() => _selectedFilterIndex = index),
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: isSelected ? theme.colorScheme.primary : theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(20),
                border: isSelected ? null : Border.all(color: theme.colorScheme.outline.withOpacity(0.1)),
                boxShadow: isSelected ? [BoxShadow(color: theme.colorScheme.primary.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))] : null,
              ),
              child: Center(
                child: Text(
                  _filters[index],
                  style: TextStyle(
                    color: isSelected ? Colors.white : theme.colorScheme.onSurface.withOpacity(0.6),
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildOrderCard(ThemeData theme, {
    required String orderId, 
    required String status, 
    required Color statusColor, 
    required String date, 
    required String price, 
    required String imageUrl,
    bool isCancel = false,
    bool isTrackable = false,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(orderId, style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.bold, fontSize: 16)),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          status.toUpperCase(), 
                          style: TextStyle(color: statusColor, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(date, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.4))),
                  const SizedBox(height: 8),
                  Text(price, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  
                  // Action Button
                  SizedBox(
                    height: 36,
                    child: TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        backgroundColor: isCancel ? theme.colorScheme.onSurface.withOpacity(0.05) : theme.colorScheme.primary.withOpacity(0.1),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            isTrackable ? 'Track Order' : 'Order Details', 
                            style: TextStyle(
                              color: isCancel ? theme.colorScheme.onSurface.withOpacity(0.6) : theme.colorScheme.primary, 
                              fontWeight: FontWeight.bold, 
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            Icons.chevron_right, 
                            size: 16, 
                            color: isCancel ? theme.colorScheme.onSurface.withOpacity(0.6) : theme.colorScheme.primary,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: theme.colorScheme.outline.withOpacity(0.05)),
                image: DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
