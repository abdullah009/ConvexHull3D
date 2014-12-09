

class VertexC
{
  int[] posArr; // x, y, z values
  int id;
  VertexC nextVer, prevVer; // next and prev vertices of vertexlist
  EdgeC duplicateEdge; // new edge to be added
  boolean onhullF, processedF; // onhullF if point is on hull; processedF if it is already processed 
  
  // default constructor function
  VertexC()
  {
    this(0, 0, 0);
  }
  
  // constructor function
  VertexC(int posX, int posY, int posZ)
  {
    posArr  = new int[3];
    posArr[0]  = posX;
    posArr[1]  = posY;
    posArr[2]  = posZ;
    
    nextVer  = prevVer = null;
    duplicateEdge  = null;
    
    onhullF  = false;
    processedF  = false;
  }
 
  // function to print vertex
  String printVertex()
  {
    String str  = "(" + posArr[0] + ", " + posArr[1] + ", " + posArr[2] + ")";
   // println(str);
    return str;
  } 
}
