# Data Folder 

## Structure
Prefixes of folders and their meaning:
"final_" - final version data, that we used for our documentation, ship length ca 290 meters
"ship_deck_" - final version deck data, that we used for the simulations of the data given in the "final_" folder.

"first_" - version with too big ship (900 meters instead of feets used :)
"second_" - version with a lot of colisions, no wall fixes.



## How to make a new configuration?

(1) put floor plans in the data folder
(2) See config_file_structure and change as wished
(3) go to code folder and simulate as mentioned there

## How to create a floor plan?
(this text is copied from the multi-level-group)

image format should be png, but can also be something else
image must have 3 channels (RGB) and 8 bits/channel, all images must have the
same dimensions

building image:
 how the building looks like and where the agents are
 - background 						(ignored)	white   #ffffff
 - walls 						black   	#000000
 - agent spawning areas					pink    	#ff00ff 
 - exits						green   	#00ff00
 - stairs down						blue    	#0000ff
 - stairs up						red		#ff0000

 stairs: for each down stairs spot (connected color) there must be an up stairs
 at the same spot on the floor below. this allows multiple stairs per floor.

Rescue boat (Exits) 13 per side green:
descending from right front to right back and then left front to left back.
#00ff00,#00fe00,#00fd00,.... #00e700,#00e600