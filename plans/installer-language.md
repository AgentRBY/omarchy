# Installer language (handoff)

Goal: the Omarchy ISO installer and the first-boot owner setup ask for the **language first, before the keyboard**; the keyboard picker then **defaults to the layout that fits that language**; the installer and setup screens are **translated** where the console can draw the language; and the **installed system comes up in that language**.

This builds on the 50-language work in omarchy PR #15326 (branch `fifty-languages`). Read `docs/i18n.md` and `AGENTS.md` first.

## Branches

- **omarchy** `installer-language` (off `fifty-languages`): this plan, plus the registry fields below. All omarchy-side installer work goes here.
- **omarchy-iso** `fifty-languages` (off `quattro`): a work-in-progress commit of `configs/airootfs/root/configurator` (language step, early console font, first screens translated). Unfinished; see below.

Land the omarchy side after (or into) PR #15326: the ISO vendors `install/provisioning/setup-form.sh` and runs `omarchy-i18n` from the omarchy runtime package it bundles, so the ISO change only works once an omarchy release carries the omarchy side.

## Decided

- **Console limits.** Both the ISO configurator and the first-boot owner setup (`bin/omarchy-provision-owner`) run on the Linux console (tty1). The kernel's default console font can't draw most languages (not even "ø"). With the Terminus console font (Arch `terminus-font`, e.g. `setfont ter-v24n`/`ter-v32n`), **36 languages render fully and 14 cannot**: Arabic, Hebrew, Persian, Urdu, Hindi, Bengali, Tamil, Sinhala, Thai, Vietnamese, Japanese, Korean, Chinese (Simplified), Chinese (Traditional). Measured by checking every character of each language's `cli.json`/`shell.json` and native name against `ter-v32n`'s unicode table (`psfgettable`).
- **The user chose "translate what fits":** the 36 get a translated installer; the 14 are listed by their English name and see an English installer, but their installed system boots fully in their language.
- **Registry** (`default/i18n/locales.json`, done on `installer-language`): each language has `keyboard`, the label of the layout to suggest (always a label in `OMARCHY_KEYBOARD_LAYOUTS` in `install/provisioning/setup-form.sh`), and the 14 undrawable ones have `"console": false`. Notable picks: Dutch → English (US) (the layout used in the Netherlands), Catalan → Spanish, Irish → Irish, languages with no console keymap (Arabic, Hindi, Persian, Thai, Vietnamese, Indonesian, Malay, Swahili, Filipino, Uzbek, Urdu, Bengali, Tamil, Sinhala) → English (US).

## The contract

### setup-form.sh (omarchy)

- `omarchy_prompt_language` — the new FIRST prompt, same status contract as the others (0 set / 1 Esc / 130 Ctrl+C). Lists all 50 languages, English first, then the rest by English name (as `omarchy-language list` does). A console-drawable language shows as `Native (English)` when they differ (`Dansk (Danish)`); an undrawable one by its English name only (`Japanese`). Preselects `$language` when already set, else English. Sets `language` (registry code) and `language_locale` (glibc locale), then exports `OMARCHY_LANGUAGE_FILE` pointing at a file it writes under `${TMPDIR:-/tmp}` containing the code when the console can draw it, `en` otherwise, so every later `omarchy-i18n` call speaks it.
- `omarchy_prompt_keyboard` preselects `keyboard_label` if already chosen, else the registry `keyboard` for `$language`, else `English (US)`.
- Every user-facing string in setup-form.sh goes through `"$OMARCHY_PATH/bin/omarchy-i18n" <key>`, keys under `setup.*` in `default/i18n/en/cli.json`, English unchanged.
- `omarchy_persist_language <target_root>` — root-side like `omarchy_persist_input_selection`: validates `$language` against the registry and writes `$target_root/etc/omarchy/language` (the code).
- `omarchy_console_font` — loads Terminus on a real VT (`/dev/tty*`) when available, no-op otherwise. The configurator and provision-owner call it at start.
- Document `language`, `language_locale` in the variable list at the top.

### Installed system (omarchy)

