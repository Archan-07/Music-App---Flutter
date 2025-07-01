import 'dart:io';

import 'package:client/core/theme/app_pallate.dart';
import 'package:client/core/utils.dart';
import 'package:client/core/widgets/custome_field.dart';
import 'package:client/core/widgets/loader.dart';
import 'package:client/features/home/view/pages/home_screen.dart';
import 'package:client/features/home/view/widgets/audio_wave.dart';
import 'package:client/features/home/viewmodel/home_viewmodel.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UploadSongPage extends ConsumerStatefulWidget {
  const UploadSongPage({super.key});

  @override
  ConsumerState<UploadSongPage> createState() => _UploadSongPageState();
}

class _UploadSongPageState extends ConsumerState<UploadSongPage> {
  final TextEditingController songNameController = TextEditingController();
  final TextEditingController artistNameController = TextEditingController();
  Color selectedColor = Pallete.cardColor;
  File? selectedImage;
  File? selectedAudio;
  final formKey = GlobalKey<FormState>();

  void selectAudio() async {
    final pickedAudio = await pickAudio();
    if (pickedAudio != null) {
      setState(() {
        selectedAudio = pickedAudio;
      });
    }
  }

  void selectImage() async {
    final pickedImage = await pickImagge();
    if (pickedImage != null) {
      setState(() {
        selectedImage = pickedImage;
      });
    }
  }

  @override
  void dispose() {
    songNameController.dispose();
    artistNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(
      homeViewmodelProvider.select((value) => value?.isLoading == true),
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text("Upload Songs"),
        actions: [
          IconButton(
            onPressed: () async {
              if (formKey.currentState!.validate() &&
                  selectedAudio != null &&
                  selectedImage != null) {
                ref
                    .read(homeViewmodelProvider.notifier)
                    .uploadSong(
                      selectedAudio: selectedAudio!,
                      selectedThumbnail: selectedImage!,
                      songName: songNameController.text,
                      artistName: artistNameController.text,
                      selectedColor: selectedColor,
                    );
                setState(() {
                  songNameController.clear();
                  artistNameController.clear();
                  selectedAudio = null;
                  selectedImage = null;
                  selectedColor = Pallete.cardColor; // Reset to default color
                });

                showSnackBar(context, "Upload Successful");
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                  (route) => false,
                );
              } else {
                showSnackBar(context, "Missing fields");
              }
            },
            icon: const Icon(Icons.check),
          ),
        ],
      ),
      body: isLoading
          ? const Loader()
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () => selectImage(),
                        child: selectedImage != null
                            ? SizedBox(
                                height: 200,
                                width: double.infinity,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),

                                  child: Image.file(
                                    selectedImage!,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              )
                            : const DottedBorder(
                                options: RoundedRectDottedBorderOptions(
                                  strokeCap: StrokeCap.round,
                                  radius: Radius.circular(10),
                                  dashPattern: [10, 4],
                                  color: Pallete.borderColor,
                                ),
                                child: SizedBox(
                                  height: 200,
                                  width: double.infinity,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.folder_open, size: 40),
                                      SizedBox(height: 15),
                                      Text(
                                        "Select Thumbnail For Your Song",
                                        style: TextStyle(fontSize: 15),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                      ),
                      const SizedBox(height: 40),
                      selectedAudio != null
                          ? AudioWave(path: selectedAudio!.path)
                          : CustomeField(
                              hintText: "Pick Song",
                              controller: null,
                              readOnly: true,
                              onTap: () => selectAudio(),
                            ),
                      const SizedBox(height: 20),
                      CustomeField(
                        hintText: "Artist",
                        controller: artistNameController,
                      ),
                      const SizedBox(height: 20),
                      CustomeField(
                        hintText: "Song Name",
                        controller: songNameController,
                      ),
                      const SizedBox(height: 20),
                      ColorPicker(
                        pickersEnabled: const {ColorPickerType.wheel: true},
                        color: selectedColor,
                        onColorChanged: (Color color) {
                          setState(() {
                            selectedColor = color;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
