
class ConvexHull
{
  static final boolean ON_HULL  = true;
  static final boolean REMOVED  = true;
  static final boolean VISIBLE  = true;
  static final boolean PROCESSED = true;
  static final int SAFE  = 1000000;
  static final int RANGE = 150;
  
  // variable declaration
  VertexListC verList;
  EdgeListC  edgeList;
  FaceListC faceList;
  ArrayList<int[]> verArr = new ArrayList<int[]>();
  
  ArrayList<VertexC[]> faceBeDrawnArr, faceAddedArr, faceBeRemovedArr;
  ArrayList<Integer> processedVerIdArr, verBeRemovedIdArr;
  VertexC verBeRemoved;
  boolean lastVerValidF;
   
  int verTotal, faceBeDrawnCount, faceBeRemovedCount; 
  boolean drawF, checkF;  
  
  // default constructor
  ConvexHull()
  {
    if (debugF)
      println("init(): ");
    verList   = new VertexListC();
    edgeList  = new EdgeListC();
    faceList  = new FaceListC();
    
    faceBeDrawnArr = new ArrayList<VertexC[]>();
    faceBeDrawnCount = 0;
    faceAddedArr = new ArrayList<VertexC[]>();
    
    faceBeRemovedArr = new ArrayList<VertexC[]>();
    faceBeRemovedCount = 0;
    
    processedVerIdArr  = new ArrayList<Integer>();
    verBeRemovedIdArr = new ArrayList<Integer>();
    lastVerValidF = false;
    
    verTotal = 0;
    drawF = false;
    checkF = false;
  }
  
  void resetAll() {
     verList = null;
     edgeList = null;
     faceList = null;
    
     verBeRemoved = null;
     
     processedVerIdArr.clear();
     verBeRemovedIdArr.clear();
     processedVerIdArr = null;
     verBeRemovedIdArr = null;
     
     
     faceBeDrawnArr.clear();
     faceAddedArr.clear();
     faceBeRemovedArr.clear();
     faceBeDrawnArr= null;
     faceAddedArr = null;
     faceBeRemovedArr = null;
     
     verArr.clear();
     verArr = null;
  }
  
  
  void readVertices()
  {
    if (debugF)
      println("readVertices(): ");
    // data from file
   // readDataFromFile();
    // data generated randomly
    generateDataRand();
    
    // print vertex list
    if (debugF)
      verList.printVertexList();
  }
  
  void generateDataRand()
  {
    for (int i = 0; i < TOTAL_POINT; ++i)
    {
      VertexC ver  = new VertexC((int)random(RANGE), (int)random(RANGE), (int)random(RANGE));
      ver.id = verTotal++;
      verList.insertVer(ver);
      verArr.add(ver.posArr);
    }
  }
  
  void readDataFromFile()
  {
   /* Table dataTable  = loadTable("InputCH3D.csv");
    for (TableRow row:dataTable.rows())
    {
      println(row.getFloat(0));
      VertexC ver  = new VertexC(row.getInt(0), row.getInt(1), row.getInt(2));
      ver.id = verTotal++;
      verList.insertVer(ver);
    }*/
  }
  
  void createDoubleTriangle()
  {
    VertexC v0 = verList.headVer;
    while (isCollinear(v0, v0.nextVer, v0.nextVer.nextVer)) {
      if ((v0 = v0.nextVer) == verList.headVer) {
        if (debugF)
          println("All points are collinear");
        return;
      }
    }
    
    VertexC v1 = v0.nextVer;
    VertexC v2 = v0.nextVer.nextVer;
    
    v0.processedF = true;
    v1.processedF = true;
    v2.processedF = true;
     
    FaceC f1 = null;
    FaceC f0 = makeFace(v0, v1, v2, f1);
    f1 = makeFace(v2, v1, v0, f0);
    
    if (debugF) {
      println("f0: " + f0.verArr[0].id + ", " + f0.verArr[1].id + ", " + f0.verArr[2].id);
      println("f1: " + f1.verArr[0].id + ", " + f1.verArr[1].id + ", " + f1.verArr[2].id);
    }
    
    /* link adjacent faces*/
    f0.edgeArr[0].faceAdjArr[1] = f1;
    f0.edgeArr[1].faceAdjArr[1] = f1;
    f0.edgeArr[2].faceAdjArr[1] = f1;
    f1.edgeArr[0].faceAdjArr[1] = f0;
    f1.edgeArr[1].faceAdjArr[1] = f0;
    f1.edgeArr[2].faceAdjArr[1] = f0;
    
    VertexC[] triVer = {v0, v1, v2};
    faceBeDrawnArr.add(triVer);
    faceBeDrawnCount++;
    
    VertexC[] triVer2 = {v2, v1, v0};
    faceBeDrawnArr.add(triVer2);
    faceBeDrawnCount++;
    
    processedVerIdArr.add(v0.id);
    processedVerIdArr.add(v1.id);
    processedVerIdArr.add(v2.id);
    
    
    // find fourth point which is not on a plane with first three
    VertexC v3 = v2.nextVer;
    int vol = getVolumeSign(f0, v3);
    while (vol == 0) {
      if ((v3 = v3.nextVer) == v0) {
        if (debugF)
          println("Points are on a plane");
        return;
      }
      vol = getVolumeSign(f0, v3);
    }
        
    // add v3
    verList.headVer = v3;    
  }
  
