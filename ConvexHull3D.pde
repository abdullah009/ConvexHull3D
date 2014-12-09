
import processing.opengl.*;
import java.util.Collections;

int TOTAL_POINT = 10;
boolean debugF = false;  
boolean initF = true;

float xmag, ymag, xmagof, ymagof;
float newXmag, newYmag = 0;
float axisLen, posz;

int stepCount, phaseCount;

int colorHullV = #00FF00;
int colorUnexplV = #FFFFFF;
int colorExplV = #0000FF;
int colorNotHullV = #000000;
int colorHullF = #AAAA00; // brown
int colorNotHullF = #FF00FF; // purple

ConvexHull convHull;

void setup() {
  size(640, 360, OPENGL);
  colorMode(RGB, 1);
  axisLen = width/4;
  smooth();
  
  posz = 400.0;
  xmag = 0;
  ymag = 0;
  xmagof = 0;
  ymagof = 0;
  
  /*
  convHull = new ConvexHull();
  convHull.readVertices();
  stepCount = 0;
  phaseCount = 0;*/
}

void draw() {
  if (convHull == null)
    return;
  background(0.5);
  camera(width/2, height/2, posz, width/2, height/2, 0, 0, 1, 0);
 // directionalLight(1, 1, 1, 0, 0, -1); 
  
  pushMatrix();
  translate(width/2, height/2, -50);

  newXmag = mouseX/float(width) * TWO_PI;
  newYmag = mouseY/float(height) * TWO_PI;

  float diff = xmag - newXmag;
  if (abs(diff) > 0.01) {
    xmag -= diff/4.0;
  }

  diff = ymag - newYmag;
  if (abs(diff) > 0.01) {
    ymag -= diff/4.0;
  }

  rotateX(ymagof + ymag);
  rotateY(xmagof + xmag);

  stroke(0, 0, 0);
  line(0, 0, 0, axisLen, 0, 0);
  stroke(0, 0, 0);
  line(0, 0, 0, 0, axisLen, 0);
  stroke(0, 0, 0);
  line(0, 0, 0, 0, 0, axisLen);

  stroke(1, 1, 1);

  {
    VertexC ver  = convHull.verList.headVer;
    do
    {
      pushMatrix();
      stroke(colorUnexplV);
      for (int t = 0; t < convHull.processedVerIdArr.size(); ++t) {
        if (convHull.processedVerIdArr.get(t) == convHull.verList.headVer.id) {
          if (convHull.lastVerValidF && (t == convHull.processedVerIdArr.size() - 1)) 
            stroke(colorExplV);
          else
            stroke(colorHullV);
          break;
        }
      }
      
      translate(convHull.verList.headVer.posArr[0], convHull.verList.headVer.posArr[1], convHull.verList.headVer.posArr[2]);
      sphere(2);
      popMatrix();
      convHull.verList.headVer  = convHull.verList.headVer.nextVer;      
    } while (ver != convHull.verList.headVer);
  }
  
  if (convHull.verBeRemovedIdArr.size() > 0) {
    pushMatrix();
    stroke(colorNotHullV);
    translate(convHull.verBeRemoved.posArr[0], convHull.verBeRemoved.posArr[1], convHull.verBeRemoved.posArr[2]);
    sphere(2);
    popMatrix();
  }
  
  //noStroke();
  stroke(.5, .5, .5);
  if (convHull.faceBeRemovedArr.size() > 0) {
    // removing faces
    for (int i = 0; i < convHull.faceBeRemovedArr.size(); ++i)
    {
      fill(colorNotHullF, 1);
      beginShape(TRIANGLES);
      VertexC[] triVer = convHull.faceBeRemovedArr.get(i);
      for (VertexC ver:triVer)
        vertex(ver.posArr[0], ver.posArr[1], ver.posArr[2]);
      endShape();
    }
  }
  else {
    // on hull faces
    for (int i = 0; i < convHull.faceAddedArr.size(); ++i)
    {
      fill(colorHullF, 1);
      beginShape(TRIANGLES);
      VertexC[] triVer = convHull.faceAddedArr.get(i);
      for (VertexC ver:triVer)
        vertex(ver.posArr[0], ver.posArr[1], ver.posArr[2]);
      endShape();
    }
  }
  
  
  
  if (convHull.faceBeDrawnArr.size() > 0)
  {
    
    for (int i = 0; i < convHull.faceBeDrawnCount; ++i)
    {
      fill(colorHullF, 1);
      beginShape(TRIANGLES);
      VertexC[] triVer = convHull.faceBeDrawnArr.get(i);
      for (VertexC ver:triVer)
        vertex(ver.posArr[0], ver.posArr[1], ver.posArr[2]);
      endShape();
    }
    
  }
  
  // draw axis X, Y, Z
  fill(1);
  stroke(1, 1, 1);
  textSize(16);
  pushMatrix();
  translate(0, axisLen, 0);
  rotateY(-xmagof -xmag);
  rotateX(-ymagof -ymag);
  text("Y", 0, 0, 0);
  popMatrix();
  
  pushMatrix();
  translate(axisLen, 0, 0);
  rotateY(-xmagof -xmag);
  rotateX(-ymagof -ymag);
  text("X", 0, 0, 0);
  popMatrix();
 
  pushMatrix();
  translate(0, 0, axisLen);
  rotateY(-xmagof-xmag);
  rotateX(-ymagof-ymag);
  text("Z", 0, 0, 0);
  popMatrix();
  

  popMatrix();
}

