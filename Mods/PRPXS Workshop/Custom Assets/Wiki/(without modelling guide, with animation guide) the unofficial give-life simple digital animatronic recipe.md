---
tags:
  - guide
  - small
  - 🐊
---

###### we'll be using [Blender](https://www.blender.org/download/) for this guide as its free and best supported,
(you can also use [BforArtists](https://www.bforartists.de) which is a clone that makes Blender easier)
###### your free to use whatever modeling tools you already have,
###### as long as it supports .glb or .fbx exporting.
###### you might have to look up what keys/scenarios are similar for your case though

make sure you have standard latest godot installed, perferably no c++

lastly, its recommended to use github desktop to clone the games files, so you can just hit "pull origin" whenever there's an update

> this tutorial removes the modelling part of the guide, for those who already have a pre-made and ready-to-go model. the animation section is kept.

---
navbox:
- [[#0. hotkeys guide (scroll down)]]]]
- [[#1. animations]]
- [[#2. exporting]]
- [[#3. materials]]
- [[#4. animatables]]
- [[#5. grouping]]
- [[#6. halfway!]]
- [[#7. proper animation support]]
- [[#8. writing the animations]]
- [[#9. other stuff]]
---

## (blender) keys youll generally get to know / general mahogany

### general:
f3 - search button
		use for applying transforms & other stuff mentioned in guide
		you might need to remap this through the preferences if your on mac

### mesh:
cmd(/ctrl)A - opens the apply menu
cmd(/ctrl)X - applies weight based on weight slider; ex. setting a jaw to red

Tip - the highlighted dot on an object is where it thinks its center is.
"applying a transformation" means it moves that center based on its size, but usually makes its center to the ground.

---

## **1. animations**

make sure you have your character posing in a comfy/natural & ready-to-animate pose. think of the pose you'd imagine it standing with on-stage. you might have to click on the armature and make sure your on resting position first:![[Screenshot 2026-05-25 at 12.45.23 PM.png]]
- you can animate it however you want, but frame 0 must be no movement, and frame 60 must be the fully finished movement. no further frames should be added, unless if its a looping kind of animation. 60 frame limit fits within 60fps and makes adjusting it's playback speed easier.

- go pose mode
	&/or "Animation" tab

- insert keyframes (I → rotation/location)
					youll only have to register the bone you want to move for each animation, you don't have to keyframe every other bone (unless your making more animated and cartoonish characters).

###### it is currently unknown if shape keys or drivers work at this time.
    

---

## 2. exporting

this is the big moment youve been waiting for.

- select your chara
- export as FBX or GTL
	- FBX: large, but easy to carry over (to different versions, different games, etc).
	- GLB: small, but hard to import back into blender (mainly for textures).

8. importing
to godot, that is.
 - drag it to your /CustomAssets/ folder if you havent already
 
 - then double click on your model file in godot to double-check your mesh
		 if it and its materials appear white and textureless, that is completely normal. the default models are like this too, this is just how it exports.

### 3. materials
 
 - click Actions uptop the preview menu, then Export Materials.
	 - export to `/CustomAssets/Materials/` (or anywhere you can remember really).
	 - make sure you have your textures exported/carried over as well (`CustomAssets\Textures\Animatronics`).

make sure to double click the exported file to edit it, it'll pop up on the side. heres how it should be set up by default:
![[Screenshot 2026-04-30 at 7.18.44 PM.png]]


- normal map = normal map, albedo = texture, specular = metallic, & roughness = roughness! :D

this is how it should look for colorables/glowables:
![[Screenshot 2026-04-30 at 6.06.18 PM.png|697]]
- texture is now gray, its colors are now variables
- use gl_paintable for the 'shaders' slot
## 4. animatables

- these go in `Custom Directory/Animatables`. they are tscn files (which are Scenes in Godot) containing the model and its info.
- just copy paste one from either true-fnaf or faz2, as they have an easier info card to configure with.
- faz2 has coloring support, but may be a bit tricky to configure/implement properly at the time of writing.

- go into the animatable and delete the node with a clipboard and eye next to it, for that is the model.

- then drag your model into the top node/circle.

- go into the top with a single click, and edit it's profile however you want.
	- an icon might necessarily not be needed, it will default to question marks
		- if you want to make one, you can make it any style you want. it could even be just a screenshot of the model, or a little doodle.

## 5. grouping

- above the animatronic profile, it says you are currently on the Inspector tab. switch to the Groups tab shown next to it.
-# (make sure your on the top node)

- create a new Scene Group associated with your character, by clicking the plus sign, next to the searchbar.
	- Reccomended formating: `GROUP_CHARACTER`.

- set color check to your new group aswell.

## 6. halfway!
###### NOTE TO WRITER: THIS IS THE CONFUSING PART
- you can now test it's visibility by dragging it into a map! if you want to!
-# (why did it glitch/error the first time??? they dont do the best with clarifying what 2 do in the og guide.)
	- note its animations might not work yet.
	- be careful with dropping it in any map without copying the map files first
	- even with copying it'll depend on it & cleaning it back up is a bit exhausting
	- map goes in `Mod Directory\Maps`, then its own folder.
		- you can copy-paste any map (reccomended to copy a simple map, like a map from true-fnaf) for easier making. you dont have to make a full-ledged map just yet.
-# (maybe this shouldn't be suggested yet. have my hopes up for the newer release though)
- I really recommend taking a break and resting at this part, youve done a lot of work up to this point

## 7. proper animation support
- copy-paste a json (or make a new one) from `Mod Directory\Anim Parameters`
-# true-fnaf is reccomended for easier editing, since they usually have few animations listed, like 'ToyFan'

- rename it with the same name the .tscn file has

- Back in the .tscn's top node, in the Inspector change the 'parameter file' to the same name
## 8. writing the animations

here is an example of what we'll be working with:
```
{
  \"AA_CCA|Jaw\": { --name
	\"animation\": \"CCa|Jaw\", --animation_name
	\"in_speed\": 2.5,
	\"out_speed\": 1.5,
	\"type\": \"standard\" -- type of movement
  },
  \"AA_CCA|Underlid L\": {
	\"animation\": \"CCa|Underlid L\",
	\"in_speed\": 5.0,
	\"out_speed\": 10.0,
	\"type\": \"move_to\",
	\"value\": 5.70421e-21
  },
}
```
*(added tildas are for reference and are not included in the json)
	(versions with Source Archival in it do not need to add the group names to the name)


this is how we tell the game how the animations work, and links them to the animatronic

- `--name` - the visual name, what people will see using the editor. you can use the scene_group name for this one
- `--animation_name` - the name it listens for to find the animation to play.
- `in/out_speed` - speed that it uses going in and out. 1 is slow 10 is fast
- `--type` - type of movement it uses
	- `standard` - basic movement, tapping and holding it's key fully plays it, and untapping reverses it. good for most movements including jaws
	- `move-to` - like an on and off switch. you wont have to hold the key, but this movement method is a bit tricky for veterans of the old engine.
		- `value` - asserts default position, really only used for 'move-to' animations.
	- `loop` - like an on-off switch, but loops the animation instead of freezing it. good for unique movements, like spinning movements or idling movement

- you can add just one for testing, then add the rest later when it seems functional enough


And thats it! You did it :D 🎉🎉🎉


## 9. other stuff

you might need to make a map for your character to actually work & test properly. right now dragging the model anywhere'll error, since they arent in the same folders nor are the indexes for the map.
luckily, making a map is actually kinda easier than most of the process so far.

- create a new scene
- categorize with white circles/basic nodes (Map, Animatables, Map Mesh & Collision)
-# categorization might be optional but considering this is how most of the official maps act its best to be safe
- add a world environment, occluderinstance3d, staticbody3d & collisionshape3d in map.
	- create a new world environemtn through the inspector
	- rename the staticbody3d to 'World Boundary'
	- put the collisionshape3d in the world boundary
		- in the inspector, make its shape a WorldBoundaryShape
- in the occluder, create an array occluder
- drag stage model into occluder, then click bake on the top, export
- drag it back out and into the MM&M
- drag the animatronic into ANimatables
- search 'player' in the file manager below the nodes, and drag the player.tscn into the tippy-top node
- your pretty much done now :D now you just need a Map Icon.png, and you can copy over a Map Info.cfg and edit it to fit your stage

- MAKE SURE THE INTERNAL ANIMATION NAMES DO *NOT* USE THE | SYMBOL. it gets confused if that happens. - and _ are probably ok, otherwise generally refrain from any other symbols anyway.

### 
---


#### companion checklist
use for easier track of your project

- [x] animations
- [x] export
- [x] moved to faz-anim/mod folder
	- [x] material export
- [ ] animatables
	- [ ] ~ rr-engine/cross-version support jsontable
	- [ ] ~ icon
	- [ ] grouped
- [ ] ~ testing
- [ ] finished up testing

~ - optionally