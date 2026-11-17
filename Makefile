IMAGE ?= git.teletypegames.org/build/tic80pro:latest
TIC80_REF ?= ae1195a9
UPDATE_SERVER ?= https://teletypegames.org
EMSDK_TAG ?= $(if $(filter arm64 aarch64,$(shell uname -m)),4.0.10-arm64,4.0.10)

.PHONY: image push export-image push-export runtime upload-runtime

image:
	docker build --platform linux/amd64 --build-arg TIC80_REF=$(TIC80_REF) -t $(IMAGE) .

push: image
	docker push $(IMAGE)

BASE ?= git.teletypegames.org/build/tic80pro:2026.11.17

export-image:
	docker build --platform linux/amd64 -f export.Dockerfile --build-arg BASE=$(BASE) --build-arg TIC80_REF=$(TIC80_REF) -t $(IMAGE) .

push-export: export-image
	docker push $(IMAGE)

runtime:
	docker build -f web.Dockerfile --build-arg TIC80_REF=$(TIC80_REF) --build-arg EMSDK_TAG=$(EMSDK_TAG) --output type=local,dest=dist .
	@echo "==> dist/tic80-runtime.zip, TIC-80 $$(cat dist/VERSION)"

upload-runtime:
	@test -n "$(TOKEN)" || { echo "TOKEN=<application token with the upload scope> is required" >&2; exit 1; }
	curl -fsS -H "X-Update-Secret: $(TOKEN)" -F name=tic80 -F version=$$(cat dist/VERSION) \
	  -F file=@dist/tic80-runtime.zip $(UPDATE_SERVER)/build/runtime
	@echo
