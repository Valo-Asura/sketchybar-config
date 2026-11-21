bin/cpu_load: cpu_load.c cpu.h ../sketchybar.h | bin
	clang -std=c99 -O3 -framework IOKit $< -o $@

bin:
	mkdir bin
