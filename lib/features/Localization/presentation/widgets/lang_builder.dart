import 'package:electro_pi_task_manager/features/Localization/presentation/logic/lang_cubit/lang_cubit.dart';
import 'package:electro_pi_task_manager/features/Localization/presentation/logic/lang_cubit/lang_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LangBuilder extends StatelessWidget {
  const LangBuilder({super.key, required this.builder, this.buildWhen});

  final Widget Function(BuildContext context, LangState state) builder;
  final bool Function(LangState previous, LangState current)? buildWhen;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LangCubit, LangState>(
      buildWhen: buildWhen,
      builder: builder,
    );
  }
}
