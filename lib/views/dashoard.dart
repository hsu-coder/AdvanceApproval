import 'package:advance_budget_request_system/views/advanceRequest.dart';
import 'package:advance_budget_request_system/views/budgetAmount.dart';
import 'package:advance_budget_request_system/views/budgetcode.dart';
import 'package:advance_budget_request_system/views/project.dart';
import 'package:advance_budget_request_system/views/trip.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  bool isMenuBar = false;
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    const DashboardView(),
    const Budgetcodeview(),
    const Budgetamount(),
    ProjectInfo(),
    const TripInfo(),
    const Advancerequest(),
    const Center(child: Text("Cash Payment")),
    const Center(child: Text("Settlement")),
    const Center(child: Text("Approval Setup")),
  ];

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _toggleMenuBar() {
    setState(() {
      if (isMenuBar) {
        controller.reverse();
      } else {
        controller.forward();
      }
      isMenuBar = !isMenuBar;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _toggleMenuBar();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(100, 207, 198, 0.855),
        title: const Text("Advance Budget Request System"),
        leading: IconButton(
          onPressed: _toggleMenuBar,
          icon: AnimatedIcon(
            icon: AnimatedIcons.menu_close,
            progress: controller,
          ),
        ),
        actions: [
          Row(
            children: [
              const IconButton(
                onPressed: null,
                icon: Icon(Icons.notifications),
                color: Colors.black,
              ),
              IconButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          final screenWidth = MediaQuery.of(context).size.width;
                          final screenHeight =
                              MediaQuery.of(context).size.height;
                          return Stack(
                            children: [
                              Positioned(
                                  left: screenWidth * 0.4,
                                  top: screenHeight / 25 * 1,
                                  // height: screenHeight * 0.2,
                                  child: SizedBox(
                                    width: screenWidth * 0.8,
                                    child: Dialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.2,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 10, top: 10),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(50.0),
                                                child: Image.asset(
                                                  "images/Kayla-Person.png",
                                                  width: 70,
                                                  height: 70,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                              const Divider(),
                                              const Row(
                                                children: [
                                                  Text("Name  "),
                                                  Text(
                                                    " - ",
                                                    style:
                                                        TextStyle(fontSize: 30),
                                                  ),
                                                  Text("Emily")
                                                ],
                                              ),
                                              const Row(
                                                children: [
                                                  Text("Email "),
                                                  Text(
                                                    " - ",
                                                    style:
                                                        TextStyle(fontSize: 30),
                                                  ),
                                                  Text("emily@gmail.com")
                                                ],
                                              ),
                                              const Row(
                                                children: [
                                                  Text('Department'),
                                                  Text(
                                                    ' - ',
                                                    style:
                                                        TextStyle(fontSize: 30),
                                                  ),
                                                  Text('Admin')
                                                ],
                                              ),
                                              const Row(
                                                children: [
                                                  Text('Role '),
                                                  Text(
                                                    ' - ',
                                                    style:
                                                        TextStyle(fontSize: 30),
                                                  ),
                                                  Text('Manager')
                                                ],
                                              ),
                                              ListTile(
                                                leading: const Icon(Icons.key),
                                                title: const Text(
                                                  "Manage your password",
                                                  style: TextStyle(
                                                      color: Colors.blue),
                                                ),
                                                onTap: () {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(const SnackBar(
                                                          content: Text(
                                                              "Click the link!!")));
                                                },
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 8.0, bottom: 10.0),
                                                child: ElevatedButton(
                                                    onPressed: () {
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                              const SnackBar(
                                                                  content: Text(
                                                                      "Click the Button!!")));
                                                    },
                                                    child:
                                                        const Text("LogOut")),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ))
                            ],
                          );
                        });
                  },
                  icon: const Icon(Icons.person)),
              const Text('Emily'),
              SizedBox(
                width: MediaQuery.of(context).size.width / 45,
              )
            ],
          )
        ],
      ),
      body: Container(
        color: Colors.green,
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              left: isMenuBar ? 0 : -200, // Adjust the width as per your drawer
              top: 0,
              bottom: 0,
              child: Container(
                  width: 200,
                  color: Colors.white,
                  child: SizedBox(
                    child: CustomDrawer(onItemTapped: _onItemTapped),
                  )),
            ),
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              left: isMenuBar ? 200 : 0,
              right: 0,
              top: 0,
              bottom: 0,
              child: _widgetOptions[_selectedIndex],
            ),
          ],
        ),
      ),
    );
  }
}

class CustomDrawer extends StatefulWidget {
  final ValueChanged<int> onItemTapped;

