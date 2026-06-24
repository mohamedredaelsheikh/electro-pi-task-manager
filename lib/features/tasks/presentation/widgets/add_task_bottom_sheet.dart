import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/enums/task_priority.dart';
import '../cubit/tasks_cubit.dart';
import '../cubit/tasks_state.dart';

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

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
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
    if (_deadline == null) return 'Today';
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
    if (_deadlineTime == null) return '10:00 AM';
    final h = _deadlineTime!.hour;
    final m = _deadlineTime!.minute.toString().padLeft(2, '0');
    final hour = h == 0 ? 12 : (h > 12 ? h - 12 : h);
    final period = h < 12 ? 'AM' : 'PM';
    return '$hour:$m $period';
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(24, 0, 24, 24 + bottomInset),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 12, bottom: 20),
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFE0E3E5),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const Text(
              'New Task',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Color(0xFF191C1E),
                letterSpacing: -0.2,
              ),
            ),
            const SizedBox(height: 20),
            _FieldLabel('Task Name'),
            const SizedBox(height: 6),
            TextFormField(
              controller: _titleController,
              autofocus: true,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => _submit(),
              decoration: InputDecoration(
                hintText: 'Enter task title...',
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                    width: 2,
                  ),
                ),
              ),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Title is required' : null,
            ),
            const SizedBox(height: 16),
            _FieldLabel('Priority'),
            const SizedBox(height: 6),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF2F4F6),
                border: Border.all(color: const Color(0xFFC7C4D8)),
                borderRadius: BorderRadius.circular(10),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<TaskPriority>(
                  value: _priority,
                  isExpanded: true,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  borderRadius: BorderRadius.circular(10),
                  items: TaskPriority.values
                      .map(
                        (p) => DropdownMenuItem(
                          value: p,
                          child: Text(
                            '${p.label} Priority',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF191C1E),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (p) =>
                      setState(() => _priority = p ?? _priority),
                  icon: const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: Color(0xFF777587),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            _FieldLabel('Deadline'),
            const SizedBox(height: 6),
            Row(
              children: [
                Expanded(
                  child: _DateTimeField(
                    label: _dateLabel,
                    icon: Icons.calendar_today_outlined,
                    onTap: _pickDate,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _DateTimeField(
                    label: _timeLabel,
                    icon: Icons.access_time_rounded,
                    onTap: _pickTime,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: const BorderSide(color: Color(0xFFC7C4D8)),
                      foregroundColor: const Color(0xFF464555),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: BlocBuilder<TasksCubit, TasksState>(
                    builder: (context, state) => FilledButton(
                      onPressed: state is TasksLoading ? null : _submit,
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: state is TasksLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
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
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: Color(0xFF191C1E),
      ),
    );
  }
}

class _DateTimeField extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _DateTimeField({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFFF2F4F6),
          border: Border.all(color: const Color(0xFFC7C4D8)),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF191C1E),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 4),
            Icon(icon, size: 18, color: const Color(0xFF777587)),
          ],
        ),
      ),
    );
  }
}
