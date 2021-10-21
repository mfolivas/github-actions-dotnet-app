SRC_DIR_NAME?=app
# -----------------------------------------------------------------------------
# Base properties
# -----------------------------------------------------------------------------
BASE_DIR:=$(dir $(lastword $(MAKEFILE_LIST)))
BIN_DIR:=${BASE_DIR}/bin
PROJECT_DIR:=$(abspath $(dir $(firstword $(MAKEFILE_LIST))))
BUILDER_VERSION:=$(shell cat ${BASE_DIR}/VERSION | tr -d '\r\n' | tr -d '\n').$(shell git -C ${BASE_DIR} rev-parse --short HEAD)
PROJECT_VERSION:=$(shell cat ${PROJECT_DIR}/VERSION | tr -d '\r\n' | tr -d '\n' | tr -d ' ')
PROJECT_TIMESTAMP="$(shell date -u +%Y%m%d%H%M%S)"
PROJECT_COMMIT:=$(shell git -C ${PROJECT_DIR} rev-parse --short HEAD)
PROJECT_BRANCH:=$(shell git -C ${PROJECT_DIR} rev-parse --abbrev-ref HEAD)
PROJECT_BUILD_VERSION:=${PROJECT_VERSION}.${PROJECT_TIMESTAMP}_${PROJECT_COMMIT}${VERSION_SUFFIX}
PROJECT_DEFAULT_NAME=$(shell basename $(shell pwd))
PROJECT_NAME?=$(shell basename $(shell git -C ${PROJECT_DIR} config --get remote.origin.url || echo "$(PROJECT_DEFAULT_NAME)"))
PROJECT_BUILD_DATE="$(shell date -u +%FT%T.000Z)"
OUTPUT_DIR_NAME=gen
OUTPUT_DIR=${PROJECT_DIR}/${OUTPUT_DIR_NAME}
OUTPUT_DIR_OWNER:=$(if $(OUTPUT_DIR_OWNER),$(OUTPUT_DIR_OWNER),$(shell id -u ${USER}):$(shell id -u ${USER}))
BUILDER_DIR:=$(shell dirname $(filter %/$(BUILDER_NAME)/Makefile, $(MAKEFILE_LIST)))
ARTIFACTS_DIR_NAME=artifacts
ARTIFACTS_DIR ?= ${OUTPUT_DIR}/${ARTIFACTS_DIR_NAME}
BUILD_ARGS+=--build-arg WORK_DIR=/${WORK_DIR}
BUILD_ARGS+=--build-arg OUTPUT_DIR=/${WORK_DIR}/${OUTPUT_DIR_NAME}
BUILD_ARGS+=--build-arg ARTIFACTS_DIR=${WORK_DIR}/${ARTIFACTS_DIR_NAME}
VOLUME_MOUNTS=
RELEASE_AUTO_PUSH=

# -----------------------------------------------------------------------------
# Local targets
# -----------------------------------------------------------------------------

DOTNET_APP_NAME=Sample
DOTNET_APP_SRC_DIR=$(PROJECT_DIR)/$(SRC_DIR_NAME)/src/$(DOTNET_APP_NAME)
DOTNET_APP_TEST_DIR=$(PROJECT_DIR)/$(SRC_DIR_NAME)/tests/$(DOTNET_APP_NAME).Tests


build-dependencies::
	@dotnet restore $(DOTNET_APP_SRC_DIR) --no-cache

release-product::
	@${BIN_DIR}/update_dependency.sh CTKO.MainLibrary ${LIB_VERSION} --push

local-build::
	$(MAKE) build-dependencies
	@dotnet msbuild $(DOTNET_APP_SRC_DIR)

local-test::
	$(MAKE) build-dependencies
	@dotnet msbuild $(DOTNET_APP_SRC_DIR)
