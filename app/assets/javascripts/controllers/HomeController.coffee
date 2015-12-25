@app.controller 'HomeController', ( $scope, $http, Auth, Card ) ->

  cardService = new Card()

  Auth.currentUser().then ( user ) ->
    $scope.user = user
    splitted    = user.email.split("@")
    $scope.user.username = splitted[0]

  # -- Request Api to create deck -- #
  $http(
   method: 'GET',
   url: 'http://deckofcardsapi.com/api/deck/new/shuffle/?deck_count=6'
  ).then (response) ->
    $scope.deckId = response.data.deck_id

  # -- Scope Method -- #

  $scope.deal = ->
    $http(
     method: 'GET',
     url: 'http://deckofcardsapi.com/api/deck/'+$scope.deckId+'/draw/?count=2'
    ).then (response) ->
      $scope.banqueCards = response.data.cards
      $scope.banquePoints = cardService.count( $scope.banqueCards )

    $http(
     method: 'GET',
     url: 'http://deckofcardsapi.com/api/deck/'+$scope.deckId+'/draw/?count=2'
    ).then (response) ->
      $scope.playerCards = response.data.cards
      $scope.playerPoints = cardService.count( $scope.playerCards )

  $scope.hit = ->
    $http(
     method: 'GET',
     url: 'http://deckofcardsapi.com/api/deck/'+$scope.deckId+'/draw/?count=1'
    ).then (response) ->
      $scope.playerCards.push response.data.cards[0]
      value = cardService.value( response.data.cards[0] )
      $scope.playerPoints += value

  $scope.stand = ->
    $http(
     method: 'GET',
     url: 'http://deckofcardsapi.com/api/deck/'+$scope.deckId+'/draw/?count=1'
    ).then (response) ->
      $scope.banqueCards.push response.data.cards[0]
      value = cardService.value( response.data.cards[0] )
      $scope.banquePoints += value

    $scope.$watch 'banquePoints', ( bc ) ->
      if bc < 21
        $http(
         method: 'GET',
         url: 'http://deckofcardsapi.com/api/deck/'+$scope.deckId+'/draw/?count=1'
        ).then (response) ->
          $scope.banqueCards.push response.data.cards[0]
          value = cardService.value( response.data.cards[0] )
          $scope.banquePoints += value
      if bc is 21
        console.log "perdu"
      if bc > 21
        console.log "gagner"
