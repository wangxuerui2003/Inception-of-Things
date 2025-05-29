all: up

up:
	vagrant up

down:
	vagrant halt

clean:
	vagrant destroy -f

re: clean all

undeploy:
	k3d cluster delete Iot-cluster 

deploy:
	bash ./scripts/deploy.sh

redeploy: undeploy deploy

ssh:
	vagrant ssh

