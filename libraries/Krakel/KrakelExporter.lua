

groups = DAME.GetGroups()
groupCount = as3.tolua(groups.length) - 1

DAME.SetFloatPrecision(2)

tab1 = "\t"
tab2 = "\t\t"
tab3 = "\t\t\t"
tab4 = "\t\t\t\t"
tab5 = "\t\t\t\t\t"

-- slow to call as3.tolua many times so do as much as can in one go and store to a lua variable instead.
exportOnlyCSV = as3.tolua(VALUE_ExportOnlyCSV)
projectName = as3.tolua(DAME.GetProjectName())
dataDir = as3.tolua(VALUE_DataDir)
projectDataDir = dataDir.."/"--..projectName

fileText = "";

spriteLayers = {}
shapeLayers = {}
pathLayers = {}
layers = {}

local groupPropTypes = as3.toobject({ String="String", Int="int", Float="Number", Boolean="Boolean" })
DAME.SetCurrentPropTypes( groupPropTypes )

layerPropsString = "%%ifproplength%%%%proploop%% %propname%=\"%propvalue%\"%%proploopend%%%%endifproplength%%"

groupPropsText = "%%ifproplength%%%%proploop%%%propname%=\"%propvalue%\" %%proploopend%%%%endifproplength%%"

linkAssignText = "%%if link%%"
	linkAssignText = linkAssignText.."linkId=\"%linkid%\" "
linkAssignText = linkAssignText.."%%endiflink%%"

------------------------
-- TILEMAP GENERATION
------------------------
function exportMapCSV( mapLayer, layerFileName )
	-- get the raw mapdata. To change format, modify the strings passed in (rowPrefix,rowSuffix,columnPrefix,columnSeparator,columnSuffix)
	mapText = as3.tolua(DAME.ConvertMapToText(mapLayer,"","\n","",",",""))
	DAME.WriteFile(projectDataDir.."/levels/maps/"..layerFileName, mapText );
end

------------------------
-- PATH GENERATION
------------------------

-- This will store the path along with a name so when we call a get it will output the value between the first : and the last %
-- Here it will be paths[i]. When we later call %getparent% on any attached avatar it will output paths[i].
pathIdText = "%store:%counter:paths%%"
pathIdText = pathIdText.."%counter++:paths%" -- This line will actually incremement the counter.

lineNodeText = tab4.."<node x=\"%nodex%\" y=\"%nodey%\" />\n"
splineNodeText = tab4.."<node x=\"%nodex%\" y=\"%nodey%\" tan1x=\"%tan1x%\" tan1y=\"%tan1y%\" tan2x=\"%tan2x%\" tan2y=\"%tan2y%\" />\n"

pathPropsText = "%%ifproplength%%".."%%proploop%% %propname%\=\"%propvalue%\"%%proploopend%%%%endifproplength%%"

pathText = tab3.."<nodes>\n%nodelist%"..tab3.."</nodes>\n"..tab2.."</path>\n"
linesText = pathIdText..tab2.."<path spline=\"false\" closed =\"%isclosed%\""..linkAssignText..pathPropsText.." >\n"..pathText
curvesText = pathIdText..tab2.."<path spline=\"true\" closed=\"%isclosed%\""..linkAssignText..pathPropsText.." >\n"..pathText

function generatePaths( )
	for i,v in ipairs(pathLayers) do
		layer = pathLayers[i][2]
		
		layerText = as3.tolua(DAME.CreateTextForPaths(layer, linesText, lineNodeText, curvesText, splineNodeText, ""))

		layerIndex = pathLayers[i][4]
		layers[layerIndex][4] = layerText
	end
end

-------------------------------------
-- SHAPE and TEXTBOX GENERATION
-------------------------------------
shapePropsText = "%%ifproplength%%>\n"..tab3.."<properties>\n"
	shapePropsText = shapePropsText.."%%proploop%%"..tab4.."<prop name=\"%propname%\" value=\"%propvalue%\" />\n%%proploopend%%"
shapePropsText = shapePropsText..tab3.."</properties>\n"..tab2.."</shape>%%endifproplength%%%%ifnoproplength%%/>%%endifproplength%%\n"

textboxText = tab2.."<shape type=\"text\""
				.." x=\"%xpos%\" y=\"%ypos%\""
				.." angle=\"%degrees%\""
				.." width=\"%width%\" height=\"%height%\""
				.." text=\"%text%\""
				.." font=\"%font%\""
				.." size=\"%size%\""
				.." color=\"0x%color%\""
				.."align=\"%align%\" "
				..linkAssignText..shapePropsText

boxText = tab2.."<shape type=\"box\""
			.." x=\"%xpos%\" y=\"%ypos%\""
			--.." angle=\"%degrees%\""
			.." width=\"%width%\" height=\"%height%\" "
			..linkAssignText..shapePropsText
