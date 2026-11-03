# Deploy the web application from the MacBook

Production is https://allure.want.foundation. The existing Want VPS is reached through the `wf-landings` SSH alias. Cloudflare proxies its A record to 129.101.120.227. Traefik terminates HTTPS using its existing Let's Encrypt DNS resolver; the separate Nginx service serves the complete static application on `want-edge`. Deployment does not rebuild or restart Wallpapers, Traefik or the database.

Use Bun 1.3.14, the root FVM pin and Python 3. Source, manifests and package versions must be committed. No GitHub Actions or npm/pub publication is part of this deployment.

## Prepare the server once

An operator with the existing SSH/sudo access installs the reviewed files from a clean, published checkout. Keep the helper and configuration root-owned. Never place Cloudflare credentials in the checkout or browser artifact.

Check `docker context show`, `docker system df`, `df -h /` and available memory first. A current artifact occupies about 92 MiB unpacked; reserve room for the uploaded archive, staging, current and previous releases. Preserve shared images and caches.

```sh
ssh wf-landings 'sudo -n install -d -m 755 /opt/want/apps/allure/data'
ALLURE_STAGE=$(ssh wf-landings 'mktemp -d /tmp/allure-install-XXXXXXXX')
scp deploy/compose.yml deploy/nginx.conf scripts/deploy-web.py "wf-landings:$ALLURE_STAGE/"
ssh wf-landings "sudo -n install -m 644 '$ALLURE_STAGE/compose.yml' '$ALLURE_STAGE/nginx.conf' '$ALLURE_STAGE/deploy-web.py' /opt/want/apps/allure/"
ssh wf-landings "rm '$ALLURE_STAGE/compose.yml' '$ALLURE_STAGE/nginx.conf' '$ALLURE_STAGE/deploy-web.py' && rmdir '$ALLURE_STAGE'"
ssh wf-landings 'sudo -n docker compose -f /opt/want/apps/allure/compose.yml config --quiet'
ssh wf-landings 'sudo -n docker compose -f /opt/want/apps/allure/compose.yml up -d'
```

Copy `deploy/traefik.yml` to a temporary file outside Traefik's watched directory, then install it as `/opt/want/traefik/dynamic/allure.yml` using an atomic rename. The file provider reloads it. Keep every existing route and static Traefik setting. Create only the proxied A record for `allure.want.foundation`; inspect existing DNS before writing and read it back afterward. The existing DNS token stays on the VPS. Verify the certificate and HTTPS redirect before publishing. A fresh service returns 404 until its first artifact is activated; keep the issue open during setup.

The container has no published host port, writable application mount or Docker socket. Its pinned Nginx image already exists on the VPS. Read-only configuration uses a 64 MiB memory limit and a bounded tmpfs. Keep the parent data directory mounted: mounting the `current` symlink target would prevent atomic switching from taking effect.

For later helper/configuration updates, inspect the diff, copy the reviewed files to unique private staging paths, verify their checksums, then install only those files. Validate the replacement Nginx configuration in a disposable container before updating the service. Because nginx.conf is a file bind mount, replacing its inode requires `docker compose -f /opt/want/apps/allure/compose.yml up -d --force-recreate static`; a signal-only reload would still read the old mount. Recreate only the Allure service. A helper checksum mismatch stops the client instead of silently using an older contract.

## Publish a merged revision

After review and merge, fetch origin and fast-forward the clean task checkout to the confirmed merge SHA. Do not move another worktree. The default command builds only when HEAD equals the refreshed origin/main.

```sh
bun run web:deploy
```

This runs `web:build` and `web:check`, writes `release.json` with the source revision and file checksums, and creates an exclusive archive under `~/.local/share/want-allure/releases`. It uploads to a unique temporary server directory, checks the archive and every file, and atomically switches `data/current` under a nonblocking lock. `data/previous` retains the previous release. Existing revision directories are immutable: a different archive for the same SHA is refused.

The command verifies public routes, metadata, fonts, shaders, runtime, MIME and cache headers. Its HTTP requests identify themselves as WantAllureReleaseCheck; the default Python client identifier is rejected by the current CDN configuration. Verification failure restores the previous pointer; on the first deployment it removes only the new current pointer. Interrupted or ambiguous SSH results require a fresh status check before any retry:

```sh
ssh wf-landings 'sudo -n python3 /opt/want/apps/allure/deploy-web.py status --root /opt/want/apps/allure/data'
```

To prepare a merged release before server setup, use `bun run web:deploy --prepare-only`. Archive creation writes to a private temporary pathname and publishes the final name only after completion. An interrupted preparation cannot leave a partial final archive.

Retry the exact retained archive rather than rebuilding the same source:

```sh
bun run web:deploy --artifact /absolute/path/to/allure-SOURCE_SHA.tgz
bun run web:verify --revision SOURCE_SHA
```

The archive's revision must belong to origin/main. Record the returned source SHA, archive SHA-256 and local archive path in the deployment result. Retain the archive for rollback and diagnosis; it contains no credentials. `release.json` is public and contains only revision/file hashes.

## Cache and routing contract

All twelve locales remain available. Existing directory pages redirect to a trailing slash while preserving query parameters. Missing pages and assets return 404 with the project's error document. There is no SPA fallback.

HTML, release metadata, Flutter bootstrap and service worker use `no-store`. Hashed Astro resources use a one-year immutable cache; current and previous release chunks remain available. Other paths require revalidation. Errors use `no-store`, including missing immutable resources. The Flutter bootstrap does not register a caching service worker. Every response includes `no-transform` so Cloudflare preserves the verified body instead of injecting HTML scripts or obfuscating email addresses. Nginx supplies JS/WASM/font/SVG types and `nosniff`.

Inspect public Cloudflare responses as well as origin behavior. If a hostname-specific cache override defeats these headers, correct only that host's rule with the owner account. Do not change zone-wide cache or TLS policy. Never claim a successful deployment while stale HTML/bootstrap remains observable.

## Rollback and cleanup

Use the full known-good SHA from status or the deployment record:

```sh
bun run web:rollback PREVIOUS_SOURCE_SHA
bun run web:verify --revision PREVIOUS_SOURCE_SHA
```

Rollback verifies the retained bytes and switches the pointer without rebuilding. It refuses a changed current release. If the command loses its SSH response, inspect status before retrying. A failed HTTP check after a requested rollback leaves that explicitly selected revision active for diagnosis.

Current and previous releases are never removed automatically. After a successful deployment, an operator may remove only older Allure release directories whose exact revisions are neither current nor previous and whose archives remain available. No shared Docker prune, volume deletion or unrelated cleanup is permitted. Recheck disk usage after cleanup.

For a failed first installation, restore the saved DNS/route state and remove only the Allure service and files created by this installation. Preserve the artifact and failure details privately. Never restart or remove shared services to recover Allure.

## Acceptance

Run the full local checks before merge. Run production browser checks after publication: English and Russian landing, React and Flutter; direct navigation and reload; both themes; language switching; 320 px and desktop layouts; Flutter readiness; local fonts, graphics and shaders; console/network errors. HTTP checks alone do not prove browser behavior.

Check canonical/hreflang, all twelve sitemap entries, robots, Open Graph artwork, TLS and HTTP redirects. Submit `/sitemap.xml` through the verified owner account in Search Console when available. Record submission separately from confirmed indexing; unavailable account access means submission remains unverified.

Keep #20 open until production HTTP and browser acceptance pass. Record the final source/artifact identity and any remaining limitation before closing it. Remove only the merged disposable remote task branch; retain the persistent task worktree.
