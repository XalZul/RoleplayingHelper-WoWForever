# Roleplaying Helper — WoW Forever

A compatibility port of the archived Roleplaying Helper 0.90d addon for WoW 1.12x, originally authored by Talyn and contributors. This repository is independent of the archived source repository.

## Current status: early development port (0.2.0-dev)

Implemented in this checkpoint:
- Forever 1.60.1 manifest (`Interface: 16001`) and per-character SavedVariables.
- Slash commands: `/rp`, `/rph`, `/rp on`, `/rp off`, `/rp toggle`, `/rp status`, `/rp insult` (or `/rp i`), `/rp emote` (or `/rp e`), and `/rp test EVENT`.
- Basic modern settings panel for global enable, chance, and delay.
- Modern frame-event triggers for combat start/end, resurrection, level-up, gossip/merchant interactions, trade windows, mounting, selected NPC chat events, and logout.
- Original English generic, race, class, insult and emote phrase modules, plus the original event/spell localization and emote definitions copied into `Data/`.

## Important Forever API limitation

Forever uses the modern Mainline-family addon API, not the Vanilla 1.12 API. In particular, the current Forever client does not deliver the traditional combat-log event stream to addons. That prevents an addon from reliably reproducing many of the original combat reactions (incoming hits, misses, blocks, dodges, parries, damage/spell criticals, and healing criticals) using the original event model. These reactions are therefore not currently implemented. This is a client restriction, not simply a missing code conversion.

The current build does **not** claim feature parity with Vanilla Roleplaying Helper.

## Remaining work
- Rebuild the original multi-page configuration UI, including per-event/per-spell chance and delay, trait selection, event/spell lists, language controls, and debug/statistics pages.
- Port the original keyword substitution engine and custom phrase composition.
- Investigate supported non-combat alternatives for pet, spell, quest, NPC conversation-stage, and world-event triggers.
- Restore event-specific emotes/custom emotes and random phrase construction.
- Add German localization after the English port is stable.
- Test in the live Forever client and verify all event names, UI templates, and SavedVariables behavior.

The original phrase content is preserved, but the compatibility layer currently uses only a subset of the original runtime behavior. Do not treat this development version as a release-ready replacement.

## Installation (when ready)

Place the addon folder in the Forever client's `Interface/AddOns/RoleplayingHelper` directory. Enable it from the AddOns list at character selection. This development build may require fixes before normal use.

## Credits and source

Original addon and phrase content by the Roleplaying Helper authors and translators. Archived source: https://github.com/XalZul/RoleplayingHelper-1.12. This port preserves attribution and leaves that repository untouched.
