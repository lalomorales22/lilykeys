# LilyKeys

A music studio that runs on your own computer: a playable piano, a LilyPond score editor,
a drum machine, and Claude as a composing partner.

Describe the music you want and Claude writes the score. LilyKeys engraves it as sheet music,
plays it back on the piano, and keeps everything you make in a gallery.

## What it does

- **Piano.** Five octaves, playable with the mouse, the computer keyboard or a MIDI keyboard.
  Ten sounds: a sampled grand piano plus electric piano, organ, strings, pad, bells, pluck, lead, bass and 8-bit.
- **Score.** Write LilyPond in the editor and engrave it to sheet music. Play it back, or download the PDF, MIDI or `.ly` file.
- **Compose with Claude.** Ask for a new piece or a change. Claude sees your current score and beat and returns a complete score that the app engraves.
- **Text into music.** Paste a transcript, course notes or an article, or attach a `.txt` / `.md` file. Claude turns the ideas and structure of the text into an instrumental piece or a song with lyrics.
- **Beat machine.** Eight drum tracks, up to 8 bars (128 steps), with accents, ghost notes, swing, three kits and starter grooves. It can play in time with the score.
- **Sound desk.** Rotary knobs for brightness, resonance, drive, chorus, echo and room on the keys, plus level, tone, crunch, tuning and per-drum levels on the drums.
- **Record a take.** Play something and it is written down as notation.
- **Gallery.** Every piece saves itself. The gallery page lists them with a player that shows a scrolling piano roll.

## What you need

- macOS (it is built and tested there; the start script is a `.command` file)
- [Node.js](https://nodejs.org) 18 or newer
- [LilyPond](https://lilypond.org) 2.24 or newer: `brew install lilypond`
- [Claude Code](https://claude.com/claude-code) installed and signed in, for the composing features. Everything else works without it.

There is nothing to `npm install`. The server uses only what ships with Node.

## Run it

```bash
git clone https://github.com/lalomorales22/lilykeys.git
cd lilykeys
node server.js --open
```

Or double-click `start.command`. The studio opens at http://localhost:4747 and the gallery at http://localhost:4747/gallery.

To use a different port: `PORT=5000 node server.js`.

## How it fits together

| File | What it is |
| --- | --- |
| `server.js` | Local server. Runs LilyPond, calls the `claude` command, stores pieces. |
| `public/index.html`, `app.js` | The studio. |
| `public/gallery.html`, `gallery.js` | The gallery and its player. |
| `public/audio.js` | Sound engine: sampled piano, synth voices, drum synth, effects, MIDI reader, score player. |
| `public/samples/` | Grand piano recordings. |
| `pieces/` | Your saved music. Created on first run and never committed. |

## Safety

LilyKeys is made to run on your own machine, for you.

- The server listens on `127.0.0.1` only and refuses requests from other sites.
- LilyPond files can run code, so do not expose this server to a network or put it on the public internet.
- Claude is called through your own Claude Code sign-in, with its tools switched off. The text you send for composing goes to Anthropic like any other Claude request.

## Credits

- Music engraving by [LilyPond](https://lilypond.org).
- Grand piano: Salamander Grand Piano by Alexander Holm, [CC BY 3.0](https://creativecommons.org/licenses/by/3.0/). See `public/samples/README.md`.
- All other instrument and drum sounds are synthesised in the browser.
