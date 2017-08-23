#!/usr/bin/env bash
#
# Copyright 2015-2017 Red Hat, Inc. and/or its affiliates
# and other contributors as indicated by the @author tags.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

PUBLIC_KEY="/client-secrets/hawkular-services-public.pem"

import_hawkular_services_public_key() {
  local PUBLIC_KEY_DER="/tmp/hawkular-services-public.cert"
  if [[ -f ${PUBLIC_KEY} ]] && [[ -s ${PUBLIC_KEY} ]]; then
    openssl x509 -inform pem -in ${PUBLIC_KEY} -out ${PUBLIC_KEY_DER}
    keytool -import -keystore "$JBOSS_HOME/$1/configuration/hawkular-services.truststore" -storepass hawkular \
    -file ${PUBLIC_KEY_DER} -noprompt
    rm -f ${PUBLIC_KEY_DER}
  fi
}

run_hawkular_agent() {
  ${JBOSS_HOME}/bin/$1.sh
}

main() {
  import_hawkular_services_public_key $1
  run_hawkular_agent "$@"
}

main "$@"