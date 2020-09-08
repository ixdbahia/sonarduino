    /*

     Sonarduino: Sonar casero con Arduino y Processing
     Infinito por Descubrir Bahía Blanca
     https://github.com/ixdbahia/sonarduino

     Basado en código original de Dejan Nedelkovski / HowToMechatronics

    */

import processing.serial.*; // Importamos la biblioteca para comunicación serial
import java.awt.event.KeyEvent; // Importamos la biblioteca para leer los datos del puerto serie
import java.io.IOException;

Serial miPuerto; // Definimos el objeto Serial
// Definimos variables
String angulo="";
String distancia="";
String datos="";
String sinObjeto;
float pxDistancia;
int iAngulo, iDistancia;
int index1=0;
int index2=0;
PFont orcFont;

void setup() {
  
 size (1920, 1080); // Cambiar de acuerdo a la resolución de tu monitor
 smooth();
 miPuerto = new Serial(this,"COM4", 9600); // Inicializamos el puerto serie
 miPuerto.bufferUntil('.'); // Leemos los datos del puerto serie hasta el carácter '.', o sea que leemos: angulo,distancia
 orcFont = loadFont("OCRAExtended-30.vlw"); // Cargamos una fuente
}

void dibujar() {
  
  fill(98,245,31);
  textFont(orcFont);
  // Simulamos el movimiento de la línea del sonar
  noStroke();
  fill(0,4); 
  rect(0, 0, width, height-height*0.065); 
  
  // Color verde
  fill(98,245,31);

  // Llamamos a las funciones que dibujan el sonar
  dibujarSonar(); 
  dibujarLinea();
  dibujarObjeto();
  dibujarTexto();
}

// Comenzamos a leer datos desde el puerto serie
void serialEvent (Serial miPuerto) { 

  // Leemos los datos del puerto serie hasta el carácter "." y los asignamos a la variable "datos".
  datos = miPuerto.readStringUntil('.');
  datos = datos.substring(0,datos.length()-1);
  
  // Buscamos el carácter "," y lo asignamos a la variable "index1"
  index1 = datos.indexOf(",");

  // Leemos los datos desde la posición "0" hasta la posición de la variable "index1" = ese es el valor de ángulo enviado por el Arduino a través del puerto serie
  angulo = datos.substring(0, index1);

  // Leemos los datos desde la posición "index1" hasta el final de los datos = ese es el valor de distancia
  distancia= datos.substring(index1+1, datos.length()); 
  
  // Convertimos las variables de tipo String a tipo Integer
  iAngulo = int(angulo);
  iDistancia = int(distancia);
}

void dibujarSonar() {
  pushMatrix();
  // Movemos las coordenadas de inicio a una nueva ubicación
  translate(width/2,height-height*0.074); 
  noFill();
  strokeWeight(2);
  stroke(98,245,31);
  // Dibujamos los círculos
  arc(0,0,(width-width*0.0625),(width-width*0.0625),PI,TWO_PI);
  arc(0,0,(width-width*0.27),(width-width*0.27),PI,TWO_PI);
  arc(0,0,(width-width*0.479),(width-width*0.479),PI,TWO_PI);
  arc(0,0,(width-width*0.687),(width-width*0.687),PI,TWO_PI);
  // Dibujamos las líneas de los ángulos
  line(-width/2,0,width/2,0);
  line(0,0,(-width/2)*cos(radians(30)),(-width/2)*sin(radians(30)));
  line(0,0,(-width/2)*cos(radians(60)),(-width/2)*sin(radians(60)));
  line(0,0,(-width/2)*cos(radians(90)),(-width/2)*sin(radians(90)));
  line(0,0,(-width/2)*cos(radians(120)),(-width/2)*sin(radians(120)));
  line(0,0,(-width/2)*cos(radians(150)),(-width/2)*sin(radians(150)));
  line((-width/2)*cos(radians(30)),0,width/2,0);
  popMatrix();
}

void dibujarObjeto() {
  pushMatrix();
  // Movemos las coordenadas de inicio a una nueva ubicación
  translate(width/2,height-height*0.074);
  strokeWeight(9);

  // Color rojo
  stroke(255,10,10);
  pxDistancia = iDistancia*((height-height*0.1666)*0.025); // Cubrimos la distancia desde el sensor en centímetros, convirtiéndola a pixels

  // Limitamos el rango a 40 centímetros
  if(iDistancia<40){
    // Dibujamos el objeto de acuerdo a su ángulo y distancia
    line(pxDistancia*cos(radians(iAngulo)),-pxDistancia*sin(radians(iAngulo)),(width-width*0.505)*cos(radians(iAngulo)),-(width-width*0.505)*sin(radians(iAngulo)));
  }
  popMatrix();
}

void dibujarLinea() {
  pushMatrix();
  strokeWeight(9);
  stroke(30,250,60);
  // Movemos las coordenadas de inicio a una nueva ubicación
  translate(width/2,height-height*0.074);
  // Dibujamos la línea de acuerdo al ángulo
  line(0,0,(height-height*0.12)*cos(radians(iAngulo)),-(height-height*0.12)*sin(radians(iAngulo)));
  popMatrix();
}

void dibujarTexto() { // Dibujamos el texto en pantalla
  pushMatrix();
  if(iDistancia>40) {
    sinObjeto = "Fuera de rango";
  }
  else {
    sinObjeto = "Dentro del rango";
  }
  
  fill(0,0,0);
  noStroke();
  rect(0, height-height*0.0648, width, height);
  
  fill(98,245,31);
  textSize(25);
  text("10 cm",width-width*0.3854,height-height*0.0833);
  text("20 cm",width-width*0.281,height-height*0.0833);
  text("30 cm",width-width*0.177,height-height*0.0833);
  text("40 cm",width-width*0.0729,height-height*0.0833);

  textSize(40);
  text("Objeto: " + sinObjeto, width-width*0.875, height-height*0.0277);
  text("Ángulo: " + iAngulo +"°", width-width*0.48, height-height*0.0277);
  text("Distancia: ", width-width*0.26, height-height*0.0277);
  if(iDistancia<40) {
    text("        " + iDistancia +" cm", width-width*0.225, height-height*0.0277);
  }
  
  textSize(25);
  fill(98,245,60);
  translate((width-width*0.4994)+width/2*cos(radians(30)),(height-height*0.0907)-width/2*sin(radians(30)));
  rotate(-radians(-60));
  text("30°",0,0);
  resetMatrix();
  translate((width-width*0.503)+width/2*cos(radians(60)),(height-height*0.0888)-width/2*sin(radians(60)));
  rotate(-radians(-30));
  text("60°",0,0);
  resetMatrix();
  translate((width-width*0.507)+width/2*cos(radians(90)),(height-height*0.0833)-width/2*sin(radians(90)));
  rotate(radians(0));
  text("90°",0,0);
  resetMatrix();
  translate(width-width*0.513+width/2*cos(radians(120)),(height-height*0.07129)-width/2*sin(radians(120)));
  rotate(radians(-30));
  text("120°",0,0);
  resetMatrix();
  translate((width-width*0.5104)+width/2*cos(radians(150)),(height-height*0.0574)-width/2*sin(radians(150)));
  rotate(radians(-60));
  text("150°",0,0);
  popMatrix(); 
}