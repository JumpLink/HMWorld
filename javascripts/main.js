var api_domain = 'http://localhost:3005';
var jsonp_cb = '?callback=?';
var under_layer = api_domain + '/image/resource_manager/map_manager/testmap.tmx/under';
var over_layer = api_domain +'/image/resource_manager/map_manager/testmap.tmx/over';
var hero_image = api_domain +'/image/resource_manager/spriteset_manager/testspriteset.ssx';

function get_json_of_map_from_filename(filename, cb) {
    $.getJSON(api_domain+'/json/resource_manager/map_manager/'+filename+jsonp_cb, {
        filename: '1',
        size: '1',
        tilesize: '1',
        property: '1'
    },
    cb);
}

function get_json_of_spriteset_from_filename(filename, cb) {
    $.getJSON(api_domain+'/json/resource_manager/spriteset_manager/'+filename+jsonp_cb,{
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

function get_frame_array_from_animation (animation) {
    var array = [];
    console.log(animation);
    for (var i = 0; i < animation.frames.length; i++)
        array.push(animation.frames[i].x + animation.frames[i].y * 11 );
    return array;
}

function load_data() {
    get_json_of_map_from_filename('testmap.tmx', function(data) {
        var map = data;
        get_json_of_spriteset_from_filename('testspriteset.ssx', function(data, map) {
            var hero = data;

            enchant(); // initialize
            var game = new Game(320, 320); // game stage
            game.preload(hero_image); // preload image
            game.fps = 6;

            game.onload = function(){
                var sp = new Sprite(hero.sprite_width, hero.sprite_height);
                sp.image = game.assets[hero_image];
                game.rootScene.addChild(sp);

                go_west = get_sprite_animation_from_name_direction(hero, "go", "east");

                sp.frame =  get_frame_array_from_animation(go_west);   // select sprite frame
                console.log( get_frame_array_from_animation(go_west) );
                
                sp.tl.scaleTo(-1, 1, 10)       // turn right
                    .moveBy(288, 0, 90)   // move right
                    .scaleTo(1, 1, 10)      // turn left
                    .moveBy(-288, 0, 90)     // move left
                    .loop();                 // loop it
            };

            game.start(); // start your game!

        });
    });
}

load_data();