  const CustomDrawer({super.key, required this.onItemTapped});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.white,
        width: MediaQuery.of(context).size.width / 2 * 1,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                title: const Text("Dashboard"),
                onTap: () => widget.onItemTapped(0),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                title: const Text("Budget Code"),
                onTap: () => widget.onItemTapped(1),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: ListTile(
                  title: const Text('Budget Amount'),
                  onTap: () => widget.onItemTapped(2)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: ListTile(
                  title: const Text('Project Information'),
                  onTap: () => widget.onItemTapped(3)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: ListTile(
                  title: const Text('Trip Information'),
                  onTap: () => widget.onItemTapped(4)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: ListTile(
                  title: const Text('Advance Request'),
                  onTap: () => widget.onItemTapped(5)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: ListTile(
                  title: const Text('Cash Payment'),
                  onTap: () => widget.onItemTapped(6)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: ListTile(
                  title: const Text('Settlement'),
                  onTap: () => widget.onItemTapped(7)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: ListTile(
                  title: const Text('Approval SetUp'),
                  onTap: () => widget.onItemTapped(8)),
            ),
            // Padding(
            //   padding: const EdgeInsets.symmetric(vertical: 8.0),
            //   child: ElevatedButton(
            //     onPressed: () {},
            //     child: const Text("LogOut"),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}

// Dashboard
class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          double containerWidth = constraints.maxWidth;
          bool isSmallScreen = constraints.maxWidth < 700;

          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
              width: isSmallScreen ? constraints.maxWidth/0.55 : containerWidth,
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          color: Color.fromARGB(255, 106, 197, 185),
                          // width: isSmallScreen? constraints.maxWidth * 0.9 : containerWidth,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                const Center(
                                  child: Icon(Icons.money_rounded),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                Column(
                                  children: [
                                    const Text("Budget Code"),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        OutlinedButton.icon(
                                          onPressed: null,
                                          icon: const Icon(Icons.add),
                                          label: const Text(
                                            "New",
                                            style: TextStyle(color: Colors.white),
                                          ),
                                          style: OutlinedButton.styleFrom(
                                              side: const BorderSide(
                                                  color: Colors.white),
                                              iconColor: Colors.white),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        OutlinedButton.icon(
                                          onPressed: null,
                                          icon: const Icon(
                                              Icons.more_horiz_outlined),
                                          label: const Text(
                                            "Detail",
                                            style: TextStyle(color: Colors.white),
                                          ),
                                          style: OutlinedButton.styleFrom(
                                            side: const BorderSide(
                                                color: Colors.white),
                                            iconColor: Colors.white,
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  width: 7,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          color: Color.fromARGB(255, 106, 197, 185),
                          // width: isSmallScreen? constraints.maxWidth * 0.9 : containerWidth,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                const Center(
                                  child: Icon(Icons.money_rounded),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                Column(
                                  children: [
                                    const Text("Budget Amount"),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        OutlinedButton.icon(
                                          onPressed: null,
                                          icon: const Icon(Icons.add),
                                          label: const Text(
                                            "New",
                                            style: TextStyle(color: Colors.white),
                                          ),
                                          style: OutlinedButton.styleFrom(
                                              side: const BorderSide(
                                                  color: Colors.white),
                                              iconColor: Colors.white),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        OutlinedButton.icon(
                                          onPressed: null,
                                          icon: const Icon(
                                              Icons.more_horiz_outlined),
                                          label: const Text(
                                            "Detail",
                                            style: TextStyle(color: Colors.white),
                                          ),
                                          style: OutlinedButton.styleFrom(
                                            side: const BorderSide(
                                                color: Colors.white),
                                            iconColor: Colors.white,
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  width: 7,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          color: Color.fromARGB(255, 106, 197, 185),
                          // width: isSmallScreen? constraints.maxWidth * 0.9 : containerWidth,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                const Center(
                                  child: Icon(Icons.money_rounded),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                Column(
                                  children: [
                                    const Text("Project Request"),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        OutlinedButton.icon(
                                          onPressed: null,
                                          icon: const Icon(Icons.add),
                                          label: const Text(
                                            "New",
                                            style: TextStyle(color: Colors.white),
                                          ),
                                          style: OutlinedButton.styleFrom(
                                              side: const BorderSide(
                                                  color: Colors.white),
                                              iconColor: Colors.white),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        OutlinedButton.icon(
                                          onPressed: null,
                                          icon: const Icon(
                                              Icons.more_horiz_outlined),
                                          label: const Text(
                                            "Detail",
                                            style: TextStyle(color: Colors.white),
                                          ),
                                          style: OutlinedButton.styleFrom(
                                            side: const BorderSide(
                                                color: Colors.white),
                                            iconColor: Colors.white,
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  width: 7,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          color: Color.fromARGB(255, 106, 197, 185),
                          // width: isSmallScreen? constraints.maxWidth * 0.9 : containerWidth,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                const Center(
                                  child: Icon(Icons.airplane_ticket_outlined),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                Column(
                                  children: [
                                    const Text("Trip Request"),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        OutlinedButton.icon(
                                          onPressed: null,
                                          icon: const Icon(Icons.add),
                                          label: const Text(
                                            "New",
                                            style: TextStyle(color: Colors.white),
                                          ),
                                          style: OutlinedButton.styleFrom(
                                              side: const BorderSide(
                                                  color: Colors.white),
                                              iconColor: Colors.white),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        OutlinedButton.icon(
                                          onPressed: null,
                                          icon: const Icon(
                                              Icons.more_horiz_outlined),
                                          label: const Text(
                                            "Detail",
                                            style: TextStyle(color: Colors.white),
                                          ),
                                          style: OutlinedButton.styleFrom(
                                            side: const BorderSide(
                                                color: Colors.white),
                                            iconColor: Colors.white,
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  width: 7,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          color: Color.fromARGB(255, 106, 197, 185),
                          // width: isSmallScreen? constraints.maxWidth * 0.9 : containerWidth,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                const Center(
                                  child: Icon(Icons.request_page),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                Column(
                                  children: [
                                    const Text("Advance Request"),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        OutlinedButton.icon(
                                          onPressed: null,
                                          icon: const Icon(Icons.add),
                                          label: const Text(
                                            "New",
                                            style: TextStyle(color: Colors.white),
                                          ),
                                          style: OutlinedButton.styleFrom(
                                              side: const BorderSide(
                                                  color: Colors.white),
                                              iconColor: Colors.white),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        OutlinedButton.icon(
                                          onPressed: null,
                                          icon: const Icon(
                                              Icons.more_horiz_outlined),
                                          label: const Text(
                                            "Detail",
                                            style: TextStyle(color: Colors.white),
                                          ),
                                          style: OutlinedButton.styleFrom(
                                            side: const BorderSide(
                                                color: Colors.white),
                                            iconColor: Colors.white,
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  width: 7,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          color: Color.fromARGB(255, 106, 197, 185),
                          // width: isSmallScreen? constraints.maxWidth * 0.9 : containerWidth,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                const Center(
                                  child: Icon(Icons.payment),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                Column(
                                  children: [
                                    const Text("Cash Payment"),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        OutlinedButton.icon(
                                          onPressed: null,
                                          icon: const Icon(Icons.add),
                                          label: const Text(
                                            "New",
                                            style: TextStyle(color: Colors.white),
                                          ),
                                          style: OutlinedButton.styleFrom(
                                              side: const BorderSide(
                                                  color: Colors.white),
                                              iconColor: Colors.white),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        OutlinedButton.icon(
                                          onPressed: null,
                                          icon: const Icon(
                                              Icons.more_horiz_outlined),
                                          label: const Text(
                                            "Detail",
                                            style: TextStyle(color: Colors.white),
                                          ),
                                          style: OutlinedButton.styleFrom(
                                            side: const BorderSide(
                                                color: Colors.white),
                                            iconColor: Colors.white,
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  width: 7,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          color: Color.fromARGB(255, 106, 197, 185),
                          // width: isSmallScreen? constraints.maxWidth * 0.9 : containerWidth,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                const Center(
                                  child: Icon(Icons.note_outlined),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                Column(
                                  children: [
                                    const Text("Settlement"),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        OutlinedButton.icon(
                                          onPressed: null,
                                          icon: const Icon(Icons.add),
                                          label: const Text(
                                            "New",
                                            style: TextStyle(color: Colors.white),
                                          ),
                                          style: OutlinedButton.styleFrom(
                                              side: const BorderSide(
                                                  color: Colors.white),
                                              iconColor: Colors.white),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        OutlinedButton.icon(
                                          onPressed: null,
                                          icon: const Icon(
                                              Icons.more_horiz_outlined),
                                          label: const Text(
                                            "Detail",
                                            style: TextStyle(color: Colors.white),
                                          ),
                                          style: OutlinedButton.styleFrom(
                                            side: const BorderSide(
                                                color: Colors.white),
                                            iconColor: Colors.white,
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  width: 7,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          color: Color.fromARGB(255, 106, 197, 185),
                          // width: isSmallScreen? constraints.maxWidth * 0.9 : containerWidth,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                const Center(
                                  child: Icon(Icons.approval),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                Column(
                                  children: [
                                    const Text("Approval SetUp"),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        OutlinedButton.icon(
                                          onPressed: null,
                                          icon: const Icon(Icons.add),
                                          label: const Text(
                                            "New",
                                            style: TextStyle(color: Colors.white),
                                          ),
                                          style: OutlinedButton.styleFrom(
                                              side: const BorderSide(
                                                  color: Colors.white),
                                              iconColor: Colors.white),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        OutlinedButton.icon(
                                          onPressed: null,
                                          icon: const Icon(
                                              Icons.more_horiz_outlined),
                                          label: const Text(
                                            "Detail",
                                            style: TextStyle(color: Colors.white),
                                          ),
                                          style: OutlinedButton.styleFrom(
                                            side: const BorderSide(
                                                color: Colors.white),
                                            iconColor: Colors.white,
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  width: 7,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
