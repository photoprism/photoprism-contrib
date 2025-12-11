#!/usr/bin/env bash
#
# Automatically assign marker_name + subj_src=manual to face markers
# based on Originals/Pictures/<firstname>_<lastname>.jpg files.
# See README.md for implementation details.

set -euo pipefail

#############################
## Defaults & CLI parsing  ##
#############################

DRY_RUN=1
VERBOSE=0

usage() {
  cat <<'EOF'
Usage: name-faces.sh [--apply] [--verbose]

Options:
  --apply      Perform updates (default is dry-run).
  --verbose    Print extra diagnostics.
  -h, --help   Show this help.

Env vars (defaults in parentheses):
  PHOTOPRISM_ORIGINALS_PATH   Originals root (storage/originals)
  PHOTOPRISM_DATABASE_SERVER  Host[:port] (required, e.g. mariadb:3306)
  PHOTOPRISM_DATABASE_NAME    Database name (photoprism)
  PHOTOPRISM_DATABASE_USER    DB user (root)
  PHOTOPRISM_DATABASE_PASSWORD DB password (required)
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --apply) DRY_RUN=0 ;;
    --verbose|-v) VERBOSE=1 ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown option: $1" >&2; usage; exit 1 ;;
  esac
  shift
done

#############################
## Dependency checks       ##
#############################

need_cmd() {
  command -v "$1" >/dev/null 2>&1 || {
    echo "Missing required command: $1" >&2
    echo "Please install it (base images include find/sed/awk; mariadb-client may need to be added)." >&2
    exit 1
  }
}

need_cmd find
need_cmd sed
need_cmd mariadb

#############################
## Config & DB connection  ##
#############################

ORIGINALS_ROOT=${PHOTOPRISM_ORIGINALS_PATH:-storage/originals}

DB_SERVER=${PHOTOPRISM_DATABASE_SERVER:-}
DB_NAME=${PHOTOPRISM_DATABASE_NAME:-photoprism}
DB_USER=${PHOTOPRISM_DATABASE_USER:-root}
DB_PASS=${PHOTOPRISM_DATABASE_PASSWORD:-}

if [[ -z "$DB_SERVER" || -z "$DB_PASS" ]]; then
  echo "PHOTOPRISM_DATABASE_SERVER and PHOTOPRISM_DATABASE_PASSWORD must be set." >&2
  exit 1
fi

DB_HOST=${DB_SERVER%%:*}
DB_PORT=${DB_SERVER#*:}
if [[ "$DB_HOST" == "$DB_PORT" ]]; then
  DB_PORT=3306
fi

MYSQL_ARGS=(
  -h "$DB_HOST"
  -P "$DB_PORT"
  -u "$DB_USER"
  "-p$DB_PASS"
  "$DB_NAME"
)

run_sql() {
  local sql="$1"
  mariadb --batch --raw --skip-column-names "${MYSQL_ARGS[@]}" --execute "$sql"
}

[[ -d "$ORIGINALS_ROOT/Pictures" ]] || {
  echo "Pictures directory not found at $ORIGINALS_ROOT/Pictures" >&2
  exit 1
}

#############################
## Counters & helpers      ##
#############################

found=0
updated=0
skipped_missing=0
skipped_multi=0
skipped_has_subj=0
not_updated=0

log() {
  echo "$*"
}

debug() {
  (( VERBOSE )) && echo "DEBUG: $*"
}

#############################
## Main loop               ##
#############################

set +e  # allow read to return 1 at EOF without exiting
while IFS= read -r -d '' file; do
  base=$(basename "$file")
  # Match First_Last.jpg (case-insensitive)
  if [[ ! "$base" =~ ^([A-Za-z]+)_([A-Za-z]+)\.[Jj][Pp][Ee]?[Gg]$ ]]; then
    debug "Skip non-matching file: $base"
    continue
  fi

  ((found++))

  firstname=${BASH_REMATCH[1]}
  lastname=${BASH_REMATCH[2]}
  full_name="$firstname $lastname"
  filename_rel="Pictures/$base"

  debug "Processing $filename_rel -> $full_name"

  select_sql="
SELECT m.marker_uid, IFNULL(m.subj_uid,'')
FROM markers AS m
JOIN files AS f ON f.file_uid = m.file_uid
WHERE f.file_name = '${filename_rel}'
  AND f.file_primary = 1
  AND (m.marker_type = 'face' OR m.marker_type = '' OR m.marker_type IS NULL);"

  rows=$(run_sql "$select_sql" || true)

  if [[ -z "$rows" ]]; then
    ((skipped_missing++))
    log "SKIP  missing marker for $filename_rel"
    continue
  fi

  mapfile -t row_arr <<<"$rows"

  if (( ${#row_arr[@]} != 1 )); then
    ((skipped_multi++))
    log "SKIP  ambiguous marker rows (${#row_arr[@]}) for $filename_rel"
    continue
  fi

  IFS=$'\t' read -r marker_uid subj_uid <<<"${row_arr[0]}"

  if [[ -n "$subj_uid" ]]; then
    ((skipped_has_subj++))
    log "SKIP  subject already set for $filename_rel (marker ${marker_uid})"
    continue
  fi

  if (( DRY_RUN )); then
    log "DRY   would set name='$full_name' subj_src=manual for $filename_rel (marker ${marker_uid})"
    continue
  fi

  update_sql="
UPDATE markers AS m
JOIN files AS f ON f.file_uid = m.file_uid
SET m.marker_name = '${full_name}',
    m.subj_src   = 'manual'
WHERE f.file_name = '${filename_rel}'
  AND f.file_primary = 1
  AND (m.marker_type = 'face' OR m.marker_type = '' OR m.marker_type IS NULL)
  AND (m.subj_uid IS NULL OR m.subj_uid = '')
LIMIT 1;
SELECT ROW_COUNT();"

  result=$(run_sql "$update_sql")
  affected=$(echo "$result" | tail -n1 | tr -d '\r')

  if [[ "$affected" =~ ^[0-9]+$ ]] && (( affected > 0 )); then
    ((updated++))
    log "DONE  updated $filename_rel (marker ${marker_uid}, rows=$affected)"
  else
    ((not_updated++))
    log "WARN  no rows updated for $filename_rel (marker ${marker_uid})"
  fi

done < <(find "$ORIGINALS_ROOT/Pictures" -maxdepth 1 -type f \( -iname '*.jpg' -o -iname '*.jpeg' \) -print0)
set -e

#############################
## Summary & next steps    ##
#############################

echo "---- Summary ----"
echo "Candidates: $found"
echo "Updated:    $updated"
echo "Skipped missing marker: $skipped_missing"
echo "Skipped ambiguous:      $skipped_multi"
echo "Skipped has subject:    $skipped_has_subj"
echo "No-op updates:          $not_updated"
echo
echo "Next: run 'photoprism faces update --force' to create/link subjects and match faces."
