
class VertexListC
{
  int totalVer;
  VertexC headVer;
  
  // default constructor function
  VertexListC()
  {
    totalVer  = 0;
    headVer   = null;
  }
  
  
  // function to initialize head pointer
  void initHeadVer(VertexC ver)
  {
    headVer  = new VertexC();
    headVer  = ver;
    headVer.nextVer  = ver;
    headVer.prevVer  = ver;
    totalVer  = 1;
  }
  
  // function to insert an dummy vertex
  VertexC insertDummyVertex()
  {
    VertexC ver  = new VertexC();
    insertVer(ver);
    return ver;
  }
  
  
  // function to insert new vertex
  void insertVer(VertexC ver)
  {
    if (headVer == null)
      initHeadVer(ver);
    else
    {
      ver.nextVer  = headVer;
      ver.prevVer  = headVer.prevVer;
      headVer.prevVer.nextVer  = ver;
      headVer.prevVer  = ver;
    }
  }
  
  // function to delete an element from the list
  void deleteVer(VertexC ver)
  {
    if (headVer == headVer.nextVer)
      headVer  = null;
    else if(headVer == ver)
      headVer  = headVer.nextVer;
      
    ver.prevVer.nextVer  = ver.nextVer;
    ver.nextVer.prevVer  = ver.prevVer;
    --totalVer;
  }
  
  // Function to print vertices
  void printVertexList()
  {
    if (headVer == null)
      return;
    VertexC ver  = headVer;
    do
    {
      ver.printVertex();
      ver  = ver.nextVer;
    } while(ver != headVer);
  }
}  
