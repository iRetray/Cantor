import 'package:flutter/cupertino.dart';

import 'package:cantor/screens/songs.dart';

void main() {
  runApp(const Cantor());
}

class Cantor extends StatelessWidget {
  const Cantor({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
      debugShowCheckedModeBanner: false,
      theme: CupertinoThemeData(brightness: Brightness.dark),
      title: "Cantor",
      home: NavigationRouter(),
    );
  }
}

class NavigationRouter extends StatelessWidget {
  const NavigationRouter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        currentIndex: 1,
        height: 60,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.music_albums),
            label: 'Albums',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.double_music_note),
            label: 'Songs',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.music_mic),
            label: 'Artists',
          ),
        ],
      ),
      tabBuilder: (context, index) {
        late final CupertinoTabView returnValue;
        switch (index) {
          case 0:
            returnValue = CupertinoTabView(builder: (context) {
              return const CupertinoPageScaffold(
                child: Text("First child"),
              );
            });
            break;
          case 1:
            returnValue = CupertinoTabView(builder: (context) {
              return const CupertinoPageScaffold(
                child: Songs(),
              );
            });
            break;
          case 2:
            returnValue = CupertinoTabView(builder: (context) {
              return const CupertinoPageScaffold(
                child: Text("Third child"),
              );
            });
            break;
        }
        return returnValue;
      },
    );
  }
}
