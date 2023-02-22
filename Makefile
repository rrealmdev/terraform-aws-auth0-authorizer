REPO    := amancevice/$(shell basename $$PWD)
RUNTIME := public.ecr.aws/lambda/nodejs:16

package.zip: package.iid package-lock.json
	docker run --rm --entrypoint cat $$(cat $<) $@ > $@

package-lock.json: package.iid
	docker run --rm --entrypoint cat $$(cat $<) $@ > $@

package.iid: index.js package.json Dockerfile
	docker build --build-arg RUNTIME=$(RUNTIME) --iidfile $@ --tag $(REPO) .

.terraform:
	terraform init

.PHONY: clean clobber validate zip

clean:
	rm -rf package.iid

clobber: clean
	docker image ls --quiet $(REPO) | uniq | xargs docker image rm --force

validate: | .terraform
	terraform fmt -check
	terraform validate

zip: package.zip
