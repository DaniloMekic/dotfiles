#!/usr/bin/env bash

# 
# Language Servers
#
# PL/SQL: https://github.com/EwanDubashinski/plsqllang-server
PLSQL_LS="$HOME/.local/share/plsql_ls"
git clone https://github.com/EwanDubashinski/plsqllang-server.git /tmp/plsql_ls/
cd /tmp/plsql_ls/
git clone https://github.com/EwanDubashinski/parser.git parser
# Build dependency: ANTLR PL/SQL language grammar
mvn -f parser/pom.xml \
    clean install \
    -Dmaven.repo.local=tmp-maven-repo
# Build PL/SQL LS
mvn clean package \
    -Dmaven.repo.local=tmp-maven-repo
mkdir -p "$PLSQL_LS" && mv /tmp/plsql_ls/target/server-all.jar "$PLSQL_LS/plsql-ls.jar"
# Cleanup
rm -rf /tmp/plsql_ls/
