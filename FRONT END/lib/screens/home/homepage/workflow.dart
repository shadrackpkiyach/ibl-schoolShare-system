import 'package:flutter/material.dart';
import 'package:student/constants/themes.dart';
import 'package:student/models/navigationHomeModel.dart';
import 'package:student/screens/home/activities.dart';
import 'package:student/screens/home/homepage/activities_done.dart';
import 'package:student/screens/home/homepage/parent_view.dart';
import 'package:student/screens/home/list_tiles/sidebarcollapsing.dart';

class WorkflowPage extends StatefulWidget {
  const WorkflowPage({super.key});

  @override
  State<WorkflowPage> createState() => _WorkflowPageState();
}

class _WorkflowPageState extends State<WorkflowPage>
    with SingleTickerProviderStateMixin {
  double maxWidth = 180;
  double minWidth = 70;
  bool isCollapsed = false;
  late ValueNotifier<bool> sidebarCollapsedNotifier;
  late AnimationController _animationController;
  late Animation<double> widthAnimation;
  int currentSelectedIndex = 0;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    widthAnimation = Tween<double>(begin: maxWidth, end: minWidth)
        .animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();

    super.dispose();
  }

  double get animationWidth => widthAnimation.value;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: <Widget>[
          AnimatedBuilder(
            animation: _animationController,
            builder: (context, widget) => getWidget(context, widget),
            //child: getWidget(context, widget)
          ),
          Expanded(
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(
                    widthAnimation.value - maxWidth,
                    0,
                  ),
                  child: child,
                );
              },
              child: getPageByIndex(currentSelectedIndex),
            ),
          ),
        ],
      ),
    );
  }

  Widget getWidget(context, widget) {
    return Material(
      elevation: 80.0,
      child: Container(
        width: widthAnimation.value,
        color: drawerBackgroundColor,
        child: Column(
          children: <Widget>[
            CollapsingListTile(
              title: 'SCHOOL',
              icon: Icons.person,
              animationController: _animationController,
              onTap: () {
                // Navigator.push(
                //  context,
                //  MaterialPageRoute(builder: (context) => Activities()),
                //);
              },
            ),
            const Divider(
              color: Colors.grey,
              height: 40.0,
            ),
            Expanded(
              child: ListView.separated(
                separatorBuilder: (context, counter) {
                  return const Divider(height: 12.0);
                },
                itemBuilder: (context, counter) {
                  return CollapsingListTile(
                    onTap: () {
                      setState(() {
                        currentSelectedIndex = counter;
                      });
                      getPageByIndex(counter);
                    },
                    isSelected: currentSelectedIndex == counter,
                    title: navigationHomeItems[counter].title,
                    icon: navigationHomeItems[counter].icon,
                    animationController: _animationController,
                  );
                },
                itemCount: navigationHomeItems.length,
              ),
            ),
            //  InkWell(
            //onTap: () {
            // setState(() {
            //  isCollapsed = !isCollapsed;
            //  isCollapsed
            //     ? _animationController.forward()
            //   : _animationController.reverse();
            //  });
            // },
            // child: AnimatedIcon(
            //  icon: AnimatedIcons.close_menu,
            //    progress: _animationController,
            //   color: selectedColor,
            //  size: 50.0,
            //  ),
            //  ),
            const SizedBox(
              height: 50.0,
            ),
          ],
        ),
      ),
    );
  }

  Widget getPageByIndex(int counter) {
    // Return the corresponding page widget based on the index
    switch (counter) {
      case 0:
        return const WorkflowTeacherScreen();
      case 1:
        return const ClassTShownActivities();
      case 2:
        return const ClassTShownActivities();
      case 3:
        return const ClassTShownActivities();

      default:
        return const ActivitiesListView(); // Default to the documents page
    }
  }
}
