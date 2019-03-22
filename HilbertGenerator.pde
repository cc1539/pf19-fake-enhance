
public static class HilbertGenerator {
  
  public static final int[] forward = new int[]{0,1,2,3};
  public static final int[] backward = new int[]{3,2,1,0};
  public static final int[] rotate_order_even = new int[]{1,0,0,3};
  public static final int[] rotate_order_odd = new int[]{3,0,0,1};
  
  public static void generate(int[][] grid, int x, int y, int n, int rotation, boolean reversed) {
    
    int[] order = reversed?backward:forward;
    
    int[] rotations = new int[4];
    for(int i=0;i<rotations.length;i++) {
      rotations[i] = (rotation+order[i])%4;
    }
    
    if(n==2) {
      grid[x  ][y  ] += rotations[0];
      grid[x  ][y+1] += rotations[1];
      grid[x+1][y+1] += rotations[2];
      grid[x+1][y  ] += rotations[3];
    } else {
      int nd2 = n/2;
      int level = nd2*nd2;
      for(int i=0;i<n;i++) {
      for(int j=0;j<n;j++) {
        if(i< nd2 && j< nd2) { grid[i+x][j+y] += rotations[0]*level; } else 
        if(i< nd2 && j>=nd2) { grid[i+x][j+y] += rotations[1]*level; } else 
        if(i>=nd2 && j>=nd2) { grid[i+x][j+y] += rotations[2]*level; } else 
        if(i>=nd2 && j< nd2) { grid[i+x][j+y] += rotations[3]*level; }
      }
      }
      int[] rotate_order = rotation%2==0?rotate_order_even:rotate_order_odd;
      generate(grid,x    ,y    ,nd2,rotation+rotate_order[rotations[0]],reversed^(rotations[0]==0||rotations[0]==3));
      generate(grid,x    ,y+nd2,nd2,rotation+rotate_order[rotations[1]],reversed^(rotations[1]==0||rotations[1]==3));
      generate(grid,x+nd2,y+nd2,nd2,rotation+rotate_order[rotations[2]],reversed^(rotations[2]==0||rotations[2]==3));
      generate(grid,x+nd2,y    ,nd2,rotation+rotate_order[rotations[3]],reversed^(rotations[3]==0||rotations[3]==3));
    }
  }
  
  public static int[][] generate(int log2n) {
    int n = 1<<log2n;
    int[][] grid = new int[n][n];
    generate(grid,0,0,n,0,false);
    return grid;
  }

}