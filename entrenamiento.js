// Arrays para las imágenes
let equilatero = [];
let acutangulo_isosceles = [];
let acutangulo_escaleno = [];
let rectangulo_isosceles = [];
let rectangulo_escaleno = [];
let obtusangulo_isosceles = [];
let obtusangulo_escaleno = [];

// Objeto ml5
let ShapeClassifier;

function preload() {
  for (let i = 0; i < 300; i++) {
    equilatero[i] = loadImage(`data/equilatero_${i}.png`);
    acutangulo_isosceles[i] = loadImage(`data/acutangulo_isosceles_${i}.png`);
    acutangulo_escaleno[i] = loadImage(`data/acutangulo_escaleno_${i}.png`);
    rectangulo_isosceles[i] = loadImage(`data/rectangulo_isosceles_${i}.png`);
    rectangulo_escaleno[i] = loadImage(`data/rectangulo_escaleno_${i}.png`);
    obtusangulo_isosceles[i] = loadImage(`data/obtusangulo_isosceles_${i}.png`);
    obtusangulo_escaleno[i] = loadImage(`data/obtusangulo_escaleno_${i}.png`);
  }
}

function setup() {
  noCanvas();

  // Parámetros del clasificador
  let options = {
    inputs: [64, 64, 4], // 64x64 imágenes con 4 canales (RGBA)
    task: "imageClassification",
    debug: true,
  };

  // Inicialización de la red neuronal
  ShapeClassifier = ml5.neuralNetwork(options);

  // Añadir datos
  for (let i = 0; i < 300; i++) {
    // aprendizaje supervisado
    ShapeClassifier.addData({ image: equilatero[i] }, { label: "equilatero" });
    ShapeClassifier.addData(
      { image: acutangulo_isosceles[i] },
      { label: "acutangulo_isosceles" }
    );
    ShapeClassifier.addData(
      { image: acutangulo_escaleno[i] },
      { label: "acutangulo_escaleno" }
    );
    ShapeClassifier.addData(
      { image: rectangulo_isosceles[i] },
      { label: "rectangulo_isosceles" }
    );
    ShapeClassifier.addData(
      { image: rectangulo_escaleno[i] },
      { label: "rectangulo_escaleno" }
    );
    ShapeClassifier.addData(
      { image: obtusangulo_isosceles[i] },
      { label: "obtusangulo_isosceles" }
    );
    ShapeClassifier.addData(
      { image: obtusangulo_escaleno[i] },
      { label: "obtusangulo_escaleno" }
    );
  }

  // Normalización y entrenamiento
  ShapeClassifier.normalizeData();
  ShapeClassifier.train({ epochs: 50 }, finishedTraining);
}

function finishedTraining() {
  console.log("Entrenamiento finalizado.");
  // Guardar el modelo
  ShapeClassifier.save();
}
