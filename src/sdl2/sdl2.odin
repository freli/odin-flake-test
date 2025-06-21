package main

import "core:fmt"
import "core:strings"
import SDL "vendor:sdl2"
import TTF "vendor:sdl2/ttf"

RENDER_FLAGS :: SDL.RENDERER_ACCELERATED
WINDOW_FLAGS :: SDL.WINDOW_SHOWN | SDL.WINDOW_ALWAYS_ON_TOP

main :: proc() {
	sdl_init_error := SDL.Init(SDL.INIT_EVERYTHING)
	assert(sdl_init_error != -1, SDL.GetErrorString())
	defer SDL.Quit()

	ttf_init_error := TTF.Init()
	assert(ttf_init_error != -1, SDL.GetErrorString())
	defer TTF.Quit()

	window := SDL.CreateWindow(
		"SDL2 test",
		SDL.WINDOWPOS_CENTERED,
		SDL.WINDOWPOS_CENTERED,
		500,
		500,
		WINDOW_FLAGS,
	)
	assert(window != nil, SDL.GetErrorString())
	defer SDL.DestroyWindow(window)

	renderer := SDL.CreateRenderer(window, -1, RENDER_FLAGS)
	assert(renderer != nil, SDL.GetErrorString())
	defer SDL.DestroyRenderer(renderer)

	ttf_font := TTF.OpenFont("assets/arialMT.ttf", 25)
	assert(ttf_font != nil, SDL.GetErrorString())


	event: SDL.Event

	game_loop: for {
		if SDL.PollEvent(&event) {
			if event.type == SDL.EventType.QUIT {
				break game_loop
			}

			if event.type == SDL.EventType.KEYDOWN {
				#partial switch event.key.keysym.scancode {
				case .ESCAPE:
					break game_loop
				}
			}
		}

		color := SDL.Color{255, 255, 255, 255}
		surface := TTF.RenderText_Solid(ttf_font, "SDL2 test, press Esc to close window", color)
		defer SDL.FreeSurface(surface)

		texture := SDL.CreateTextureFromSurface(renderer, surface)
		defer SDL.DestroyTexture(texture)

		dest_rect := SDL.Rect{10, 10, 0, 0}

		SDL.QueryTexture(texture, nil, nil, &dest_rect.w, &dest_rect.h)

		SDL.RenderCopy(renderer, texture, nil, &dest_rect)

		SDL.RenderPresent(renderer)
		SDL.SetRenderDrawColor(renderer, 0, 0, 0, 100)
		SDL.RenderClear(renderer)
	}

}
