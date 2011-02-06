<CsoundSynthesizer>
<CsOptions>
</CsOptions>

<CsInstruments>
sr = 44100
kr = 4410
nchnls = 2
0dbfs = 1

/*
Setup of global variable for portamento effect
taken from The Csound Book, ch. 
"Using Global Csound Instruments for Meta-Parameter Control", instr 1802 and 1803
*/

  gkfr      init      0                           ; INIT FREQUENCY

    instr 1                                       ; CONTROLS INST 2 FREQ
  koct      linseg   p4, p3, p5
  gkfr      =        cpsoct(koct)
    endin

    instr 2                                       
  kenv      linen     1, 0.01, p3, 0.01
  a1        oscil     kenv, gkfr, 1
            outs       a1,0*a1
    endin

    instr 3                                        ; ONE CONTINUOUS TONE               
  koct      linseg    5, p3, 9
  kfr       =         cpsoct(koct)
  kenv      linen     1, 0.01, p3, 0.01
  a1        oscil     kenv, kfr, 1
            outs       0*a1,a1
    endin
</CsInstruments>

<CsScore>
f 1 0 4096  10    1
t       0       60                   

i 2 0  10
i 1 0 1 5 5.07164071640716
i 1 + . pp5 5.21276212762128
i 1 + . pp5 5.4020440204402
i 1 + . pp5 5.6389663896639
i 1 + . pp5 5.92588925889259
i 1 + . pp5 6.26569265692657
i 1 + . pp5 6.67057670576706
i 1 + . pp5 7.16338163381634
i 1 + . pp5 7.80322803228032
i 1 + . pp5 9

i 3 0  10

e

</CsScore>
</CsoundSynthesizer>
