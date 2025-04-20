// Constants
final int NUM_PLATFORMS = 10;
final int PLAYER_HEALTH = 3;
final float SCROLL_SPEED = -2;
final int INVINCIBILITY_DURATION = 180; // 3 seconds at 60 FPS
final int DAMAGE_BLINK_DURATION = 30;
final int ANIMATION_INTERVAL = 10;
final int FRAME_RATE = 60; // Frames per second
final int WIN_MINIMUM_TIME = 60; // Time in seconds required to win
final float SLIDE_SPEED = 5; // Speed at which the win image slides in

// Game Variables
Platform[] platforms = new Platform[NUM_PLATFORMS]; // Array to store all platforms
Player player; // The player object
PImage[][] playerSprites = new PImage[3][];
float bgY1 = 0, bgY2; // Vertical positions of the two background images for scrolling
PImage bg; // Background image
PImage platformImage; // Images for platforms
PImage winImage; // The image displayed when the player wins
float winImageY; // The vertical position of the win image
boolean gameWon = false; // Flag to indicate if the player has won
int survivalTime = 0; // Time the player has survived in seconds
int frameCounter = 0; // Counter to track frames for timing purposes
float winImageHeight = 50;

// Setup
void setup() {
  size(400, 600);
  loadAssets();
  initializeGame();
}

void loadAssets() {
  bg = loadImage("background.png");
  bg.resize(width, 0);
  bgY2 = -bg.height;
  platformImage = loadImage("cloud.png");
  winImage = loadImage("win_image.png"); // Load the win image
  winImage.resize(width, 0); // Resize the win image to fit the screen
  winImageHeight = winImage.height;

  // Load player sprites
  playerSprites[0] = new PImage[1]; // idle
  playerSprites[1] = new PImage[2]; // left
  playerSprites[2] = new PImage[2]; // right

  playerSprites[0][0] = loadImage("idle.png");
  playerSprites[1][0] = loadImage("move_left1.png");
  playerSprites[1][1] = loadImage("move_left2.png");
  playerSprites[2][0] = loadImage("move_right1.png");
  playerSprites[2][1] = loadImage("move_right2.png");
}

void initializeGame() {
  player = new Player();
  initializePlatforms();
  survivalTime = 0;
  frameCounter = 0;
  gameWon = false;
  winImageY = height; // Start the win image off-screen
}

void initializePlatforms() {
  // stage 1-1: Initialize platforms with random positions
  for (int i = 0; i < NUM_PLATFORMS; i++) {
    platforms[i] = new Platform(0, width, 0, height, i, NUM_PLATFORMS);
  }
}

// Main Game Loop
void draw() {
  scrollBackground(); // Scroll the background continuously

  if (player.health > 0) {
    updateGame(); // Update the game state if the player is alive
  } else {
    endGame(); // Handle the end of the game if the player is dead
  }

  for (Platform platform : platforms) {
    platform.update(); // Update the platform's position
    platform.display(); // Display the platform on the screen
  }
  player.update(); // Update the player's position and state
  player.display(); // Display the player on the screen

  if (gameWon) {
    displayWinImage(); // Render the win image later than the player, so it covers the player
  }
}

// Background Scrolling
void scrollBackground() {
  image(bg, 0, bgY1); // Draw the first background image
  image(bg, 0, bgY2); // Draw the second background image

  bgY1 += SCROLL_SPEED; // Move the first background image up
  bgY2 += SCROLL_SPEED; // Move the second background image up

  // Reset the background positions when they scroll out of view
  if (bgY1 <= -bg.height) bgY1 = bgY2 + bg.height;
  if (bgY2 <= -bg.height) bgY2 = bgY1 + bg.height;
}

// Updates the game state every frame
void updateGame() {
  frameCounter++;
  // Stage 3-2: Calculate survival time (in seconds) based on frame count
  
  // End of stage 3-2
  if (survivalTime >= WIN_MINIMUM_TIME) {
    gameWon = true; // Mark the game as won if the survival time is reached
  }
  displayHealth(); // Display the player's health and survival time
}

// Handles the end of the game
void endGame() {
  player.forceDropToBottom(); // Allow the player to drop to the bottom of the screen
  if (gameWon) {
    displayWinMessage(); // Show a congratulatory message if the player has won
  } else {
    displayGameOver(); // Show a game-over message if the player has lost
  }
}

// Updates and displays all platforms
void updatePlatforms() {
  for (Platform platform : platforms) {
    platform.update(); // Update the platform's position
    platform.display(); // Display the platform on the screen
  }
}

  // Stage 2-3: Check if a lands on b
 
  // End of stage 2-3


// Win Image Functions
void displayWinImage() {
  if (winImageY > height - winImageHeight) {
    winImageY -= SLIDE_SPEED;
  } else {
    winImageY = height - winImageHeight; // Stop at the bottom of the screen
  }
  image(winImage, 0, winImageY, width, winImageHeight); // Displays the win image at its current position
}

// Display Functions
void displayHealth() {
  // Stage 3-1: Display the player's health and survival time
  
  // End of stage 3-1
}

