#!/bin/sh -ex

IN_INPUT="${DATADIR}/files_for_db/inclusion.txt"
EX_INPUT="${DATADIR}/files_for_db/exclusion.txt"
ACC2TAXID="${DATADIR}/files_for_db/test.accession2taxid"
TAXONOMY="${DATADIR}/files_for_db/taxonomy"
REF="${DATADIR}/reference/"

cd "${DATADIR}/files_for_db/"

"${METABULI}" build "${RESULTS}/inclusionDB" "${IN_INPUT}" "${ACC2TAXID}" --threads 1 --buffer-size 100000 --taxonomy-path "${TAXONOMY}"

"${METABULI}" build "${RESULTS}/exclusionDB" "${EX_INPUT}" "${ACC2TAXID}" --threads 1 --buffer-size 100000 --taxonomy-path "${TAXONOMY}"

cd "${BASE}"

## Evaluate

## 1. Compare built DBs with expected DBs.
CMP_NUM=6
ID_CNT=0

## Compare results between paired-end FASTA and FASTQ.
## Inclusion DB
if diff -q "${RESULTS}/inclusionDB/diffIdx" "${REF}/in/diffIdx"; then
    ID_CNT=$((ID_CNT+1))
fi

if diff -q "${RESULTS}/inclusionDB/info" "${REF}/in/info"; then
    ID_CNT=$((ID_CNT+1))
fi

if diff -q "${RESULTS}/inclusionDB/split" "${REF}/in/split"; then
    ID_CNT=$((ID_CNT+1))
fi

## Exclusion DB
if diff -q "${RESULTS}/exclusionDB/diffIdx" "${REF}/ex/diffIdx"; then
    ID_CNT=$((ID_CNT+1))
fi

if diff -q "${RESULTS}/exclusionDB/info" "${REF}/ex/info"; then
    ID_CNT=$((ID_CNT+1))
fi

if diff -q "${RESULTS}/exclusionDB/split" "${REF}/ex/split"; then
    ID_CNT=$((ID_CNT+1))
fi


## If ID_CNT is equal to CMP_NUM, the test is passed.
if [ "${ID_CNT}" -eq "${CMP_NUM}" ]; then
    echo "Test passed."
else
    echo "Test failed."
    exit 1
fi

awk -v actual="$ID_CNT" -v target="$CMP_NUM" \
    'BEGIN { print (actual == target) ? "GOOD" : "BAD"; print "Expected: ", target; print "Actual: ", actual; }' \
    > "${RESULTS}.report"

