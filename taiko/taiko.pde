import SimpleOpenNI.*;
import java.awt.*;
import java.awt.event.KeyEvent;

Robot robot;

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
 
  
  kinect = new SimpleOpenNI(this);
  kinect.enableDepth();
  kinect.enableUser();
  
  
  
}

void draw()
{  
  background(0);
  kinect.update();
  
  PImage depth = kinect.depthImage();
  image(depth,0,0);
  
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
  
  PVector leftHand = new PVector();
  PVector rightHand = new PVector();
  PVector torso = new PVector();
       
  float confidenceL = kinect.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_LEFT_HAND,leftHand);
  float confidenceR = kinect.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_RIGHT_HAND,rightHand);
  float confidenceTorso = kinect.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_RIGHT_HIP,torso);
       
  PVector convLeftHand = new PVector();
  kinect.convertRealWorldToProjective(leftHand, convLeftHand);
       
  PVector convRightHand = new PVector();
  kinect.convertRealWorldToProjective(rightHand, convRightHand);
  
  PVector convTorso = new PVector();
  kinect.convertRealWorldToProjective(torso, convTorso);
  
  // make test line
  fill(255,0,0);
  ellipse(convLeftHand.x, convLeftHand.y, 50, 50);
  fill(0,0,255);
  ellipse(convRightHand.x, convRightHand.y, 50, 50);
  ellipse(convTorso.x, convTorso.y, 50, 50);
  stroke(0,255,0);
  strokeWeight(5);
  line(convLeftHand.x, convLeftHand.y, convRightHand.x, convRightHand.y);
  
  if(convLeftHand.y < convTorso.y)
  {
    if(Math.abs(leftHand.z - torso.z) < 200)
    {
        if(!lDrum)
        {
          lDrum = true;
          robot.keyPress(KeyEvent.VK_F);
          robot.keyRelease(KeyEvent.VK_F);
          println("LDRUM");
         //kkeyHit  
        }
    }
    else
    {
      lDrum = false;  
    }
    
    if((Math.abs(leftHand.z - torso.z) >= 200))
    {
      if(!lRim)
      {
         lRim = true;
         robot.keyPress(KeyEvent.VK_D);
         robot.keyRelease(KeyEvent.VK_D);
         println("LRIM");
        //keyHit  
      }
    }
    else
    {
      lRim = false;
    }
  }
  
  if(convRightHand.y < convTorso.y)
  {
    if(Math.abs(rightHand.z - torso.z) < 200)
    {
        if(!rDrum)
        {
          rDrum = true;
          robot.keyPress(KeyEvent.VK_J);
          robot.keyRelease(KeyEvent.VK_J);
          println("rDRUM");
         //kkeyHit  
        }
    }
    else
    {
      rDrum = false;  
    }
    
    if((Math.abs(rightHand.z - torso.z) >= 200))
    {
      if(!rRim)
      {
         rRim = true;
         robot.keyPress(KeyEvent.VK_K);
          robot.keyRelease(KeyEvent.VK_K);
          println("RRIM");
        //keyHit  
      }
    }
    else
    {
      rRim = false;
    }
  }
  
 
}

