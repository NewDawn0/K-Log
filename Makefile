# Vars
CC=clang
CFLAGS=-framework Foundation -framework Carbon -O2 -g -Wall
OBJS:=src/main.m
OUT:=logged

# Colours
GREEN=\x1b[32;1m
RESET=\x1b[0m

build:
	@printf "$(GREEN)Building...$(RESET)\n"
	mkdir -p bin
	pwd
	$(CC) $(CFLAGS) $(OBJS) -o bin/$(OUT)
