ICU_Beds_reg=[
327 299 626 305
10 8 18 9
861 585 1446 704
69 86 155 75
494 211 705 343
120 55 175 85
180 43 223 109
449 192 641 312
374 162 536 261
70 57 127 62
115 105 220 107
571 274 845 412
123 66 189 92
30 14 44 21
335 499 834 406
304 275 579 282
49 32 81 39
146 134 280 136
418 301 719 350
134 102 236 115];

for i=1:20
    ICU_beds(i).number=ICU_Beds_reg(i,[1,3]);
    ICU_beds(i).data=[1,85];
end