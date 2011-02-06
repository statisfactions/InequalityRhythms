/* ----R Header: P-field list-----
inst, start, dur, amp, pan, freq
-----end header---- */


sr=44100
kr=4410
0dbfs=1
nchnls=2

    instr 1
  ipan      =  p5
  kenv      linen     p4, 0.01*p3, p3, 0.99*p3
  anoise    rand      kenv
  asig      reson     anoise, p6, 500
            outs      asig*ipan, asig*(1-ipan)
    endin
