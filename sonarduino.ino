    /*

     Sonarduino: Sonar casero con Arduino y Processing
     Infinito por Descubrir Bahía Blanca
     https://github.com/ixdbahia/sonarduino

     Basado en código original de Dejan Nedelkovski / HowToMechatronics

    */

    // Incluimos la biblioteca para controlar el servomotor
    #include <Servo.h> 

    // Definimos los pines Trig/Ping y Echo del sensor ultrasónico
    const int trigPin = 10;
    const int echoPin = 11;

    // Variables para la duración y la distancia
    long duracion;
    int distancia;
    
    // Creamos un objeto para controlar el servomotor
    Servo miServo;

    void setup() {
      pinMode(trigPin, OUTPUT); // Configuramos el pin trigPin como una salida
      pinMode(echoPin, INPUT); // Configuramos el pin echoPin como una entrada
      Serial.begin(9600); // Inicializamos el puerto serie
      miServo.attach(12); // Definimos el pin donde conectamos el servomotor
    }

    void loop() {
    
      // Rotamos el servomotor de 15 a 165 grados
      for(int i = 15; i <= 165; i++){  
      miServo.write(i);
      delay(30);
      distancia = calculardistancia();// Llamamos a una función que calcula la distancia medida por el sensor ultrasónico para cada ángulo
      
      Serial.print(i); // Enviamos el ángulo actual a través del puerto serie
      Serial.print(","); // Agregamos un carácter adicional que será usado por la IDE de Processing al indexar los datos
      Serial.print(distancia); // Enviamos la distancia medida por el sensor actual a través del puerto serie 
      Serial.print("."); // Agregamos un carácter adicional que será usado por la IDE de Processing al indexar los datos
      }
    
      // Repetimos las instrucciones anteriores de 165 a 15 grados
      for(int i = 165; i > 15; i--){  
      miServo.write(i);
      delay(30);
      distancia = calculardistancia();
      Serial.print(i);
      Serial.print(",");
      Serial.print(distancia);
      Serial.print(".");
      }
    }

    // Función para calcular la distancia medida por el sensor ultrasónico
    int calculardistancia(){ 
      digitalWrite(trigPin, LOW); 
      delayMicroseconds(2);
      // Configuramos el pin trigPin con el valor HIGH (encendido) durante 10 microsegundos
      digitalWrite(trigPin, HIGH); 
      delayMicroseconds(10);
      digitalWrite(trigPin, LOW);
      // Leemos el valor del pin echoPin, que nos devuelve el tiempo de viaje de las ondas sonoras en microsegundos
      duracion = pulseIn(echoPin, HIGH); 
      distancia = duracion*0.034/2;
      return distancia;
    }