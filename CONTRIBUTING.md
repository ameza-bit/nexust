# Contribuir a Nexust

¡Gracias por tu interés en contribuir a Nexust! Este documento proporciona directrices y pasos para contribuir al proyecto de manera efectiva.

## Índice

- [Código de Conducta](https://claude.ai/chat/0f600217-8f92-45a7-919d-2ee487109c6d#c%C3%B3digo-de-conducta)
- [Proceso de Contribución](https://claude.ai/chat/0f600217-8f92-45a7-919d-2ee487109c6d#proceso-de-contribuci%C3%B3n)
- [Configuración del Entorno de Desarrollo](https://claude.ai/chat/0f600217-8f92-45a7-919d-2ee487109c6d#configuraci%C3%B3n-del-entorno-de-desarrollo)
- [Estilo y Estándares de Código](https://claude.ai/chat/0f600217-8f92-45a7-919d-2ee487109c6d#estilo-y-est%C3%A1ndares-de-c%C3%B3digo)
- [Pruebas](https://claude.ai/chat/0f600217-8f92-45a7-919d-2ee487109c6d#pruebas)
- [Documentación](https://claude.ai/chat/0f600217-8f92-45a7-919d-2ee487109c6d#documentaci%C3%B3n)
- [Reportar Bugs](https://claude.ai/chat/0f600217-8f92-45a7-919d-2ee487109c6d#reportar-bugs)
- [Solicitudes de Funcionalidades](https://claude.ai/chat/0f600217-8f92-45a7-919d-2ee487109c6d#solicitudes-de-funcionalidades)
- [Proceso de Pull Request](https://claude.ai/chat/0f600217-8f92-45a7-919d-2ee487109c6d#proceso-de-pull-request)
- [Estructura del Proyecto](https://claude.ai/chat/0f600217-8f92-45a7-919d-2ee487109c6d#estructura-del-proyecto)
- [Comunidad](https://claude.ai/chat/0f600217-8f92-45a7-919d-2ee487109c6d#comunidad)

## Código de Conducta

Este proyecto y todos los participantes están regidos por nuestro [Código de Conducta](https://claude.ai/chat/CODE_OF_CONDUCT.md). Al participar, se espera que cumplas con este código. Por favor, reporta comportamientos inaceptables a [email@ejemplo.com].

## Proceso de Contribución

1. **Explorar Issues**: Comienza por explorar los issues abiertos en el repositorio.
2. **Seleccionar un Issue**: Comenta en un issue para indicar que estás trabajando en él.
3. **Hacer Fork del Proyecto**: Crea un fork del repositorio.
4. **Crear una Rama**: Crea una rama para tu contribución desde `develop`.
5. **Realizar Cambios**: Implementa tus cambios siguiendo las guías de estilo.
6. **Probar**: Ejecuta todas las pruebas y asegúrate de que pasan.
7. **Enviar Pull Request**: Envía un PR a la rama `develop` del repositorio principal.

## Configuración del Entorno de Desarrollo

### Prerrequisitos

- Flutter SDK (versión 3.29.0 o superior)
- Dart SDK (versión 3.7.0 o superior)
- IDE recomendado: VS Code o Android Studio
- Git

### Configuración Inicial

```bash
# Clonar el repositorio
git clone https://github.com/ameza-bit/nexust.git

# Navegar al directorio
cd nexust

# Configurar el remote upstream
git remote add upstream https://github.com/ameza-bit/nexust.git

# Obtener dependencias
flutter pub get

# Configurar Firebase (si es necesario)
flutterfire configure
```

### Configuración de Firebase

Para contribuir con las funcionalidades relacionadas con Firebase:

1. Crear un proyecto en la [Consola de Firebase](https://console.firebase.google.com/)
2. Habilitar Authentication y Firestore
3. Configurar las aplicaciones (Android, iOS, Web) según tu entorno de desarrollo
4. Copiar los archivos de configuración específicos de Firebase a las carpetas correspondientes

## Estilo y Estándares de Código

### Estilo de Código Dart

Seguimos las [convenciones oficiales de estilo de Dart](https://dart.dev/guides/language/effective-dart/style). Asegúrate de:

- Usar `lowerCamelCase` para nombres de variables y funciones
- Usar `UpperCamelCase` para nombres de clases y tipos
- Usar indentación de 2 espacios
- Limitar las líneas a 80 caracteres
- Incluir documentación para clases públicas y métodos

### Arquitectura

Seguimos los principios de Arquitectura Limpia:

- **lib/core/**: Código central y utilidades
- **lib/data/**: Capa de datos (modelos, repositorios, fuentes)
- **lib/domain/**: Lógica de negocio (entidades, casos de uso)
- **lib/presentation/**: Capa de UI (widgets, páginas, blocs)

### Gestión de Estado

Usamos BLoC/Cubit para la gestión de estado. Directrices:

- Los eventos deben ser inmutables
- Los estados deben ser clases con propiedades finales
- Mantener los bloques lógicos y enfocados en una responsabilidad

## Pruebas

Es importante incluir pruebas para todos los cambios:

- **Pruebas unitarias**: Para lógica de negocio y servicios
- **Pruebas de widgets**: Para componentes de UI complejos
- **Pruebas de integración**: Para flujos completos

```bash
# Ejecutar todas las pruebas
flutter test

# Ejecutar pruebas con cobertura
flutter test --coverage
```

## Documentación

- **Documentación de código**: Usa comentarios de documentación de Dart (`///`) para clases y métodos públicos
- **README y Wiki**: Actualiza la documentación relevante cuando añadas características nuevas
- **Ejemplos**: Proporciona ejemplos de código cuando sea apropiado

## Reportar Bugs

Cuando reportes un bug, incluye:

1. Descripción clara y concisa del problema
2. Pasos para reproducir el comportamiento
3. Comportamiento esperado vs. actual
4. Capturas de pantalla si aplica
5. Detalles del entorno (dispositivo, OS, versión de Flutter)
6. Posibles soluciones si las tienes

## Solicitudes de Funcionalidades

Las solicitudes de nuevas funcionalidades deben incluir:

1. Descripción clara del problema que resolverá la función
2. Casos de uso específicos
3. Bosquejo de la implementación (opcional)
4. Consideraciones sobre UX/UI
5. Impacto en el rendimiento o en otras partes del código

## Proceso de Pull Request

1. Actualiza tu fork con los cambios recientes del repositorio principal
   ```bash
   git fetch upstream
   git checkout develop
   git merge upstream/develop
   ```
2. Crea una rama para tu contribución
   ```bash
   git checkout -b feature/nombre-funcionalidad
   ```
3. Realiza tus cambios con commits significativos
   ```bash
   git commit -m "Descripción clara del cambio"
   ```
4. Sube tu rama y crea un PR contra la rama `develop` del repositorio principal
   ```bash
   git push origin feature/nombre-funcionalidad
   ```
5. En la descripción del PR:
   - Enlaza al issue relacionado
   - Describe los cambios realizados
   - Menciona cualquier dependencia nueva
   - Añade capturas si hay cambios visuales

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

## Convenciones de Nomenclatura

- **Archivos**: `snake_case.dart`
- **Clases**: `PascalCase`
- **Variables/Funciones**: `camelCase`
- **Constantes**: `kConstantName` o `CONSTANT_NAME`
- **Extensiones**: `extension_type.dart`

## Comunidad

- **Discusiones**: Participa en las discusiones del repositorio
- **Revisiones de código**: Ayuda revisando PRs de otros contribuidores
- **Compartir conocimiento**: Documentar soluciones a problemas comunes

---

¡Gracias por contribuir a hacer Nexust mejor para todos! Si tienes preguntas sobre estas guías, no dudes en crear un issue o contactar a los mantenedores.
