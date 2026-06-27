import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../domain/enums/task_priority.dart';
import '../cubit/tasks_cubit.dart';

class AddTaskBottomSheet extends StatefulWidget {
  const AddTaskBottomSheet({super.key});

  @override
  State<AddTaskBottomSheet> createState() => _AddTaskBottomSheetState();
}

class _AddTaskBottomSheetState extends State<AddTaskBottomSheet> {
  final _titleController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  TaskPriority _priority = TaskPriority.medium;
  DateTime? _deadline;
  TimeOfDay? _deadlineTime;
  bool _isSubmitting = false;

  bool get _isSubmitEnabled =>
      _titleController.text.trim().isNotEmpty &&
      _deadline != null &&
      _deadlineTime != null;

  @override
  void initState() {
    super.initState();
    _titleController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSubmitting = true);
    await context.read<TasksCubit>().addTask(
          _titleController.text.trim(),
          priority: _priority,
        );
    if (mounted) Navigator.of(context).pop();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _deadline ?? now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );
    if (picked != null) setState(() => _deadline = picked);
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _deadlineTime ?? const TimeOfDay(hour: 10, minute: 0),
    );
    if (picked != null) setState(() => _deadlineTime = picked);
  }

  String get _dateLabel {
    if (_deadline == null) return 'Select date';
    final now = DateTime.now();
    if (_deadline!.year == now.year &&
        _deadline!.month == now.month &&
        _deadline!.day == now.day) {
      return 'Today';
    }
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${months[_deadline!.month - 1]} ${_deadline!.day}';
  }

  String get _timeLabel {
    if (_deadlineTime == null) return 'Select time';
    final h = _deadlineTime!.hour;
    final m = _deadlineTime!.minute.toString().padLeft(2, '0');
    final hour = h == 0 ? 12 : (h > 12 ? h - 12 : h);
    final period = h < 12 ? 'AM' : 'PM';
    return '$hour:$m $period';
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceBright,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 24.h + bottomInset),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                margin: EdgeInsets.only(top: 12.h, bottom: 20.h),
                width: 36.w,
                height: 4.r,
                decoration: BoxDecoration(
                  color: colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ),
            Text(
              'New Task',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
                color: colorScheme.onSurface,
                letterSpacing: -0.2,
              ),
            ),
            SizedBox(height: 20.h),
            _FieldLabel('Task Name'),
            SizedBox(height: 6.h),
            TextFormField(
              controller: _titleController,
              autofocus: true,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) {
                if (_isSubmitEnabled && !_isSubmitting) _submit();
              },
              decoration: InputDecoration(
                hintText: 'Enter task title...',
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.r),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                    width: 2,
                  ),
                ),
              ),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Title is required' : null,
            ),
            SizedBox(height: 16.h),
            _FieldLabel('Priority'),
            SizedBox(height: 6.h),
            Container(
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainer,
                border: Border.all(color: colorScheme.outlineVariant),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<TaskPriority>(
                  value: _priority,
                  isExpanded: true,
                  padding: EdgeInsets.symmetric(horizontal: 14.w),
                  borderRadius: BorderRadius.circular(10.r),
                  items: TaskPriority.values
                      .map(
                        (p) => DropdownMenuItem(
                          value: p,
                          child: Text(
                            '${p.label} Priority',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: colorScheme.onSurface,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (p) =>
                      setState(() => _priority = p ?? _priority),
                  icon: Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: colorScheme.outline,
                  ),
                ),
              ),
            ),
            SizedBox(height: 16.h),
            _FieldLabel('Deadline'),
            SizedBox(height: 6.h),
            Row(
              children: [
                Expanded(
                  child: _DateTimeField(
                    label: _dateLabel,
                    icon: Icons.calendar_today_outlined,
                    isPlaceholder: _deadline == null,
                    onTap: _pickDate,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: _DateTimeField(
                    label: _timeLabel,
                    icon: Icons.access_time_rounded,
                    isPlaceholder: _deadlineTime == null,
                    onTap: _pickTime,
                  ),
                ),
              ],
            ),
            SizedBox(height: 24.h),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      side: BorderSide(color: colorScheme.outlineVariant),
                      foregroundColor: colorScheme.outline,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: FilledButton(
                    onPressed: (_isSubmitting || !_isSubmitEnabled) ? null : _submit,
                    style: FilledButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                    child: _isSubmitting
                        ? SizedBox(
                            height: 20.r,
                            width: 20.r,
                            child: const CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'Add Task',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 13.sp,
        fontWeight: FontWeight.w600,
        color: Theme.of(context).colorScheme.onSurface,
      ),
    );
  }
}

class _DateTimeField extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isPlaceholder;
  final VoidCallback onTap;

  const _DateTimeField({
    required this.label,
    required this.icon,
    required this.isPlaceholder,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainer,
          border: Border.all(color: colorScheme.outlineVariant),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: isPlaceholder
                      ? colorScheme.onSurfaceVariant
                      : colorScheme.onSurface,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(width: 4.w),
            Icon(icon, size: 18.r, color: colorScheme.outline),
          ],
        ),
      ),
    );
  }
}