  // this function is called for every unprocessed vertex
  void constructHull()
  {
    lastVerValidF = false;
    VertexC v = verList.headVer;
    do {
      VertexC vnext = v.nextVer;
      if (!v.processedF) {
        v.processedF = true;
        processedVerIdArr.add(v.id);
        lastVerValidF = true;
        addOne(v);
        cleanUp();
        break; // one node at a time
      }
      v = vnext;
    } while (v != verList.headVer);
  }
  
  boolean addOne(VertexC p)
  {
    boolean visF = false;
    
    // find visible faces to the point p 
    FaceC f = faceList.headFace;
    do {
      int vol = getVolumeSign(f, p); 
      if (vol < 0) {
        if (debugF)
          println("f: " + f.verArr[0].id + ", " + f.verArr[1].id + ", " + f.verArr[2].id);
        f.visibleF = VISIBLE;
        visF = true;
        
        for (int i = 0; i < faceBeDrawnArr.size(); )
        {
          VertexC[] triVerDrawn = faceBeDrawnArr.get(i);
          if (triVerDrawn[0].id == f.verArr[0].id && triVerDrawn[1].id == f.verArr[1].id && triVerDrawn[2].id == f.verArr[2].id) {
            faceBeDrawnArr.remove(i);
            faceBeDrawnCount--;
            if (debugF)
              println("removed: " + f.verArr[0].id + ", " + f.verArr[1].id + ", " + f.verArr[2].id);
          }
          else
            ++i;
        }
        
        VertexC[] triVer = {f.verArr[0], f.verArr[1], f.verArr[2]};
        faceBeRemovedArr.add(triVer);
        faceBeRemovedCount++;
      }
      
      f = f.nextFace;
    } while (f != faceList.headFace);
    
    // no face is visible
    if (!visF) {
      p.onhullF = !ON_HULL;
      if (debugF)
        println("INSIDE HULL POINT:" + p.id);
      return false;
    }
    
    // find inside edges for deletion and find new faces
    EdgeC e = edgeList.headEdge;
    do {
      EdgeC temp = e.nextEdge;
      if (e.faceAdjArr[0].visibleF && e.faceAdjArr[1].visibleF) {
        e.deleteToBeF = REMOVED;
        if (debugF)
          println("edge removed: " + e.verArr[0].id + " " + e.verArr[1].id);
      }
      else if (e.faceAdjArr[0].visibleF || e.faceAdjArr[1].visibleF) {
        e.newFace = makeConeFace(e, p);
        
        VertexC[] triVer = {e.newFace.verArr[0], e.newFace.verArr[1], e.newFace.verArr[2]};
        faceAddedArr.add(triVer);
        if (debugF) {
          println("FaceCount " + faceBeDrawnCount);
          println("Face added: " + e.newFace.verArr[0].id + ", " + e.newFace.verArr[1].id + ", " + e.newFace.verArr[2].id);
        }
      }
      e = temp;
    } while (e != edgeList.headEdge);
    
    return true;
  }
  
