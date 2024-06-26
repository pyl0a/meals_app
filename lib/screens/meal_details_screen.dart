import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals_app/helpers/snackbar_helper.dart';
import 'package:meals_app/models/meal.dart';
import 'package:meals_app/providers/favourites_provider.dart';
import 'package:transparent_image/transparent_image.dart';

class MealDetailsScreen extends ConsumerWidget {
  const MealDetailsScreen({
    super.key,
    required this.meal,
  });

  final Meal meal;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favourites = ref.watch(favouritesProvider);
    final isFavoriteMeal = favourites.contains(meal);

    return Scaffold(
      appBar: AppBar(
        title: Text(meal.title),
        actions: [
          IconButton(
            onPressed: () {
              FavoritesAddedSnackbar(context: context, ref: ref, meal: meal)
                  .showSnackbar();
            },
            icon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 600),
              switchInCurve: Curves.easeInOutBack,
              switchOutCurve: Curves.easeInOutBack,
              reverseDuration: Duration.zero,
              // const Duration(milliseconds: 0),
              transitionBuilder: (child, animation) {
                return RotationTransition(
                  turns: Tween(begin: 0.6, end: 1.0).animate(animation),
                  child: child,
                );
              },
              child: Icon(
                isFavoriteMeal ? Icons.star : Icons.star_border_outlined,
                key: ValueKey(isFavoriteMeal),
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        children: [
          Hero(
            tag: meal.id,
            child: FadeInImage(
              placeholder: MemoryImage(kTransparentImage),
              image: NetworkImage(meal.imageUrl),
              fit: BoxFit.cover,
              height: 300,
              width: double.infinity,
            ),
          ),
          const SizedBox(height: 28.0),
          Text(meal.title,
              style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                  color: Theme.of(context).colorScheme.onBackground,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 16.0),
          Text('Ingredients',
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: Theme.of(context).colorScheme.onBackground,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 12.0),
          for (final ingredient in meal.ingredients) Text('- $ingredient'),
          const SizedBox(height: 12.0),
          Text('Steps',
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: Theme.of(context).colorScheme.onBackground,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 12.0),
          for (final step in meal.steps) Text('- $step'),
          const SizedBox(height: 28.0),
        ],
      ),
    );
  }
}
