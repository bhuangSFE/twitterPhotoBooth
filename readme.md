##TwitterPhotoBooth.pde

This example takes a photo when the spacebar key is pressed and will tweet it out with a 
message. You'll need to login and create an AUTH token at https://apps.twitter.com/

Insert these into the code. There is a boolean variable called tweet that hard codes whether 
or not the code will send out the tweet. This example will show a dialog box to confirm before
tweeting out.

This is dependant on the following libraries:
processing.video
processing.sound
twitter4j
javax.swing.JOptionPane.*;
java.util.*