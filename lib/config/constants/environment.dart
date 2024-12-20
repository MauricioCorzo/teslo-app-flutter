import 'package:envied/envied.dart';

part "environment.g.dart";

@Envied(path: ".env")
final class Environment {
  @EnviedField(varName: "API_URL", obfuscate: true)
  static final String API_URL = _Environment.API_URL;
}
