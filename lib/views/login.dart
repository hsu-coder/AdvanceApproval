import 'package:advance_budget_request_system/views/register.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final List<String> departments = ["Admin", "HR", "Marketing"];
  String? _selectedDepartment;

  final _formkey = GlobalKey<FormState>();

  bool _isObscured = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: const Color.fromARGB(255, 100, 131, 84),
        child: Row(
          children: [
            Container(
              color: const Color.fromARGB(255, 83, 107, 62),
              width: MediaQuery.of(context).size.width / 7 * 2,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image(
                  image: const AssetImage("images/frame_2.png"),
                  width: MediaQuery.of(context).size.width / 7 * 2,
                  height: MediaQuery.of(context).size.height / 7 * 7,
                ),
              ),
            ),
            Expanded(
                child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 50),
                  child: Center(
                    child: Text(
                      "Login An Account",
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 30, top: 10),
                  child: Container(
                    width: MediaQuery.of(context).size.width / 7 * 5,
                    child: Column(
                      children: [
                        Form(
                            key: _formkey,
                            child: Column(
                              children: [
                                ListTile(
                                  leading: const Icon(
                                    Icons.email_outlined,
                                    color: Colors.black,
                                    size: 40,
                                  ),
                                  title: TextFormField(
                                    decoration: const InputDecoration(
                                      labelText: "Enter Your Email",
                                      labelStyle:
                                          TextStyle(color: Colors.white),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.white),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.white, width: 2.0),
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Enter Your Email";
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                ListTile(
                                    leading: const Icon(
                                      Icons.apartment,
                                      color: Colors.black,
                                      size: 40,
                                    ),
                                    title: DropdownButtonFormField(
                                      decoration: const InputDecoration(
                                          labelText: "Choose Your Department",
                                          labelStyle:
                                              TextStyle(color: Colors.white),
                                          enabledBorder: UnderlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.white),
                                          ),
                                          focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.white))),
                                      dropdownColor: Colors.white,
                                      items: departments.map((department) {
                                        return DropdownMenuItem(
                                            value: department,
                                            child: Text(department));
                                      }).toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          _selectedDepartment = value;
                                        });
                                      },
                                      icon: const Icon(
                                        Icons.arrow_drop_down,
                                        color: Colors.white,
                                        size: 30,
                                      ),
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please select your department!!';
                                        }
                                        return null;
                                      },
                                    )),
                                ListTile(
                                  leading: const Icon(
                                    Icons.key,
                                    color: Colors.black,
                                    size: 40,
                                  ),
                                  title: TextFormField(
                                      decoration: InputDecoration(
                                        labelText: "Enter Your Password",
                                        labelStyle: const TextStyle(
                                            color: Colors.white),
                                        enabledBorder:
                                            const UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.white),
                                        ),
                                        focusedBorder:
                                            const UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.white, width: 2.0),
                                        ),
                                        suffixIcon: IconButton(
                                            onPressed: () {
                                              setState(() {
                                                _isObscured = !_isObscured;
                                              });
                                            },
                                            icon: Icon(
                                              _isObscured
                                                  ? Icons.visibility_off
                                                  : Icons.visibility,
                                              color: Colors.white,
                                            )),
                                      ),
                                      obscureText: _isObscured,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return "Please Enter your Password!!";
                                        }
                                        return null;
                                      }),
                                ),
                                ListTile(
                                  title: const Text(
                                    "Create an Account",
                                    style: TextStyle(
                                        color: Colors.lightBlueAccent,
                                        decoration: TextDecoration.underline,
                                        decorationColor: Colors.blue,
                                        decorationThickness: 2.0),
                                  ),
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const RegisterView()));
                                  },
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    if (_formkey.currentState?.validate() ??
                                        false) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content: Text(
                                                  "Login Successfully!!")));
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const Login()));
                                    }
                                    // else {
                                    //   ScaffoldMessenger.of(context).showSnackBar(
                                    //     const SnackBar(
                                    //       content:
                                    //           Text("Please fix the errors above"),
                                    //       backgroundColor: Colors.red,
                                    //     ),
                                    //   );
                                    // }
                                  },
                                  style: ButtonStyle(
                                      shape: WidgetStateProperty.all(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0)),
                                      ),
                                      minimumSize: WidgetStateProperty.all(
                                          const Size(150, 50))),
                                  child: const Text(
                                    "Login",
                                    style: TextStyle(
                                        fontFamily: 'Schyler',
                                        color: Colors.black,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                )
                              ],
                            ))
                      ],
                    ),
                  ),
                )
              ],
            ))
          ],
        ),
      ),
    );
  }
}
