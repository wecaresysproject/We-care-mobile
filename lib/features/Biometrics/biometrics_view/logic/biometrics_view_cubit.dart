
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/features/Biometrics/biometrics_view/logic/biometrics_view_state.dart';


class BiometricsViewCubit extends Cubit<BiometricsViewState> {
  BiometricsViewCubit()
      : super(BiometricsViewState.initial());
  
}
