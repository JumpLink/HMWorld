'use strict';

/* Directives */


var librpg = angular.module('librpg.directives', []);

// try window-size part on on http://jsfiddle.net/bY5qe/
librpg.directive('rpgGame', function ($window) {
    return {
        restrict: 'E',
        replace: false,
        transclude: false,
        scope:{
            fullscreen:"="
        },
        controller: function ($scope) {
            $scope.setSize = function () {
                $scope.width = $window.innerWidth;
                $scope.height = $window.innerHeight;
            };
        },
        link: function (scope, elm, attrs) {
            if(scope.fullscreen === true) {
                scope.width = $window.innerWidth;
                scope.height = $window.innerHeight;
                angular.element($window).bind('resize', function () {
                    scope.$apply("setSize()");
                });
            } else {
                scope.window = {
                    width: attrs.width,
                    height: attrs.height
                };
            }
        },
        template:
            '<rpg-layer position="over-hero" witdh="{{width}}" height="{{height}}" ></rpg-layer>'+
            '<canvas witdh="{{width}}" height="{{height}}" style="width:{{width}}px; height:{{height}}px"></canvas>'+
            '<rpg-layer position="under-hero"></rpg-layer>'
    };
});

// librpg.directive('rpgLayer', function () {
//     return {
//         restrict: 'E',
//         scope:{
//             position:"=",
//             witdh:"=",
//             height:"="
//         },
//         link: function (scope, elm, attrs) {

//         },
//         template:
//             '<img style="width:{{width}}px; height:{{height}}px"><img>'
//     };
// });