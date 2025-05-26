int tamanoLienzo = 64;
String rutaGuardado = "data/";
int imagenesPorTipo = 300; 
String[] tiposDeTriangulos = {"equilatero", "acutangulo_isosceles", "acutangulo_escaleno", "rectangulo_isosceles", "rectangulo_escaleno", "obtusangulo_isosceles", "obtusangulo_escaleno"};
float margen = 2;

float epsilonLado = 1.5; 
float toleranciaAngulo = 1.5e-3;

// Función auxiliar para calcular distancia al cuadrado
float distanciaCuadradaPuntos(PVector v1, PVector v2) {
  float dx = v1.x - v2.x;
  float dy = v1.y - v2.y;
  return dx*dx + dy*dy;
}

// FUNCIONES AUXILIARES DE CLASIFICACIÓN DE LADOS Y ÁNGULOS

boolean esEquilatero(PVector v1, PVector v2, PVector v3) {
  if (v1 == null || v2 == null || v3 == null) return false;
  float d12 = dist(v1.x, v1.y, v2.x, v2.y);
  float d23 = dist(v2.x, v2.y, v3.x, v3.y);
  float d31 = dist(v3.x, v3.y, v1.x, v1.y);
  return abs(d12 - d23) < epsilonLado && abs(d23 - d31) < epsilonLado;
}

boolean esIsoscelesBase(PVector v1, PVector v2, PVector v3) {
  if (v1 == null || v2 == null || v3 == null) return false;
  float d12 = dist(v1.x, v1.y, v2.x, v2.y);
  float d23 = dist(v2.x, v2.y, v3.x, v3.y);
  float d31 = dist(v3.x, v3.y, v1.x, v1.y);
  return abs(d12 - d23) < epsilonLado || abs(d23 - d31) < epsilonLado || abs(d31 - d12) < epsilonLado;
}

boolean esIsoscelesEstricto(PVector v1, PVector v2, PVector v3) {
  return esIsoscelesBase(v1, v2, v3) && !esEquilatero(v1, v2, v3);
}

boolean esEscaleno(PVector v1, PVector v2, PVector v3) {
  if (v1 == null || v2 == null || v3 == null) return false;
  float d12 = dist(v1.x, v1.y, v2.x, v2.y);
  float d23 = dist(v2.x, v2.y, v3.x, v3.y);
  float d31 = dist(v3.x, v3.y, v1.x, v1.y);
  return abs(d12 - d23) > epsilonLado && abs(d23 - d31) > epsilonLado && abs(d31 - d12) > epsilonLado;
}

boolean esRectoClasif(PVector v1, PVector v2, PVector v3) {
  if (v1 == null || v2 == null || v3 == null) return false;
  float d12_sq = distanciaCuadradaPuntos(v1, v2);
  float d23_sq = distanciaCuadradaPuntos(v2, v3);
  float d31_sq = distanciaCuadradaPuntos(v3, v1);

  if (d12_sq < 1e-4 || d23_sq < 1e-4 || d31_sq < 1e-4) return false;

  if (abs(d23_sq - (d12_sq + d31_sq)) <= toleranciaAngulo * max(d12_sq, d31_sq)) return true;
  if (abs(d31_sq - (d12_sq + d23_sq)) <= toleranciaAngulo * max(d12_sq, d23_sq)) return true;
  if (abs(d12_sq - (d23_sq + d31_sq)) <= toleranciaAngulo * max(d23_sq, d31_sq)) return true;
  
  return false;
}

