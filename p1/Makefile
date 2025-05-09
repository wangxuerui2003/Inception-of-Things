up:
	vagrant up

down:
	vagrant halt

clean:
	vagrant destroy -f

re: clean up

ssh-s:
	vagrant ssh wxueruiS

ssh-sw:
	vagrant ssh wxueruiSW

copy-k3s-config:
	@mkdir -p ~/.kube
	vagrant ssh wxueruiS -c "sudo cat /etc/rancher/k3s/k3s.yaml" > ~/.kube/config	
