WSD = waffles

tapply:
	@. cd terraform/$(ROLE) && terraform apply

tdestroy:
	@. cd terraform/$(ROLE) && terraform destroy

tplan:
	@. cd terraform/$(ROLE) && terraform plan

.PHONY: waffles
waffles:
	WAFFLES_SITE_DIR=$(WSD) /etc/waffles/waffles.sh -s $(NODE) -k keys/infra -r $(ROLE)
