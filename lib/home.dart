import 'dart:io';
import 'package:cat_vs_dog_detector/constants.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  bool _loading = true;
  late File _image;
  late List _output;
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    loadModel().then((value) {
      setState(() {

      });
    });
  }


  /// Hapa ndo una classify image ipo kundi gani
  classifyImage(File image) async {
    var output = await Tflite.runModelOnImage(
        path: image.path,
        numResults: 2,
        threshold: 0.5,
        imageMean: 127.5,
        imageStd: 127.5,
    );
    setState(() {
      _output = output!;
      _loading = false;
    });
  }


  /// Loading Models - whether made in TeachableModel au coded from fresh
  loadModel() async {
    await Tflite.loadModel(
        model: 'assets/model_unquant.tflite',
        labels: 'assets/labels.txt'
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    Tflite.close();
    super.dispose();
  }

  /// Take Picture
  pickImage() async {
    var image = await picker.getImage(
        source: ImageSource.camera
    );
    if (image == null) return null;

    setState(() {
      _image = File(image.path);
    });

    classifyImage(_image);

  }

  /// Pick from Gallery
  pickGalleryImage() async {
    var image = await picker.getImage(
        source: ImageSource.gallery
    );
    if (image == null) return null;

    setState(() {
      _image = File(image.path);
    });

    classifyImage(_image);

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: ListView(children: [

        const SizedBox(height: 30),

        /// Title
        Container(
          margin: const EdgeInsets.all(12.0),
          child: Column(
            children: const [
            Text("Detect Dogs and Cats", style: TextStyle(
              color: kOperators, fontSize: 25
            ),),
          ],),
        ),


        /// Is it loading? Weka picha au Image ya paka/mbwa
        Center(
          child: _loading ? Container(
            width: 350,
            child: Image.asset('assets/app.png'),
          ) :
          Container(
            child: Column(children: [

              Container(
                height: 250,
                child: Image.file(_image),
              ),
              const SizedBox(height: 20),

              _output != null ? Text('${_output[0]['label']}', style: const TextStyle(
                color: Colors.white, fontSize: 20
              ),) : Container(),

            ],),
          ),
        ),
        const SizedBox(height: 30),


        /// Take a Photo Button
        GestureDetector(

          onTap: pickImage,

          child: UnconstrainedBox(
            child: Container(

              width: MediaQuery.of(context).size.width*0.6,
              height: MediaQuery.of(context).size.height*0.07,

              alignment: Alignment.center,

              decoration: BoxDecoration(
                color: kOperators,
                borderRadius: BorderRadius.circular(12.0)
              ),

              child: Text('Take a photo', style: TextStyle(
                color: Colors.white, fontSize: 17
              ),),
            ),
          ),
        ),
        const SizedBox(height: 15),


        /// Camera Roll
        GestureDetector(

          onTap: pickGalleryImage,

          child: UnconstrainedBox(
            child: Container(

              width: MediaQuery.of(context).size.width*0.6,
              height: MediaQuery.of(context).size.height*0.07,

              alignment: Alignment.center,

              decoration: BoxDecoration(
                  color: kOperators,
                  borderRadius: BorderRadius.circular(12.0)
              ),

              child: Text('Camera Roll', style: TextStyle(
                  color: Colors.white, fontSize: 17
              ),),
            ),
          ),
        ),

      ],),

    );
  }
}
