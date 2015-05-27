import SimpleOpenNI.*;
import java.awt.*;
import java.awt.event.KeyEvent;

Robot robot;
PVector convLeftHand;
PVector leftHand;
int midpoint;

int yDrum;
boolean rDrum, lDrum, rRim, lRim;

SimpleOpenNI kinect;

PFont f;

int[] userMap;

void setup()
{
  
  try {
  robot = new Robot();
}
catch(AWTException a)
{
  
}
  
  size(640, 480, P3D);
  background(0);
  noStroke();
 
  
  kinect = new SimpleOpenNI(this);
  kinect.enableDepth();
  kinect.enableUser();
  
  
  
}

void draw()
{  
  background(0);
  kinect.update();
  
  
  int[] users = kinect.getUsers();
  if(users.length > 0)
  {
    int userId = users[0];    
    
    if(kinect.isTrackingSkeleton(users[0]))
    {     
      handData(users[0]);
    }
    
  }
}

void onNewUser(SimpleOpenNI ourContect, int userId)
{
  kinect.startTrackingSkeleton(userId);
}

void handData(int userId)
{
  
  leftHand = new PVector();
  PVector rightHand = new PVector();
  PVector torso = new PVector();
       
  float confidenceL = kinect.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_LEFT_HAND,leftHand);
  float confidenceR = kinect.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_RIGHT_HAND,rightHand);
  float confidenceTorso = kinect.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_TORSO,torso);
       
  convLeftHand = new PVector();
  kinect.convertRealWorldToProjective(leftHand, convLeftHand);
       
  PVector convRightHand = new PVector();
  kinect.convertRealWorldToProjective(rightHand, convRightHand);
  
  PVector convTorso = new PVector();
  kinect.convertRealWorldToProjective(torso, convTorso);
  println(leftHand.z);
  // make test line
  
  if(Math.abs(leftHand.z - torso.z) < 300)
      fill(255,0,0);
  else
      fill(0, 0, 255);
  ellipse(convLeftHand.x, convLeftHand.y, 25, 25);
   if(Math.abs(rightHand.z - torso.z) < 300)
      fill(255,0,0);
  else
      fill(0, 0, 255);
  ellipse(convRightHand.x, convRightHand.y, 25, 25);
  fill(255,255,255);
  ellipse(width/2, yDrum, 25, 25);
  
  if(convLeftHand.y > yDrum - 10)
  {
    if(leftHand.z >= midpoint)
    {
        if(!lDrum)
        {
          lDrum = true;
          robot.keyPress(KeyEvent.VK_F);
          
          println("LDRUM");
         //kkeyHit  
        }
    }
    else
    {
      if(lDrum)
        robot.keyRelease(KeyEvent.VK_F);
      lDrum = false;  
    }
    
    if(leftHand.z < midpoint)
    {
      if(!lRim)
      {
         lRim = true;
         robot.keyPress(KeyEvent.VK_D);
         println("LRIM");
        //keyHit  
      }
    }
    else
    {
      if(lRim)
        robot.keyRelease(KeyEvent.VK_D);
      lRim = false;
    }
  }
  else
  {
    if(lDrum)
        robot.keyRelease(KeyEvent.VK_F);
    if(lRim)
        robot.keyRelease(KeyEvent.VK_D); 
    lDrum = false;
    lRim = false;
  }
  
  if(convRightHand.y > yDrum - 10)
  {
    if(rightHand.z >= midpoint)
    {
        if(!rDrum)
        {
          rDrum = true;
          robot.keyPress(KeyEvent.VK_J);
          
          println("RDRUM");
         //kkeyHit  
        }
    }
    else
    {
      if(rDrum)
        robot.keyRelease(KeyEvent.VK_J);
      lDrum = false;  
    }
    
    if(rightHand.z < midpoint)
    {
      if(!rRim)
      {
         rRim = true;
         robot.keyPress(KeyEvent.VK_K);
         println("LRIM");
        //keyHit  
      }
    }
    else
    {
      if(rRim)
        robot.keyRelease(KeyEvent.VK_K);
      rRim = false;
    }
  }
  else
  {
    if(rDrum)
        robot.keyRelease(KeyEvent.VK_J);
    if(rRim)
        robot.keyRelease(KeyEvent.VK_K); 
    rDrum = false;
    rRim = false;
  }
  
 
}

void keyPressed()
{
  if (key == CODED) {
    if (keyCode == UP) {
      yDrum = (int)convLeftHand.y;
      midpoint = (int)leftHand.z;
    }
  }
}

