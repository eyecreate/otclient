--[[
Here is my module to add functionality to the client. I set it to load on startup to avoid implementing a way to load the module using the rest of the UI. I found it interesting that, even though the widget code has layout and alignments, that coordinates are for the whole screen and not relative to the parent. I start here with some globals that are needed throughout the module. I codified some values up here to make it easy to change them later about how the button moves.
]]
scrollingBtnWindows = nil
windowMoveEvent = nil
movementSpeed = 50
movementAmount = 5

-- I decided to implement the scrolling behavior using the event framework. After looking through the code, I saw there was an event type that endlessly looped. This allowed me to form a loop for moving the button that worked consistently.
function init()
	scrollingBtnWindow = g_ui.displayUI('scrolling_button')
	windowMoveEvent = cycleEvent(scrollMe, movementSpeed)
end

-- Not that important for the demo, but I made sure to clean up the endless loop if the window is closed.(only implemented that with escape)
function terminate()
	removeEvent(windowMoveEvent)
	scrollingBtnWindow:destroy()
end

-- I organized the code to restart the button on the right side so that it could trigger by button press or reaching the end. Some math to make sure the button is still in the window panel and to randomly move it up or down.
function jumpMe()
  scrollBtn = scrollingBtnWindow:recursiveGetChildById('movingBtn')
  panel = scrollingBtnWindow:recursiveGetChildById('generalPanel')
  scrollBtn:setX(panel:getX()+panel:getWidth()-scrollBtn:getWidth())
  scrollBtn:setY(math.random(panel:getY(),panel:getY()+panel:getHeight()-scrollBtn:getHeight()))
end

-- This is the main event. ;) I check to make sure the button has space left to move left. If not, I have it jump to another position. 
function scrollMe()
  scrollBtn = scrollingBtnWindow:recursiveGetChildById('movingBtn')
  panel = scrollingBtnWindow:recursiveGetChildById('generalPanel')
  if scrollBtn:getX()-panel:getX() >= movementAmount then
    scrollBtn:setX(scrollBtn:getX() - movementAmount)
  else
    jumpMe()
  end
end


