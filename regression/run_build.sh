#!/bin/sh -ex

IN_INPUT="${DATADIR}/files_for_db/inclusion.txt"
EX_INPUT="${DATADIR}/files_for_db/exclusion.txt"
ACC2TAXID="${DATADIR}/files_for_db/test.accession2taxid"
TAXONOMY="${DATADIR}/files_for_db/taxonomy"

"${METABULI}" build "${RESULTS}/inclusionDB" "${IN_INPUT}" "${ACC2TAXID}" --threads 1 --buffer-size 100000 --taxonomy-path "${TAXONOMY}"

"${METABULI}" build "${RESULTS}/exclusionDB" "${EX_INPUT}" "${ACC2TAXID}" --threads 1 --buffer-size 100000 --taxonomy-path "${TAXONOMY}"

## Evaluate

IN_diffIdx="56501ee4e9ed29aef83446b80b523684"
IN_info="35ceab567b57ae6d8bc347731a9d65e3"
EX_diffIdx="295c0e57135ed5812ef5b933fc435845"
EX_info="31da0a863effaadefcd48727e1cc0a13"



