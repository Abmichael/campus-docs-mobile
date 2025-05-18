import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:mit_mobile/providers/auth_provider.dart';
import 'package:mit_mobile/services/api_client.dart';
import 'package:mit_mobile/models/user.dart';

@GenerateMocks([ApiClient])
import 'auth_provider_test.mocks.dart';

void main() {
  late MockApiClient mockApiClient;
  late ProviderContainer container;

  setUp(() {
    mockApiClient = MockApiClient();
    container = ProviderContainer(
      overrides: [apiClientProvider.overrideWithValue(mockApiClient)],
    );
  });

  tearDown(() {
    container.dispose();
  });

  test('login success updates auth state', () async {
    // Arrange
    const user = User(
      id: '1',
      name: 'Test User',
      email: 'test@example.com',
      role: UserRole.student,
    );
    final response = LoginResponse(token: 'test-token', user: user);
    when(mockApiClient.login(any)).thenAnswer((_) async => response);

    // Act
    await container
        .read(authProvider.notifier)
        .login('test@example.com', 'password');

    // Assert
    expect(
      container.read(authProvider).user,
      equals(user.copyWith(token: 'test-token')),
    );
  });

  test('login failure updates auth state with error', () async {
    // Arrange
    when(mockApiClient.login(any)).thenThrow(Exception('Invalid credentials'));

    // Act
    await container
        .read(authProvider.notifier)
        .login('test@example.com', 'wrong');

    // Assert
    expect(container.read(authProvider).error, isNotNull);
  });
}
