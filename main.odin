package main

import "core:fmt"
import SDL "vendor:sdl2"
import SDL_Image "vendor:sdl2/image"
import SDL_ttf "vendor:sdl2/ttf"



RenderWindow :: struct{
	window:^SDL.Window,
	renderer:^SDL.Renderer,
}

renderWindow :: proc(p_title:cstring , p_w:i32, p_h:i32)->RenderWindow{
	window:RenderWindow

	window.window = SDL.CreateWindow(p_title,SDL.WINDOWPOS_CENTERED,SDL.WINDOWPOS_CENTERED,p_w,p_h,SDL.WINDOW_FULLSCREEN_DESKTOP)


	window.renderer = SDL.CreateRenderer(window.window, -1, SDL.RENDERER_ACCELERATED)
	return window
}

Entity::struct{
	texture:^SDL.Texture,
	source : ^SDL.Rect,
	destionation : ^SDL.Rect,
	//source : SDL.Rect,
}

playerUpdate :: proc(player:^Entity,event:^SDL.Event){
	if SDL.EventType.KEYDOWN == event.type{
		if(event.key.keysym.scancode == SDL.SCANCODE_D){
			player.destionation.x += 10
		}
		
		if(event.key.keysym.scancode == SDL.SCANCODE_A){
			player.destionation.x -= 10
		}

		if(event.key.keysym.scancode == SDL.SCANCODE_W){

			player.destionation.y -= 10 
		}

		if(event.key.keysym.scancode == SDL.SCANCODE_S){
			player.destionation.y += 10
		}	
	}
}

main :: proc() {
	fmt.println("sups")
	if SDL.Init(SDL.INIT_VIDEO)> 0{
		fmt.println("HEY .. SDL_Init HAS FAILED. SDL_ERROR: ",SDL.GetError())
	}

	assert(SDL_Image.Init(SDL_Image.INIT_PNG) != nil, SDL.GetErrorString())
	window:= renderWindow("S",0,0)
	text:= SDL_Image.LoadTexture(window.renderer,"j.png")
	textRect:= SDL.Rect{10,10,10,10}	
	event:SDL.Event
	gameRunning:bool = true

	

	nope : Entity = {text,&SDL.Rect{0,0,32,32},&SDL.Rect{32*3,32*3,32*3,32*3}}
	fmt.println(nope.destionation)

	for gameRunning{
		for SDL.PollEvent(&event){
			if(event.type==SDL.EventType.QUIT){
				gameRunning=false;
			}

			playerUpdate(&nope,&event)
		}
	
		SDL.RenderClear(window.renderer)

	//	playerUpdate(&nope,&event)
		
		SDL.RenderCopy(window.renderer, nope.texture,nope.source, nope.destionation)//nope.source,nope.destionation)
		//SDL.RenderCopy(window.renderer,text,nil,nil)

		SDL.RenderPresent(window.renderer)

	}

	
	SDL.Quit()

}
