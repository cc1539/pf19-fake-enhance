
public class ImageEnhance {
  
  private PImage image;
  private PImage target;
  
  private PGraphics canvas;
  private PImage frame;
  private HilbertTraverser hilbert;
  
  public int time;
  
  public int state;
  public static final int IDLE_START = 0;
  public static final int BLINKING = 1;
  public static final int ZOOMING = 2;
  public static final int ENHANCING = 3;
  public static final int IDLE_END = 4;
  
  public int blink_duration;
  public float blink_rate;
  public int zoom_duration;
  public int zoom_levels;
  public int enhance_duration;
  public int enhance_levels;
  public int enhance_speed;
  
  public float frame_x;
  public float frame_y;
  public float frame_w;
  public float frame_h;
  
  public ImageEnhance(PImage image, PImage target) {
    this.image = image;
    this.target = target;
    canvas = createGraphics(image.width,image.height);
  }
  
  public void setState(int state) {
    this.state = state;
    time = 0;
    switch(state) {
      case BLINKING:
        frame = image.get(
          floor(frame_x),
          floor(frame_y),
          ceil(frame_w),
          ceil(frame_h)
        );
      break;
      case ENHANCING:
        hilbert = new HilbertTraverser(HilbertGenerator.generate(1));
      break;
    }
  }
  
  public int getState() {
    return state;
  }
  
  public void setBlinkDuration(int blink_duration) {
    this.blink_duration = blink_duration;
  }
  
  public void setBlinkRate(float blink_rate) {
    this.blink_rate = blink_rate;
  }
  
  public void setZoomDuration(int zoom_duration) {
    this.zoom_duration = zoom_duration;
  }
  
  public void setZoomLevels(int zoom_levels) {
    this.zoom_levels = zoom_levels;
  }
  
  public void setEnhanceDuration(int enhance_duration) {
    this.enhance_duration = enhance_duration;
  }
  
  public void setEnhanceLevels(int enhance_levels) {
    this.enhance_levels = enhance_levels;
  }
  
  public void setEnhanceSpeed(int enhance_speed) {
    this.enhance_speed = enhance_speed;
  }
  
  public void start(float x, float y) {
    frame_w = 10;
    frame_h = 10;
    frame_x = x;
    frame_y = y;
    setState(BLINKING);
  }
  
  public void start() {
    start(
      random(0,image.width-frame_w),
      random(0,image.height-frame_h)
    );
  }
  
  public void reset() {
    setState(IDLE_START);
  }
  
  public void timeStep() {
    switch(getState()) {
      case BLINKING:
        if(time>blink_duration) {
          setState(ZOOMING);
        }
      break;
      case ZOOMING:
        if(time>zoom_duration) {
          setState(ENHANCING);
        }
      break;
      case ENHANCING:
        if(time>enhance_duration) {
          setState(IDLE_END);
        }
      break;
    }
    time++;
  }
  
  public PImage get() {
    switch(getState()) {
      case IDLE_START:
      
        return image;
        
      case BLINKING:
      
        canvas.beginDraw();
        canvas.image(image,0,0);
        canvas.noFill();
        canvas.strokeWeight(2);
        canvas.stroke(floor(time*blink_rate)%2==0?255:0);
        canvas.rect(frame_x,frame_y,frame_w,frame_h);
        canvas.endDraw();
        return canvas.get();
        
      case ZOOMING:
        
        canvas.beginDraw();
        canvas.image(image,0,0);
        float progress = (float)floor((float)time/zoom_duration*zoom_levels)/zoom_levels;
        canvas.image(frame,
          frame_x*(1-progress),
          frame_y*(1-progress),
          frame_w+(image.width-frame_w)*progress,
          frame_h+(image.height-frame_h)*progress
        );
        canvas.endDraw();
        return canvas.get();
        
      case ENHANCING:
        
        canvas.beginDraw();
        
        for(int t=0;t<hilbert.getSideLength();t++) {
          
          if(hilbert.isFinished()) {
            
            // finding log2n
            int pow2n = hilbert.getSideLength();
            int length = 2;
            int n = 1;
            while(length!=pow2n) {
              length <<= 1;
              n++;
            }
            
            hilbert.setHilbert(HilbertGenerator.generate(n+1));
          }
          
          float x = hilbert.getX();
          float y = hilbert.getY();
          hilbert.step();
          color sample = target.get(
            floor(x*target.width),
            floor(y*target.height)
          );
          canvas.noStroke();
          canvas.fill(sample,hilbert.getSideLength());
          canvas.rect(
            x*image.width,
            y*image.height,
            (float)image.width/hilbert.getSideLength(),
            (float)image.height/hilbert.getSideLength()
          );
          
        }
        canvas.endDraw();
        return canvas.get();
        
      case IDLE_END:
        
        return target;
        
    }
    return image;
  }
  
}