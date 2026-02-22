import 'package:flutter/material.dart';
import 'package:boltuix/adapter/menu_adapter.dart';
import 'package:boltuix/data/img.dart';
import 'package:boltuix/model/menu.dart';
import 'package:boltuix/screens/profile/profile_gradient.dart';
import 'package:boltuix/screens/seekbar/seekbar_range.dart';
import 'package:boltuix/screens/snacktoast/snackbar_custom.dart';
import 'package:boltuix/screens/snacktoast/toast_custom.dart';
import 'package:boltuix/screens/tabs/tabs_simple_product.dart';
import 'package:boltuix/screens/verification/verification_green.dart';
import '../data/my_colors.dart';
import 'backdrop/backdrop_navigation.dart';
import 'backdrop/backdrop_selection.dart';
import 'backdrop/backdrop_text_field.dart';
import 'banner/banner_pin.dart';
import 'banner/banner_small_info.dart';
import 'banner/banner_white.dart';
import 'button/button_text_label.dart';
import 'card/card_divider.dart';
import 'card/card_expand.dart';
import 'chip/chip_action.dart';
import 'chip/chip_choice.dart';
import 'chip/chip_input.dart';
import 'dialog/cupertino_dialog.dart';
import 'form/form_checkout.dart';
import 'form/form_ecommerce.dart';
import 'form/form_sign_up_card_stack.dart';
import 'form/form_sign_up_image.dart';
import 'form/form_sign_up_image_outline.dart';
import 'list/list_multi_selection.dart';
import 'menu/menu_drawer_abstract.dart';
import 'menu/menu_drawer_admin.dart';
import 'motion/motion_fab_view.dart';
import 'motion/motion_list.dart';
import 'noitem/noitem_access.dart';
import 'noitem/noitem_bg_light_house.dart';
import 'onboard/app_intro_background_abstract.dart';
import 'about/onboding_screen.dart';
import 'seekbar/seekbar_filter_flight.dart';
import 'sidesheet/side_sheet_basic.dart';
import 'backdrop/backdrop_basic.dart';
import 'backdrop/backdrop_filter.dart';
import 'backdrop/backdrop_stepper.dart';
import 'bottomsheet/bottom_sheet_expand.dart';
import 'bottomsheet/bottom_sheet_player.dart';
import 'about/about_app.dart';
import 'about/about_app_simple.dart';
import 'article/article_review.dart';
import 'article/article_medium.dart';
import 'article/article_stepper.dart';
import 'bottomnavigation/bottom_navigation_article.dart';
import 'bottomnavigation/bottom_navigation_basic.dart';
import 'bottomnavigation/bottom_navigation_shifting.dart';
import 'bottomsheet/bottom_sheet_basic.dart';
import 'bottomsheet/bottom_sheet_fab.dart';
import 'bottomsheet/bottom_sheet_filter.dart';
import 'bottomsheet/bottom_sheet_floating.dart';
import 'bottomsheet/bottom_sheet_list.dart';
import 'bottomsheet/bottom_sheet_menu.dart';
import 'button/button_fab_middle.dart';
import 'button/button_fab_more_text.dart';
import 'button/button_high_emphasis.dart';
import 'card/card_basic.dart';
import 'card/card_outlined.dart';
import 'card/card_destination_overview.dart';
import 'onboard/app_intro_with_cards.dart';
import 'chat/simple_chat_ui.dart';
import 'chat/abstract_background_chat_ui.dart';
import 'chip/chip_group.dart';
import 'dashboard/dashboard_flight.dart';
import 'dashboard/dashboard_grid_fab.dart';
import 'dashboard/dashboard_pay_bill.dart';
import 'dashboard/dashboard_statistics.dart';
import 'dashboard/dashboard_wallet.dart';