//void keyPressed()
void keyPressedWeb(int keyCode)
{
  if (debugF)
    println(keyCode);
  if (keyCode == 39)
  {
    
    ++stepCount;
    
    if (stepCount > 1)
    {
      if (debugF) 
        println("v re " + convHull.verBeRemovedIdArr.size() + " f r " + convHull.faceBeRemovedArr.size() + "f a " + convHull.faceAddedArr.size());
     
      if (phaseCount == 0) {
        convHull.cleanFV();
        convHull.constructHull();
        if (debugF)
          println("face: " + convHull.faceBeDrawnCount + " processedV: " + convHull.processedVerIdArr.size());
        phaseCount++;
      }
      else if (phaseCount == 1) {
        phaseCount = 0;
        convHull.cleanFV();
      }
      
      if (stepCount == 2) {
        phaseCount = 0;
        convHull.cleanFV();
      }
    }
    else if (stepCount == 1)
      convHull.createDoubleTriangle();
  }
  else if (keyCode == 38) {
    if (posz > 200)
      posz -= 5;
  }
  else if (keyCode == 40) {
    if (posz < 450)
      posz += 5;
  }
}

String startAppl(int _vertexTotal) {
  if (debugF)
    println("VertexTotal: " + _vertexTotal);
  if (convHull != null) {
    convHull.resetAll();
  convHull = null;
  }
  
  TOTAL_POINT  = _vertexTotal;
  convHull = new ConvexHull();
  convHull.readVertices();
  stepCount = 0;
  phaseCount = 0;
  
  return getVerListAll();
}

String getVerList(int keyCode) {
  keyPressedWeb(keyCode);
  if (keyCode == 39) {
  return getVerListAll();
  }
  
  return "";
}

String getVerListAll() {
  String verUnexpl = "Unexplored: ";
  String verExpl = "Exploring: ";
  String verOnhull = "OnHull: ";
  String verInhull = "InsideHull: ";

  ArrayList<Integer> verIdArr = new ArrayList<Integer>();
  VertexC ver  = convHull.verList.headVer;
  do
  {
      for (int t = 0; t < convHull.processedVerIdArr.size(); ++t) {
        if (convHull.processedVerIdArr.get(t) == convHull.verList.headVer.id) {
          verIdArr.add(convHull.verList.headVer.id);
          if (convHull.lastVerValidF && (t == convHull.processedVerIdArr.size() - 1))  
            verExpl = verExpl + convHull.verList.headVer.printVertex() + " ";
          else
            verOnhull = verOnhull + convHull.verList.headVer.printVertex() + " ";
          break;
        }
      }
      if (!convHull.verList.headVer.processedF) {
        verIdArr.add(convHull.verList.headVer.id);
        verUnexpl = verUnexpl + convHull.verList.headVer.printVertex() + " ";
      }
      convHull.verList.headVer  = convHull.verList.headVer.nextVer;      
  } while (ver != convHull.verList.headVer);
  
  int k = 0;
  for (int i = 0; i < TOTAL_POINT; ++i) {
    if (verIdArr.indexOf(i) < 0){
      int[] verTri = convHull.verArr.get(i);
      verInhull = verInhull + "(" + verTri[0] + ", "  + verTri[1] + ", " + verTri[2] + ") ";
    }
  }
  verIdArr.clear();
  verIdArr = null;
  String str = (verUnexpl + ";" + verExpl + ";" + verOnhull + ";" + verInhull);
  if (debugF)
    println(str);
  return str;
}


