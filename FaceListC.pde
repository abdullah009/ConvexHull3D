
class FaceListC
{
  int totalFace;
  FaceC headFace;
  
  // default constructor
  FaceListC()
  {
    headFace  = null;
    totalFace  = 0; 
  }
  
  // function to initialize head face
  void initHeadFace(FaceC face)
  {
    if (debugF)
      println("initHeadFace():");
    headFace  = new FaceC();
    headFace  = face;
    headFace.nextFace = headFace.prevFace  = headFace;
    totalFace  = 1;
  }
  
  // function to insert dummy face
  FaceC insertDummyFace()
  {
    FaceC face  = new FaceC();
    insertFace(face);
    return face;
  }
  
  // function to insert a face
  void insertFace(FaceC face)
  {
    if (debugF)
      println("insertFace():");
    if (headFace == null)
      initHeadFace(face);
    else
    {
      headFace.prevFace.nextFace  = face;
      face.prevFace  = headFace.prevFace;
      face.nextFace  = headFace;   
      headFace.prevFace  = face;
      ++totalFace;
    }
  }
  
  
  // function to delete a specific face
  void deleteFace(FaceC face)
  {
    if (headFace == headFace.nextFace)
      headFace  = null;
    else if (headFace == face)
      headFace  = headFace.nextFace;
      
    face.prevFace.nextFace  = face.nextFace;
    face.nextFace.prevFace  = face.prevFace;
    --totalFace;
  }
  
  // function to print face list
  void printFaceLsit()
  {
    if (headFace == null)
      return;
      
    FaceC face  = headFace;
    do
    {
      face.printFace();
      face  = face.nextFace;
    } while (face != headFace);
  }
}
