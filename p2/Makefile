all: up copy-k3s-config

up:
	vagrant up

down:
	vagrant halt

clean:
	vagrant destroy -f

re: clean all

ssh-s:
	vagrant ssh wxueruiS

copy-k3s-config:
	@mkdir -p ~/.kube
	vagrant ssh wxueruiS -c "sudo cat /etc/rancher/k3s/k3s.yaml" > ~/.kube/config	
	sed -i 's/0.0.0.0/192.168.56.110/g' ~/.kube/config

