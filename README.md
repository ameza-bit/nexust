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

## Tecnologías

- **Framework**: Flutter 3.29.0
- **Lenguaje**: Dart 3.7.0
- **Gestión de Estado**: [Bloc/Cubit](https://bloclibrary.dev/)
- **HTTP Client**: [Dio](https://pub.dev/packages/dio)
- **Almacenamiento Local**: [Drift/Moor](https://pub.dev/packages/drift)
- **Base de Datos en la Nube**: [Cloud Firestore](https://firebase.google.com/products/firestore)
- **Autenticación**: [Firebase Authentication](https://firebase.google.com/products/auth)
- **Sintaxis Highlighting**: [flutter_code_editor](https://pub.dev/packages/flutter_code_editor)
- **Serialización JSON**: [json_serializable](https://pub.dev/packages/json_serializable)
- **Navegación**: [go_router](https://pub.dev/packages/go_router)

## Instalación

### Prerrequisitos

- Flutter SDK (versión 3.29.0 o superior)
- Dart SDK (versión 3.7.0 o superior)
- IDE (VS Code, Android Studio o IntelliJ IDEA)

### Pasos para Instalación de Desarrollo

```bash
# Clonar el repositorio
git clone https://github.com/ameza-bit/nexust.git

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

### Fase 1: Fundamentos (Q3 2025)

- [ ] **v0.1.0 - MVP**
  - Interfaz básica con soporte para métodos HTTP principales
  - Visualización simple de respuestas JSON/XML
  - Guardado local de solicitudes individuales
  - Soporte para plataformas móviles (Android/iOS)
- [ ] **v0.2.0 - Organización**
  - Sistema de colecciones y carpetas
  - Historial de solicitudes con búsqueda
  - Exportación/importación básica
  - Soporte inicial para escritorio (Windows/macOS)
- [ ] **v1.0.0 - Lanzamiento Estable**
  - Gestión completa de solicitudes y respuestas
  - UI/UX pulida con temas claro/oscuro
  - Documentación completa para usuarios
  - Soporte para todas las plataformas (+ Linux y Web)

### Fase 2: Avanzado (Q4 2025)

- [ ] **v1.1.0 - Productividad**
  - Sistema de entornos y variables
  - Autocompletado inteligente para URLs y headers
  - Snippets para body comunes (JSON, forms)
  - Modo fullscreen para análisis detallado
- [ ] **v1.2.0 - Testing**
  - Framework de pruebas automatizadas
  - Assertions y validaciones de respuestas
  - Ejecución programada de pruebas
  - Exportación de resultados e informes
- [ ] **v1.3.0 - Colaboración**
  - Sincronización en la nube
  - Compartir colecciones entre usuarios
  - Historial de cambios y versiones
  - Gestión de permisos básica

### Fase 3: Profesional (Q1-Q2 2026)

- [ ] **v2.0.0 - Herramientas pro**
  - Generación de código para clientes API (Dart, Kotlin, Swift, JS)
  - Análisis de rendimiento y métricas
  - Captura y replay de tráfico HTTP
  - Validación de esquemas OpenAPI/Swagger
- [ ] **v2.1.0 - Integración**
  - Integración con sistemas CI/CD
  - Conectores para servicios de API Gateway
  - Plugins y extensibilidad
  - API para integración con otras herramientas
- [ ] **v2.2.0 - Empresa**
  - Dashboard de equipo y analíticas
  - Gestión de acceso granular
  - SSO y autenticación empresarial
  - Auditoría y logging avanzado

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

Armando Vigueras - [Axolotl Software](https://axolotl-software.com) - [Contacto](mailto:contacto@axolotl-software.com)

Link del Proyecto: [https://github.com/ameza-bit/nexust](https://github.com/ameza-bit/nexust)

---

<p align="center">
  Desarrollado con ❤️ utilizando Flutter
</p>