boolean esAcutanguloClasif(PVector v1, PVector v2, PVector v3) {
  if (v1 == null || v2 == null || v3 == null) return false;
  float d12_sq = distanciaCuadradaPuntos(v1, v2);
  float d23_sq = distanciaCuadradaPuntos(v2, v3);
  float d31_sq = distanciaCuadradaPuntos(v3, v1);

  if (d12_sq < 1e-4 || d23_sq < 1e-4 || d31_sq < 1e-4) return false;

  boolean angulo1Agudo = (d12_sq + d31_sq - d23_sq) / (2 * sqrt(d12_sq * d31_sq)) > toleranciaAngulo; // cos(A) > 0
  boolean angulo2Agudo = (d12_sq + d23_sq - d31_sq) / (2 * sqrt(d12_sq * d23_sq)) > toleranciaAngulo; // cos(B) > 0
  boolean angulo3Agudo = (d23_sq + d31_sq - d12_sq) / (2 * sqrt(d23_sq * d31_sq)) > toleranciaAngulo; // cos(C) > 0
  
  return angulo1Agudo && angulo2Agudo && angulo3Agudo;
}

boolean esObtusoClasif(PVector v1, PVector v2, PVector v3) {
  if (v1 == null || v2 == null || v3 == null) return false;
  float d12_sq = distanciaCuadradaPuntos(v1, v2);
  float d23_sq = distanciaCuadradaPuntos(v2, v3);
  float d31_sq = distanciaCuadradaPuntos(v3, v1);

  if (d12_sq < 1e-4 || d23_sq < 1e-4 || d31_sq < 1e-4) return false;

  boolean angulo1Obtuso = (d12_sq + d31_sq - d23_sq) / (2 * sqrt(d12_sq * d31_sq)) < -toleranciaAngulo; // cos(A) < 0
  boolean angulo2Obtuso = (d12_sq + d23_sq - d31_sq) / (2 * sqrt(d12_sq * d23_sq)) < -toleranciaAngulo; // cos(B) < 0
  boolean angulo3Obtuso = (d23_sq + d31_sq - d12_sq) / (2 * sqrt(d23_sq * d31_sq)) < -toleranciaAngulo; // cos(C) < 0

  return angulo1Obtuso || angulo2Obtuso || angulo3Obtuso;
}


// FUNCIÓN AUXILIAR PARA CALCULAR ÁREA
float calcularAreaTriangulo(PVector v1, PVector v2, PVector v3) {
  if (v1 == null || v2 == null || v3 == null) return 0;
  return abs(v1.x*(v2.y-v3.y) + v2.x*(v3.y-v1.y) + v3.x*(v1.y-v2.y)) / 2.0;
}

// FUNCIÓN AUXILIAR PARA VALIDAR Y RESTRINGIR PUNTOS
PVector[] validarYRestringirPuntos(PVector p1Crudo, PVector p2Crudo, PVector p3Crudo, float umbralAreaMinima) {
  if (p1Crudo == null || p2Crudo == null || p3Crudo == null) return null;

  // Crear nuevos PVectors para los puntos restringidos para no modificar los originales.
  PVector[] puntosRestringidos = {
    new PVector(constrain(p1Crudo.x, margen, tamanoLienzo - margen), constrain(p1Crudo.y, margen, tamanoLienzo - margen)),
    new PVector(constrain(p2Crudo.x, margen, tamanoLienzo - margen), constrain(p2Crudo.y, margen, tamanoLienzo - margen)),
    new PVector(constrain(p3Crudo.x, margen, tamanoLienzo - margen), constrain(p3Crudo.y, margen, tamanoLienzo - margen))
  };

  float area = calcularAreaTriangulo(puntosRestringidos[0], puntosRestringidos[1], puntosRestringidos[2]);
  if (area < umbralAreaMinima) {
    return null;
  }
  return puntosRestringidos;
}

void settings() {
  size(tamanoLienzo, tamanoLienzo);
}

void setup() {
  // La llamada a size() se ha movido a settings()
  
  // Crear carpeta de salida
  java.io.File outputDir = new java.io.File(sketchPath(rutaGuardado));
  if (!outputDir.exists()) {
    outputDir.mkdirs();
  }
  
  for (String tipo : tiposDeTriangulos) {
    println("Generando " + imagenesPorTipo + " imágenes para el tipo: " + tipo);
    for (int i = 0; i < imagenesPorTipo; i++) {
      generarYGuardarTriangulo(tipo, i); 
    }
  }
  println("Finalizada la generación de " + (imagenesPorTipo * tiposDeTriangulos.length) + " imágenes.");
  exit(); // Cierra el programa al terminar
}

