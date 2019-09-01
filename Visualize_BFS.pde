int cellW = 25;
int cellH = 25;

int rows = 28;
int cols = 50;

int offsetX = 20;
int offsetY = 20;

int startRow = rows/2;
int startCol = cols/2;

Cell[][] a = new Cell[rows][cols];
P2d [][] trace = new P2d[rows][cols];
int [][] dist = new int[rows][cols];

int front = 0, rear = -1;
P2d []q = new P2d[cols*rows+5];

void bfs()
{
  int []td = {0, -1, 0, 1};
  int []tc = {1, 0, -1, 0};
  
  boolean [][]visit = new boolean[rows][cols];
  for(int i = 0; i < rows; i++) 
    for(int j = 0; j < cols; j++) 
    {
      visit[i][j] = false;
      trace[i][j] = new P2d(0,0);
    }
  
  q[++rear] = new P2d(startRow, startCol);
  visit[startRow][startCol] = true;
  dist[startRow][startCol] = 0;
  trace[startRow][startCol].r = startRow;
  trace[startRow][startCol].c = startCol;
  while (front <= rear)
  {
    P2d u = q[front++];
    for(int k = 0; k < 4; k++)
    {
      P2d v = new P2d(u.r + td[k], u.c+tc[k]);
      if (!(v.r >=0 && v.r < rows && v.c >= 0 && v.c < cols)) continue;
      if (!(getBit(a[u.r][u.c].gateMask, k) == 0 && getBit(a[v.r][v.c].gateMask, (k+2)%4) == 0)) continue;
      if (!visit[v.r][v.c])
      {
        visit[v.r][v.c] = true;
        trace[v.r][v.c] = new P2d(u.r, u.c);
        dist[v.r][v.c] = dist[u.r][u.c]+1;
        q[++rear] = new P2d(v.r, v.c);
      }
    }
  }
}
JSONObject json;
int mode;
int delayTime;
void setup()
{
  
  size(1366, 768);
  blendMode(REPLACE);
  //randomSeed(10);
  
  json = loadJSONObject("data.json");
  mode = json.getInt("mode");
  int seed = json.getInt("seed");
  rows = json.getInt("rows");
  cols = json.getInt("cols");
  cellW = json.getInt("cellW");
  cellH = json.getInt("cellH");
  startRow = json.getInt("startRow");
  startCol = json.getInt("startCol");
  delayTime = json.getInt("delayTime");
  
  if (seed != -1) randomSeed(seed);
  
  int []c = {1,2,4,8};
  for(int j = 0; j < cols; j++)
    for(int i = 0; i < rows; i++)
    {
      a[i][j] = new Cell(offsetX+1f*j*cellW, offsetY+1f*i*cellH, 1f*cellW, 1f*cellH, (byte)c[(int)random(4)]);
    }
  bfs();
}

int curPos = 0;

void draw()
{
  background(0);
  noStroke();
  //fill(0,0,128);
  //rect(offsetX, offsetY, cols*cellW, rows*cellH);
  if (mode == 1)
  {
    for(int i = 0; i < rows; i++)
      for(int j = 0; j < cols; j++) 
      {
        a[i][j].Draw();
      }
  }
  
   
   for(int i = 0; i <= rear; i++)
   {
     if (dist[q[i].r][q[i].c] <= curPos)
     {
       
       
       
       //if (dist[q[i].r][q[i].c] < curPos) fill(255,100,0); else fill(100,255,0);
       colorMode(HSB);
       color fillColor = lerpColor(color(#C62833),color(#2CFF0D), 1f*dist[q[i].r][q[i].c]/dist[q[rear].r][q[rear].c]);
       colorMode(RGB);
       fill(fillColor);
       noStroke();
       rect(a[q[i].r][q[i].c].x+cellW/4, a[q[i].r][q[i].c].y+cellH/4, cellW/2, cellH/2);
       
       P2d tr = trace[q[i].r][q[i].c];
       colorMode(HSB);
       stroke(fillColor);
       colorMode(RGB);
       strokeWeight(3);
       line(a[q[i].r][q[i].c].x+cellW/2, a[q[i].r][q[i].c].y+cellH/2, a[tr.r][tr.c].x+cellW/2, a[tr.r][tr.c].y+cellH/2);
       
     }
   }
  
  delay(delayTime);
  
  if (curPos > dist[q[rear].r][q[rear].c] + 1)
  {
    println("END");
    noLoop();
  } else
  {
    curPos++;
  }
     
}

void keyPressed()
{
  curPos++;
  if (curPos > dist[q[rear].r][q[rear].c] + 1)
  {println("END"); exit();}
}

class Cell {
  float x, y, w, h;
  byte gateMask;
  
  Cell()
  {
    x = y = w = h = 0;
    gateMask = 0;
  }
  
  Cell(float _x, float _y, float _w, float _h, byte _gateMask)
  {
    x = _x;
    y = _y;
    w = _w;
    h = _h;
    gateMask = _gateMask;
  }
  
  void Draw()
  {
    stroke(255);
    strokeWeight(1);
    line(x, y, x + cellW/4, y);
    line(x, y, x, y + cellH/4);
    
    line(x + cellW, y, x + 3*cellW/4, y);
    line(x + cellW, y, x + cellW, y + cellH/4);
    
    line(x, y + cellH, x + cellW/4, y + cellH);
    line(x, y + cellH, x, y + 3*cellH/4);
    
    line(x + cellW, y + cellH, x + 3*cellW/4, y + cellH);
    line(x + cellW, y + cellH, x + cellW, y + 3*cellH/4);
    
    // 0 = right, 1 = up, 2 = left, 3 = down
    if (getBit(gateMask, 0) == 1)
    {
      line(x+cellW, y+cellH/4, x+cellW, y+3*cellH/4);
    }
    
    if (getBit(gateMask, 1) == 1)
    {
      line(x+cellW/4, y, x+3*cellW/4, y);
    }
    
    if (getBit(gateMask, 2) == 1)
    {
      line(x, y+cellH/4, x, y+3*cellH/4);
    }
    
    if (getBit(gateMask, 3) == 1)
    {
      line(x+cellW/4, y+cellW, x+3*cellW/4, y+cellW);
    }
    
  } 
}

class P2d {
  int r, c;
  P2d() {}
  P2d(int _r, int _c) {r = _r; c = _c;}
}
