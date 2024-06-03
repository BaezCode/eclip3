import 'package:bloc/bloc.dart';
import 'package:eclips_3/models/grupo_model.dart';
import 'package:meta/meta.dart';

part 'server_event.dart';
part 'server_state.dart';

class ServerBloc extends Bloc<ServerEvent, ServerState> {
  String channelId = '';
  String callToken = '';
  int uidCall = 0;
  ServerBloc() : super(ServerState()) {
    on<SetServer>((event, emit) {
      emit(state.copyWith(server: event.server));
    });
  }
}
