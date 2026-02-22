class DemoListData {
  DemoListData({
    this.imagePath = '',
    this.titleTxt = '',
    this.startColor = '',
    this.endColor = '',
    this.description = '',
    this.details = const [],
  });

  String imagePath;
  String titleTxt;
  String startColor;
  String endColor;
  String description;
  List<String> details;

  static List<DemoListData> tabIconsList = <DemoListData>[
    DemoListData(
      imagePath: 'assets/app_template/widgets.png',
      titleTxt: 'Widgets',
      description: '100+ Widgets',
      details: <String>[],
      startColor: '#00c6ff',
      endColor: '#0072ff',
    ),
    DemoListData(
      imagePath: 'assets/app_template/themes.png',
      titleTxt: 'Screens',
      description: '150+ Screens',
      details: <String>[],
      startColor: '#38ef7d', // Light green
      endColor: '#11998e', // Dark green
    ),
    DemoListData(
      imagePath: 'assets/app_template/apps.png',
      titleTxt: 'Apps',
      description: 'Lite Apps Demo ',
      details: <String>[],
      startColor: '#FA7D82',
      endColor: '#FF5287',
    ),
  ];
}
