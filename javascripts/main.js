var api_domain = 'http://localhost:3005';
var jsonp_cb = '?callback=?';

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

var under_layer = api_domain + '/image/resource_manager/map_manager/testmap.tmx/under';
var over_layer = api_domain +'/image/resource_manager/map_manager/testmap.tmx/over';

var hero_image = api_domain +'/image/resource_manager/spriteset_manager/testspriteset.ssx';

// create the Scene object
var scene = sjs.Scene({w:640, h:480});
var sprites = [];
var cycle;
var ticker = scene.Ticker(30, paint);

function get_frame_array_from_animation (animation, width, height) {
    var array = [];
    console.log(animation);
    for (var i = 0; i < animation.frames.length; i++)
        array.push([animation.frames[i].x*width , animation.frames[i].y*height, animation.frame_ps]);
    return array;
}

function load_data() {
    get_json_of_map_from_filename('testmap.tmx', function(data) {
        var map = data;
        get_json_of_spriteset_from_filename('testspriteset.ssx', function(data, map) {
            var hero = data;
            console.log(hero);

            // create the Sprite object;
            var sp = scene.Sprite(hero_image);

            console.log();

            // change the visible size of the sprite
            sp.size(hero.sprite_width, hero.sprite_height);

            sprites.push(sp);

            go_west = get_sprite_animation_from_name_direction(hero, "go", "north");

            cycle = sjs.Cycle(get_frame_array_from_animation(go_west, hero.sprite_width, hero.sprite_height));

            cycle.addSprites(sprites[0]);

            // load the images in parallel. When all the images are
            // ready, the callback function is called.
            scene.loadImages([hero_image, under_layer, over_layer], function() {
                
                ticker.run();

            } );



        });
    });
}

function paint() {
    // var background = scene.Layer('background', {autoClear:false});
    // var sprite = background.Sprite(under_layer);

    cycle.next(ticker.lastTicksElapsed);

    // apply the latest visual changes to the sprite
    // (draw if canvas, update attribute if DOM);
    sprites[0].update();

    // change the offset of the image in the sprite
    // (this works the opposite way of a CSS background)
    //sp.offset(50, 50);

    // various transformations
    //sp.move(100, 100);
    //sp.rotate(3.14 / 4);
    //sp.scale(2);
    //sprites[0].setOpacity(0.8);

    //onsole.log("test");

    //sp.update();
}

load_data();