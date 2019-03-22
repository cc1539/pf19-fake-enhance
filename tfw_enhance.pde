
public ImageEnhance ie;

public void setup() {
  
  size(640,480);
  noSmooth();
  
  ie = new ImageEnhance(
    loadImage("city.jpg"),
    loadImage("jason-bourne.jpg")
  );
  ie.setBlinkDuration(100);
  ie.setBlinkRate(0.1);
  ie.setZoomDuration(30);
  ie.setZoomLevels(5);
  ie.setEnhanceDuration(1000);
  ie.setEnhanceSpeed(300);
}

public void keyPressed() {
  switch(key) {
    case ' ':
      ie.start(mouseX,mouseY);
    break;
    case 'r':
      ie.reset();
    break;
  }
}

public void draw() {
  ie.timeStep();
  image(ie.get(),0,0);
  surface.setTitle("FPS: "+frameRate);
}