import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:boltuix/m_material_components.dart';
import 'package:boltuix/widgets/m_typography.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'm_details_web_view_screen.dart';

class WidgetGallery extends StatefulWidget {
  const WidgetGallery({super.key});

  @override
  State<WidgetGallery> createState() => _WidgetGalleryState();
}

class _WidgetGalleryState extends State<WidgetGallery> with RestorationMixin {
  final RestorableInt _selectedIndex = RestorableInt(0);
  int value = 0;

  late bool isLoading = true;

  final List<CustomComponent> items = [
    CustomComponent(
      id: 1,
      title: "App bar",
      description:
          "The app bar provides content and actions related to the current screen. It's used for branding, screen titles, navigation and actions.",
      tag: "Flutter",
      label: "Action",
      website:
          "https://dartpad.dev/embed-flutter.html?&split=65&theme=light&run=true&id=bfd7701f6dcaf6f390a8d7cff9c75a31",
      image: "app_bar.webp",
      widget: null,
    ),
    CustomComponent(
      id: 2,
      title: "Bottom app bar",
      description:
          "Bottom app bars display navigation and key actions at the bottom of mobile and tablet screens.",
      tag: "Flutter",
      label: "Action",
      website:
          "https://dartpad.dev/embed-flutter.html?&split=65&theme=light&run=true&id=4aec74fc911cadd4d512e717da4930a9",
      image: "bottom_app_bar.webp",
      widget: null,
    ),
    CustomComponent(
      id: 3,
      title: "Bottom navigation",
      description:
          "Navigation bars let people switch between UI views on smaller devices.",
      tag: "Flutter",
      label: "Action",
      website:
          "https://dartpad.dev/embed-flutter.html?&split=65&theme=light&run=true&id=af36da452abfaea39dc45c218d73c7a6",
      image: "bottom_navigation.webp",
      widget: null,
    ),

    CustomComponent(
      id: 4,
      title: "Navigation drawer",
      description:
          "Navigation drawers let people switch between UI views on larger devices.",
      tag: "Flutter",
      label: "Action",
      website:
          "https://dartpad.dev/embed-flutter.html?&split=65&theme=light&run=true&id=4cad3568317f789ac7aa1947b3b0aa0b",
      image: "navigation_drawer.webp",
      widget: null,
    ),
    CustomComponent(
      id: 5,
      title: "Navigation rail",
      description:
          "Navigation rails let people switch between UI views on mid-sized devices.",
      tag: "Flutter",
      label: "Action",
      website:
          "https://dartpad.dev/embed-flutter.html?&split=65&theme=light&run=true&id=51b8bdeefedc4ec2d7041dfebf337bbc",
      image: "navigation_rail.webp",
      widget: null,
    ),
    CustomComponent(
      id: 6,
      title: "Tabs",
      description: "Tabs organize content across different screens and views.",
      tag: "Flutter",
      label: "Action",
      website:
          "https://dartpad.dev/embed-flutter.html?&split=65&theme=light&run=true&id=8ff6590d179be11490ff428624f42458",
      image: "tab_layout.webp",
      widget: null,
    ),

    CustomComponent(
      id: 7,
      title: "Elevated Button",
      description:
          "A raised button with a solid background, providing prominence and a touch of elevation.",
      tag: "Flutter",
      label: "Action",
      website:
          "https://dartpad.dev/embed-flutter.html?&split=65&theme=light&run=true&id=87e882c3278979692ad3c154a0c35ac3",
      image: "1_button_elevated.webp",
      // widget: null,
      widget: null,
    ),
    CustomComponent(
      id: 8,
      title: "Filled Button",
      description:
          "A button with a solid color fill, creating a visually distinct and vibrant appearance.",
      tag: "Flutter",
      label: "Action",
      website:
          "https://dartpad.dev/embed-flutter.html?&split=65&theme=light&run=true&id=51d1e1aadebe14679236ba8480c5d4e4",
      image: "1_button_fillled.webp",
      //widget: null,
      widget: null,
    ),
    CustomComponent(
      id: 9,
      title: "Filled Tonal Button",
      description:
          "A filled button with a tonal color scheme, adding depth and dimension to the visual design.",
      tag: "Flutter",
      label: "Action",
      website:
          "https://dartpad.dev/embed-flutter.html?&split=65&theme=light&run=true&id=cc466eddcf9c66f9f0a0ddea256100ba",
      image: "1_button_fillled_tonal.webp",
      //  widget: null,
      widget: null,
    ),
    CustomComponent(
      id: 10,
      title: "Outlined Button",
      description:
          "A button with a clear and defined outline, offering a subtle and sleek appearance.",
      tag: "Flutter",
      label: "Action",
      website:
          "https://dartpad.dev/embed-flutter.html?&split=65&theme=light&run=true&id=cb029d43fe0f6edb000493dbcfa25b18",
      image: "1_button_outlined.webp",
      //  widget: null,
      widget: null,
    ),
    CustomComponent(
      id: 11,
      title: "Text Button",
      description:
          "A button with no background, presenting as simple text with clickable functionality.",
      tag: "Flutter",
      label: "Action",
      website:
          "https://dartpad.dev/embed-flutter.html?&split=65&theme=light&run=true&id=b3e1119b328a6d90c2da01454331d3a3",
      image: "button_text.webp",
      //   widget: null,
      widget: null,
    ),
    CustomComponent(
      id: 12,
      title: "Text Gradient Button",
      description:
          "A button with gradient background, presenting as simple text with clickable functionality.",
      tag: "Flutter",
      label: "Action",
      website:
          "https://dartpad.dev/embed-flutter.html?&split=65&theme=light&run=true&id=cdd91c7b7c4e7e6069c860ab0c7a426c",
      image: "button_text_gradient.webp",
      // widget: null,
      widget: null,
    ),

    //.................................
    CustomComponent(
      id: 13,
      title: "FAB Regular",
      description: "A FAB should present a screen’s primary action.",
      tag: "Flutter",
      label: "Action",
      website:
          "https://dartpad.dev/embed-flutter.html?&split=65&theme=light&run=true&id=16893c23b0f47a3a5cf53b38ec58a46b",
      image: "2_fab_normal.png",
      widget: null,
    ),
    CustomComponent(
      id: 14,
      title: "FAB Small",
      description:
          "A small FAB is used for a secondary, supporting action, or in place of a default FAB on compact window sizes. One or more small FABs can be paired with a default FAB or extended FAB.",
      tag: "Flutter",
      label: "Action",
      website:
          "https://dartpad.dev/embed-flutter.html?&split=65&theme=light&run=true&id=72062a425c4368a473ca327349a7dfe9",
      image: "2_fab_small.webp",
      widget: null,
    ),
    CustomComponent(
      id: 15,
      title: "FAB Large",
      description:
          "A large FAB is useful when the layout calls for a clear and prominent primary action, and where a larger footprint would help the user engage. For example, when appearing in a medium window size.",
      tag: "Flutter",
      label: "Action",
      website:
          "https://dartpad.dev/embed-flutter.html?&split=65&theme=light&run=true&id=b0393931ae0b93dab168985088b465f1",
      image: "2_fab_large.webp",
      widget: null,
    ),

    CustomComponent(
      id: 16,
      title: "FAB Demo",
      description:
          "Use an extended FAB to provide persistent access to the screen's primary action.",
      tag: "Flutter",
      label: "Action",
      website:
          "https://dartpad.dev/embed-flutter.html?&split=65&theme=light&run=true&id=67b05a00bd0de7f82fa8c206889954c8",
      image: "2_fab_properties.webp",
      widget: null,
    ),
    CustomComponent(
      id: 17,
      title: "FAB Color Mappings",
      description:
          "By utilizing the color property of the FAB, developers can customize the appearance of the button to align with specific color schemes or themes.",
      tag: "Flutter",
      label: "Action",
      website:
          "https://dartpad.dev/embed-flutter.html?&split=65&theme=light&run=true&id=1e88c71141a99189e18af0acda7f3287",
      image: "2_fab_color.webp",
      widget: null,
    ),
    CustomComponent(
      id: 18,
      title: "FAB extended",
      description:
          "Use an extended FAB on screens with long, scrolling views that require persistent access to an action, such as a check-out screen. Do not use an extended FAB in a view that cannot scroll.",
      tag: "Flutter",
      label: "Action",
      website:
          "https://dartpad.dev/embed-flutter.html?&split=65&theme=light&run=true&id=4ed0b30868a7dc806dd71cb908cecf5d",
      image: "3_fab_extend.webp",
      widget: null,
    ),

    CustomComponent(
      id: 19,
      title: "Icon Button",
      description:
          "Icon buttons can be used within other components, such as a bottom app bar, top app bars often contain icon buttons.",
      tag: "Flutter",
      label: "Action",
      website:
          "https://dartpad.dev/embed-flutter.html?&split=65&theme=light&run=true&id=234e441d3b99ff636ca3390aee2a1892",
      image: "icon_button.webp",
      widget: null,
    ),
    CustomComponent(
      id: 20,
      title: "Icon toggle Button",
      description:
          "Toggle icon buttons allow a single choice to be selected or deselected, such as adding or removing something from favorites.",
      tag: "Flutter",
      label: "Action",
      website:
          "https://dartpad.dev/embed-flutter.html?&split=65&theme=light&run=true&id=75a8e1bc0a9d8b18fe3594f4147c4abb",
      image: "4_icon_button_2.webp",
      widget: null,
    ),
    CustomComponent(
      id: 21,
      title: "Segmented Button",
      description:
          "Segmented buttons help people select options, switch views, or sort elements.",
      tag: "Flutter",
      label: "Action",
      website:
          "https://dartpad.dev/embed-flutter.html?&split=65&theme=light&run=true&id=fb4f7f5e45e0c6eebef72098ef3d0a29",
      image: "5_button_segmented.webp",
      widget: null,
    ),
    CustomComponent(
      id: 22,
      title: "Menus",
      description:
          "Use a menu to display a list of choices on a temporary surface, such as a set of overflow actions in a top app bar.",
      tag: "Flutter",
      label: "Action",
      website:
          "https://dartpad.dev/embed-flutter.html?&split=65&theme=light&run=true&id=4a60305ea707fb9b5f37a00722e874fa",
      image: "23_menu2.png",
      widget: null,
    ),

    CustomComponent(
      id: 23,
      title: "Date pickers",
      description:
          "Date pickers let people select a date or range of dates. They should be suitable for the context in which they appear.",
      tag: "Flutter",
      label: "Action",
      website:
          "https://dartpad.dev/embed-flutter.html?&split=55&theme=light&run=true&id=13810cc684aa9c75c7bf15da07495bab",
      image: "date_picker.webp",
      widget: null,
    ),
    CustomComponent(
      id: 24,
      title: "Time pickers",
      description:
          "Time pickers allow people to enter a specific time value. They’re displayed in dialogs and can be used to select hours, minutes, or periods of time.",
      tag: "Flutter",
      label: "Action",
      website:
          "https://dartpad.dev/embed-flutter.html?&split=55&theme=light&run=true&id=4d2aefc56b2fd6af0cfd98d5456b3350",
      image: "time_picker.webp",
      widget: null,
    ),
    CustomComponent(
      id: 25,
      title: "Snackbar",
      description:
          "Snackbars show short updates about app processes at the bottom of the screen.",
      tag: "Flutter",
      label: "Action",
      website:
          "https://dartpad.dev/embed-flutter.html?&split=65&theme=light&run=true&id=5427106593ac173d6cee0c481af5c1fe",
      image: "8_snackbar2.webp",
      widget: null,
    ),
    CustomComponent(
      id: 26,
      title: "Filled Text fields",
      description:
          "There are two types of text fields: Filled text fields, Outlined text fields. Both types of text fields use a container to provide a visual cue for interaction and provide the same functionality.",
      tag: "Flutter",
      label: "Action",
      website:
          "https://dartpad.dev/embed-flutter.html?&split=65&theme=light&run=true&id=1009549cdc3600afda0cbc94909c391f",
      image: "filled_textfield.webp",
      widget: null,
    ),
    CustomComponent(
      id: 27,
      title: "Outlined Text fields",
      description:
          "Use a text field when someone needs to enter text into a UI, such as filling in contact or payment information.",
      tag: "Flutter",
      label: "Action",
      website:
          "https://dartpad.dev/embed-flutter.html?&split=65&theme=light&run=true&id=649624de24eaa52d973c84935388b98c",
      image: "outlined_textfield.webp",
      widget: null,
    ),
    CustomComponent(
      id: 28,
      title: "Common Text fields",
      description:
          "Common utility function for text fields allows users to enter text into a UI.",
      tag: "Flutter",
      label: "Action",
      website:
          "https://dartpad.dev/embed-flutter.html?&split=65&theme=light&run=true&id=c5beeee7fb0e87232e60248d7cf0fa12",
      image: "common_text_fields.webp",
      widget: null,
    ),

    CustomComponent(
      id: 29,
      title: "Action chips",
      description:
          "Action chips offer actions related to primary content. They should appear dynamically and contextually in a UI. An alternative to action chips are buttons, which should appear persistently and consistently.",
      tag: "Flutter",
      label: "Action",
      website:
          "https://dartpad.dev/embed-flutter.html?&split=65&theme=light&run=true&id=0fb8216fb74722c03c2b096d1838226f",
      image: "chip1.webp",
      widget: null,
    ),
    CustomComponent(
      id: 30,
      title: "Choice chip",
      description:
          "Choice chips allow selection of a single chip from a set of options. Choice chips clearly delineate and display options in a compact area. They are a good alternative to toggle buttons, radio buttons, and single select menus.",
      tag: "Flutter",
      label: "Action",
      website:
          "https://dartpad.dev/embed-flutter.html?&split=65&theme=light&run=true&id=c5905a4ce445f71b102e672763ed7ec5",
      image: "chip2.webp",
      widget: null,
    ),
    CustomComponent(
      id: 31,
      title: "Filter chip",
      description:
          "Filter chips use tags or descriptive words to filter content. Filter chips clearly delineate and display options in a compact area. They are a good alternative to toggle buttons or checkboxes.",
      tag: "Flutter",
      label: "Action",
      website:
          "https://dartpad.dev/embed-flutter.html?&split=65&theme=light&run=true&id=1b480807da2de67b854a74e6674b91ca",
      image: "chip3.webp",
      widget: null,
    ),
    CustomComponent(
      id: 31,
      title: "Input chip",
      description:
          "Input chips represent a complex piece of information in compact form, such as an entity (person, place, or thing) or text. They enable user input and verify that input by converting text into chips.",
      tag: "Flutter",
      label: "Action",
      website:
          "https://dartpad.dev/embed-flutter.html?&split=65&theme=light&run=true&id=c2213054b47d50c233caf5eb7082dd2c",
      image: "chip4.webp",
      widget: null,
    ),

    CustomComponent(
      id: 32,
      title: "Checkbox",
      description:
          "Checkboxes let users select one or more items from a list, or turn an item on or off.",
      tag: "Flutter",
      label: "Action",
      website:
          "https://dartpad.dev/embed-flutter.html?&split=65&theme=light&run=true&id=24b50afc7db86a2323b1621c422138fb",
      image: "checkbox.webp",
      widget: null,
    ),
    CustomComponent(
      id: 33,
      title: "Switch",
      description:
          "Switches are best used to adjust settings and other standalone options. They make a binary selection, like on and off or true and false.",
      tag: "Flutter",
      label: "Action",
      website:
          "https://dartpad.dev/embed-flutter.html?&split=65&theme=light&run=true&id=5ed6d475f25ee4afcc18e37b5eceaa25",
      image: "switch.webp",
      widget: null,
    ),

    CustomComponent(
      id: 34,
      title: "Radio button",
      description:
          "Radio buttons are the recommended way to allow users to make a single selection from a list of options.",
      tag: "Flutter",
      label: "Action",
      website:
          "https://dartpad.dev/embed-flutter.html?&split=65&theme=light&run=true&id=ef6370c948b1932f63a871eeb6916cfd",
      image: "radio.webp",
      widget: null,
    ),

    CustomComponent(
      id: 35,
      title: "Sliders",
      description:
          "Sliders allow users to view and select a value (or range) along a track. They’re ideal for adjusting settings such as volume and brightness, or for applying image filters.",
      tag: "Flutter",
      label: "Action",
      website:
          "https://dartpad.dev/embed-flutter.html?&split=65&theme=light&run=true&id=fdfb27ef2e49bc36c2b3361c3caf4ea3",
      image: "slider.webp",
      widget: null,
    ),

    CustomComponent(
      id: 36,
      title: "Banner",
      description:
          "A banner displays an important, succinct message, and provides actions for users to address (or dismiss the banner). A user action is required for it to be dismissed.",
      tag: "Flutter",
      label: "Action",
      website:
          "https://dartpad.dev/embed-flutter.html?&split=55&theme=light&run=true&id=320d41b8e92470edcaf47e2fade19235",
      image: "32_banner.webp",
      widget: null,
    ),
    CustomComponent(
      id: 37,
      title: "Tooltips",
      description: "Tooltips display brief labels or messages.",
      tag: "Flutter",
      label: "Action",
      website:
          "https://dartpad.dev/embed-flutter.html?&split=65&theme=light&run=true&id=a6783bcba80616b5400d3fe9d8963aff",
      image: "tooltip.webp",
      // widget: DataTableDemo(),
      widget: null,
    ),
    CustomComponent(
      id: 38,
      title: "Data tables",
      description:
          "Data tables display information in a grid-like format of rows and columns. They organise information in a way that's easy to scan, so that users can look for patterns and insights.",
      tag: "Flutter",
      label: "Action",
      website:
          "https://dartpad.dev/embed-flutter.html?&split=65&theme=light&run=true&id=90d38d6ab2fb74b39501b477398f8c01",
      image: "data_table.webp",
      widget: null,
    ),
    CustomComponent(
      id: 39,
      title: "Progress indicator",
      description:
          "Progress indicators express an unspecified wait time or display the length of a process.",
      tag: "Flutter",
      label: "Action",
      website:
          "https://dartpad.dev/embed-flutter.html?&split=65&theme=light&run=true&id=7795c2d60ca4c80ec503bed6ee0226fb",
      image: "progress_bar.webp",
      widget: null,
    ),

    //https://api.flutter.dev/flutter/material/Divider-class.html
    CustomComponent(
      id: 40,
      title: "Divider",
      description:
          "Layout is the visual arrangement of elements on the screen.",
      tag: "Flutter",
      label: "Action",
      website:
          "https://dartpad.dev/embed-flutter.html?&split=65&theme=light&run=true&id=f6c8100335f8b1fc34780f0767e9f144",
      image: "divider.webp",
      widget: null,
    ),
    CustomComponent(
      id: 41,
      title: "Dialog Licenses",
      description:
          "This is a dialog box with the application's icon, name, version number, and copyright, plus a button to show licenses for software used by the application.",
      tag: "Flutter",
      label: "Action",
      website:
          "https://dartpad.dev/embed-flutter.html?&split=65&theme=light&run=true&id=08354291678094ef6d8a924130a2be89",
      image: "about.webp",
      widget: null,
    ),

//............................................

    CustomComponent(
      id: 42,
      title: "Dialogs",
      description: "Dialogs provide important prompts in a user flow.",
      tag: "Flutter",
      label: "Action",
      website:
          "https://dartpad.dev/embed-flutter.html?&split=65&theme=light&run=true&id=b096ad881069931b1625bd07a5250f16",
      image: "dialog_basic.webp",
      widget: null,
    ),
    CustomComponent(
      id: 43,
      title: "Bottom sheet Modal",
      description:
          "Like dialogs, modal bottom sheets appear in front of app content, disabling all other app functionality when they appear, and remaining on screen until confirmed, dismissed, or a required action has been taken.",
      tag: "Flutter",
      label: "Action",
      website:
          "https://dartpad.dev/embed-flutter.html?&split=65&theme=light&run=true&id=b096ad881069931b1625bd07a5250f16",
      image: "bottom_sheet_modal.webp",
      widget: null,
    ),
    CustomComponent(
      id: 44,
      title: "Bottom sheet Persistent",
      description:
          "Bottom sheets can offer an expansion option where the sheet is fully raised and toggled between a collapsed and expanded state. This provides a more predictable footprint of the sheet, and can be set by the system or toggled by the user.",
      tag: "Flutter",
      label: "Action",
      website:
          "https://dartpad.dev/embed-flutter.html?&split=65&theme=light&run=true&id=e501965581ff09fc6deb281a01c9346e",
      image: "bottom_sheet_persistent.webp",
      widget: null,
    ),

    CustomComponent(
      id: 45,
      title: "Lists",
      description: "Lists are continuous, vertical indexes of text and images",
      tag: "Flutter",
      label: "Action",
      website:
          "https://dartpad.dev/embed-flutter.html?&split=65&theme=light&run=true&id=cd0278327f5ebdc69c2c2dae43c80e54",
      image: "list.webp",
      widget: null,
    ),

    CustomComponent(
      id: 46,
      title: "Grid lists",
      description: "Row and column layout.",
      tag: "Flutter",
      label: "Action",
      website:
          "https://dartpad.dev/embed-flutter.html?&split=65&theme=light&run=true&id=1ca480735b0790bc8844feb0a68e49df",
      image: "grid.webp",
      widget: null,
    ),

    CustomComponent(
      id: 47,
      title: "Badges",
      description:
          "Badges show notifications, counts, or status information on navigation items and icons.",
      tag: "Flutter",
      label: "Action",
      website:
          "https://dartpad.dev/embed-flutter.html?&split=65&theme=light&run=true&id=126e96b91e655960c0aca22f7b42f2aa",
      image: "badges.webp",
      widget: null,
    ),
    CustomComponent(
      id: 48,
      title: "Navigation transitions",
      description:
          "Navigational transitions occur when users move between screens, such as from a home screen to a detail screen.",
      tag: "Flutter",
      label: "Action",
      website:
          "https://dartpad.dev/embed-flutter.html?&split=65&theme=light&run=true&id=9e90afec3c3f9e703c1632f87ec1b9ff",
      image: "35_transitions.webp",
      widget: null,
    ),
    CustomComponent(
      id: 49,
      title: "Typography",
      description:
          "Definitions for the various typographical styles found in Material Design.",
      tag: "Flutter",
      label: "Action",
      website:
          "https://dartpad.dev/embed-flutter.html?&split=65&theme=light&run=true&id=42dd6dd4aed43e45504fec65711eb3aa",
      image: "33_typography.webp",
      widget: null,
    ),
    CustomComponent(
      id: 50,
      title: "Elevation",
      description:
          "Elevation is the distance between two surfaces on the z-axis.",
      tag: "Flutter",
      label: "Action",
      website:
          "https://dartpad.dev/embed-flutter.html?&split=50&theme=light&run=true&id=4bc263b7b20ef4c228f710176760d5e7",
      image: "elevation.webp",
      widget: null,
    ),

    //...........................
    //https://api.flutter.dev/flutter/material/Stepper-class.html
    CustomComponent(
      id: 51,
      title: "Stepper",
      description:
          "A Material Design stepper widget that displays progress through a sequence of steps.",
      tag: "Flutter",
      label: "Layout",
      website:
          "https://dartpad.dev/embed-flutter.html?&split=65&theme=light&run=true&id=73884111617b7947513dcb1a299aca69",
      image: "stepper.webp",
      widget: null,
    ),

    //https://api.flutter.dev/flutter/material/ListTile-class.html
    CustomComponent(
      id: 51,
      title: "ListTile",
      description:
          "A single fixed-height row that typically contains some text as well as a leading or trailing icon.",
      tag: "Flutter",
      label: "Layout",
      website:
          "https://dartpad.dev/embed-flutter.html?&split=65&theme=light&run=true&id=19ec482ee5cb6e0a028bdb1a4e4d15ed",
      image: "list_title.webp",
      widget: null,
    ),

    //https://api.flutter.dev/flutter/material/Scaffold-class.html
    CustomComponent(
      id: 52,
      title: "Icons",
      description: "Icons are small symbols for actions or other items.",
      tag: "Flutter",
      label: "Layout",
      website:
          "https://dartpad.dev/embed-flutter.html?&split=65&theme=light&run=true&id=fa44c13b12d36133de24342b21a4c091",
      image: "icons.webp",
      widget: null,
    ),

    //https://api.flutter.dev/flutter/material/AnimatedIcons-class.html
    CustomComponent(
      id: 53,
      title: "Animated Icons",
      description: "Icons are small symbols for actions or other items.",
      tag: "Flutter",
      label: "Icons",
      website:
          "https://dartpad.dev/embed-flutter.html?&split=65&theme=light&run=true&id=bab8a8a95f76451a3dfe698db6f714f2",
      image: "icons.webp",
      widget: null,
    ),

    //https://api.flutter.dev/flutter/material/ExpansionPanelList-class.html
    CustomComponent(
      id: 54,
      title: "ExpansionPanel",
      description:
          "Expansion panels contain creation flows and allow lightweight editing of an element.",
      tag: "Flutter",
      label: "Icons",
      website:
          "https://dartpad.dev/embed-flutter.html?&split=65&theme=light&run=true&id=0daae099fd7ae1a30c3d1ce64013ca29",
      image: "expansion.webp",
      widget: null,
    ),

    CustomComponent(
      id: 55,
      title: "Colors",
      description:
          "Colour and colour swatch constants which represent Material Design's colour palette.",
      tag: "Flutter",
      label: "Styles",
      website:
          "https://dartpad.dev/embed-flutter.html?&split=45&theme=light&run=true&id=64bb2c73236a865adcaff23e7c19faa2",
      image: "color.webp",
      widget: null,
    ),

    CustomComponent(
      id: 56,
      title: "Onboarding",
      description:
          "Onboarding is a virtual unboxing experience that helps users get started with an app.",
      tag: "Flutter",
      label: "Styles",
      website:
          "https://dartpad.dev/embed-flutter.html?&split=55&theme=light&run=true&id=6923866dc39658fbfdb798e5aaf63fa9",
      image: "onboard.webp",
      widget: null,
    ),

    CustomComponent(
      id: 57,
      title: "Imagery",
      description:
          "Imagery communicates and differentiates a product through visuals.",
      tag: "Flutter",
      label: "Styles",
      website:
          "https://dartpad.dev/embed-flutter.html?&split=55&theme=light&run=true&id=bc95530b162b1e63ea5732033e1e42b1",
      image: "imagery_new.webp",
      widget: null,
    ),

    CustomComponent(
      id: 58,
      title: "Responsive and Adaptive",
      description:
          "Depending on the screen size, you may see your app on a watch, a foldable phone with two screens, or a high-definition monitor.",
      tag: "Flutter",
      label: "Styles",
      website:
          "https://dartpad.dev/embed-flutter.html?&split=55&theme=light&run=true&id=1f397fab579c68d0a2bc331a806da4dc",
      image: "40_adaptive_layout.webp",
      widget: null,
    ),
    CustomComponent(
      id: 59,
      title: "Launch screen",
      description:
          "The launch screen is a user’s first experience of your app.",
      tag: "Flutter",
      label: "Action",
      website:
          "https://dartpad.dev/embed-flutter.html?&split=65&theme=light&run=true&id=d5a23acc3615bd3e6f0865cb9bdae6b6",
      image: "launch.webp",
      widget: null,
    ),

    CustomComponent(
      id: 60,
      title: "Empty states",
      description: "Empty states occur when an item’s content can’t be shown.",
      tag: "Flutter",
      label: "Action",
      website:
          "https://dartpad.dev/embed-flutter.html?&split=55&theme=light&run=true&id=79596919dfbfd0699acf21089358ed53",
      image: "empty_state.webp",
      widget: null,
    ),

    //...............................................................................................
    CustomComponent(
      id: 61,
      title: "Fade Scale Transition",
      description:
          "The fade pattern is used for UI elements that enter or exit from within the screen bounds. Elements that enter use a quick fade in and scale from 80% to 100%. Elements that exit simply fade out.",
      tag: "Flutter",
      label: "Motion",
      website:
          "https://dartpad.dev/embed-flutter.html?&split=65&theme=light&run=true&id=bdec1d017bfe251ee20d4c37354b6dd5",
      image: "motions.png",
      widget: null,
    ),
    CustomComponent(
      id: 62,
      title: "Fade Through Transition",
      description:
          "Defines a transition in which outgoing elements fade out, then incoming elements fade in and scale up.",
      tag: "Flutter",
      label: "Motion",
      website:
          "https://dartpad.dev/embed-flutter.html?&split=65&theme=light&run=true&id=4e34256562c706accefbb0c675c6daa4",
      image: "motions.png",
      widget: null,
    ),
    CustomComponent(
      id: 63,
      title: "Shared X Axis Transition",
      description:
          "The shared axis pattern is used for transitions between UI elements that have a spatial or navigational relationship. This pattern uses a shared transformation on the x, y, or z axis to reinforce the relationship between elements.",
      tag: "Flutter",
      label: "Motion",
      website:
          "https://dartpad.dev/embed-flutter.html?&split=65&theme=light&run=true&id=836500e6f7f683a692e155f751eff638",
      image: "motions.png",
      widget: null,
    ),
    CustomComponent(
      id: 64,
      title: "Open Container Transform",
      description:
          "The container transform pattern is designed for transitions between UI elements that include a container. This pattern creates a visible connection between two UI elements.",
      tag: "Flutter",
      label: "Motion",
      website:
          "https://dartpad.dev/embed-flutter.html?&split=65&theme=light&run=true&id=e30c1f0defe0400fea4b235f641d3494",
      image: "motions.png",
      widget: null,
    ),
    CustomComponent(
      id: 65,
      title: "Google Fonts",
      description:
          "Making the web more beautiful, fast, and open through great typography and iconography",
      tag: "Flutter",
      label: "Styles",
      website:
          "https://dartpad.dev/embed-flutter.html?&split=55&theme=light&run=true&id=16889b14d045ee8a993604c0f31b126e",
      image: "34_custom_font.webp",
      widget: null,
    ),

    ////////////////////////////////
    CustomComponent(
      id: 101,
      title: "Cupertino Activity indicator",
      description: "An iOS-style activity indicator that spins clockwise.",
      tag: "Flutter",
      label: "Cupertino",
      website:
          "https://dartpad.dev/embed-flutter.html?&split=65&theme=light&run=true&id=6caeeb44541fbba9c3af83dadefe6c7b",
      image: "cupertino_activity_indicator.webp",
      widget: null,
    ),
    CustomComponent(
      id: 102,
      title: "Cupertino Alert Dialog",
      description: "An iOS-style alert dialog.",
      tag: "Flutter",
      label: "Cupertino",
      website:
          "https://dartpad.dev/embed-flutter.html?&split=65&theme=light&run=true&id=36c1c136aeb1509b2ed36836288d5fd3",
      image: "cupertino_alert_dialog.webp",
      widget: null,
    ),
    CustomComponent(
      id: 103,
      title: "Cupertino Action Sheet",
      description:
          "An iOS-style modal bottom action sheet to choose an option among many.",
      tag: "Flutter",
      label: "Cupertino",
      website:
          "https://dartpad.dev/embed-flutter.html?&split=65&theme=light&run=true&id=ca40bee462e9415a4ab9c06250736976",
      image: "cupertino_action_sheet.webp",
      widget: null,
    ),
    CustomComponent(
      id: 104,
      title: "Cupertino Buttons",
      description:
          "An iOS-style button. It takes in text and/or an icon that fades out and in on touch. May optionally have a background.",
      tag: "Flutter",
      label: "Cupertino",
      website:
          "https://dartpad.dev/embed-flutter.html?&split=65&theme=light&run=true&id=6313f5397f1a567eca6c86ca9ba2cf7c",
      image: "cupertino_button.webp",
      widget: null,
    ),
    CustomComponent(
      id: 105,
      title: "Cupertino Context menu",
      description:
          "An iOS-style full screen contextual menu that appears when an element is long-pressed.",
      tag: "Flutter",
      label: "Cupertino",
      website:
          "https://dartpad.dev/embed-flutter.html?&split=65&theme=light&run=true&id=ef6f8116c5985faf383d83bd12236574",
      image: "cupertino_context_menu.webp",
      widget: null,
    ),
    CustomComponent(
      id: 106,
      title: "Cupertino Date Picker",
      description: "An iOS-style date pickers.",
      tag: "Flutter",
      label: "Cupertino",
      website:
          "https://dartpad.dev/embed-flutter.html?&split=65&theme=light&run=true&id=a61863d0f4aee2ec07949f074488510e",
      image: "cupertino_date_picker.webp",
      widget: null,
    ),

    //..............................................................................................
    CustomComponent(
      id: 107,
      title: "Cupertino Time Picker",
      description: "An iOS-style time pickers.",
      tag: "Flutter",
      label: "Cupertino",
      website:
          "https://dartpad.dev/embed-flutter.html?&split=65&theme=light&run=true&id=190244e0778ee81763f05bac63a1d8c7",
      image: "cupertino_date_picker.webp",
      widget: null,
    ),
    CustomComponent(
      id: 108,
      title: "Cupertino Time Picker",
      description: "An iOS-style time pickers.",
      tag: "Flutter",
      label: "Cupertino",
      website:
          "https://dartpad.dev/embed-flutter.html?&split=65&theme=light&run=true&id=d93fb1d8c44b16a10d581e42d4c4d054",
      image: "cupertino_timer_picker.webp",
      widget: null,
    ),
    CustomComponent(
      id: 109,
      title: "Cupertino Navigation Bar",
      description:
          "Container at the top of a screen that uses the iOS style. Many developers use this with `CupertinoPageScaffold`",
      tag: "Flutter",
      label: "Cupertino",
      website:
          "https://dartpad.dev/embed-flutter.html?&split=65&theme=light&run=true&id=d3f84fc82c804a4d1848692f3f0adc00",
      image: "cupertino_nav_bar.webp",
      widget: null,
    ),
    CustomComponent(
      id: 1091,
      title: "Cupertino Picker",
      description:
          "An iOS-style picker control. Used to select an item in a short list.",
      tag: "Flutter",
      label: "Cupertino",
      website:
          "https://dartpad.dev/embed-flutter.html?&split=65&theme=light&run=true&id=d591f11ab09d64b4e943ea0641054712",
      image: "cupertino_picker.webp",
      widget: null,
    ),
    //..............................................................................................
    CustomComponent(
      id: 1102,
      title: "Cupertino Scrollbar",
      description: "A scrollbar that wraps the given child.",
      tag: "Flutter",
      label: "Cupertino",
      website:
          "https://dartpad.dev/embed-flutter.html?&split=65&theme=light&run=true&id=01ae11dcd31729a3cb16c795f0a47e4b",
      image: "cupertino_scrollbar.webp",
      widget: null,
    ),
    CustomComponent(
      id: 111,
      title: "Cupertino TextField",
      description:
          "A text field allows the user to enter text, either with a hardware keyboard or with an on-screen keyboard.",
      tag: "Flutter",
      label: "Cupertino",
      website:
          "https://dartpad.dev/embed-flutter.html?&split=65&theme=light&run=true&id=6121816590783187b16f2c35e61601fd",
      image: "cupertino_textfield.webp",
      widget: null,
    ),
    CustomComponent(
      id: 112,
      title: "Cupertino Search TextField",
      description: "An iOS-style search field.",
      tag: "Flutter",
      label: "Cupertino",
      website:
          "https://dartpad.dev/embed-flutter.html?&split=65&theme=light&run=true&id=33862755c33142b07c6549ec345ad4f4",
      image: "cupertino_search_field.webp",
      widget: null,
    ),

    CustomComponent(
      id: 113,
      title: "Cupertino Switch",
      description:
          "An iOS-style switch. Used to toggle the on/off state of a single setting.",
      tag: "Flutter",
      label: "Cupertino",
      website:
          "https://dartpad.dev/embed-flutter.html?&split=65&theme=light&run=true&id=dc50253fba694e4f424345a181886f2b",
      image: "cupertino_switch.png",
      widget: null,
    ),

    CustomComponent(
      id: 114,
      title: "Cupertino Segmented control",
      description:
          "An iOS-13-style segmented control. Used to select mutually exclusive options in a horizontal list.",
      tag: "Flutter",
      label: "Cupertino",
      website:
          "https://dartpad.dev/embed-flutter.html?&split=65&theme=light&run=true&id=b40651f484fccc2eef8b275261bfedcf",
      image: "cupertino_segmented_control.webp",
      widget: null,
    ),

    CustomComponent(
      id: 115,
      title: "Cupertino Slider",
      description:
          "A slider can be used to select from either a continuous or a discrete set of values.",
      tag: "Flutter",
      label: "Cupertino",
      website:
          "https://dartpad.dev/embed-flutter.html?&split=65&theme=light&run=true&id=d026e6fcb744962331991cc65c092fb4",
      image: "cupertino_slider.webp",
      widget: null,
    ),

    CustomComponent(
      id: 116,
      title: "Cupertino TabBar",
      description:
          "An iOS-style bottom tab bar. Typically used with CupertinoTabScaffold.",
      tag: "Flutter",
      label: "Cupertino",
      website:
          "https://dartpad.dev/embed-flutter.html?&split=65&theme=light&run=true&id=0c3ac76421e79df6d5aa2a912ba718d3",
      image: "cupertino_tab_bar.webp",
      widget: null,
    ),
  ];

