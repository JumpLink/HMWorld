'use strict';

/* Controllers */

function AppCtrl($scope, $http) {
  $http({method: 'GET', url: '/api/name'}).
  success(function(data, status, headers, config) {
    $scope.name = data.name;
  }).
  error(function(data, status, headers, config) {
    $scope.name = 'Error!';
  });
}

function SizeCtrl($scope) {

    $scope.getSize = function() {
        return {width:$(window).width(),height:$(window).height()};
    };

    $scope.$watch($scope.getSize, function(newValue, oldValue) {
        $scope.window_width = newValue.width;
        $scope.window_height = newValue.height;
    });

    window.onresize = function(){
        $scope.$apply();
    };
}

function MyCtrl1() {}
MyCtrl1.$inject = [];


function MyCtrl2() {
}
MyCtrl2.$inject = [];
