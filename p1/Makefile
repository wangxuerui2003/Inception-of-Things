up:
	vagrant up

down:
	vagrant down

re:
	vagrant destroy -f && vagrant up

copy-k3s-config:
	vagrant ssh wxueruiS -c "sudo cat /etc/rancher/k3s/k3s.yaml" > ~/.kube/config	
