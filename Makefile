cart.p8: main.p8 sprites.p8
	p8tool build cart.p8 --lua main.p8 --gfx sprites.p8

clean:
	rm -f cart.p8
