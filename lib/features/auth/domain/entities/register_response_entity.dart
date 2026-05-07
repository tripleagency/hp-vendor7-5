/// Represents the successful response from the register endpoint
class RegisterResponseEntity {
  final String message;
  final int expiresInMinutes;

  const RegisterResponseEntity({
    required this.message,
    required this.expiresInMinutes,
  });
}
