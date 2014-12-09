

class EdgeListC
{
  int totalEdge;
  EdgeC headEdge;
  
  // default constructor function
  EdgeListC()
  {
    headEdge  = null;
    totalEdge  = 0;
  }
  
  // function to initialize head edge
  void initHeadEdge(EdgeC edge)
  {
    headEdge  = new EdgeC();
    headEdge  = edge;
    headEdge.nextEdge  = headEdge;
    headEdge.prevEdge  = headEdge;
    totalEdge  = 1;
  }
  
  // function to insert a dummy edge
  EdgeC insertDummyEdge()
  {
    EdgeC edge  = new EdgeC();
    insertEdge(edge);
    return edge;
  }
  
  // function to insert a given edge
  void insertEdge(EdgeC edge)
  {
    if (headEdge == null)
      initHeadEdge(edge);
    else
    {
      edge.nextEdge  = headEdge;
      edge.prevEdge  = headEdge.prevEdge;
      headEdge.prevEdge.nextEdge  = edge;
      headEdge.prevEdge  = edge;
      ++totalEdge;
    }
  }
  
  // funtion to delete a specific edge
  void deleteEdge(EdgeC edge)
  {
    if (headEdge == headEdge.nextEdge)
      headEdge  = null;
    else if (headEdge == edge)
      headEdge  = headEdge.nextEdge;
    
    edge.prevEdge.nextEdge  = edge.nextEdge;
    edge.nextEdge.prevEdge  = edge.prevEdge;
    --totalEdge;   
  }
  
  
  // funtion to print edge list
  void printEdgeList()
  {
    if (headEdge == null)
      return;
    EdgeC edge  = headEdge;
    do
    {
      edge.printEdge();
      edge  = edge.nextEdge;
    } while(edge != headEdge);
  }
}
