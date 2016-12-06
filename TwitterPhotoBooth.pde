//Simple photo booth program written in Processing
//takes a photo with spacebar keypress and overlays text above & below photo
//saves photo for sharing.

import processing.video.*;

import processing.sound.*;
SoundFile shutterSound;

import static javax.swing.JOptionPane.*;

/*Twitter-related stuff*/
import twitter4j.conf.*;
import twitter4j.*;
import twitter4j.auth.*;
import twitter4j.api.*;
import java.util.*;

boolean tweet = true;

String TopTitle = "CSEDWeek Boulder 2016";
String BottomTitle = "SparkFun Electronics - MaKeyMaKey";
String baseTweet = "Excited to be at #CSEDWeek Boulder 2016 Red Hawk Elementary @SVVSD! #HourOfCode @SparkFunEDU @csedlive";
int borderColor = 0x003880;
String imgFilename;

int borderWidth = 80;

Capture cam;
int imgNum;
boolean takePhoto;
boolean lastPressed;
int dlgConfirm;

File lastImage; 
PImage imgSparkFunLogo;

Status lastStatus;
Twitter twitter;
ConfigurationBuilder cb = new ConfigurationBuilder();

void setup() {
  size(800, 600);
  surface.setResizable(true);
  imgSparkFunLogo = loadImage("sparkFunEDU.png");

  // cam = new Capture(this, 640, 480, "Logitech QuickCam Pro 9000", 30);
  cam = new Capture(this, 640, 480, 30);
  cam.start();

  String[] cameras = Capture.list();

  if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  } else {
    println("Available cameras:");
    for (int i = 0; i < cameras.length; i++) {
      println(i + " - " + cameras[i]);
    }
  }

  //Bauhaus font
  PFont font = createFont("BAUHS93.TTF", 48);
  textFont(font);
  textAlign(CENTER);

  shutterSound = new SoundFile(this, "camera-shutter-click-08.mp3");

  // setup Auth for Twitter
  cb.setOAuthConsumerKey("*****YOUR-KEY-HERE******");
  cb.setOAuthConsumerSecret("*************YOUR-KEY-HERE*************");
  cb.setOAuthAccessToken("*************YOUR-KEY-HERE***************");
  cb.setOAuthAccessTokenSecret("**********YOUR-KEY-HERE***************");

  TwitterFactory tf = new TwitterFactory(cb.build());

  twitter = tf.getInstance();
}

/********************************************************************************/
void draw() {
  if (cam.available()) {
    cam.read();
  }  

  image(cam, 0, 0, width, height);
  image(imgSparkFunLogo, width - imgSparkFunLogo.width - 10, height - imgSparkFunLogo.height - 10);

  if (tweet)
  {
    fill(0, 255, 0);
    noStroke();
    ellipse(width-35, 35, 30, 30);
    fill(0, 255, 0);
    text("Press spacebar to tweet!", width/2, 50);
  } else
  {
    fill(255, 0, 0);
    noStroke();
    ellipse(width-35, 35, 30, 30);
    fill(255, 0, 0);
    text("Press spacebar to take photo!", width/2, 50);
  }

  if (takePhoto)
  {
    if (tweet)
    {
      dlgConfirm = showConfirmDialog(null, "Do you wish to tweet this?", "Tweet?", YES_NO_OPTION);
      if (dlgConfirm == 0) {
        println("Sending tweet out");
        tweetPic(lastImage, baseTweet);
      }
    }
    takePhoto = false;
  }
}
/********************************************************************************/
void keyPressed() {
  println(key);
  if (lastPressed == false &&  key== ' ')
  {
    background(borderColor);
    image(cam, borderWidth, borderWidth, width - 2*borderWidth, height - 2*borderWidth);
    image(imgSparkFunLogo, width - borderWidth - imgSparkFunLogo.width*.9 - 10, height - borderWidth - imgSparkFunLogo.height*.9 - 10, imgSparkFunLogo.width*.9, imgSparkFunLogo.height*.9);    

    fill(255, 255, 255);
    text(TopTitle, width/2, 50 );
    text(BottomTitle, width/2, height-20);
    imgFilename = "image" + imgNum + ".jpg";
    save(imgFilename);
    imgNum++;
    
    //limit to storing 10 photos
    if(imgNum > 9)
      imgNum = 0;
    
    lastImage = new File(sketchPath() + "/" + imgFilename);
    takePhoto = true;
    shutterSound.play();
    lastPressed = true;
  }
} 
/********************************************************************************/
void keyReleased()
{
  lastPressed = false;
}
/********************************************************************************/
void tweetMessage(String tweetMsg)
{
  try
  {
    Status status = twitter.updateStatus(tweetMsg);
    System.out.println("Status updated to [" + status.getText() + "].");
  }
  catch (TwitterException te)
  {
    System.out.println("Error: "+ te.getMessage());
  }
}

/********************************************************************************/
void tweetPic(File _file, String theTweet)
{
  try
  {
    StatusUpdate status = new StatusUpdate(theTweet);
    status.setMedia(_file);
    twitter.updateStatus(status);
  }
  catch (TwitterException te)
  {
    println("Error: "+ te.getMessage());
  }
}

/********************************************************************************/
void testPassingFile(File _file)
{
  println(_file.exists());
  println(_file.getName());
  println(_file.getPath());
  println(_file.canRead());
}