  // List<Map<String, dynamic>> displayedItems = [];
  List<CustomComponent> displayedItems = [];

  StreamSubscription? connection;
  bool isoffline = false;

  final ScrollController _scrollController = ScrollController();

  @override
  String get restorationId => 'flutter_gallery';

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_selectedIndex, 'selected_index');
  }

  void _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      if (!isLoading) {
        loadData();
      }
    }
  }

  @override
  void initState() {
    super.initState();

    connection = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      // whenevery connection status is changed.
      if (result == ConnectivityResult.none) {
        //there is no any connection
        setState(() {
          isoffline = true;
        });
      } else if (result == ConnectivityResult.mobile) {
        //connection is mobile data network
        setState(() {
          isoffline = false;
        });
      } else if (result == ConnectivityResult.wifi) {
        //connection is from wifi
        setState(() {
          isoffline = false;
        });
      } else if (result == ConnectivityResult.ethernet) {
        //connection is from wired connection
        setState(() {
          isoffline = false;
        });
      } else if (result == ConnectivityResult.bluetooth) {
        //connection is from bluetooth threatening
        setState(() {
          isoffline = false;
        });
      }
    });
    _scrollController.addListener(_scrollListener);
    loadDataAll();
  }

  void loadData() {
    print('load init');
    setState(() {
      isLoading = true; // Set isLoading flag to true
      int currentLength = displayedItems.length;
      int nextIndex = currentLength + 12;

      if (nextIndex > items.length) {
        nextIndex = items.length;
      }
      displayedItems.addAll(items.getRange(currentLength, nextIndex));
      isLoading = false; // Set isLoading flag to false
      print('load init ${displayedItems.length}');
    });
  }

  void loadDataAll() {
    print('loadDataAll init');
    setState(() {
      isLoading = true; // Set isLoading flag to true
      int currentLength = displayedItems.length;
      int nextIndex = currentLength + 150;

      if (nextIndex > items.length) {
        nextIndex = items.length;
      }
      displayedItems.addAll(items.take(12).toList());
      isLoading = false; // Set isLoading flag to false
    });
    print('loadDataAll init ${displayedItems.length}');
  }

  @override
  void dispose() {
    _selectedIndex.dispose();
    _scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  // Method to navigate to the detail page when a post is tapped.
  Future<void> _navigateToDetail(
    BuildContext context,
    CustomComponent displayedItem,
  ) async {
    var result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.none) {
      print("No internet connection");
      openDialog(context);
    } else {
      if (displayedItem.website != "") {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => DetailPage(displayedItem: displayedItem),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Theme.of(context);

    Widget cardViewDesign(CustomComponent displayedItem) {
      print(displayedItem.title.length);

      final textTheme = Theme.of(context)
          .textTheme
          .apply(displayColor: Theme.of(context).colorScheme.onSurface);

      return Padding(
        padding: const EdgeInsets.all(25),
        child: Hero(
          tag: 'card_${displayedItem.id}',
          child: Material(
            child: Card(
                elevation: 20,
                color: Colors.white,
                surfaceTintColor: Colors.white,
                shadowColor: Color(0xFFEFD4DD),
                //  shadowColor: Colors.blue.shade500,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(45),
                    topRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(45),
                  ),
                ),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: InkWell(
                    onTap: () async {
                      //  _launchURL(context, displayedItem.website);
                      _navigateToDetail(context, displayedItem);
                    },
                    splashColor: Colors.white,
                    highlightColor: Colors.white,
                    hoverColor: Colors.white,
                    focusColor: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Visibility(
                          visible: displayedItem.image.isNotEmpty,
                          child: ColorFiltered(
                            colorFilter: const ColorFilter.mode(
                                Colors.white, BlendMode.hue),
                            // colorFilter:  ColorFilter.mode(Colors.blue.shade50, BlendMode.hue),
                            child: Image.asset(
                              "assets/images/${displayedItem.image}",
                              height: 170,
                            ),
                          ),
                        ),
                        Container(
                          color: Colors.white,
                          padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              ShaderMask(
                                shaderCallback: (Rect bounds) {
                                  return LinearGradient(
                                    colors: [
                                      Color(0xFF0072ff),
                                      Color(0xff2880ea),
                                      Color(0xFF0072ff),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ).createShader(bounds);
                                },
                                blendMode: BlendMode.srcIn,
                                child: TextStyleExample(
                                    name: displayedItem.title,
                                    style: textTheme.titleMedium!.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xff1967d2),
                                    )),
                              ),

                              //Container(height: 10),
                              TextStyleExample(
                                  name: displayedItem.description,
                                  style: textTheme.bodyMedium!),
                              Container(height: 15),

                              displayedItem.website != ''
                                  ? Container(
                                      padding: const EdgeInsets.all(5),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Container(height: 3),
                                          SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment
                                                  .end, // Aligns buttons to the right
                                              children: [
                                                // "Preview" Button
                                                /*displayedItem.website != ''
                                              ? GestureDetector(
                                            onTap: () {
                                              _navigateToDetail(context, displayedItem);
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  colors: [
                                                    Color(0xFF0072ff), // Start color
                                                    Color(0xFF00c6ff), // End color
                                                  ],
                                                  begin: Alignment.topLeft,
                                                  end: Alignment.bottomRight,
                                                ),
                                                borderRadius: BorderRadius.circular(25.0),
                                              ),
                                              padding: const EdgeInsets.symmetric(
                                                  vertical: 10, horizontal: 20),
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.code_rounded,
                                                    color: Colors.white,
                                                    size: 25.0,
                                                  ),
                                                  SizedBox(width: 8),
                                                  Text(
                                                    'Preview',
                                                    style: textTheme.titleSmall!.copyWith(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                              : Container(height: 5),*/
                                                SizedBox(
                                                    width:
                                                        10), // Spacing between buttons
                                                // "Demo" Button
                                                GestureDetector(
                                                  onTap: () {
                                                    _navigateToDetail(
                                                        context, displayedItem);
                                                  },
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      gradient: LinearGradient(
                                                        colors: [
                                                          Color(0xFF6A88E5),
                                                          Color(0xFFFD4685),
                                                        ],
                                                        begin:
                                                            Alignment.topLeft,
                                                        end: Alignment
                                                            .bottomRight,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              25.0),
                                                    ),
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        vertical: 10,
                                                        horizontal: 20),
                                                    child: Row(
                                                      children: [
                                                        Icon(
                                                          Icons
                                                              .play_arrow_rounded,
                                                          color: Colors.white,
                                                          size: 25.0,
                                                        ),
                                                        SizedBox(width: 8),
                                                        Text(
                                                          'Demo and Explore',
                                                          style: textTheme
                                                              .titleSmall!
                                                              .copyWith(
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : Container(height: 5),
                              Container(height: 20),
                            ],
                          ),
                        ),
                        Container(height: 5)
                      ],
                    ) // add your Card widget here
                    )),
          ),
        ),
      );
    }

    int getResponsiveGridCount(BuildContext context) {
      double screenWidth = MediaQuery.of(context).size.width;
      if (screenWidth > 1200) {
        return 3;
      } else if (screenWidth > 800) {
        return 2;
      } else {
        return 1;
      }
    }


    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(25.0), // Rounded bottom-right corner
            ),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF0072ff), // Start color
                    Color(0xFFF00c6ff), // End color
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: AppBar(
                backgroundColor: Colors.transparent, // Make AppBar transparent
                elevation: 0, // Remove shadow
                leading: IconButton(
                  icon: Icon(Icons.arrow_back_rounded, color: Colors.white),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                title: Text(
                  "Widget Gallery",
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: Colors.white,
                      ),
                ),
                centerTitle: true,
              ),
            ),
          ),
        ),
        body: Container(
          child: Row(
            children: [
              Expanded(
                  child: Stack(children: [
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xffffffff),
                        const Color(0xffffffff),
                        const Color(0xffffffff),
                      ],
                      //colors: [Color(0xFFFF512F), Color(0xFFDD2476)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
                Row(
                  children: [
                    /*  NavigationRail(
                  backgroundColor: const Color(0xfff3f6fc),
                  // Next Navigation
                  leading: Hero(
                      tag: 'material_logo_hero_tag',
                      // Same tag as the first widget
                      child: ShaderMask(
                        shaderCallback: (bounds) => LinearGradient(
                          colors: [
                            Color(0xFFF00c6ff),
                            Color(0xFF0072ff),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ).createShader(bounds),
                        blendMode: BlendMode.srcIn,
                        // Tint the Lottie animation
                        child: LottieBuilder.asset(
                          'assets/anim/material_logo.json',
                          height: 70,
                          fit: BoxFit.cover,
                          repeat: true,
                        ),
                      )),

                  selectedIndex: _selectedIndex.value,
                  // The index of the currently selected navigation item.
                  onDestinationSelected: (index) {
                    setState(() {
                      _selectedIndex.value =
                          index; // Update the index of the selected navigation item when a new item is selected.
                    });

                    if (index == 1) {
                      Navigator.of(context).pushReplacementNamed('/MenuRoute');
                    }
                  },
                  labelType: NavigationRailLabelType.selected,
                  // The type of label to show for the selected navigation item.
                  destinations: [
                    NavigationRailDestination(
                      padding: EdgeInsets.all(16.0),
                      icon: Badge(
                        label: Text('${items.length}'),
                        child: Icon(Icons.code),
                      ),
                      selectedIcon: Icon(
                        Icons.code,
                        size: 40,
                      ),
                      label: Text(
                        "Material 3", // The label of the second navigation item.
                      ),
                    ),
                    const NavigationRailDestination(
                      padding: EdgeInsets.all(16.0),
                      icon: Icon(
                        Icons.arrow_back,
                        size: 30,
                      ),
                      selectedIcon: Icon(
                        Icons.arrow_back,
                        size: 40,
                      ),
                      label: Text(
                        "Home", // The label of the third navigation item.
                      ),
                    ),
                  ],
                ),
                Container(
                  width: 2, // Width of the divider
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xffa5c5ec),  // Gradient end color
                        Color(0xffa5c5ec),  // Gradient end color
                        Color(0xffd5e3f4), // Gradient start color
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),*/

                    Expanded(
                      child: Container(
                        //color: Colors.blue.withOpacity(0.6),
                        child: NotificationListener<ScrollNotification>(
                          onNotification: (ScrollNotification scrollInfo) {
                            if (scrollInfo.metrics.pixels ==
                                    scrollInfo.metrics.maxScrollExtent &&
                                displayedItems.length < items.length &&
                                !isLoading) {
                              loadData();
                            }
                            return true;
                          },
                          child: MasonryGridView.builder(
                              itemCount: displayedItems.length,
                              gridDelegate:
                                  SliverSimpleGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount:
                                          getResponsiveGridCount(context)),
                              itemBuilder: (
                                context,
                                index,
                              ) {
                                return cardViewDesign(displayedItems[index]);
                              }),
                        ),
                      ),
                    ),
                  ],
                ),
              ])),
            ],
          ),
        ));
  }

  void openDialog(BuildContext context) {
    final textTheme = Theme.of(context)
        .textTheme
        .apply(displayColor: Theme.of(context).colorScheme.onSurface);
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: TextStyleExample(name: 'Whoops!', style: textTheme.titleLarge!),
        content: TextStyleExample(
            name:
                "No Internet Connection found.\nCheck your connection or try again.",
            style: textTheme.titleSmall!),
        actions: <Widget>[
          TextButton(
            child: TextStyleExample(name: 'OK', style: textTheme.labelLarge!),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}
