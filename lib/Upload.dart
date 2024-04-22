import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class UploadImageToFirebase extends StatefulWidget {
  const UploadImageToFirebase({super.key});

  @override
  State<UploadImageToFirebase> createState() => _UploadImageToFirebaseState();
}

class _UploadImageToFirebaseState extends State<UploadImageToFirebase> {
  String _imageFile = ''; // Variable to hold the selected image file
  Uint8List? selectedImageInBytes;

  @override
  Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text("Upload Image"),
    ),
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (_imageFile.isNotEmpty || _imageFile != '')
            Container(
              height: 150, // Ustawienie wysokości obrazu
              width: 150, // Ustawienie szerokości obrazu
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover, // Dopasowanie obrazu do kontenera
                  image: MemoryImage(selectedImageInBytes!),
                ),
              ),
            ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Calling pickImage Method
              pickImage();
            },
            child: const Text('Pick Image'),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
              onPressed: () async {
                // Calling uploadImage Method
                await uploadImage(selectedImageInBytes!);
              },
              child: const Text('Upload Image To Firebase Storage')),
        ],
      ),
    ),
  );
}


  // Method to pick image in flutter web
  Future<void> pickImage() async {
    try {
      // Pick image using file_picker package
      FilePickerResult? fileResult = await FilePicker.platform.pickFiles(
        type: FileType.image,
      );

      // If user picks an image, save selected image to variable
      if (fileResult != null) {
        setState(() {
          _imageFile = fileResult.files.first.name;
          selectedImageInBytes = fileResult.files.first.bytes;
        });
      }
    } catch (e) {
      // If an error occured, show SnackBar with error message
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error:$e")));
    }
  }

  // Method to upload selected image in flutter web
  // This method will get selected image in Bytes
  Future<String> uploadImage(Uint8List selectedImageInBytes) async {
  try {
    // Unikalny identyfikator pliku powinien być użyty, aby zapobiec nadpisywaniu
    String fileName = 'Images/${DateTime.now().millisecondsSinceEpoch}.jpg'; // Przykładowy format pliku .jpg
    Reference ref = FirebaseStorage.instance.ref().child(fileName);

    // Metadane powinny wskazywać konkretny typ MIME, np. 'image/jpeg'
    final metadata = SettableMetadata(contentType: 'image/jpeg');

    // Przesyłanie obrazu
    UploadTask uploadTask = ref.putData(selectedImageInBytes, metadata);

    // Oczekiwanie na zakończenie przesyłania
    await uploadTask;
    
    // Po pomyślnym przesłaniu obrazu
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Image Uploaded")));

    // Pobranie i zwrot URL do pobrania
    String downloadURL = await ref.getDownloadURL();
    return downloadURL;
  } catch (e) {
    // Wyświetlenie komunikatu o błędzie, jeśli wystąpi
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Upload error: $e")));
    return '';
  }
}

}
