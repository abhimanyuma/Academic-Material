m4_dnl Helper m4 macro
m4_define(`repo_item',
  `m4_esyscmd(SCRIPTS/repo-item BASE_URL`'DIR m4_dnl
m4_translit(`$@',`,',` '))')