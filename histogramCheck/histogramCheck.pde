import gab.opencv.*;
import java.awt.Rectangle;

final int SCALEFACTOR = 1;
final int DISPLAYWIDTH = 600;
final int DISPLAYHEIGHT = 600;

PImage src, img, destination;
ArrayList<BoundingBox> boxPoints;
Rectangle[] faces;
OpenCV opencv;

class BoundingBox {
  int x, y, width, height;
  Rectangle [] faces;
  PImage src;

  BoundingBox(int _x, int _y, int _width, int _height) {
    x = _x; 
    y = _y; 
    width = _width; 
    height = _height;
    //img = _img;
  }

  void draw() {
    noFill();
    stroke(0, 0, 255);
    strokeWeight(3);
    rect(x, y, width, height);
  }
}


void setup() {
  src = loadImage("nikanew.jpg");
  src.resize(0, 600);
  boxPoints = new ArrayList();
  size(600, 600);
  opencv = new OpenCV(this, src);
  opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);
  faces = opencv.detect();
  checkFaces(faces);
}

void draw() {
  background(0);
  image(src, 0, 0); 
  for (BoundingBox boxPoint : boxPoints) {
    println(boxPoint.x);
    println(boxPoint.y);
    println(boxPoint.width);
    println(boxPoint.height);
    boxPoint.draw();
  }
  filter(BLUR, 1);
  histogram(src);
}

void checkFaces(Rectangle[] faces) {
  for (int i=0; i < faces.length; i++) {
    int facewidth = (faces[i].width)/SCALEFACTOR;
    int faceheight = (faces[i].height)/SCALEFACTOR;
    int faceX = (faces[i].x)/SCALEFACTOR;
    int faceY = (faces[i].y)/SCALEFACTOR;
    if ((faceheight > 100) && (facewidth > 100)) {
      boxPoints.add(new BoundingBox(faceX, faceY, facewidth, faceheight));
    }
  }
}

void histogram(PImage img) {
  int bright = 0;
  int[] hist = new int[256];
  for (int x = 0; x < img.width; x++) {
    for (int y = 0; y < img.height; y++) {
      bright = int(brightness(get(x, y)));
      hist[bright]++;
    }
  }
  int histMax = max(hist);
  stroke(255);
  //spacing out histogram bars displays histogram of brightness at 5 pixel intervals
  for (int i=0; i< img.width; i+=5) {
    int histX = int(map(i, 0, img.width, 0, 255));
    int histY = int(map(hist[histX], 0, histMax, img.height, 0));
    line(i, img.height, i, histY);
  }
}
