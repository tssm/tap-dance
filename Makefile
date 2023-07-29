FNL = $(shell find . -type f -iname '*.fnl')

LUA = $(FNL:.fnl=.lua)

all: $(LUA)

$(LUA): %.lua: %.fnl
	fennel \
		--add-package-path ${VIMRUNTIME}/lua \
		--compile $^ \
		> $@
