# Sistema de Clasificación de Triángulos con Machine Learning

Un sistema de clasificación de triángulos en tiempo real construido con p5.js y ml5.js que utiliza una red neuronal para identificar diferentes tipos de triángulos dibujados por los usuarios.

## 📖 Descripción del Proyecto

Este proyecto implementa un sistema completo de machine learning para la clasificación automática de triángulos. Consta de dos módulos principales:

1. **Módulo de Entrenamiento** - Entrena una red neuronal utilizando un dataset de imágenes de triángulos pre-generadas
2. **Módulo de Consumo** - Permite a los usuarios dibujar triángulos y obtener clasificaciones en tiempo real

El sistema puede clasificar 7 tipos diferentes de triángulos basándose en sus propiedades geométricas (longitud de lados y ángulos).

## 🎯 Tipos de Triángulos Clasificados

El sistema identifica los siguientes tipos de triángulos:

- **Equilátero** - Todos los lados iguales (3 lados iguales)
- **Acutángulo Isósceles** - Dos lados iguales, todos los ángulos < 90°
- **Acutángulo Escaleno** - Todos los lados diferentes, todos los ángulos < 90°
- **Rectángulo Isósceles** - Dos lados iguales, un ángulo = 90°
- **Rectángulo Escaleno** - Todos los lados diferentes, un ángulo = 90°
- **Obtusángulo Isósceles** - Dos lados iguales, un ángulo > 90°
- **Obtusángulo Escaleno** - Todos los lados diferentes, un ángulo > 90°

## 🛠️ Tecnologías Utilizadas

- **p5.js** - Librería de programación creativa para dibujo y manipulación de canvas
- **ml5.js** - Librería de machine learning construida sobre TensorFlow.js
- **HTML5 Canvas** - Para la interfaz de dibujo
- **Redes Neuronales** - Modelo de clasificación de imágenes

## 📁 Estructura del Proyecto

```
├── entrenamiento.html          # Interfaz de entrenamiento
├── entrenamiento.js           # Lógica de entrenamiento y creación del modelo
├── consume.html               # Interfaz de dibujo para usuarios
├── consume.js                 # Lógica de clasificación en tiempo real
├── data/                      # Dataset de entrenamiento (2100+ imágenes)
├── model/                     # Archivos del modelo entrenado
│   ├── model.json
│   ├── model_meta.json
│   └── model.weights.bin
├── GeneradorTriangulos.pde    # Script de Processing para generar datos
├── README.md                  # Este archivo
└── .gitignore                 # Configuración de Git
```

## 🚀 Instrucciones de Instalación y Ejecución

### Requisitos Previos

- Navegador web moderno con JavaScript habilitado
- Servidor web local (requerido para cargar archivos del modelo)
- Git (para clonar el repositorio)

### Paso 1: Clonar el Repositorio

```bash
# Clonar el repositorio desde GitHub
git clone https://github.com/tu-usuario/entrenamiento-triangle.git

# Navegar al directorio del proyecto
cd entrenamiento-triangle
```

### Paso 2: Configurar un Servidor Web Local

El proyecto requiere un servidor web local debido a las restricciones CORS para cargar archivos del modelo. Puedes usar cualquiera de las siguientes opciones:

#### Opción A: Usando Python (Recomendado)

```bash
# Python 3
python -m http.server 8000

# Python 2 (si no tienes Python 3)
python -m SimpleHTTPServer 8000
```

#### Opción B: Usando Node.js

```bash
# Instalar live-server globalmente (solo la primera vez)
npm install -g live-server

# Ejecutar el servidor
live-server --port=8000
```

#### Opción C: Usando PHP

```bash
php -S localhost:8000
```

### Paso 3: Ejecutar la Aplicación

Una vez que el servidor esté ejecutándose, abre tu navegador web y navega a:

#### Para Entrenar un Nuevo Modelo:

```
http://localhost:8000/entrenamiento.html
```

#### Para Usar el Sistema de Clasificación:

```
http://localhost:8000/consume.html
```

## 📚 Guía de Uso

### Entrenamiento del Modelo

1. Abre `entrenamiento.html` en tu navegador
2. El sistema cargará automáticamente 2100 imágenes de triángulos (300 por categoría)
3. El entrenamiento comenzará automáticamente con 50 épocas
4. Una vez completado, el modelo se guardará en el directorio `model/`
5. Verás mensajes en la consola del navegador indicando el progreso

### Uso del Sistema de Clasificación

1. Abre `consume.html` en tu navegador
2. Espera a que aparezca el mensaje "¡Modelo cargado!"
3. Dibuja un triángulo en el canvas usando el mouse
4. Al soltar el mouse, obtendrás una clasificación instantánea
5. El resultado mostrará el tipo de triángulo y el porcentaje de confianza
6. Usa el botón "Limpiar Canvas" para borrar y dibujar nuevamente

## 🧠 Arquitectura del Modelo

- **Capa de Entrada**: 64×64 píxeles con 4 canales (RGBA)
- **Tarea**: Clasificación de Imágenes
- **Datos de Entrenamiento**: 2100 imágenes de triángulos (300 por categoría)
- **Épocas de Entrenamiento**: 50
- **Framework**: Red Neuronal de ml5.js

## 📊 Dataset

El dataset de entrenamiento consiste en 2100 imágenes de triángulos generadas programáticamente:

- 300 imágenes por tipo de triángulo
- Resolución de 64×64 píxeles
- Formato PNG con fondos transparentes
- Generadas usando Processing (ver `GeneradorTriangulos.pde`)

## 🎨 Características Principales

- **Clasificación en Tiempo Real**: Resultados instantáneos mientras dibujas
- **Interfaz Interactiva**: Experiencia de dibujo fluida con mouse/táctil
- **Retroalimentación Visual**: Resultados codificados por color con porcentajes de confianza
- **Diseño Responsivo**: Interfaz limpia y moderna
- **Manejo de Errores**: Manejo robusto de errores y retroalimentación al usuario

## 🔧 Detalles Técnicos

### Proceso de Entrenamiento del Modelo

1. Cargar 2100 imágenes de triángulos pre-generadas
2. Crear red neuronal con tarea de clasificación de imágenes
3. Agregar datos de entrenamiento etiquetados para cada tipo de triángulo
4. Normalizar datos y entrenar por 50 épocas
5. Guardar modelo entrenado en el directorio `model/`

### Proceso de Clasificación

1. El usuario dibuja un triángulo en un canvas de 280×280
2. La imagen se redimensiona a 64×64 píxeles para coincidir con el formato de entrenamiento
3. La imagen se convierte al formato de objeto Image de p5.js
4. La red neuronal clasifica la imagen
5. Los resultados se muestran con el tipo de triángulo y porcentaje de confianza

## 🐛 Problemas Conocidos

- El modelo requiere un servidor web local debido a restricciones CORS
- El dibujo funciona mejor con mouse; el soporte táctil puede variar
- La precisión de clasificación depende de la calidad del dibujo y claridad del triángulo

