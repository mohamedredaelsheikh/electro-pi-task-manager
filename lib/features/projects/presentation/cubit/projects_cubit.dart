import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_projects_usecase.dart';
import '../../../../core/network/api_result.dart';
import 'projects_state.dart';

class ProjectsCubit extends Cubit<ProjectsState> {
  final GetProjectsUseCase _getProjects;

  ProjectsCubit(this._getProjects) : super(const ProjectsInitial());

  Future<void> loadProjects() async {
    emit(const ProjectsLoading());
    final result = await _getProjects();
    switch (result) {
      case ApiSuccess(:final data):
        emit(ProjectsLoaded(data));
      case ApiFailure(:final failure):
        emit(ProjectsError(failure.message));
    }
  }
}
