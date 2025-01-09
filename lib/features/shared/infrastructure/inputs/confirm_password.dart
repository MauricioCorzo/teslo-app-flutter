import 'package:formz/formz.dart';

// Define input validation errors
enum ConfirmPasswordError { empty, length, format, notEqual }

// Extend FormzInput and provide the input type and error type.
class ConfirmPassword extends FormzInput<String, ConfirmPasswordError> {
  static final RegExp passwordRegExp = RegExp(
    r'(?:(?=.*\d)|(?=.*\W+))(?![.\n])(?=.*[A-Z])(?=.*[a-z]).*$',
  );

  final String originalPassword;

  // Call super.pure to represent an unmodified form input.
  const ConfirmPassword.pure({this.originalPassword = ""}) : super.pure('');

  // Call super.dirty to represent a modified form input.
  const ConfirmPassword.dirty(
      {required this.originalPassword, String value = ""})
      : super.dirty(value);

  String? get errorMessage {
    if (isValid || isPure) return null;

    return switch (error) {
      ConfirmPasswordError.empty => 'El campo es requerido',
      ConfirmPasswordError.length => 'Mínimo 6 caracteres',
      ConfirmPasswordError.format =>
        'Debe de tener Mayúscula, letras y un número',
      ConfirmPasswordError.notEqual => 'Las contraseñas no coinciden',
      _ => null,
    };
  }

  // Override validator to handle validating a given input value.
  @override
  ConfirmPasswordError? validator(String value) {
    if (value.isEmpty || value.trim().isEmpty)
      return ConfirmPasswordError.empty;
    if (value.length < 6) return ConfirmPasswordError.length;
    if (!passwordRegExp.hasMatch(value)) return ConfirmPasswordError.format;
    if (originalPassword != value) return ConfirmPasswordError.notEqual;

    return null;
  }
}
