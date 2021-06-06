#!/bin/sh

testDependencyCheckCorrectlyInstalled() {
  test -s /dependency-check/bin/dependency-check.sh
  assertEquals "0" "$?"
}

testDatabaseShouldBePresent() {
  test -s /data/odc.mv.db
  assertEquals "0" "$?"
}

testIfUserIsPresent() {
  assertEquals "owasp:x:100:101:Linux User,,,:/home/owasp:/sbin/nologin" "$(tail -n 1 /etc/passwd)"
}

testDependencyCommandGloballyAvailable() {
  assertEquals 'dependency-check command should be installed' "/usr/bin/dependency-check" "$(which dependency-check)"
}

testAnalyzingDemoProjectShouldFindViolation() {
  ./mvnw org.owasp:dependency-check-maven:6.1.6:aggregate -DautoUpdate=false -DdataDirectory=/data > output.txt
  grep "jackson-databind-2.9.1.jar" output.txt
  assertEquals "0" "$?"
  grep "CVE-2017-17485" output.txt
  assertEquals "0" "$?"
}

. shunit2