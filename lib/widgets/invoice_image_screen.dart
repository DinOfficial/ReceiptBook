import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:receipt_book/services/app_theme_style.dart';
import 'package:share_plus/share_plus.dart';
import 'package:receipt_book/utils/toast_helper.dart';

class InvoiceImageSave extends StatelessWidget {
  final Uint8List imageBytes;
  final String fileName;

  const InvoiceImageSave({
    super.key,
    required this.imageBytes,
    required this.fileName,
  });

  Future<void> _saveImage(BuildContext context) async {
    // Permission
    final status = await Permission.photos.request();
    if (!status.isGranted) {
      ToastHelper.showError(context, 'Permission denied');
      return;
    }

    final result = await ImageGallerySaverPlus.saveImage(
      imageBytes,
      quality: 100,
      name: fileName,
    );

    if (result['isSuccess']) {
      ToastHelper.showSuccess(context, 'Image saved to Gallery');
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppThemeStyle.primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Invoice Preview',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
        child: InteractiveViewer(
          minScale: 0.5,
          maxScale: 4,
          child: Image.memory(imageBytes),
        ),
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
