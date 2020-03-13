#!/bin/sed -Enf

# A script to play a musical melodies.
# Written by Circiter (mailto:xcirciter@gmail.com)
# Repository: github.com/Circiter/music-in-sed
# License: MIT.

# Input: composition (a sequence of notes).

:play
    # Lookup table.
    s/$/@A1111B1100C1010D1000E110F101G100a1101b1001d111f101g100 0/

    # Search for the note.
    s/^(.)(.*@).*\1([01]*)/\3|\2/
    s/@.*$//

    # Pattern space: frequency|composition_suffix.

    # N.B., zero frequency.
    /^0\|/ {s/^0\|//; s/$/\n--------/; bsilence}

    s/$/\n/
    :decrement
        :digit s/0(_*\|)/_\1/; tdigit
        s/1(_*\|)/0\1/
        s/_/1/g
        s/\n~*$/&~/
        s/^0([01])/\1/
        /^0\|/!bdecrement

    s/^0\|//

    s/\n[^\n]*$/&&/
    :dash_replace s/~(-*)$/-\1/; tdash_replace
    s/\n([^\n]*)$/\1/

    :silence

    # Pattern space: composition_suffix\nwaveform

    h
    # Remove the unecessary data from the hold space.
    x; s/^.*\n([^\n]*)$/\1/; y/-/\n/; x

    # Hold space: waveform.

    # Well, now we have one period of a square wave,
    # so play it enough times.
    s/$/\n1111111110/ # Reference duration (samples count) of a note.

    # Pattern space: composition_suffix\nwaveform\nreference_duration.

    s/^[^\n]*\n/&>/ # Add a marker just before the waveform.

    :one_period
        x; p; x # Output at least one period.

        :one_sample
            # Move the marker to the right,
            # one character at a time.
            s/>([^\n])/\1>/

            :d s/0(_*)$/_\1/; td
            s/1(_*)$/0\1/
            s/_/1/g
            s/\n0([01]+)$/\n\1/
            /\n0$/ bnext_note
            />\n/! bone_sample

        # Reinitialize the > marker.
        s/>//; s/^[^\n]*\n/&>/

        bone_period

    :next_note

    s/^([^\n]*)\n.*$/\1/ # Leave only the composition.

    /./ bplay # Play the next note.
