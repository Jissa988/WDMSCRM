import 'package:customer_portal/models/homeModel.dart';
import 'package:customer_portal/outstanding/outstanding.dart';
import 'package:customer_portal/outstanding/outstandingList.dart';
import 'package:customer_portal/config/themes.dart';
import 'package:customer_portal/custodyDetails/custodyDetails.dart';
import 'package:customer_portal/home/bottomNavigation.dart';
import 'package:customer_portal/sales/salesList.dart';
import 'package:customer_portal/viewModels/home_provider.dart';
import 'package:customer_portal/viewModels/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:popover/popover.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/routes.dart';
import '../constant/constants.dart';
import '../coupon/couponListPage.dart';
import '../login/loginScreen.dart';
import '../outstanding/collectionDetails.dart';
import '../sales/salesDetails.dart';
import '../viewModels/notification_provider.dart';
import '../customised/popUp/customPopup.dart';
import '../viewModels/registeration_provider.dart';
import 'greenAnimationWave.dart';
import 'redanimationWave.dart';
import 'headerDrawer.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HomeProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => RegisterProvider()),

        // Add other providers if needed
      ],
      child: MaterialApp(
        title: 'Your App',
        home: _HomePage(),
      ),
    );
  }
}

class _HomePage extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<_HomePage> {
  final logger = Logger();
  late HomeProvider homeProvider;
  late RegisterProvider registerProvider;

  // late NotificationDataProvider notificationDataProvider;

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _token = "";
  CustomerAccouts?
      _selectedCustomerAccount; // Define a variable to store the selected customer account

  @override
  void initState() {
    super.initState();
    print('initState--');
    homeProvider = Provider.of<HomeProvider>(context, listen: false);
    registerProvider = Provider.of<RegisterProvider>(context, listen: false);
    // notificationDataProvider = Provider.of<NotificationDataProvider>(context, listen: false);
    getSharedPreference();
  }

