package main

import "core:fmt"
import "core:strings"
import SDL "vendor:sdl3"
import TTF "vendor:sdl3/ttf"

WINDOW_FLAGS :: SDL.WINDOW_ALWAYS_ON_TOP

main :: proc() {
	sdl_init_success := SDL.Init(SDL.INIT_VIDEO)
	if !sdl_init_success {
		fmt.printfln("Failed to init sdl3: %v", strings.clone_from_cstring(SDL.GetError()))
	}
	defer SDL.Quit()

	ttf_init_success := TTF.Init()
	if !ttf_init_success {
		fmt.printfln("Failed to init ttf: %v", strings.clone_from_cstring(SDL.GetError()))
	}
	defer TTF.Quit()

	window := SDL.CreateWindow("SDL3 test", 500, 500, WINDOW_FLAGS)
	assert(window != nil, strings.clone_from_cstring(SDL.GetError()))
	defer SDL.DestroyWindow(window)

	renderer := SDL.CreateRenderer(window, nil)
	assert(renderer != nil, strings.clone_from_cstring(SDL.GetError()))
	defer SDL.DestroyRenderer(renderer)

	ttf_font := TTF.OpenFont("assets/arialMT.ttf", 25)
	assert(ttf_font != nil, strings.clone_from_cstring(SDL.GetError()))


	event: SDL.Event

	game_loop: for {
		if SDL.PollEvent(&event) {
			if event.type == SDL.EventType.QUIT {
				break game_loop
			}

			if event.type == SDL.EventType.KEY_DOWN {
				#partial switch event.key.scancode {
				case .ESCAPE:
					break game_loop
				}
			}
		}

		color := SDL.Color{255, 255, 255, 255}
		surface := TTF.RenderText_Solid(
			ttf_font,
			"SDL3 test, press Esc to close window",
			40,
			color,
		)
		defer SDL.DestroySurface(surface)

		texture := SDL.CreateTextureFromSurface(renderer, surface)
		defer SDL.DestroyTexture(texture)


		dest_rect := SDL.FRect{10, 10, 0, 0}
		SDL.GetTextureSize(texture, &dest_rect.w, &dest_rect.h)

		SDL.RenderTexture(renderer, texture, nil, &dest_rect)

		SDL.RenderPresent(renderer)
		SDL.SetRenderDrawColor(renderer, 0, 0, 0, 100)
		SDL.RenderClear(renderer)
	}

}
