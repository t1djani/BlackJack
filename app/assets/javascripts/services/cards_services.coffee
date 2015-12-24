@app.factory "Card", ->

  class Card
      constructor: ->

      count: ( cards ) ->
        for card in cards
          switch card.value
            when 'ACE' then card.value = 1
            when 'KING', 'QUEEN', 'JACK' then card.value = 10
            else card.value

        count  = cards.map ( c ) -> parseInt(c.value)
        points = eval(count.join("+"))

      value: ( card ) ->
        switch card.value
          when 'ACE' then card.value = 1
          when 'KING', 'QUEEN', 'JACK' then card.value = 10
          else card.value

        parseInt( card.value )