void draw() {
  // Vacío intencionalmente - no necesitamos un bucle draw() continuo
}

void generarYGuardarTriangulo(String tipo, int indice) { 
  background(255); 
  
  PVector[] puntos = obtenerPuntosTriangulo(tipo); 
  
  if (puntos == null) {
    println("Omitiendo generación de imagen para tipo: " + tipo + ", índice: " + indice + " ya que los puntos no se pudieron generar correctamente.");
    return; 
  }
  
  // MEJORA: Aplicar rotación aleatoria al triángulo (PRIORIDAD MEDIA)
  if(random(1) > 0.3) { // 70% de probabilidad de aplicar rotación
    rotarTriangulo(puntos);
  }
  
  // MEJORA: Variar más la escala de los triángulos (PRIORIDAD MEDIA)
  if(random(1) > 0.5) { // 50% de probabilidad de aplicar un escalado adicional
    escalarTriangulo(puntos, random(0.7, 1.1)); // Escalar entre 70% y 110%
  }
  
  // Color de relleno aleatorio - ELIMINADO PARA EVITAR DISTORSIÓN Y MEJORAR CONSISTENCIA
  // fill(random(170, 210), random(170, 210), random(170, 210), random(180, 230));
  
  // MEJORA: Dibujar con efecto de mano alzada (PRIORIDAD ALTA)
  dibujarTrianguloEfectoManoAlzada(puntos);
  
  save(rutaGuardado + tipo + "_" + indice + ".png"); 
}

// NUEVA FUNCIÓN: Rotación del triángulo (PRIORIDAD MEDIA)
void rotarTriangulo(PVector[] puntos) {
  // Encontrar el centro del triángulo
  PVector centro = new PVector(0, 0);
  for (PVector p : puntos) {
    centro.add(p);
  }
  centro.div(puntos.length);
  
  // Aplicar rotación aleatoria
  float angulo = random(TWO_PI); // Rotación completa aleatoria
  
  for (int i = 0; i < puntos.length; i++) {
    // Trasladar al origen, rotar y volver a la posición
    float x = puntos[i].x - centro.x;
    float y = puntos[i].y - centro.y;
    
    float xRotado = x * cos(angulo) - y * sin(angulo);
    float yRotado = x * sin(angulo) + y * cos(angulo);
    
    puntos[i].x = xRotado + centro.x;
    puntos[i].y = yRotado + centro.y;
    
    // Asegurar que esté dentro de los márgenes
    puntos[i].x = constrain(puntos[i].x, margen, tamanoLienzo - margen);
    puntos[i].y = constrain(puntos[i].y, margen, tamanoLienzo - margen);
  }
}

// NUEVA FUNCIÓN: Escalado del triángulo (PRIORIDAD MEDIA)
void escalarTriangulo(PVector[] puntos, float escala) {
  // Encontrar el centro del triángulo
  PVector centro = new PVector(0, 0);
  for (PVector p : puntos) {
    centro.add(p);
  }
  centro.div(puntos.length);
  
  // Aplicar escalado desde el centro
  for (int i = 0; i < puntos.length; i++) {
    PVector direccion = PVector.sub(puntos[i], centro);
    direccion.mult(escala);
    puntos[i] = PVector.add(centro, direccion);
    
    // Asegurar que esté dentro de los márgenes
    puntos[i].x = constrain(puntos[i].x, margen, tamanoLienzo - margen);
    puntos[i].y = constrain(puntos[i].y, margen, tamanoLienzo - margen);
  }
}

