class LessonsProvider {
  List<String> classFiles = [
    'basic_geogebra',
    'advanced_geogebra',
    'intermediate_geogebra',
    'points',
    'lines',
    'functions',
    'equations',
    'final_test',
  ];

  List<String> getAllClassFiles() {
    return classFiles.map((file) => 'assets/classes/$file.json').toList();
  }
}
