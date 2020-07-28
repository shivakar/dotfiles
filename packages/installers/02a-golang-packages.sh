#!/usr/bin/env bash
ml go
export GOPATH=$HOME/go

go get -u \
	"github.com/GoASTScanner/gas" \
	"github.com/alecthomas/gometalinter" \
	"github.com/dominikh/go-tools/cmd/keyify" \
	"github.com/fatih/gomodifytags" \
	"github.com/fatih/motion" \
	"github.com/golang/lint/golint" \
	"github.com/josharian/impl" \
	"github.com/jstemmer/gotags" \
	"github.com/kisielk/errcheck" \
	"github.com/klauspost/asmfmt/cmd/asmfmt" \
	"github.com/nsf/gocode" \
	"github.com/rogpeppe/godef" \
	"github.com/zmb3/gogetdoc" \
	"golang.org/x/tools/cmd/..." \


