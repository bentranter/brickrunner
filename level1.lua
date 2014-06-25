-----------------------------------------------------------------------------------------
--
-- level1.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

-- include Corona's "physics" library
local physics = require "physics"
physics.start();   -- initialize the phsyics engine
physics.setGravity(0, 0)   -- no gravity, since it behaves like a space shooter
physics.setPositionIterations( 16 )   -- anything higher may affect game performance

--------------------------------------------

-- seed random number generator
math.randomseed( os.time() )

--------------------------------------------

-- forward declarations and other locals
local screenW, screenH, halfW = display.contentWidth, display.contentHeight, display.contentWidth*0.5
local gameover_returntomenu -- the game over button

-- Game Settings
motionx = 0; -- used to move character along x axis
speed = 10; -- controls the ship speed
playerScore = 0; -- initialize the player's score to zero
playerLives = 1; -- initialize the player's score to 1, since lives can only be increased with power-ups
enemySpeed = 1875; -- sets how fast the enemies move along the screen
enemySpawn = 1800; -- sets how fast the enemies spawn

function scene:create( event )

	-- Called when the scene's view does not exist.
	-- 
	-- INSERT code here to initialize the scene
	-- e.g. add display objects to 'sceneGroup', add touch listeners, etc.

	local sceneGroup = self.view

	-- create the background (same background as menu scene)
	local background = display.newImageRect( "background.jpg", screenW, screenH )
	background.anchorX = 0
	background.anchorY = 0
	
	--[[ make a crate (off-screen), position it, and rotate slightly
	local crate = display.newImageRect( "crate.png", 90, 90 )
	crate.x, crate.y = 160, -100
	crate.rotation = 15 
	
	-- add physics to the crate
	physics.addBody( crate, { density=1.0, friction=0.3, bounce=0.3 } )
    ]]--
	
	-- create the player and put them in the middle of the screen
	local player = display.newImageRect( "sprites/circle2.png", 44, 44 )
	player.anchorX = 0
	player.anchorY = 1
	player.x, player.y = 0, display.contentHeight
	
	-- define a shape that's slightly shorter than image bounds (set draw mode to "hybrid" or "debug" to see)
	local playerShape = { -halfW,-100, halfW,-100, halfW,100, -halfW,100 }
	physics.addBody( player, "static", { friction=0.3, shape=playerShape } )
    
    -- create left wall
    local leftWall = display.newRect(0, 0, 5, screenH)
    leftWall.x = 0
    leftWall:setFillColor( 0, 0, 0 )
    leftWall.alpha = 0.01
    physics.addBody( leftWall, "static" )
    
    -- create right wall
	local rightWall = display.newRect(0, 0, 5, screenH)
    rightWall.x = 480
    rightWall:setFillColor( 0, 0, 0 )
    rightWall.alpha = 0.01
    physics.addBody( rightWall, "static" )
    
    -------------------------------------------
    -- GUI Elements
    -------------------------------------------
    local gui_score = display.newText( "Score: "..playerScore, 0, 0, "ComicNeue-Angular-Light", 16 )
    -- here: figure out anchor points
    
    
    
	-- all display objects must be inserted into group
	sceneGroup:insert( background )
    sceneGroup:insert( leftWall )
    sceneGroup:insert( rightWall )
	sceneGroup:insert( player )
    sceneGroup:insert( gui_score )
	-- sceneGroup:insert( crate )
end


function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen
	elseif phase == "did" then
		-- Called when the scene is now on screen
		-- 
		-- INSERT code here to make the scene come alive
		-- e.g. start timers, begin animation, play audio, etc.
		physics.start()
	end
end

function scene:hide( event )
	local sceneGroup = self.view
	
	local phase = event.phase
	
	if event.phase == "will" then
		-- Called when the scene is on screen and is about to move off screen
		--
		-- INSERT code here to pause the scene
		-- e.g. stop timers, stop animation, unload sounds, etc.)
		physics.stop()
	elseif phase == "did" then
		-- Called when the scene is now off screen
	end	
	
end

function scene:destroy( event )

	-- Called prior to the removal of scene's "view" (sceneGroup)
	-- 
	-- INSERT code here to cleanup the scene
	-- e.g. remove display objects, remove touch listeners, save state, etc.
	local sceneGroup = self.view
	
	package.loaded[physics] = nil
	physics = nil
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene