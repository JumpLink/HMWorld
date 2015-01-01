(function () {
  var clock, game, layer;
  var spec = {};

  // Create a canvas to draw on
  layer = BLOCKS.layer({
    parentElement: document.getElementById("demo"),
    // height: 100,
    // width: 100
  });

  // Create a block
  block = BLOCKS.block();

  console.log(block);

  // Add a slice to the block

  // walk
  block.addSlice({
    name: 'walkSouth',
    layer: layer,
    imageSrc: "images/sprites/player1/south/walk.png", // Define sprite sheet location
    numberOfFrames: 4, // Define number of frames of animation
    frameDelay: 12,
    loop: true,
    autoPlay: true
  });

  block.addSlice({
    name: 'walkWest',
    layer: layer,
    imageSrc: "images/sprites/player1/west/walk.png",
    numberOfFrames: 4,
    frameDelay: 12,
    loop: true,
    autoPlay: true
  });

  block.addSlice({
    name: 'walkEast',
    layer: layer,
    imageSrc: "images/sprites/player1/east/walk.png",
    numberOfFrames: 4,
    frameDelay: 12,
    loop: true,
    autoPlay: true
  });

  block.addSlice({
    name: 'walkNorth',
    layer: layer,
    imageSrc: "images/sprites/player1/north/walk.png",
    numberOfFrames: 4,
    frameDelay: 12,
    loop: true,
    autoPlay: true
  });

  // stand
  block.addSlice({
    name: 'standSouth',
    layer: layer,
    imageSrc: "images/sprites/player1/south/stand.png", // Define sprite sheet location
    numberOfFrames: 1, // Define number of frames of animation
    frameDelay: 12,
    loop: true,
    autoPlay: true
  });

  block.addSlice({
    name: 'standWest',
    layer: layer,
    imageSrc: "images/sprites/player1/west/stand.png",
    numberOfFrames: 1,
    frameDelay: 12,
    loop: true,
    autoPlay: true
  });

  block.addSlice({
    name: 'standEast',
    layer: layer,
    imageSrc: "images/sprites/player1/east/stand.png",
    numberOfFrames: 1,
    frameDelay: 12,
    loop: true,
    autoPlay: true
  });

  block.addSlice({
    name: 'standNorth',
    layer: layer,
    imageSrc: "images/sprites/player1/north/stand.png",
    numberOfFrames: 1,
    frameDelay: 12,
    loop: true,
    autoPlay: true
  });

  var animations = function () {
    block.setSlice('walkSouth', function () {
      console.log("animation walkSouth completed");
    });
    setTimeout(function () {
      block.setSlice('walkWest', function () {
        console.log("animation standWest completed");
      });
      setTimeout(function () {
        block.setSlice('walkNorth', function () {
          console.log("animation walkNorth completed");
        });
        setTimeout(function () {
          block.setSlice('walkNorth', function () {
            console.log("animation walkNorth completed");
          });
          setTimeout(function () {
            block.setSlice('walkEast', function () {
              console.log("animation walkEast completed");
            });
          }, 2000);
        }, 2000);
      }, 2000);
    }, 2000);
  }

  setInterval(function(){
    animations();
  }, 10000);

  animations();

  // Create a clock
  clock = BLOCKS.clock();

  // Update and render the block on each tick of the clock
  clock.addEventListener("tick", function () {
    block.update();
    if (block.dirty) { // Clear the layer if the block is dirty
      layer.clear();
    }
    block.render();
  });

  // Start the clock
  clock.start();
}());
