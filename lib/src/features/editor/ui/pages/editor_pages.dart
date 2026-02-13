import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:art_house/src/core/background_app.dart';
import 'package:art_house/src/core/service_notification.dart';
import 'package:art_house/src/features/editor/ui/controllers/editor_controller.dart';
import 'package:art_house/src/features/editor/ui/controllers/save_data_controller.dart';
import 'package:art_house/src/features/editor/ui/widgets/color_picker_widget.dart';
import 'package:art_house/src/features/editor/ui/widgets/drawing_area_widget.dart';
import 'package:art_house/src/features/editor/ui/widgets/panel_instrument_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class EditorPage extends ConsumerStatefulWidget {
  final String? imageUrl;
  final bool? isEditing;
  final String? docId;
  const EditorPage({super.key, this.imageUrl, this.isEditing = false, this.docId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EditorPageState();
}

  class _EditorPageState extends ConsumerState<EditorPage> {

    final GlobalKey _globalKey = GlobalKey();

    @override
    void initState() {
      super.initState();
      ServiceNotification().requestPermissions();
      if (widget.imageUrl != null) {
        Future.microtask(() {
          _loadImageFromUrl(widget.imageUrl!);
        });
      }
    }

    Future<void> _loadImageFromUrl(String url) async {
      try {

        final imageDecode = base64Decode(widget.imageUrl ?? '');

        ref.read(editorControllerProvider.notifier).backgroundImage(imageDecode);

      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Не удалось загрузить рисунок: $e')),
          );
        }
      }
    }

    // Выбираем фото
    Future<void> _selectPhoto() async {
      final imagePicker = ImagePicker();
      final XFile? image = await imagePicker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        final bytes = await image.readAsBytes();
        ref.read(editorControllerProvider.notifier).backgroundImage(bytes);
      }
    }

    // Сохраненяем фото в галерею и в firebase
    Future<void> _savePhoto({bool saveToCloud = true}) async {
      try {

        // Используем RenderRepaintBoundary для того чтобы сделать скриншот области рисования,
        // чтобы сохранять только эту область, а не весь экран в галерею
        // pixelRatio: 1.0 поставим наименьшее значение, так как нужно оптимизировать качество изображенеия до самого худшего
        RenderRepaintBoundary? renderRepaintBoundary = _globalKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;

        if (renderRepaintBoundary == null) return;

        ui.Image image = await renderRepaintBoundary.toImage(pixelRatio: 1.0);
        ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
        Uint8List pngBytes = byteData!.buffer.asUint8List();

        final directory = await getTemporaryDirectory();
        final imagePath = '${directory.path}/art_house_image.png';
        final imageFile = File(imagePath);
        await imageFile.writeAsBytes(pngBytes);

        final box = context.findRenderObject() as RenderBox?;

        final xFile = XFile(imagePath, name: 'art_house_image.png');

        await SharePlus.instance.share(
          ShareParams(
            files: [xFile],
            text: 'Мой рисунок',
            subject: 'Art House',
            sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
          ),
        );

        if(saveToCloud) {
          ref.read(saveDataControllerProvider.notifier).saveData(
            title: 'Art House Image',
            imageBytes: pngBytes,
            docId: widget.docId,
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Ошибка: $e')),
          );
        }
      }
    }

    // Открываем виджет выбора цвета для кисти
    void _openColorPicker() {
      showDialog(
        context: context,
        builder: (context) {
          return Center(
            child: Material(
              color: Colors.transparent,
              child: ColorPickerWidget(

                selectedColor: ref.read(editorControllerProvider).selectedColor,

                onColorChanged: (color) {

                  ref.read(editorControllerProvider.notifier).colorPick(color);

                  Navigator.of(context).pop();
                },
              ),
            ),
          );
        },
      );
    }

  @override
  Widget build(BuildContext context) {

    final editorState = ref.watch(editorControllerProvider);
    final editorController = ref.read(editorControllerProvider.notifier);

    ref.listen(saveDataControllerProvider, (previous, next) async {
      if (next.isLoading) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Загрузка...'), duration: Duration(seconds: 2)),
        );
      }
      if (next.hasError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка: ${next.error}'), backgroundColor: Colors.red),
        );
      }
      if (next.hasValue && !next.isLoading) {
        await ServiceNotification().showNotification(
          id: 1,
          title: 'Успешно',
          body: 'Ваш рисунок сохранен на устройстве',
        );

        if(context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Рисунок успешно сохранен в Firebase!')),
          );

          Navigator.of(context).pop();
        }

      }
    });

    return BackgroundApp(
      appBar: AppBar(
        title: widget.isEditing == true
            ? const Text('Редактирование', style: TextStyle(color: Colors.white))
            : const Text('Новое изображение', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: SvgPicture.asset('assets/arrowleft.svg'),
        ),
        backgroundColor: Color(0xFF2E243C).withValues(alpha: 1.0),
        actions: [
          IconButton(
            icon: SvgPicture.asset('assets/done.svg'),
            onPressed: () => _savePhoto(saveToCloud: true),
          ),
        ],
      ),
      child: Stack(
        children: [
          Column(
            children: [

              PanelInstrumentWidget(
                saveImage: () => _savePhoto(saveToCloud: false),
                pickImage: _selectPhoto,
                penMode: editorController.penMode,
                eraserMode: editorController.eraserMode,
                openColorPicker: _openColorPicker,
              ),

              Expanded(
                child: AspectRatio(
                  aspectRatio: 375 / 500,
                  child: DrawingAreaWidget(
                    globalKey: _globalKey,
                    editorState: editorState,
                    editorController: editorController,
                  ),
                ),
              ),

              const SizedBox(height: 10),
            ],
          ),

          if (ref.watch(saveDataControllerProvider).isLoading)
            Container(
              color: Colors.black26,
              child: const Center(child: CircularProgressIndicator()),
            ),

        ],
      ),
    );
  }
}