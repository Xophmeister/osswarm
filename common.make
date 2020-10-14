# Check environment variable exists
# https://stackoverflow.com/a/7367903/876937
check-%:
	@ if [ "${${*}}" = "" ]; then \
	  echo "Environment variable $* not set"; \
	  exit 1; \
	fi
