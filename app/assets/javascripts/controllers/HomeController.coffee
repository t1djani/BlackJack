@app.controller 'HomeController', ( $scope, $http, Auth, Card ) ->

  cardService = new Card()

  Auth.currentUser().then ( user ) ->
    $scope.user = user
    splitted    = user.email.split("@")
    $scope.user.username = splitted[0]

  $scope.deal = ->
    $http(
     method: 'GET',
     url: 'http://deckofcardsapi.com/api/deck/new/draw/?count=2'
    ).then (response) ->
      $scope.banqueCards = response.data.cards
      $scope.banquePoints = cardService.count( $scope.banqueCards )

    $http(
     method: 'GET',
     url: 'http://deckofcardsapi.com/api/deck/new/draw/?count=2'
    ).then (response) ->
      $scope.playerCards = response.data.cards
      $scope.playerPoints = cardService.count( $scope.playerCards )

  $scope.hit = ->
    $http(
     method: 'GET',
     url: 'http://deckofcardsapi.com/api/deck/new/draw/?count=1'
    ).then (response) ->
      $scope.playerCards.push response.data.cards[0]
      value = cardService.value( response.data.cards[0] )
      $scope.playerPoints += value
