local composer = require "composer"

local scene = composer.newScene()

local x,y = 250, display.contentCenterY
local boardGroup, uiGroup, cardGroup
local cards = {}
local cardShows = {}
local txt = "Trải bài"
local isCard = false
local listCard = { "0-Fool-icon.png",
                   "1-Magician-icon.png",
                   "2-High-Priestess-icon.png",
                   "3-Empress-icon.png",
                   "4-Emperor-icon.png",
                   "5-Hierophant-icon.png",
                   "6-Lovers-icon.png",
                   "7-chariot-icon.png",
                   "8-Strength-icon.png",
                   "9-Hermit-icon.png",
                   "10-Wheel-of-Fortune-icon.png",
                   "11-Justice-icon.png",
                   "12-Hanged-Man-icon"
                 }
function scene:create( event )
  local sceneGroup = self.view
  boardGroup = display.newGroup()
  uiGroup = display.newGroup()
  cardGroup = display.newGroup()

  sceneGroup:insert( boardGroup )
  sceneGroup:insert( uiGroup )
  sceneGroup:insert( cardGroup )
  local board = display.newImageRect( boardGroup, "Assets/Images/background.jpg", 1024, 768 )
  board.x, board.y = display.contentCenterX, display.contentCenterY

  local text = display.newText( uiGroup, txt, 100, 600, nil, 40 )
  local saveIndex
  local function showCard( i )
    if cards == nil then cards = {} end
    local nextCard = #cards + 1
    cards[nextCard] = display.newImageRect( cardGroup, "Assets/Images/112.jpg", 100, 200 )
    cards[nextCard].x, cards[nextCard].y = x * i, y
    cards[nextCard].id = i
    --cards[nextCard]:applyTorque( 100 )
    transition.from( cards[nextCard], { tag = "card", xScale = 0.001, yScale = 0.001, x = 0, y = 768, alpha = 0, time = 444*i } )
    local index = math.random( #listCard )
    
    local nextShow = #cardShows + 1


    cardShows[nextShow] = display.newImageRect( cardGroup, "Assets/Images/"..listCard[index], 100, 200 )
    cardShows[nextShow].x, cardShows[nextShow].y = x * i, y
    cardShows[nextShow].index = index
    cardShows[nextShow].id = i
    cardShows[nextShow]:toBack()
    saveIndex = index
    transition.from( cardShows[nextShow], { tag = "card", xScale = 0.001, yScale = 0.001, x = 0, y = 768, alpha = 0, time = 444*i } )
    local function onTouch( event )
      local target = event.target
      if event.phase == "ended" or event.phase == "cancelled" then
        transition.to( target, { tag = "card", alpha = 0, time = 444, onComplete = function ()
          display.remove( target )
        end } )

        for i = #cards, 1, -1 do
          if target.id == cards[i].id then
            table.remove( cards, i )
          end

        end
      end
    end
    cards[nextCard]:addEventListener( "touch", onTouch )
  end

  local function onTouch( event )

    if event.phase == "began" then

      for i = 1, 3 do
        if not isCard then
          showCard( i )
        end
      end

      if isCard == true then

        for i = #cards, 1, -1 do
            display.remove( cards[i] )
            table.remove( cards, i )
        end

        for i = #cardShows, 1, -1 do
            display.remove( cardShows[i] )
            table.remove( cardShows, i )
        end
        isCard = false
        text.text = "Trải bài"
      else
        isCard = true
        text.text = "Trải lại"
      end


    elseif event.phase == "ended" or event.phase == "cancelled" then

    end
  end
  text:addEventListener( "touch", onTouch )
end

function scene:show( event )

end

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )

return scene
