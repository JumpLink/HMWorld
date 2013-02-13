var api_domain = 'http://localhost:3005';
var jsonp_cb = '?callback=?';

function get_map() {
    $.getJSON(api_domain+'/json/resource_manager/map_manager/testmap.tmx'+jsonp_cb,{
        filename: '1',
        size: '1',
        tilesize: '1',
        property: '1'
    },
    function(data) {
        console.log(data);
    });
}

get_map();

var under_layer = api_domain + '/image/resource_manager/map_manager/testmap.tmx/under';
var over_layer = api_domain +'/image/resource_manager/map_manager/testmap.tmx/over';

// create the Scene object
var scene = sjs.Scene({w:640, h:480});

// load the images in parallel. When all the images are
// ready, the callback function is called.
scene.loadImages([under_layer, over_layer], function() {

    // var background = scene.Layer('background', {autoClear:false});
    // var sprite = background.Sprite(under_layer);

    // create the Sprite object;
    var sp = scene.Sprite(under_layer);

    // change the visible size of the sprite
    //sp.size(55, 30);

    // apply the latest visual changes to the sprite
    // (draw if canvas, update attribute if DOM);
    sp.update();

    // change the offset of the image in the sprite
    // (this works the opposite way of a CSS background)
    //sp.offset(50, 50);

    // various transformations
    //sp.move(100, 100);
    //sp.rotate(3.14 / 4);
    //sp.scale(2);
    sp.setOpacity(0.8);

    //sp.update();
});