- `/etc/omarchy/language` holds the code chosen at install. A new user-install step (`install/user/language.sh`, wired into `install/user/all.sh`) applies it for the installing user when `~/.config/omarchy/language` doesn't exist: the language file plus the uwsm env file (`omarchy-language` does both; give it a flag to skip the notification and the live-session env update inside a chroot). The locale is already generated system-wide: archinstall `sys_lang` on the ISO, locale-gen as root in provision-owner.
- `bin/omarchy-provision-owner` (root, tty1): language before keyboard on the same screen, translated text, generate the chosen locale and set `LANG` in `/etc/locale.conf` (a fresh machine), and set the new owner's language when creating the user.
- Add `terminus-font` to the package list the installed system needs if provision-owner should draw it at first boot (check `install/*.packages`).
- `test/shell.d/i18n-test.sh`'s key-reference checks scan only `bin/`: extend them to `install/`, and accept `installer.*` keys as referenced from the omarchy-iso repo (document that in the test and `docs/i18n.md`).

### ISO (omarchy-iso)

- Live ISO: `terminus-font` in the ISO package list, `omarchy_console_font` before the greeter (the WIP commit calls it).
- Configurator: language then keyboard on the first screen (WIP done: Esc on keyboard returns to language; a changed language clears a keyboard picked for the previous one; Ctrl+C on either still offers deferred provisioning). Summary table gains Language (WIP started a tab-separated `summary_table`). `user_configuration.json` `locale_config.sys_lang` becomes `$language_locale` in **both** places it's written; `omarchy_install` gains `"language": "$language"`.
- Orchestrator (`configs/airootfs/usr/share/omarchy-iso/orchestrator/`): validate `omarchy_install.language` against `$OMARCHY_PATH/default/i18n/locales.json` in `context.py` (default `en` when absent, for old autoinstall configs), write `/etc/omarchy/language` in the target like `keyboard.py` writes the input-method preference, unit tests in `test/unit/`.
- Deferred provisioning (Ctrl+C path): first-boot owner setup asks the language.
- Every user-facing string in the configurator and `configs/airootfs/usr/local/bin/omarchy-install-dashboard` goes through `"$OMARCHY_PATH/bin/omarchy-i18n" installer.<key>` (the WIP adds an `i18n` helper). The English for each `installer.*` key goes in omarchy's `default/i18n/en/cli.json` on `installer-language` — the WIP commit already uses `installer.greeterTagline`, `greeterStart`, `aborted`, `retryHint` (`%1` = the script path), `setupMachine`, `prepareForAnotherOwnerHint`, `prepareForAnotherOwnerBody`, `prepareForAnotherOwnerDelay`, `prepareForAnotherOwnerYes`, `prepareForAnotherOwnerNo`, `prepareForAnotherOwnerConfirm`, `setupUser`; their English is the text those lines replaced (see that commit's diff). Debug/dry-run lines, logs and stderr stay English.

## Translating

New English goes through the normal pipeline: `python3 scripts/i18n-sync.py pending` / `translate --locale <code>` (Muse; `MUSE_MODEL` may need setting to a model the account can use), then `python3 scripts/i18n-sync.py manifest`, or let the `Sync translations` workflow do it once the English lands on `quattro`.

## Done means

omarchy: `./test/cli`, every `test/shell.d/*` touching what changed (including `provision-owner*`), and `I18N_STRUCTURAL=1 test/shell.d/i18n-test.sh`. omarchy-iso: `test/unit/` and what `bin/omarchy-iso-test` offers short of building an ISO. New tests for: language → keyboard preselection, persist validation, orchestrator language handling, `sys_lang`. Then a real ISO boot in a VM, checking a Latin language (Danish), a Cyrillic one (Russian), and an undrawable one (Japanese).

## Known follow-up (separate)

Picking a non-Latin keyboard layout (Russian, Greek, Hebrew, Ukrainian…) sets only that layout, so Latin letters can't be typed on the desktop afterwards. That's existing behavior, but defaulting those languages to their layout makes it more likely; worth adding a Latin layout alongside them.
