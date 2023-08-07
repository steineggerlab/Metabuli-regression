#!/bin/sh -ex

FASTA1="${DATADIR}/reads/"
FASTA2="${DATADIR}/reads/"
FASTQ1="${DATADIR}/reads/"
FASTQ2="${DATADIR}/reads/"

## Paired-end FASTA
"${METABULI}" classify "${FASTA1}" "${FASTA2}" "${RESULTS}/inclusionDB" "${RESULTS}/inclusion" "fasta_paired" --max-ram 6

## Paired-end FASTQ
"${METABULI}" classify "${FASTQ1}" "${FASTQ2}" "${RESULTS}/inclusionDB" "${RESULTS}/inclusion" "fastq_paired" --max-ram 6

## Single-end FASTA
"${METABULI}" classify --seq-mode 1 "${FASTA1}" "${RESULTS}/inclusionDB" "${RESULTS}/inclusion" "fasta_single" --max-ram 6

## Single-end FASTQ
"${METABULI}" classify --seq-mode 1 "${FASTQ1}" "${RESULTS}/inclusionDB" "${RESULTS}/inclusion" "fastq_single" --max-ram 6

## Long-read ????