  FaceC makeConeFace(EdgeC e, VertexC v)
  {
    // create new edges
    EdgeC newEdgeArr[] = new EdgeC[2];
    for (int i = 0; i < 2; ++i) {
      if ((newEdgeArr[i] = e.verArr[i].duplicateEdge) == null) {
        newEdgeArr[i] = edgeList.insertDummyEdge();
        newEdgeArr[i].verArr[0] = e.verArr[i];
        newEdgeArr[i].verArr[1] = v;
        e.verArr[i].duplicateEdge = newEdgeArr[i];
      }
    }
    
    // create new face
    FaceC newFace = faceList.insertDummyFace();
    newFace.edgeArr[0] = e;
    newFace.edgeArr[1] = newEdgeArr[0];
    newFace.edgeArr[2] = newEdgeArr[1];
    makeCCW(newFace, e, v);
        
    // set adjacent faces of newly created edges
    for (int i = 0; i < 2; ++i) {
      for (int j = 0; j < 2; ++j) {
        if (newEdgeArr[i].faceAdjArr[j] == null) {
          newEdgeArr[i].faceAdjArr[j] = newFace;
          break;
        }
      }
    }
    
    return newFace;
  }
  
  void makeCCW(FaceC f, EdgeC e, VertexC v)
  {
    FaceC fv;
    if (e.faceAdjArr[0].visibleF)
      fv = e.faceAdjArr[0];
    else
      fv = e.faceAdjArr[1];
      
    int i = 0;
    for (; fv.verArr[i] != e.verArr[0]; ++i)
      ;
     
    if (fv.verArr[(i+1)%3] != e.verArr[1]) {
      f.verArr[0] = e.verArr[1];
      f.verArr[1] = e.verArr[0];
    }
    else {
      f.verArr[0] = e.verArr[0];
      f.verArr[1] = e.verArr[1];
      swapEdge(f.edgeArr[1], f.edgeArr[2]);
    }
    
    f.verArr[2] = v;
  }
  
  void swapEdge(EdgeC e1, EdgeC e2)
  {
    EdgeC temp = new EdgeC();
    temp = e1;
    e1 = e2;
    e2 = temp;
  }
  
  
  int getVolumeSign(FaceC f, VertexC p)
  {
    double  vol;
    int     voli = 0;
    double  ax, ay, az, bx, by, bz, cx, cy, cz, dx, dy, dz;
    double  bxdx, bydy, bzdz, cxdx, cydy, czdz, axdx, aydy, azdz;
    
    ax = f.verArr[0].posArr[0];
    ay = f.verArr[0].posArr[1];
    az = f.verArr[0].posArr[2];
    bx = f.verArr[1].posArr[0];
    by = f.verArr[1].posArr[1];
    bz = f.verArr[1].posArr[2];
    cx = f.verArr[2].posArr[0];
    cy = f.verArr[2].posArr[1];
    cz = f.verArr[2].posArr[2];
    dx = p.posArr[0];
    dy = p.posArr[1];
    dz = p.posArr[2];
    
    bxdx=bx-dx;
    bydy=by-dy;
    bzdz=bz-dz;
    cxdx=cx-dx;
    cydy=cy-dy;
    czdz=cz-dz;
    axdx=ax-dx;
    aydy=ay-dy;
    azdz=az-dz;
    
    vol = axdx * (bydy*czdz - bzdz*cydy) - aydy * (bxdx*czdz - bzdz*cxdx) + azdz * (bxdx*cydy - bydy*cxdx);
      
    
    /* The volume should be an integer. */
    if (vol > 0.5)  
      return 1;
    else if (vol < -0.5)  
      return -1;
    else               
      return  0;
  }
  
  FaceC makeFace(VertexC v0, VertexC v1, VertexC v2, FaceC foldFace)
  {
    if (debugF)
      println("makeFace():");
    FaceC f;
    EdgeC e0, e1, e2;
    
    
    if (foldFace == null) { // initial triangle
      e0 = edgeList.insertDummyEdge();
      e1 = edgeList.insertDummyEdge();
      e2 = edgeList.insertDummyEdge();
    }
    else { //
      e0 = foldFace.edgeArr[2];
      e1 = foldFace.edgeArr[1];
      e2 = foldFace.edgeArr[0];
    }
    
    e0.verArr[0] = v0;
    e0.verArr[1] = v1;
    e1.verArr[0] = v1;
    e1.verArr[1] = v2;
    e2.verArr[0] = v2;
    e2.verArr[1] = v0;
    
    f = faceList.insertDummyFace();
    f.edgeArr[0] = e0;
    f.edgeArr[1] = e1;
    f.edgeArr[2] = e2;
    f.verArr[0] = v0;
    f.verArr[1] = v1;
    f.verArr[2] = v2;
    
    e0.faceAdjArr[0] = f;
    e1.faceAdjArr[0] = f;
    e2.faceAdjArr[0] = f;
    
    return f; 
  }
  
  
  // function to check whether 3 points are collinear
  boolean isCollinear(VertexC a, VertexC b, VertexC c)
  {
    return ( c.posArr[2] - a.posArr[2] ) * ( b.posArr[1] - a.posArr[1] ) -
      ( b.posArr[2] - a.posArr[2] ) * ( c.posArr[1] - a.posArr[1] ) == 0
      && ( b.posArr[2] - a.posArr[2] ) * ( c.posArr[0] - a.posArr[0] ) -
      ( b.posArr[0] - a.posArr[0] ) * ( c.posArr[2] - a.posArr[2] ) == 0
      && ( b.posArr[0] - a.posArr[0] ) * ( c.posArr[1] - a.posArr[1] ) -
      ( b.posArr[1] - a.posArr[1] ) * ( c.posArr[0] - a.posArr[0] ) == 0;
  }
  
  
  
