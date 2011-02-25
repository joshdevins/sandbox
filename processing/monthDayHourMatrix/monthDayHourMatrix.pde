/**
 * A very simple matrix of activity over the course of a month.
 *
 * Y-axis: day of the month
 * X-axis: hour of the day
 * Intensity: activity
 *
 * Activity can only be compared relative to points on this matrix since intensities are normalized.
 *
 * @author Josh Devins
 */

int numDays = 31;
int numHours = 24;
int diameter = 8;
int radius = diameter / 2;

int canvasLeftGutter = 100;
int canvasRightGutter = 20;
int canvasTopGutter = 100;
int canvasBottomGutter = 20;

void setup() {
  
  // setup a small canvas
  size(diameter * numHours + canvasLeftGutter + canvasRightGutter,
       diameter * numDays + canvasTopGutter + canvasBottomGutter);
  background(255);
  smooth();
  
  int[][] numbers = generateRandomNumbers();
  
  drawText();
  drawMatrix(numbers);
};

void drawText() {
  
  PFont font = loadFont("Modern-Regular-32.vlw"); 
  textFont(font);
  fill(0, 0, 0, 80);

  text("your activity matrix", 15, 50);
}

void drawMatrix(int[][] numbers) {

  noStroke();
  
  for(int x = 0; x < numbers.length; x++) {
    for(int y = 0; y < numbers[x].length; y++) {
      
      // draw a dot at this coordinate with the opacity of the value
      int value = numbers[x][y];
      fill(0, value);
      ellipse((x * diameter) + radius + canvasLeftGutter,
              (y * diameter) + radius + canvasTopGutter,
              diameter, diameter);
    }
  }
};

int[][] generatePatternedNumbers() {

  int[][] numbers = new int[numHours][numDays];
  
  for(int hours = 0; hours < numHours; hours++) {
    for(int days = 0; days < numDays; days++) {
      
      int value;
      
      if (hours < 12) {
        value = hours * 2;
      } else {
        value = hours * 2 + 10;
      }
      
      value += 10;
      
      if (days > 20) {
        value = 10;
      }
      
      numbers[hours][days] = value;
    }
  }
  
  return numbers;
}

int[][] generateRandomNumbers() {

  int[][] numbers = new int[numHours][numDays];
  
  for(int hours = 0; hours < numHours; hours++) {
    for(int days = 0; days < numDays; days++) {
      numbers[hours][days] = ceil(random(0,99));
    }
  }
  
  return numbers;
}

void draw() {
  // draw per frame
};

