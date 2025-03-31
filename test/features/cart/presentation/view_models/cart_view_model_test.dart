import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:itunes_music_app/core/providers/providers.dart';
import 'package:itunes_music_app/features/cart/data/repositories/cart_repository.dart';
import 'package:itunes_music_app/features/cart/domain/entities/cart_entity.dart';
import 'package:mocktail/mocktail.dart';
import 'package:itunes_music_app/features/cart/presentation/states/cart_state.dart';
import 'package:itunes_music_app/features/cart/presentation/view_models/cart_view_model.dart';

class MockCartRepositoryImpl extends Mock implements CartRepositoryImpl {}

class MockCartEntity extends Mock implements CartEntity {}

void main() {
  late CartViewModel viewModel;
  late MockCartRepositoryImpl mockRepository;
  late ProviderContainer container;

  setUp(() {
    mockRepository = MockCartRepositoryImpl();
    container = ProviderContainer(overrides: [
      cartRepositoryProvider.overrideWithValue(mockRepository),
    ]);
    viewModel = container.read(cartViewModel.notifier);
  });

  tearDown(() {
    container.dispose();
  });

  group('CartViewModel', () {
    test('initial state is correct', () {
      expect(viewModel.state, equals(CartState()));
    });

    group('getCartItems', () {
      test('sets loading state and updates with items', () async {
        final mockItems = [MockCartEntity()];
        when(() => mockRepository.getCartItems())
            .thenAnswer((_) async => mockItems);
        await viewModel.getCartItems();

        verify(() => mockRepository.getCartItems()).called(1);
        expect(viewModel.state.isLoading, false);
        expect(viewModel.state.cartItems, mockItems);
      });

      test('handles error gracefully', () async {
        when(() => mockRepository.getCartItems()).thenThrow(Exception('Error'));
        await viewModel.getCartItems();
        expect(viewModel.state.isLoading, false);
      });
    });

    group('addToCart', () {
      test('calls repository and refreshes items', () async {
        const songId = '123';
        when(() => mockRepository.addToCart(songId)).thenAnswer((_) async {});
        when(() => mockRepository.getCartItems()).thenAnswer((_) async => []);

        await viewModel.addToCart(songId);

        verify(() => mockRepository.addToCart(songId)).called(1);
        verify(() => mockRepository.getCartItems()).called(1);
      });
    });

    group('removeFromCart', () {
      test('calls repository and refreshes items', () async {
        const songId = '123';
        when(() => mockRepository.removeFromCart(songId))
            .thenAnswer((_) async {});
        when(() => mockRepository.getCartItems()).thenAnswer((_) async => []);

        await viewModel.removeFromCart(songId);

        verify(() => mockRepository.removeFromCart(songId)).called(1);
        verify(() => mockRepository.getCartItems()).called(1);
      });
    });

    group('toggleCartItem', () {
      test('adds item when not in cart', () async {
        const songId = '123';
        when(() => mockRepository.addToCart(songId)).thenAnswer((_) async {});
        when(() => mockRepository.getCartItems()).thenAnswer((_) async => []);

        await viewModel.toggleCartItem(songId);

        verify(() => mockRepository.addToCart(songId)).called(1);
      });

      test('removes item when in cart', () async {
        const songId = '123';
        final mockItem = MockCartEntity();
        when(() => mockItem.songId).thenReturn(songId);
        viewModel.state = viewModel.state.copyWith(cartItems: [mockItem]);

        when(() => mockRepository.removeFromCart(songId))
            .thenAnswer((_) async {});
        when(() => mockRepository.getCartItems()).thenAnswer((_) async => []);

        await viewModel.toggleCartItem(songId);

        verify(() => mockRepository.removeFromCart(songId)).called(1);
      });
    });

    group('clearCart', () {
      test('calls repository and refreshes items', () async {
        when(() => mockRepository.clearCart()).thenAnswer((_) async {});
        when(() => mockRepository.getCartItems()).thenAnswer((_) async => []);

        await viewModel.clearCart();

        verify(() => mockRepository.clearCart()).called(1);
        verify(() => mockRepository.getCartItems()).called(1);
      });
    });
  });
}