  // function group for cleaning
  
  void cleanUp()
  {
    cleanEdges();
    cleanFaces();
    cleanVertices();
  }
  
  void cleanEdges()
  {
    EdgeC e = edgeList.headEdge;
    do {
      if (e.newFace != null) {
        if (e.faceAdjArr[0].visibleF) {
          e.faceAdjArr[0] = e.newFace;
        }
        else {
          e.faceAdjArr[1] = e.newFace;
        }
        e.newFace = null; 
      }
      e = e.nextEdge;
    } while (e != edgeList.headEdge);
    
    while (edgeList.headEdge != null && edgeList.headEdge.deleteToBeF) {
      e = edgeList.headEdge;
      edgeList.deleteEdge(e);
    }
    
    EdgeC t;
    e = edgeList.headEdge.nextEdge;
    do {
      if (e.deleteToBeF) {
        t = e;
        e = e.nextEdge;
        edgeList.deleteEdge(t);
      }
      else {
        e = e.nextEdge;
      }
    } while (e != edgeList.headEdge);
  }


  void cleanFaces()
  {
    FaceC f;
    while (faceList.headFace != null && faceList.headFace.visibleF) {
      f = faceList.headFace;
      faceList.deleteFace(f);
    }
    f = faceList.headFace.nextFace;
    
    do {
      if (f.visibleF) {
        FaceC t = f;
        f = f.nextFace;
        faceList.deleteFace(t);
        
        
      }
      else
        f = f.nextFace;
    } while (f != faceList.headFace);
  }
  
  void cleanVertices()
  {
    // endpoints of existent edges should be on hull 
    EdgeC e = edgeList.headEdge;
    do {
      e.verArr[0].onhullF = e.verArr[1].onhullF = ON_HULL;
      e = e.nextEdge;
    } while (e != edgeList.headEdge);
    
    // delete processed but not onhull vertices
    VertexC v;
    while (verList.headVer != null && verList.headVer.processedF && !verList.headVer.onhullF) {
      v = verList.headVer;
      verBeRemovedIdArr.add(v.id);
      verBeRemoved  = new VertexC(v.posArr[0], v.posArr[1], v.posArr[2]);
      verList.deleteVer(v);
    }
    v = verList.headVer.nextVer;
    do {
      if (v.processedF && !v.onhullF) {
        VertexC t = v;
        v = v.nextVer;
        verBeRemovedIdArr.add(t.id);
        verBeRemoved  = new VertexC(t.posArr[0], t.posArr[1], t.posArr[2]);
        verList.deleteVer(t);
      }
      else
        v = v.nextVer;
    } while (v != verList.headVer);
    
    // reset existent vertices' flags
    v = verList.headVer;
    do {
      v.duplicateEdge = null;
      v.onhullF = !ON_HULL;
      v = v.nextVer;
    } while (v != verList.headVer);
  }
  
  void cleanFV()
  {
    verBeRemoved = null;
    verBeRemovedIdArr.clear();
    faceBeRemovedArr.clear();
    
    for (int i = 0; i < faceAddedArr.size(); ++i) {
      VertexC[] v = faceAddedArr.get(i);//[0], faceAddedArr.get(i)[1], faceAddedArr.get(i)[2])};
      faceBeDrawnArr.add(v);
    }
    faceBeDrawnCount = faceBeDrawnArr.size();
    faceAddedArr.clear();  
    
  }
}