// NUEVA FUNCIÓN: Dibujo con efecto de mano alzada (PRIORIDAD ALTA)
void dibujarTrianguloEfectoManoAlzada(PVector[] puntos) {
  // Primero dibujamos el relleno como forma cerrada
  noFill(); // Asegurar que no haya relleno
  beginShape();
  for (PVector punto : puntos) {
    vertex(punto.x, punto.y);
  }
  endShape(CLOSE);
  
  // Luego dibujamos los bordes con efecto de mano alzada
  stroke(0);
  
  // Para cada línea del triángulo
  for (int i = 0; i < puntos.length; i++) {
    PVector inicio = puntos[i];
    PVector fin = puntos[(i + 1) % puntos.length];
    
    // Determinar cuántos puntos intermedios generar
    float longitudLinea = dist(inicio.x, inicio.y, fin.x, fin.y);
    int pasos = max(5, int(longitudLinea / 3));
    
    // Definir una variación del trazo
    float temblor = random(0.5, 1.5); // Qué tanto tiembla la mano
    
    beginShape();
    // strokeWeight(random(11, 13)); // Grosor del trazo principal para el segmento, similar a consume.html MODIFICADO
    strokeWeight(random(1, 2)); // Reducido drásticamente: Grosor del trazo principal
    
    // Punto inicial con ligera variación
    vertex(inicio.x + random(-temblor/2, temblor/2), inicio.y + random(-temblor/2, temblor/2));
    
    // Puntos intermedios con temblor
    for (int j = 1; j < pasos; j++) {
      float t = j / float(pasos);
      float x = lerp(inicio.x, fin.x, t) + random(-temblor, temblor);
      float y = lerp(inicio.y, fin.y, t) + random(-temblor, temblor);
      // strokeWeight(random(10, 14)); // Variación ligera del grosor durante el temblor MODIFICADO
      strokeWeight(random(1, 2)); // Reducido drásticamente: Variación ligera del grosor durante el temblor
      vertex(x, y);
    }
    
    // Punto final con ligera variación
    vertex(fin.x + random(-temblor/2, temblor/2), fin.y + random(-temblor/2, temblor/2));
    endShape();
    
    // Ocasionalmente, dibujar un pequeño sobrepasado en las esquinas (PRIORIDAD ALTA)
    if (random(1) > 0.7) {
      PVector dir = PVector.sub(fin, inicio).normalize().mult(random(1, 3));
      line(fin.x, fin.y, fin.x + dir.x, fin.y + dir.y);
    }
    
    // Ocasionalmente, dejar pequeños espacios en el trazo (PRIORIDAD ALTA)
    if (random(1) > 0.8) {
      float inicioHueco = random(0.2, 0.8); // Posición relativa del inicio del hueco
      float longitudHueco = random(0.05, 0.15); // Longitud relativa del hueco
      
      float x1 = lerp(inicio.x, fin.x, inicioHueco);
      float y1 = lerp(inicio.y, fin.y, inicioHueco);
      float x2 = lerp(inicio.x, fin.x, inicioHueco + longitudHueco);
      float y2 = lerp(inicio.y, fin.y, inicioHueco + longitudHueco);
      
      // Dibujamos un pequeño segmento del color de fondo para crear el "hueco"
      stroke(255); // Color del fondo
      // strokeWeight(random(12, 15)); // Un poco más grueso para asegurar que el hueco se vea bien MODIFICADO
      strokeWeight(random(2, 3)); // Reducido: Un poco más grueso para asegurar que el hueco se vea bien
      line(x1, y1, x2, y2);
      stroke(0); // Volver al color negro para el resto del trazo
    }
  }
}

PVector[] obtenerPuntosTriangulo(String tipo) {
  switch (tipo) {
    case "equilatero":
      return generarPuntosEquilatero();
    case "acutangulo_isosceles":
      return generarPuntosAcutangulo(true);
    case "acutangulo_escaleno":
      return generarPuntosAcutangulo(false);
    case "rectangulo_isosceles":
      return generarPuntosRectangulo(true);
    case "rectangulo_escaleno":
      return generarPuntosRectangulo(false);
    case "obtusangulo_isosceles":
      return generarPuntosObtusangulo(true);
    case "obtusangulo_escaleno":
      return generarPuntosObtusangulo(false);
    default:
      println("Tipo de triángulo desconocido o no combinado: " + tipo);
      return null;
  }
}

