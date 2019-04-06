cart.p8: main.lua renderer.lua math.lua model.lua
	p8tool build cart.p8 --lua main.lua

clean:
	rm -f cart.p8
