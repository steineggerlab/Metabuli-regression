#!/bin/sh -ex

FASTA1="${DATADIR}/reads/ERR9594652_5000_1.fna"
FASTA2="${DATADIR}/reads/ERR9594652_5000_2.fna"
FASTQ1="${DATADIR}/reads/ERR9594652_5000_1.fq"
FASTQ2="${DATADIR}/reads/ERR9594652_5000_2.fq"
DB="${DATADIR}/reference/ex"
TAXONOMY="${DATADIR}/files_for_db/taxonomy"


## Paired-end FASTA
"${METABULI}" classify "${FASTA1}" "${FASTA2}" "${DB}" "${RESULTS}" "fasta_paired" --max-ram 6 --threads 1 --taxonomy-path "${TAXONOMY}"

## Paired-end FASTQ
"${METABULI}" classify "${FASTQ1}" "${FASTQ2}" "${DB}" "${RESULTS}" "fastq_paired" --max-ram 6 --threads 1 --taxonomy-path "${TAXONOMY}"

## Single-end FASTA
"${METABULI}" classify --seq-mode 1 "${FASTA1}" "${DB}" "${RESULTS}" "fasta_single" --max-ram 6 --threads 1 --taxonomy-path "${TAXONOMY}"

## Single-end FASTQ
"${METABULI}" classify --seq-mode 1 "${FASTQ1}" "${DB}" "${RESULTS}" "fastq_single" --max-ram 6 --threads 1 --taxonomy-path "${TAXONOMY}"


## Evaluate results

## 1. Compare FASTA and FASTQ results.
CMP_NUM=2
ID_CNT=0

## Compare results between paired-end FASTA and FASTQ.
if diff -q "${RESULTS}/fasta_paired_report.tsv" "${RESULTS}/fastq_paired_report.tsv"; then
    ID_CNT=$((ID_CNT+1))
fi

## Compare results between single-end FASTA and FASTQ.
if diff -q "${RESULTS}/fasta_single_report.tsv" "${RESULTS}/fastq_single_report.tsv"; then
    ID_CNT=$((ID_CNT+1))
fi

## If ID_CNT is equal to CMP_NUM, the test is passed.
if [ "${ID_CNT}" -eq "${CMP_NUM}" ]; then
    echo "Test passed."
else
    echo "Test failed."
    exit 1
fi

## 2. Compare recall and precision.
TARGET="76.5200 1.0000 71.5400 1.0000" # paired-end Recall, paired-end Precision, single-end Recall, single-end Precision

PE_RECALL=$(grep -w 227984 "${RESULTS}/fasta_paired_report.tsv" | awk '{print $1}')
PE_CLASSIFIED=$(grep -w root "${RESULTS}/fasta_paired_report.tsv" | awk '{print $1}')
PE_PRECISION=$(echo "scale=4; ${PE_RECALL}/${PE_CLASSIFIED}" | bc)

SG_RECALL=$(grep -w 227984 "${RESULTS}/fasta_single_report.tsv" | awk '{print $1}')
SG_CLASSIFIED=$(grep -w root "${RESULTS}/fasta_single_report.tsv" | awk '{print $1}')
SG_PRECISION=$(echo "scale=4; ${SG_RECALL}/${SG_CLASSIFIED}" | bc)

ACTUAL="${PE_RECALL} ${PE_PRECISION} ${SG_RECALL} ${SG_PRECISION}"

awk -v actual="$ACTUAL" -v target="$TARGET" \
    'BEGIN { print (actual >= target) ? "GOOD" : "BAD"; print "Expected: ", target; print "Actual: ", actual; }' \
    > "${RESULTS}.report"



