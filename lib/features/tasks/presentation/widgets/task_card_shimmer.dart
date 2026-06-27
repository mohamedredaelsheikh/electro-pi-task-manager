import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class TasksShimmerList extends StatelessWidget {
  const TasksShimmerList({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor =
        isDark ? const Color(0xFF2C2C2E) : const Color(0xFFE5E7EB);
    final highlightColor =
        isDark ? const Color(0xFF3A3A3C) : const Color(0xFFF3F4F6);

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _ProgressCardSkeleton(),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.only(bottom: 120.h),
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 6 + 1,
              itemBuilder: (_, i) =>
                  i == 0 ? const _SectionLabelSkeleton() : const _TaskCardSkeleton(),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgressCardSkeleton extends StatelessWidget {
  const _ProgressCardSkeleton();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      margin: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 0),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: colorScheme.surfaceBright,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // "PROGRESS" label
          _Bone(width: 72.w, height: 10.h),
          SizedBox(height: 10.h),
          // "XX% Complete" + "X / X tasks done"
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              _Bone(width: 130.w, height: 20.h),
              const Spacer(),
              _Bone(width: 90.w, height: 12.h),
            ],
          ),
          SizedBox(height: 14.h),
          // Progress bar
          _Bone(width: double.infinity, height: 6.h, radius: 3.r),
        ],
      ),
    );
  }
}

class _SectionLabelSkeleton extends StatelessWidget {
  const _SectionLabelSkeleton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 8.h),
      child: _Bone(width: 48.w, height: 11.h),
    );
  }
}

class _TaskCardSkeleton extends StatelessWidget {
  const _TaskCardSkeleton();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 6.h),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: colorScheme.surfaceBright,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Checkbox circle
          _Bone(width: 24.r, height: 24.r, radius: 12.r),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _Bone(width: double.infinity, height: 13.h),
                          SizedBox(height: 5.h),
                          _Bone(width: 140.w, height: 13.h),
                        ],
                      ),
                    ),
                    SizedBox(width: 8.w),
                    // Priority chip
                    _Bone(width: 58.w, height: 22.h, radius: 100.r),
                  ],
                ),
                SizedBox(height: 10.h),
                // Status dot + label
                Row(
                  children: [
                    _Bone(width: 8.r, height: 8.r, radius: 4.r),
                    SizedBox(width: 6.w),
                    _Bone(width: 52.w, height: 11.h),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Bone extends StatelessWidget {
  final double width;
  final double height;
  final double? radius;

  const _Bone({required this.width, required this.height, this.radius});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius ?? 6.r),
      ),
    );
  }
}
