#!/usr/bin/env bash 

rootDir="$LOCAL_SOFTWARE/cli-zotero";
outDir="$HOME/Zotero/bib";
tool="$rootDir/cli-zotero.py";

test ! -d $outDir && mkdir -p $outDir;

$tool --id hspitia --collections-to-bibtex --out-dir $outDir 2>&1 > /dev/null;