
#include <Servo.h>

Servo servo;

int photocell = A2;
int photocellVal = 1024;
int led = 2;
int initialPhotocellVal = 0;

void setup() {
  
  // setup inputs, outputs, default states
  pinMode(led, OUTPUT);
  digitalWrite(led, LOW);

  servo.attach(9);
  servo.write(100);

  // initialize ambient light value
  photocellVal = analogRead(photocell);
  initialPhotocellVal = photocellVal;
}

void loop() {

  // read current ambient value
  photocellVal = analogRead(photocell);
  
  if(photocellVal <= initialPhotocellVal - 10) {
    
    // gate down
    digitalWrite(led, HIGH);
    servo.write(0);
    delay(5000);
    
  } else {

    // gate up
    digitalWrite(led, LOW);
    servo.write(100);
    delay(1000);
  }
}

