# Name-Faces Script

This script fills in names for detected faces when profile JPEGs encode `<firstname>_<lastname>` in their filename. It sets `marker_name` and `subj_src=manual` on matching face markers, then relies on `photoprism faces update` to create/link subjects and propagate to faces/markers.

## Requirements

- PhotoPrism running with MariaDB/MySQL.
- `mariadb` (client) available inside the container (install if missing).
- Originals path contains `Pictures/<firstname>_<lastname>.jpg` files; each such JPEG shows one person.
- Face detection already ran so a face marker exists for the file (typical after `photoprism index`).

## What the Script Does

1) Scans `Pictures/` for files named `Firstname_Lastname.jpg` (or .jpeg).
2) Parses `Firstname Lastname`.
3) Finds the primary face marker for that file.
4) If `subj_uid` is empty, sets `marker_name` and `subj_src=manual` (dry-run by default).
5) Reminds you to run `photoprism faces update --force` to create/link subjects and faces.

## Limitations / Safety

- Does **not** overwrite markers that already have `subj_uid`.
- Assumes exactly one face marker per target file.
- Requires an existing marker with embeddings; otherwise `faces update` cannot create a subject/face.
- Runs a single-row `UPDATE ... LIMIT 1` per file to prevent bulk mistakes.

## Usage Examples

### 1) Dry-run (default)
```bash
photoprism exec /bin/bash -lc "./name-faces.sh"
```
Outputs planned updates only.

### 2) Apply updates
```bash
photoprism exec /bin/bash -lc "./name-faces.sh --apply"
```

### 3) Post-step (create/link subjects and faces)
```bash
photoprism exec /bin/bash -lc "photoprism faces update --force"
```

### Options

- `--apply`   perform updates (otherwise dry-run).
- `--verbose` extra diagnostics.

### Environment Variables

- `PHOTOPRISM_ORIGINALS_PATH` (default `/photoprism/storage/originals`)
- `PHOTOPRISM_DATABASE_SERVER` (default `mariadb:3306`)
- `PHOTOPRISM_DATABASE_NAME`   (default `photoprism`)
- `PHOTOPRISM_DATABASE_USER`   (default `root`)
- `PHOTOPRISM_DATABASE_PASSWORD` (**required**)

Example with custom DB host:
```bash
photoprism exec /bin/bash -lc "PHOTOPRISM_DATABASE_SERVER=db:3306 PHOTOPRISM_DATABASE_PASSWORD=secret ./name-faces.sh --apply"
```

## Files & Database Tables

- Script: `name-faces.sh`
- Tables:
  - `files` — stores `file_name`, `file_uid`, `file_primary`.
  - `markers` — face markers (`marker_uid`, `file_uid`, `marker_type='face'`, `marker_name`, `subj_uid`, `subj_src`, `face_id`).
  - `subjects` — people records; created later by `photoprism faces update`.
- Key query used by the script (simplified):
  - `SELECT m.marker_uid, m.subj_uid FROM markers m JOIN files f ON f.file_uid=m.file_uid WHERE f.file_name=:filename AND f.file_primary=1 AND m.marker_type='face';`
  - `UPDATE markers ... SET marker_name=:full_name, subj_src='manual' WHERE f.file_name=:filename AND f.file_primary=1 AND m.marker_type='face' AND (m.subj_uid IS NULL OR m.subj_uid='') LIMIT 1;`

## Contributor Notes

- Subject creation is handled by `photoprism faces update` via `query.CreateMarkerSubjects()` which picks markers with `marker_name <> ''`, `subj_src <> 'auto'`, `marker_type='face'`, `subj_uid=''`.
- If you add logic (e.g., better filename parsing, multi-face support), ensure:
  - You keep the guard `(m.subj_uid IS NULL OR m.subj_uid='')`.
  - You don’t bypass `LIMIT 1`.
  - You keep `marker_type='face'` filter.
- Useful code references:
  - `internal/entity/marker.go` (SetName, SyncSubject, Face handling)
  - `internal/entity/query/subjects.go` (CreateMarkerSubjects)
  - `internal/photoprism/faces.go` and `faces_update` command wiring.

## Troubleshooting

- “Missing required command: mariadb” → install the MariaDB client in the container image.
- “Pictures directory not found” → ensure `PHOTOPRISM_ORIGINALS_PATH` points to the correct mount and that `Pictures/` exists.
- No-op updates for a file → likely the marker already has `subj_uid` or the filename doesn’t match pattern.
- After apply, still no subject → run `photoprism faces update --force`; if still empty, the marker may lack embeddings; re-run face detection or re-index that file.
