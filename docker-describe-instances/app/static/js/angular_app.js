//AngualarJS app for searching instance in table
app = angular.module('myApps', ['ngRoute'])

.config(function($routeProvider, $locationProvider) {
    $routeProvider
    .when("/", {
        templateUrl:"/all_instances", 
        controller: "instancesCtrl"
    })
    .when("/instance/:id", {
        //implementing dynamic routing for SPA https://stackoverflow.com/questions/13681116/angularjs-dynamic-routing
            templateUrl: function(urlattr){
                return '/instance/' + urlattr.id;
            },
            controller: function($scope){
                $scope.home = false;
            }
    });
    
    // to remove the hash in href https://stackoverflow.com/questions/14319967/angularjs-routing-without-the-hash
    $locationProvider.html5Mode({
      enabled: true,
      requireBase: false
    });
})

.controller('instancesCtrl', function($scope, $http) {
    /* 
    	initializing the data on server side using Python dictionary/list. 
    	don't forget to use this method that you must do it within HTML <script>
    	
    $scope.instances = {{ list_running_instances | safe}};
    
    */
    
    //initializing the data on client-side using HTTP object JSON API call 
    $scope.home = true;
    
	$http.get("/api/all_instances").then(function (response) {
		$scope.instances = response.data;
	});
})

.directive("allInstancesDirective", function() {
    /*
        this directive not needed (idle) since using routeProvider rather to get and show views
        
        <all-instance-directive></all-instance-directive>
    */
    
    return {
        templateUrl : 'all_instances'
    };
});