# Pokémon Mobile Flutter 📱

Una aplicación móvil multiplataforma desarrollada en **Flutter** que funciona como un explorador avanzado del ecosistema Pokémon. El propósito central de este proyecto es demostrar un dominio sólido en **Networking**, **Arquitectura de Software** y **Persistencia de Datos Híbrida**.

<p align="center">
<img src="https://i.imgur.com/B3leOoJ.png" alt="App Screenshot">
</p>

## 🚀 Propósito Técnico

Este proyecto aborda desafíos críticos del desarrollo móvil moderno mediante el desarrollo de funcionalidades como:

* **Persistencia Híbrida:** Implementación estratégica de una base de datos relacional con **Drift (SQLite)** para la colección capturada y **Shared Preferences** para la gestión eficiente de favoritos.
* **Networking Asíncrono:** Consumo optimizado de la [PokeAPI](https://pokeapi.co/), gestionando múltiples peticiones concurrentes para reducir la latencia.
* **Arquitectura Modular:** Organización del código bajo el principio de responsabilidad única (*Single Responsibility Principle*), facilitando la escalabilidad y el mantenimiento.
* **Optimización de Interfaz:** Implementación de *Lazy Loading* (Infinite Scroll) y diseño responsivo avanzado para garantizar fluidez visual y eficiencia en el consumo de memoria.

## ✨ Características Principales

* **Pokédex Infinita:** Navegación fluida por la primera generación con carga bajo demanda y gestión de estados de carga no bloqueantes.
* **Colección Persistente:** Sistema de captura que serializa y almacena objetos Pokémon complejos localmente, permitiendo el acceso total a los datos en modo offline.
* **Búsqueda Inteligente:** Localización por nombre o ID con un motor robusto de manejo de excepciones de red y validación de entradas en tiempo real.
* **Gestión de Favoritos:** Sincronización reactiva entre el estado global de la aplicación (**Provider**) y el almacenamiento local persistente.
* **UI Adaptativa:** Diseño basado en `LayoutBuilder` que normaliza la visualización de habilidades y métricas (sistema métrico) en una amplia gama de densidades de pantalla.

## 🛠️ Stack Tecnológico

* **Lenguaje:** Dart 🎯
* **Framework:** Flutter 💙
* **Gestión de Estado:** `Provider` (ChangeNotifier)
* **Base de Datos Local:** `Drift` (SQLite)
* **Almacenamiento Ligero:** `Shared_Preferences`
* **Networking:** `http`
* **Arquitectura:** Modular / Clean Code Principles

## 🏗️ Arquitectura del Proyecto

```text
lib/
├── Data/          # Definición de esquemas de BD (Drift) y constantes globales.
├── DataModel/     # Modelos de datos y lógica de serialización JSON.
├── Services/      # Lógica de negocio, Managers de estado y servicios de API.
├── Widgets/
│   ├── Cards/     # Componentes visuales y tarjetas responsivas.
│   └── Pages/     # Vistas y navegación principal.
└── main.dart      # Punto de entrada e inyección de dependencias.

```

## ⚙️ Desafíos Técnicos Superados

### 1. Sincronización y Persistencia de Datos

Se integró una arquitectura donde los gestores de estado actúan como puente hacia el almacenamiento persistente, garantizando una experiencia de usuario fluida y sin pérdida de datos mediante:

* **Shared Preferences:** Lectura síncrona de IDs de favoritos al arranque para una carga instantánea.
* **Drift/SQLite:** Persistencia de objetos complejos mediante una capa de acceso a datos (DAO) que asegura la integridad de estadísticas y habilidades.

### 2. Diseño Responsivo y Resolución de Overflows

Para mitigar errores de desbordamiento de `RenderFlex` y garantizar consistencia visual en cualquier dispositivo, se implementaron soluciones de layout dinámico:

* **LayoutBuilder:** Cálculo dinámico de dimensiones de imagen basado en el contexto de restricciones del padre.
* **SingleChildScrollView:** Garantía de accesibilidad al contenido detallado, permitiendo el desplazamiento interno en tarjetas cuando la longitud de los datos excede el límite visual.

## 💻 Cómo ejecutar

1. Clonar el repositorio.
2. Instalar las dependencias: `flutter pub get`.
3. Generar el código necesario para la base de datos:
   `dart run build_runner build`
4. Lanzar la aplicación: `flutter run`.

---

<p align="center">
<img src="https://i.imgur.com/NtemBd3.png" width="100" height="100" alt="Ícono del launcher">
</p>

<p align="center"> <a href="https://www.flaticon.es/icono-gratis/pokemon_15217930" title="pokemon iconos">Ícono de launcher creado por SBTS2018 - Flaticon</a> </p>

---

<p align="center">Desarrollado con ❤️ por <b>borj410</b>.</p>

---