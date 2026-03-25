import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import '../models/kaza_model.dart';
import '../repositories/kaza_repository.dart';

class BackupService {
  final KazaRepository repository;

  BackupService(this.repository);

  Future<void> exportData() async {
    final data = repository.getKazaData();
    // In a real app we'd also export history, but let's start with counts
    // or maybe serialize everything to a big JSON object.

    final fullBackup = {
      'data': data.toMap(),
      'timestamp': DateTime.now().toIso8601String(),
      'version': 1,
    };

    final jsonString = jsonEncode(fullBackup);

    // Save to temp file to share
    final directory = await getTemporaryDirectory();
    final file = File('${directory.path}/kaza_backup.json');
    await file.writeAsString(jsonString);

    // Use Share.shareXFiles (SharePlus instance API was not found/defined as expected)
    // ignore: deprecated_member_use
    await Share.shareXFiles([XFile(file.path)], text: 'Kaza Backup File');
  }

  Future<bool> importData() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );

      if (result != null) {
        File file = File(result.files.single.path!);
        String content = await file.readAsString();
        Map<String, dynamic> json = jsonDecode(content);

        if (json.containsKey('data')) {
          final model = KazaModel.fromMap(json['data']);
          await repository.saveKazaData(model);
          return true;
        }
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}