PVector[] generarPuntosEquilatero() {
  float lado = random(20, 50); 
  float h = lado * sqrt(3) / 2; 
  
  float cx_bb_min = margen + lado/2;
  float cx_bb_max = tamanoLienzo - margen - lado/2;
  float cy_bb_min = margen + h/2;
  float cy_bb_max = tamanoLienzo - margen - h/2;

  if (cx_bb_min >= cx_bb_max || cy_bb_min >= cy_bb_max) {
      //println("Equilateral fallback, canvas too small");
      return new PVector[]{new PVector(tamanoLienzo/2, margen), new PVector(margen, tamanoLienzo-margen), new PVector(tamanoLienzo-margen, tamanoLienzo-margen)}; // Fallback muy simple
  }
  
  float cx_bb = random(cx_bb_min, cx_bb_max); 
  float cy_bb = random(cy_bb_min, cy_bb_max);   
  
  PVector p1 = new PVector(cx_bb - lado / 2, cy_bb + h / 2); 
  PVector p2 = new PVector(cx_bb + lado / 2, cy_bb + h / 2); 
  PVector p3 = new PVector(cx_bb, cy_bb - h / 2);           
  
  // Validar y restringir puntos generados para equilátero también
  PVector[] puntosValidados = validarYRestringirPuntos(p1, p2, p3, 30.0f);
  if (puntosValidados == null || !esEquilatero(puntosValidados[0], puntosValidados[1], puntosValidados[2])) {
      // Fallback simple si la validación falla (raro para equilátero con esta generación)
      println("Fallo en validación de equilátero, usando fallback simple. Tipo: equilatero");
      return new PVector[]{new PVector(tamanoLienzo/2, margen), new PVector(margen, tamanoLienzo-margen), new PVector(tamanoLienzo-margen, tamanoLienzo-margen)};
  }
  return puntosValidados;
}

// FUNCIONES DE GENERACIÓN CONSOLIDADAS

