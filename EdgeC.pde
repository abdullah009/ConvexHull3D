
class EdgeC
{
  FaceC[] faceAdjArr; // 2 faces adjacent to the edge
  VertexC[] verArr; // 2 endpoints
  EdgeC nextEdge, prevEdge; // next and prev edges of edgelist
  FaceC newFace; // newface being added
  boolean deleteToBeF; // whether edge to be deleted
  
  // default constructor function
  EdgeC()
  {
    faceAdjArr  = new FaceC[2];
    faceAdjArr[0] = faceAdjArr[1] = null;
      
    verArr  = new VertexC[2];
    verArr[0] = verArr[1] = null;
    
    newFace  = null;
    deleteToBeF  = false;
    nextEdge = prevEdge = null;
  }
  
  // function to print edge
  String printEdge()
  {
    String str  = "[" + verArr[0].printVertex() + ", " + verArr[1].printVertex() + "]";
    println(str);  
    return str;
  }
}
