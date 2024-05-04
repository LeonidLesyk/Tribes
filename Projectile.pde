class Projectile {
    PVector pos;
    PVector dest;
    PVector speed;
    int frameCounter;
    int totalFrames;
    PImage sprite;  // The image to be drawn for this projectile
    int size;
    float angle;

    Projectile(PVector start, PVector end, String spriteName, int frames, int size) {
        this.pos = new PVector(start.x, start.y);
        this.dest = new PVector(end.x, end.y);
        this.size = size;
        this.speed = PVector.sub(dest, start);
        this.speed.div(frames);
        this.angle = atan2(speed.y, speed.x);
        this.totalFrames = frames;
        this.frameCounter = 0;
        this.sprite = loadSprite(spriteName);
    }

    void draw() {
    if (frameCounter < totalFrames) {
        pos.add(speed);
        pushMatrix(); // Save the current transformation matrix
        translate(pos.x, pos.y); // Move the origin to the projectile's position
        rotate(angle); // Rotate the coordinate system around the new origin
        if (sprite != null) {
            image(sprite, -size/4, -size/4, size/2, size/2); // Draw the image centered at the origin
        }
        popMatrix(); // Restore the original transformation matrix
        frameCounter++;
    }
}



    boolean isDone() {
        return frameCounter >= totalFrames;
    }

    PImage loadSprite(String name) {
        try {
            return loadImage("resources/" + name + ".png");
        } catch (Exception e) {
            println("Failed to load " + name + " sprite");
            return null;
        }
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
class Arrow extends Projectile {
    Arrow(PVector start, PVector end, int size) {
        super(start, end, "arrow", 30, size);
    }
}

class Rock extends Projectile {
    Rock(PVector start, PVector end, int size) {
        super(start, end, "rock", 60, size);
    }
}

class Fireball extends Projectile {
    int side;  // Not used in current implementation, but could affect sprite

    Fireball(PVector start, PVector end, int side, int size) {
        super(start, end, "fireball" + side, 45, size);  // Moderate speed
        this.side = side;
    }
}