PVector[] generarPuntosAcutangulo(boolean esIsosceles) {
  PVector p1 = null, p2 = null, p3 = null;
  int intentos = 0;
  int maxIntentos = esIsosceles ? 300 : 350;
  boolean exito = false;

  while (intentos < maxIntentos && !exito) {
    PVector[] puntosCandidatos = null;
    if (esIsosceles) {
      float base = random(15, 48); 
      float alturaVal = random(10, (tamanoLienzo - 2 * margen) * 0.45f); 
      alturaVal = max(8, alturaVal); 
      if (base < 8) base = max(base, 10);

      if (abs(alturaVal - base * sqrt(3)/2) < epsilonLado) {
        alturaVal += random(1) > 0.5 ? (epsilonLado + 1) : -(epsilonLado + 1);
        alturaVal = constrain(alturaVal, 8, (tamanoLienzo - 2 * margen) * 0.45f);
      }

      float cxMin = margen + base / 2;
      float cxMax = tamanoLienzo - margen - base / 2;
      if (cxMin >= cxMax) { intentos++; continue; }
      float cx = random(cxMin, cxMax);

      float cyBase, apiceY;
      if (random(1) > 0.5) { 
          apiceY = random(margen, tamanoLienzo - margen - alturaVal - margen); 
          cyBase = apiceY + alturaVal;
      } else { 
          cyBase = random(margen + alturaVal, tamanoLienzo - margen);
          apiceY = cyBase - alturaVal;
      }
      PVector p1Crudo = new PVector(cx - base / 2, cyBase);
      PVector p2Crudo = new PVector(cx + base / 2, cyBase);
      PVector p3Crudo = new PVector(cx, apiceY);
      puntosCandidatos = validarYRestringirPuntos(p1Crudo, p2Crudo, p3Crudo, 30.0f);
      if (puntosCandidatos != null && esIsoscelesEstricto(puntosCandidatos[0], puntosCandidatos[1], puntosCandidatos[2]) && esAcutanguloClasif(puntosCandidatos[0], puntosCandidatos[1], puntosCandidatos[2])) {
        p1 = puntosCandidatos[0]; p2 = puntosCandidatos[1]; p3 = puntosCandidatos[2];
        exito = true;
      }
    } else { // Escaleno
      float minLado = 10; 
      float maxDispersion = 22; 
      float umbralAreaMinima = (minLado * minLado / 2.5f);

      float centroX = random(margen + maxDispersion, tamanoLienzo - margen - maxDispersion);
      float centroY = random(margen + maxDispersion, tamanoLienzo - margen - maxDispersion);
      
      PVector p1Crudo = new PVector(centroX + random(-maxDispersion, maxDispersion), centroY + random(-maxDispersion, maxDispersion));
      PVector p2Crudo = new PVector(centroX + random(-maxDispersion, maxDispersion), centroY + random(-maxDispersion, maxDispersion));
      PVector p3Crudo = new PVector(centroX + random(-maxDispersion, maxDispersion), centroY + random(-maxDispersion, maxDispersion));
      
      puntosCandidatos = validarYRestringirPuntos(p1Crudo, p2Crudo, p3Crudo, umbralAreaMinima);
      if (puntosCandidatos != null) {
        float d12 = dist(puntosCandidatos[0].x, puntosCandidatos[0].y, puntosCandidatos[1].x, puntosCandidatos[1].y);
        float d23 = dist(puntosCandidatos[1].x, puntosCandidatos[1].y, puntosCandidatos[2].x, puntosCandidatos[2].y);
        float d31 = dist(puntosCandidatos[2].x, puntosCandidatos[2].y, puntosCandidatos[0].x, puntosCandidatos[0].y);
        boolean ladosOk = d12 > minLado && d23 > minLado && d31 > minLado;
        if (ladosOk && esEscaleno(puntosCandidatos[0], puntosCandidatos[1], puntosCandidatos[2]) && esAcutanguloClasif(puntosCandidatos[0], puntosCandidatos[1], puntosCandidatos[2])) {
          p1 = puntosCandidatos[0]; p2 = puntosCandidatos[1]; p3 = puntosCandidatos[2];
          exito = true;
        }
      }
    }
    intentos++;
  }
  if (!exito) {
    println("Fallo al generar TrianguloAcutangulo (" + (esIsosceles ? "Isosceles" : "Escaleno") + ") después de " + intentos + " intentos.");
    return null; 
  }
  return new PVector[]{p1, p2, p3};
}

