# Roleplaying Helper — WoW Forever

A compatibility port of the archived Roleplaying Helper 0.90d addon for WoW 1.12x, originally authored by Talyn and contributors. This repository is independent of the archived source repository.

## Current status: early development port (0.2.0-dev)

The port now includes:
- Mainline-style addon manifest and per-character SavedVariables.
- Modern frame event registration and slash commands: `/rp`, `/rph`, `/rp on`, `/rp off`, `/rp toggle`, `/rp status`, and `/rp test EVENT`.
- Modern combat-log mapping for combat start/end, incoming damage/misses, player critical hits, and heals.
- Basic NPC/gossip, merchant, trade, mount, resurrection, and level-up triggers where modern events expose a usable signal.
- The original English race/class phrase modules, generic phrases, insults/emotes, emote definitions, and event/spell localization data copied into `Data/`.
- A compact modern settings panel for global enable, chance, and delay.

## Compatibility notes

This is not yet feature-complete and has not been tested inside a WoW Forever client. Vanilla's old combat-chat events and many 1.12 UI templates no longer exist in the modern client. Some original features therefore need redesigned triggers or cannot be reproduced exactly.

Known porting work still required:
- Rebuild the original multi-page configuration UI, including per-event/per-spell chance and delay, trait selection, event/spell lists, language controls, and debug/statistics pages.
- Port the original keyword substitution engine and custom phrase composition.
- Complete modern pet, spell, NPC conversation-stage, quest, resurrection, and world-event triggers.
- Validate all combat-log field mappings and event availability against the exact Forever build.
- Add German localization after the English port is stable.
- Add in-client regression testing and fix any UI-template/API differences.

The original phrase data is retained, but the compatibility layer currently handles only a subset of the original runtime behavior. Do not treat this development version as a release-ready replacement.

## Installation (when ready)

Place the addon folder in the Forever client's `Interface/AddOns/RoleplayingHelper` directory. Enable it from the AddOns list at character selection. This development build may require fixes before normal use.

## Credits and source

Original addon and phrase content by the Roleplaying Helper authors and translators. The archived source is at https://github.com/XalZul/RoleplayingHelper-1.12. This port preserves attribution and keeps the archived repository untouched.