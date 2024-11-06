build:
	v fmt -w convft.v
	v -prod -o convft .
	sudo ./convft install

rebuild:
	sudo convft uninstall
	v fmt -w convft.v
	v -prod -o convft .
	sudo ./convft install
	
delete:
	sudo convft uninstall