  Future<void> getSharedPreference() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        _token = prefs.getString(Constants.API_TOKEN) ?? "";
        navigateBasedOnNotificationType();
      });

      // Do not call _fetchCustomerAccounts here, because the HomeProvider instance is not initialized yet.
    } catch (e) {
      // Handle errors
      print('Error fetching shared preferences: $e');
    }
  }

  void updateSelectedCustomerAccount(CustomerAccouts? selectedAccount) {
    setState(() {
      _selectedCustomerAccount = selectedAccount;
    });
  }

  void navigateBasedOnNotificationType() {
    final notificationDataProvider =
        Provider.of<NotificationDataProvider>(context, listen: false);
    final notificationData = notificationDataProvider.notificationData.data;
    print('navigateBasedOnNotificationType--build--$notificationData');
    if (notificationData.isNotEmpty) {
      final int notificationId = int.parse(notificationData['NotificationId']);
      print('notificationId-build--$notificationId');
      final String notificationType = notificationData['NotificationType'];
      print('notificationType-build--$notificationType');
      final int customerId = int.parse(notificationData['CustomerId']);
      print('customerId-build--$customerId');
      final int notificationheadId = int.parse(notificationData['NewRecId']);
      print('notificationheadId-build--$notificationheadId');

      final int finYearId = int.parse(notificationData['FinYearId']);
      print('finYearId-build--$finYearId');

      final int typeId = int.parse(notificationData['TypeId']);
      print('notificationheadId-build--$typeId');

      homeProvider.notificationSeenUpdation(_token, notificationId).then((_) {
        print('status--notificationSeenUpdation-${homeProvider.status}');
        print('msg--notificationSeenUpdation-${homeProvider.msg}');

        if (homeProvider.status == 1) {
          if (notificationType == "CV") {
            print('notificationheadId-build--CollectionDetails');
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CollectionDetails(),
                settings: RouteSettings(
                  arguments: {
                    'voucherId': notificationheadId,
                    'finyearId': finYearId,
                    'typeId': typeId
                  },
                ),
              ),
            );
          } else if (notificationType == "SI") {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SalesDetails(),
                settings: RouteSettings(
                  arguments: {
                    'salesInvoiceId': notificationheadId,
                    'headType': 'Sale'
                  },
                ),
              ),
            );
          } else if (notificationType == "DO") {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SalesDetails(),
                settings: RouteSettings(
                  arguments: {
                    'salesInvoiceId': notificationheadId,
                    'headType': 'Do'
                  },
                ),
              ),
            );
          }
        } else {
          print("message--" + homeProvider.msg);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "${homeProvider.msg}",
                style: TextStyle(fontFamily: 'Metropolis'),
              ),
              duration: Duration(seconds: 2),
              backgroundColor: Colors.red[700],
            ),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      // Add the key here
      appBar: CustomAppBar(
        scaffoldKey: _scaffoldKey,
        homeProvider: homeProvider,
        registerProvider: registerProvider,
        token: _token,
        selectedCustomerAccount: _selectedCustomerAccount,
        onCustomerAccountChanged: updateSelectedCustomerAccount,
      ),
      drawer: Consumer<HomeProvider>(
        builder: (context, homeProvider, _) {
          // Your UI code here
          return MyHeaderDrawer(
            fileName: homeProvider.homeEmployeeDetails.isNotEmpty
                ? homeProvider.homeEmployeeDetails[0].fileName ?? ''
                : '',
            customerName: homeProvider.homeEmployeeDetails.isNotEmpty
                ? homeProvider.homeEmployeeDetails[0].customerName ?? ''
                : '',
          );
        },
      ),

      body: BodyContainer(
        homeProvider: homeProvider,
        token: _token,
        selectedCustomerAccount:
        _selectedCustomerAccount, // Pass the selected customer account to BodyContainer
      ),
      bottomNavigationBar: BottomNavigationMenu(2),
    );
  }
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final HomeProvider homeProvider;
  final RegisterProvider registerProvider;

  String token = "";
  final Function(CustomerAccouts?)
      onCustomerAccountChanged; // Define the callback function
  CustomerAccouts?
      selectedCustomerAccount; // Define a variable to store the selected customer account

  CustomAppBar({
    required this.scaffoldKey,
    required this.homeProvider,
    required this.registerProvider,
    required this.token,
    required this.onCustomerAccountChanged,
    this.selectedCustomerAccount,
  });

  void handleCustomerAccountChange(CustomerAccouts? selectedAccount) {
    // Call the callback function and pass the selected account
    onCustomerAccountChanged(selectedAccount);
  }

  void showNotificationMenu(BuildContext context,
      List<UnSeenNotification> items, Offset targetPosition) {
    // Build the list of menu items
    List<PopupMenuEntry<UnSeenNotification>> menuItems = items.map((item) {
      return PopupMenuItem<UnSeenNotification>(
        value: item,
        child: ListTile(
          horizontalTitleGap: 0,
          dense: true,
          contentPadding: EdgeInsets.zero,
          title: Text(
            '${item.transactionDocNo}',
            style: TextStyle(
              fontFamily: 'Metropolis',
              fontSize: 14,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
              color: AppColors.theme_color,
            ),
          ),
        ),
      );
    }).toList();

    // Show the popup menu anchored to the given position
    showMenu<UnSeenNotification>(
      context: context,
      color: AppColors.white,
      position: RelativeRect.fromLTRB(
        targetPosition.dx,
        targetPosition.dy,
        targetPosition.dx + 1,
        targetPosition.dy + 1,
      ),
      items: menuItems,
      elevation: 8.0,
    ).then((selectedItem) {
      if (selectedItem != null) {
        // Dismiss the menu
        handleNotificationTap(context, selectedItem);
        // Navigator.pop(context);
      }
    });
  }

  void handleNotificationTap(BuildContext context, UnSeenNotification item) {
    homeProvider.notificationSeenUpdation(token, item.notificationId).then((_) {
      print("handleNotificationTap---${homeProvider.status}");

      if (homeProvider.status == 1) {
        print("handleNotificationTap---${item.notificationType}");
        try {
          print("handleNotificationTap---try");
          if (item.notificationType.toString() == "CV") {
            print("handleNotificationTap-1--${item.notificationType}");
            navigateToCollectionDetails(context, item);
          } else if (item.notificationType == "SI" ||
              item.notificationType == "DO") {
            print("handleNotificationTap-2--${item.notificationType}");
            navigateToSalesDetails(context, item);
          }
        } catch (e) {
          print("handleNotificationTap---catch--$e");
        }
      } else {
        print("Error: ${homeProvider.msg}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "${homeProvider.msg}",
              style: TextStyle(fontFamily: 'Metropolis'),
            ),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.red[700],
          ),
        );
        // Handle error (e.g., show a snackbar)
      }
    });
  }

  void navigateToCollectionDetails(
      BuildContext context, UnSeenNotification item) {
    print('navigateToCollectionDetails');
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CollectionDetails(),
        settings: RouteSettings(
          arguments: {
            'voucherId': item.transactionHeadId,
            'finyearId': item.finYearId,
            'typeId': item.typeid
          },
        ),
      ),
    );
  }

  void navigateToSalesDetails(BuildContext context, UnSeenNotification item) {
    print('navigateToSalesDetails');

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SalesDetails(),
        settings: RouteSettings(
          arguments: {
            'salesInvoiceId': item.transactionHeadId,
            'headType': item.notificationType == "SI" ? 'Sale' : 'Do',
          },
        ),
      ),
    );
  }

  void fetchNotificationsAndShowMenu(BuildContext context) async {
    try {
      List<UnSeenNotification> items =
          await homeProvider.fetchUnSeenNotifications(
        token,
        homeProvider.selected_customerAccounts!.customerId,
      );
      RenderBox renderBox = context.findRenderObject() as RenderBox;
      Offset targetPosition = renderBox.localToGlobal(Offset.zero);
      // Adjust the target position to align the right edge of the icon
      targetPosition = Offset(targetPosition.dx + renderBox.size.width,
          targetPosition.dy + renderBox.size.height);

      // Pass the position to the showNotificationMenu function
      showNotificationMenu(context, items, targetPosition);
      // showNotificationMenu(context, items);
    } catch (e) {
      print('Error fetching notifications: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "${homeProvider.msg}",
            style: TextStyle(fontFamily: 'Metropolis'),
          ),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.red[700],
        ),
      );
    }
  }

  bool _isfirstTime = true;

  @override
  Widget build(BuildContext context) {
    print(
        'Selected accouts BuildContext=${homeProvider
            .selected_customerAccounts}');

    return FutureBuilder(
        future: homeProvider.fetchCustomerAccounts(token),
        // Assuming fetchCustomerAccounts returns a Future
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show loading indicator while fetching data
            return Center(
              child: Container(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: AppColors.theme_color,
                  strokeWidth: 2, // Adjust the size as needed
                ),
              ),
            );
          } else if (snapshot.hasError) {
            // Show error message if fetching data fails
            if (snapshot.error.toString().contains('Network is unreachable')) {
              return Container(
                  color: AppColors.white,
                  child: Center(
                child: Text(''),),
              );
            }
            // Show generic error message if fetching data fails
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            print(
                'Selected accouts BuildContext1=${homeProvider
                    .selected_customerAccounts?.customerId}');



            if (homeProvider.selected_customerAccounts == null &&
                _isfirstTime == true) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                homeProvider.selected_customerAccounts =
                    homeProvider.customerAccounts.first;
                handleCustomerAccountChange(
                    homeProvider.selected_customerAccounts);
                _isfirstTime = false;
              });
            }
            if (homeProvider.customerAccounts.isNotEmpty) {
              return Container(
                padding: EdgeInsets.all(10.0),
                color: Colors.white,
                child: AppBar(
                  backgroundColor: Colors.white,
                  elevation: 0,
                  leading: IconButton(
                    icon: Icon(
                      Icons.menu,
                      color: AppColors.theme_color,
                      size: 25,
                    ),
                    onPressed: () {
                      final scaffoldState = scaffoldKey.currentState;
                      if (scaffoldState != null) {
                        scaffoldState.openDrawer(); // Open the drawer
                      }
                    },
                  ),
                  title: Container(
                    padding: EdgeInsets.all(5),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<int>(
                        isExpanded: true,
                        value:
                        homeProvider.selected_customerAccounts?.customerId,
                        onChanged: (newValue) {
                          // Find the corresponding CustomerAccouts object based on the newValue
                          CustomerAccouts? selectedAccount =
                          homeProvider.customerAccounts.firstWhere(
                                (customerAccount) =>
                            customerAccount.customerId == newValue,
                            orElse: () =>
                                CustomerAccouts(-1,
                                    'Default'), // Default object when no match is found
                          );
                          homeProvider.selected_customerAccounts =
                              selectedAccount;
                          handleCustomerAccountChange(selectedAccount);
                        },
                        items: homeProvider.customerAccounts
                            .map((customerAccount) {
                          return DropdownMenuItem<int>(
                            value: customerAccount.customerId,
                            child: Text(customerAccount.customerName),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  actions: [
                    Stack(
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.notifications_rounded,
                            color: AppColors.theme_color,
                            size: 25,
                          ),
                          onPressed: () {
                            if (homeProvider.homeEmployeeDetails.isNotEmpty &&
                                homeProvider.homeEmployeeDetails[0]
                                    .notificationCount >
                                    0) {
                              fetchNotificationsAndShowMenu(context);
                            }
                          },
                        ),
                        homeProvider.homeEmployeeDetails.isNotEmpty &&
                            homeProvider.homeEmployeeDetails[0]
                                .notificationCount >
                                0
                            ? Positioned(
                          right: 10,
                          top: 2,
                          child: Container(
                            padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: AppColors.bs_teal,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              '${homeProvider.homeEmployeeDetails[0]
                                  .notificationCount}',
                              style: TextStyle(
                                color: AppColors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        )
                            : SizedBox(),
                        // Or you can replace `SizedBox()` with `null` if the widget should not be rendered when the condition is not met
                      ],
                    ),
                  ],
                ),
              );
            } else {
              handleLogout(context);
              return Container();

            }
          }
        });


  }
  Future<void> handleLogout(BuildContext context) async {
    print("handleLogout--");
    final logger = Logger();


    try {
      await registerProvider.logout(token).then((_) {
        print(registerProvider.log_status);
        print("message--" + registerProvider.msg);
        if (registerProvider.log_status == 1) {
          print("message--" + registerProvider.msg);

          SharedPreferences.getInstance().then((prefs) {
            prefs.remove(Constants.API_TOKEN);


            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => LoginScreen(),

              ),
            );
          });
        } else {
          // Show login failure message
          print("message--" + registerProvider.msg);



        }
      });
    } catch (e) {
      // Handle errors
      logger.e("Error logout: $e");
    }
  }
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class BodyContainer extends StatelessWidget {
  final HomeProvider homeProvider;
  String token = "";
  final CustomerAccouts?
      selectedCustomerAccount; // Receive the selected customer account

  BodyContainer({
    required this.homeProvider,
    required this.token,
    required this.selectedCustomerAccount,
  });

  @override
  Widget build(BuildContext context) {
    print(
        'home details=selected_customerAccounts${homeProvider.selected_customerAccounts?.customerId}');

    return FutureBuilder(
        future: homeProvider.getHome(
            token, selectedCustomerAccount?.customerId ?? 0),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Container(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: AppColors.theme_color,
                  strokeWidth: 2, // Adjust the size as needed
                ),
              ),
            );
          } else if (snapshot.hasError) {
            if (snapshot.error.toString().contains('Network is unreachable')) {
               return Container(
                   color: AppColors.white,
                child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(padding: EdgeInsets.only(right: 25,left: 25,bottom:15 ),child:
                    Image.asset(
                      'assets/quickAlerts/lightbulb.gif',
                      // width: 500,
                      // height: 100,
                    ),
                    ),
                    Flexible(child:
                        Padding(padding: EdgeInsets.all(10.0), child:
                        Text(
                          'Network is unreachable ,Please check your internet connection',
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'Metropolis',
                            color: AppColors.theme_color,
                            fontWeight: FontWeight.bold,
                          ),
                        ),  )
                   ),
                  ],
                ),
              ),);
            }
            // Show generic error message if fetching data fails
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            if (homeProvider.homeEmployeeDetails.isNotEmpty) {
              print(
                  'home details=${homeProvider.homeEmployeeDetails[0].customerId}');

              return LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  return SingleChildScrollView(
                    child: Container(
                      color: AppColors.background.withOpacity(0.1),
                      padding: EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.all(9.0),
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                  color: AppColors.theme_color, width: 0.5),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Image.asset(
                                      'assets/home/user.png',
                                      width: 20,
                                      height: 20,
                                      color: AppColors.theme_color,
                                    ),
                                    SizedBox(width: 10),
                                    Flexible(
                                      child: Text(
                                        "${homeProvider.homeEmployeeDetails[0].customerName}",
                                        style: TextStyle(
                                          color: AppColors.bs_teal,
                                          fontSize: 18,
                                          fontFamily: 'Metropolis',
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                Row(
                                  children: [
                                    Image.asset('assets/home/location.png',
                                        width: 20,
                                        height: 20,
                                        color: AppColors.theme_color),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Flexible(
                                      child: Text(
                                        "${homeProvider.homeEmployeeDetails[0].route} - ${homeProvider.homeEmployeeDetails[0].area}",
                                        style: TextStyle(
                                          color: AppColors.black,
                                          fontSize: 16,
                                          fontFamily: 'Metropolis',
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    Image.asset(
                                        'assets/home/payment_method.png',
                                        width: 20,
                                        height: 20,
                                        color: AppColors.theme_color),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Flexible(
                                      child: Text(
                                        "${homeProvider.homeEmployeeDetails[0].paymentTerm}",
                                        style: TextStyle(
                                          color: AppColors.black,
                                          fontSize: 14,
                                          fontFamily: 'Metropolis',
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 8),
                            padding: EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              border: Border.all(
                                  color: AppColors.theme_color, width: 0.5),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Wrap(
                                  children: [
                                    Row(
                                      children: [
                                        Image.asset(
                                          'assets/home/outstanding.png',
                                          width: constraints.maxWidth * 0.1,
                                          height: constraints.maxWidth * 0.1,
                                          color: AppColors.theme_color,
                                        ),
                                        SizedBox(width: 10),
                                        Container(
                                          width: 0.5,
                                          height: 30,
                                          color: AppColors.theme_color,
                                        ),
                                        SizedBox(width: 10),
                                        Flexible(
                                          child: Text(
                                            'Outstanding Amount ',
                                            style: TextStyle(
                                              fontFamily: 'Metropolis',
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                              color: AppColors.black,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Align(
                                            alignment: Alignment.centerRight,
                                            child: Text(
                                              '${homeProvider.homeEmployeeDetails[0].totalOutstanding} AED',
                                              style: TextStyle(
                                                fontFamily: 'Metropolis',
                                                fontSize: 22,
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.theme_color,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),

                                // SizedBox(height: 2),
                                Divider(
                                  thickness: 0.5,
                                  // Adjust the width of the line
                                  height: 30,
                                  // Adjust the height of the line
                                  color: AppColors.theme_color,
                                ),

                                // This is where you missed the Row widget
                                Wrap(
                                  alignment: WrapAlignment.center,
                                  // Aligns children at the center
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                          child: Text(
                                            'Last Purchase On  ',
                                            style: TextStyle(
                                              fontFamily: 'Metropolis',
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              fontStyle: FontStyle.italic,
                                              color: AppColors.lightGray,
                                            ),
                                          ),
                                        ),
                                        Flexible(
                                          child: Text(
                                            '${homeProvider.homeEmployeeDetails[0].paymentTerm == 'DO' ? '${homeProvider.homeEmployeeDetails[0].lastDodateTime}' : '${homeProvider.homeEmployeeDetails[0].lastSaleDateTime}'}',
                                            style: TextStyle(
                                              fontFamily: 'Metropolis',
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                              color: AppColors.black,
                                            ),
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        SalesList(),
                                                    settings: RouteSettings(
                                                      arguments: {
                                                        'homeDetails': homeProvider
                                                            .homeEmployeeDetails[0]
                                                      },
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 8, vertical: 4),
                                                decoration: BoxDecoration(
                                                  color: AppColors.theme_color,
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                child: Image.asset(
                                                  'assets/home/sales.png',
                                                  width: 20,
                                                  height: 20,
                                                  color: AppColors.white,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        Outstanding(),
                                                    settings: RouteSettings(
                                                      arguments: {
                                                        'homeDetails': homeProvider
                                                            .homeEmployeeDetails[0]
                                                      },
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 8, vertical: 4),
                                                decoration: BoxDecoration(
                                                  color: AppColors.theme_color,
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                child: Image.asset(
                                                  'assets/home/collection.png',
                                                  width: 20,
                                                  height: 20,
                                                  color: AppColors.white,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 9),
                            padding: EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              border: Border.all(
                                  color: AppColors.theme_color, width: 0.5),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Wrap(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                          child: Row(
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  color: AppColors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                ),
                                                child: Image.asset(
                                                    'assets/home/custody_details.png',
                                                    width:
                                                        constraints.maxWidth *
                                                            0.1,
                                                    height:
                                                        constraints.maxWidth *
                                                            0.1,
                                                    color:
                                                        AppColors.theme_color),
                                              ),
                                              SizedBox(width: 10),
                                              Container(
                                                width: 0.5,
                                                // Adjust the width of the line
                                                height: 30,
                                                // Adjust the height of the line
                                                color: AppColors.theme_color,
                                              ),
                                              SizedBox(width: 10),
                                              Flexible(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Custody Details',
                                                      style: TextStyle(
                                                        fontFamily:
                                                            'Metropolis',
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: AppColors.black,
                                                      ),
                                                    ),
                                                    Text(
                                                      '${homeProvider.homeEmployeeDetails[0].totalCustodyAmount} AED',
                                                      style: TextStyle(
                                                        fontFamily:
                                                            'Metropolis',
                                                        fontSize: 22,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: AppColors
                                                            .theme_color,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    CustodyDetails(),
                                                settings: RouteSettings(
                                                  arguments: {
                                                    'homeDetails': homeProvider
                                                        .homeEmployeeDetails[0]
                                                  },
                                                ),
                                              ),
                                            );

                                            // Navigator.pushNamed(
                                            //     context,
                                            //     CustomerPortalRoutes
                                            //         .custodyDetails);
                                          },
                                          child: Container(
                                            width: 35,
                                            height: 35,
                                            decoration: BoxDecoration(
                                              color: AppColors.theme_color,
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: AppColors.white,
                                                  blurRadius: 14,
                                                  offset: Offset(0, 4),
                                                ),
                                              ],
                                            ),
                                            child: Icon(
                                              Icons.arrow_forward,
                                              color: Colors.white,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(height: 5),
                                    Divider(
                                      thickness: 0.5,
                                      // Adjust the width of the line
                                      height: 30,
                                      // Adjust the height of the line
                                      color: AppColors.theme_color,
                                    ),
                                    ListView(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      children: [
                                        Row(
                                          children: [
                                            SaleTimingBox(
                                              title: 'Bottle ',
                                              subtitile: 'Custody',
                                              amount:
                                                  '${homeProvider.homeEmployeeDetails[0].bottleCustody}',
                                              imagePath:
                                                  'assets/home/bottle_custody.png',
                                            ),
                                            Spacer(),
                                            Container(
                                              width: 0.5,
                                              // Adjust the width of the line
                                              height: 50,
                                              // Adjust the height of the line
                                              color: AppColors.theme_color,
                                            ),
                                            Spacer(),
                                            SaleTimingBox(
                                              title: 'Dispenser',
                                              subtitile: '',
                                              amount:
                                                  '${homeProvider.homeEmployeeDetails[0].totalDispenser}',
                                              imagePath:
                                                  'assets/home/dispenser.png',
                                            ),
                                            Spacer(),
                                            Container(
                                              width: 0.5,
                                              // Adjust the width of the line
                                              height: 50,
                                              // Adjust the height of the line
                                              color: AppColors.theme_color,
                                            ),
                                            Spacer(),
                                            SaleTimingBox(
                                              title: 'Temp ',
                                              subtitile: 'Bottle',
                                              amount:
                                                  '${homeProvider.homeEmployeeDetails[0].tempBottle}',
                                              imagePath:
                                                  'assets/home/temp_bottle.png',
                                            ),
                                            Spacer(),
                                            Container(
                                              width: 0.5,
                                              // Adjust the width of the line
                                              height: 50,
                                              // Adjust the height of the line
                                              color: AppColors.theme_color,
                                            ),
                                            Spacer(),
                                            SaleTimingBox(
                                              title: 'Others',
                                              subtitile: '',
                                              amount:
                                                  '${homeProvider.homeEmployeeDetails[0].totalOthers}',
                                              imagePath:
                                                  'assets/home/others.png',
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 9, bottom: 9),
                            padding: EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: AppColors.theme_color),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.04),
                                  spreadRadius: 0,
                                  blurRadius: 12,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                InkWell(
                                  onTap: () {
                                    // Handle tap
                                  },
                                  child: Container(
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                          child: Row(
                                            children: [

                                              Image.asset(
                                                  'assets/home/available_coupon.png',
                                                  width: constraints.maxWidth *
                                                      0.1,
                                                  height: constraints.maxWidth *
                                                      0.1,
                                                  color: AppColors.theme_color),
                                              // ),
                                              SizedBox(width: 8),
                                              Container(
                                                width: 0.5,
                                                // Adjust the width of the line
                                                height: 30,
                                                // Adjust the height of the line
                                                color: AppColors.theme_color,
                                              ),
                                              SizedBox(width: 10),
                                              Flexible(
                                                child: Column(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Available Coupon Book',
                                                      style: TextStyle(
                                                        fontFamily:
                                                        'Metropolis',
                                                        fontSize: 16,
                                                        fontWeight:
                                                        FontWeight.w500,
                                                        color: AppColors.black,
                                                      ),
                                                    ),
                                                    Text(
                                                      '${homeProvider.homeEmployeeDetails[0].totalAvailableCouponCount}',
                                                      style: TextStyle(
                                                        fontFamily:
                                                        'Metropolis',
                                                        fontSize: 22,
                                                        fontWeight:
                                                        FontWeight.bold,
                                                        color: AppColors
                                                            .theme_color,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    CouponListPage(),
                                                settings: RouteSettings(
                                                  arguments: {
                                                    'homeDetails': homeProvider
                                                        .homeEmployeeDetails[0]
                                                  },
                                                ),
                                              ),
                                            );

                                            // Navigator.pushNamed(context,
                                            //     CustomerPortalRoutes.couponBook);
                                          },
                                          child: Container(
                                            width: 35,
                                            height: 35,
                                            decoration: BoxDecoration(
                                              color: AppColors.theme_color,
                                              borderRadius:
                                              BorderRadius.circular(4),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: AppColors.white,
                                                  blurRadius: 14,
                                                  offset: Offset(0, 4),
                                                ),
                                              ],
                                            ),
                                            child: Icon(
                                              Icons.arrow_forward,
                                              color: Colors.white,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    _buildItem(
                                        '${homeProvider.homeEmployeeDetails[0].remainingPaidCouponCount}(${homeProvider.homeEmployeeDetails[0].remainingFreeCouponCount} Free Coupons)',
                                        'assets/home/paidcoupon.png',
                                        'Remaining'),
                                    _buildItem(
                                        '${homeProvider.homeEmployeeDetails[0].utilizedPaidCouponCount}(${homeProvider.homeEmployeeDetails[0].utilizedFreeCouponCount} Free Coupons)',
                                        'assets/home/free_coupon.png',
                                        'Utilized'),
                                  ],
                                ),
                              ],
                            ),
                          ),


                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  child: Material(
                                    color: Colors.white,
                                    elevation: 5,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(10.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                width: 60,
                                                // Width of the circle container
                                                height: 60,
                                                // Height of the circle container
                                                child: Stack(
                                                  alignment: Alignment.center,
                                                  children: [
                                                    SizedBox(
                                                      width: 60,
                                                      // Width of the CircularProgressIndicator
                                                      height: 60,
                                                      // Height of the CircularProgressIndicator
                                                      child:
                                                          CircularProgressIndicator(
                                                        value: 0.8,
                                                        // Value for progress
                                                        backgroundColor:
                                                            Colors.transparent,
                                                        valueColor:
                                                            AlwaysStoppedAnimation<
                                                                Color>(
                                                          AppColors
                                                              .theme_color, // Color of the progress
                                                        ),
                                                        strokeWidth:
                                                            4, // Increase the strokeWidth to increase the gap
                                                      ),
                                                    ),
                                                    Container(
                                                      width: 40,
                                                      // Width of the inner circle
                                                      height: 40,
                                                      // Height of the inner circle
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: Colors.red
                                                            .shade500, // Color of the inner circle
                                                      ),
                                                      child: Icon(
                                                        Icons.arrow_upward,
                                                        color: Colors
                                                            .white, // Color of the arrow icon
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(width: 10),
                                              // Adding space between circle and text
                                              Flexible(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      '${homeProvider.homeEmployeeDetails[0].paymentTerm == 'DO' ? 'This Month DO' : 'This Month Paid'}',
                                                      style: TextStyle(
                                                        fontFamily:
                                                            'Metropolis',
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: AppColors.black,
                                                      ),
                                                    ),
                                                    Text(
                                                      '${homeProvider.homeEmployeeDetails[0].paymentTerm == 'DO' ? '${homeProvider.homeEmployeeDetails[0].thisMonthDoAmount} AED' : '${homeProvider.homeEmployeeDetails[0].thisMonthsaleAmount} AED'}',
                                                      style: TextStyle(
                                                        fontFamily:
                                                            'Metropolis',
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: AppColors
                                                            .theme_color,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 10),
                                          // Adding space between top and bottom content
                                          Container(
                                              height: 70,
                                              // Height of the small chart
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.only(
                                                  bottomLeft:
                                                      Radius.circular(8.0),
                                                  bottomRight:
                                                      Radius.circular(8.0),
                                                ),
                                              ),
                                              child: WaveAnimation()),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: Container(
                                  color: Colors.white,
                                  child: Material(
                                    color: Colors.white,
                                    elevation: 5,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(10.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                width: 60,
                                                // Width of the circle container
                                                height: 60,
                                                // Height of the circle container
                                                child: Stack(
                                                  alignment: Alignment.center,
                                                  children: [
                                                    SizedBox(
                                                      width: 60,
                                                      // Width of the CircularProgressIndicator
                                                      height: 60,
                                                      // Height of the CircularProgressIndicator
                                                      child:
                                                          CircularProgressIndicator(
                                                        value: 0.6,
                                                        // Value for progress
                                                        backgroundColor:
                                                            Colors.transparent,
                                                        valueColor:
                                                            AlwaysStoppedAnimation<
                                                                Color>(
                                                          AppColors
                                                              .theme_color, // Color of the progress
                                                        ),
                                                        strokeWidth:
                                                            4, // Increase the strokeWidth to increase the gap
                                                      ),
                                                    ),
                                                    Container(
                                                      width: 40,
                                                      // Width of the inner circle
                                                      height: 40,
                                                      // Height of the inner circle
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: AppColors
                                                            .green, // Color of the inner circle
                                                      ),
                                                      child: Icon(
                                                        Icons.arrow_upward,
                                                        color: Colors
                                                            .white, // Color of the arrow icon
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(width: 10),
                                              // Adding space between circle and text
                                              Flexible(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'This Month Collection',
                                                      style: TextStyle(
                                                        fontFamily:
                                                            'Metropolis',
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: AppColors.black,
                                                      ),
                                                    ),
                                                    Text(
                                                      '${homeProvider.homeEmployeeDetails[0].thisMonthCollection} AED',
                                                      style: TextStyle(
                                                        fontFamily:
                                                            'Metropolis',
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: AppColors
                                                            .theme_color,
                                                      ),
                                                    ),
                                                    Text(
                                                      'Last Collection',
                                                      style: TextStyle(
                                                        fontFamily:
                                                            'Metropolis',
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: AppColors.black,
                                                      ),
                                                    ),
                                                    Text(
                                                      '${homeProvider.homeEmployeeDetails[0].lastCollectionAmount} AED',
                                                      style: TextStyle(
                                                        fontFamily:
                                                            'Metropolis',
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: AppColors
                                                            .theme_color,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 10),
                                          // Adding space between top and bottom content
                                          Container(
                                              height: 60,
                                              // Height of the small chart
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.only(
                                                  bottomLeft:
                                                      Radius.circular(8.0),
                                                  bottomRight:
                                                      Radius.circular(8.0),
                                                ),
                                              ),
                                              child: GreenWaveAnimation()),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                },
              );
            } else {
              return Container();
            }
          }
        });
  }
}

Widget _buildItem(String text, String imagePath, String label) {
  return Expanded(
    child: Stack(
      children: [
        Positioned(
          bottom: 15,
          left: 0,
          width: 4,
          top: 65,
          child: Container(
            color: AppColors.theme_color, // Indicator color
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 2,
                offset: Offset(0, 1),
              ),
            ],
          ),
          padding: EdgeInsets.all(15.0),
          margin: EdgeInsets.symmetric(horizontal: 5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                // mainAxisAlignment: MainAxisAlignment.end, // Align to right
                children: [
                  Column(
                    children: [
                      Text(
                        label,
                        style: TextStyle(
                          fontFamily: 'Metropolis',
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppColors.black,
                        ),
                      ),
                      Text(
                        'Coupons',
                        style: TextStyle(
                          fontFamily: 'Metropolis',
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppColors.black,
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.theme_color, // Indicator color
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Image.asset(imagePath,
                        width: 30, height: 30, color: AppColors.white
                        // You can adjust width and height as needed
                        ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Text(
                text,
                style: TextStyle(
                  fontFamily: 'Metropolis',
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColors.theme_color,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class SaleTimingBox extends StatelessWidget {
  final String title;
  final String amount;
  final String imagePath;
  final String subtitile;

  const SaleTimingBox({
    Key? key,
    required this.title,
    required this.amount,
    required this.imagePath,
    required this.subtitile,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              Image.asset(imagePath,
                  width: 20, height: 20, color: AppColors.theme_color),
              SizedBox(
                width: 2,
              ),
              Column(children: [
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: 'Metropolis',
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.black,
                  ),
                ),
                if (subtitile != '')
                  Text(
                    subtitile,
                    style: TextStyle(
                      fontFamily: 'Metropolis',
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppColors.black,
                    ),
                  )
              ]),
            ],
          ),
          SizedBox(height: 4),
          Text(
            amount,
            style: TextStyle(
              fontFamily: 'Metropolis',
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppColors.theme_color,
            ),
          ),
        ],
      ),
    );
  }
}
