import 'package:electro_pi_task_manager/features/Localization/presentation/logic/lang_cubit/lang_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class DirectionalWidget extends StatelessWidget {
  const DirectionalWidget({super.key});

  bool isRTL(BuildContext context) {
    return context.watch<LangCubit>().state.isRTL;
  }

  TextDirection getTextDirection(BuildContext context) {
    return context.watch<LangCubit>().state.textDirection;
  }
}
