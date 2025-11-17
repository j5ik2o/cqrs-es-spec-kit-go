#!/usr/bin/env bash

set -eu

# shellcheck disable=SC2046
cd $(dirname "$0") || exit

export ARCH=$(uname -m)
echo "ARCH=${ARCH}"

if [ "$ARCH" = "x86_64" ]; then
  ARCH="amd64"
fi

if [ "$ARCH" = "aarch64" ]; then
  ARCH="arm64"
fi

# Set default AWS_REGION if not set
export AWS_REGION=${AWS_REGION:-ap-northeast-1}
echo "AWS_REGION=${AWS_REGION}"

F_OPTION="-f ../docker-compose/docker-compose-applications.yml"

while getopts d OPT; do
  # shellcheck disable=SC2220
  case ${OPT} in
  "d") F_OPTION="" ;;
  esac
done

# Remove processed options from $@
shift $(($OPTIND - 1))

# Build Docker images if applications are included
if [ -n "$F_OPTION" ]; then
  echo "Building Docker images..."
  cd ../../
  make docker-build
  make docker-build-rmu
  cd tools/scripts
fi

docker compose -p cqrs-es-spec-kit-go -f ../docker-compose/docker-compose-databases.yml ${F_OPTION} down -v --remove-orphans
docker compose -p cqrs-es-spec-kit-go -f ../docker-compose/docker-compose-databases.yml ${F_OPTION} up --remove-orphans --force-recreate --renew-anon-volumes -d "$@"
