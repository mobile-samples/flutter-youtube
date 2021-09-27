class FormatDuration {
  static String getTimeString(int value) {
    if (value < 3600) {
      int minutes = value ~/ 60;
      int seconds = value % 60;
      return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    } else {
      int hours = value ~/ 3600;
      int minutes = (value - (hours * 3600)) ~/ 60;
      int seconds = value - (hours * 3600) - (minutes * 60);
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
  }
}
