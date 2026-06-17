import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerList extends StatelessWidget {
  final int itemCount;
  const ShimmerList({super.key, this.itemCount = 8});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Theme.of(context).brightness == Brightness.light ? Colors.grey[300]! : Colors.grey[800]!,
      highlightColor: Theme.of(context).brightness == Brightness.light ? Colors.grey[100]! : Colors.grey[600]!,
      child: ListView.builder(
        itemCount: itemCount,
        itemBuilder: (context, index) => const _ShimmerListItem(),
      ),
    );
  }
}

class _ShimmerListItem extends StatelessWidget {
  const _ShimmerListItem();

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const CircleAvatar(backgroundColor: Colors.white),
      title: Container(
        height: 16,
        width: 150,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
        ),
      ),
      subtitle: Container(
        height: 12,
        width: 100,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
        ),
      ),
      trailing: Container(
        height: 20,
        width: 60,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }
}