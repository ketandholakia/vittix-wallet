class Attachment {
  final int id;
  final String filePath;
  final String? fileType;

  Attachment({
    required this.id,
    required this.filePath,
    this.fileType,
  });
}
