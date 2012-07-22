int pos;
char buffer[128];

void setup() {
  Serial.begin(9600);

  pos = 0;
  for (int i = 0; i < sizeof(buffer); i++) {
    buffer[i] = 0;
  }
}

void loop() {
  char c;

  if (Serial.available() > 0) {
    c = Serial.read();

    if (c == '\n' || c == ':') {
      buffer[pos] = 0;
      Serial.print("Arduino received: ");
      Serial.println(buffer);
      pos = 0;

    } else {
      buffer[pos] = c;
      pos++;

      if (pos >= sizeof(buffer)) {
        pos = 0;
      }
    }
  }
}

