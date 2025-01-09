import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';
import 'package:teslo_shop/features/auth/presentation/providers/auth_provider.dart';
import 'package:teslo_shop/features/shared/shared.dart';
import 'package:teslo_shop/helpers/logger.dart';

final registerFormProvider =
    StateNotifierProvider.autoDispose<RegisterFormNotifier, RegisterFormState>(
        (ref) {
  final register_user_callback = ref.watch(authProvider.notifier).registerUser;
  return RegisterFormNotifier(registerUserCallback: register_user_callback);
});

typedef RegisterUserCallback = Future<void> Function(
  String email,
  String password,
  String fullname,
);

class RegisterFormNotifier extends StateNotifier<RegisterFormState> {
  final RegisterUserCallback registerUserCallback;

  RegisterFormNotifier({
    required this.registerUserCallback,
  }) : super(RegisterFormState());

  onEmailChange(String value) {
    final newEmail = Email.dirty(value);
    state = state.copyWith(
      email: newEmail,
      isValid: Formz.validate(
          [newEmail, state.password, state.confirmPassword, state.fullname]),
    );
  }

  onPasswordChange(String value) {
    final newPassword = Password.dirty(value);
    state = state.copyWith(
      password: newPassword,
      isValid: Formz.validate(
          [newPassword, state.email, state.fullname, state.confirmPassword]),
    );
  }

  onConfirmPasswordChange(String value) {
    final newPassword = ConfirmPassword.dirty(
        originalPassword: state.password.value, value: value);
    state = state.copyWith(
      confirmPassword: newPassword,
      isValid: Formz.validate(
          [newPassword, state.email, state.password, state.fullname]),
    );
  }

  onFullnameChange(String value) {
    final newFullname = Fullname.dirty(value);
    state = state.copyWith(
      fullname: newFullname,
      isValid: Formz.validate([newFullname, state.email, state.password]),
    );
  }

  onFormSubmit() async {
    _touchEveryField();

    if (!state.isValid) return;

    final email = state.email.value;
    final password = state.password.value;
    final fullname = state.fullname.value;

    await registerUserCallback(email, password, fullname);
    LoggerPrint.info(state);
  }

  _touchEveryField() {
    state = state.copyWith(
      email: Email.dirty(state.email.value),
      password: Password.dirty(state.password.value),
      confirmPassword: ConfirmPassword.dirty(
          originalPassword: state.password.value,
          value: state.confirmPassword.value),
      fullname: Fullname.dirty(state.fullname.value),
      isFormPosted: true,
      isValid: Formz.validate([state.email, state.password, state.fullname]),
    );
  }
}

class RegisterFormState {
  final bool isPosting;
  final bool isFormPosted;
  final bool isValid;
  final Email email;
  final Password password;
  final ConfirmPassword confirmPassword;
  final Fullname fullname;

  RegisterFormState({
    this.isPosting = false,
    this.isFormPosted = false,
    this.isValid = false,
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.confirmPassword = const ConfirmPassword.pure(),
    this.fullname = const Fullname.pure(),
  });

  RegisterFormState copyWith({
    bool? isPosting,
    bool? isFormPosted,
    bool? isValid,
    Email? email,
    Password? password,
    ConfirmPassword? confirmPassword,
    Fullname? fullname,
  }) {
    return RegisterFormState(
      isPosting: isPosting ?? this.isPosting,
      isFormPosted: isFormPosted ?? this.isFormPosted,
      isValid: isValid ?? this.isValid,
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      fullname: fullname ?? this.fullname,
    );
  }

  @override
  String toString() {
    return '''
RegisterFormState: {
    isPosting: $isPosting
    isFormPosted: $isFormPosted
    isValid: $isValid
    email: $email
    password: $password
    fullname: $fullname
  }  
   ''';
  }
}
