cart.p8: main.lua polygon.lua
	p8tool build cart.p8 --lua main.lua

clean:
	rm -f cart.p8
