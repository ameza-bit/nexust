# Nexust

<p align="center">
  <img src="assets/nexust_logo.png" alt="Nexust Logo" width="200"/>
</p>

<p align="center">
  <b>El punto central donde convergen todas tus APIs</b>
</p>

<p align="center">
  <a href="#características">Características</a> •
  <a href="#capturas-de-pantalla">Capturas de Pantalla</a> •
  <a href="#instalación">Instalación</a> •
  <a href="#uso">Uso</a> •
  <a href="#estructura-del-proyecto">Estructura</a> •
  <a href="#roadmap">Roadmap</a> •
  <a href="#contribuir">Contribuir</a> •
  <a href="#licencia">Licencia</a>
</p>

## Descripción

Nexust es un cliente REST avanzado multiplataforma desarrollado con Flutter que transforma la manera en que interactúas con APIs. Combina la potencia de clientes profesionales con una interfaz moderna, intuitiva y eficiente, diseñada para desarrolladores, testers y entusiastas de las APIs.

## Características

### Funcionalidades Principales

- ✅ Soporte completo para métodos HTTP (GET, POST, PUT, DELETE, PATCH, etc.)
- ✅ Gestión avanzada de colecciones y organización jerárquica
- ✅ Visualizador de respuestas con formato para JSON, XML, HTML y más
- ✅ Sistema de variables y entornos (desarrollo, pruebas, producción)
- ✅ Historial inteligente con búsqueda avanzada
- ✅ Pruebas automatizadas para validación de APIs
- ✅ Importación/exportación compatible con formatos estándar
- ✅ Experiencia multiplataforma (iOS, Android, Windows, macOS, Linux)

### Diferenciales

- 🚀 Interfaz optimizada con respuesta instantánea
- 🌙 Modo oscuro/claro con temas personalizables
- 📱 Diseño responsive para todas las pantallas
- 🔒 Gestión segura de tokens y credenciales
- 🔌 Trabajo offline con sincronización inteligente
- 💡 Autocompletado inteligente para URLs, headers y parameters

## Capturas de Pantalla

<p align="center">
  <img src="screenshots/dashboard.png" width="250" alt="Dashboard"/>
  <img src="screenshots/request_editor.png" width="250" alt="Editor de Solicitudes"/>
  <img src="screenshots/response_viewer.png" width="250" alt="Visualizador de Respuestas"/>
</p>

> Nota: Reemplazar con capturas de pantalla reales cuando estén disponibles.

## Tecnologías

- **Framework**: Flutter 3.29.0
- **Lenguaje**: Dart 3.7.0
- **Gestión de Estado**: [Bloc/Cubit](https://bloclibrary.dev/)
- **HTTP Client**: [Dio](https://pub.dev/packages/dio)
- **Almacenamiento Local**: [Hive](https://pub.dev/packages/hive)
- **Sintaxis Highlighting**: [flutter_highlight](https://pub.dev/packages/flutter_highlight)

## Instalación

### Prerrequisitos

- Flutter SDK (versión 3.29.0 o superior)
- Dart SDK (versión 3.7.0 o superior)
- IDE (VS Code, Android Studio o IntelliJ IDEA)

### Pasos para Instalación de Desarrollo

```bash
# Clonar el repositorio
git clone https://github.com/tu-usuario/nexust.git

# Navegar al directorio
cd nexust

# Obtener dependencias
flutter pub get

# Ejecutar en modo debug
flutter run
```

### Construcción de Binarios de Producción

```bash
# Android
flutter build apk --release

# iOS
flutter build ios --release

# Web
flutter build web --release

# Windows
flutter build windows --release

# macOS
flutter build macos --release

# Linux
flutter build linux --release
```

## Uso

### Crear una Nueva Solicitud

1. Haz clic en el botón "+" flotante desde la pantalla principal
2. Selecciona el método HTTP (GET, POST, etc.)
3. Ingresa la URL del endpoint
4. Configura los parámetros, headers o body según sea necesario
5. Presiona "Enviar" para ejecutar la solicitud

### Organizar en Colecciones

1. Ve a la pestaña "Colecciones" en la pantalla principal
2. Haz clic en "Nueva Colección"
3. Organiza tus solicitudes arrastrándolas a las colecciones
4. Crea subcarpetas para una mejor organización

### Configurar Entornos

1. Accede a la sección "Entornos" desde la configuración
2. Crea entornos para desarrollo, pruebas, producción, etc.
3. Define variables específicas para cada entorno
4. Cambia fácilmente entre entornos desde la barra superior

## Estructura del Proyecto

```
lib/
├── core/                   # Código central y utilitarios
│   ├── constants/          # Constantes de la aplicación
│   ├── errors/             # Manejo de errores
│   ├── network/            # Lógica de red básica
│   └── utils/              # Utilidades generales
├── data/                   # Capa de datos
│   ├── models/             # Modelos de datos
│   ├── repositories/       # Implementación de repositorios
│   └── sources/            # Fuentes de datos (local, remoto)
├── domain/                 # Lógica de negocio
│   ├── entities/           # Entidades del dominio
│   ├── repositories/       # Interfaces de repositorios
│   └── usecases/           # Casos de uso
├── presentation/           # Interfaz de usuario
│   ├── blocs/              # Gestión de estado (Blocs/Cubits)
│   ├── pages/              # Páginas de la aplicación
│   ├── widgets/            # Widgets reutilizables
│   └── themes/             # Temas y estilos
└── main.dart               # Punto de entrada
```

## Roadmap

- [ ] Versión 1.0.0 - Funcionalidades básicas (Solicitudes, Colecciones, Visualización)
- [ ] Versión 1.1.0 - Sistema de entornos y variables
- [ ] Versión 1.2.0 - Pruebas automatizadas
- [ ] Versión 1.3.0 - Sincronización en la nube
- [ ] Versión 2.0.0 - Generación de código para clientes API

## Contribuir

Las contribuciones son bienvenidas y apreciadas. Para contribuir:

1. Haz fork del proyecto
2. Crea una rama para tu característica (`git checkout -b feature/amazing-feature`)
3. Haz commit de tus cambios (`git commit -m 'Add some amazing feature'`)
4. Sube la rama (`git push origin feature/amazing-feature`)
5. Abre un Pull Request

Consulta el archivo [CONTRIBUTING.md](CONTRIBUTING.md) para conocer más detalles.

## Licencia

Este proyecto está licenciado bajo la Licencia MIT - consulta el archivo [LICENSE.md](LICENSE.md) para más detalles.

## Contacto

Armando Vigueras - [Axolotl Software](https://axolotl-software.com) - [Contacto](contacto@axolotl-software.com)

Link del Proyecto: [https://github.com/ameza-bit/nexust](https://github.com/ameza-bit/nexust)

---

<p align="center">
  Desarrollado con ❤️ utilizando Flutter
</p>
