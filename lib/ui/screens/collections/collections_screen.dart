import 'package:flutter/material.dart';
import 'package:nexust/data/models/rest_endpoint.dart';
import 'package:nexust/ui/views/collections/collection_list_view.dart';
import 'package:nexust/ui/widgets/collections/rest_endpoint_item.dart';

class CollectionsScreen extends StatefulWidget {
  static const String routeName = "collections";
  const CollectionsScreen({super.key});

  @override
  State<CollectionsScreen> createState() => _CollectionsScreenState();
}

class _CollectionsScreenState extends State<CollectionsScreen> {
  final List<RestEndpoint> demoData = [
    RestEndpoint(
      name: 'Usuarios',
      isGroup: true,
      children: [
        RestEndpoint(
          name: 'Obtener usuarios',
          isGroup: false,
          method: 'GET',
          path: '/api/users',
          parameters: {'page': 1, 'limit': 20, 'sort': 'name'},
          headers: {
            'Authorization': 'Bearer {token}',
            'Content-Type': 'application/json',
          },
          response: {
            'data': [
              {'id': 1, 'name': 'Juan Pérez', 'email': 'juan@example.com'},
              {'id': 2, 'name': 'Ana García', 'email': 'ana@example.com'},
            ],
            'total': 50,
            'page': 1,
            'pages': 3,
          },
        ),
        RestEndpoint(
          name: 'Crear usuario',
          isGroup: false,
          method: 'POST',
          path: '/api/users',
          headers: {
            'Authorization': 'Bearer {token}',
            'Content-Type': 'application/json',
          },
          body: {
            'name': 'Nuevo Usuario',
            'email': 'nuevo@example.com',
            'password': '********',
          },
          response: {
            'id': 3,
            'name': 'Nuevo Usuario',
            'email': 'nuevo@example.com',
            'created_at': '2025-04-26T10:30:00Z',
          },
        ),
        RestEndpoint(
          name: 'Usuario por ID',
          isGroup: true,
          children: [
            RestEndpoint(
              name: 'Obtener usuario',
              isGroup: false,
              method: 'GET',
              path: '/api/users/{id}',
              parameters: {'id': 1},
              headers: {
                'Authorization': 'Bearer {token}',
                'Content-Type': 'application/json',
              },
              response: {
                'id': 1,
                'name': 'Juan Pérez',
                'email': 'juan@example.com',
                'role': 'admin',
                'created_at': '2025-03-15T08:40:00Z',
              },
            ),
            RestEndpoint(
              name: 'Actualizar usuario',
              isGroup: false,
              method: 'PUT',
              path: '/api/users/{id}',
              parameters: {'id': 1},
              headers: {
                'Authorization': 'Bearer {token}',
                'Content-Type': 'application/json',
              },
              body: {
                'name': 'Juan Pérez Actualizado',
                'email': 'juan.nuevo@example.com',
              },
              response: {
                'id': 1,
                'name': 'Juan Pérez Actualizado',
                'email': 'juan.nuevo@example.com',
                'updated_at': '2025-04-26T11:15:00Z',
              },
            ),
            RestEndpoint(
              name: 'Eliminar usuario',
              isGroup: false,
              method: 'DELETE',
              path: '/api/users/{id}',
              parameters: {'id': 1},
              headers: {'Authorization': 'Bearer {token}'},
              response: {
                'message': 'Usuario eliminado correctamente',
                'deleted_at': '2025-04-26T11:30:00Z',
              },
            ),
          ],
        ),
      ],
    ),
    RestEndpoint(
      name: 'Productos',
      isGroup: true,
      children: [
        RestEndpoint(
          name: 'Listar productos',
          isGroup: false,
          method: 'GET',
          path: '/api/products',
          parameters: {'category': 'electronics', 'limit': 10},
          headers: {'Content-Type': 'application/json'},
          response: {
            'products': [
              {'id': 101, 'name': 'Smartphone XYZ', 'price': 699.99},
              {'id': 102, 'name': 'Laptop ABC', 'price': 1299.99},
            ],
            'total': 45,
            'count': 2,
          },
        ),
        RestEndpoint(
          name: 'Crear producto',
          isGroup: false,
          method: 'POST',
          path: '/api/products',
          headers: {
            'Authorization': 'Bearer {token}',
            'Content-Type': 'application/json',
          },
          body: {
            'name': 'Nuevo Producto',
            'price': 499.99,
            'category': 'electronics',
            'stock': 25,
          },
          response: {
            'id': 103,
            'name': 'Nuevo Producto',
            'created_at': '2025-04-26T14:20:00Z',
          },
        ),
      ],
    ),
    RestEndpoint(
      name: 'Autenticación',
      isGroup: true,
      children: [
        RestEndpoint(
          name: 'Iniciar sesión',
          isGroup: false,
          method: 'POST',
          path: '/api/auth/login',
          headers: {'Content-Type': 'application/json'},
          body: {'email': 'usuario@example.com', 'password': '********'},
          response: {
            'token': 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...',
            'expires_at': '2025-04-26T23:59:59Z',
            'user': {'id': 1, 'name': 'Usuario', 'role': 'admin'},
          },
        ),
        RestEndpoint(
          name: 'Renovar token',
          isGroup: false,
          method: 'POST',
          path: '/api/auth/refresh',
          headers: {
            'Authorization': 'Bearer {refresh_token}',
            'Content-Type': 'application/json',
          },
          response: {
            'token': 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...',
            'expires_at': '2025-04-27T23:59:59Z',
          },
        ),
        RestEndpoint(
          name: 'Cerrar sesión',
          isGroup: false,
          method: 'POST',
          path: '/api/auth/logout',
          headers: {
            'Authorization': 'Bearer {token}',
            'Content-Type': 'application/json',
          },
          response: {'message': 'Sesión cerrada correctamente'},
        ),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'REST API Explorer',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        actions: [
          IconButton(icon: Icon(Icons.search), onPressed: () {}),
          IconButton(icon: Icon(Icons.settings), onPressed: () {}),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 16.0, bottom: 16.0, top: 8.0),
                child: Text(
                  'Endpoints disponibles',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: CollectionListView(items: demoData),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.indigo.shade700,
        tooltip: 'Crear nuevo endpoint',
        child: Icon(Icons.add),
      ),
    );
  }
}

// Modelo de datos para representar elementos del sistema de archivos
class FileSystemEntity {
  final String name;
  final bool isDirectory;
  final List<FileSystemEntity> children;
  bool isExpanded;

  FileSystemEntity({
    required this.name,
    required this.isDirectory,
    this.children = const [],
    this.isExpanded = false,
  });
}
