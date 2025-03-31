import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:itunes_music_app/features/cart/presentation/views/widgets/cart_item.dart';
import 'package:itunes_music_app/features/songs/domain/entities/song_entity.dart';

void main() {
  testWidgets('CartItem widget test', (WidgetTester tester) async {
    // Mock data
    final song = SongEntity(
      id: '123',
      title: 'Test Song',
      imgURL: 'https://example.com/image.jpg',
    );
    int quantity = 1;

    // Callbacks
    void increment() {
      quantity++;
    }

    void decrement() {
      quantity--;
    }

    // Build widget
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CartItem(
            song: song,
            quantity: quantity,
            onIncrement: increment,
            onDecrement: decrement,
          ),
        ),
      ),
    );

    // Verify the song title
    expect(find.text('Test Song'), findsOneWidget);

    // Verify the quantity
    expect(find.text('Quantity: 1'), findsOneWidget);
    expect(find.text('1'), findsOneWidget);

    // Find buttons
    final incrementButton = find.byIcon(Icons.add_circle);
    final decrementButton = find.byIcon(Icons.remove_circle);

    // Tap increment button and check for change
    await tester.tap(incrementButton);
    await tester.pump();
    expect(quantity, 2); // Ensure the function is called

    // Tap decrement button and check for change
    await tester.tap(decrementButton);
    await tester.pump();
    expect(quantity, 1); // Ensure the function is called
  });
}
