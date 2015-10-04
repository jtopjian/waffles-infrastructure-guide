WSD = waffles

tapply:
	cd terraform/$(ROLE) && terraform apply

tdestroy:
	cd terraform/$(ROLE) && terraform destroy

tplan:
	cd terraform/$(ROLE) && terraform plan

ctunnel:
	  ssh -i keys/infra -L 8500:localhost:8500 consul.example.com

.PHONY: waffles
waffles:
	WAFFLES_SITE_DIR=$(WSD) /etc/waffles/waffles.sh -s $(NODE) -k keys/infra -r $(ROLE)
