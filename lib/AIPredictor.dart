import 'package:tflite_flutter/tflite_flutter.dart';

class AIPredictor {
  late Interpreter _interpreter;
  late List<double> Function(List<double>) normalize;

  AIPredictor._create(this._interpreter, this.normalize);

  // Load the model
  static Future<AIPredictor> load() async {
    print("ai predictor classı load() metodu çalıştı");
    try {
      final interpreter = await Interpreter.fromAsset('assets/linear_model_with_more_data.tflite');
      print("✅ai predictor classı interpreter tanımlandı");

      // Mean and scale values from Python
      List<double> means = [30.60503974, 32.24069702, 32.51306753, 30.8252517,  32.92876065];  // from scaler.mean_
      List<double> stds = [9.23442293, 8.4602309,  8.7970684,  7.84506277, 8.7206365 ];  // from scaler.scale_

      // Return an instance of AIPredictor with the normalized function
      return AIPredictor._create(interpreter, (List<double> input) {
        print("ai predictor classı load() metodu bitti");
        // Normalize input based on the mean and stds
        return List.generate(input.length, (i) => (input[i] - means[i]) / stds[i]); // Normalize each input
      });
    } catch (e) {
      print("❌Model yüklenirken hata oluştu: $e");
      rethrow;
    }
  }

  // Make predictions
  Future<double> predict(List<double> last5Months) async {
    // Normalize the input using the normalize function
    List<double> input = normalize(last5Months);

    var inputTensor = [input]; // Shape: [1, 5] for 5 months of data
    var outputTensor = [
      [0.0]
    ]; // Shape: [1, 1] for a single predicted value

    // Run the model
    _interpreter.run(inputTensor, outputTensor);

    // Return the prediction result
    return outputTensor[0][0];
  }
}