PVector[] generarPuntosRectangulo(boolean esIsosceles) {
  PVector pEsquina = null, pCateto1Fin = null, pCateto2Fin = null;
  int intentos = 0;
  int maxIntentos = esIsosceles ? 250 : 350;
  boolean exito = false;

  while (intentos < maxIntentos && !exito) {
    float longitudCateto1, longitudCateto2;
    if (esIsosceles) {
      longitudCateto1 = random(18, (min(tamanoLienzo, tamanoLienzo) - 2 * margen) * 0.7f);
      longitudCateto1 = max(12, longitudCateto1);
      longitudCateto2 = longitudCateto1;
    } else { // Escaleno
      longitudCateto1 = random(12, (tamanoLienzo - 2 * margen) * 0.8f);
      longitudCateto2 = random(12, (tamanoLienzo - 2 * margen) * 0.8f); // height es tamanoLienzo
      longitudCateto1 = max(10, longitudCateto1);
      longitudCateto2 = max(10, longitudCateto2);

      if (abs(longitudCateto1 - longitudCateto2) < epsilonLado + 3.0) {
        longitudCateto2 += (longitudCateto1 > longitudCateto2) ? -(epsilonLado + 3.1) : (epsilonLado + 3.1);
        longitudCateto2 = constrain(longitudCateto2, 10, (tamanoLienzo - 2*margen) * 0.8f);
        if (abs(longitudCateto1 - longitudCateto2) < epsilonLado + 3.0) {intentos++; continue;}
      }
    }

    float esquinaXCruda = random(margen, tamanoLienzo - margen);
    float esquinaYCruda = random(margen, tamanoLienzo - margen);
    PVector tempEsquinaCruda = new PVector(esquinaXCruda, esquinaYCruda);
    PVector tempCateto1FinCrudo, tempCateto2FinCrudo;

    float[] dirs = {-1, 1};
    float dirMultX = dirs[int(random(2))]; 
    float dirMultY = dirs[int(random(2))]; 

    if (random(1) > 0.5) { // Cateto 1 a lo largo de X, Cateto 2 a lo largo de Y
        tempCateto1FinCrudo = new PVector(esquinaXCruda + dirMultX * longitudCateto1, esquinaYCruda);
        tempCateto2FinCrudo = new PVector(esquinaXCruda, esquinaYCruda + dirMultY * longitudCateto2);
    } else { // Cateto 1 a lo largo de Y, Cateto 2 a lo largo de X
        tempCateto1FinCrudo = new PVector(esquinaXCruda, esquinaYCruda + dirMultY * longitudCateto1);
        tempCateto2FinCrudo = new PVector(esquinaXCruda + dirMultX * longitudCateto2, esquinaYCruda);
    }
    
    PVector[] puntosValidados = validarYRestringirPuntos(tempEsquinaCruda, tempCateto1FinCrudo, tempCateto2FinCrudo, 30.0f);

    if (puntosValidados != null) {
      boolean condicionLadosOk = true;
      if (esIsosceles) {
        if (distanciaCuadradaPuntos(puntosValidados[1], puntosValidados[2]) < longitudCateto1 * longitudCateto1 * 0.1f) { 
            condicionLadosOk = false;
        }
      } else { 
        if (distanciaCuadradaPuntos(puntosValidados[0], puntosValidados[1]) < 100 || 
            distanciaCuadradaPuntos(puntosValidados[0], puntosValidados[2]) < 100 || 
            distanciaCuadradaPuntos(puntosValidados[1], puntosValidados[2]) < 100) {
            condicionLadosOk = false;
        }
      }

      if (condicionLadosOk && esRectoClasif(puntosValidados[0], puntosValidados[1], puntosValidados[2])) {
        boolean clasifLadosOk = false;
        if (esIsosceles && esIsoscelesBase(puntosValidados[0], puntosValidados[1], puntosValidados[2])) { // esIsoscelesBase es suficiente ya que un equilátero no puede ser rectángulo
            clasifLadosOk = true;
        } else if (!esIsosceles && esEscaleno(puntosValidados[0], puntosValidados[1], puntosValidados[2])) {
            clasifLadosOk = true;
        }
        
        if (clasifLadosOk) {
            pEsquina = puntosValidados[0]; pCateto1Fin = puntosValidados[1]; pCateto2Fin = puntosValidados[2];
            exito = true;
        }
      }
    }
    intentos++;
  }
  if (!exito) {
    println("Fallo al generar TrianguloRectangulo (" + (esIsosceles ? "Isosceles" : "Escaleno") + ") después de " + intentos + " intentos.");
    return null;
  }
  return new PVector[]{pEsquina, pCateto1Fin, pCateto2Fin};
}

