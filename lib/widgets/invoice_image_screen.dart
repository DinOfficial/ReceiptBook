import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';

class InvoiceImageSave extends StatelessWidget {
  final Uint8List imageBytes;
  final String fileName;

  const InvoiceImageSave({super.key, required this.imageBytes, required this.fileName});

  Future<void> _saveImage(BuildContext context) async {
    // Permission
    final status = await Permission.photos.request();
    if (!status.isGranted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Permission denied')));
      return;
    }

    final result = await ImageGallerySaverPlus.saveImage(imageBytes, quality: 100, name: fileName);

    if (result['isSuccess']) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Image saved to Gallery')));
    }
  }

  Future<void> _shareImage(BuildContext context) async {
    final temp = await getTemporaryDirectory();
    final file = File('${temp.path}/$fileName.png');
    await file.writeAsBytes(imageBytes);
    await Share.shareXFiles([XFile(file.path)], text: 'Invoice');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Invoice Preview', style: TextStyle(color: Colors.white)),
      ),
      body: Center(
        child: InteractiveViewer(minScale: 0.5, maxScale: 4, child: Image.memory(imageBytes)),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.save),
                  label: const Text('Save'),
                  onPressed: () => _saveImage(context),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.share),
                  label: const Text('Share'),
                  onPressed: () => _shareImage(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