circleText = tab2.."<shape type=\"circle\" x=\"%xpos%\" y=\"%ypos%\" radius=\"%radius%\" "..linkAssignText..shapePropsText

function generateShapes( )
	for i,v in ipairs(shapeLayers) do	
		layer = shapeLayers[i][2]
		
		layerText = as3.tolua(DAME.CreateTextForShapes(layer, circleText, boxText, textboxText ))
		layerIndex = shapeLayers[i][4]
		layers[layerIndex][4] = layerText
	end
end

-------------------------------------
-- SPRITE GENERATION - must be called after paths.
-------------------------------------

spritePropsText =	"%%ifproplength%%"..
					"%%proploop%%%propname%\=\"%propvalue%\" %%proploopend%%"..
					"%%endifproplength%%"

spriteAnimText =	"%%spriteanimloop%%"..
						tab3.."<animation name=\"%animname%\" fps=\"%fps%\" looped=\"%looped%\">"..
						"%%animframeloop%%"..
							tab4.."%tileid%%separator:,%\n"..
						"%%animframeloopend%%"..tab3.."</animation>\n"..
					"%%spriteanimloopend%%"
-- spriteShapeString = "%%spriteframeloop%%"..tab3.."spriteData.shapeList[%frame%] = ( [%%shapeloop%%new AnimFrameShapeData(\"%shapename%\", AnimFrameShapeData.SHAPE_%TYPE%, %xpos%, %ypos%, %radius%, %wid%, %ht%)%separator:,\n"..tab5..tab5.."%%%shapeloopend%% ]);\n%%spriteframeloopend%%"
	
spriteText = tab2.."<sprite type=\"%class%\" "..
			-- "name=%name% "..
			"x=\"%xpos%\" "..
			"y=\"%ypos%\" "..
			-- "angle=\"%degrees%\" "..
			"flip=\"%flipped%\" "..
			-- "%%ifflipped%%flip=\"%flipped%\" %%endifflipped%%"..
			-- "%%if flipped%%flip=\"%flipped%\" %%endif flipped%%"..
			-- "%%if%flipped%%%flip=\"%flipped%\" %%endifflipped%%"..
			"xScale=\"%scalex%\" "..
			"yScale=\"%scaley%\" "..
			"%%if parent%%"..
				" pathId=\"%getparent%\" ".."startNode=\"%attachedsegment%\" pathT=\"%attachedsegment_t%\" "..
			"%%endifparent%%"..
			linkAssignText..spritePropsText..">\n"..
			spriteAnimText..
			tab2.."</sprite>"

function generateSprites( )
	for i,v in ipairs(spriteLayers) do
		layer = spriteLayers[i][2]
		
		layerText = as3.tolua(DAME.CreateTextForSprites(layer,spriteText,"KrkSprite"))
		layerIndex = spriteLayers[i][4]
		layers[layerIndex][4] = layerText
	end
end


