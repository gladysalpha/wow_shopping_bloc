import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:wow_shopping/backend/auth_repo.dart';
import 'package:wow_shopping/models/user.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({required AuthRepo authRepo})
      : _authRepo = authRepo,
        super(AuthInitial()) {
    on<AuthStatusSubscriptionRequested>(_onAuthStatusSubscriptionRequested);
    on<AuthLoginRequested>(_onLoginRequested);
    on<AuthLogoutRequested>(_onLogoutRequested);
  }

  final AuthRepo _authRepo;

  Future<void> _onAuthStatusSubscriptionRequested(
      AuthStatusSubscriptionRequested event, Emitter<AuthState> emit) async {
    await emit.forEach(_authRepo.streamUser, onData: (userData) {
      print("streamed");

      if (userData == User.none) {
        print("loggedOut");
        return AuthUnauthenticated();
      } else {
        return AuthAuthenticated(user: _authRepo.currentUser);
      }
    });
  }

  Future<void> _onLoginRequested(
      AuthLoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      _authRepo.login(event.username, event.password);
    } catch (error) {
      emit(AuthError(errText: error.toString()));
    }
  }

  Future<void> _onLogoutRequested(
      AuthLogoutRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    try {
      await _authRepo.logout();
    } catch (error) {
      emit(AuthError(errText: error.toString()));
    }
  }
}
