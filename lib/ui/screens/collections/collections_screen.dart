import 'package:flutter/material.dart';
import 'package:nexust/ui/widgets/collections/collection_tree_item.dart';

class CollectionsScreen extends StatefulWidget {
  static const String routeName = "collections";
  const CollectionsScreen({super.key});

  @override
  State<CollectionsScreen> createState() => _CollectionsScreenState();
}

class _CollectionsScreenState extends State<CollectionsScreen> {
  final List<FileSystemEntity> demoData = [
    FileSystemEntity(
      name: 'Documentos',
      isDirectory: true,
      children: [
        FileSystemEntity(name: 'informe.pdf', isDirectory: false),
        FileSystemEntity(
          name: 'Proyectos',
          isDirectory: true,
          children: [
            FileSystemEntity(name: 'proyecto1.docx', isDirectory: false),
            FileSystemEntity(name: 'proyecto2.xlsx', isDirectory: false),
          ],
        ),
        FileSystemEntity(name: 'presupuesto.xlsx', isDirectory: false),
      ],
    ),
    FileSystemEntity(
      name: 'Imágenes',
      isDirectory: true,
      children: [
        FileSystemEntity(name: 'vacaciones.jpg', isDirectory: false),
        FileSystemEntity(
          name: 'Familia',
          isDirectory: true,
          children: [
            FileSystemEntity(name: 'cumpleaños.png', isDirectory: false),
            FileSystemEntity(name: 'navidad.jpg', isDirectory: false),
          ],
        ),
      ],
    ),
    FileSystemEntity(name: 'notas.txt', isDirectory: false),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Collections")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: ListView.builder(
          itemCount: demoData.length,
          itemBuilder: (context, index) {
            return CollectionTreeItem(
              entity: demoData[index],
              depth: 0,
              onTap: () {
                setState(() {
                  demoData[index].isExpanded = !demoData[index].isExpanded;
                });
              },
            );
          },
        ),
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
