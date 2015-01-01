
var api_domain = 'http://localhost:3005';
var jsonp_cb = '?callback=?';
var background = api_domain + '/image/resource_manager/map_manager/testmap.tmx/under';
var foreground = api_domain +'/image/resource_manager/map_manager/testmap.tmx/over';
var hero_image = api_domain +'/image/resource_manager/spriteset_manager/testspriteset.ssx';
var spriteset_query_string = $.param ( {
    filename: '1',
    folder: '1',
    name: '1',
    size: '1',
    sprite_size: '1',
    pixel_size: '1',
    version: '1',
    layer: {
        type: '1',
        active: '1',
        name: '1',
        number: '1',
        image_filename: '1',
        image_size: '1',
        folder: '1',
        transparency: '1',
        size: '1',
        sprite_size: '1',
        tex: '1'
    },
    animation: {
        name: '1',
        direction: '1',
        repeat: '1',
        number_of_frames: '1',
        frame_ps: '1'
    },
    frame: {
        mirror: '1',
        coord: '1'
    },
    sprite: {

    }
});
var hero_json = api_domain+'/json/resource_manager/spriteset_manager/testspriteset.ssx?'+spriteset_query_string;

// Here we build a class from scratch to create the bear
// Bear = Class.create(Sprite, // We extend the Sprite class
// {
//     initialize: function(x, y) { //initialization
//         Sprite.call(this, 32, 32); //initialization of the Sprite object
//         this.image = game.assets['chara1.gif'];
//         this.x = x;
//         this.y = y;
//         this.frame = 0;
//         game.rootScene.addChild(this);
//     },
//     //define the onenterframe eventlistener (run every frame)
//     onenterframe: function() {
//         this.x++; //move to the right
//     },
//     //define the ontouchend event listener (when the user lifts finger/finishes clicking on the bear)
//     ontouchend: function() {
//         this.frame += 3; //switch to frame of crying bear
//     }
// });



function get_json_of_map_from_filename(filename, cb) {
    $.getJSON(api_domain+'/json/resource_manager/map_manager/'+filename+jsonp_cb, {
        filename: '1',
        size: '1',
        tilesize: '1',
        property: '1'
    },
    cb);
}


function get_sprite_animation_from_name_direction(sprite, name, direction) {
    for (var i = 0; i < sprite.animations.length; i++) {
        if( sprite.animations[i].name == name && sprite.animations[i].direction == direction ) {
            return sprite.animations[i];
        }
    }
}

function get_frame_array_from_animation (animation, width) {
    var array = [];
    console.log(animation);
    for (var i = 0; i < animation.frames.length; i++)
        array.push(animation.frames[i].x + animation.frames[i].y * width );
    return array;
}

function load_data() {
    get_json_of_map_from_filename('testmap.tmx', function(data) {
        var map = data;
        get_json_of_spriteset_from_filename('testspriteset.ssx', function(data, map) {
            var hero = data;
            console.log(hero);
            enchant(); // initialize
            var game = new Game(320, 320); // game stage
            game.preload(hero_image); // preload image
            game.preload(hero_json);
            game.preload(background);
            game.preload(foreground);


            game.fps = 10;

            game.onload = function(){
                var sp = new Sprite(hero.sprite_width, hero.sprite_height);
                sp.image = game.assets[hero_image];
                go_west = get_sprite_animation_from_name_direction(hero, "go", "east");
                sp.frame =  get_frame_array_from_animation(go_west, hero.width);   // select sprite frame

                bg = new Sprite(320,320);
                bg.image = game.assets[background];

                fg = new Sprite(320,320);
                fg.image = game.assets[foreground];

                sp.tl.scaleTo(-1, 1, 10)       // turn right
                    .moveBy(288, 0, 90)   // move right
                    .scaleTo(1, 1, 10)      // turn left
                    .moveBy(-288, 0, 90)     // move left
                    .loop();                 // loop it

                game.rootScene.addChild(bg);
                game.rootScene.addChild(sp);
                game.rootScene.addChild(fg);
                console.log(game.assets[hero_json]);


            };

            game.start(); // start your game!

        });
    });
}

load_data();