let ShapeClassifier;      // Red neuronal
let canvas;               // Lienzo donde dibujamos
let resultDiv;            // Div donde mostramos el resultado
let inputImage;           // Imagen reescalada para la red
let clearButton;          // Botón para limpiar el lienzo

function setup() {
  // Crear lienzo principal
  canvas = createCanvas(400, 400);
  canvas.parent("canvasContainer");
  background(255);

  // Botón para limpiar
  clearButton = select('#limpiar');
  clearButton.mousePressed(() => {
    background(255);
  });
  clearButton.attribute('disabled', '');

  // Div para mostrar resultados
  resultDiv = select('#resultado');
  resultDiv.html('Cargando modelo...');

  // Crear gráfico auxiliar para la imagen de entrada
  inputImage = createGraphics(64, 64);

  // Opciones de la red neuronal
  let options = {
    inputs: [64, 64, 4],
    task: 'imageClassification'
  };

  // Inicializar la red neuronal
  ShapeClassifier = ml5.neuralNetwork(options);

  // Detalles del modelo entrenado
  const modelDetails = {
    model: 'model/model.json',
    metadata: 'model/model_meta.json',
    weights: 'model/model.weights.bin'
  };

  // Cargar el modelo
  ShapeClassifier.load(modelDetails, modelLoaded);
}

function modelLoaded() {
  console.log('Modelo cargado');
  resultDiv.html('Modelo cargado. Dibuja un triángulo.');
  clearButton.removeAttribute('disabled');
  classifyImage();
}

function classifyImage() {
  // Reescalar la imagen del canvas principal al tamaño de entrada de la red
  inputImage.copy(canvas, 0, 0, 400, 400, 0, 0, 64, 64);
  ShapeClassifier.classify({ image: inputImage }, gotResults);
}

function gotResults(error, results) {
  if (error) {
    console.error(error);
    resultDiv.html("Error en la clasificación");
    return;
  }
  // Mostrar el resultado más probable
  let etiqueta = results[0].label;
  let confianza = Math.round(results[0].confidence * 100);
  resultDiv.html(`<span style="color: #2196F3;">${etiqueta}</span> (${confianza}%)`);
  // Clasificar de nuevo para mantener el resultado actualizado
  setTimeout(classifyImage, 500);
}

function draw() {
  // Permitir dibujar con el mouse
  if (mouseIsPressed) {
    strokeWeight(8);
    stroke(0);
    line(mouseX, mouseY, pmouseX, pmouseY);
  }
}