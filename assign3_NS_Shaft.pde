// Constants
final int NUM_PLATFORMS = 10;
final int PLAYER_HEALTH = 3;
final float SCROLL_SPEED = -2;
final int PLAYER_FEET_OFFSET = 5; // Offset distance between the player's feet and the platform
final int INVINCIBILITY_DURATION = 180; // 3 seconds at 60 FPS
final int DAMAGE_BLINK_DURATION = 30;
final int ANIMATION_INTERVAL = 10;
final int FRAME_RATE = 60; // Frames per second
final int WIN_MINIMUM_TIME = 60; // Time in seconds required to win
final float SLIDE_SPEED = 5; // Speed at which the win image slides in

// Game Variables
float playerX, playerY, playerW = 30, playerH = 60, playerSpeed = 5;
int playerMoveDir = 0; // Movement direction (-1 for left, 1 for right, 0 for no movement)
int playerHealth = PLAYER_HEALTH; // Player movement direction and health
float[] platformX = new float[NUM_PLATFORMS]; // X positions of platforms
float[] platformY = new float[NUM_PLATFORMS]; // Y positions of platforms
float platformW = 80, platformH = 20, platformSpeed = 2; // Platform dimensions and speed
float bgY1 = 0, bgY2; // Background positions
PImage bg; // Background image
int survivalTime, frameCounter; // Survival time and frame counter

// Setup
void setup() {
  size(400, 600);
  loadAssets(); // Load assets
  initializeGame(); // Initialize game variables
}

void loadAssets() {
  bg = loadImage("background.png"); // Load the background image
  bg.resize(width, 0); // Resize the background image to fit the screen width
  // Practice 1-1: Setting up second background position
}

void initializeGame() {
  playerX = width / 2 - playerW / 2; // Center the player horizontally
  playerY = height - playerH; // Place the player at the bottom of the screen
  initializePlatforms(); // Initialize the platforms
  survivalTime = 0; // Reset survival time
  frameCounter = 0; // Reset frame counter
}

void initializePlatforms() {
  for (int i = 0; i < NUM_PLATFORMS; i++) {
    platformX[i] = random(width - platformW); // Random X position for platforms
    platformY[i] = height - (i + 1) * (height / NUM_PLATFORMS); // Evenly spaced platforms
  }
}

// Main Game Loop
void draw() {
  scrollBackground();
  updateGame(); // Call the updateGame function
  updatePlatforms(); // Update and display platforms
  updatePlayer(); // Update and display the player
  displayHealth(); // Display health and survival time
}

// Practice 1-1: Write a function to draw the background and make it scroll.
void scrollBackground() {
}

// Updates the game state every frame
void updateGame() {
  frameCounter++;
  if (frameCounter % FRAME_RATE == 0) {
    survivalTime++; // Increment survival time every second
  }
}

// Updates and displays platforms
void updatePlatforms() {
  for (int i = 0; i < NUM_PLATFORMS; i++) {
    // Update platform positions
    platformY[i] -= platformSpeed;
    if (platformY[i] < 0) {
      platformY[i] = height; // Reset the platform to the bottom
      platformX[i] = random(width - platformW); // Random X position for new platform
    }
    // Draw the platforms
    fill(255, 0, 0);
    rect(platformX[i], platformY[i], platformW, platformH);
  }
}

void updatePlayer() {
  // Practice 1-2: Write a function to handle the player's movement and constrain it within the screen.

  // Draw the player
  fill(0, 0, 255);
  rect(playerX, playerY, playerW, playerH);
}

/* Practice 1-2: Modify key input to change velocity instead of position, for smoother movement */
// Input Handling
void keyPressed() {
  if (key == 'a' || key == 'A') {
    playerX -= playerSpeed; // Move left
  } else if (key == 'd' || key == 'D') {
    playerX += playerSpeed; // Move right
  } else if (key == 'r' || key == 'R') {
    restartGame(); // Restart the game
  }
}

void keyReleased() {
  if (key == 'a' || key == 'A' || key == 'd' || key == 'D') {
    // Practice 1-2: Stop player movement when key is released
  }
}

// Display Health and Survival Time
void displayHealth() {
  fill(0);
  textSize(16);
  textAlign(LEFT, TOP);
  text("Health: " + playerHealth, 10, 20); // Display health
  text("Time: " + survivalTime + " s", 10, 40); // Display survival time
}

void restartGame() {
  initializeGame();
}

//To avoid making the code look too complex, this starter file only includes space for Level 1 tasks.
//Check the slides for what to do in later levels!
