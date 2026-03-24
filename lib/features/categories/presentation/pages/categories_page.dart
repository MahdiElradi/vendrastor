import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/config/theme/app_theme.dart';
import '../../../../core/widgets/asset_or_network_image.dart';
import '../../../../core/widgets/loading_spinner.dart';
import '../cubit/categories_cubit.dart';
import '../cubit/categories_state.dart';
import '../../domain/entities/category_entity.dart';
import 'category_products_page.dart';

/// Category grid and navigation to products by category.
class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key, this.useScaffold = true});

  final bool useScaffold;

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  @override
  void initState() {
    super.initState();
    context.read<CategoriesCubit>().loadCategories();
    context.read<CategoriesCubit>().selectCategory(null);
  }

  @override
  Widget build(BuildContext context) {
    final body = BlocBuilder<CategoriesCubit, CategoriesState>(
      builder: (context, state) {
        if (state.isLoadingCategories && state.categories.isEmpty) {
          return const LoadingSpinner();
        }
        if (state.categoriesFailure != null && state.categories.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Text(
                state.categoriesFailure!.message,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: Theme.of(context).colorScheme.error),
              ),
            ),
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              child: _CategoryGrid(
                categories: state.categories,
                selectedCategoryId: state.selectedCategoryId,
                onCategoryTap: (id) =>
                    context.read<CategoriesCubit>().selectCategory(id),
              ),
            ),
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Text(
                    'Tap a category to browse products',
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );

    return widget.useScaffold
        ? Scaffold(
            appBar: AppBar(title: const Text('Categories')),
            body: body,
          )
        : body;
  }

}

class _CategoryGrid extends StatelessWidget {
  const _CategoryGrid({
    required this.categories,
    required this.selectedCategoryId,
    required this.onCategoryTap,
  });

  final List<CategoryEntity> categories;
  final String? selectedCategoryId;
  final void Function(String) onCategoryTap;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final crossAxisCount = width >= 800 ? 3 : 2;

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: categories.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: 1.05,
        crossAxisSpacing: AppSpacing.sm,
        mainAxisSpacing: AppSpacing.sm,
      ),
      itemBuilder: (context, index) {
        final category = categories[index];
        final isSelected = category.id == selectedCategoryId;
        return _CategoryCard(
          category: category,
          isSelected: isSelected,
          onTap: () {
            // Ensure the cubit knows what category is selected so products can be loaded.
            onCategoryTap(category.id);
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => CategoryProductsPage(category: category),
              ),
            );
          },
        );
      },
    );
  }
}

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({
    required this.category,
    required this.isSelected,
    required this.onTap,
  });

  final CategoryEntity category;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: isSelected ? 4 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: isSelected
            ? BorderSide(color: theme.colorScheme.primary, width: 2)
            : BorderSide.none,
      ),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: AspectRatio(
                aspectRatio: 4 / 3,
                child: category.imageUrl != null &&
                        category.imageUrl!.isNotEmpty
                    ? AssetOrNetworkImage(
                        imageUrl: category.imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _imageFallback(context),
                      )
                    : _imageFallback(context),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.sm),
              child: Text(
                category.name,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _imageFallback(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: const Center(
        child: Icon(Icons.image_outlined, size: 40),
      ),
    );
  }
}
