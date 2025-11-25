import 'package:flutter/material.dart';
import 'package:todo_api/components/app_button_icon.dart';
import 'package:todo_api/components/app_color.dart';
import 'package:todo_api/components/app_path.dart';
import 'package:todo_api/components/app_text.dart';
import 'package:todo_api/routes/app_route.dart';
import 'package:todo_api/screens/completed_task_screen.dart';
import 'package:todo_api/screens/todo_page.dart';

class BottomNavigationWidget extends StatefulWidget {
  const BottomNavigationWidget({super.key});

  @override
  State<BottomNavigationWidget> createState() => _BottomNavigationWidgetState();
}

int currentIndex = 0;

class _BottomNavigationWidgetState extends State<BottomNavigationWidget> {
  void _onItemTapped(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> page = [TodoPage(), Completedtaskscreen()];
    return Scaffold(
      body: IndexedStack(index: currentIndex, children: [...page]),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _plusButton(context),
      bottomNavigationBar: _bottomAppBar(_onItemTapped),
    );
  }
}

//bottomappbar
BottomAppBar _bottomAppBar(onItemTapped) {
  return BottomAppBar(
    shape: const CircularNotchedRectangle(),
    notchMargin: 0,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buttonBottomAppBar(
          index: 0,
          iconPath: AppPath.icPlaylist,
          label: "All",
          onTap: onItemTapped,
        ),
        _buttonBottomAppBar(
          index: 1,
          iconPath: AppPath.icTick,
          label: 'Completed',
          onTap: onItemTapped,
        ),
      ],
    ),
  );
}

//create Task
FloatingActionButton _plusButton(context) {
  return FloatingActionButton(
    onPressed: () {
      Navigator.pushNamed(context, AppRoute.createTaskPage);
    },

    backgroundColor: AppColor.pastelPurple,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
    child: const Icon(Icons.add),
  );
}

//button_buttonappbar
Widget _buttonBottomAppBar({
  required int index,
  required String iconPath,
  required String label,
  required onTap,
}) {
  return Column(
    children: [
      AppButtonIcon(
        onTap: () => onTap(index),
        iconpath: iconPath,
        colorFilter: ColorFilter.mode(
          currentIndex == index ? AppColor.pastelPurple : AppColor.warmGray,
          BlendMode.srcIn,
        ),
      ),
      AppText(
        text: label,
        style: TextStyle(
          color: currentIndex == index
              ? AppColor.pastelPurple
              : AppColor.warmGray,
        ),
      ),
    ],
  );
}