PVector[] generarPuntosObtusangulo(boolean esIsosceles) {
  PVector p1 = null, p2 = null, p3 = null;
  int intentos = 0;
  int maxIntentos = esIsosceles ? 300 : 400;
  boolean exito = false;

  while (intentos < maxIntentos && !exito) {
    PVector[] puntosCandidatos = null;
    if (esIsosceles) {
      float ladoIgual = random(15, (min(tamanoLienzo, tamanoLienzo) - 2*margen) * 0.4f); 
      ladoIgual = max(12, ladoIgual);
      float anguloObtusoRad = random(PI/2 + 0.25, PI - 0.25); 

      float apiceXCrudo = random(margen, tamanoLienzo - margen); 
      float apiceYCrudo = random(margen, tamanoLienzo - margen);
      PVector tempApiceCrudo = new PVector(apiceXCrudo, apiceYCrudo);

      float anguloOffset = random(TWO_PI); 
      PVector tempV1Crudo = new PVector(apiceXCrudo + ladoIgual * cos(anguloOffset), apiceYCrudo + ladoIgual * sin(anguloOffset));
      PVector tempV2Crudo = new PVector(apiceXCrudo + ladoIgual * cos(anguloOffset + anguloObtusoRad), apiceYCrudo + ladoIgual * sin(anguloOffset + anguloObtusoRad));
      
      puntosCandidatos = validarYRestringirPuntos(tempApiceCrudo, tempV1Crudo, tempV2Crudo, 30.0f);
      if (puntosCandidatos != null) {
        if (distanciaCuadradaPuntos(puntosCandidatos[1], puntosCandidatos[2]) < ladoIgual*ladoIgual*0.1f ) { 
            intentos++; continue;
        }
        if (esObtusoClasif(puntosCandidatos[0], puntosCandidatos[1], puntosCandidatos[2]) && esIsoscelesEstricto(puntosCandidatos[0], puntosCandidatos[1], puntosCandidatos[2])) {
          p1 = puntosCandidatos[0]; p2 = puntosCandidatos[1]; p3 = puntosCandidatos[2];
          exito = true;
        }
      }
    } else { // Escaleno
      float minLadoSq = 10*10;
      float dispersion = random(15, (min(tamanoLienzo,tamanoLienzo) - 2*margen)/2.2f);
      float cxCrudo = random(margen + dispersion, tamanoLienzo - margen - dispersion);
      float cyCrudo = random(margen + dispersion, tamanoLienzo - margen - dispersion);

      PVector tempP1Crudo = new PVector(cxCrudo + random(-dispersion, dispersion), cyCrudo + random(-dispersion, dispersion));
      PVector tempP2Crudo = new PVector(cxCrudo + random(-dispersion, dispersion), cyCrudo + random(-dispersion, dispersion));
      PVector tempP3Crudo = new PVector(cxCrudo + random(-dispersion, dispersion), cyCrudo + random(-dispersion, dispersion));

      puntosCandidatos = validarYRestringirPuntos(tempP1Crudo, tempP2Crudo, tempP3Crudo, 40.0f);
      if (puntosCandidatos != null) {
        if (distanciaCuadradaPuntos(puntosCandidatos[0],puntosCandidatos[1]) < minLadoSq || 
            distanciaCuadradaPuntos(puntosCandidatos[1],puntosCandidatos[2]) < minLadoSq || 
            distanciaCuadradaPuntos(puntosCandidatos[2],puntosCandidatos[0]) < minLadoSq) { 
            intentos++; continue;
        }
        if (esObtusoClasif(puntosCandidatos[0], puntosCandidatos[1], puntosCandidatos[2]) && esEscaleno(puntosCandidatos[0], puntosCandidatos[1], puntosCandidatos[2])) {
          p1 = puntosCandidatos[0]; p2 = puntosCandidatos[1]; p3 = puntosCandidatos[2];
          exito = true;
        }
      }
    }
    intentos++;
  }
  if (!exito) {
    println("Fallo al generar TrianguloObtusangulo (" + (esIsosceles ? "Isosceles" : "Escaleno") + ") después de " + intentos + " intentos.");
    return null; 
  }
  return new PVector[]{p1, p2, p3};
}