// Displays a game-over message when the player loses
void displayGameOver() {
  textAlign(CENTER, CENTER);
  textSize(32);
  fill(255, 0, 0);
  text("Game Over", width / 2, height / 2 - 20);

  textSize(16);
  fill(0);
  text("You survived: " + survivalTime + " seconds", width / 2, height / 2 + 20);
  text("Press R to restart", width / 2, height / 2 + 40);
}

// Displays a congratulatory message when the player wins
void displayWinMessage() {
  textAlign(CENTER, CENTER);
  textSize(32);
  fill(0, 255, 0);
  text("Congratulations!", width / 2, height / 2 - 20);

  textSize(16);
  fill(0);
  text("You survived: " + survivalTime + " seconds", width / 2, height / 2 + 20);
  text("Press R to restart", width / 2, height / 2 + 40);
}

// Input Handling
void keyPressed() {
  if (key == 'a' || key == 'A') {
    player.setMovement(-1); // Move left
  } else if (key == 'd' || key == 'D') {
    player.setMovement(1); // Move right
  } else if (key == 'r' || key == 'R') {
    restartGame();
  }
}

void keyReleased() {
  if (key == 'a' || key == 'A' || key == 'd' || key == 'D') {
    player.setMovement(0); // Stop moving
  }
}

void restartGame() {
  initializeGame();
}

// Platform Class: Represents a platform in the game
class Platform {
  float xMin, xMax, yMin, yMax; // Boundaries for platform position
  float xPos, yPos; // Position of the platform
  final float PLATFORM_WIDTH = 80; // Width of the platform
  final float PLATFORM_HEIGHT = 20; // Height of the platform
  final float PLATFORM_SPEED = -2; // Speed of the platform

  Platform(float newXMin, float newXMax, float newYMin, float newYMax, int index, int totalPlatforms) {
    // Save variables
    xMin = newXMin; // Minimum x position for the platform
    xMax = newXMax; // Maximum x position for the platform
    yMin = newYMin; // Minimum y position for the platform
    yMax = newYMax; // Maximum y position for the platform
    // Stage 1-1: generate random horizontal positions for the platforms, while distributed evenly in vertical space
    
    // End of stage 1-1
  }

  void update() {
    // Stage 1-2: Move the platform up and reset its position when it goes out of view
  
    // End of stage 1-2
  }

  void display() {
    image(platformImage, xPos, yPos, PLATFORM_WIDTH, PLATFORM_HEIGHT); // Draw the platform image at its position
  }
}

// Player Class: Represents the player in the game
class Player {
  float x, y, w = 30, h = 60, speed = 5, gravity = 0.4, velocity = 0; // Position, size, speed, and physics
  int moveDir = 0; // Movement direction
  int health = PLAYER_HEALTH; // Player's health
  int spriteIndex = 0; // 0=idle, 1=left, 2=right
  boolean invincible = true, damaged = false; // Flags for invincibility and damage states
  int invincibilityTimer = INVINCIBILITY_DURATION, damageTimer = 0; // Timers for invincibility and damage
  int animationFrame = 0, animationTimer = 0; // Animation frame and timer

  Player() {
    x = width / 2; // Start the player in the middle of the screen
    y = 0; // Start the player at the top of the screen
  }

  void update() {
    if (health <= 0) return; // Stop updating if the player is dead
    horizontalMovement(); // Handle horizontal movement
    verticalMovement(); // Handle vertical movement
    setSpriteIndex(); // Set the sprite index based on movement direction
    updateAnimation(); // Update the player's animation
  }

  void horizontalMovement() {
    // Stage 2-1: Handle horizontal movement based on moveDir, which is set by keyPressed and keyReleased
  
    // End of stage 2-1
  }

  void verticalMovement() {
    // Stage 2-2: Handle vertical movement based on gravity and velocity
   
    // End of stage 2-2
  }

  void setSpriteIndex() {
    // Stage 2-1: Set the sprite index based on player's movement direction
   
    // End of stage 2-1
  }

  void handleCeilingCollision() {
    // Stage 2-4: When the player collides with the ceiling, stop upward movement and reset velocity
   
    // End of stage 2-4

    // Stage 3-3: Getting damage - If the player collides with the ceiling, subtract health by 1
    
    // End of stage 3-3
  }

  void handleBottomCollision() {
    // Stage 2-4: We're not going to do anything here, but can add this to prevent the player from falling off the screen temporarily
    // y = height - h; // Uncomment this line to prevent falling off the screen
    // velocity = 0; // Reset the player's velocity
    // End of stage 2-4
    // Stage 3-3: Getting damage - If the player falls off the screen, set health to 0
   
    // End of stage 3-3
  }

  void handlePlatformCollision() {
    // Stage 2-3: Check for collisions with platforms
   
    // End of stage 2-3
  }


  void updateAnimation() {
    // Stage 3-4: Cycle through animation frames based on timer
    
    // End of stage 3-4
  }

  void display() {
    PImage currentImage = playerSprites[spriteIndex][animationFrame];
    if (damaged && frameCount % 10 < 5) {
      tint(255, 0, 0);
    } else {
      noTint();
    }
    image(currentImage, x, y, w, h);
    noTint();
  }

  void setMovement(int dir) {
    moveDir = dir;
  }

  void forceDropToBottom() {
    velocity += gravity; // Apply gravity to the player's velocity
    y += velocity; // Update the player's vertical position
    if (y > height) {
      y = height;
    }
  }
}
