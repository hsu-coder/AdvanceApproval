
import 'package:advance_budget_request_system/views/budgetcode.dart';
import 'package:advance_budget_request_system/views/project.dart';
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
    budgetcode(),
    //const Center(child: Text('Budget Code')),
    const Center(child: Text("Budget Amount")),
  ProjectInfo(),
    const Center(child: Text("Trip Information")),
    const Center(child: Text("Advance Request")),
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
        backgroundColor: Color.fromRGBO(142, 224, 249, 0.855),
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
                title: const Text("Budget Code"),
                onTap: () => widget.onItemTapped(0),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: ListTile(
                  title: const Text('Budget Amount'),
                  onTap: () => widget.onItemTapped(1)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: ListTile(
                  title: const Text('Project Information'),
                  onTap: () => widget.onItemTapped(2)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: ListTile(
                  title: const Text('Trip Information'),
                  onTap: () => widget.onItemTapped(3)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: ListTile(
                  title: const Text('Advance Request'),
                  onTap: () => widget.onItemTapped(4)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: ListTile(
                  title: const Text('Cash Payment'),
                  onTap: () => widget.onItemTapped(5)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: ListTile(
                  title: const Text('Settlement'),
                  onTap: () => widget.onItemTapped(6)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: ListTile(
                  title: const Text('Approval SetUp'),
                  onTap: () => widget.onItemTapped(7)),
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
class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      

    );
  }
}
