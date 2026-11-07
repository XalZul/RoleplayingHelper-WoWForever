# Roleplaying Helper — WoW Forever

A Forever-client port of Talyn's archived Roleplaying Helper 0.90d (originally WoW 1.12x).

> **Status: port in progress.** This repository is separate from the original `XalZul/RoleplayingHelper-1.12`. No changes are made to the original repository.

## Port goals
- Retain the original RP event behavior, race/class phrase sets, customization, slash commands, and configuration UI as closely as the modern API permits.
- Replace Vanilla frame/event/chat APIs with the Forever (Mainline-family) equivalents.
- Keep character settings saved per character.
- Clearly document feature differences caused by Forever's API restrictions.

Forever's API is not Vanilla's API. In particular, old combat-chat parsing cannot be assumed to be available; event-driven features must be reimplemented using supported modern events and APIs.

## Installation
When a release is ready, install this folder under `World of Warcraft\_forever_\Interface\AddOns\RoleplayingHelper`. Do not install this development checkpoint as a complete feature-equivalent release.

## Credits
Original addon and phrase content by the original Roleplaying Helper authors; archived source uploaded by Talyn. This port retains attribution and is intended as a compatibility adaptation.