------------------------
-- GROUP CLASSES
------------------------
for groupIndex = 0,groupCount do

	maps = {}
	spriteLayers = {}
	shapeLayers = {}
	pathLayers = {}
	layers = {}
	
	group = groups[groupIndex]
	groupName = as3.tolua(group.name)
	groupName = string.gsub(groupName, " ", "_")
	
	DAME.ResetCounters()
	
	
	layerCount = as3.tolua(group.children.length) - 1
	
	minx = 9999999
	miny = 9999999
	maxx = -9999999
	maxy = -9999999
	
	-- Go through each layer and store some tables for the different layer types.
	for layerIndex = 0,layerCount do
		layer = group.children[layerIndex]
		isMap = as3.tolua(layer.map)~=nil
		layerName = as3.tolua(layer.name)
		layerName = string.gsub(layerName, " ", "_")
		layerText = ""
		
		if isMap == true then
			mapFileName = groupName..".csv"
			-- Generate the map file.
			exportMapCSV( layer, mapFileName )
			
			-- This needs to be done here so it maintains the layer visibility ordering.
			if exportOnlyCSV == false then
				--table.insert(maps,{groupName,layer,layerName,layerIndex})
				x = as3.tolua(layer.map.x)
				y = as3.tolua(layer.map.y)
				xscroll = as3.tolua(layer.xScroll)
				yscroll = as3.tolua(layer.yScroll)
				width = as3.tolua(layer.map.width)
				height = as3.tolua(layer.map.height)
				hasHitsString = ""
				if as3.tolua(layer.HasHits) == true then
					hasHitsString = "true"
				else
					hasHitsString = "false"
				end
				
				
				mapFileName = "levels/maps".."/"..groupName..".csv"
				
				
				layerText = layerText..tab2..
							"<map "
							.."csv=\""..mapFileName.."\" "
							.."tiles=\""..as3.tolua(DAME.GetRelativePath(dataDir, layer.imageFile)).."\" "
							.."x=\""..string.format("%.3f",x).."\" "
							.."y=\""..string.format("%.3f",y).."\" "
							.."tileWidth=\""..as3.tolua(layer.map.tileWidth).."\" "
							.."tileHeight=\""..as3.tolua(layer.map.tileHeight).."\" "
							.."collide=\""..hasHitsString.."\" "
							.."collIdx=\""..as3.tolua(layer.map.drawIndex).."\" "
							.."drawIdx=\""..as3.tolua(layer.map.collideIndex).."\" "
				
				tilePropsText = "%%ifproplength%%"..tab4.."<tile id=\"%tileid%\" "..
								"%%proploop%%%propname%=\"%propvalue%\" %%proploopend%%"..
								"/>\n%%endifproplength%%"
				
				tileData = as3.tolua(DAME.CreateTileDataText( layer, tilePropsText, "", ""))
				if # tileData > 0 then
					layerText = layerText..">\n"..tab3.."<properties>\n"..tileData..tab3.."</properties>\n"..tab2.."</map>\n"
				else
					layerText = layerText.."/>\n"
				end

				-- Only set the bounds based on maps whose scroll factor is the same as the player's.
				if xscroll == 1 and yscroll == 1 then
					if x < minx then minx = x end
					if y < miny then miny = y end
					if x + width > maxx then maxx = x + width end
					if y + height > maxy then maxy = y + height end
				end
			end

		elseif exportOnlyCSV == false then
			if as3.tolua(layer.IsSpriteLayer()) == true then
				table.insert( spriteLayers,{groupName,layer,layerName,layerIndex+1})
			elseif as3.tolua(layer.IsShapeLayer()) == true then
				table.insert(shapeLayers,{groupName,layer,layerName,layerIndex+1})
			elseif as3.tolua(layer.IsPathLayer()) == true then
				table.insert(pathLayers,{groupName,layer,layerName,layerIndex+1})
			end
		end
		
		-- The 4th element will be the text to export, allowing us to maintain the layer ordering!
		table.insert(layers,{groupName, layer, layerName, layerText})
	end

	-- Generate the actual text for the derived class file.
	
	if exportOnlyCSV == false then
		
		-- Create the paths first so that sprites can reference them if any are attached.
		generatePaths()
		generateShapes()
		generateSprites()
		
		-- output the actual file text for all the layers now that any object references and layer text has been parsed.

		fileText = "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
		fileText = fileText
			.."<level name=\""..groupName.."\" "
			.."bounds.x=\""..minx.."\" bounds.y=\""..miny.."\" "
			.."bounds.width=\""..maxx.."\" bounds.height=\""..maxy.."\" "
			.."bgColor = \""..as3.tolua(DAME.GetBackgroundColor()).."\" "
			..as3.tolua(DAME.GetTextForProperties( groupPropsText, group.properties ))..">\n"
		
		for i,v in ipairs(layers) do
			layer = layers[i][2]
			layerName = as3.tolua(layer.name)
			layerName = string.gsub(layerName, " ", "_")
			xscroll = as3.tolua(layer.xScroll)
			yscroll = as3.tolua(layer.yScroll)
			fileText = fileText..tab1.."<layer"
					.." name=\""..layerName.."\""
					.." xScroll=\""..string.format("%.3f",xscroll).."\""
					.." yScroll=\""..string.format("%.3f",yscroll).."\""
					..as3.tolua(DAME.GetTextForProperties( layerPropsString, layer.properties )).." >\n"
			fileText = fileText..layers[i][4]
			fileText = fileText..tab1.."</layer>\n"
		end
		
		
		
		-- Create the links between objects.
		linkPropsText = "%%ifproplength%%>\n"..tab3.."<properties>\n"
		linkPropsText = linkPropsText.."%%proploop%%"..tab4.."<prop name=\"%propname%\" value=\"%propvalue%\" />\n%%proploopend%%"
		linkPropsText = linkPropsText..tab4.."</properties>\n"..tab2.."</link>%%endifproplength%%%%ifnoproplength%%/>%%endifproplength%%\n"
		linkText = tab2.."<link from=\"%linkfromid%\" to=\"%linktoid%\""..linkPropsText
		linkText = as3.tolua(DAME.GetTextForLinks(linkText,group))
		if # linkText > 0 then
			fileText = fileText..tab1.."<links>\n"..linkText..tab1.."</links>\n"
		end
		
		-- group properties.
		-- fileText = fileText..as3.tolua(DAME.GetTextForProperties( groupPropsText, group.properties ))
		
		fileText = fileText.."</level>\n"
			
		-- Save the file!
		
		DAME.WriteFile(projectDataDir.."levels/"..groupName..".xml", fileText )
		
	end
end


return 1
