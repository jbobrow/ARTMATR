/*
 * Edge Detection Example 01
 * ---------------------
 * Find the outline of the areas filled
 *
 * Sketch for ARTMATR
 * by Jonathan Bobrow
 * 08.24.2017
/*
 * Outline Example 01
 * ---------------------
 * Find the areas to trace around
 *
 * Load an image into the sketch
 * Resize the image to a resolution of the sketch
 * With the press of the SPACEBAR, draw the outline of the image
 *
 * Sketch for ARTMATR
 * by Jonathan Bobrow
 * 08.27.2017
 *
 */
 
import blobDetection.*;

BlobDetection theBlobDetection;
//PGraphics img;

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
  detectBlobs(photo);
  // draw edges
  drawEdges();
}


/*
 * detect blobs for image
 */
 
void detectBlobs(PImage img) {
  theBlobDetection = new BlobDetection(img.width, img.height);
  theBlobDetection.setPosDiscrimination(false);
  theBlobDetection.setThreshold((float)(threshold/255.f));
  theBlobDetection.computeBlobs(img.pixels);
}


/*
 * drawEdges() - almost directly copied from BlobDetection example DrawEdges
 */
void drawEdges()
{
  noFill();
  Blob b;
  EdgeVertex eA, eB;
  for (int n=0 ; n<theBlobDetection.getBlobNb() ; n++)
  {
    b=theBlobDetection.getBlob(n);
    if (b!=null)
    {
    // Edges
      strokeWeight(1);
      stroke(0, 255, 0);
      for (int m=0;m<b.getEdgeNb();m++)
      {
        eA = b.getEdgeVertexA(m);
        eB = b.getEdgeVertexB(m);
        if (eA !=null && eB !=null)
          // here we are drawing lines from point to point
          // these could be the paths that the airbrush travels
          // Note: we multiply by the size of the image because
          // the blob is normalized, (i.e. all values are between 0-1)
          line(
          eA.x*photo.width, eA.y*photo.height, 
          eB.x*photo.width, eB.y*photo.height
            );
      }    
    }
  }
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