cart.p8: main.lua engine.lua rasterizer.lua math.lua mesh.lua quicksort.lua
	p8tool build cart.p8 --lua main.lua

clean:
	rm -f cart.p8
