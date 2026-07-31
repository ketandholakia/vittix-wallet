// BROKEN DEPENDENCY: Experimental
/*
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:expense_tracker/presentation/screens/dashboard/assets_screen.dart';
import 'package:expense_tracker/features/settings/presentation/settings_providers.dart';

class AssetsOverviewWidget extends ConsumerWidget {
  const AssetsOverviewWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final assetsAsync = ref.watch(assetsStreamProvider);
    final currencyFormatter = ref.watch(currencyFormatProvider);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (ctx) => const AssetsScreen(),
          ));
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Assets & Investments', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Icon(Icons.trending_up, color: Theme.of(context).colorScheme.primary),
                ],
              ),
              const SizedBox(height: 12),
              assetsAsync.when(
                data: (assets) {
                  if (assets.isEmpty) {
                    return const Text('Tap to start tracking your assets');
                  }
                  final totalValue = assets.fold<double>(0, (sum, asset) => sum + (asset.quantity * asset.currentPrice));
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Net Value', style: TextStyle(color: Colors.grey)),
                      Text(
                        currencyFormatter.format(totalValue),
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  );
                },
                loading: () => const LinearProgressIndicator(),
                error: (err, stack) => Text('Error loading assets', style: TextStyle(color: Theme.of(context).colorScheme.error)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

*/