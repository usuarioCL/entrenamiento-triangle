int tamanoLienzo = 64;
String rutaGuardado = "data/";
int imagenesPorTipo = 300;
String[] tiposDeTriangulos = {
  "equilatero", "acutangulo_isosceles", "acutangulo_escaleno",
  "rectangulo_isosceles", "rectangulo_escaleno",
  "obtusangulo_isosceles", "obtusangulo_escaleno"
};
float margen = 2;

void settings() {
  size(tamanoLienzo, tamanoLienzo);
}

void setup() {
  for (String tipo : tiposDeTriangulos) {
    for (int i = 0; i < imagenesPorTipo; i++) {
      background(255);
      PVector[] pts = generarTriangulo(tipo);
      if (pts != null) {
        if (random(1) > 0.3) rotarTriangulo(pts);
        dibujarTrianguloManoAlzada(pts);
        save(rutaGuardado + tipo + "_" + i + ".png");
      }
    }
  }
  exit();
}

PVector[] generarTriangulo(String tipo) {
  float cx = random(margen+10, tamanoLienzo-margen-10);
  float cy = random(margen+10, tamanoLienzo-margen-10);
  float l1 = random(18, 40);
  float l2 = random(18, 40);
  float ang = random(PI/6, PI/1.2);

  if (tipo.equals("equilatero")) {
    float h = l1 * sqrt(3)/2;
    return new PVector[] {
      new PVector(cx, cy-h/2),
      new PVector(cx-l1/2, cy+h/2),
      new PVector(cx+l1/2, cy+h/2)
    };
  }
  if (tipo.equals("acutangulo_isosceles")) {
    return new PVector[] {
      new PVector(cx, cy-l1/2),
      new PVector(cx-l1/2, cy+l1/2),
      new PVector(cx+l1/2, cy+l1/2)
    };
  }
  if (tipo.equals("acutangulo_escaleno")) {
    return new PVector[] {
      new PVector(cx, cy),
      new PVector(cx+l1*cos(PI/3), cy+l1*sin(PI/3)),
      new PVector(cx+l2*cos(PI/2), cy+l2*sin(PI/2))
    };
  }
  if (tipo.equals("rectangulo_isosceles")) {
    return new PVector[] {
      new PVector(cx, cy),
      new PVector(cx+l1, cy),
      new PVector(cx, cy+l1)
    };
  }
  if (tipo.equals("rectangulo_escaleno")) {
    return new PVector[] {
      new PVector(cx, cy),
      new PVector(cx+l1, cy),
      new PVector(cx, cy+l2)
    };
  }
  if (tipo.equals("obtusangulo_isosceles")) {
    float angObt = PI*0.7;
    return new PVector[] {
      new PVector(cx, cy),
      new PVector(cx+l1, cy),
      new PVector(cx+l1*cos(angObt), cy+l1*sin(angObt))
    };
  }
  if (tipo.equals("obtusangulo_escaleno")) {
    float angObt = PI*0.8;
    return new PVector[] {
      new PVector(cx, cy),
      new PVector(cx+l1, cy),
      new PVector(cx+l2*cos(angObt), cy+l2*sin(angObt))
    };
  }
  return null;
}

void rotarTriangulo(PVector[] pts) {
  PVector c = new PVector();
  for (PVector p : pts) c.add(p);
  c.div(3);
  float a = random(TWO_PI);
  for (int i=0; i<3; i++) {
    float x = pts[i].x-c.x, y = pts[i].y-c.y;
    pts[i].x = c.x + x*cos(a) - y*sin(a);
    pts[i].y = c.y + x*sin(a) + y*cos(a);
    pts[i].x = constrain(pts[i].x, margen, tamanoLienzo-margen);
    pts[i].y = constrain(pts[i].y, margen, tamanoLienzo-margen);
  }
}

void dibujarTrianguloManoAlzada(PVector[] pts) {
  stroke(0); noFill();
  for (int i=0; i<3; i++) {
    PVector a = pts[i], b = pts[(i+1)%3];
    beginShape();
    for (float t=0; t<=1; t+=0.2) {
      float x = lerp(a.x, b.x, t) + random(-1,1);
      float y = lerp(a.y, b.y, t) + random(-1,1);
      vertex(x, y);
    }
    endShape();
  }
}