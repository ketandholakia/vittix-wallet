import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class DashboardShimmer extends StatelessWidget {
  const DashboardShimmer({super.key});

  Widget _buildContainer(double height, {double? width, double radius = 8}) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Theme.of(context).brightness == Brightness.light ? Colors.grey[300]! : Colors.grey[800]!,
      highlightColor: Theme.of(context).brightness == Brightness.light ? Colors.grey[100]! : Colors.grey[600]!,
      child: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Header Shimmer
          _buildContainer(20, width: 150),
          const SizedBox(height: 8),
          _buildContainer(40, width: 250),
          const SizedBox(height: 24),
          Row(
            children: List.generate(3, (_) => Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: _buildContainer(80, radius: 0),
                ),
              ),
            )),
          ),
          const SizedBox(height: 24),
          // Chart Shimmer
          _buildContainer(20, width: 200),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CircleAvatar(radius: 70, backgroundColor: Colors.white),
              const SizedBox(width: 24),
              Expanded(child: Column(
                children: List.generate(4, (_) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: _buildContainer(20),
                )),
              )),
            ],
          ),
          const SizedBox(height: 24),
          // List Shimmer
          _buildContainer(20, width: 200),
          const SizedBox(height: 16),
          ...List.generate(3, (_) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: ListTile(
              leading: const CircleAvatar(backgroundColor: Colors.white),
              title: _buildContainer(16),
              subtitle: _buildContainer(12, width: 100),
            ),
          )),
        ],
      ),
    );
  }
}