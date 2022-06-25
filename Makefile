CURDIR = $(shell pwd)

install:
	ln -s $(CURDIR) ~/.config/nvim

bundles:
	nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerInstall'

packages:

download: bundles
