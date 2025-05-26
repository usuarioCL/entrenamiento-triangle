// Objeto ml5
let ShapeClassifier;
let canvas;
let modeloListo = false;

function setup() {
  // Crear canvas
  canvas = createCanvas(280, 280);
  canvas.parent("canvasContainer");
  background(255);

  // Configurar botón de limpiar
  let botonLimpiar = select("#limpiar");
  botonLimpiar.mousePressed(limpiarCanvas);
  botonLimpiar.removeAttribute("disabled");

  // Permitir dibujar inmediatamente
  let resultado = select("#resultado");
  resultado.html("Cargando modelo... Puedes dibujar mientras tanto!");

  // Cargar el modelo
  cargarModelo();
}

function cargarModelo() {
  console.log("Iniciando carga del modelo...");

  // Crear neural network con las mismas opciones que en entrenamiento
  let opciones = {
    inputs: [64, 64, 4],
    task: "imageClassification",
    debug: true,
  };

  ShapeClassifier = ml5.neuralNetwork(opciones);
  console.log("Neural Network creado");
  // Cargar especificando el archivo JSON directamente
  ShapeClassifier.load(
    "model/model.json",
    function () {
      console.log("Modelo cargado correctamente");
      console.log("ShapeClassifier después de cargar:", ShapeClassifier);
      console.log("Método classify disponible:", !!ShapeClassifier.classify);
      modeloListo = true;
      let resultado = select("#resultado");
      resultado.html("¡Modelo cargado! Dibuja un triángulo para clasificar.");
    },
    function (error) {
      console.error("Error cargando modelo:", error);
      // Intentar método alternativo
      cargarModeloAlternativo();
    }
  );
}

function cargarModeloAlternativo() {
  console.log("Intentando método alternativo...");

  // Recrear el neural network
  let opciones = {
    inputs: [64, 64, 4],
    task: "imageClassification",
    debug: true,
  };

  ShapeClassifier = ml5.neuralNetwork(opciones);

  // Intentar cargar especificando solo la carpeta
  ShapeClassifier.load(
    "model/",
    function () {
      console.log("Modelo cargado con método alternativo");
      modeloListo = true;
      let resultado = select("#resultado");
      resultado.html("¡Modelo cargado! Dibuja un triángulo para clasificar.");
    },
    function (error) {
      console.error("Error con método alternativo:", error);
      let resultado = select("#resultado");
      resultado.html(
        "Error: No se pudo cargar el modelo. Verifica los archivos."
      );
    }
  );
}

function draw() {
  // Permitir dibujar siempre
  if (mouseIsPressed) {
    strokeWeight(8);
    stroke(0);
    line(pmouseX, pmouseY, mouseX, mouseY);
  }
}

function mouseReleased() {
  // Clasificar solo si el modelo está listo
  if (modeloListo) {
    setTimeout(clasificar, 100);
  }
}

function clasificar() {
  if (!modeloListo) return;

  // Crear una imagen p5 desde el canvas principal
  let img = createImage(64, 64);
  img.loadPixels(); // Cargar pixels antes de copiar
  img.copy(canvas, 0, 0, canvas.width, canvas.height, 0, 0, 64, 64);
  img.updatePixels(); // Actualizar después de copiar

  // Mostrar que está clasificando
  let resultado = select("#resultado");
  resultado.html("Clasificando...");

  try {
    // Verificar que ShapeClassifier y su método classify existen
    if (!ShapeClassifier || !ShapeClassifier.classify) {
      console.error(
        "ShapeClassifier no está disponible o no tiene método classify"
      );
      resultado.html("Error: Modelo no disponible");
      return;
    }

    console.log("Clasificando con imagen p5");
    console.log("Imagen p5:", img);

    // Usar el formato correcto que espera el modelo: { image: p5Image }
    ShapeClassifier.classify({ image: img }, function (err, res) {
      console.log("Callback de clasificación ejecutado");
      console.log("Error callback:", err);
      console.log("Resultado callback:", res);
      mostrarResultado(err, res);
    });
  } catch (error) {
    console.error("Error en clasificar:", error);
    resultado.html("Error al procesar imagen");
  }
}

function mostrarResultado(error, results) {
  console.log("Callback mostrarResultado ejecutado");
  console.log("Error recibido:", error);
  console.log("Results recibidos:", results);
  console.log("Tipo de results:", typeof results);
  console.log("Es array results:", Array.isArray(results));

  let resultado = select("#resultado");

  if (error) {
    console.error("Error en clasificación:", error);
    resultado.html("Error en la clasificación");
    return;
  }

  // Verificar múltiples formatos posibles de respuesta
  if (results) {
    if (Array.isArray(results) && results.length > 0 && results[0]) {
      let label = results[0].label || results[0].className || "sin_etiqueta";
      let confianza = Math.round(
        (results[0].confidence || results[0].value || 0) * 100
      );
      resultado.html(
        `<span style="color: #2196F3;">${label}</span> (${confianza}%)`
      );
    } else if (results.label || results.className) {
      // Si results no es un array pero tiene label directamente
      let label = results.label || results.className;
      let confianza = Math.round(
        (results.confidence || results.value || 0) * 100
      );
      resultado.html(
        `<span style="color: #2196F3;">${label}</span> (${confianza}%)`
      );
    } else {
      console.error("Formato de results no reconocido:", results);
      resultado.html("Resultado en formato no reconocido");
    }
  } else {
    resultado.html("No se pudo clasificar - sin resultados");
  }
}

function limpiarCanvas() {
  background(255);
  let resultado = select("#resultado");
  if (modeloListo) {
    resultado.html("¡Dibuja un triángulo para clasificar!");
  } else {
    resultado.html("Cargando modelo... Puedes dibujar mientras tanto!");
  }
}
