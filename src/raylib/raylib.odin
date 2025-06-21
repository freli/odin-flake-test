package main

import rl "vendor:raylib"
import rlgl "vendor:raylib/rlgl"

main :: proc() {
	rl.InitWindow(500, 500, "raylib test")
	rl.InitAudioDevice()

	for !rl.WindowShouldClose() {
		rl.BeginDrawing()
		rl.ClearBackground({32, 32, 32, 255})

		rl.DrawText("raylib test", 20, 20, 25, rl.RAYWHITE)
		rl.DrawText("Press escape to close the window", 20, 50, 20, rl.DARKGREEN)

		rl.EndDrawing()
	}
}
