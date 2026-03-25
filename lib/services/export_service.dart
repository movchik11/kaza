import 'dart:convert';
import 'dart:io';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import '../models/kaza_model.dart';

class ExportService {
  /// Exports data as JSON and shares it
  static Future<void> exportJson(KazaModel data) async {
    final jsonString = jsonEncode(data.toJson());
    final directory = await getTemporaryDirectory();
    final file = File(
      '${directory.path}/kaza_backup_${DateTime.now().millisecondsSinceEpoch}.json',
    );
    await file.writeAsString(jsonString);

    // ignore: deprecated_member_use
    await Share.shareXFiles([XFile(file.path)], text: 'Kaza Data Backup');
  }

  /// Exports progress report as PDF
  static Future<void> exportPdf(KazaModel data) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Header(level: 0, text: 'Kaza Progress Report'),
              pw.Text('Date: ${DateTime.now().toString()}'),
              pw.SizedBox(height: 20),
              pw.Text('Level: ${data.level}'),
              pw.Text(
                'Total Remaining: ${data.fajr + data.dhuhr + data.asr + data.maghrib + data.isha + data.witr}',
              ),
              pw.Text(
                'Streak: ${data.currentStreak} (Best: ${data.bestStreak})',
              ),
              pw.SizedBox(height: 20),
              pw.Bullet(text: 'Fajr: ${data.fajr}'),
              pw.Bullet(text: 'Dhuhr: ${data.dhuhr}'),
              pw.Bullet(text: 'Asr: ${data.asr}'),
              pw.Bullet(text: 'Maghrib: ${data.maghrib}'),
              pw.Bullet(text: 'Isha: ${data.isha}'),
              pw.Bullet(text: 'Witr: ${data.witr}'),
              pw.SizedBox(height: 40),
              pw.Text('Keep going! May Allah accept your efforts.'),
            ],
          );
        },
      ),
    );

    await Printing.sharePdf(
      bytes: await pdf.save(),
      filename: 'kaza_report.pdf',
    );
  }
}
