import 'package:flutter_test/flutter_test.dart';
import 'package:mambaul_ulum/main.dart';

void main() {
  testWidgets('Mambaul Ulum App Test', (WidgetTester tester) async {

    // Jalankan aplikasi
    await tester.pumpWidget(const MambaulUlumApp());

    // Cek apakah judul aplikasi muncul
    expect(find.text('Mambaul Ulum'), findsOneWidget);

    // Cek menu-menu utama
    expect(find.text('Hizib NW'), findsOneWidget);
    expect(find.text('Al-Barzanji'), findsOneWidget);
    expect(find.text('Absensi'), findsOneWidget);
    expect(find.text('Modul'), findsOneWidget);
    expect(find.text('Jadwal Sholat'), findsOneWidget);
    expect(find.text("Kitab Ta'lim"), findsOneWidget);
  });
}