import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:ecomservics/presentation/blocs/home_bloc.dart';
import 'package:ecomservics/presentation/routes/app_routes.dart';
import 'package:ecomservics/presentation/widgets/shimmer_loading.dart';

class AllCategoriesScreen extends StatelessWidget {
  const AllCategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => context.pop(),
        ),
        title: const Text('All Categories'),
      ),
      body: BlocProvider(
        create: (context) => GetIt.I<HomeBloc>()..add(GetHomeData()),
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state is HomeLoading) {
              return const CategoryListShimmer();
            } else if (state is HomeError) {
              return Center(child: Text(state.message));
            } else if (state is HomeLoaded) {
              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: state.categories.length,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  final category = state.categories[index];
                  return ListTile(
                    leading: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: theme.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(Icons.category, color: theme.primaryColor),
                    ),
                    title: Text(
                      category.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      context.push('${AppRoutes.allProducts}?categoryId=${category.id}&categoryName=${category.name}');
                    },
                  );
                },
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
