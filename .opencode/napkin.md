# Napkin

## Mistakes

## Corrections

- Confirmed `postgresql@14` was installed and running even though no app databases existed. Stopped service first, verified no listener-dependent usage, then replaced with `postgresql@18`.

## Learnings

- For Homebrew DB deprecation checks, verify three things before uninstall: `brew services list`, actual listener on `5432`, and local databases via `psql`.
