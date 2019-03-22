
public class HilbertTraverser {
  
  private int[][] grid;
  private int i;
  private int j;
  
  private int value;
  private boolean finished;
  
  public HilbertTraverser(int[][] grid) {
    setHilbert(grid);
  }
  
  public HilbertTraverser() {
    
  }
  
  public void setHilbert(int[][] grid) {
    this.grid = grid;
    reset();
  }
  
  public void step() {
    do {
      value++;
      if(i>0 && grid[i-1][j]==value) { i--; break; }
      if(j>0 && grid[i][j-1]==value) { j--; break; }
      if(i<grid.length-1 && grid[i+1][j]==value) { i++; break; }
      if(j<grid.length-1 && grid[i][j+1]==value) { j++; break; }
      finished = true;
    } while(false);
  }
  
  public void reset() {
    i = 0;
    j = 0;
    value = 0;
    finished = false;
  }
  
  public void setX(int i) {
    this.i = i;
  }
  
  public void setY(int j) {
    this.j = j;
  }
  
  public void setLocation(int i, int j) {
    setX(i);
    setY(j);
  }
  
  public float getX() {
    return (float)i/getSideLength();
  }
  
  public float getY() {
    return (float)j/getSideLength();
  }
  
  public boolean isFinished() {
    return finished;
  }
  
  public int getSideLength() {
    return grid.length;
  }
  
}