class ApiItemModel {
  final String title;
  final String body;

  ApiItemModel({
    required this.title,
    required this.body,
  });

  factory ApiItemModel.fromJson(Map<String, dynamic> json) {
    return ApiItemModel(
      title: json['title']?.toString() ?? 'No title',
      body: json['body']?.toString() ?? 'No content',
    );
  }
}