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

    var computeWidth = function() {
        return window.innerWidth;
    };
    
    var computeHeight = function() {
        return window.innerHeight;
    };
    
    $scope.width = computeWidth();
    $scope.height = computeHeight();
    
    angular.element(window).bind('resize', function() {
        $scope.width = computeWidth();
        $scope.height = computeHeight();
        $scope.$apply();
    });
}

function MyCtrl1() {}
MyCtrl1.$inject = [];


function MyCtrl2() {
}
MyCtrl2.$inject = [];