import 'dialog/dialog_basic.dart';
import 'expand/expand_ticket.dart';
import 'form/form_address.dart';
import 'list/list_basic.dart';
import 'list/list_draggable.dart';
import 'list/list_expand.dart';
import 'list/list_news_card.dart';
import 'list/list_news_image.dart';
import 'list/list_news_light.dart';
import 'list/list_news_light_hrzntl.dart';
import 'list/list_swipe.dart';
import 'login/light_theme_login_card.dart';
import 'menu/menu_drawer_agri.dart';
import 'menu/menu_drawer_filter.dart';
import 'menu/menu_drawer_mail.dart';
import 'menu/menu_drawer_news.dart';
import 'menu/menu_drawer_white.dart';
import 'menu/menu_overflow_list.dart';
import 'menu/menu_overflow_toolbar.dart';
import 'motion/motion_card.dart';
import 'motion/motion_fab.dart';
import 'motion/motion_page_basic.dart';
import 'noitem/noitem_internet_icon.dart';
import 'noitem/noitem_internet_image.dart';
import 'payment/payment_card_details.dart';
import 'payment/payment_form.dart';
import 'payment/payment_profile.dart';
import 'picker/picker_date_light.dart';
import 'picker/picker_time_light.dart';
import 'player/circular_album_music_player.dart';
import 'player/music_player_lottie_animation.dart';
import 'player/music_song_list.dart';
import 'profile/profile_image_appbar.dart';
import 'progress/progress_basic.dart';
import 'progress/progress_linear_top.dart';
import 'progress/progress_pull_refresh.dart';
import 'search/search_primary.dart';
import 'search/search_primary_bg.dart';
import 'search/search_toolbar_light_basic.dart';
import 'seekbar/seekbar_light.dart';
import 'settings/setting_flat.dart';
import 'settings/setting_profile_light.dart';
import 'shopping/category_card_view.dart';
import 'shopping/category_with_images.dart';
import 'shopping/category_list_ui.dart';
import 'shopping/product_details_page.dart';
import 'shopping/product_grid_view.dart';
import 'shopping/sub_category_tabs.dart';
import 'sliderimage/slider_image_header.dart';
import 'sliderimage/slider_image_header_auto.dart';
import 'snacktoast/toast_snackbar_basic.dart';
import 'snacktoast/snackbar_lift_fab.dart';
import 'steppers/steppers_wizard_color.dart';
import 'steppers/steppers_wizard_light.dart';
import 'tabs/tabs_basic.dart';
import 'tabs/tabs_icon.dart';
import 'tabs/tabs_icon_light.dart';
import 'tabs/tabs_round.dart';
import 'tabs/tabs_scroll.dart';
import 'tabs/tabs_simple_green.dart';
import 'tabs/tabs_simple_light.dart';
import 'tabs/tabs_store.dart';
import 'tabs/tabs_text_icon.dart';
import 'theme/theme_page.dart';
import 'timeline/timeline_dot_card.dart';
import 'timeline/timeline_explore.dart';
import 'timeline/timeline_feed.dart';
import 'timeline/timeline_path.dart';
import 'timeline/timeline_twitter.dart';
import 'toolbar/toolbar_basic.dart';
import 'toolbar/toolbar_bottom_basic.dart';
import 'toolbar/toolbar_bottom_fab.dart';
import 'toolbar/toolbar_bottom_scroll.dart';
import 'toolbar/toolbar_collapse.dart';
import 'toolbar/toolbar_collapse_and_pin.dart';
import 'toolbar/toolbar_light.dart';
import 'verification/verification_image.dart';
import 'package:boltuix/utils/dialog_about.dart';
import 'package:boltuix/utils/tools.dart';
import 'package:boltuix/widgets/my_text.dart';

import 'bottomnavigation/bottom_navigation_badge_blink.dart';
import 'expand/expand_basic.dart';
import 'expand/expand_invoice.dart';
import 'list/list_sectioned.dart';

class MenuRoute extends StatefulWidget {
  const MenuRoute();

  @override
  MenuRouteState createState() {
    return MenuRouteState();
  }
}

class MenuRouteState extends State<MenuRoute> {
  static const int MAX_PRESS = 10;
  int pressCount = 0;

  List menus = <Menu>[];
  //GlobalKey<ScaffoldState> _scaffoldStateKey = GlobalKey<ScaffoldState>();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> listMenu =
        MenuAdapter(menus, onItemClick).itemsTile as List<Widget>;
    print("menu length ::: ${menus.length}......");

