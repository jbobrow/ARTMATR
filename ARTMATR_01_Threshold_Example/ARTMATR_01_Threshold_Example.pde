/*
 * Threshold Example 01
 * ---------------------
 * Find the areas to fill
 *
 * Load an image into the sketch
 * Resize the image to a resolution of the sketch
 * With the press of the SPACEBAR, draw the thresholded version of the image
 *
 * Sketch for ARTMATR
 * by Jonathan Bobrow
 * 08.24.2017
 *
 */


PImage photo;
int max_size = 800;   // size of the processing canvas (arbitrary, but does define resolution)
int threshold = 128;  // on a value of brightness from 0-255, this will be the threshold to be on or off (we can update this with key presses until we are satisfied)


void setup() {
  size(800, 800);
  photo = loadImage("barnaby_01.jpg");
  photo = scaleImage(photo, width, height);

  // press spacebar to run this again
  display();
}


void draw() {
  // this keeps the sketch running
  // actions happen based on key presses
  // this way the computer doesn't have to compute
  // what to draw ~30 times per seconds
}

/*
 * Draw the image to screen when called
 */
void display() {
  // draw image
  image(photo, 0, 0);
  //background(255);  // or draw a blank background
  // draw thresholded image
  drawThresholdImage(photo, threshold);
}


/* 
 * scale image and maintain aspect ratio
 * img = PImage to scale
 * w = width to contain within
 * h = height to contain within
 * returns a scaled image which maintains proportions
 */ 
PImage scaleImage(PImage img, int w, int h) {
  // maintain aspect ratio
  int window_width, window_height;

  if (img.width > img.height) {
    window_width = w;
    window_height = int(w * (img.height/float(img.width)));
  } else {
    window_width = int(h * (img.width/float(img.height)));
    window_height = h;
  }
  println("image scaled to: ( " +window_width + ", " + window_height + ")"); 
  img.resize(window_width, window_height);

  return img;
}


/*
 * draw a thresholded image
 * img = PImage that is the image to evaluate
 * thresholdValue = integer value 0-255 that represents the threshold to measure against whether to draw or not to draw at a specific location
 */
void drawThresholdImage(PImage img, int thresholdValue) {
  // load pixels
  img.loadPixels();

  // loop through rows
  for (int i=0; i<img.height; i++) { 

    // loop through columns
    for (int j=0; j<img.width; j++) {
      int index = i * img.width + j;
      int b = (int)brightness(img.pixels[index]);
      if (b > thresholdValue) {
        // this locatoin is greater than the threshold
        // in this case, we will draw a green point
        // this could be substituted to turn on the airbrush here
        stroke(0,255,0);
        point(j, i);
      }
    } // end of row
  } // end of image
}

/*
 * Handle actions from the keyboard here
 */
void keyPressed() {

  switch(keyCode) {
  
    case 32:  // this is the KeyCode for 'spacebar'
      display();
    break;
   
    case UP:   // keyCode for up is 38, but processing has this already defined as 'UP' for us 
      threshold++; 
    break;  // if the up arrow
    
    case DOWN:   // keyCode for up is 40, but processing has this already defined as 'DOWN' for us 
      threshold--; 
    break;  // if the up arrow
  
    default: 
    break;
  }
  
  // let's print the latest value of our threshold
  println("threshold: " + threshold);
}