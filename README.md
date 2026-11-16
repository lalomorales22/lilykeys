# LilyKeys

A music studio that runs on your own computer: a playable piano, a LilyPond score editor,
a drum machine, a sampled orchestra and band, and Claude as a composing partner.

Describe the music you want and Claude writes the score. LilyKeys engraves it as sheet music,
plays it back on the piano, and keeps everything you make in a gallery.

## What it does

- **Piano.** Five octaves, playable with the mouse, the computer keyboard or a MIDI keyboard.
  Ten sounds: a sampled grand piano plus electric piano, organ, strings, pad, bells, pluck, lead, bass and 8-bit.
- **Orchestra and band.** Scores can use any General MIDI instrument: strings, woodwinds, brass, timpani, harp, choir,
  guitars, basses, saxophones, organs, synths and world instruments. Each staff plays back with the sampled instrument named
  in its `midiInstrument`, placed where it would sit on a concert stage. The same instruments are on the keyboard's Sound menu.
- **Score.** Write LilyPond in the editor and engrave it to sheet music. Play it back, or download the PDF, MIDI or `.ly` file.
- **Compose with Claude.** Ask for a new piece or a change. Claude sees your current score and beat and returns a complete score that the app engraves.
  Pick the instruments from the menu above the chat (full orchestra, film score, string orchestra or quartet, wind quintet, brass, choir,
  jazz, rock, pop, electronic, lo-fi, Latin, folk, world), or leave it on "Any instruments" and just say what you want.
- **Text into music.** Paste a transcript, course notes or an article, or attach a `.txt` / `.md` file. Claude turns the ideas and structure of the text into an instrumental piece or a song with lyrics.
- **Beat machine.** Eight drum tracks, up to 8 bars (128 steps), with accents, ghost notes, swing, three kits and starter grooves. It can play in time with the score.
- **Sound desk.** Rotary knobs for brightness, resonance, drive, chorus, echo and room on the keys, plus level, tone, crunch, tuning and per-drum levels on the drums.
- **Record a take.** Play something and it is written down as notation.
- **Gallery.** Every piece saves itself. The gallery page lists them with a player that shows a scrolling piano roll.

## Install

```bash
git clone https://github.com/lalomorales22/lilykeys.git
cd lilykeys
./setup.command
```

Or double-click `setup.command` in Finder. It installs whatever is missing and leaves the rest alone, so it is safe to run again:

- [Homebrew](https://brew.sh) (macOS), used to install the next two
- [Node.js](https://nodejs.org) 18 or newer
- [LilyPond](https://lilypond.org) 2.24 or newer
- [Claude Code](https://claude.com/claude-code), and it asks you to sign in once. Composing needs it; everything else works without it.
- The orchestra and band sounds (about 140 MB, into `sounds/`). Instruments not downloaded yet are fetched the first time a score uses them, and a synth stands in if there is no internet.

There is nothing to `npm install`. The server uses only what ships with Node.

## Run it

Double-click `start.command`, or run `node server.js --open`. On a new computer `start.command` runs the setup first if anything is missing.
The studio opens at http://localhost:4747 and the gallery at http://localhost:4747/gallery. If something is still missing, the studio says what and how to fix it.

To use a different port: `PORT=5000 node server.js`. To download more instrument sounds ahead of time: `node server.js --fetch-sounds all` (or `orchestra`, `band`).

If macOS says `setup.command` or `start.command` cannot be opened because it was downloaded from the internet, right-click it and choose Open.

## How it fits together

| File | What it is |
| --- | --- |
| `server.js` | Local server. Runs LilyPond, calls the `claude` command, stores pieces. |
| `public/index.html`, `app.js` | The studio. |
| `public/gallery.html`, `gallery.js` | The gallery and its player. |
| `public/audio.js` | Sound engine: sampled piano, sampled orchestra and band, synth voices, drum synth, effects, MIDI reader, score player. |
| `public/instruments.js` | The General MIDI instrument table shared by the server and the browser. |
| `setup.command`, `start.command` | Installer and launcher. |
| `sounds/` | Downloaded instrument sounds. Created by setup and never committed. |
| `public/samples/` | Grand piano recordings. |
| `pieces/` | Your saved music. Created on first run and never committed. |

## Safety

LilyKeys is made to run on your own machine, for you.

- The server listens on `127.0.0.1` only and refuses requests from other sites.
- LilyPond files can run code, so do not expose this server to a network or put it on the public internet.
- The only other thing the server downloads is instrument sounds, from `gleitz.github.io`, saved in `sounds/`.
- Claude is called through your own Claude Code sign-in, with its tools switched off. The text you send for composing goes to Anthropic like any other Claude request.

## Credits

- Music engraving by [LilyPond](https://lilypond.org).
- Grand piano: Salamander Grand Piano by Alexander Holm, [CC BY 3.0](https://creativecommons.org/licenses/by/3.0/). See `public/samples/README.md`.
- Orchestra and band instruments: FluidR3 GM soundfont by Frank Wen (MIT licence), as packaged by
  [midi-js-soundfonts](https://github.com/gleitz/midi-js-soundfonts).
- The synth voices and drums are synthesised in the browser.
