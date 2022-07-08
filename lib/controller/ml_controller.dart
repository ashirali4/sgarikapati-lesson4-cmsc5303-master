import 'dart:io';

import 'package:google_ml_kit/google_ml_kit.dart';

class GoogleMlController {

  static const minCofidence = 0.6;

   static Future<List<dynamic>> getImageLabels({
    required File photo, 
   }) async{
         var inputImage = InputImage.fromFile(photo);
         final imageLabeler = GoogleMlKit.vision.imageLabeler();
         final List<ImageLabel> imageLabels= await imageLabeler.processImage(inputImage);
         imageLabeler.close();

         var results = <String> [];
         for(var i in imageLabels){
          if(i.confidence >= minCofidence){
            results.add(i.label.toLowerCase());
          }
         }

         return results;
   }
}