    return MaterialApp(
      debugShowCheckedModeBanner: false, // Add this line to hide the debug flag
      home: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(25.0), // Rounded bottom-right corner
            ),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [MyColors.gradient1, MyColors.gradient2],
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
                    // Navigator.of(context).pushReplacementNamed('/MenuRoute');
                  },
                ),
                title: Text(
                  "Screens Gallery",
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: Colors.white,
                      ),
                ),
                centerTitle: true,
              ),
            ),
          ),
        ),

        // key: _scaffoldStateKey,
        body: CustomScrollView(
          slivers: <Widget>[
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return Container(
                    //color: MyColors.grey_100_,
                    child: Column(
                      children: listMenu,
                    ),
                  );
                },
                childCount: 1,
              ),
            ),
          ],
        ),
        drawer: Container(
          width: 200,
          color: MyColors.grey_100_,
          child: buildDrawer(),
        ),
      ),
    );
  }

  int prevExpand = -1;

  void onItemClick(int index, Menu obj) {
    if (obj.subs.isNotEmpty) {
      // parent
      setState(() {
        if (prevExpand != -1) {
          menus[prevExpand].expand = false;
        }
        menus[index] = obj;
        prevExpand = obj.expand ? index : -1;
      });
    } else {
      // child
      if (obj.route == null) return;
      Navigator.push(context,
          MaterialPageRoute(builder: (BuildContext context) {
        return obj.route!;
      })).then((value) {});
    }
  }

  @override
  void initState() {
    super.initState();

    //...........................................................................
    Menu dialogsMenu = Menu(5000, Icons.picture_in_picture_rounded, "Dialog");
    dialogsMenu.subs
        .add(Menu.sub(5001, "Material Dialog", MaterialDialog(), ""));
    dialogsMenu.subs
        .add(Menu.sub(5002, "Cupertino Dialog", CupertinoDialog(), ""));
    menus.add(dialogsMenu);
    menus.add(Menu.divider());

    Menu menuShopping = Menu(10000, Icons.shopping_cart_rounded, "Shopping");
    menuShopping.subs
        .add(Menu.sub(10001, "Category List UI", CategoryListUI(), ""));
    menuShopping.subs
        .add(Menu.sub(10002, "Category Card View", CategoryCardView(), ""));
    menuShopping.subs
        .add(Menu.sub(10003, "Category with Images", CategoryWithImages(), ""));
    menuShopping.subs
        .add(Menu.sub(10004, "Subcategory Tabs", SubcategoryTabs(), ""));
    menuShopping.subs
        .add(Menu.sub(10005, "Product Grid View", ProductGridView(), ""));
    menuShopping.subs
        .add(Menu.sub(10006, "Product Details Page", ProductDetailsPage(), ""));
    menus.add(menuShopping);
    menus.add(Menu.divider());

    Menu menuChat = Menu(3300, Icons.chat_rounded, "Chat");
    menuChat.subs.add(Menu.sub(3303, "Simple chat UI", SimpleChatUI(), ""));
    menuChat.subs.add(Menu.sub(3302, "Chat UI with background abstract",
        ChatBackgroundAbstract(), ""));
    menus.add(menuChat);
    menus.add(Menu.divider());

    Menu menuLogin = Menu(2000, Icons.lock_rounded, "Login Demo");
    menuLogin.subs.add(
        Menu.sub(2001, "Light Theme Login Card", LightThemeLoginCard(), ""));
    menus.add(menuLogin);
    menus.add(Menu.divider());

    Menu menuPlayer = Menu(3000, Icons.music_note_rounded, "Player");
    menuPlayer.subs.add(Menu.sub(
        3001,
        "Circular Album Music Player",
        CircularAlbumMusicPlayer(
          title: 'Song Title',
          artist: 'Artist Name',
          albumImage: 'assets/images/image_002.png',
        ),
        ""));
    menuPlayer.subs.add(Menu.sub(3002, "Music Player with Lottie Animation",
        MusicPlayerLottieAnimation(), ""));
    menuPlayer.subs.add(Menu.sub(3003, "Music Song List", MusicSongList(), ""));
    menus.add(menuPlayer);
    menus.add(Menu.divider());

    Menu menuNoItem =
        Menu(4000, Icons.do_not_disturb_off_rounded, "Empty State");
    menuNoItem.subs.add(
        Menu.sub(4001, "No Internet - Tap to Retry", NoItemInternetIcon(), ""));
    menuNoItem.subs.add(
        Menu.sub(4002, "No Internet - Image View", NoItemInternetImage(), ""));
    menuNoItem.subs.add(
        Menu.sub(4003, "No Access - Lottie Animation", NoItemAccess(), ""));
    menuNoItem.subs.add(Menu.sub(
        4004, "No Items - Lighthouse Background", NoItemBgLightHouse(), ""));
    menus.add(menuNoItem);
    menus.add(Menu.divider());

    // Profile
    Menu menuProfile = Menu(1900, Icons.person_rounded, "Profile");
    menuProfile.subs
        .add(Menu.sub(1901, "Gradient profile", ProfileGradient(), ""));
    menuProfile.subs
        .add(Menu.sub(1905, "Image appbar profile", ProfileImageAppbar(), ""));
    menus.add(menuProfile);
    menus.add(Menu.divider());

    Menu menuSettings = Menu(2600, Icons.settings_rounded, "Settings");
    menuSettings.subs
        .add(Menu.sub(2602, "Flat settings", SettingsScreen(), ""));
    menuSettings.subs.add(
        Menu.sub(2604, "Light profile settings", SettingProfileLight(), ""));
    menus.add(menuSettings);
    menus.add(Menu.divider());

    // Intro
    Menu intro = Menu(4001, Icons.slideshow_rounded, "App Intro");
    intro.subs.add(Menu.sub(4061, "App Intro with Cards", AppIntroCards(), ""));
    intro.subs.add(Menu.sub(4051, "App Intro Cards with Background Abstract",
        AppIntroCardsBackgroundAbstract(), ""));
    menus.add(intro);
    menus.add(Menu.divider());

    // Cards
    Menu menuCards = Menu(400, Icons.menu_rounded, "Card");
    menuCards.subs.add(Menu.sub(401, "Basic cards", CardBasic(), ""));
    menuCards.subs.add(Menu.sub(407, "Outlined cards", CardOutlined(), ""));
    menuCards.subs.add(Menu.sub(408, "Cards with dividers", CardDivider(), ""));
    menuCards.subs.add(Menu.sub(409, "Expandable cards", CardExpand(), ""));
    menuCards.subs
        .add(Menu.sub(4031, "Destination Overview", DestinationOverview(), ""));
    menus.add(menuCards);
    menus.add(Menu.divider());

    // Article
    Menu menuArticle = Menu(3100, Icons.chrome_reader_mode_rounded, "Article");
    menuArticle.subs.add(Menu.sub(3102, "Medium Article", ArticleMedium(), ""));
    menuArticle.subs
        .add(Menu.sub(3105, "Stepper Article", ArticleStepper(), ""));
    menuArticle.subs.add(Menu.sub(3108, "Review Article", ArticleReview(), ""));
    menus.add(menuArticle);
    menus.add(Menu.divider());

    // About
    Menu menuAbout = Menu(3200, Icons.info_outline_rounded, "About");
    menuAbout.subs
        .add(Menu.sub(405111, "Blurred About Info", AboutOnboarding(), ""));
    menuAbout.subs.add(Menu.sub(3201, "About Card View", AboutApp(), ""));
    menuAbout.subs
        .add(Menu.sub(3203, "Simple About Information", AboutAppSimple(), ""));
    menus.add(menuAbout);
    menus.add(Menu.divider());

    Menu menuSliderImage =
        Menu(2500, Icons.photo_library_rounded, "Slider / Showcase Image");
    menuSliderImage.subs
        .add(Menu.sub(2501, "Header slider image", SliderImageHeader(), ""));
    menuSliderImage.subs.add(Menu.sub(
        2502, "Auto header slider image", SliderImageHeaderAuto(), ""));
    menus.add(menuSliderImage);
    menus.add(Menu.divider());

    Menu menuVerification =
        Menu(2700, Icons.verified_user_rounded, "OTP Verification");
    menuVerification.subs
        .add(Menu.sub(2704, "Image verification", VerificationImage(), ""));
    menuVerification.subs
        .add(Menu.sub(2706, "Green verification", VerificationGreen(), ""));
    menus.add(menuVerification);
    menus.add(Menu.spacer());

    Menu menuTheme = Menu(2800, Icons.settings_rounded, "App Theme");
    menuTheme.subs.add(Menu.sub(2804, "Dark/Light Theme", ThemePage(), ""));
    menus.add(menuTheme);
    menus.add(Menu.spacer());

    // Dashboard
    Menu menuDashboard =
        Menu(3000, Icons.dashboard_customize_rounded, "Dashboard");
    menuDashboard.subs.add(Menu.sub(
        3001,
        "Grid FAB dashboard",
        DashboardGridFab(),
        "A customizable Flutter dashboard featuring dynamic gradients, profile and balance cards, reward points tracking, and detailed travel features including deals and guides with integrated background images."));
    menuDashboard.subs.add(Menu.sub(
        3002,
        "Statistics dashboard",
        DashboardStatistics(),
        "A modern and elegant Flutter dashboard featuring green gradient designs for all charts and statistic cards. Track key metrics such as active users, sales, new signups, and feedback. Visualize data with dynamic line and pie charts, and stay updated with recent activities and user engagement trends."));
    menuDashboard.subs.add(Menu.sub(
        3003,
        "Pay bill dashboard",
        DashboardPayBill(),
        "The Dashboard Pay Bill Route is a comprehensive and user-friendly interface designed to help users manage their bill payments and ticket purchases efficiently. The application offers a range of services including paying for electricity, water, mobile, internet, TV cable, and landline bills, as well as purchasing movie, event, and sport tickets. Users can also manage other services like insurance, rent, and loans. The interface features gradient icons, rounded corners, and a tips section to provide useful information on managing bills effectively. The app is designed with a clean and modern layout, ensuring an excellent user experience."));
    menuDashboard.subs.add(Menu.sub(3004, "Flight dashboard", DashboardFlight(),
        " A seamless flight booking interface with intuitive search, gradient icons, and detailed summaries. Effortlessly find and manage your flights in a clean, modern layout."));
    menuDashboard.subs
        .add(Menu.sub(3005, "Wallet dashboard", DashboardWallet(), ""));
    menus.add(menuDashboard);
    menus.add(Menu.divider());

    // Lists
    Menu menuLists = Menu(900, Icons.view_stream_rounded, "Lists");
    menuLists.subs.add(Menu.sub(901, "Basic lists", ListBasic(), ""));
    menuLists.subs.add(Menu.sub(902, "Sectioned lists", ListSectioned(), ""));
    menuLists.subs.add(Menu.sub(904, "Expandable lists", ListExpand(), ""));
    menuLists.subs.add(Menu.sub(905, "Draggable lists", ListDraggable(), ""));
    menuLists.subs.add(Menu.sub(906, "Swipeable lists", ListSwipe(), ""));
    menuLists.subs
        .add(Menu.sub(907, "Multi-select lists", ListMultiSelection(), ""));
    menuLists.subs.add(Menu.sub(908, "Light news lists", ListNewsLight(), ""));
    menuLists.subs
        .add(Menu.sub(909, "Horizontal news lists", ListNewsLightHrzntl(), ""));
    menuLists.subs.add(Menu.sub(910, "News cards", ListNewsCard(), ""));
    menuLists.subs.add(Menu.sub(911, "Image news lists", ListNewsImage(), ""));
    menus.add(menuLists);
    menus.add(Menu.divider());

    // Bottom Navigation
    Menu menuBottomNavigation =
        Menu(100, Icons.view_column_rounded, "Bottom Navigation");
    menuBottomNavigation.subs.add(
        Menu.sub(101, "Simple bottom navigation", BottomNavigationBasic(), ""));
    menuBottomNavigation.subs.add(Menu.sub(
        102, "Animated shifting tabs", BottomNavigationShifting(), ""));
    menuBottomNavigation.subs.add(Menu.sub(
        108, "Article-style bottom navigation", BottomNavigationArticle(), ""));
    menuBottomNavigation.subs.add(Menu.sub(
        113, "Blinking badge notifications", BottomNavigationBadgeBlink(), ""));
    menus.add(menuBottomNavigation);
    menus.add(Menu.divider());

    // Menu
    Menu menuMenu = Menu(1000, Icons.list_alt_rounded, "Menu");
    menuMenu.subs.add(Menu.sub(1001, "News drawer", MenuDrawerNews(), ""));
    menuMenu.subs.add(Menu.sub(1002, "Mail drawer demo", MenuDrawerMail(), ""));
    menuMenu.subs
        .add(Menu.sub(1006, "Overflow toolbar", MenuOverflowToolbar(), ""));
    menuMenu.subs.add(Menu.sub(1007, "Overflow list", MenuOverflowList(), ""));
    menuMenu.subs.add(Menu.sub(1008, "White drawer", MenuDrawerWhite(),
        "")); // Updated ID to avoid duplication
    menuMenu.subs.add(Menu.sub(1009, "Abstract drawer", MenuDrawerAbstract(),
        "")); // Corrected duplicate ID
    menuMenu.subs.add(Menu.sub(1010, "Navigation drawer with background image",
        MenuDrawerGoGreen(), ""));
    menuMenu.subs.add(Menu.sub(1011, "Filter drawer", MenuDrawerFilter(), ""));
    menuMenu.subs.add(Menu.sub(1012, "Admin drawer", MenuDrawerApp(), ""));
    menus.add(menuMenu);
    menus.add(Menu.divider());

    Menu menuSearch = Menu(2400, Icons.search_rounded, "Search");
    menuSearch.subs
        .add(Menu.sub(2401, "Light search toolbar", SearchToolbarLight(), ""));
    menuSearch.subs.add(Menu.sub(
        2404,
        "Primary search",
        SearchBarWidget(
          categories: [
            'cake',
            'sweets',
            'snacks',
            'Drinks',
            'Burger'
          ], // Provide the categories list
          icon: Icons.search_rounded, // Provide the icon to be used
          onSearch: (query) {
            // Handle the search query
            print("Searching for: $query");
          },
        ),
        ""));
    menuSearch.subs.add(Menu.sub(
        2405, "Primary background search", SearchPrimaryBackground(), ""));
    menus.add(menuSearch);
    menus.add(Menu.divider());

    Menu menuToolbars = Menu(1800, Icons.web_asset_rounded, "Toolbars");
    menuToolbars.subs.add(Menu.sub(1801, "Basic toolbar", ToolbarBasic(), ""));
    menuToolbars.subs
        .add(Menu.sub(1802, "Collapsible toolbar", ToolbarCollapse(), ""));
    menuToolbars.subs.add(Menu.sub(
        1803, "Pinned collapsible toolbar", ToolbarCollapseAndPin(), ""));
    menuToolbars.subs
        .add(Menu.sub(1804, "Light-themed toolbar", ToolbarLight(), ""));
    menuToolbars.subs
        .add(Menu.sub(1806, "Basic bottom toolbar", ToolbarBottomBasic(), ""));
    menuToolbars.subs
        .add(Menu.sub(1807, "FAB bottom toolbar", ToolbarBottomFab(), ""));
    menuToolbars.subs.add(
        Menu.sub(1808, "Scrollable bottom toolbar", ToolbarBottomScroll(), ""));
    menus.add(menuToolbars);
    menus.add(Menu.divider());

    //...........................................................................
    Menu menuMotion = Menu(3600, Icons.timelapse_rounded, "Motion");
    menuMotion.subs
        .add(Menu.sub(3601, "Basic motion pages", MotionPageBasicRoute(), ""));
    menuMotion.subs.add(Menu.sub(3602, "Motion cards", MotionCardRoute(), ""));
    menuMotion.subs.add(Menu.sub(3603, "Motion FABs", MotionFabRoute(), ""));
    menuMotion.subs.add(Menu.sub(3604, "Motion lists", MotionListRoute(), ""));
    menuMotion.subs
        .add(Menu.sub(3606, "Motion FAB view", MotionFabViewRoute(), ""));
    menus.add(menuMotion);
    menus.add(Menu.divider());

    //menus.add(Menu.divider());
    Menu menuForm = Menu(1700, Icons.assignment_rounded, "Form");
    menuForm.subs.add(Menu.sub(1706, "Address form", FormAddress(), ""));
    menuForm.subs.add(Menu.sub(1708, "Ecommerce form", FormEcommerce(), ""));
    menuForm.subs.add(Menu.sub(1707, "Checkout form", FormCheckout(), ""));
    menuForm.subs
        .add(Menu.sub(1710, "Stacked sign-up card", FormSignUpCardStack(), ""));
    menuForm.subs
        .add(Menu.sub(1712, "Image sign-up form", FormSignUpImage(), ""));
    menuForm.subs.add(
        Menu.sub(1714, "Outlined image sign-up", FormSignUpImageOutline(), ""));
    menus.add(menuForm);
    menus.add(Menu.divider());

    Menu menuPayment = Menu(2900, Icons.payments_rounded, "Payment");
    menuPayment.subs
        .add(Menu.sub(2902, "Card details", PaymentCardDetails(), ""));
    menuPayment.subs.add(Menu.sub(2903, "Payment form", PaymentForm(), ""));
    menuPayment.subs
        .add(Menu.sub(2904, "Payment profile", PaymentProfile(), ""));
    menus.add(menuPayment);
    menus.add(Menu.divider());

    // Buttons
    Menu menuButtons = Menu(300, Icons.touch_app_rounded, "Buttons");
    menuButtons.subs
        .add(Menu.sub(303, "Middle FAB button", ButtonFabMiddle(), ""));
    menuButtons.subs
        .add(Menu.sub(305, "FAB with text", ButtonFabMoreText(), ""));
    menuButtons.subs
        .add(Menu.sub(309, "High emphasis buttons", ButtonHighEmphasis(), ""));
    menuButtons.subs
        .add(Menu.sub(311, "Text label buttons", ButtonTextLabel(), ""));
    menus.add(menuButtons);
    menus.add(Menu.divider());

    // Expand
    Menu menuExpand = Menu(700, Icons.expand_circle_down_rounded, "Expand");
    menuExpand.subs.add(Menu.sub(701, "Basic expand", ExpandablePanels(), ""));
    menuExpand.subs
        .add(Menu.sub(702, "Expandable invoice", ExpandInvoice(), ""));
    menuExpand.subs.add(Menu.sub(703, "Expandable ticket", ExpandTicket(), ""));
    menus.add(menuExpand);
    menus.add(Menu.divider());

    // Timeline
    Menu menuTimeline = Menu(2200, Icons.wrap_text_rounded, "Timeline");
    menuTimeline.subs.add(Menu.sub(2201, "Timeline feed", TimelineFeed(), ""));
    menuTimeline.subs.add(Menu.sub(2202, "Timeline path", TimelinePath(), ""));
    menuTimeline.subs
        .add(Menu.sub(2203, "Dot card timeline", TimelineDotCard(), ""));
    menuTimeline.subs
        .add(Menu.sub(2204, "Twitter timeline", TimelineTwitter(), ""));
    menuTimeline.subs
        .add(Menu.sub(2206, "Explore timeline", TimelineExplore(), ""));
    menus.add(menuTimeline);
    menus.add(Menu.divider());

    Menu menuBottomSheet =
        Menu(200, Icons.call_to_action_rounded, "Bottom Sheet");
    menuBottomSheet.subs
        .add(Menu.sub(201, "Basic bottom sheet", BottomSheetBasic(), ""));
    menuBottomSheet.subs
        .add(Menu.sub(202, "List style bottom sheet", BottomSheetList(), ""));
    menuBottomSheet.subs.add(Menu.sub(
        203, "FAB-triggered bottom sheet", BottomSheetFabAppSetting(), ""));
    menuBottomSheet.subs.add(Menu.sub(
        204, "Floating bottom sheet", BottomSheetFloatingAppRating(), ""));
    menuBottomSheet.subs
        .add(Menu.sub(205, "Menu bottom sheet", BottomSheetMenu(), ""));
    menuBottomSheet.subs
        .add(Menu.sub(206, "Filter bottom sheet", BottomSheetFilter(), ""));
    menuBottomSheet.subs
        .add(Menu.sub(207, "Player bottom sheet", BottomSheetPlayer(), ""));
    menuBottomSheet.subs
        .add(Menu.sub(208, "Expandable bottom sheet", BottomSheetExpand(), ""));
    menus.add(menuBottomSheet);
    menus.add(Menu.divider());

    Menu menuSideSheet =
        Menu(3400, Icons.space_dashboard_rounded, "Side Sheet");
    menuSideSheet.subs
        .add(Menu.sub(3401, "Side sheet - Filter", SideSheetBasicRoute(), ""));
    menus.add(menuSideSheet);
    menus.add(Menu.divider());

    Menu menuBackdrop = Menu(3500, Icons.receipt_long_rounded, "Backdrop");
    menuBackdrop.subs
        .add(Menu.sub(3501, "Basic backdrop", BackdropBasic(), ""));
    menuBackdrop.subs
        .add(Menu.sub(3502, "Backdrop with filter", BackdropFilterBy(), ""));
    menuBackdrop.subs.add(Menu.sub(
        3503, "Mail Navigation backdrop", BackdropNavigationMail(), ""));
    menuBackdrop.subs
        .add(Menu.sub(3504, "Backdrop with steppers", BackdropStepper(), ""));
    menuBackdrop.subs.add(
        Menu.sub(3505, "Backdrop with text fields", BackdropTextField(), ""));
    menuBackdrop.subs
        .add(Menu.sub(3506, "Selection backdrop", BackdropAppSettings(), ""));
    menus.add(menuBackdrop);
    menus.add(Menu.divider());

    Menu menuChips = Menu(500, Icons.label_rounded, "Chips");
    menuChips.subs.add(Menu.sub(503, "Grouped chips", DiverseChipGroup(), ""));
    menuChips.subs.add(Menu.sub(504, "Input chips", ChipInput(), ""));
    menuChips.subs.add(Menu.sub(505, "Choice chips", ChipChoice(), ""));
    menuChips.subs.add(Menu.sub(507, "Action chips", ChipAction(), ""));
    menus.add(menuChips);
    menus.add(Menu.divider());

    Menu menuPickers = Menu(1100, Icons.event_rounded, "Pickers");
    menuPickers.subs
        .add(Menu.sub(1101, "Light date picker", PickerDateLight(), ""));
    menuPickers.subs
        .add(Menu.sub(1102, "Light time picker", PickerTimeLight(), ""));
    menus.add(menuPickers);
    menus.add(Menu.divider());

    Menu menuBanner = Menu(1400, Icons.picture_in_picture_rounded, "Banner");
    menuBanner.subs.add(Menu.sub(1403, "Pinned banner", BannerPin(), ""));
    menuBanner.subs
        .add(Menu.sub(1404, "Small info banner", BannerSmallInfo(), ""));
    menuBanner.subs.add(Menu.sub(1405, "White banner", BannerWhite(), ""));
    menus.add(menuBanner);
    menus.add(Menu.divider());

    Menu menuSnackbarsToasts =
        Menu(1400, Icons.wb_iridescent_rounded, "Snackbars & Toasts");
    menuSnackbarsToasts.subs
        .add(Menu.sub(1401, "Basic snackbar", ToastSnackbarBasicRoute(), ""));
    menuSnackbarsToasts.subs
        .add(Menu.sub(1402, "Lift FAB snackbar", SnackbarLiftFabRoute(), ""));
    menuSnackbarsToasts.subs
        .add(Menu.sub(1403, "Custom toast", ToastCustomRoute(), ""));
    menuSnackbarsToasts.subs
        .add(Menu.sub(1404, "Custom snackbar", SnackbarCustomRoute(), ""));
    menus.add(menuSnackbarsToasts);
    menus.add(Menu.divider());

    Menu menuProgress =
        Menu(1200, Icons.settings_backup_restore_rounded, "Progress");
    menuProgress.subs
        .add(Menu.sub(1201, "Basic progress", ProgressBasic(), ""));
    menuProgress.subs
        .add(Menu.sub(1203, "Linear top progress", ProgressLinearTop(), ""));
    menuProgress.subs.add(
        Menu.sub(1206, "Pull-to-refresh progress", ProgressPullRefresh(), ""));
    menus.add(menuProgress);
    menus.add(Menu.divider());

    Menu menuSeekbar = Menu(1300, Icons.tune_rounded, "Slider");
    menuSeekbar.subs.add(Menu.sub(1301, "Basic seekbar", SeekbarBasic(), ""));
    menuSeekbar.subs.add(Menu.sub(1304, "Range seekbar", SeekbarRange(), ""));
    menuSeekbar.subs
        .add(Menu.sub(1305, "Flight filter seekbar", CartFilterDemo(), ""));
    menus.add(menuSeekbar);
    menus.add(Menu.divider());

    Menu menuSteppers = Menu(1500, Icons.timeline_rounded, "Steppers");
    menuSteppers.subs.add(
        Menu.sub(1504, "Light wizard steppers", SteppersWizardLight(), ""));
    menuSteppers.subs.add(
        Menu.sub(1505, "Color wizard steppers", SteppersWizardColor(), ""));
    menus.add(menuSteppers);
    menus.add(Menu.divider());

    Menu menuTabs = Menu(1600, Icons.tab_rounded, "Tabs");
    menuTabs.subs.add(Menu.sub(1601, "Basic tabs", TabsBasicRoute(), ""));
    menuTabs.subs.add(Menu.sub(1602, "Store tabs", TabsStoreRoute(), ""));
    menuTabs.subs.add(Menu.sub(1605, "Icon tabs", TabsIconRoute(), ""));
    menuTabs.subs
        .add(Menu.sub(1606, "Text and icon tabs", TabsTextIconRoute(), ""));
    menuTabs.subs
        .add(Menu.sub(1607, "Light icon tabs", TabsIconLightRoute(), ""));
    menuTabs.subs.add(Menu.sub(1608, "Scrollable tabs", TabsScrollRoute(), ""));
    menuTabs.subs.add(Menu.sub(1609, "Round tabs", TabsRoundRoute(), ""));
    menuTabs.subs
        .add(Menu.sub(1610, "Simple light tabs", TabsSimpleLightRoute(), ""));
    menuTabs.subs
        .add(Menu.sub(1611, "Simple blue tabs", TabsSimpleBlueRoute(), ""));
    menuTabs.subs
        .add(Menu.sub(1612, "Product tabs", TabsSimpleProductRoute(), ""));
    menus.add(menuTabs);
    menus.add(Menu.divider());
  }

  Widget buildDrawer() {
    return Drawer(
      child: Container(
        padding: EdgeInsets.all(20),
        color: MyColors.grey_95,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(height: 10),
              Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(vertical: 30),
                child: Image.asset(Img.get('logo_f.png'),
                    color: MyColors.grey_20, width: 60, height: 60),
              ),
              Text("FlutterUiX",
                  style: MyText.title(context)!.copyWith(
                      color: Colors.white, fontWeight: FontWeight.w500)),
              Container(height: 5),
              Divider(color: Colors.white),
              buildMenuDrawer("Notification", () {}),
              buildMenuDrawer("Other Apps", () {
                Tools.directUrl(
                    "https://codecanyon.net/user/boltuix/portfolio");
              }),
              buildMenuDrawer("Rate This App", () {
                Tools.directUrl(
                    "https://codecanyon.net/user/boltuix/portfolio");
              }),
              buildMenuDrawer("About", () {
                showDialog(
                    context: context, builder: (_) => DialogAboutRoute());
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildMenuDrawer(String title, Function onTap) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        highlightColor: Colors.black.withOpacity(0.5),
        hoverColor: Colors.black.withOpacity(0.5),
        onTap: onTap as void Function()?,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 15),
          width: double.infinity,
          child: Text(title,
              style: MyText.subhead(context)!
                  .copyWith(color: Colors.white, fontWeight: FontWeight.w500)),
        ),
      ),
    );
  }
}
