import 'package:flutter/material.dart';
import 'chat_screen.dart';

class HomeScreen extends StatelessWidget {
  final List<Map<String, dynamic>> boards = [
    {
      'id': 'board1',
      'name': 'General Chat',
      'icon': Icons.chat,
    },
    {
      'id': 'board2',
      'name': 'Tech Talk',
      'icon': Icons.computer,
    },
    {
      'id': 'board3',
      'name': 'Random',
      'icon': Icons.sentiment_satisfied,
    },
    {
      'id': 'board4',
      'name': 'Study Group',
      'icon': Icons.school,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Message Boards'),
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: Icon(Icons.message),
              title: Text('Message Boards'),
              onTap: () {
                Navigator.pop(context); // Close drawer
              },
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Profile'),
              onTap: () {
                Navigator.pushNamed(context, '/profile');
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                Navigator.pushNamed(context, '/settings');
              },
            ),
          ],
        ),
      ),
      body: ListView.builder(
        itemCount: boards.length,
        itemBuilder: (context, index) {
          final board = boards[index];
          return Card(
            child: ListTile(
              leading: Icon(
                board['icon'] is IconData ? board['icon'] as IconData : Icons.help,
              ),
              title: Text(board['name']),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatScreen(boardId: board['id'], boardName: board['name']),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
