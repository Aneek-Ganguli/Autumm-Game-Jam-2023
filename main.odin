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

main :: proc() {
	fmt.println("sups")
	if SDL.Init(SDL.INIT_VIDEO)> 0{
		fmt.println("HEY .. SDL_Init HAS FAILED. SDL_ERROR: ",SDL.GetError())
	}

	assert(SDL_Image.Init(SDL_Image.INIT_PNG) != nil, SDL.GetErrorString())
	window:= renderWindow("S",0,0)
	text:= SDL_Image.LoadTexture(window.renderer,"j.png")

	event:SDL.Event
	gameRunning:bool = true

	for gameRunning{
		for SDL.PollEvent(&event){
			if(event.type==SDL.EventType.QUIT){
				gameRunning=false;
			}
		}

		SDL.RenderClear(window.renderer)
		
		SDL.RenderCopy(window.renderer, text, nil,nil)

		SDL.RenderPresent(window.renderer)

	}

	
	SDL.Quit()

}
