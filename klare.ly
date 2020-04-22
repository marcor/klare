\version "2.20.0"

blackNote =
#(ly:make-stencil 
    (list 'embedded-ps
     "gsave
      currentpoint translate
      newpath
      -.50 -0 .51 0 360 arc closepath
      fill
      grestore" )
    (cons -1.02 1.02)
    (cons -.51 .51)
)

whiteNote =
#(ly:make-stencil 
    (list 'embedded-ps
     "gsave
      currentpoint translate
      newpath
      0.05 setlinewidth
      .50 -0 .485 0 360 arc closepath
      gsave
        1 setgray fill
      grestore
      stroke
      grestore" )
    (cons -1.02 1.02)
    (cons -.51 .51)
)

blackLongNote =
#(ly:make-stencil 
    (list 'embedded-ps
     "gsave
      currentpoint translate
      newpath
      -.50 -0 .51 0 360 arc closepath
      fill
      newpath
      0.12 setlinewidth
      -.6 -0 .80 140 -140 arc
      .2 setgray stroke
      grestore" )
    (cons -1.22 1.22)
    (cons -.51 .51)
)

whiteLongNote =
#(ly:make-stencil 
    (list 'embedded-ps
     "gsave
      currentpoint translate
      newpath
      0.05 setlinewidth
      .50 -0 .485 0 360 arc closepath
      gsave
        1 setgray fill
      grestore
      stroke
      0.12 setlinewidth
      .6 0 .80 -40 40 arc
      .3 setgray stroke
      grestore" )
    (cons -1.22 1.22)
    (cons -.51 .51)
)


%Based on the pitch, and duration, which note head
#(define (pitch-to-stencil pitch dur)
   (if (= (remainder (ly:pitch-semitones pitch) 2) 0) 
      (if (< dur 2) 
          blackLongNote
	  blackNote)
      (if (< dur 2)
	  whiteLongNote
	  whiteNote)
   )
)

#(define (ps-stencil-notehead grob)
   (pitch-to-stencil 
      (ly:event-property (event-cause grob) 'pitch)
      (ly:grob-property grob 'duration-log)
   )
)

clefKlareTreble = {
  %\clef treble
  \set Staff.clefGlyph = #"clefs.G"
  \set Staff.middleCPosition = #-6
  \set Staff.clefPosition = #1
}

clefKlareBass = {
  %\clef "bass_13"
  \set Staff.clefGlyph = #"clefs.F"
  \set Staff.middleCPosition = #18
  \set Staff.clefPosition = #11
}

\layout {
  \context {
    \Staff
    \name KlareStaff
    \alias Staff
 
    staffLineLayoutFunction = #ly:pitch-semitones

    \override StaffSymbol.line-positions = #'( -6  -2    6  10 )
    \override StaffSymbol.ledger-positions = #'( -18 -14 -10 2 14 22 )
    \override StaffSymbol.ledger-extra = #1
    \override StaffSymbol.ledger-line-thickness = #'(.6 . 0)
 
    %\override Stem #'no-stem-extend = ##t
    \override Stem.thickness = #.5
    
    \override NoteHead #'stencil = #ps-stencil-notehead
    \override NoteHead #'stem-attachment = #'(0 . 0)
    \override NoteHead #'X-offset = #0
   
    \override SpacingSpanner.uniform-stretching = ##t
    \override Score.SpacingSpanner.strict-note-spacing = ##t
        
    \remove "Accidental_engraver"
    \remove "Key_engraver"
    %\remove "Clef_engraver"
    \clefKlareTreble
    %\remove "Time_signature_engraver"
    \override TimeSignature #'Y-offset = #3
    %\override NoteColumn.ignore-collision = ##t
  }
  \inherit-acceptability "KlareStaff" "Staff"
}


%% helpers for making a continuous note-space out of a PianoStaff
% http://lilypond.org/doc/v2.20/Documentation/notation/explicit-staff-and-system-positioning
stackStaves = {
  \overrideProperty Score.NonMusicalPaperColumn.line-break-system-details
      #'((alignment-distances . (12)))
}
% adds a C line on top of the standard staff
ExtendStaff = \with { 
    \override StaffSymbol #'line-positions = #'( -6  -2    6  10 18 )
    \override StaffSymbol #'ledger-positions = #'( -18 -14 -10 2 14 22 26 )
}
