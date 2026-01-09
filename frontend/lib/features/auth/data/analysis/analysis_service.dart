import '../../../../core/api/api_client.dart';
import 'analysis_model.dart';

class AnalysisService {
  Future<AnalysisModel> getAnalysis() async {
    final response = await ApiClient.dio.get('/analysis');
    return AnalysisModel.fromJson(response.data);
  }
}
