
class FaceC
{
  EdgeC[] edgeArr; // 3 edges of the face
  VertexC[] verArr; // 3 vertices of the face
  FaceC nextFace, prevFace; // nextFace and prevFace point to next and prev faces of the facelist respectively
  boolean visibleF; // whether face is visible from a new vertex
  
  // default constructor function
  FaceC()
  {
    edgeArr  = new EdgeC[3];
    edgeArr[0] = edgeArr[1] = edgeArr[2] = null;
    
    verArr  = new VertexC[3];
    verArr[0] = verArr[1] = verArr[2] = null;
    
    nextFace = prevFace = null;
    visibleF  = false;     
  }
  
  // function to print face
  void printFace()
  {
    String str  = "[1:" + edgeArr[0].printEdge() + " 2:" + edgeArr[1].printEdge() + " 3:" + edgeArr[2].printEdge() + "]";
    println(str);
  }
}
