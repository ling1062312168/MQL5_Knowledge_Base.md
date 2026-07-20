; WININET.dll unpacked .text full disasm (skipdata=1)
; size=56988 RVA=0x1000 base=0x180000000

0x00001000: 4883ec28                 sub      rsp, 0x28
0x00001004: 488d0df5760100           lea      rcx, [rip + 0x176f5]
0x0000100B: e808070000               call     0x180001718
0x00001010: 488d0d79de0000           lea      rcx, [rip + 0xde79]
0x00001017: 4883c428                 add      rsp, 0x28
0x0000101B: e9380c0000               jmp      0x180001c58
0x00001020: 4850                     push     rax
0x00001022: e831431d00               call     0x1801d5358
0x00001027: cc                       int3     
0x00001028: cc                       int3     
0x00001029: cc                       int3     
0x0000102A: cc                       int3     
0x0000102B: cc                       int3     
0x0000102C: cc                       int3     
0x0000102D: cc                       int3     
0x0000102E: cc                       int3     
0x0000102F: cc                       int3     
0x00001030: 4883ec38                 sub      rsp, 0x38
0x00001034: 488b05c55f0100           mov      rax, qword ptr [rip + 0x15fc5]
0x0000103B: 4833c4                   xor      rax, rsp
0x0000103E: 4889442428               mov      qword ptr [rsp + 0x28], rax
0x00001043: 4c8d442420               lea      r8, [rsp + 0x20]
0x00001048: 488d15e1ffffff           lea      rdx, [rip - 0x1f]
0x0000104F: b906000000               mov      ecx, 6
0x00001054: 56                       push     rsi
0x00001055: e8a7122000               call     0x180202301
0x0000105A: 85c0                     test     eax, eax
0x0000105C: 744a                     je       0x1800010a8
0x0000105E: 488b4c2420               mov      rcx, qword ptr [rsp + 0x20]
0x00001063: 488d15a68a0100           lea      rdx, [rip + 0x18aa6]
0x0000106A: 41b804010000             mov      r8d, 0x104
0x00001070: e84a9e2200               call     0x18022aebf
0x00001075: 55                       push     rbp
0x00001076: 488d0d938a0100           lea      rcx, [rip + 0x18a93]
0x0000107D: 55                       push     rbp
0x0000107E: e8cb550300               call     0x18003664e
0x00001083: 488b4c2420               mov      rcx, qword ptr [rsp + 0x20]
0x00001088: 488d15918c0100           lea      rdx, [rip + 0x18c91]
0x0000108F: 41b804010000             mov      r8d, 0x104
0x00001095: 57                       push     rdi
0x00001096: e8ef790b00               call     0x1800b8a8a
0x0000109B: 488d0d7e8c0100           lea      rcx, [rip + 0x18c7e]
0x000010A2: 50                       push     rax
0x000010A3: e845b01700               call     0x18017c0ed
0x000010A8: 488b4c2428               mov      rcx, qword ptr [rsp + 0x28]
0x000010AD: 4833cc                   xor      rcx, rsp
0x000010B0: e85b070000               call     0x180001810
0x000010B5: 4883c438                 add      rsp, 0x38
0x000010B9: c3                       ret      
0x000010BA: cc                       int3     
0x000010BB: cc                       int3     
0x000010BC: cc                       int3     
0x000010BD: cc                       int3     
0x000010BE: cc                       int3     
0x000010BF: cc                       int3     
0x000010C0: 4881ec08040000           sub      rsp, 0x408
0x000010C7: 448bd2                   mov      r10d, edx
0x000010CA: 4c8bd9                   mov      r11, rcx
0x000010CD: 4533c0                   xor      r8d, r8d
0x000010D0: 4c8d0c24                 lea      r9, [rsp]
0x000010D4: 418bc0                   mov      eax, r8d
0x000010D7: d1e8                     shr      eax, 1
0x000010D9: 41f6c001                 test     r8b, 1
0x000010DD: 7405                     je       0x1800010e4
0x000010DF: 352083b8ed               xor      eax, 0xedb88320
0x000010E4: a801                     test     al, 1
0x000010E6: 7409                     je       0x1800010f1
0x000010E8: d1e8                     shr      eax, 1
0x000010EA: 352083b8ed               xor      eax, 0xedb88320
0x000010EF: eb02                     jmp      0x1800010f3
0x000010F1: d1e8                     shr      eax, 1
0x000010F3: a801                     test     al, 1
0x000010F5: 7409                     je       0x180001100
0x000010F7: d1e8                     shr      eax, 1
0x000010F9: 352083b8ed               xor      eax, 0xedb88320
0x000010FE: eb02                     jmp      0x180001102
0x00001100: d1e8                     shr      eax, 1
0x00001102: a801                     test     al, 1
0x00001104: 7409                     je       0x18000110f
0x00001106: d1e8                     shr      eax, 1
0x00001108: 352083b8ed               xor      eax, 0xedb88320
0x0000110D: eb02                     jmp      0x180001111
0x0000110F: d1e8                     shr      eax, 1
0x00001111: a801                     test     al, 1
0x00001113: 7409                     je       0x18000111e
0x00001115: d1e8                     shr      eax, 1
0x00001117: 352083b8ed               xor      eax, 0xedb88320
0x0000111C: eb02                     jmp      0x180001120
0x0000111E: d1e8                     shr      eax, 1
0x00001120: a801                     test     al, 1
0x00001122: 7409                     je       0x18000112d
0x00001124: d1e8                     shr      eax, 1
0x00001126: 352083b8ed               xor      eax, 0xedb88320
0x0000112B: eb02                     jmp      0x18000112f
0x0000112D: d1e8                     shr      eax, 1
0x0000112F: a801                     test     al, 1
0x00001131: 7409                     je       0x18000113c
0x00001133: d1e8                     shr      eax, 1
0x00001135: 352083b8ed               xor      eax, 0xedb88320
0x0000113A: eb02                     jmp      0x18000113e
0x0000113C: d1e8                     shr      eax, 1
0x0000113E: a801                     test     al, 1
0x00001140: 7409                     je       0x18000114b
0x00001142: d1e8                     shr      eax, 1
0x00001144: 352083b8ed               xor      eax, 0xedb88320
0x00001149: eb02                     jmp      0x18000114d
0x0000114B: d1e8                     shr      eax, 1
0x0000114D: 41ffc0                   inc      r8d
0x00001150: 418901                   mov      dword ptr [r9], eax
0x00001153: 4983c104                 add      r9, 4
0x00001157: 4181f800010000           cmp      r8d, 0x100
0x0000115E: 0f8c70ffffff             jl       0x1800010d4
0x00001164: 83caff                   or       edx, 0xffffffff
0x00001167: 4585d2                   test     r10d, r10d
0x0000116A: 7423                     je       0x18000118f
0x0000116C: 0f1f4000                 nop      dword ptr [rax]
0x00001170: 410fb60b                 movzx    ecx, byte ptr [r11]
0x00001174: 8bc2                     mov      eax, edx
0x00001176: 4d8d5b01                 lea      r11, [r11 + 1]
0x0000117A: 4833c8                   xor      rcx, rax
0x0000117D: 0fb6c1                   movzx    eax, cl
0x00001180: 8bca                     mov      ecx, edx
0x00001182: 8b1484                   mov      edx, dword ptr [rsp + rax*4]
0x00001185: c1e908                   shr      ecx, 8
0x00001188: 33d1                     xor      edx, ecx
0x0000118A: 41ffca                   dec      r10d
0x0000118D: 75e1                     jne      0x180001170
0x0000118F: f7d2                     not      edx
0x00001191: 8bc2                     mov      eax, edx
0x00001193: 4881c408040000           add      rsp, 0x408
0x0000119A: c3                       ret      
0x0000119B: cc                       int3     
0x0000119C: cc                       int3     
0x0000119D: cc                       int3     
0x0000119E: cc                       int3     
0x0000119F: cc                       int3     

; ========== EXPORT check_ex4 @ 0x11A0 ==========
0x000011A0: 68052c3440               push     0x40342c05
0x000011A5: 4154                     push     r12
0x000011A7: e82b1c1400               call     0x180142dd7
0x000011AC: 9d                       popfq    
0x000011AD: 0fb6d2                   movzx    edx, dl
0x000011B0: 4b8d9476140fa20f         lea      rdx, [r14 + r14*2 + 0xfa20f14]
0x000011B8: 4c8b742400               mov      r14, qword ptr [rsp]
0x000011BD: 488d14d52e20ef38         lea      rdx, [rdx*8 + 0x38ef202e]
0x000011C5: e822882100               call     0x1802199ec
0x000011CA: a5                       movsd    dword ptr [rdi], dword ptr [rsi]
0x000011CB: fe                       .byte    0xfe
0x000011CC: 93                       xchg     ebx, eax
0x000011CD: 21fe                     and      esi, edi
0x000011CF: 7f00                     jg       0x1800011d1
0x000011D1: 00488d                   add      byte ptr [rax - 0x73], cl
0x000011D4: ad                       lodsd    eax, dword ptr [rsi]
0x000011D5: e150                     loope    0x180001227
0x000011D7: 126141                   adc      ah, byte ptr [rcx + 0x41]
0x000011DA: 56                       push     rsi
0x000011DB: 66f7d3                   not      bx
0x000011DE: 4881442420ff65ea66       add      qword ptr [rsp + 0x20], 0x66ea65ff
0x000011E7: 035c241b                 add      ebx, dword ptr [rsp + 0x1b]
0x000011EB: 0fbedb                   movsx    ebx, bl
0x000011EE: 66215c2418               and      word ptr [rsp + 0x18], bx
0x000011F3: 48814424101340de7f       add      qword ptr [rsp + 0x10], 0x7fde4013
0x000011FC: 4154                     push     r12
0x000011FE: 488d1c9d443fee4a         lea      rbx, [rbx*4 + 0x4aee3f44]
0x00001206: 4887ac1c74c011b5         xchg     qword ptr [rsp + rbx - 0x4aee3f8c], rbp
0x0000120E: f7db                     neg      ebx
0x00001210: 49be3112fa510841471d     movabs   r14, 0x1d47410851fa1231
0x0000121A: 410f9cc6                 setl     r14b
0x0000121E: f6542428                 not      byte ptr [rsp + 0x28]
0x00001222: 51                       push     rcx
0x00001223: 488b4c2428               mov      rcx, qword ptr [rsp + 0x28]
0x00001228: e89b271500               call     0x1801539c8
0x0000122D: 488dad267d645b           lea      rbp, [rbp + 0x5b647d26]
0x00001234: e8b06d1800               call     0x180187fe9
0x00001239: 4889742430               mov      qword ptr [rsp + 0x30], rsi
0x0000123E: 3bde                     cmp      ebx, esi
0x00001240: 488dbc5fe816d2fc         lea      rdi, [rdi + rbx*2 - 0x32de918]
0x00001248: 48f7542430               not      qword ptr [rsp + 0x30]
0x0000124D: 66f7d6                   not      si
0x00001250: 52                       push     rdx
0x00001251: 660f475c2439             cmova    bx, word ptr [rsp + 0x39]
0x00001257: e897a32000               call     0x18020b5f3
0x0000125C: e86a7f1700               call     0x1801791cb
0x00001261: 48816c24604c468052       sub      qword ptr [rsp + 0x60], 0x5280464c
0x0000126A: ff742470                 push     qword ptr [rsp + 0x70]
0x0000126E: 9d                       popfq    
0x0000126F: 488da42480000000         lea      rsp, [rsp + 0x80]
0x00001277: c3                       ret      
0x00001278: 488d642410               lea      rsp, [rsp + 0x10]
0x0000127D: e85ebe3a00               call     0x1803ad0e0
0x00001282: 66097c2448               or       word ptr [rsp + 0x48], di
0x00001287: 4c397c2448               cmp      qword ptr [rsp + 0x48], r15
0x0000128C: 488b7c2440               mov      rdi, qword ptr [rsp + 0x40]
0x00001291: 0f873a941600             ja       0x18016a6d1
0x00001297: 0f8455fe0100             je       0x1800210f2
0x0000129D: 488bd1                   mov      rdx, rcx
0x000012A0: 408acf                   mov      cl, dil
0x000012A3: 66410fbec9               movsx    cx, r9b
0x000012A8: 498bc8                   mov      rcx, r8
0x000012AB: e9f7ed1000               jmp      0x1801100a7
0x000012B0: 5a                       pop      rdx
0x000012B1: 4152                     push     r10
0x000012B3: 9c                       pushfq   
0x000012B4: 49ba524f2e54e6796a61     movabs   r10, 0x616a79e6542e4f52
0x000012BE: 41f7d2                   not      r10d
0x000012C1: 49f7da                   neg      r10
0x000012C4: 4181fae70aeb2d           cmp      r10d, 0x2deb0ae7
0x000012CB: e8b39f1c00               call     0x1801cb283
0x000012D0: 488d642410               lea      rsp, [rsp + 0x10]
0x000012D5: c3                       ret      
0x000012D6: 0f9c442428               setl     byte ptr [rsp + 0x28]
0x000012DB: 4881442430f88be9ff       add      qword ptr [rsp + 0x30], -0x167408
0x000012E4: e822141300               call     0x18013270b
0x000012E9: e8e8d12200               call     0x18022e4d6
0x000012EE: 9c                       pushfq   
0x000012EF: 81ffe854de6f             cmp      edi, 0x6fde54e8
0x000012F5: e82ced1a00               call     0x1801b0026
0x000012FA: e891080300               call     0x180031b90
0x000012FF: 448b4c2451               mov      r9d, dword ptr [rsp + 0x51]
0x00001304: 4c8b5c2468               mov      r11, qword ptr [rsp + 0x68]
0x00001309: 480fca                   bswap    rdx
0x0000130C: e88f890200               call     0x180029ca0
0x00001311: ae                       scasb    al, byte ptr [rdi]
0x00001312: b6c8                     mov      dh, 0xc8
0x00001314: 6b627429                 imul     esp, dword ptr [rdx + 0x74], 0x29
0x00001318: 198592d40fcb             sbb      dword ptr [rbp - 0x34f02b6e], eax
0x0000131E: 31ed                     xor      ebp, ebp
0x00001320: 4c53                     push     rbx
0x00001322: 04c4                     add      al, 0xc4
0x00001324: e8fafc0100               call     0x180021023
0x00001329: 81fe7b34f623             cmp      esi, 0x23f6347b
0x0000132F: 66f7d5                   not      bp
0x00001332: 488dacaeac006325         lea      rbp, [rsi + rbp*4 + 0x256300ac]
0x0000133A: e875fc1000               call     0x180110fb4
0x0000133F: 5b                       pop      rbx
0x00001340: 4157                     push     r15
0x00001342: 9c                       pushfq   
0x00001343: 49bfdd24e4180b134e75     movabs   r15, 0x754e130b18e424dd
0x0000134D: 4d03ff                   add      r15, r15
0x00001350: 49f7d7                   not      r15
0x00001353: 48875c2410               xchg     qword ptr [rsp + 0x10], rbx
0x00001358: e841171a00               call     0x1801a2a9e
0x0000135D: e81e6b1800               call     0x180187e80
0x00001362: 44387c2458               cmp      byte ptr [rsp + 0x58], r15b
0x00001367: 410fc8                   bswap    r8d
0x0000136A: e863191a00               call     0x1801a2cd2
0x0000136F: c3                       ret      
0x00001370: 0100                     add      dword ptr [rax], eax
0x00001372: 0000                     add      byte ptr [rax], al
0x00001374: e85da40d00               call     0x1800db7d6
0x00001379: bb3626c522               mov      ebx, 0x22c52636
0x0000137E: f6d3                     not      bl
0x00001380: 490fbed9                 movsx    rbx, r9b
0x00001384: 488b5c2408               mov      rbx, qword ptr [rsp + 8]
0x00001389: 488b1b                   mov      rbx, qword ptr [rbx]
0x0000138C: 4c894c2408               mov      qword ptr [rsp + 8], r9
0x00001391: e8c42b1600               call     0x180163f5a
0x00001396: c3                       ret      
0x00001397: cc                       int3     
0x00001398: cc                       int3     
0x00001399: cc                       int3     
0x0000139A: cc                       int3     
0x0000139B: cc                       int3     
0x0000139C: cc                       int3     
0x0000139D: cc                       int3     
0x0000139E: cc                       int3     
0x0000139F: cc                       int3     

; ========== EXPORT GetAccount @ 0x13A0 ==========
0x000013A0: b001                     mov      al, 1
0x000013A2: c3                       ret      
0x000013A3: cc                       int3     
0x000013A4: cc                       int3     
0x000013A5: cc                       int3     
0x000013A6: cc                       int3     
0x000013A7: cc                       int3     
0x000013A8: cc                       int3     
0x000013A9: cc                       int3     
0x000013AA: cc                       int3     
0x000013AB: cc                       int3     
0x000013AC: cc                       int3     
0x000013AD: cc                       int3     
0x000013AE: cc                       int3     
0x000013AF: cc                       int3     

; ========== EXPORT Http* @ 0x13B0 ==========
0x000013B0: b801000000               mov      eax, 1
0x000013B5: c3                       ret      
0x000013B6: cc                       int3     
0x000013B7: cc                       int3     
0x000013B8: cc                       int3     
0x000013B9: cc                       int3     
0x000013BA: cc                       int3     
0x000013BB: cc                       int3     
0x000013BC: cc                       int3     
0x000013BD: cc                       int3     
0x000013BE: cc                       int3     
0x000013BF: cc                       int3     
0x000013C0: e825340b00               call     0x1800b47ea
0x000013C5: e89c2d1a00               call     0x1801a4166
0x000013CA: 0f88b4680300             js       0x180037c84
0x000013D0: e8fd891600               call     0x180169dd2
0x000013D5: e8dc9a2200               call     0x18022aeb6
0x000013DA: 66036c243a               add      bp, word ptr [rsp + 0x3a]
0x000013DF: 4c8b442458               mov      r8, qword ptr [rsp + 0x58]
0x000013E4: e8ce380200               call     0x180024cb7
0x000013E9: 9c                       pushfq   
0x000013EA: 49b9144a675c1367c30b     movabs   r9, 0xbc367135c674a14
0x000013F4: 49b86b372b7340784944     movabs   r8, 0x44497840732b376b
0x000013FE: 4981e95e09aa7e           sub      r9, 0x7eaa095e
0x00001405: 41f6c0f7                 test     r8b, 0xf7
0x00001409: 4f8d8cc9f04d5e19         lea      r9, [r9 + r9*8 + 0x195e4df0]
0x00001411: 4c8b4c2418               mov      r9, qword ptr [rsp + 0x18]
0x00001416: 48c74424182c81a80f       mov      qword ptr [rsp + 0x18], 0xfa8812c
0x0000141F: e8be890200               call     0x180029de2
0x00001424: e8feac1700               call     0x18017c127
0x00001429: 4981c287605510           add      r10, 0x10556087
0x00001430: 4887542460               xchg     qword ptr [rsp + 0x60], rdx
0x00001435: 664533ca                 xor      r9w, r10w
0x00001439: 4181ea203b4f3b           sub      r10d, 0x3b4f3b20
0x00001440: 4181f9c26ff83b           cmp      r9d, 0x3bf86fc2
0x00001447: 4c89542438               mov      qword ptr [rsp + 0x38], r10
0x0000144C: 0f8352e10100             jae      0x18001f5a4
0x00001452: 9c                       pushfq   
0x00001453: 4881442408b4701a00       add      qword ptr [rsp + 8], 0x1a70b4
0x0000145C: ff742400                 push     qword ptr [rsp]
0x00001460: 9d                       popfq    
0x00001461: 488d642408               lea      rsp, [rsp + 8]
0x00001466: c3                       ret      
0x00001467: 4d33c9                   xor      r9, r9
0x0000146A: e899781e00               call     0x1801e8d08
0x0000146F: e827380200               call     0x180024c9b
0x00001474: 0f875fb51700             ja       0x18017c9d9
0x0000147A: cc                       int3     
0x0000147B: cc                       int3     
0x0000147C: cc                       int3     
0x0000147D: cc                       int3     
0x0000147E: cc                       int3     
0x0000147F: cc                       int3     

; ========== EXPORT InternetOpenUrlW @ 0x1480 ==========
0x00001480: b864000000               mov      eax, 0x64
0x00001485: c3                       ret      
0x00001486: cc                       int3     
0x00001487: cc                       int3     
0x00001488: cc                       int3     
0x00001489: cc                       int3     
0x0000148A: cc                       int3     
0x0000148B: cc                       int3     
0x0000148C: cc                       int3     
0x0000148D: cc                       int3     
0x0000148E: cc                       int3     
0x0000148F: cc                       int3     

; ========== EXPORT ex4 @ 0x1490 ==========
0x00001490: 8b0582880100             mov      eax, dword ptr [rip + 0x18882]
0x00001496: c3                       ret      
0x00001497: cc                       int3     
0x00001498: cc                       int3     
0x00001499: cc                       int3     
0x0000149A: cc                       int3     
0x0000149B: cc                       int3     
0x0000149C: cc                       int3     
0x0000149D: cc                       int3     
0x0000149E: cc                       int3     
0x0000149F: cc                       int3     

; ========== EXPORT GetStrategy @ 0x14A0 ==========
0x000014A0: 33c0                     xor      eax, eax
0x000014A2: c3                       ret      
0x000014A3: cc                       int3     
0x000014A4: cc                       int3     
0x000014A5: cc                       int3     
0x000014A6: cc                       int3     
0x000014A7: cc                       int3     
0x000014A8: cc                       int3     
0x000014A9: cc                       int3     
0x000014AA: cc                       int3     
0x000014AB: cc                       int3     
0x000014AC: cc                       int3     
0x000014AD: cc                       int3     
0x000014AE: cc                       int3     
0x000014AF: cc                       int3     

; ========== EXPORT CalculateMax @ 0x14B0 ==========
0x000014B0: 4883ec68                 sub      rsp, 0x68
0x000014B4: 0f29742450               movaps   xmmword ptr [rsp + 0x50], xmm6
0x000014B9: 0f297c2440               movaps   xmmword ptr [rsp + 0x40], xmm7
0x000014BE: 440f29442430             movaps   xmmword ptr [rsp + 0x30], xmm8
0x000014C4: 0f28f2                   movaps   xmm6, xmm2
0x000014C7: 0f28f9                   movaps   xmm7, xmm1
0x000014CA: 440f28c0                 movaps   xmm8, xmm0
0x000014CE: 440f294c2420             movaps   xmmword ptr [rsp + 0x20], xmm9
0x000014D4: 440f28cb                 movaps   xmm9, xmm3
0x000014D8: e8c3fcffff               call     0x1800011a0
0x000014DD: f2440f590d02390100       mulsd    xmm9, qword ptr [rip + 0x13902]
0x000014E6: f2440f5cc6               subsd    xmm8, xmm6
0x000014EB: f20f5cfe                 subsd    xmm7, xmm6
0x000014EF: 0f28742450               movaps   xmm6, xmmword ptr [rsp + 0x50]
0x000014F4: f2440f5ec7               divsd    xmm8, xmm7
0x000014F9: 0f287c2440               movaps   xmm7, xmmword ptr [rsp + 0x40]
0x000014FE: f2440f5c05d1380100       subsd    xmm8, qword ptr [rip + 0x138d1]
0x00001507: f2440f5905d0380100       mulsd    xmm8, qword ptr [rip + 0x138d0]
0x00001510: f2450f58c1               addsd    xmm8, xmm9
0x00001515: 440f284c2420             movaps   xmm9, xmmword ptr [rsp + 0x20]
0x0000151B: 410f28c0                 movaps   xmm0, xmm8
0x0000151F: 440f28442430             movaps   xmm8, xmmword ptr [rsp + 0x30]
0x00001525: 4883c468                 add      rsp, 0x68
0x00001529: c3                       ret      
0x0000152A: cc                       int3     
0x0000152B: cc                       int3     
0x0000152C: cc                       int3     
0x0000152D: cc                       int3     
0x0000152E: cc                       int3     
0x0000152F: cc                       int3     

; ========== EXPORT GetExpirationTime @ 0x1530 ==========
0x00001530: b80077bd7f               mov      eax, 0x7fbd7700
0x00001535: c3                       ret      
0x00001536: cc                       int3     
0x00001537: cc                       int3     
0x00001538: cc                       int3     
0x00001539: cc                       int3     
0x0000153A: cc                       int3     
0x0000153B: cc                       int3     
0x0000153C: cc                       int3     
0x0000153D: cc                       int3     
0x0000153E: cc                       int3     
0x0000153F: cc                       int3     

; ========== EXPORT GetAuth @ 0x1540 ==========
0x00001540: 4883ec28                 sub      rsp, 0x28
0x00001544: e857fcffff               call     0x1800011a0
0x00001549: b001                     mov      al, 1
0x0000154B: 4883c428                 add      rsp, 0x28
0x0000154F: c3                       ret      

; ========== EXPORT ProfitPoint @ 0x1550 ==========
0x00001550: 48895c2408               mov      qword ptr [rsp + 8], rbx
0x00001555: 48896c2410               mov      qword ptr [rsp + 0x10], rbp
0x0000155A: 4889742418               mov      qword ptr [rsp + 0x18], rsi
0x0000155F: 57                       push     rdi
0x00001560: 4883ec20                 sub      rsp, 0x20
0x00001564: 418be9                   mov      ebp, r9d
0x00001567: 418bf0                   mov      esi, r8d
0x0000156A: 8bfa                     mov      edi, edx
0x0000156C: 0fb6d9                   movzx    ebx, cl
0x0000156F: e82cfcffff               call     0x1800011a0
0x00001574: 84db                     test     bl, bl
0x00001576: 741b                     je       0x180001593
0x00001578: 85ff                     test     edi, edi
0x0000157A: 7438                     je       0x1800015b4
0x0000157C: 3bf7                     cmp      esi, edi
0x0000157E: 7e34                     jle      0x1800015b4
0x00001580: 2bfe                     sub      edi, esi
0x00001582: b964000000               mov      ecx, 0x64
0x00001587: 6bc732                   imul     eax, edi, 0x32
0x0000158A: 03c5                     add      eax, ebp
0x0000158C: 3bc1                     cmp      eax, ecx
0x0000158E: 0f4cc1                   cmovl    eax, ecx
0x00001591: eb23                     jmp      0x1800015b6
0x00001593: 85ff                     test     edi, edi
0x00001595: 741d                     je       0x1800015b4
0x00001597: 3bf7                     cmp      esi, edi
0x00001599: 7e19                     jle      0x1800015b4
0x0000159B: b90a000000               mov      ecx, 0xa
0x000015A0: 8bc7                     mov      eax, edi
0x000015A2: 2bc6                     sub      eax, esi
0x000015A4: c1e002                   shl      eax, 2
0x000015A7: 2bc6                     sub      eax, esi
0x000015A9: 03c7                     add      eax, edi
0x000015AB: 03c5                     add      eax, ebp
0x000015AD: 3bc1                     cmp      eax, ecx
0x000015AF: 0f4cc1                   cmovl    eax, ecx
0x000015B2: eb02                     jmp      0x1800015b6
0x000015B4: 8bc5                     mov      eax, ebp
0x000015B6: 488b5c2430               mov      rbx, qword ptr [rsp + 0x30]
0x000015BB: 488b6c2438               mov      rbp, qword ptr [rsp + 0x38]
0x000015C0: 488b742440               mov      rsi, qword ptr [rsp + 0x40]
0x000015C5: 4883c420                 add      rsp, 0x20
0x000015C9: 5f                       pop      rdi
0x000015CA: c3                       ret      
0x000015CB: cc                       int3     
0x000015CC: cc                       int3     
0x000015CD: cc                       int3     
0x000015CE: cc                       int3     
0x000015CF: cc                       int3     

; ========== EXPORT OrdersCheck @ 0x15D0 ==========
0x000015D0: 0f57c0                   xorps    xmm0, xmm0
0x000015D3: 660f2fc1                 comisd   xmm0, xmm1
0x000015D7: 0f87ff000000             ja       0x1800016dc
0x000015DD: f20f101513380100         movsd    xmm2, qword ptr [rip + 0x13813]
0x000015E5: 84c9                     test     cl, cl
0x000015E7: 7429                     je       0x180001612
0x000015E9: 660f2ec8                 ucomisd  xmm1, xmm0
0x000015ED: 7a0e                     jp       0x1800015fd
0x000015EF: 750c                     jne      0x1800015fd
0x000015F1: b8581b0000               mov      eax, 0x1b58
0x000015F6: ba64000000               mov      edx, 0x64
0x000015FB: eb40                     jmp      0x18000163d
0x000015FD: 0f28c1                   movaps   xmm0, xmm1
0x00001600: f20f590d08380100         mulsd    xmm1, qword ptr [rip + 0x13808]
0x00001608: f20f5905f0370100         mulsd    xmm0, qword ptr [rip + 0x137f0]
0x00001610: eb23                     jmp      0x180001635
0x00001612: 660f2ec8                 ucomisd  xmm1, xmm0
0x00001616: 7a0e                     jp       0x180001626
0x00001618: 750c                     jne      0x180001626
0x0000161A: b8bc020000               mov      eax, 0x2bc
0x0000161F: ba0a000000               mov      edx, 0xa
0x00001624: eb17                     jmp      0x18000163d
0x00001626: 0f28c1                   movaps   xmm0, xmm1
0x00001629: f20f590dd7370100         mulsd    xmm1, qword ptr [rip + 0x137d7]
0x00001631: f20f59c2                 mulsd    xmm0, xmm2
0x00001635: f20f2cc1                 cvttsd2si eax, xmm1
0x00001639: f20f2cd0                 cvttsd2si edx, xmm0
0x0000163D: 660f6ec8                 movd     xmm1, eax
0x00001641: 418d41f9                 lea      eax, [r9 - 7]
0x00001645: f30fe6c9                 cvtdq2pd xmm1, xmm1
0x00001649: 83f805                   cmp      eax, 5
0x0000164C: 7735                     ja       0x180001683
0x0000164E: 4c8d15abe9ffff           lea      r10, [rip - 0x1655]
0x00001655: 4898                     cdqe     
0x00001657: 418b8c82e0160000         mov      ecx, dword ptr [r10 + rax*4 + 0x16e0]
0x0000165F: 4903ca                   add      rcx, r10
0x00001662: ffe1                     jmp      rcx
0x00001664: f20f5eca                 divsd    xmm1, xmm2
0x00001668: 0f28c1                   movaps   xmm0, xmm1
0x0000166B: eb33                     jmp      0x1800016a0
0x0000166D: 0f28c1                   movaps   xmm0, xmm1
0x00001670: f20f5ec2                 divsd    xmm0, xmm2
0x00001674: eb2a                     jmp      0x1800016a0
0x00001676: 0f28c1                   movaps   xmm0, xmm1
0x00001679: f20f5e056f370100         divsd    xmm0, qword ptr [rip + 0x1376f]
0x00001681: eb1d                     jmp      0x1800016a0
0x00001683: 410fafd1                 imul     edx, r9d
0x00001687: 660f6ec2                 movd     xmm0, edx
0x0000168B: f30fe6c0                 cvtdq2pd xmm0, xmm0
0x0000168F: 4183f90d                 cmp      r9d, 0xd
0x00001693: 750b                     jne      0x1800016a0
0x00001695: 0f28c1                   movaps   xmm0, xmm1
0x00001698: f20f590530370100         mulsd    xmm0, qword ptr [rip + 0x13730]
0x000016A0: 4183f801                 cmp      r8d, 1
0x000016A4: 750e                     jne      0x1800016b4
0x000016A6: f20f104c2430             movsd    xmm1, qword ptr [rsp + 0x30]
0x000016AC: f20f5c4c2438             subsd    xmm1, qword ptr [rsp + 0x38]
0x000016B2: eb12                     jmp      0x1800016c6
0x000016B4: 4183f802                 cmp      r8d, 2
0x000016B8: 7522                     jne      0x1800016dc
0x000016BA: f20f104c2438             movsd    xmm1, qword ptr [rsp + 0x38]
0x000016C0: f20f5c4c2430             subsd    xmm1, qword ptr [rsp + 0x30]
0x000016C6: f20f59442440             mulsd    xmm0, qword ptr [rsp + 0x40]
0x000016CC: 660f2fc1                 comisd   xmm0, xmm1
0x000016D0: 730a                     jae      0x1800016dc
0x000016D2: 443b4c2428               cmp      r9d, dword ptr [rsp + 0x28]
0x000016D7: 7d03                     jge      0x1800016dc
0x000016D9: b001                     mov      al, 1
0x000016DB: c3                       ret      
0x000016DC: 32c0                     xor      al, al
0x000016DE: c3                       ret      
0x000016DF: 90                       nop      
0x000016E0: 64                       .byte    0x64
0x000016E1: 16                       .byte    0x16
0x000016E2: 0000                     add      byte ptr [rax], al
0x000016E4: 6d                       insd     dword ptr [rdi], dx
0x000016E5: 16                       .byte    0x16
0x000016E6: 0000                     add      byte ptr [rax], al
0x000016E8: 6d                       insd     dword ptr [rdi], dx
0x000016E9: 16                       .byte    0x16
0x000016EA: 0000                     add      byte ptr [rax], al
0x000016EC: 6d                       insd     dword ptr [rdi], dx
0x000016ED: 16                       .byte    0x16
0x000016EE: 0000                     add      byte ptr [rax], al
0x000016F0: 7616                     jbe      0x180001708
0x000016F2: 0000                     add      byte ptr [rax], al
0x000016F4: 7616                     jbe      0x18000170c
0x000016F6: 0000                     add      byte ptr [rax], al
0x000016F8: cc                       int3     
0x000016F9: cc                       int3     
0x000016FA: cc                       int3     
0x000016FB: cc                       int3     
0x000016FC: cc                       int3     
0x000016FD: cc                       int3     
0x000016FE: cc                       int3     
0x000016FF: cc                       int3     

; ========== EXPORT InternetClose* @ 0x1700 ==========
0x00001700: b86f000000               mov      eax, 0x6f
0x00001705: c3                       ret      
0x00001706: cc                       int3     
0x00001707: cc                       int3     
0x00001708: cc                       int3     
0x00001709: cc                       int3     
0x0000170A: cc                       int3     
0x0000170B: cc                       int3     
0x0000170C: cc                       int3     
0x0000170D: cc                       int3     
0x0000170E: cc                       int3     
0x0000170F: cc                       int3     

; ========== EXPORT InternetOpenW @ 0x1710 ==========
0x00001710: b80b000000               mov      eax, 0xb
0x00001715: c3                       ret      
0x00001716: cc                       int3     
0x00001717: cc                       int3     
0x00001718: 48895c2408               mov      qword ptr [rsp + 8], rbx
0x0000171D: 57                       push     rdi
0x0000171E: 4883ec20                 sub      rsp, 0x20
0x00001722: 33d2                     xor      edx, edx
0x00001724: 488bf9                   mov      rdi, rcx
0x00001727: 448d4228                 lea      r8d, [rdx + 0x28]
0x0000172B: 4903c8                   add      rcx, r8
0x0000172E: e89d0b0000               call     0x1800022d0
0x00001733: 4883675000               and      qword ptr [rdi + 0x50], 0
0x00001738: 83675800                 and      dword ptr [rdi + 0x58], 0
0x0000173C: 83675c00                 and      dword ptr [rdi + 0x5c], 0
0x00001740: 488d05b9e8ffff           lea      rax, [rip - 0x1747]
0x00001747: 488d4f28                 lea      rcx, [rdi + 0x28]
0x0000174B: 48894710                 mov      qword ptr [rdi + 0x10], rax
0x0000174F: 48894708                 mov      qword ptr [rdi + 8], rax
0x00001753: 488d05dedb0000           lea      rax, [rip + 0xdbde]
0x0000175A: 4533c0                   xor      r8d, r8d
0x0000175D: 33d2                     xor      edx, edx
0x0000175F: c70760000000             mov      dword ptr [rdi], 0x60
0x00001765: 48894720                 mov      qword ptr [rdi + 0x20], rax
0x00001769: c74718000c0000           mov      dword ptr [rdi + 0x18], 0xc00
0x00001770: e8abf8ffff               call     0x180001020
0x00001775: 85c0                     test     eax, eax
0x00001777: 7536                     jne      0x1800017af
0x00001779: e802680300               call     0x180037f80
0x0000177E: c3                       ret      
0x0000177F: 0fb7c8                   movzx    ecx, ax
0x00001782: 81c900000780             or       ecx, 0x80070000
0x00001788: 85c0                     test     eax, eax
0x0000178A: 0f4ec8                   cmovle   ecx, eax
0x0000178D: 85c9                     test     ecx, ecx
0x0000178F: 791e                     jns      0x1800017af
0x00001791: 51                       push     rcx
0x00001792: e8c3c50200               call     0x18002dd5a
0x00001797: 85c0                     test     eax, eax
0x00001799: 740d                     je       0x1800017a8
0x0000179B: 488d0daedb0000           lea      rcx, [rip + 0xdbae]
0x000017A2: 50                       push     rax
0x000017A3: e8a82b0200               call     0x180024350
0x000017A8: c60581ae010001           mov      byte ptr [rip + 0x1ae81], 1
0x000017AF: 488bc7                   mov      rax, rdi
0x000017B2: 488b5c2430               mov      rbx, qword ptr [rsp + 0x30]
0x000017B7: 4883c420                 add      rsp, 0x20
0x000017BB: 5f                       pop      rdi
0x000017BC: c3                       ret      
0x000017BD: cc                       int3     
0x000017BE: cc                       int3     
0x000017BF: cc                       int3     
0x000017C0: 4053                     push     rbx
0x000017C2: 4883ec20                 sub      rsp, 0x20
0x000017C6: 488bd9                   mov      rbx, rcx
0x000017C9: 4883c128                 add      rcx, 0x28
0x000017CD: 52                       push     rdx
0x000017CE: e80b031100               call     0x180111ade
0x000017D3: 488b4b50                 mov      rcx, qword ptr [rbx + 0x50]
0x000017D7: 4885c9                   test     rcx, rcx
0x000017DA: 740a                     je       0x1800017e6
0x000017DC: e84f000000               call     0x180001830
0x000017E1: 4883635000               and      qword ptr [rbx + 0x50], 0
0x000017E6: 83635800                 and      dword ptr [rbx + 0x58], 0
0x000017EA: 83635c00                 and      dword ptr [rbx + 0x5c], 0
0x000017EE: 4883c420                 add      rsp, 0x20
0x000017F2: 5b                       pop      rbx
0x000017F3: c3                       ret      
0x000017F4: e937000000               jmp      0x180001830
0x000017F9: cc                       int3     
0x000017FA: cc                       int3     
0x000017FB: cc                       int3     
0x000017FC: cc                       int3     
0x000017FD: cc                       int3     
0x000017FE: cc                       int3     
0x000017FF: cc                       int3     
0x00001800: cc                       int3     
0x00001801: cc                       int3     
0x00001802: cc                       int3     
0x00001803: cc                       int3     
0x00001804: cc                       int3     
0x00001805: cc                       int3     
0x00001806: 66660f1f840000000000     nop      word ptr [rax + rax]
0x00001810: 483b0de9570100           cmp      rcx, qword ptr [rip + 0x157e9]
0x00001817: 7511                     jne      0x18000182a
0x00001819: 48c1c110                 rol      rcx, 0x10
0x0000181D: 66f7c1ffff               test     cx, 0xffff
0x00001822: 7502                     jne      0x180001826
0x00001824: f3c3                     repz ret 
0x00001826: 48c1c910                 ror      rcx, 0x10
0x0000182A: e9190d0000               jmp      0x180002548
0x0000182F: cc                       int3     
0x00001830: 4885c9                   test     rcx, rcx
0x00001833: 7437                     je       0x18000186c
0x00001835: 53                       push     rbx
0x00001836: 4883ec20                 sub      rsp, 0x20
0x0000183A: 4c8bc1                   mov      r8, rcx
0x0000183D: 488b0db4740100           mov      rcx, qword ptr [rip + 0x174b4]
0x00001844: 33d2                     xor      edx, edx
0x00001846: 56                       push     rsi
0x00001847: e81de60100               call     0x18001fe69
0x0000184C: 85c0                     test     eax, eax
0x0000184E: 7517                     jne      0x180001867
0x00001850: e8370e0000               call     0x18000268c
0x00001855: 488bd8                   mov      rbx, rax
0x00001858: e832681800               call     0x18018808f
0x0000185D: 9c                       pushfq   
0x0000185E: 8bc8                     mov      ecx, eax
0x00001860: e8470e0000               call     0x1800026ac
0x00001865: 8903                     mov      dword ptr [rbx], eax
0x00001867: 4883c420                 add      rsp, 0x20
0x0000186B: 5b                       pop      rbx
0x0000186C: c3                       ret      
0x0000186D: cc                       int3     
0x0000186E: cc                       int3     
0x0000186F: cc                       int3     
0x00001870: 48895c2408               mov      qword ptr [rsp + 8], rbx
0x00001875: 4889742410               mov      qword ptr [rsp + 0x10], rsi
0x0000187A: 57                       push     rdi
0x0000187B: 4883ec20                 sub      rsp, 0x20
0x0000187F: 488bd9                   mov      rbx, rcx
0x00001882: 4883f9e0                 cmp      rcx, -0x20
0x00001886: 777c                     ja       0x180001904
0x00001888: bf01000000               mov      edi, 1
0x0000188D: 4885c9                   test     rcx, rcx
0x00001890: 480f45f9                 cmovne   rdi, rcx
0x00001894: 488b0d5d740100           mov      rcx, qword ptr [rip + 0x1745d]
0x0000189B: 4885c9                   test     rcx, rcx
0x0000189E: 7520                     jne      0x1800018c0
0x000018A0: e8ef150000               call     0x180002e94
0x000018A5: b91e000000               mov      ecx, 0x1e
0x000018AA: e859160000               call     0x180002f08
0x000018AF: b9ff000000               mov      ecx, 0xff
0x000018B4: e807110000               call     0x1800029c0
0x000018B9: 488b0d38740100           mov      rcx, qword ptr [rip + 0x17438]
0x000018C0: 4c8bc7                   mov      r8, rdi
0x000018C3: 33d2                     xor      edx, edx
0x000018C5: 51                       push     rcx
0x000018C6: e8d51f0400               call     0x1800438a0
0x000018CB: 488bf0                   mov      rsi, rax
0x000018CE: 4885c0                   test     rax, rax
0x000018D1: 752c                     jne      0x1800018ff
0x000018D3: 3905bf7a0100             cmp      dword ptr [rip + 0x17abf], eax
0x000018D9: 740e                     je       0x1800018e9
0x000018DB: 488bcb                   mov      rcx, rbx
0x000018DE: e8450e0000               call     0x180002728
0x000018E3: 85c0                     test     eax, eax
0x000018E5: 740d                     je       0x1800018f4
0x000018E7: ebab                     jmp      0x180001894
0x000018E9: e89e0d0000               call     0x18000268c
0x000018EE: c7000c000000             mov      dword ptr [rax], 0xc
0x000018F4: e8930d0000               call     0x18000268c
0x000018F9: c7000c000000             mov      dword ptr [rax], 0xc
0x000018FF: 488bc6                   mov      rax, rsi
0x00001902: eb12                     jmp      0x180001916
0x00001904: e81f0e0000               call     0x180002728
0x00001909: e87e0d0000               call     0x18000268c
0x0000190E: c7000c000000             mov      dword ptr [rax], 0xc
0x00001914: 33c0                     xor      eax, eax
0x00001916: 488b5c2430               mov      rbx, qword ptr [rsp + 0x30]
0x0000191B: 488b742438               mov      rsi, qword ptr [rsp + 0x38]
0x00001920: 4883c420                 add      rsp, 0x20
0x00001924: 5f                       pop      rdi
0x00001925: c3                       ret      
0x00001926: cc                       int3     
0x00001927: cc                       int3     
0x00001928: 48895c2408               mov      qword ptr [rsp + 8], rbx
0x0000192D: 57                       push     rdi
0x0000192E: 4883ec10                 sub      rsp, 0x10
0x00001932: 408a3a                   mov      dil, byte ptr [rdx]
0x00001935: 488bda                   mov      rbx, rdx
0x00001938: 4c8bc1                   mov      r8, rcx
0x0000193B: 4084ff                   test     dil, dil
0x0000193E: 7508                     jne      0x180001948
0x00001940: 488bc1                   mov      rax, rcx
0x00001943: e9b2010000               jmp      0x180001afa
0x00001948: 833d3158010002           cmp      dword ptr [rip + 0x15831], 2
0x0000194F: 41baff0f0000             mov      r10d, 0xfff
0x00001955: 458d5af1                 lea      r11d, [r10 - 0xf]
0x00001959: 0f8dd0000000             jge      0x180001a2f
0x0000195F: 400fb6c7                 movzx    eax, dil
0x00001963: 0f57d2                   xorps    xmm2, xmm2
0x00001966: 8bc8                     mov      ecx, eax
0x00001968: c1e108                   shl      ecx, 8
0x0000196B: 0bc8                     or       ecx, eax
0x0000196D: 660f6ec1                 movd     xmm0, ecx
0x00001971: f20f70c800               pshuflw  xmm1, xmm0, 0
0x00001976: 660f70d900               pshufd   xmm3, xmm1, 0
0x0000197B: 498bc0                   mov      rax, r8
0x0000197E: 4923c2                   and      rax, r10
0x00001981: 493bc3                   cmp      rax, r11
0x00001984: 7729                     ja       0x1800019af
0x00001986: f3410f6f00               movdqu   xmm0, xmmword ptr [r8]
0x0000198B: 660f6fc8                 movdqa   xmm1, xmm0
0x0000198F: 660f74c3                 pcmpeqb  xmm0, xmm3
0x00001993: 660f74ca                 pcmpeqb  xmm1, xmm2
0x00001997: 660febc8                 por      xmm1, xmm0
0x0000199B: 660fd7c1                 pmovmskb eax, xmm1
0x0000199F: 85c0                     test     eax, eax
0x000019A1: 7506                     jne      0x1800019a9
0x000019A3: 4983c010                 add      r8, 0x10
0x000019A7: ebd2                     jmp      0x18000197b
0x000019A9: 0fbcc0                   bsf      eax, eax
0x000019AC: 4c03c0                   add      r8, rax
0x000019AF: 41803800                 cmp      byte ptr [r8], 0
0x000019B3: 0f843f010000             je       0x180001af8
0x000019B9: 413a38                   cmp      dil, byte ptr [r8]
0x000019BC: 7569                     jne      0x180001a27
0x000019BE: 498bd0                   mov      rdx, r8
0x000019C1: 4c8bcb                   mov      r9, rbx
0x000019C4: 498bc1                   mov      rax, r9
0x000019C7: 4923c2                   and      rax, r10
0x000019CA: 493bc3                   cmp      rax, r11
0x000019CD: 7741                     ja       0x180001a10
0x000019CF: 488bc2                   mov      rax, rdx
0x000019D2: 4923c2                   and      rax, r10
0x000019D5: 493bc3                   cmp      rax, r11
0x000019D8: 7736                     ja       0x180001a10
0x000019DA: f3410f6f09               movdqu   xmm1, xmmword ptr [r9]
0x000019DF: f30f6f02                 movdqu   xmm0, xmmword ptr [rdx]
0x000019E3: 660f74c1                 pcmpeqb  xmm0, xmm1
0x000019E7: 660f74ca                 pcmpeqb  xmm1, xmm2
0x000019EB: 660f74c2                 pcmpeqb  xmm0, xmm2
0x000019EF: 660febc1                 por      xmm0, xmm1
0x000019F3: 660fd7c0                 pmovmskb eax, xmm0
0x000019F7: 85c0                     test     eax, eax
0x000019F9: 750a                     jne      0x180001a05
0x000019FB: 4883c210                 add      rdx, 0x10
0x000019FF: 4983c110                 add      r9, 0x10
0x00001A03: ebbf                     jmp      0x1800019c4
0x00001A05: 0fbcc0                   bsf      eax, eax
0x00001A08: 8bc8                     mov      ecx, eax
0x00001A0A: 4803d1                   add      rdx, rcx
0x00001A0D: 4c03c9                   add      r9, rcx
0x00001A10: 418a01                   mov      al, byte ptr [r9]
0x00001A13: 84c0                     test     al, al
0x00001A15: 0f84d8000000             je       0x180001af3
0x00001A1B: 3802                     cmp      byte ptr [rdx], al
0x00001A1D: 7508                     jne      0x180001a27
0x00001A1F: 48ffc2                   inc      rdx
0x00001A22: 49ffc1                   inc      r9
0x00001A25: eb9d                     jmp      0x1800019c4
0x00001A27: 49ffc0                   inc      r8
0x00001A2A: e94cffffff               jmp      0x18000197b
0x00001A2F: 488bc2                   mov      rax, rdx
0x00001A32: 4923c2                   and      rax, r10
0x00001A35: 493bc3                   cmp      rax, r11
0x00001A38: 7706                     ja       0x180001a40
0x00001A3A: f30f6f02                 movdqu   xmm0, xmmword ptr [rdx]
0x00001A3E: eb2b                     jmp      0x180001a6b
0x00001A40: 488bca                   mov      rcx, rdx
0x00001A43: 0f57c0                   xorps    xmm0, xmm0
0x00001A46: 41b910000000             mov      r9d, 0x10
0x00001A4C: 408ad7                   mov      dl, dil
0x00001A4F: 660f73d801               psrldq   xmm0, 1
0x00001A54: 0fbec2                   movsx    eax, dl
0x00001A57: 660f3a20c00f             pinsrb   xmm0, eax, 0xf
0x00001A5D: 84d2                     test     dl, dl
0x00001A5F: 7405                     je       0x180001a66
0x00001A61: 48ffc1                   inc      rcx
0x00001A64: 8a11                     mov      dl, byte ptr [rcx]
0x00001A66: 49ffc9                   dec      r9
0x00001A69: 75e4                     jne      0x180001a4f
0x00001A6B: 498bc0                   mov      rax, r8
0x00001A6E: 4923c2                   and      rax, r10
0x00001A71: 493bc3                   cmp      rax, r11
0x00001A74: 775a                     ja       0x180001ad0
0x00001A76: f3410f6f08               movdqu   xmm1, xmmword ptr [r8]
0x00001A7B: 660f3a63c10c             pcmpistri xmm0, xmm1, 0xc
0x00001A81: 7606                     jbe      0x180001a89
0x00001A83: 4983c010                 add      r8, 0x10
0x00001A87: ebe2                     jmp      0x180001a6b
0x00001A89: 736d                     jae      0x180001af8
0x00001A8B: 660f3a63c10c             pcmpistri xmm0, xmm1, 0xc
0x00001A91: 4863c1                   movsxd   rax, ecx
0x00001A94: 4c03c0                   add      r8, rax
0x00001A97: 498bd0                   mov      rdx, r8
0x00001A9A: 4c8bcb                   mov      r9, rbx
0x00001A9D: 488bc2                   mov      rax, rdx
0x00001AA0: 4923c2                   and      rax, r10
0x00001AA3: 493bc3                   cmp      rax, r11
0x00001AA6: 7738                     ja       0x180001ae0
0x00001AA8: 498bc1                   mov      rax, r9
0x00001AAB: 4923c2                   and      rax, r10
0x00001AAE: 493bc3                   cmp      rax, r11
0x00001AB1: 772d                     ja       0x180001ae0
0x00001AB3: f30f6f0a                 movdqu   xmm1, xmmword ptr [rdx]
0x00001AB7: f3410f6f11               movdqu   xmm2, xmmword ptr [r9]
0x00001ABC: 660f3a63d10c             pcmpistri xmm2, xmm1, 0xc
0x00001AC2: 7117                     jno      0x180001adb
0x00001AC4: 782d                     js       0x180001af3
0x00001AC6: 4883c210                 add      rdx, 0x10
0x00001ACA: 4983c110                 add      r9, 0x10
0x00001ACE: ebcd                     jmp      0x180001a9d
0x00001AD0: 41803800                 cmp      byte ptr [r8], 0
0x00001AD4: 7422                     je       0x180001af8
0x00001AD6: 413838                   cmp      byte ptr [r8], dil
0x00001AD9: 74bc                     je       0x180001a97
0x00001ADB: 49ffc0                   inc      r8
0x00001ADE: eb8b                     jmp      0x180001a6b
0x00001AE0: 418a01                   mov      al, byte ptr [r9]
0x00001AE3: 84c0                     test     al, al
0x00001AE5: 740c                     je       0x180001af3
0x00001AE7: 3802                     cmp      byte ptr [rdx], al
0x00001AE9: 75f0                     jne      0x180001adb
0x00001AEB: 48ffc2                   inc      rdx
0x00001AEE: 49ffc1                   inc      r9
0x00001AF1: ebaa                     jmp      0x180001a9d
0x00001AF3: 498bc0                   mov      rax, r8
0x00001AF6: eb02                     jmp      0x180001afa
0x00001AF8: 33c0                     xor      eax, eax
0x00001AFA: 488b5c2420               mov      rbx, qword ptr [rsp + 0x20]
0x00001AFF: 4883c410                 add      rsp, 0x10
0x00001B03: 5f                       pop      rdi
0x00001B04: c3                       ret      
0x00001B05: cc                       int3     
0x00001B06: cc                       int3     
0x00001B07: cc                       int3     
0x00001B08: 4053                     push     rbx
0x00001B0A: 4883ec20                 sub      rsp, 0x20
0x00001B0E: ba08000000               mov      edx, 8
0x00001B13: 8d4a18                   lea      ecx, [rdx + 0x18]
0x00001B16: e83d180000               call     0x180003358
0x00001B1B: 488bc8                   mov      rcx, rax
0x00001B1E: 488bd8                   mov      rbx, rax
0x00001B21: 52                       push     rdx
0x00001B22: e83c662100               call     0x180218163
0x00001B27: 4889057abc0100           mov      qword ptr [rip + 0x1bc7a], rax
0x00001B2E: 4889056bbc0100           mov      qword ptr [rip + 0x1bc6b], rax
0x00001B35: 4885db                   test     rbx, rbx
0x00001B38: 7505                     jne      0x180001b3f
0x00001B3A: 8d4318                   lea      eax, [rbx + 0x18]
0x00001B3D: eb06                     jmp      0x180001b45
0x00001B3F: 48832300                 and      qword ptr [rbx], 0
0x00001B43: 33c0                     xor      eax, eax
0x00001B45: 4883c420                 add      rsp, 0x20
0x00001B49: 5b                       pop      rbx
0x00001B4A: c3                       ret      
0x00001B4B: cc                       int3     
0x00001B4C: 48895c2408               mov      qword ptr [rsp + 8], rbx
0x00001B51: 4889742410               mov      qword ptr [rsp + 0x10], rsi
0x00001B56: 48897c2418               mov      qword ptr [rsp + 0x18], rdi
0x00001B5B: 4154                     push     r12
0x00001B5D: 4156                     push     r14
0x00001B5F: 4157                     push     r15
0x00001B61: 4883ec20                 sub      rsp, 0x20
0x00001B65: 4c8be1                   mov      r12, rcx
0x00001B68: e877110000               call     0x180002ce4
0x00001B6D: 90                       nop      
0x00001B6E: 488b0d33bc0100           mov      rcx, qword ptr [rip + 0x1bc33]
0x00001B75: e8a6411900               call     0x180195d20
0x00001B7A: 6e                       outsb    dx, byte ptr [rsi]
0x00001B7B: 4c8bf0                   mov      r14, rax
0x00001B7E: 488b0d1bbc0100           mov      rcx, qword ptr [rip + 0x1bc1b]
0x00001B85: 55                       push     rbp
0x00001B86: e854951900               call     0x18019b0df
0x00001B8B: 488bd8                   mov      rbx, rax
0x00001B8E: 493bc6                   cmp      rax, r14
0x00001B91: 0f829b000000             jb       0x180001c32
0x00001B97: 488bf8                   mov      rdi, rax
0x00001B9A: 492bfe                   sub      rdi, r14
0x00001B9D: 4c8d7f08                 lea      r15, [rdi + 8]
0x00001BA1: 4983ff08                 cmp      r15, 8
0x00001BA5: 0f8287000000             jb       0x180001c32
0x00001BAB: 498bce                   mov      rcx, r14
0x00001BAE: e869170000               call     0x18000331c
0x00001BB3: 488bf0                   mov      rsi, rax
0x00001BB6: 493bc7                   cmp      rax, r15
0x00001BB9: 7355                     jae      0x180001c10
0x00001BBB: ba00100000               mov      edx, 0x1000
0x00001BC0: 483bc2                   cmp      rax, rdx
0x00001BC3: 480f42d0                 cmovb    rdx, rax
0x00001BC7: 4803d0                   add      rdx, rax
0x00001BCA: 483bd0                   cmp      rdx, rax
0x00001BCD: 7211                     jb       0x180001be0
0x00001BCF: 498bce                   mov      rcx, r14
0x00001BD2: e87d180000               call     0x180003454
0x00001BD7: 33db                     xor      ebx, ebx
0x00001BD9: 4885c0                   test     rax, rax
0x00001BDC: 751a                     jne      0x180001bf8
0x00001BDE: eb02                     jmp      0x180001be2
0x00001BE0: 33db                     xor      ebx, ebx
0x00001BE2: 488d5620                 lea      rdx, [rsi + 0x20]
0x00001BE6: 483bd6                   cmp      rdx, rsi
0x00001BE9: 7249                     jb       0x180001c34
0x00001BEB: 498bce                   mov      rcx, r14
0x00001BEE: e861180000               call     0x180003454
0x00001BF3: 4885c0                   test     rax, rax
0x00001BF6: 743c                     je       0x180001c34
0x00001BF8: 48c1ff03                 sar      rdi, 3
0x00001BFC: 488d1cf8                 lea      rbx, [rax + rdi*8]
0x00001C00: 488bc8                   mov      rcx, rax
0x00001C03: e8c34d0300               call     0x1800369cb
0x00001C08: a848                     test     al, 0x48
0x00001C0A: 890598bb0100             mov      dword ptr [rip + 0x1bb98], eax
0x00001C10: 498bcc                   mov      rcx, r12
0x00001C13: 55                       push     rbp
0x00001C14: e81b231300               call     0x180133f34
0x00001C19: 488903                   mov      qword ptr [rbx], rax
0x00001C1C: 488d4b08                 lea      rcx, [rbx + 8]
0x00001C20: 52                       push     rdx
0x00001C21: e859091900               call     0x18019257f
0x00001C26: 48890573bb0100           mov      qword ptr [rip + 0x1bb73], rax
0x00001C2D: 498bdc                   mov      rbx, r12
0x00001C30: eb02                     jmp      0x180001c34
0x00001C32: 33db                     xor      ebx, ebx
0x00001C34: e8b7100000               call     0x180002cf0
0x00001C39: 488bc3                   mov      rax, rbx
0x00001C3C: 488b5c2440               mov      rbx, qword ptr [rsp + 0x40]
0x00001C41: 488b742448               mov      rsi, qword ptr [rsp + 0x48]
0x00001C46: 488b7c2450               mov      rdi, qword ptr [rsp + 0x50]
0x00001C4B: 4883c420                 add      rsp, 0x20
0x00001C4F: 415f                     pop      r15
0x00001C51: 415e                     pop      r14
0x00001C53: 415c                     pop      r12
0x00001C55: c3                       ret      
0x00001C56: cc                       int3     
0x00001C57: cc                       int3     
0x00001C58: 4883ec28                 sub      rsp, 0x28
0x00001C5C: e8ebfeffff               call     0x180001b4c
0x00001C61: 48f7d8                   neg      rax
0x00001C64: 1bc0                     sbb      eax, eax
0x00001C66: f7d8                     neg      eax
0x00001C68: ffc8                     dec      eax
0x00001C6A: 4883c428                 add      rsp, 0x28
0x00001C6E: c3                       ret      
0x00001C6F: cc                       int3     
0x00001C70: 4883ec78                 sub      rsp, 0x78
0x00001C74: 488b0585530100           mov      rax, qword ptr [rip + 0x15385]
0x00001C7B: 4833c4                   xor      rax, rsp
0x00001C7E: 4889442460               mov      qword ptr [rsp + 0x60], rax
0x00001C83: 833900                   cmp      dword ptr [rcx], 0
0x00001C86: 7506                     jne      0x180001c8e
0x00001C88: 83790400                 cmp      dword ptr [rcx + 4], 0
0x00001C8C: 745b                     je       0x180001ce9
0x00001C8E: 488d542450               lea      rdx, [rsp + 0x50]
0x00001C93: e842ed2300               call     0x1802409da
0x00001C98: 54                       push     rsp
0x00001C99: 85c0                     test     eax, eax
0x00001C9B: 744c                     je       0x180001ce9
0x00001C9D: 4c8d442440               lea      r8, [rsp + 0x40]
0x00001CA2: 488d542450               lea      rdx, [rsp + 0x50]
0x00001CA7: 33c9                     xor      ecx, ecx
0x00001CA9: e898381d00               call     0x1801d5546
0x00001CAE: f4                       hlt      
0x00001CAF: 85c0                     test     eax, eax
0x00001CB1: 7436                     je       0x180001ce9
0x00001CB3: 834c2430ff               or       dword ptr [rsp + 0x30], 0xffffffff
0x00001CB8: 0fb744244c               movzx    eax, word ptr [rsp + 0x4c]
0x00001CBD: 440fb754244a             movzx    r10d, word ptr [rsp + 0x4a]
0x00001CC3: 440fb74c2448             movzx    r9d, word ptr [rsp + 0x48]
0x00001CC9: 440fb7442446             movzx    r8d, word ptr [rsp + 0x46]
0x00001CCF: 0fb7542442               movzx    edx, word ptr [rsp + 0x42]
0x00001CD4: 0fb74c2440               movzx    ecx, word ptr [rsp + 0x40]
0x00001CD9: 89442428                 mov      dword ptr [rsp + 0x28], eax
0x00001CDD: 4489542420               mov      dword ptr [rsp + 0x20], r10d
0x00001CE2: e8851e0000               call     0x180003b6c
0x00001CE7: eb04                     jmp      0x180001ced
0x00001CE9: 4883c8ff                 or       rax, 0xffffffffffffffff
0x00001CED: 488b4c2460               mov      rcx, qword ptr [rsp + 0x60]
0x00001CF2: 4833cc                   xor      rcx, rsp
0x00001CF5: e816fbffff               call     0x180001810
0x00001CFA: 4883c478                 add      rsp, 0x78
0x00001CFE: c3                       ret      
0x00001CFF: cc                       int3     
0x00001D00: 48895c2408               mov      qword ptr [rsp + 8], rbx
0x00001D05: 57                       push     rdi
0x00001D06: 4883ec30                 sub      rsp, 0x30
0x00001D0A: 488364244800             and      qword ptr [rsp + 0x48], 0
0x00001D10: 488bd9                   mov      rbx, rcx
0x00001D13: 488bfa                   mov      rdi, rdx
0x00001D16: 488d4a24                 lea      rcx, [rdx + 0x24]
0x00001D1A: 488d542448               lea      rdx, [rsp + 0x48]
0x00001D1F: e8400b0000               call     0x180002864
0x00001D24: 85c0                     test     eax, eax
0x00001D26: 750b                     jne      0x180001d33
0x00001D28: 488b5c2440               mov      rbx, qword ptr [rsp + 0x40]
0x00001D2D: 4883c430                 add      rsp, 0x30
0x00001D31: 5f                       pop      rdi
0x00001D32: c3                       ret      
0x00001D33: 4c8b442448               mov      r8, qword ptr [rsp + 0x48]
0x00001D38: 488d4b24                 lea      rcx, [rbx + 0x24]
0x00001D3C: ba04010000               mov      edx, 0x104
0x00001D41: e84e010000               call     0x180001e94
0x00001D46: 85c0                     test     eax, eax
0x00001D48: 7533                     jne      0x180001d7d
0x00001D4A: 488b4c2448               mov      rcx, qword ptr [rsp + 0x48]
0x00001D4F: e8dcfaffff               call     0x180001830
0x00001D54: 8b07                     mov      eax, dword ptr [rdi]
0x00001D56: 8903                     mov      dword ptr [rbx], eax
0x00001D58: 488b4708                 mov      rax, qword ptr [rdi + 8]
0x00001D5C: 48894308                 mov      qword ptr [rbx + 8], rax
0x00001D60: 488b4710                 mov      rax, qword ptr [rdi + 0x10]
0x00001D64: 48894310                 mov      qword ptr [rbx + 0x10], rax
0x00001D68: 488b4718                 mov      rax, qword ptr [rdi + 0x18]
0x00001D6C: 48894318                 mov      qword ptr [rbx + 0x18], rax
0x00001D70: 8b4720                   mov      eax, dword ptr [rdi + 0x20]
0x00001D73: 894320                   mov      dword ptr [rbx + 0x20], eax
0x00001D76: b801000000               mov      eax, 1
0x00001D7B: ebab                     jmp      0x180001d28
0x00001D7D: 488364242000             and      qword ptr [rsp + 0x20], 0
0x00001D83: 4533c9                   xor      r9d, r9d
0x00001D86: 4533c0                   xor      r8d, r8d
0x00001D89: 33d2                     xor      edx, edx
0x00001D8B: 33c9                     xor      ecx, ecx
0x00001D8D: e8321b0000               call     0x1800038c4
0x00001D92: cc                       int3     
0x00001D93: cc                       int3     
0x00001D94: 48895c2418               mov      qword ptr [rsp + 0x18], rbx
0x00001D99: 57                       push     rdi
0x00001D9A: 4881ec70020000           sub      rsp, 0x270
0x00001DA1: 488b0558520100           mov      rax, qword ptr [rip + 0x15258]
0x00001DA8: 4833c4                   xor      rax, rsp
0x00001DAB: 4889842460020000         mov      qword ptr [rsp + 0x260], rax
0x00001DB3: 488364242000             and      qword ptr [rsp + 0x20], 0
0x00001DB9: 488bfa                   mov      rdi, rdx
0x00001DBC: 488d542420               lea      rdx, [rsp + 0x20]
0x00001DC1: e89e090000               call     0x180002764
0x00001DC6: 85c0                     test     eax, eax
0x00001DC8: 7506                     jne      0x180001dd0
0x00001DCA: 4883c8ff                 or       rax, 0xffffffffffffffff
0x00001DCE: eb36                     jmp      0x180001e06
0x00001DD0: 488b4c2420               mov      rcx, qword ptr [rsp + 0x20]
0x00001DD5: 488d542430               lea      rdx, [rsp + 0x30]
0x00001DDA: e8211b0000               call     0x180003900
0x00001DDF: 488b4c2420               mov      rcx, qword ptr [rsp + 0x20]
0x00001DE4: 488bd8                   mov      rbx, rax
0x00001DE7: e844faffff               call     0x180001830
0x00001DEC: 4883fbff                 cmp      rbx, -1
0x00001DF0: 7411                     je       0x180001e03
0x00001DF2: 488d542430               lea      rdx, [rsp + 0x30]
0x00001DF7: 488bcf                   mov      rcx, rdi
0x00001DFA: e801ffffff               call     0x180001d00
0x00001DFF: 85c0                     test     eax, eax
0x00001E01: 74c7                     je       0x180001dca
0x00001E03: 488bc3                   mov      rax, rbx
0x00001E06: 488b8c2460020000         mov      rcx, qword ptr [rsp + 0x260]
0x00001E0E: 4833cc                   xor      rcx, rsp
0x00001E11: e8faf9ffff               call     0x180001810
0x00001E16: 488b9c2490020000         mov      rbx, qword ptr [rsp + 0x290]
0x00001E1E: 4881c470020000           add      rsp, 0x270
0x00001E25: 5f                       pop      rdi
0x00001E26: c3                       ret      
0x00001E27: cc                       int3     
0x00001E28: 48895c2418               mov      qword ptr [rsp + 0x18], rbx
0x00001E2D: 57                       push     rdi
0x00001E2E: 4881ec60020000           sub      rsp, 0x260
0x00001E35: 488b05c4510100           mov      rax, qword ptr [rip + 0x151c4]
0x00001E3C: 4833c4                   xor      rax, rsp
0x00001E3F: 4889842450020000         mov      qword ptr [rsp + 0x250], rax
0x00001E47: 488bfa                   mov      rdi, rdx
0x00001E4A: 488d542420               lea      rdx, [rsp + 0x20]
0x00001E4F: e8f41b0000               call     0x180003a48
0x00001E54: 8bd8                     mov      ebx, eax
0x00001E56: 83f8ff                   cmp      eax, -1
0x00001E59: 7416                     je       0x180001e71
0x00001E5B: 488d542420               lea      rdx, [rsp + 0x20]
0x00001E60: 488bcf                   mov      rcx, rdi
0x00001E63: e898feffff               call     0x180001d00
0x00001E68: 85c0                     test     eax, eax
0x00001E6A: 7505                     jne      0x180001e71
0x00001E6C: 83c8ff                   or       eax, 0xffffffff
0x00001E6F: eb02                     jmp      0x180001e73
0x00001E71: 8bc3                     mov      eax, ebx
0x00001E73: 488b8c2450020000         mov      rcx, qword ptr [rsp + 0x250]
0x00001E7B: 4833cc                   xor      rcx, rsp
0x00001E7E: e88df9ffff               call     0x180001810
0x00001E83: 488b9c2480020000         mov      rbx, qword ptr [rsp + 0x280]
0x00001E8B: 4881c460020000           add      rsp, 0x260
0x00001E92: 5f                       pop      rdi
0x00001E93: c3                       ret      
0x00001E94: 4053                     push     rbx
0x00001E96: 4883ec20                 sub      rsp, 0x20
0x00001E9A: 4885c9                   test     rcx, rcx
0x00001E9D: 740d                     je       0x180001eac
0x00001E9F: 4885d2                   test     rdx, rdx
0x00001EA2: 7408                     je       0x180001eac
0x00001EA4: 4d85c0                   test     r8, r8
0x00001EA7: 751c                     jne      0x180001ec5
0x00001EA9: 448801                   mov      byte ptr [rcx], r8b
0x00001EAC: e8db070000               call     0x18000268c
0x00001EB1: bb16000000               mov      ebx, 0x16
0x00001EB6: 8918                     mov      dword ptr [rax], ebx
0x00001EB8: e8e7190000               call     0x1800038a4
0x00001EBD: 8bc3                     mov      eax, ebx
0x00001EBF: 4883c420                 add      rsp, 0x20
0x00001EC3: 5b                       pop      rbx
0x00001EC4: c3                       ret      
0x00001EC5: 4c8bc9                   mov      r9, rcx
0x00001EC8: 4d2bc8                   sub      r9, r8
0x00001ECB: 418a00                   mov      al, byte ptr [r8]
0x00001ECE: 43880401                 mov      byte ptr [r9 + r8], al
0x00001ED2: 49ffc0                   inc      r8
0x00001ED5: 84c0                     test     al, al
0x00001ED7: 7405                     je       0x180001ede
0x00001ED9: 48ffca                   dec      rdx
0x00001EDC: 75ed                     jne      0x180001ecb
0x00001EDE: 4885d2                   test     rdx, rdx
0x00001EE1: 750e                     jne      0x180001ef1
0x00001EE3: 8811                     mov      byte ptr [rcx], dl
0x00001EE5: e8a2070000               call     0x18000268c
0x00001EEA: bb22000000               mov      ebx, 0x22
0x00001EEF: ebc5                     jmp      0x180001eb6
0x00001EF1: 33c0                     xor      eax, eax
0x00001EF3: ebca                     jmp      0x180001ebf
0x00001EF5: cc                       int3     
0x00001EF6: cc                       int3     
0x00001EF7: cc                       int3     
0x00001EF8: 4053                     push     rbx
0x00001EFA: 4883ec20                 sub      rsp, 0x20
0x00001EFE: 4533d2                   xor      r10d, r10d
0x00001F01: 4c8bc9                   mov      r9, rcx
0x00001F04: 4885c9                   test     rcx, rcx
0x00001F07: 740d                     je       0x180001f16
0x00001F09: 4885d2                   test     rdx, rdx
0x00001F0C: 7408                     je       0x180001f16
0x00001F0E: 4d85c0                   test     r8, r8
0x00001F11: 751c                     jne      0x180001f2f
0x00001F13: 448811                   mov      byte ptr [rcx], r10b
0x00001F16: e871070000               call     0x18000268c
0x00001F1B: bb16000000               mov      ebx, 0x16
0x00001F20: 8918                     mov      dword ptr [rax], ebx
0x00001F22: e87d190000               call     0x1800038a4
0x00001F27: 8bc3                     mov      eax, ebx
0x00001F29: 4883c420                 add      rsp, 0x20
0x00001F2D: 5b                       pop      rbx
0x00001F2E: c3                       ret      
0x00001F2F: 443811                   cmp      byte ptr [rcx], r10b
0x00001F32: 7408                     je       0x180001f3c
0x00001F34: 48ffc1                   inc      rcx
0x00001F37: 48ffca                   dec      rdx
0x00001F3A: 75f3                     jne      0x180001f2f
0x00001F3C: 4885d2                   test     rdx, rdx
0x00001F3F: 7505                     jne      0x180001f46
0x00001F41: 458811                   mov      byte ptr [r9], r10b
0x00001F44: ebd0                     jmp      0x180001f16
0x00001F46: 492bc8                   sub      rcx, r8
0x00001F49: 418a00                   mov      al, byte ptr [r8]
0x00001F4C: 42880401                 mov      byte ptr [rcx + r8], al
0x00001F50: 49ffc0                   inc      r8
0x00001F53: 84c0                     test     al, al
0x00001F55: 7405                     je       0x180001f5c
0x00001F57: 48ffca                   dec      rdx
0x00001F5A: 75ed                     jne      0x180001f49
0x00001F5C: 4885d2                   test     rdx, rdx
0x00001F5F: 750f                     jne      0x180001f70
0x00001F61: 458811                   mov      byte ptr [r9], r10b
0x00001F64: e823070000               call     0x18000268c
0x00001F69: bb22000000               mov      ebx, 0x22
0x00001F6E: ebb0                     jmp      0x180001f20
0x00001F70: 33c0                     xor      eax, eax
0x00001F72: ebb5                     jmp      0x180001f29
0x00001F74: 4c89442418               mov      qword ptr [rsp + 0x18], r8
0x00001F79: 53                       push     rbx
0x00001F7A: 4883ec20                 sub      rsp, 0x20
0x00001F7E: 498bd8                   mov      rbx, r8
0x00001F81: 83fa01                   cmp      edx, 1
0x00001F84: 757d                     jne      0x180002003
0x00001F86: e871070000               call     0x1800026fc
0x00001F8B: 85c0                     test     eax, eax
0x00001F8D: 7507                     jne      0x180001f96
0x00001F8F: 33c0                     xor      eax, eax
0x00001F91: e937010000               jmp      0x1800020cd
0x00001F96: e859240000               call     0x1800043f4
0x00001F9B: 85c0                     test     eax, eax
0x00001F9D: 7507                     jne      0x180001fa6
0x00001F9F: e878070000               call     0x18000271c
0x00001FA4: ebe9                     jmp      0x180001f8f
0x00001FA6: e831340000               call     0x1800053dc
0x00001FAB: 52                       push     rdx
0x00001FAC: e83f550300               call     0x1800374f0
0x00001FB1: 48890500b80100           mov      qword ptr [rip + 0x1b800], rax
0x00001FB8: e81b2d0000               call     0x180004cd8
0x00001FBD: 488905ac670100           mov      qword ptr [rip + 0x167ac], rax
0x00001FC4: e8cf240000               call     0x180004498
0x00001FC9: 85c0                     test     eax, eax
0x00001FCB: 7907                     jns      0x180001fd4
0x00001FCD: e8a2240000               call     0x180004474
0x00001FD2: ebcb                     jmp      0x180001f9f
0x00001FD4: e863280000               call     0x18000483c
0x00001FD9: 85c0                     test     eax, eax
0x00001FDB: 781f                     js       0x180001ffc
0x00001FDD: e8162b0000               call     0x180004af8
0x00001FE2: 85c0                     test     eax, eax
0x00001FE4: 7816                     js       0x180001ffc
0x00001FE6: 33c9                     xor      ecx, ecx
0x00001FE8: e86b0b0000               call     0x180002b58
0x00001FED: 85c0                     test     eax, eax
0x00001FEF: 750b                     jne      0x180001ffc
0x00001FF1: ff0571670100             inc      dword ptr [rip + 0x16771]
0x00001FF7: e9cc000000               jmp      0x1800020c8
0x00001FFC: e8c7270000               call     0x1800047c8
0x00002001: ebca                     jmp      0x180001fcd
0x00002003: 85d2                     test     edx, edx
0x00002005: 7552                     jne      0x180002059
0x00002007: 8b055b670100             mov      eax, dword ptr [rip + 0x1675b]
0x0000200D: 85c0                     test     eax, eax
0x0000200F: 0f8e7affffff             jle      0x180001f8f
0x00002015: ffc8                     dec      eax
0x00002017: 89054b670100             mov      dword ptr [rip + 0x1674b], eax
0x0000201D: 3915256d0100             cmp      dword ptr [rip + 0x16d25], edx
0x00002023: 7505                     jne      0x18000202a
0x00002025: e81e0b0000               call     0x180002b48
0x0000202A: e8a9090000               call     0x1800029d8
0x0000202F: 4885db                   test     rbx, rbx
0x00002032: 7510                     jne      0x180002044
0x00002034: e88f270000               call     0x1800047c8
0x00002039: e836240000               call     0x180004474
0x0000203E: e8d9060000               call     0x18000271c
0x00002043: 90                       nop      
0x00002044: 4885db                   test     rbx, rbx
0x00002047: 757f                     jne      0x1800020c8
0x00002049: 833d40510100ff           cmp      dword ptr [rip + 0x15140], -1
0x00002050: 7476                     je       0x1800020c8
0x00002052: e81d240000               call     0x180004474
0x00002057: eb6f                     jmp      0x1800020c8
0x00002059: 83fa02                   cmp      edx, 2
0x0000205C: 755e                     jne      0x1800020bc
0x0000205E: 8b0d2c510100             mov      ecx, dword ptr [rip + 0x1512c]
0x00002064: e87f2e0000               call     0x180004ee8
0x00002069: 4885c0                   test     rax, rax
0x0000206C: 755a                     jne      0x1800020c8
0x0000206E: ba78040000               mov      edx, 0x478
0x00002073: 8d4801                   lea      ecx, [rax + 1]
0x00002076: e8dd120000               call     0x180003358
0x0000207B: 488bd8                   mov      rbx, rax
0x0000207E: 4885c0                   test     rax, rax
0x00002081: 0f8408ffffff             je       0x180001f8f
0x00002087: 488bd0                   mov      rdx, rax
0x0000208A: 8b0d00510100             mov      ecx, dword ptr [rip + 0x15100]
0x00002090: e86f2e0000               call     0x180004f04
0x00002095: 488bcb                   mov      rcx, rbx
0x00002098: 85c0                     test     eax, eax
0x0000209A: 7416                     je       0x1800020b2
0x0000209C: 33d2                     xor      edx, edx
0x0000209E: e88d220000               call     0x180004330
0x000020A3: e8430b2400               call     0x180242beb
0x000020A8: 1a890348834b             sbb      cl, byte ptr [rcx + 0x4b834803]
0x000020AE: 08ff                     or       bh, bh
0x000020B0: eb16                     jmp      0x1800020c8
0x000020B2: e879f7ffff               call     0x180001830
0x000020B7: e9d3feffff               jmp      0x180001f8f
0x000020BC: 83fa03                   cmp      edx, 3
0x000020BF: 7507                     jne      0x1800020c8
0x000020C1: 33c9                     xor      ecx, ecx
0x000020C3: e884210000               call     0x18000424c
0x000020C8: b801000000               mov      eax, 1
0x000020CD: 4883c420                 add      rsp, 0x20
0x000020D1: 5b                       pop      rbx
0x000020D2: c3                       ret      
0x000020D3: cc                       int3     
0x000020D4: 48895c2408               mov      qword ptr [rsp + 8], rbx
0x000020D9: 4889742410               mov      qword ptr [rsp + 0x10], rsi
0x000020DE: 57                       push     rdi
0x000020DF: 4883ec20                 sub      rsp, 0x20
0x000020E3: 498bf8                   mov      rdi, r8
0x000020E6: 8bda                     mov      ebx, edx
0x000020E8: 488bf1                   mov      rsi, rcx
0x000020EB: 83fa01                   cmp      edx, 1
0x000020EE: 7505                     jne      0x1800020f5
0x000020F0: e8372b0000               call     0x180004c2c
0x000020F5: 4c8bc7                   mov      r8, rdi
0x000020F8: 8bd3                     mov      edx, ebx
0x000020FA: 488bce                   mov      rcx, rsi
0x000020FD: 488b5c2430               mov      rbx, qword ptr [rsp + 0x30]
0x00002102: 488b742438               mov      rsi, qword ptr [rsp + 0x38]
0x00002107: 4883c420                 add      rsp, 0x20
0x0000210B: 5f                       pop      rdi
0x0000210C: e903000000               jmp      0x180002114
0x00002111: cc                       int3     
0x00002112: cc                       int3     
0x00002113: cc                       int3     
0x00002114: 488bc4                   mov      rax, rsp
0x00002117: 48895820                 mov      qword ptr [rax + 0x20], rbx
0x0000211B: 4c894018                 mov      qword ptr [rax + 0x18], r8
0x0000211F: 895010                   mov      dword ptr [rax + 0x10], edx
0x00002122: 48894808                 mov      qword ptr [rax + 8], rcx
0x00002126: 56                       push     rsi
0x00002127: 57                       push     rdi
0x00002128: 4156                     push     r14
0x0000212A: 4883ec50                 sub      rsp, 0x50
0x0000212E: 498bf0                   mov      rsi, r8
0x00002131: 8bda                     mov      ebx, edx
0x00002133: 4c8bf1                   mov      r14, rcx
0x00002136: ba01000000               mov      edx, 1
0x0000213B: 8950b8                   mov      dword ptr [rax - 0x48], edx
0x0000213E: 85db                     test     ebx, ebx
0x00002140: 750f                     jne      0x180002151
0x00002142: 391d20660100             cmp      dword ptr [rip + 0x16620], ebx
0x00002148: 7507                     jne      0x180002151
0x0000214A: 33c0                     xor      eax, eax
0x0000214C: e9d2000000               jmp      0x180002223
0x00002151: 8d43ff                   lea      eax, [rbx - 1]
0x00002154: 83f801                   cmp      eax, 1
0x00002157: 7738                     ja       0x180002191
0x00002159: 488b0578d20000           mov      rax, qword ptr [rip + 0xd278]
0x00002160: 4885c0                   test     rax, rax
0x00002163: 740a                     je       0x18000216f
0x00002165: 8bd3                     mov      edx, ebx
0x00002167: ffd0                     call     rax
0x00002169: 8bd0                     mov      edx, eax
0x0000216B: 89442420                 mov      dword ptr [rsp + 0x20], eax
0x0000216F: 85d2                     test     edx, edx
0x00002171: 7417                     je       0x18000218a
0x00002173: 4c8bc6                   mov      r8, rsi
0x00002176: 8bd3                     mov      edx, ebx
0x00002178: 498bce                   mov      rcx, r14
0x0000217B: e8f4fdffff               call     0x180001f74
0x00002180: 8bd0                     mov      edx, eax
0x00002182: 89442420                 mov      dword ptr [rsp + 0x20], eax
0x00002186: 85c0                     test     eax, eax
0x00002188: 7507                     jne      0x180002191
0x0000218A: 33c0                     xor      eax, eax
0x0000218C: e992000000               jmp      0x180002223
0x00002191: 4c8bc6                   mov      r8, rsi
0x00002194: 8bd3                     mov      edx, ebx
0x00002196: 498bce                   mov      rcx, r14
0x00002199: e812f2ffff               call     0x1800013b0
0x0000219E: 8bf8                     mov      edi, eax
0x000021A0: 89442420                 mov      dword ptr [rsp + 0x20], eax
0x000021A4: 83fb01                   cmp      ebx, 1
0x000021A7: 7534                     jne      0x1800021dd
0x000021A9: 85c0                     test     eax, eax
0x000021AB: 7530                     jne      0x1800021dd
0x000021AD: 4c8bc6                   mov      r8, rsi
0x000021B0: 33d2                     xor      edx, edx
0x000021B2: 498bce                   mov      rcx, r14
0x000021B5: e8f6f1ffff               call     0x1800013b0
0x000021BA: 4c8bc6                   mov      r8, rsi
0x000021BD: 33d2                     xor      edx, edx
0x000021BF: 498bce                   mov      rcx, r14
0x000021C2: e8adfdffff               call     0x180001f74
0x000021C7: 488b050ad20000           mov      rax, qword ptr [rip + 0xd20a]
0x000021CE: 4885c0                   test     rax, rax
0x000021D1: 740a                     je       0x1800021dd
0x000021D3: 4c8bc6                   mov      r8, rsi
0x000021D6: 33d2                     xor      edx, edx
0x000021D8: 498bce                   mov      rcx, r14
0x000021DB: ffd0                     call     rax
0x000021DD: 85db                     test     ebx, ebx
0x000021DF: 7405                     je       0x1800021e6
0x000021E1: 83fb03                   cmp      ebx, 3
0x000021E4: 7537                     jne      0x18000221d
0x000021E6: 4c8bc6                   mov      r8, rsi
0x000021E9: 8bd3                     mov      edx, ebx
0x000021EB: 498bce                   mov      rcx, r14
0x000021EE: e881fdffff               call     0x180001f74
0x000021F3: f7d8                     neg      eax
0x000021F5: 1bc9                     sbb      ecx, ecx
0x000021F7: 23cf                     and      ecx, edi
0x000021F9: 8bf9                     mov      edi, ecx
0x000021FB: 894c2420                 mov      dword ptr [rsp + 0x20], ecx
0x000021FF: 741c                     je       0x18000221d
0x00002201: 488b05d0d10000           mov      rax, qword ptr [rip + 0xd1d0]
0x00002208: 4885c0                   test     rax, rax
0x0000220B: 7410                     je       0x18000221d
0x0000220D: 4c8bc6                   mov      r8, rsi
0x00002210: 8bd3                     mov      edx, ebx
0x00002212: 498bce                   mov      rcx, r14
0x00002215: ffd0                     call     rax
0x00002217: 8bf8                     mov      edi, eax
0x00002219: 89442420                 mov      dword ptr [rsp + 0x20], eax
0x0000221D: 8bc7                     mov      eax, edi
0x0000221F: eb02                     jmp      0x180002223
0x00002221: 33c0                     xor      eax, eax
0x00002223: 488b9c2488000000         mov      rbx, qword ptr [rsp + 0x88]
0x0000222B: 4883c450                 add      rsp, 0x50
0x0000222F: 415e                     pop      r14
0x00002231: 5f                       pop      rdi
0x00002232: 5e                       pop      rsi
0x00002233: c3                       ret      
0x00002234: 48895c2408               mov      qword ptr [rsp + 8], rbx
0x00002239: 4889742410               mov      qword ptr [rsp + 0x10], rsi
0x0000223E: 57                       push     rdi
0x0000223F: 4883ec20                 sub      rsp, 0x20
0x00002243: 33ff                     xor      edi, edi
0x00002245: 488bda                   mov      rbx, rdx
0x00002248: 488bf1                   mov      rsi, rcx
0x0000224B: 4885d2                   test     rdx, rdx
0x0000224E: 741d                     je       0x18000226d
0x00002250: 33d2                     xor      edx, edx
0x00002252: 488d47e0                 lea      rax, [rdi - 0x20]
0x00002256: 48f7f3                   div      rbx
0x00002259: 493bc0                   cmp      rax, r8
0x0000225C: 730f                     jae      0x18000226d
0x0000225E: e829040000               call     0x18000268c
0x00002263: c7000c000000             mov      dword ptr [rax], 0xc
0x00002269: 33c0                     xor      eax, eax
0x0000226B: eb3d                     jmp      0x1800022aa
0x0000226D: 490fafd8                 imul     rbx, r8
0x00002271: 4885c9                   test     rcx, rcx
0x00002274: 7408                     je       0x18000227e
0x00002276: e8a1100000               call     0x18000331c
0x0000227B: 488bf8                   mov      rdi, rax
0x0000227E: 488bd3                   mov      rdx, rbx
0x00002281: 488bce                   mov      rcx, rsi
0x00002284: e8c3310000               call     0x18000544c
0x00002289: 488bf0                   mov      rsi, rax
0x0000228C: 4885c0                   test     rax, rax
0x0000228F: 7416                     je       0x1800022a7
0x00002291: 483bfb                   cmp      rdi, rbx
0x00002294: 7311                     jae      0x1800022a7
0x00002296: 482bdf                   sub      rbx, rdi
0x00002299: 488d0c07                 lea      rcx, [rdi + rax]
0x0000229D: 33d2                     xor      edx, edx
0x0000229F: 4c8bc3                   mov      r8, rbx
0x000022A2: e829000000               call     0x1800022d0
0x000022A7: 488bc6                   mov      rax, rsi
0x000022AA: 488b5c2430               mov      rbx, qword ptr [rsp + 0x30]
0x000022AF: 488b742438               mov      rsi, qword ptr [rsp + 0x38]
0x000022B4: 4883c420                 add      rsp, 0x20
0x000022B8: 5f                       pop      rdi
0x000022B9: c3                       ret      
0x000022BA: cc                       int3     
0x000022BB: cc                       int3     
0x000022BC: cc                       int3     
0x000022BD: cc                       int3     
0x000022BE: cc                       int3     
0x000022BF: cc                       int3     
0x000022C0: cc                       int3     
0x000022C1: cc                       int3     
0x000022C2: cc                       int3     
0x000022C3: cc                       int3     
0x000022C4: cc                       int3     
0x000022C5: cc                       int3     
0x000022C6: 66660f1f840000000000     nop      word ptr [rax + rax]
0x000022D0: 4c8bd9                   mov      r11, rcx
0x000022D3: 0fb6d2                   movzx    edx, dl
0x000022D6: 4983f810                 cmp      r8, 0x10
0x000022DA: 0f825c010000             jb       0x18000243c
0x000022E0: 0fba25b470010001         bt       dword ptr [rip + 0x170b4], 1
0x000022E8: 730e                     jae      0x1800022f8
0x000022EA: 57                       push     rdi
0x000022EB: 488bf9                   mov      rdi, rcx
0x000022EE: 8bc2                     mov      eax, edx
0x000022F0: 498bc8                   mov      rcx, r8
0x000022F3: f3aa                     rep stosb byte ptr [rdi], al
0x000022F5: 5f                       pop      rdi
0x000022F6: eb6d                     jmp      0x180002365
0x000022F8: 49b90101010101010101     movabs   r9, 0x101010101010101
0x00002302: 490fafd1                 imul     rdx, r9
0x00002306: 0fba258e70010002         bt       dword ptr [rip + 0x1708e], 2
0x0000230E: 0f829c000000             jb       0x1800023b0
0x00002314: 4983f840                 cmp      r8, 0x40
0x00002318: 721e                     jb       0x180002338
0x0000231A: 48f7d9                   neg      rcx
0x0000231D: 83e107                   and      ecx, 7
0x00002320: 7406                     je       0x180002328
0x00002322: 4c2bc1                   sub      r8, rcx
0x00002325: 498913                   mov      qword ptr [r11], rdx
0x00002328: 4903cb                   add      rcx, r11
0x0000232B: 4d8bc8                   mov      r9, r8
0x0000232E: 4983e03f                 and      r8, 0x3f
0x00002332: 49c1e906                 shr      r9, 6
0x00002336: 753f                     jne      0x180002377
0x00002338: 4d8bc8                   mov      r9, r8
0x0000233B: 4983e007                 and      r8, 7
0x0000233F: 49c1e903                 shr      r9, 3
0x00002343: 7411                     je       0x180002356
0x00002345: 66666690                 nop      
0x00002349: 90                       nop      
0x0000234A: 488911                   mov      qword ptr [rcx], rdx
0x0000234D: 4883c108                 add      rcx, 8
0x00002351: 49ffc9                   dec      r9
0x00002354: 75f4                     jne      0x18000234a
0x00002356: 4d85c0                   test     r8, r8
0x00002359: 740a                     je       0x180002365
0x0000235B: 8811                     mov      byte ptr [rcx], dl
0x0000235D: 48ffc1                   inc      rcx
0x00002360: 49ffc8                   dec      r8
0x00002363: 75f6                     jne      0x18000235b
0x00002365: 498bc3                   mov      rax, r11
0x00002368: c3                       ret      
0x00002369: 0f1f8000000000           nop      dword ptr [rax]
0x00002370: 66666690                 nop      
0x00002374: 666690                   nop      
0x00002377: 488911                   mov      qword ptr [rcx], rdx
0x0000237A: 48895108                 mov      qword ptr [rcx + 8], rdx
0x0000237E: 48895110                 mov      qword ptr [rcx + 0x10], rdx
0x00002382: 4883c140                 add      rcx, 0x40
0x00002386: 488951d8                 mov      qword ptr [rcx - 0x28], rdx
0x0000238A: 488951e0                 mov      qword ptr [rcx - 0x20], rdx
0x0000238E: 49ffc9                   dec      r9
0x00002391: 488951e8                 mov      qword ptr [rcx - 0x18], rdx
0x00002395: 488951f0                 mov      qword ptr [rcx - 0x10], rdx
0x00002399: 488951f8                 mov      qword ptr [rcx - 8], rdx
0x0000239D: 75d8                     jne      0x180002377
0x0000239F: eb97                     jmp      0x180002338
0x000023A1: 666666666666660f1f840000000000 nop      word ptr [rax + rax]
0x000023B0: 66480f6ec2               movq     xmm0, rdx
0x000023B5: 660f60c0                 punpcklbw xmm0, xmm0
0x000023B9: f6c10f                   test     cl, 0xf
0x000023BC: 7416                     je       0x1800023d4
0x000023BE: 0f1101                   movups   xmmword ptr [rcx], xmm0
0x000023C1: 488bc1                   mov      rax, rcx
0x000023C4: 4883e00f                 and      rax, 0xf
0x000023C8: 4883c110                 add      rcx, 0x10
0x000023CC: 482bc8                   sub      rcx, rax
0x000023CF: 4e8d4400f0               lea      r8, [rax + r8 - 0x10]
0x000023D4: 4d8bc8                   mov      r9, r8
0x000023D7: 49c1e907                 shr      r9, 7
0x000023DB: 7432                     je       0x18000240f
0x000023DD: eb01                     jmp      0x1800023e0
0x000023DF: 90                       nop      
0x000023E0: 0f2901                   movaps   xmmword ptr [rcx], xmm0
0x000023E3: 0f294110                 movaps   xmmword ptr [rcx + 0x10], xmm0
0x000023E7: 4881c180000000           add      rcx, 0x80
0x000023EE: 0f2941a0                 movaps   xmmword ptr [rcx - 0x60], xmm0
0x000023F2: 0f2941b0                 movaps   xmmword ptr [rcx - 0x50], xmm0
0x000023F6: 49ffc9                   dec      r9
0x000023F9: 0f2941c0                 movaps   xmmword ptr [rcx - 0x40], xmm0
0x000023FD: 0f2941d0                 movaps   xmmword ptr [rcx - 0x30], xmm0
0x00002401: 0f2941e0                 movaps   xmmword ptr [rcx - 0x20], xmm0
0x00002405: 0f2941f0                 movaps   xmmword ptr [rcx - 0x10], xmm0
0x00002409: 75d5                     jne      0x1800023e0
0x0000240B: 4983e07f                 and      r8, 0x7f
0x0000240F: 4d8bc8                   mov      r9, r8
0x00002412: 49c1e904                 shr      r9, 4
0x00002416: 7414                     je       0x18000242c
0x00002418: 0f1f840000000000         nop      dword ptr [rax + rax]
0x00002420: 0f2901                   movaps   xmmword ptr [rcx], xmm0
0x00002423: 4883c110                 add      rcx, 0x10
0x00002427: 49ffc9                   dec      r9
0x0000242A: 75f4                     jne      0x180002420
0x0000242C: 4983e00f                 and      r8, 0xf
0x00002430: 7406                     je       0x180002438
0x00002432: 410f114408f0             movups   xmmword ptr [r8 + rcx - 0x10], xmm0
0x00002438: 498bc3                   mov      rax, r11
0x0000243B: c3                       ret      
0x0000243C: 49b90101010101010101     movabs   r9, 0x101010101010101
0x00002446: 490fafd1                 imul     rdx, r9
0x0000244A: 4c8d0dafdbffff           lea      r9, [rip - 0x2451]
0x00002451: 438b848165240000         mov      eax, dword ptr [r9 + r8*4 + 0x2465]
0x00002459: 4c03c8                   add      r9, rax
0x0000245C: 4903c8                   add      rcx, r8
0x0000245F: 498bc3                   mov      rax, r11
0x00002462: 41ffe1                   jmp      r9
0x00002465: be240000bb               mov      esi, 0xbb000024
0x0000246A: 2400                     and      al, 0
0x0000246C: 00cc                     add      ah, cl
0x0000246E: 2400                     and      al, 0
0x00002470: 00b7240000e0             add      byte ptr [rdi - 0x1fffffdc], dh
0x00002476: 2400                     and      al, 0
0x00002478: 00d5                     add      ch, dl
0x0000247A: 2400                     and      al, 0
0x0000247C: 00c9                     add      cl, cl
0x0000247E: 2400                     and      al, 0
0x00002480: 00b4240000f524           add      byte ptr [rsp + 0x24f50000], dh
0x00002487: 0000                     add      byte ptr [rax], al
0x00002489: ed                       in       eax, dx
0x0000248A: 2400                     and      al, 0
0x0000248C: 00e4                     add      ah, ah
0x0000248E: 2400                     and      al, 0
0x00002490: 00bf240000dc             add      byte ptr [rdi - 0x23ffffdc], bh
0x00002496: 2400                     and      al, 0
0x00002498: 00d1                     add      cl, dl
0x0000249A: 2400                     and      al, 0
0x0000249C: 00c5                     add      ch, al
0x0000249E: 2400                     and      al, 0
0x000024A0: 00b024000066             add      byte ptr [rax + 0x66000024], dh
0x000024A6: 66660f1f840000000000     nop      word ptr [rax + rax]
0x000024B0: 488951f1                 mov      qword ptr [rcx - 0xf], rdx
0x000024B4: 8951f9                   mov      dword ptr [rcx - 7], edx
0x000024B7: 668951fd                 mov      word ptr [rcx - 3], dx
0x000024BB: 8851ff                   mov      byte ptr [rcx - 1], dl
0x000024BE: c3                       ret      
0x000024BF: 488951f5                 mov      qword ptr [rcx - 0xb], rdx
0x000024C3: ebf2                     jmp      0x1800024b7
0x000024C5: 488951f2                 mov      qword ptr [rcx - 0xe], rdx
0x000024C9: 8951fa                   mov      dword ptr [rcx - 6], edx
0x000024CC: 668951fe                 mov      word ptr [rcx - 2], dx
0x000024D0: c3                       ret      
0x000024D1: 488951f3                 mov      qword ptr [rcx - 0xd], rdx
0x000024D5: 8951fb                   mov      dword ptr [rcx - 5], edx
0x000024D8: 8851ff                   mov      byte ptr [rcx - 1], dl
0x000024DB: c3                       ret      
0x000024DC: 488951f4                 mov      qword ptr [rcx - 0xc], rdx
0x000024E0: 8951fc                   mov      dword ptr [rcx - 4], edx
0x000024E3: c3                       ret      
0x000024E4: 488951f6                 mov      qword ptr [rcx - 0xa], rdx
0x000024E8: 668951fe                 mov      word ptr [rcx - 2], dx
0x000024EC: c3                       ret      
0x000024ED: 488951f7                 mov      qword ptr [rcx - 9], rdx
0x000024F1: 8851ff                   mov      byte ptr [rcx - 1], dl
0x000024F4: c3                       ret      
0x000024F5: 488951f8                 mov      qword ptr [rcx - 8], rdx
0x000024F9: c3                       ret      
0x000024FA: cc                       int3     
0x000024FB: cc                       int3     
0x000024FC: 4053                     push     rbx
0x000024FE: 4883ec20                 sub      rsp, 0x20
0x00002502: 488bd9                   mov      rbx, rcx
0x00002505: 56                       push     rsi
0x00002506: e8b9181e00               call     0x1801e3dc4
0x0000250B: b901000000               mov      ecx, 1
0x00002510: 8905da670100             mov      dword ptr [rip + 0x167da], eax
0x00002516: e87d350000               call     0x180005a98
0x0000251B: 488bcb                   mov      rcx, rbx
0x0000251E: e8992e0000               call     0x1800053bc
0x00002523: 833dc667010000           cmp      dword ptr [rip + 0x167c6], 0
0x0000252A: 750a                     jne      0x180002536
0x0000252C: b901000000               mov      ecx, 1
0x00002531: e862350000               call     0x180005a98
0x00002536: b9090400c0               mov      ecx, 0xc0000409
0x0000253B: 4883c420                 add      rsp, 0x20
0x0000253F: 5b                       pop      rbx
0x00002540: e9572e0000               jmp      0x18000539c
0x00002545: cc                       int3     
0x00002546: cc                       int3     
0x00002547: cc                       int3     
0x00002548: 48894c2408               mov      qword ptr [rsp + 8], rcx
0x0000254D: 4883ec38                 sub      rsp, 0x38
0x00002551: b917000000               mov      ecx, 0x17
0x00002556: e89dc60000               call     0x18000ebf8
0x0000255B: 85c0                     test     eax, eax
0x0000255D: 7407                     je       0x180002566
0x0000255F: b902000000               mov      ecx, 2
0x00002564: cd29                     int      0x29
0x00002566: 488d0db3620100           lea      rcx, [rip + 0x162b3]
0x0000256D: e8ca280000               call     0x180004e3c
0x00002572: 488b442438               mov      rax, qword ptr [rsp + 0x38]
0x00002577: 4889059a630100           mov      qword ptr [rip + 0x1639a], rax
0x0000257E: 488d442438               lea      rax, [rsp + 0x38]
0x00002583: 4883c008                 add      rax, 8
0x00002587: 4889052a630100           mov      qword ptr [rip + 0x1632a], rax
0x0000258E: 488b0583630100           mov      rax, qword ptr [rip + 0x16383]
0x00002595: 488905f4610100           mov      qword ptr [rip + 0x161f4], rax
0x0000259C: 488b442440               mov      rax, qword ptr [rsp + 0x40]
0x000025A1: 488905f8620100           mov      qword ptr [rip + 0x162f8], rax
0x000025A8: c705ce610100090400c0     mov      dword ptr [rip + 0x161ce], 0xc0000409
0x000025B2: c705c861010001000000     mov      dword ptr [rip + 0x161c8], 1
0x000025BC: c705d261010001000000     mov      dword ptr [rip + 0x161d2], 1
0x000025C6: b808000000               mov      eax, 8
0x000025CB: 486bc000                 imul     rax, rax, 0
0x000025CF: 488d0dca610100           lea      rcx, [rip + 0x161ca]
0x000025D6: 48c7040102000000         mov      qword ptr [rcx + rax], 2
0x000025DE: b808000000               mov      eax, 8
0x000025E3: 486bc000                 imul     rax, rax, 0
0x000025E7: 488b0d124a0100           mov      rcx, qword ptr [rip + 0x14a12]
0x000025EE: 48894c0420               mov      qword ptr [rsp + rax + 0x20], rcx
0x000025F3: b808000000               mov      eax, 8
0x000025F8: 486bc001                 imul     rax, rax, 1
0x000025FC: 488b0d054a0100           mov      rcx, qword ptr [rip + 0x14a05]
0x00002603: 48894c0420               mov      qword ptr [rsp + rax + 0x20], rcx
0x00002608: 488d0dd1cd0000           lea      rcx, [rip + 0xcdd1]
0x0000260F: e8e8feffff               call     0x1800024fc
0x00002614: 4883c438                 add      rsp, 0x38
0x00002618: c3                       ret      
0x00002619: cc                       int3     
0x0000261A: cc                       int3     
0x0000261B: cc                       int3     
0x0000261C: 4883ec28                 sub      rsp, 0x28
0x00002620: e8871c0000               call     0x1800042ac
0x00002625: 4885c0                   test     rax, rax
0x00002628: 7509                     jne      0x180002633
0x0000262A: 488d054b4b0100           lea      rax, [rip + 0x14b4b]
0x00002631: eb04                     jmp      0x180002637
0x00002633: 4883c014                 add      rax, 0x14
0x00002637: 4883c428                 add      rsp, 0x28
0x0000263B: c3                       ret      
0x0000263C: 48895c2408               mov      qword ptr [rsp + 8], rbx
0x00002641: 57                       push     rdi
0x00002642: 4883ec20                 sub      rsp, 0x20
0x00002646: 8bf9                     mov      edi, ecx
0x00002648: e85f1c0000               call     0x1800042ac
0x0000264D: 4885c0                   test     rax, rax
0x00002650: 7509                     jne      0x18000265b
0x00002652: 488d05234b0100           lea      rax, [rip + 0x14b23]
0x00002659: eb04                     jmp      0x18000265f
0x0000265B: 4883c014                 add      rax, 0x14
0x0000265F: 8938                     mov      dword ptr [rax], edi
0x00002661: e8461c0000               call     0x1800042ac
0x00002666: 488d1d0b4b0100           lea      rbx, [rip + 0x14b0b]
0x0000266D: 4885c0                   test     rax, rax
0x00002670: 7404                     je       0x180002676
0x00002672: 488d5810                 lea      rbx, [rax + 0x10]
0x00002676: 8bcf                     mov      ecx, edi
0x00002678: e82f000000               call     0x1800026ac
0x0000267D: 8903                     mov      dword ptr [rbx], eax
0x0000267F: 488b5c2430               mov      rbx, qword ptr [rsp + 0x30]
0x00002684: 4883c420                 add      rsp, 0x20
0x00002688: 5f                       pop      rdi
0x00002689: c3                       ret      
0x0000268A: cc                       int3     
0x0000268B: cc                       int3     
0x0000268C: 4883ec28                 sub      rsp, 0x28
0x00002690: e8171c0000               call     0x1800042ac
0x00002695: 4885c0                   test     rax, rax
0x00002698: 7509                     jne      0x1800026a3
0x0000269A: 488d05d74a0100           lea      rax, [rip + 0x14ad7]
0x000026A1: eb04                     jmp      0x1800026a7
0x000026A3: 4883c010                 add      rax, 0x10
0x000026A7: 4883c428                 add      rsp, 0x28
0x000026AB: c3                       ret      
0x000026AC: 4c8d155d490100           lea      r10, [rip + 0x1495d]
0x000026B3: 33d2                     xor      edx, edx
0x000026B5: 4d8bc2                   mov      r8, r10
0x000026B8: 448d4a08                 lea      r9d, [rdx + 8]
0x000026BC: 413b08                   cmp      ecx, dword ptr [r8]
0x000026BF: 742f                     je       0x1800026f0
0x000026C1: ffc2                     inc      edx
0x000026C3: 4d03c1                   add      r8, r9
0x000026C6: 4863c2                   movsxd   rax, edx
0x000026C9: 4883f82d                 cmp      rax, 0x2d
0x000026CD: 72ed                     jb       0x1800026bc
0x000026CF: 8d41ed                   lea      eax, [rcx - 0x13]
0x000026D2: 83f811                   cmp      eax, 0x11
0x000026D5: 7706                     ja       0x1800026dd
0x000026D7: b80d000000               mov      eax, 0xd
0x000026DC: c3                       ret      
0x000026DD: 81c144ffffff             add      ecx, 0xffffff44
0x000026E3: b816000000               mov      eax, 0x16
0x000026E8: 83f90e                   cmp      ecx, 0xe
0x000026EB: 410f46c1                 cmovbe   eax, r9d
0x000026EF: c3                       ret      
0x000026F0: 4863c2                   movsxd   rax, edx
0x000026F3: 418b44c204               mov      eax, dword ptr [r10 + rax*8 + 4]
0x000026F8: c3                       ret      
0x000026F9: cc                       int3     
0x000026FA: cc                       int3     
0x000026FB: cc                       int3     
0x000026FC: 4883ec28                 sub      rsp, 0x28
0x00002700: 50                       push     rax
0x00002701: e8d9651600               call     0x180168cdf
0x00002706: 33c9                     xor      ecx, ecx
0x00002708: 4885c0                   test     rax, rax
0x0000270B: 488905e6650100           mov      qword ptr [rip + 0x165e6], rax
0x00002712: 0f95c1                   setne    cl
0x00002715: 8bc1                     mov      eax, ecx
0x00002717: 4883c428                 add      rsp, 0x28
0x0000271B: c3                       ret      
0x0000271C: 488325d465010000         and      qword ptr [rip + 0x165d4], 0
0x00002724: c3                       ret      
0x00002725: cc                       int3     
0x00002726: cc                       int3     
0x00002727: cc                       int3     
0x00002728: 4053                     push     rbx
0x0000272A: 4883ec20                 sub      rsp, 0x20
0x0000272E: 488bd9                   mov      rbx, rcx
0x00002731: 488b0dc8650100           mov      rcx, qword ptr [rip + 0x165c8]
0x00002738: e843c31e00               call     0x1801eea80
0x0000273D: c5                       .byte    0xc5
0x0000273E: 4885c0                   test     rax, rax
0x00002741: 7410                     je       0x180002753
0x00002743: 488bcb                   mov      rcx, rbx
0x00002746: ffd0                     call     rax
0x00002748: 85c0                     test     eax, eax
0x0000274A: 7407                     je       0x180002753
0x0000274C: b801000000               mov      eax, 1
0x00002751: eb02                     jmp      0x180002755
0x00002753: 33c0                     xor      eax, eax
0x00002755: 4883c420                 add      rsp, 0x20
0x00002759: 5b                       pop      rbx
0x0000275A: c3                       ret      
0x0000275B: cc                       int3     
0x0000275C: 48890d9d650100           mov      qword ptr [rip + 0x1659d], rcx
0x00002763: c3                       ret      
0x00002764: 488bc4                   mov      rax, rsp
0x00002767: 48895808                 mov      qword ptr [rax + 8], rbx
0x0000276B: 48896810                 mov      qword ptr [rax + 0x10], rbp
0x0000276F: 48897018                 mov      qword ptr [rax + 0x18], rsi
0x00002773: 48897820                 mov      qword ptr [rax + 0x20], rdi
0x00002777: 4157                     push     r15
0x00002779: 4883ec30                 sub      rsp, 0x30
0x0000277D: 33ff                     xor      edi, edi
0x0000277F: 488bda                   mov      rbx, rdx
0x00002782: 488bf1                   mov      rsi, rcx
0x00002785: 4885c9                   test     rcx, rcx
0x00002788: 7518                     jne      0x1800027a2
0x0000278A: e8fdfeffff               call     0x18000268c
0x0000278F: bb16000000               mov      ebx, 0x16
0x00002794: 8918                     mov      dword ptr [rax], ebx
0x00002796: e809110000               call     0x1800038a4
0x0000279B: 8bc3                     mov      eax, ebx
0x0000279D: e9a7000000               jmp      0x180002849
0x000027A2: 4885d2                   test     rdx, rdx
0x000027A5: 74e3                     je       0x18000278a
0x000027A7: e8a0270000               call     0x180004f4c
0x000027AC: 41bf01000000             mov      r15d, 1
0x000027B2: 85c0                     test     eax, eax
0x000027B4: 750c                     jne      0x1800027c2
0x000027B6: e8f3701800               call     0x1801898ae
0x000027BB: e385                     jrcxz    0x180002742
0x000027BD: c0410f44                 rol      byte ptr [rcx + 0xf], 0x44
0x000027C1: ff8364242800             inc      dword ptr [rbx + 0x282464]
0x000027C7: 48832300                 and      qword ptr [rbx], 0
0x000027CB: 488364242000             and      qword ptr [rsp + 0x20], 0
0x000027D1: 4183c9ff                 or       r9d, 0xffffffff
0x000027D5: 4c8bc6                   mov      r8, rsi
0x000027D8: 33d2                     xor      edx, edx
0x000027DA: 8bcf                     mov      ecx, edi
0x000027DC: 57                       push     rdi
0x000027DD: e8ffaa2200               call     0x18022d2e1
0x000027E2: 4863e8                   movsxd   rbp, eax
0x000027E5: 85c0                     test     eax, eax
0x000027E7: 7511                     jne      0x1800027fa
0x000027E9: 56                       push     rsi
0x000027EA: e864862200               call     0x18022ae53
0x000027EF: 8bc8                     mov      ecx, eax
0x000027F1: e846feffff               call     0x18000263c
0x000027F6: 33c0                     xor      eax, eax
0x000027F8: eb4f                     jmp      0x180002849
0x000027FA: 488bcd                   mov      rcx, rbp
0x000027FD: 4803c9                   add      rcx, rcx
0x00002800: e8d30b0000               call     0x1800033d8
0x00002805: 488903                   mov      qword ptr [rbx], rax
0x00002808: 4885c0                   test     rax, rax
0x0000280B: 74e9                     je       0x1800027f6
0x0000280D: 4183c9ff                 or       r9d, 0xffffffff
0x00002811: 4c8bc6                   mov      r8, rsi
0x00002814: 33d2                     xor      edx, edx
0x00002816: 8bcf                     mov      ecx, edi
0x00002818: 896c2428                 mov      dword ptr [rsp + 0x28], ebp
0x0000281C: 4889442420               mov      qword ptr [rsp + 0x20], rax
0x00002821: 56                       push     rsi
0x00002822: e824521200               call     0x180127a4b
0x00002827: 85c0                     test     eax, eax
0x00002829: 751b                     jne      0x180002846
0x0000282B: e8de831000               call     0x18010ac0e
0x00002830: dc8bc8e804fe             fmul     qword ptr [rbx - 0x1fb1738]
0x00002836: ff                       .byte    0xff
0x00002837: ff488b                   dec      dword ptr [rax - 0x75]
0x0000283A: 0be8                     or       ebp, eax
0x0000283C: f0                       .byte    0xf0
0x0000283D: ef                       out      dx, eax
0x0000283E: ff                       .byte    0xff
0x0000283F: ff4883                   dec      dword ptr [rax - 0x7d]
0x00002842: 2300                     and      eax, dword ptr [rax]
0x00002844: ebb0                     jmp      0x1800027f6
0x00002846: 418bc7                   mov      eax, r15d
0x00002849: 488b5c2440               mov      rbx, qword ptr [rsp + 0x40]
0x0000284E: 488b6c2448               mov      rbp, qword ptr [rsp + 0x48]
0x00002853: 488b742450               mov      rsi, qword ptr [rsp + 0x50]
0x00002858: 488b7c2458               mov      rdi, qword ptr [rsp + 0x58]
0x0000285D: 4883c430                 add      rsp, 0x30
0x00002861: 415f                     pop      r15
0x00002863: c3                       ret      
0x00002864: 488bc4                   mov      rax, rsp
0x00002867: 48895808                 mov      qword ptr [rax + 8], rbx
0x0000286B: 48896810                 mov      qword ptr [rax + 0x10], rbp
0x0000286F: 48897018                 mov      qword ptr [rax + 0x18], rsi
0x00002873: 48897820                 mov      qword ptr [rax + 0x20], rdi
0x00002877: 4157                     push     r15
0x00002879: 4883ec40                 sub      rsp, 0x40
0x0000287D: 33ff                     xor      edi, edi
0x0000287F: 488bda                   mov      rbx, rdx
0x00002882: 488bf1                   mov      rsi, rcx
0x00002885: 4885c9                   test     rcx, rcx
0x00002888: 7518                     jne      0x1800028a2
0x0000288A: e8fdfdffff               call     0x18000268c
0x0000288F: bb16000000               mov      ebx, 0x16
0x00002894: 8918                     mov      dword ptr [rax], ebx
0x00002896: e809100000               call     0x1800038a4
0x0000289B: 8bc3                     mov      eax, ebx
0x0000289D: e9bc000000               jmp      0x18000295e
0x000028A2: 4885d2                   test     rdx, rdx
0x000028A5: 74e3                     je       0x18000288a
0x000028A7: e8a0260000               call     0x180004f4c
0x000028AC: 41bf01000000             mov      r15d, 1
0x000028B2: 85c0                     test     eax, eax
0x000028B4: 750c                     jne      0x1800028c2
0x000028B6: 51                       push     rcx
0x000028B7: e86b2a1c00               call     0x1801c5327
0x000028BC: 85c0                     test     eax, eax
0x000028BE: 410f44ff                 cmove    edi, r15d
0x000028C2: 488364243800             and      qword ptr [rsp + 0x38], 0
0x000028C8: 488364243000             and      qword ptr [rsp + 0x30], 0
0x000028CE: 8364242800               and      dword ptr [rsp + 0x28], 0
0x000028D3: 488364242000             and      qword ptr [rsp + 0x20], 0
0x000028D9: 48832300                 and      qword ptr [rbx], 0
0x000028DD: 4183c9ff                 or       r9d, 0xffffffff
0x000028E1: 4c8bc6                   mov      r8, rsi
0x000028E4: 33d2                     xor      edx, edx
0x000028E6: 8bcf                     mov      ecx, edi
0x000028E8: e8710e0300               call     0x18003375e
0x000028ED: eb48                     jmp      0x180002937
0x000028EF: 63                       .byte    0x63
0x000028F0: e885c07511               call     0x19175e97a
0x000028F5: 55                       push     rbp
0x000028F6: e8ae391c00               call     0x1801c62a9
0x000028FB: 8bc8                     mov      ecx, eax
0x000028FD: e83afdffff               call     0x18000263c
0x00002902: 33c0                     xor      eax, eax
0x00002904: eb58                     jmp      0x18000295e
0x00002906: 488bcd                   mov      rcx, rbp
0x00002909: e8ca0a0000               call     0x1800033d8
0x0000290E: 488903                   mov      qword ptr [rbx], rax
0x00002911: 4885c0                   test     rax, rax
0x00002914: 74ec                     je       0x180002902
0x00002916: 488364243800             and      qword ptr [rsp + 0x38], 0
0x0000291C: 488364243000             and      qword ptr [rsp + 0x30], 0
0x00002922: 4183c9ff                 or       r9d, 0xffffffff
0x00002926: 4c8bc6                   mov      r8, rsi
0x00002929: 33d2                     xor      edx, edx
0x0000292B: 8bcf                     mov      ecx, edi
0x0000292D: 896c2428                 mov      dword ptr [rsp + 0x28], ebp
0x00002931: 4889442420               mov      qword ptr [rsp + 0x20], rax
0x00002936: 53                       push     rbx
0x00002937: e81f2e0200               call     0x18002575b
0x0000293C: 85c0                     test     eax, eax
0x0000293E: 751b                     jne      0x18000295b
0x00002940: 52                       push     rdx
0x00002941: e8b1f40200               call     0x180031df7
0x00002946: 8bc8                     mov      ecx, eax
0x00002948: e8effcffff               call     0x18000263c
0x0000294D: 488b0b                   mov      rcx, qword ptr [rbx]
0x00002950: e8dbeeffff               call     0x180001830
0x00002955: 48832300                 and      qword ptr [rbx], 0
0x00002959: eba7                     jmp      0x180002902
0x0000295B: 418bc7                   mov      eax, r15d
0x0000295E: 488b5c2450               mov      rbx, qword ptr [rsp + 0x50]
0x00002963: 488b6c2458               mov      rbp, qword ptr [rsp + 0x58]
0x00002968: 488b742460               mov      rsi, qword ptr [rsp + 0x60]
0x0000296D: 488b7c2468               mov      rdi, qword ptr [rsp + 0x68]
0x00002972: 4883c440                 add      rsp, 0x40
0x00002976: 415f                     pop      r15
0x00002978: c3                       ret      
0x00002979: cc                       int3     
0x0000297A: cc                       int3     
0x0000297B: cc                       int3     
0x0000297C: 4053                     push     rbx
0x0000297E: 4883ec20                 sub      rsp, 0x20
0x00002982: 8bd9                     mov      ebx, ecx
0x00002984: 4c8d442438               lea      r8, [rsp + 0x38]
0x00002989: 488d1560ca0000           lea      rdx, [rip + 0xca60]
0x00002990: 33c9                     xor      ecx, ecx
0x00002992: e888281500               call     0x18015521f
0x00002997: fc                       cld      
0x00002998: 85c0                     test     eax, eax
0x0000299A: 741b                     je       0x1800029b7
0x0000299C: 488b4c2438               mov      rcx, qword ptr [rsp + 0x38]
0x000029A1: 488d1560ca0000           lea      rdx, [rip + 0xca60]
0x000029A8: 51                       push     rcx
0x000029A9: e8eb0d0f00               call     0x1800f3799
0x000029AE: 4885c0                   test     rax, rax
0x000029B1: 7404                     je       0x1800029b7
0x000029B3: 8bcb                     mov      ecx, ebx
0x000029B5: ffd0                     call     rax
0x000029B7: 4883c420                 add      rsp, 0x20
0x000029BB: 5b                       pop      rbx
0x000029BC: c3                       ret      
0x000029BD: cc                       int3     
0x000029BE: cc                       int3     
0x000029BF: cc                       int3     
0x000029C0: 4053                     push     rbx
0x000029C2: 4883ec20                 sub      rsp, 0x20
0x000029C6: 8bd9                     mov      ebx, ecx
0x000029C8: e8afffffff               call     0x18000297c
0x000029CD: 8bcb                     mov      ecx, ebx
0x000029CF: 50                       push     rax
0x000029D0: e8a61c1b00               call     0x1801b467b
0x000029D5: cc                       int3     
0x000029D6: cc                       int3     
0x000029D7: cc                       int3     
0x000029D8: 48895c2408               mov      qword ptr [rsp + 8], rbx
0x000029DD: 57                       push     rdi
0x000029DE: 4883ec20                 sub      rsp, 0x20
0x000029E2: 488b0dbfad0100           mov      rcx, qword ptr [rip + 0x1adbf]
0x000029E9: e873700200               call     0x180029a61
0x000029EE: 7b48                     jnp      0x180002a38
0x000029F0: 8b1d32630100             mov      ebx, dword ptr [rip + 0x16332]
0x000029F6: 488bf8                   mov      rdi, rax
0x000029F9: 4885db                   test     rbx, rbx
0x000029FC: 741a                     je       0x180002a18
0x000029FE: 488b0b                   mov      rcx, qword ptr [rbx]
0x00002A01: 4885c9                   test     rcx, rcx
0x00002A04: 740b                     je       0x180002a11
0x00002A06: e825eeffff               call     0x180001830
0x00002A0B: 4883c308                 add      rbx, 8
0x00002A0F: 75ed                     jne      0x1800029fe
0x00002A11: 488b1d10630100           mov      rbx, qword ptr [rip + 0x16310]
0x00002A18: 488bcb                   mov      rcx, rbx
0x00002A1B: e810eeffff               call     0x180001830
0x00002A20: 488b1df9620100           mov      rbx, qword ptr [rip + 0x162f9]
0x00002A27: 488325f962010000         and      qword ptr [rip + 0x162f9], 0
0x00002A2F: 4885db                   test     rbx, rbx
0x00002A32: 741a                     je       0x180002a4e
0x00002A34: 488b0b                   mov      rcx, qword ptr [rbx]
0x00002A37: 4885c9                   test     rcx, rcx
0x00002A3A: 740b                     je       0x180002a47
0x00002A3C: e8efedffff               call     0x180001830
0x00002A41: 4883c308                 add      rbx, 8
0x00002A45: 75ed                     jne      0x180002a34
0x00002A47: 488b1dd2620100           mov      rbx, qword ptr [rip + 0x162d2]
0x00002A4E: 488bcb                   mov      rcx, rbx
0x00002A51: e8daedffff               call     0x180001830
0x00002A56: 488b0dbb620100           mov      rcx, qword ptr [rip + 0x162bb]
0x00002A5D: 488325bb62010000         and      qword ptr [rip + 0x162bb], 0
0x00002A65: e8c6edffff               call     0x180001830
0x00002A6A: 488b0d9f620100           mov      rcx, qword ptr [rip + 0x1629f]
0x00002A71: e8baedffff               call     0x180001830
0x00002A76: 4883259a62010000         and      qword ptr [rip + 0x1629a], 0
0x00002A7E: 4883258a62010000         and      qword ptr [rip + 0x1628a], 0
0x00002A86: 4883cbff                 or       rbx, 0xffffffffffffffff
0x00002A8A: 483bfb                   cmp      rdi, rbx
0x00002A8D: 7412                     je       0x180002aa1
0x00002A8F: 48833d11ad010000         cmp      qword ptr [rip + 0x1ad11], 0
0x00002A97: 7408                     je       0x180002aa1
0x00002A99: 488bcf                   mov      rcx, rdi
0x00002A9C: e88fedffff               call     0x180001830
0x00002AA1: 488bcb                   mov      rcx, rbx
0x00002AA4: e893fc1d00               call     0x1801e273c
0x00002AA9: 99                       cdq      
0x00002AAA: 488b0db76e0100           mov      rcx, qword ptr [rip + 0x16eb7]
0x00002AB1: 488905f0ac0100           mov      qword ptr [rip + 0x1acf0], rax
0x00002AB8: 4885c9                   test     rcx, rcx
0x00002ABB: 740d                     je       0x180002aca
0x00002ABD: e86eedffff               call     0x180001830
0x00002AC2: 4883259e6e010000         and      qword ptr [rip + 0x16e9e], 0
0x00002ACA: 488b0d9f6e0100           mov      rcx, qword ptr [rip + 0x16e9f]
0x00002AD1: 4885c9                   test     rcx, rcx
0x00002AD4: 740d                     je       0x180002ae3
0x00002AD6: e855edffff               call     0x180001830
0x00002ADB: 4883258d6e010000         and      qword ptr [rip + 0x16e8d], 0
0x00002AE3: 488b05d64e0100           mov      rax, qword ptr [rip + 0x14ed6]
0x00002AEA: 8bcb                     mov      ecx, ebx
0x00002AEC: f00fc108                 lock xadd dword ptr [rax], ecx
0x00002AF0: 03cb                     add      ecx, ebx
0x00002AF2: 751f                     jne      0x180002b13
0x00002AF4: 488b0dc54e0100           mov      rcx, qword ptr [rip + 0x14ec5]
0x00002AFB: 488d1d9e4b0100           lea      rbx, [rip + 0x14b9e]
0x00002B02: 483bcb                   cmp      rcx, rbx
0x00002B05: 740c                     je       0x180002b13
0x00002B07: e824edffff               call     0x180001830
0x00002B0C: 48891dad4e0100           mov      qword ptr [rip + 0x14ead], rbx
0x00002B13: 488b5c2430               mov      rbx, qword ptr [rsp + 0x30]
0x00002B18: 4883c420                 add      rsp, 0x20
0x00002B1C: 5f                       pop      rdi
0x00002B1D: c3                       ret      
0x00002B1E: cc                       int3     
0x00002B1F: cc                       int3     
0x00002B20: 4053                     push     rbx
0x00002B22: 4883ec20                 sub      rsp, 0x20
0x00002B26: 8bd9                     mov      ebx, ecx
0x00002B28: e867030000               call     0x180002e94
0x00002B2D: 8bcb                     mov      ecx, ebx
0x00002B2F: e8d4030000               call     0x180002f08
0x00002B34: 4533c0                   xor      r8d, r8d
0x00002B37: b9ff000000               mov      ecx, 0xff
0x00002B3C: 418d5001                 lea      edx, [r8 + 1]
0x00002B40: e8b7010000               call     0x180002cfc
0x00002B45: cc                       int3     
0x00002B46: cc                       int3     
0x00002B47: cc                       int3     
0x00002B48: 33d2                     xor      edx, edx
0x00002B4A: 33c9                     xor      ecx, ecx
0x00002B4C: 448d4201                 lea      r8d, [rdx + 1]
0x00002B50: e9a7010000               jmp      0x180002cfc
0x00002B55: cc                       int3     
0x00002B56: cc                       int3     
0x00002B57: cc                       int3     
0x00002B58: 4053                     push     rbx
0x00002B5A: 4883ec20                 sub      rsp, 0x20
0x00002B5E: 48833d0a22010000         cmp      qword ptr [rip + 0x1220a], 0
0x00002B66: 8bd9                     mov      ebx, ecx
0x00002B68: 7418                     je       0x180002b82
0x00002B6A: 488d0dff210100           lea      rcx, [rip + 0x121ff]
0x00002B71: e88a310000               call     0x180005d00
0x00002B76: 85c0                     test     eax, eax
0x00002B78: 7408                     je       0x180002b82
0x00002B7A: 8bcb                     mov      ecx, ebx
0x00002B7C: ff15ee210100             call     qword ptr [rip + 0x121ee]
0x00002B82: e8f9310000               call     0x180005d80
0x00002B87: 488d1532c70000           lea      rdx, [rip + 0xc732]
0x00002B8E: 488d0d03c70000           lea      rcx, [rip + 0xc703]
0x00002B95: e80e010000               call     0x180002ca8
0x00002B9A: 85c0                     test     eax, eax
0x00002B9C: 754a                     jne      0x180002be8
0x00002B9E: 488d0d6f280000           lea      rcx, [rip + 0x286f]
0x00002BA5: e8aef0ffff               call     0x180001c58
0x00002BAA: 488d15dfc60000           lea      rdx, [rip + 0xc6df]
0x00002BB1: 488d0dc8c60000           lea      rcx, [rip + 0xc6c8]
0x00002BB8: e88b000000               call     0x180002c48
0x00002BBD: 48833dd3ab010000         cmp      qword ptr [rip + 0x1abd3], 0
0x00002BC5: 741f                     je       0x180002be6
0x00002BC7: 488d0dcaab0100           lea      rcx, [rip + 0x1abca]
0x00002BCE: e82d310000               call     0x180005d00
0x00002BD3: 85c0                     test     eax, eax
0x00002BD5: 740f                     je       0x180002be6
0x00002BD7: 4533c0                   xor      r8d, r8d
0x00002BDA: 33c9                     xor      ecx, ecx
0x00002BDC: 418d5002                 lea      edx, [r8 + 2]
0x00002BE0: ff15b2ab0100             call     qword ptr [rip + 0x1abb2]
0x00002BE6: 33c0                     xor      eax, eax
0x00002BE8: 4883c420                 add      rsp, 0x20
0x00002BEC: 5b                       pop      rbx
0x00002BED: c3                       ret      
0x00002BEE: cc                       int3     
0x00002BEF: cc                       int3     
0x00002BF0: 4533c0                   xor      r8d, r8d
0x00002BF3: 418d5001                 lea      edx, [r8 + 1]
0x00002BF7: e900010000               jmp      0x180002cfc
0x00002BFC: 4053                     push     rbx
0x00002BFE: 4883ec20                 sub      rsp, 0x20
0x00002C02: 33c9                     xor      ecx, ecx
0x00002C04: e8a3fc2100               call     0x1802228ac
0x00002C09: 5b                       pop      rbx
0x00002C0A: 488bc8                   mov      rcx, rax
0x00002C0D: 488bd8                   mov      rbx, rax
0x00002C10: e847fbffff               call     0x18000275c
0x00002C15: 488bcb                   mov      rcx, rbx
0x00002C18: e8170c0000               call     0x180003834
0x00002C1D: 488bcb                   mov      rcx, rbx
0x00002C20: e8d7310000               call     0x180005dfc
0x00002C25: 488bcb                   mov      rcx, rbx
0x00002C28: e8e7310000               call     0x180005e14
0x00002C2D: 488bcb                   mov      rcx, rbx
0x00002C30: e8a7310000               call     0x180005ddc
0x00002C35: 488bcb                   mov      rcx, rbx
0x00002C38: e82b340000               call     0x180006068
0x00002C3D: 4883c420                 add      rsp, 0x20
0x00002C41: 5b                       pop      rbx
0x00002C42: e951230000               jmp      0x180004f98
0x00002C47: cc                       int3     
0x00002C48: 48895c2408               mov      qword ptr [rsp + 8], rbx
0x00002C4D: 48896c2410               mov      qword ptr [rsp + 0x10], rbp
0x00002C52: 4889742418               mov      qword ptr [rsp + 0x18], rsi
0x00002C57: 57                       push     rdi
0x00002C58: 4883ec20                 sub      rsp, 0x20
0x00002C5C: 33ed                     xor      ebp, ebp
0x00002C5E: 488bda                   mov      rbx, rdx
0x00002C61: 488bf9                   mov      rdi, rcx
0x00002C64: 482bd9                   sub      rbx, rcx
0x00002C67: 8bf5                     mov      esi, ebp
0x00002C69: 4883c307                 add      rbx, 7
0x00002C6D: 48c1eb03                 shr      rbx, 3
0x00002C71: 483bca                   cmp      rcx, rdx
0x00002C74: 480f47dd                 cmova    rbx, rbp
0x00002C78: 4885db                   test     rbx, rbx
0x00002C7B: 7416                     je       0x180002c93
0x00002C7D: 488b07                   mov      rax, qword ptr [rdi]
0x00002C80: 4885c0                   test     rax, rax
0x00002C83: 7402                     je       0x180002c87
0x00002C85: ffd0                     call     rax
0x00002C87: 48ffc6                   inc      rsi
0x00002C8A: 4883c708                 add      rdi, 8
0x00002C8E: 483bf3                   cmp      rsi, rbx
0x00002C91: 72ea                     jb       0x180002c7d
0x00002C93: 488b5c2430               mov      rbx, qword ptr [rsp + 0x30]
0x00002C98: 488b6c2438               mov      rbp, qword ptr [rsp + 0x38]
0x00002C9D: 488b742440               mov      rsi, qword ptr [rsp + 0x40]
0x00002CA2: 4883c420                 add      rsp, 0x20
0x00002CA6: 5f                       pop      rdi
0x00002CA7: c3                       ret      
0x00002CA8: 48895c2408               mov      qword ptr [rsp + 8], rbx
0x00002CAD: 57                       push     rdi
0x00002CAE: 4883ec20                 sub      rsp, 0x20
0x00002CB2: 33c0                     xor      eax, eax
0x00002CB4: 488bfa                   mov      rdi, rdx
0x00002CB7: 488bd9                   mov      rbx, rcx
0x00002CBA: 483bca                   cmp      rcx, rdx
0x00002CBD: 7317                     jae      0x180002cd6
0x00002CBF: 85c0                     test     eax, eax
0x00002CC1: 7513                     jne      0x180002cd6
0x00002CC3: 488b0b                   mov      rcx, qword ptr [rbx]
0x00002CC6: 4885c9                   test     rcx, rcx
0x00002CC9: 7402                     je       0x180002ccd
0x00002CCB: ffd1                     call     rcx
0x00002CCD: 4883c308                 add      rbx, 8
0x00002CD1: 483bdf                   cmp      rbx, rdi
0x00002CD4: 72e9                     jb       0x180002cbf
0x00002CD6: 488b5c2430               mov      rbx, qword ptr [rsp + 0x30]
0x00002CDB: 4883c420                 add      rsp, 0x20
0x00002CDF: 5f                       pop      rdi
0x00002CE0: c3                       ret      
0x00002CE1: cc                       int3     
0x00002CE2: cc                       int3     
0x00002CE3: cc                       int3     
0x00002CE4: b908000000               mov      ecx, 8
0x00002CE9: e9b22d0000               jmp      0x180005aa0
0x00002CEE: cc                       int3     
0x00002CEF: cc                       int3     
0x00002CF0: b908000000               mov      ecx, 8
0x00002CF5: e9962f0000               jmp      0x180005c90
0x00002CFA: cc                       int3     
0x00002CFB: cc                       int3     
0x00002CFC: 48895c2408               mov      qword ptr [rsp + 8], rbx
0x00002D01: 4889742410               mov      qword ptr [rsp + 0x10], rsi
0x00002D06: 4489442418               mov      dword ptr [rsp + 0x18], r8d
0x00002D0B: 57                       push     rdi
0x00002D0C: 4154                     push     r12
0x00002D0E: 4155                     push     r13
0x00002D10: 4156                     push     r14
0x00002D12: 4157                     push     r15
0x00002D14: 4883ec40                 sub      rsp, 0x40
0x00002D18: 458bf0                   mov      r14d, r8d
0x00002D1B: 8bda                     mov      ebx, edx
0x00002D1D: 448be9                   mov      r13d, ecx
0x00002D20: b908000000               mov      ecx, 8
0x00002D25: e8762d0000               call     0x180005aa0
0x00002D2A: 90                       nop      
0x00002D2B: 833dd65f010001           cmp      dword ptr [rip + 0x15fd6], 1
0x00002D32: 0f8407010000             je       0x180002e3f
0x00002D38: c7050660010001000000     mov      dword ptr [rip + 0x16006], 1
0x00002D42: 448835fb5f0100           mov      byte ptr [rip + 0x15ffb], r14b
0x00002D49: 85db                     test     ebx, ebx
0x00002D4B: 0f85da000000             jne      0x180002e2b
0x00002D51: 488b0d50aa0100           mov      rcx, qword ptr [rip + 0x1aa50]
0x00002D58: e831b72200               call     0x18022e48e
0x00002D5D: f6488bf0                 test     byte ptr [rax - 0x75], -0x10
0x00002D61: 4889442430               mov      qword ptr [rsp + 0x30], rax
0x00002D66: 4885c0                   test     rax, rax
0x00002D69: 0f84a9000000             je       0x180002e18
0x00002D6F: 488b0d2aaa0100           mov      rcx, qword ptr [rip + 0x1aa2a]
0x00002D76: e811251e00               call     0x1801e528c
0x00002D7B: f4                       hlt      
0x00002D7C: 488bf8                   mov      rdi, rax
0x00002D7F: 4889442420               mov      qword ptr [rsp + 0x20], rax
0x00002D84: 4c8be6                   mov      r12, rsi
0x00002D87: 4889742428               mov      qword ptr [rsp + 0x28], rsi
0x00002D8C: 4c8bf8                   mov      r15, rax
0x00002D8F: 4889442438               mov      qword ptr [rsp + 0x38], rax
0x00002D94: 4883ef08                 sub      rdi, 8
0x00002D98: 48897c2420               mov      qword ptr [rsp + 0x20], rdi
0x00002D9D: 483bfe                   cmp      rdi, rsi
0x00002DA0: 7276                     jb       0x180002e18
0x00002DA2: 33c9                     xor      ecx, ecx
0x00002DA4: e8c12e0c00               call     0x1800c5c6a
0x00002DA9: 3b4839                   cmp      ecx, dword ptr [rax + 0x39]
0x00002DAC: 07                       .byte    0x07
0x00002DAD: 7502                     jne      0x180002db1
0x00002DAF: ebe3                     jmp      0x180002d94
0x00002DB1: 483bfe                   cmp      rdi, rsi
0x00002DB4: 7262                     jb       0x180002e18
0x00002DB6: 488b0f                   mov      rcx, qword ptr [rdi]
0x00002DB9: e801b41e00               call     0x1801ee1bf
0x00002DBE: 8d488b                   lea      ecx, [rax - 0x75]
0x00002DC1: d833                     fdiv     dword ptr [rbx]
0x00002DC3: c9                       leave    
0x00002DC4: e890862600               call     0x18026b459
0x00002DC9: 53                       push     rbx
0x00002DCA: 488907                   mov      qword ptr [rdi], rax
0x00002DCD: ffd3                     call     rbx
0x00002DCF: 488b0dd2a90100           mov      rcx, qword ptr [rip + 0x1a9d2]
0x00002DD6: 56                       push     rsi
0x00002DD7: e8ac370c00               call     0x1800c6588
0x00002DDC: 488bd8                   mov      rbx, rax
0x00002DDF: 488b0dbaa90100           mov      rcx, qword ptr [rip + 0x1a9ba]
0x00002DE6: e81ddd1e00               call     0x1801f0b08
0x00002DEB: 3b4c3be3                 cmp      ecx, dword ptr [rbx + rdi - 0x1d]
0x00002DEF: 7505                     jne      0x180002df6
0x00002DF1: 4c3bf8                   cmp      r15, rax
0x00002DF4: 74b9                     je       0x180002daf
0x00002DF6: 4c8be3                   mov      r12, rbx
0x00002DF9: 48895c2428               mov      qword ptr [rsp + 0x28], rbx
0x00002DFE: 488bf3                   mov      rsi, rbx
0x00002E01: 48895c2430               mov      qword ptr [rsp + 0x30], rbx
0x00002E06: 4c8bf8                   mov      r15, rax
0x00002E09: 4889442438               mov      qword ptr [rsp + 0x38], rax
0x00002E0E: 488bf8                   mov      rdi, rax
0x00002E11: 4889442420               mov      qword ptr [rsp + 0x20], rax
0x00002E16: eb97                     jmp      0x180002daf
0x00002E18: 488d15c9c40000           lea      rdx, [rip + 0xc4c9]
0x00002E1F: 488d0da2c40000           lea      rcx, [rip + 0xc4a2]
0x00002E26: e81dfeffff               call     0x180002c48
0x00002E2B: 488d15c6c40000           lea      rdx, [rip + 0xc4c6]
0x00002E32: 488d0db7c40000           lea      rcx, [rip + 0xc4b7]
0x00002E39: e80afeffff               call     0x180002c48
0x00002E3E: 90                       nop      
0x00002E3F: 4585f6                   test     r14d, r14d
0x00002E42: 740f                     je       0x180002e53
0x00002E44: b908000000               mov      ecx, 8
0x00002E49: e8422e0000               call     0x180005c90
0x00002E4E: 4585f6                   test     r14d, r14d
0x00002E51: 7526                     jne      0x180002e79
0x00002E53: c705ab5e010001000000     mov      dword ptr [rip + 0x15eab], 1
0x00002E5D: b908000000               mov      ecx, 8
0x00002E62: e8292e0000               call     0x180005c90
0x00002E67: 418bcd                   mov      ecx, r13d
0x00002E6A: e80dfbffff               call     0x18000297c
0x00002E6F: 418bcd                   mov      ecx, r13d
0x00002E72: 50                       push     rax
0x00002E73: e8bff01400               call     0x180151f37
0x00002E78: cc                       int3     
0x00002E79: 488b5c2470               mov      rbx, qword ptr [rsp + 0x70]
0x00002E7E: 488b742478               mov      rsi, qword ptr [rsp + 0x78]
0x00002E83: 4883c440                 add      rsp, 0x40
0x00002E87: 415f                     pop      r15
0x00002E89: 415e                     pop      r14
0x00002E8B: 415d                     pop      r13
0x00002E8D: 415c                     pop      r12
0x00002E8F: 5f                       pop      rdi
0x00002E90: c3                       ret      
0x00002E91: cc                       int3     
0x00002E92: cc                       int3     
0x00002E93: cc                       int3     
0x00002E94: 4883ec28                 sub      rsp, 0x28
0x00002E98: b903000000               mov      ecx, 3
0x00002E9D: e8e23d0000               call     0x180006c84
0x00002EA2: 83f801                   cmp      eax, 1
0x00002EA5: 7417                     je       0x180002ebe
0x00002EA7: b903000000               mov      ecx, 3
0x00002EAC: e8d33d0000               call     0x180006c84
0x00002EB1: 85c0                     test     eax, eax
0x00002EB3: 751d                     jne      0x180002ed2
0x00002EB5: 833da45e010001           cmp      dword ptr [rip + 0x15ea4], 1
0x00002EBC: 7514                     jne      0x180002ed2
0x00002EBE: b9fc000000               mov      ecx, 0xfc
0x00002EC3: e840000000               call     0x180002f08
0x00002EC8: b9ff000000               mov      ecx, 0xff
0x00002ECD: e836000000               call     0x180002f08
0x00002ED2: 4883c428                 add      rsp, 0x28
0x00002ED6: c3                       ret      
0x00002ED7: cc                       int3     
0x00002ED8: 4c8d0d41c50000           lea      r9, [rip + 0xc541]
0x00002EDF: 33d2                     xor      edx, edx
0x00002EE1: 4d8bc1                   mov      r8, r9
0x00002EE4: 413b08                   cmp      ecx, dword ptr [r8]
0x00002EE7: 7412                     je       0x180002efb
0x00002EE9: ffc2                     inc      edx
0x00002EEB: 4983c010                 add      r8, 0x10
0x00002EEF: 4863c2                   movsxd   rax, edx
0x00002EF2: 4883f817                 cmp      rax, 0x17
0x00002EF6: 72ec                     jb       0x180002ee4
0x00002EF8: 33c0                     xor      eax, eax
0x00002EFA: c3                       ret      
0x00002EFB: 4863c2                   movsxd   rax, edx
0x00002EFE: 4803c0                   add      rax, rax
0x00002F01: 498b44c108               mov      rax, qword ptr [r9 + rax*8 + 8]
0x00002F06: c3                       ret      
0x00002F07: cc                       int3     
0x00002F08: 48895c2410               mov      qword ptr [rsp + 0x10], rbx
0x00002F0D: 48896c2418               mov      qword ptr [rsp + 0x18], rbp
0x00002F12: 4889742420               mov      qword ptr [rsp + 0x20], rsi
0x00002F17: 57                       push     rdi
0x00002F18: 4156                     push     r14
0x00002F1A: 4157                     push     r15
0x00002F1C: 4881ec50020000           sub      rsp, 0x250
0x00002F23: 488b05d6400100           mov      rax, qword ptr [rip + 0x140d6]
0x00002F2A: 4833c4                   xor      rax, rsp
0x00002F2D: 4889842440020000         mov      qword ptr [rsp + 0x240], rax
0x00002F35: 8bf9                     mov      edi, ecx
0x00002F37: e89cffffff               call     0x180002ed8
0x00002F3C: 33f6                     xor      esi, esi
0x00002F3E: 488bd8                   mov      rbx, rax
0x00002F41: 4885c0                   test     rax, rax
0x00002F44: 0f8499010000             je       0x1800030e3
0x00002F4A: 8d4e03                   lea      ecx, [rsi + 3]
0x00002F4D: e8323d0000               call     0x180006c84
0x00002F52: 83f801                   cmp      eax, 1
0x00002F55: 0f841d010000             je       0x180003078
0x00002F5B: 8d4e03                   lea      ecx, [rsi + 3]
0x00002F5E: e8213d0000               call     0x180006c84
0x00002F63: 85c0                     test     eax, eax
0x00002F65: 750d                     jne      0x180002f74
0x00002F67: 833df25d010001           cmp      dword ptr [rip + 0x15df2], 1
0x00002F6E: 0f8404010000             je       0x180003078
0x00002F74: 81fffc000000             cmp      edi, 0xfc
0x00002F7A: 0f8463010000             je       0x1800030e3
0x00002F80: 488d2de95d0100           lea      rbp, [rip + 0x15de9]
0x00002F87: 41bf14030000             mov      r15d, 0x314
0x00002F8D: 4c8d052ccf0000           lea      r8, [rip + 0xcf2c]
0x00002F94: 488bcd                   mov      rcx, rbp
0x00002F97: 418bd7                   mov      edx, r15d
0x00002F9A: e8913b0000               call     0x180006b30
0x00002F9F: 33c9                     xor      ecx, ecx
0x00002FA1: 85c0                     test     eax, eax
0x00002FA3: 0f85bb010000             jne      0x180003164
0x00002FA9: 4c8d35f25d0100           lea      r14, [rip + 0x15df2]
0x00002FB0: 41b804010000             mov      r8d, 0x104
0x00002FB6: 668935ed5f0100           mov      word ptr [rip + 0x15fed], si
0x00002FBD: 498bd6                   mov      rdx, r14
0x00002FC0: 56                       push     rsi
0x00002FC1: e820321000               call     0x1801061e6
0x00002FC6: 418d7fe7                 lea      edi, [r15 - 0x19]
0x00002FCA: 85c0                     test     eax, eax
0x00002FCC: 7519                     jne      0x180002fe7
0x00002FCE: 4c8d0523cf0000           lea      r8, [rip + 0xcf23]
0x00002FD5: 8bd7                     mov      edx, edi
0x00002FD7: 498bce                   mov      rcx, r14
0x00002FDA: e8513b0000               call     0x180006b30
0x00002FDF: 85c0                     test     eax, eax
0x00002FE1: 0f8529010000             jne      0x180003110
0x00002FE7: 498bce                   mov      rcx, r14
0x00002FEA: e8ad3b0000               call     0x180006b9c
0x00002FEF: 48ffc0                   inc      rax
0x00002FF2: 4883f83c                 cmp      rax, 0x3c
0x00002FF6: 7639                     jbe      0x180003031
0x00002FF8: 498bce                   mov      rcx, r14
0x00002FFB: e89c3b0000               call     0x180006b9c
0x00003000: 488d4dbc                 lea      rcx, [rbp - 0x44]
0x00003004: 4c8d051dcf0000           lea      r8, [rip + 0xcf1d]
0x0000300B: 488d0c41                 lea      rcx, [rcx + rax*2]
0x0000300F: 41b903000000             mov      r9d, 3
0x00003015: 488bc1                   mov      rax, rcx
0x00003018: 492bc6                   sub      rax, r14
0x0000301B: 48d1f8                   sar      rax, 1
0x0000301E: 482bf8                   sub      rdi, rax
0x00003021: 488bd7                   mov      rdx, rdi
0x00003024: e88f3b0000               call     0x180006bb8
0x00003029: 85c0                     test     eax, eax
0x0000302B: 0f85f4000000             jne      0x180003125
0x00003031: 4c8d05f8ce0000           lea      r8, [rip + 0xcef8]
0x00003038: 498bd7                   mov      rdx, r15
0x0000303B: 488bcd                   mov      rcx, rbp
0x0000303E: e8653a0000               call     0x180006aa8
0x00003043: 85c0                     test     eax, eax
0x00003045: 0f8504010000             jne      0x18000314f
0x0000304B: 4c8bc3                   mov      r8, rbx
0x0000304E: 498bd7                   mov      rdx, r15
0x00003051: 488bcd                   mov      rcx, rbp
0x00003054: e84f3a0000               call     0x180006aa8
0x00003059: 85c0                     test     eax, eax
0x0000305B: 0f85d9000000             jne      0x18000313a
0x00003061: 488d15d8ce0000           lea      rdx, [rip + 0xced8]
0x00003068: 41b810200100             mov      r8d, 0x12010
0x0000306E: 488bcd                   mov      rcx, rbp
0x00003071: e84e3c0000               call     0x180006cc4
0x00003076: eb6b                     jmp      0x1800030e3
0x00003078: b9f4ffffff               mov      ecx, 0xfffffff4
0x0000307D: e849231000               call     0x1801053cb
0x00003082: 8a488b                   mov      cl, byte ptr [rax - 0x75]
0x00003085: f8                       clc      
0x00003086: 488d48ff                 lea      rcx, [rax - 1]
0x0000308A: 4883f9fd                 cmp      rcx, -3
0x0000308E: 7753                     ja       0x1800030e3
0x00003090: 448bc6                   mov      r8d, esi
0x00003093: 488d542440               lea      rdx, [rsp + 0x40]
0x00003098: 8a0b                     mov      cl, byte ptr [rbx]
0x0000309A: 880a                     mov      byte ptr [rdx], cl
0x0000309C: 663933                   cmp      word ptr [rbx], si
0x0000309F: 7415                     je       0x1800030b6
0x000030A1: 41ffc0                   inc      r8d
0x000030A4: 48ffc2                   inc      rdx
0x000030A7: 4883c302                 add      rbx, 2
0x000030AB: 4963c0                   movsxd   rax, r8d
0x000030AE: 483df4010000             cmp      rax, 0x1f4
0x000030B4: 72e2                     jb       0x180003098
0x000030B6: 488d4c2440               lea      rcx, [rsp + 0x40]
0x000030BB: 4088b42433020000         mov      byte ptr [rsp + 0x233], sil
0x000030C3: e838390000               call     0x180006a00
0x000030C8: 4c8d4c2430               lea      r9, [rsp + 0x30]
0x000030CD: 488d542440               lea      rdx, [rsp + 0x40]
0x000030D2: 488bcf                   mov      rcx, rdi
0x000030D5: 4c8bc0                   mov      r8, rax
0x000030D8: 4889742420               mov      qword ptr [rsp + 0x20], rsi
0x000030DD: 53                       push     rbx
0x000030DE: e8b4b20d00               call     0x1800de397
0x000030E3: 488b8c2440020000         mov      rcx, qword ptr [rsp + 0x240]
0x000030EB: 4833cc                   xor      rcx, rsp
0x000030EE: e81de7ffff               call     0x180001810
0x000030F3: 4c8d9c2450020000         lea      r11, [rsp + 0x250]
0x000030FB: 498b5b28                 mov      rbx, qword ptr [r11 + 0x28]
0x000030FF: 498b6b30                 mov      rbp, qword ptr [r11 + 0x30]
0x00003103: 498b7338                 mov      rsi, qword ptr [r11 + 0x38]
0x00003107: 498be3                   mov      rsp, r11
0x0000310A: 415f                     pop      r15
0x0000310C: 415e                     pop      r14
0x0000310E: 5f                       pop      rdi
0x0000310F: c3                       ret      
0x00003110: 4533c9                   xor      r9d, r9d
0x00003113: 4533c0                   xor      r8d, r8d
0x00003116: 33d2                     xor      edx, edx
0x00003118: 33c9                     xor      ecx, ecx
0x0000311A: 4889742420               mov      qword ptr [rsp + 0x20], rsi
0x0000311F: e8a0070000               call     0x1800038c4
0x00003124: cc                       int3     
0x00003125: 4533c9                   xor      r9d, r9d
0x00003128: 4533c0                   xor      r8d, r8d
0x0000312B: 33d2                     xor      edx, edx
0x0000312D: 33c9                     xor      ecx, ecx
0x0000312F: 4889742420               mov      qword ptr [rsp + 0x20], rsi
0x00003134: e88b070000               call     0x1800038c4
0x00003139: cc                       int3     
0x0000313A: 4533c9                   xor      r9d, r9d
0x0000313D: 4533c0                   xor      r8d, r8d
0x00003140: 33d2                     xor      edx, edx
0x00003142: 33c9                     xor      ecx, ecx
0x00003144: 4889742420               mov      qword ptr [rsp + 0x20], rsi
0x00003149: e876070000               call     0x1800038c4
0x0000314E: cc                       int3     
0x0000314F: 4533c9                   xor      r9d, r9d
0x00003152: 4533c0                   xor      r8d, r8d
0x00003155: 33d2                     xor      edx, edx
0x00003157: 33c9                     xor      ecx, ecx
0x00003159: 4889742420               mov      qword ptr [rsp + 0x20], rsi
0x0000315E: e861070000               call     0x1800038c4
0x00003163: cc                       int3     
0x00003164: 4533c9                   xor      r9d, r9d
0x00003167: 4533c0                   xor      r8d, r8d
0x0000316A: 33d2                     xor      edx, edx
0x0000316C: 4889742420               mov      qword ptr [rsp + 0x20], rsi
0x00003171: e84e070000               call     0x1800038c4
0x00003176: cc                       int3     
0x00003177: cc                       int3     
0x00003178: 48895c2408               mov      qword ptr [rsp + 8], rbx
0x0000317D: 48896c2410               mov      qword ptr [rsp + 0x10], rbp
0x00003182: 4889742418               mov      qword ptr [rsp + 0x18], rsi
0x00003187: 57                       push     rdi
0x00003188: 4883ec10                 sub      rsp, 0x10
0x0000318C: 33c9                     xor      ecx, ecx
0x0000318E: 33c0                     xor      eax, eax
0x00003190: 33ff                     xor      edi, edi
0x00003192: 0fa2                     cpuid    
0x00003194: c705e63f010002000000     mov      dword ptr [rip + 0x13fe6], 2
0x0000319E: c705d83f010001000000     mov      dword ptr [rip + 0x13fd8], 1
0x000031A8: 448bdb                   mov      r11d, ebx
0x000031AB: 8bd9                     mov      ebx, ecx
0x000031AD: 448bc2                   mov      r8d, edx
0x000031B0: 81f36e74656c             xor      ebx, 0x6c65746e
0x000031B6: 448bca                   mov      r9d, edx
0x000031B9: 418bd3                   mov      edx, r11d
0x000031BC: 4181f0696e6549           xor      r8d, 0x49656e69
0x000031C3: 81f247656e75             xor      edx, 0x756e6547
0x000031C9: 8be8                     mov      ebp, eax
0x000031CB: 440bc3                   or       r8d, ebx
0x000031CE: 8d4701                   lea      eax, [rdi + 1]
0x000031D1: 440bc2                   or       r8d, edx
0x000031D4: 410f94c2                 sete     r10b
0x000031D8: 4181f341757468           xor      r11d, 0x68747541
0x000031DF: 4181f1656e7469           xor      r9d, 0x69746e65
0x000031E6: 450bd9                   or       r11d, r9d
0x000031E9: 81f163414d44             xor      ecx, 0x444d4163
0x000031EF: 440bd9                   or       r11d, ecx
0x000031F2: 400f94c6                 sete     sil
0x000031F6: 33c9                     xor      ecx, ecx
0x000031F8: 0fa2                     cpuid    
0x000031FA: 448bd9                   mov      r11d, ecx
0x000031FD: 448bc8                   mov      r9d, eax
0x00003200: 895c2404                 mov      dword ptr [rsp + 4], ebx
0x00003204: 8954240c                 mov      dword ptr [rsp + 0xc], edx
0x00003208: 4584d2                   test     r10b, r10b
0x0000320B: 744f                     je       0x18000325c
0x0000320D: 8bd0                     mov      edx, eax
0x0000320F: 81e2f03fff0f             and      edx, 0xfff3ff0
0x00003215: 81fac0060100             cmp      edx, 0x106c0
0x0000321B: 742b                     je       0x180003248
0x0000321D: 81fa60060200             cmp      edx, 0x20660
0x00003223: 7423                     je       0x180003248
0x00003225: 81fa70060200             cmp      edx, 0x20670
0x0000322B: 741b                     je       0x180003248
0x0000322D: 81c2b0f9fcff             add      edx, 0xfffcf9b0
0x00003233: 83fa20                   cmp      edx, 0x20
0x00003236: 7724                     ja       0x18000325c
0x00003238: 48b90100010001000000     movabs   rcx, 0x100010001
0x00003242: 480fa3d1                 bt       rcx, rdx
0x00003246: 7314                     jae      0x18000325c
0x00003248: 448b054d610100           mov      r8d, dword ptr [rip + 0x1614d]
0x0000324F: 4183c801                 or       r8d, 1
0x00003253: 44890542610100           mov      dword ptr [rip + 0x16142], r8d
0x0000325A: eb07                     jmp      0x180003263
0x0000325C: 448b0539610100           mov      r8d, dword ptr [rip + 0x16139]
0x00003263: 4084f6                   test     sil, sil
0x00003266: 741b                     je       0x180003283
0x00003268: 4181e1000ff00f           and      r9d, 0xff00f00
0x0000326F: 4181f9000f6000           cmp      r9d, 0x600f00
0x00003276: 7c0b                     jl       0x180003283
0x00003278: 4183c804                 or       r8d, 4
0x0000327C: 44890519610100           mov      dword ptr [rip + 0x16119], r8d
0x00003283: b807000000               mov      eax, 7
0x00003288: 3be8                     cmp      ebp, eax
0x0000328A: 7c22                     jl       0x1800032ae
0x0000328C: 33c9                     xor      ecx, ecx
0x0000328E: 0fa2                     cpuid    
0x00003290: 8bfb                     mov      edi, ebx
0x00003292: 890424                   mov      dword ptr [rsp], eax
0x00003295: 894c2408                 mov      dword ptr [rsp + 8], ecx
0x00003299: 8954240c                 mov      dword ptr [rsp + 0xc], edx
0x0000329D: 0fbae309                 bt       ebx, 9
0x000032A1: 730b                     jae      0x1800032ae
0x000032A3: 4183c802                 or       r8d, 2
0x000032A7: 448905ee600100           mov      dword ptr [rip + 0x160ee], r8d
0x000032AE: 410fbae314               bt       r11d, 0x14
0x000032B3: 7350                     jae      0x180003305
0x000032B5: c705c13e010002000000     mov      dword ptr [rip + 0x13ec1], 2
0x000032BF: c705bb3e010006000000     mov      dword ptr [rip + 0x13ebb], 6
0x000032C9: 410fbae31b               bt       r11d, 0x1b
0x000032CE: 7335                     jae      0x180003305
0x000032D0: 410fbae31c               bt       r11d, 0x1c
0x000032D5: 732e                     jae      0x180003305
0x000032D7: c7059f3e010003000000     mov      dword ptr [rip + 0x13e9f], 3
0x000032E1: c705993e01000e000000     mov      dword ptr [rip + 0x13e99], 0xe
0x000032EB: 40f6c720                 test     dil, 0x20
0x000032EF: 7414                     je       0x180003305
0x000032F1: c705853e010005000000     mov      dword ptr [rip + 0x13e85], 5
0x000032FB: c7057f3e01002e000000     mov      dword ptr [rip + 0x13e7f], 0x2e
0x00003305: 488b5c2420               mov      rbx, qword ptr [rsp + 0x20]
0x0000330A: 488b6c2428               mov      rbp, qword ptr [rsp + 0x28]
0x0000330F: 488b742430               mov      rsi, qword ptr [rsp + 0x30]
0x00003314: 33c0                     xor      eax, eax
0x00003316: 4883c410                 add      rsp, 0x10
0x0000331A: 5f                       pop      rdi
0x0000331B: c3                       ret      
0x0000331C: 4883ec28                 sub      rsp, 0x28
0x00003320: 4885c9                   test     rcx, rcx
0x00003323: 7519                     jne      0x18000333e
0x00003325: e862f3ffff               call     0x18000268c
0x0000332A: c70016000000             mov      dword ptr [rax], 0x16
0x00003330: e86f050000               call     0x1800038a4
0x00003335: 4883c8ff                 or       rax, 0xffffffffffffffff
0x00003339: 4883c428                 add      rsp, 0x28
0x0000333D: c3                       ret      
0x0000333E: 4c8bc1                   mov      r8, rcx
0x00003341: 488b0db0590100           mov      rcx, qword ptr [rip + 0x159b0]
0x00003348: 33d2                     xor      edx, edx
0x0000334A: 4883c428                 add      rsp, 0x28
0x0000334E: 4852                     push     rdx
0x00003350: e8a3fa0100               call     0x180022df8
0x00003355: cc                       int3     
0x00003356: cc                       int3     
0x00003357: cc                       int3     
0x00003358: 488bc4                   mov      rax, rsp
0x0000335B: 48895808                 mov      qword ptr [rax + 8], rbx
0x0000335F: 48896810                 mov      qword ptr [rax + 0x10], rbp
0x00003363: 48897018                 mov      qword ptr [rax + 0x18], rsi
0x00003367: 48897820                 mov      qword ptr [rax + 0x20], rdi
0x0000336B: 4156                     push     r14
0x0000336D: 4883ec20                 sub      rsp, 0x20
0x00003371: 33db                     xor      ebx, ebx
0x00003373: 488bf2                   mov      rsi, rdx
0x00003376: 488be9                   mov      rbp, rcx
0x00003379: 4183ceff                 or       r14d, 0xffffffff
0x0000337D: 4533c0                   xor      r8d, r8d
0x00003380: 488bd6                   mov      rdx, rsi
0x00003383: 488bcd                   mov      rcx, rbp
0x00003386: e8ad3b0000               call     0x180006f38
0x0000338B: 488bf8                   mov      rdi, rax
0x0000338E: 4885c0                   test     rax, rax
0x00003391: 7526                     jne      0x1800033b9
0x00003393: 390507600100             cmp      dword ptr [rip + 0x16007], eax
0x00003399: 761e                     jbe      0x1800033b9
0x0000339B: 8bcb                     mov      ecx, ebx
0x0000339D: e8f21f0000               call     0x180005394
0x000033A2: 8d8be8030000             lea      ecx, [rbx + 0x3e8]
0x000033A8: 3b0df25f0100             cmp      ecx, dword ptr [rip + 0x15ff2]
0x000033AE: 8bd9                     mov      ebx, ecx
0x000033B0: 410f47de                 cmova    ebx, r14d
0x000033B4: 413bde                   cmp      ebx, r14d
0x000033B7: 75c4                     jne      0x18000337d
0x000033B9: 488b5c2430               mov      rbx, qword ptr [rsp + 0x30]
0x000033BE: 488b6c2438               mov      rbp, qword ptr [rsp + 0x38]
0x000033C3: 488b742440               mov      rsi, qword ptr [rsp + 0x40]
0x000033C8: 488bc7                   mov      rax, rdi
0x000033CB: 488b7c2448               mov      rdi, qword ptr [rsp + 0x48]
0x000033D0: 4883c420                 add      rsp, 0x20
0x000033D4: 415e                     pop      r14
0x000033D6: c3                       ret      
0x000033D7: cc                       int3     
0x000033D8: 488bc4                   mov      rax, rsp
0x000033DB: 48895808                 mov      qword ptr [rax + 8], rbx
0x000033DF: 48896810                 mov      qword ptr [rax + 0x10], rbp
0x000033E3: 48897018                 mov      qword ptr [rax + 0x18], rsi
0x000033E7: 48897820                 mov      qword ptr [rax + 0x20], rdi
0x000033EB: 4156                     push     r14
0x000033ED: 4883ec20                 sub      rsp, 0x20
0x000033F1: 8b35a95f0100             mov      esi, dword ptr [rip + 0x15fa9]
0x000033F7: 33db                     xor      ebx, ebx
0x000033F9: 488be9                   mov      rbp, rcx
0x000033FC: 4183ceff                 or       r14d, 0xffffffff
0x00003400: 488bcd                   mov      rcx, rbp
0x00003403: e868e4ffff               call     0x180001870
0x00003408: 488bf8                   mov      rdi, rax
0x0000340B: 4885c0                   test     rax, rax
0x0000340E: 7524                     jne      0x180003434
0x00003410: 85f6                     test     esi, esi
0x00003412: 7420                     je       0x180003434
0x00003414: 8bcb                     mov      ecx, ebx
0x00003416: e8791f0000               call     0x180005394
0x0000341B: 8b357f5f0100             mov      esi, dword ptr [rip + 0x15f7f]
0x00003421: 8d8be8030000             lea      ecx, [rbx + 0x3e8]
0x00003427: 3bce                     cmp      ecx, esi
0x00003429: 8bd9                     mov      ebx, ecx
0x0000342B: 410f47de                 cmova    ebx, r14d
0x0000342F: 413bde                   cmp      ebx, r14d
0x00003432: 75cc                     jne      0x180003400
0x00003434: 488b5c2430               mov      rbx, qword ptr [rsp + 0x30]
0x00003439: 488b6c2438               mov      rbp, qword ptr [rsp + 0x38]
0x0000343E: 488b742440               mov      rsi, qword ptr [rsp + 0x40]
0x00003443: 488bc7                   mov      rax, rdi
0x00003446: 488b7c2448               mov      rdi, qword ptr [rsp + 0x48]
0x0000344B: 4883c420                 add      rsp, 0x20
0x0000344F: 415e                     pop      r14
0x00003451: c3                       ret      
0x00003452: cc                       int3     
0x00003453: cc                       int3     
0x00003454: 488bc4                   mov      rax, rsp
0x00003457: 48895808                 mov      qword ptr [rax + 8], rbx
0x0000345B: 48896810                 mov      qword ptr [rax + 0x10], rbp
0x0000345F: 48897018                 mov      qword ptr [rax + 0x18], rsi
0x00003463: 48897820                 mov      qword ptr [rax + 0x20], rdi
0x00003467: 4156                     push     r14
0x00003469: 4883ec20                 sub      rsp, 0x20
0x0000346D: 33db                     xor      ebx, ebx
0x0000346F: 488bf2                   mov      rsi, rdx
0x00003472: 488be9                   mov      rbp, rcx
0x00003475: 4183ceff                 or       r14d, 0xffffffff
0x00003479: 488bd6                   mov      rdx, rsi
0x0000347C: 488bcd                   mov      rcx, rbp
0x0000347F: e8c81f0000               call     0x18000544c
0x00003484: 488bf8                   mov      rdi, rax
0x00003487: 4885c0                   test     rax, rax
0x0000348A: 752b                     jne      0x1800034b7
0x0000348C: 4885f6                   test     rsi, rsi
0x0000348F: 7426                     je       0x1800034b7
0x00003491: 3905095f0100             cmp      dword ptr [rip + 0x15f09], eax
0x00003497: 761e                     jbe      0x1800034b7
0x00003499: 8bcb                     mov      ecx, ebx
0x0000349B: e8f41e0000               call     0x180005394
0x000034A0: 8d8be8030000             lea      ecx, [rbx + 0x3e8]
0x000034A6: 3b0df45e0100             cmp      ecx, dword ptr [rip + 0x15ef4]
0x000034AC: 8bd9                     mov      ebx, ecx
0x000034AE: 410f47de                 cmova    ebx, r14d
0x000034B2: 413bde                   cmp      ebx, r14d
0x000034B5: 75c2                     jne      0x180003479
0x000034B7: 488b5c2430               mov      rbx, qword ptr [rsp + 0x30]
0x000034BC: 488b6c2438               mov      rbp, qword ptr [rsp + 0x38]
0x000034C1: 488b742440               mov      rsi, qword ptr [rsp + 0x40]
0x000034C6: 488bc7                   mov      rax, rdi
0x000034C9: 488b7c2448               mov      rdi, qword ptr [rsp + 0x48]
0x000034CE: 4883c420                 add      rsp, 0x20
0x000034D2: 415e                     pop      r14
0x000034D4: c3                       ret      
0x000034D5: cc                       int3     
0x000034D6: cc                       int3     
0x000034D7: cc                       int3     
0x000034D8: 48895c2408               mov      qword ptr [rsp + 8], rbx
0x000034DD: 48896c2410               mov      qword ptr [rsp + 0x10], rbp
0x000034E2: 4889742418               mov      qword ptr [rsp + 0x18], rsi
0x000034E7: 57                       push     rdi
0x000034E8: 4156                     push     r14
0x000034EA: 4157                     push     r15
0x000034EC: 4883ec20                 sub      rsp, 0x20
0x000034F0: 33db                     xor      ebx, ebx
0x000034F2: 498bf0                   mov      rsi, r8
0x000034F5: 488bea                   mov      rbp, rdx
0x000034F8: 4183cfff                 or       r15d, 0xffffffff
0x000034FC: 4c8bf1                   mov      r14, rcx
0x000034FF: 4c8bc6                   mov      r8, rsi
0x00003502: 488bd5                   mov      rdx, rbp
0x00003505: 498bce                   mov      rcx, r14
0x00003508: e827edffff               call     0x180002234
0x0000350D: 488bf8                   mov      rdi, rax
0x00003510: 4885c0                   test     rax, rax
0x00003513: 752b                     jne      0x180003540
0x00003515: 4885f6                   test     rsi, rsi
0x00003518: 7426                     je       0x180003540
0x0000351A: 3905805e0100             cmp      dword ptr [rip + 0x15e80], eax
0x00003520: 761e                     jbe      0x180003540
0x00003522: 8bcb                     mov      ecx, ebx
0x00003524: e86b1e0000               call     0x180005394
0x00003529: 8d8be8030000             lea      ecx, [rbx + 0x3e8]
0x0000352F: 3b0d6b5e0100             cmp      ecx, dword ptr [rip + 0x15e6b]
0x00003535: 8bd9                     mov      ebx, ecx
0x00003537: 410f47df                 cmova    ebx, r15d
0x0000353B: 413bdf                   cmp      ebx, r15d
0x0000353E: 75bf                     jne      0x1800034ff
0x00003540: 488b5c2440               mov      rbx, qword ptr [rsp + 0x40]
0x00003545: 488b6c2448               mov      rbp, qword ptr [rsp + 0x48]
0x0000354A: 488b742450               mov      rsi, qword ptr [rsp + 0x50]
0x0000354F: 488bc7                   mov      rax, rdi
0x00003552: 4883c420                 add      rsp, 0x20
0x00003556: 415f                     pop      r15
0x00003558: 415e                     pop      r14
0x0000355A: 5f                       pop      rdi
0x0000355B: c3                       ret      
0x0000355C: 488bc4                   mov      rax, rsp
0x0000355F: 48895808                 mov      qword ptr [rax + 8], rbx
0x00003563: 48896810                 mov      qword ptr [rax + 0x10], rbp
0x00003567: 48897018                 mov      qword ptr [rax + 0x18], rsi
0x0000356B: 57                       push     rdi
0x0000356C: 4154                     push     r12
0x0000356E: 4155                     push     r13
0x00003570: 4156                     push     r14
0x00003572: 4157                     push     r15
0x00003574: 4883ec40                 sub      rsp, 0x40
0x00003578: 4d8b6108                 mov      r12, qword ptr [r9 + 8]
0x0000357C: 4d8b39                   mov      r15, qword ptr [r9]
0x0000357F: 498b5938                 mov      rbx, qword ptr [r9 + 0x38]
0x00003583: 4d2bfc                   sub      r15, r12
0x00003586: f6410466                 test     byte ptr [rcx + 4], 0x66
0x0000358A: 4d8bf1                   mov      r14, r9
0x0000358D: 4c8bea                   mov      r13, rdx
0x00003590: 488be9                   mov      rbp, rcx
0x00003593: 0f85de000000             jne      0x180003677
0x00003599: 418b7148                 mov      esi, dword ptr [r9 + 0x48]
0x0000359D: 488948c8                 mov      qword ptr [rax - 0x38], rcx
0x000035A1: 4c8940d0                 mov      qword ptr [rax - 0x30], r8
0x000035A5: 3b33                     cmp      esi, dword ptr [rbx]
0x000035A7: 0f836d010000             jae      0x18000371a
0x000035AD: 8bfe                     mov      edi, esi
0x000035AF: 4803ff                   add      rdi, rdi
0x000035B2: 8b44fb04                 mov      eax, dword ptr [rbx + rdi*8 + 4]
0x000035B6: 4c3bf8                   cmp      r15, rax
0x000035B9: 0f82aa000000             jb       0x180003669
0x000035BF: 8b44fb08                 mov      eax, dword ptr [rbx + rdi*8 + 8]
0x000035C3: 4c3bf8                   cmp      r15, rax
0x000035C6: 0f839d000000             jae      0x180003669
0x000035CC: 837cfb1000               cmp      dword ptr [rbx + rdi*8 + 0x10], 0
0x000035D1: 0f8492000000             je       0x180003669
0x000035D7: 837cfb0c01               cmp      dword ptr [rbx + rdi*8 + 0xc], 1
0x000035DC: 7417                     je       0x1800035f5
0x000035DE: 8b44fb0c                 mov      eax, dword ptr [rbx + rdi*8 + 0xc]
0x000035E2: 488d4c2430               lea      rcx, [rsp + 0x30]
0x000035E7: 498bd5                   mov      rdx, r13
0x000035EA: 4903c4                   add      rax, r12
0x000035ED: ffd0                     call     rax
0x000035EF: 85c0                     test     eax, eax
0x000035F1: 787d                     js       0x180003670
0x000035F3: 7e74                     jle      0x180003669
0x000035F5: 817d0063736de0           cmp      dword ptr [rbp], 0xe06d7363
0x000035FC: 7528                     jne      0x180003626
0x000035FE: 48833d8aa1010000         cmp      qword ptr [rip + 0x1a18a], 0
0x00003606: 741e                     je       0x180003626
0x00003608: 488d0d81a10100           lea      rcx, [rip + 0x1a181]
0x0000360F: e8ec260000               call     0x180005d00
0x00003614: 85c0                     test     eax, eax
0x00003616: 740e                     je       0x180003626
0x00003618: ba01000000               mov      edx, 1
0x0000361D: 488bcd                   mov      rcx, rbp
0x00003620: ff156aa10100             call     qword ptr [rip + 0x1a16a]
0x00003626: 8b4cfb10                 mov      ecx, dword ptr [rbx + rdi*8 + 0x10]
0x0000362A: 41b801000000             mov      r8d, 1
0x00003630: 498bd5                   mov      rdx, r13
0x00003633: 4903cc                   add      rcx, r12
0x00003636: e8e5390000               call     0x180007020
0x0000363B: 498b4640                 mov      rax, qword ptr [r14 + 0x40]
0x0000363F: 8b54fb10                 mov      edx, dword ptr [rbx + rdi*8 + 0x10]
0x00003643: 448b4d00                 mov      r9d, dword ptr [rbp]
0x00003647: 4889442428               mov      qword ptr [rsp + 0x28], rax
0x0000364C: 498b4628                 mov      rax, qword ptr [r14 + 0x28]
0x00003650: 4903d4                   add      rdx, r12
0x00003653: 4c8bc5                   mov      r8, rbp
0x00003656: 498bcd                   mov      rcx, r13
0x00003659: 4889442420               mov      qword ptr [rsp + 0x20], rax
0x0000365E: 50                       push     rax
0x0000365F: e865892400               call     0x18024bfc9
0x00003664: e8e7390000               call     0x180007050
0x00003669: ffc6                     inc      esi
0x0000366B: e935ffffff               jmp      0x1800035a5
0x00003670: 33c0                     xor      eax, eax
0x00003672: e9a8000000               jmp      0x18000371f
0x00003677: 498b7120                 mov      rsi, qword ptr [r9 + 0x20]
0x0000367B: 418b7948                 mov      edi, dword ptr [r9 + 0x48]
0x0000367F: 492bf4                   sub      rsi, r12
0x00003682: e989000000               jmp      0x180003710
0x00003687: 8bcf                     mov      ecx, edi
0x00003689: 4803c9                   add      rcx, rcx
0x0000368C: 8b44cb04                 mov      eax, dword ptr [rbx + rcx*8 + 4]
0x00003690: 4c3bf8                   cmp      r15, rax
0x00003693: 7279                     jb       0x18000370e
0x00003695: 8b44cb08                 mov      eax, dword ptr [rbx + rcx*8 + 8]
0x00003699: 4c3bf8                   cmp      r15, rax
0x0000369C: 7370                     jae      0x18000370e
0x0000369E: f6450420                 test     byte ptr [rbp + 4], 0x20
0x000036A2: 7444                     je       0x1800036e8
0x000036A4: 4533c9                   xor      r9d, r9d
0x000036A7: 85d2                     test     edx, edx
0x000036A9: 7438                     je       0x1800036e3
0x000036AB: 458bc1                   mov      r8d, r9d
0x000036AE: 4d03c0                   add      r8, r8
0x000036B1: 428b44c304               mov      eax, dword ptr [rbx + r8*8 + 4]
0x000036B6: 483bf0                   cmp      rsi, rax
0x000036B9: 7220                     jb       0x1800036db
0x000036BB: 428b44c308               mov      eax, dword ptr [rbx + r8*8 + 8]
0x000036C0: 483bf0                   cmp      rsi, rax
0x000036C3: 7316                     jae      0x1800036db
0x000036C5: 8b44cb10                 mov      eax, dword ptr [rbx + rcx*8 + 0x10]
0x000036C9: 423944c310               cmp      dword ptr [rbx + r8*8 + 0x10], eax
0x000036CE: 750b                     jne      0x1800036db
0x000036D0: 8b44cb0c                 mov      eax, dword ptr [rbx + rcx*8 + 0xc]
0x000036D4: 423944c30c               cmp      dword ptr [rbx + r8*8 + 0xc], eax
0x000036D9: 7408                     je       0x1800036e3
0x000036DB: 41ffc1                   inc      r9d
0x000036DE: 443bca                   cmp      r9d, edx
0x000036E1: 72c8                     jb       0x1800036ab
0x000036E3: 443bca                   cmp      r9d, edx
0x000036E6: 7532                     jne      0x18000371a
0x000036E8: 8b44cb10                 mov      eax, dword ptr [rbx + rcx*8 + 0x10]
0x000036EC: 85c0                     test     eax, eax
0x000036EE: 7407                     je       0x1800036f7
0x000036F0: 483bf0                   cmp      rsi, rax
0x000036F3: 7425                     je       0x18000371a
0x000036F5: eb17                     jmp      0x18000370e
0x000036F7: 8d4701                   lea      eax, [rdi + 1]
0x000036FA: 498bd5                   mov      rdx, r13
0x000036FD: 41894648                 mov      dword ptr [r14 + 0x48], eax
0x00003701: 448b44cb0c               mov      r8d, dword ptr [rbx + rcx*8 + 0xc]
0x00003706: b101                     mov      cl, 1
0x00003708: 4d03c4                   add      r8, r12
0x0000370B: 41ffd0                   call     r8
0x0000370E: ffc7                     inc      edi
0x00003710: 8b13                     mov      edx, dword ptr [rbx]
0x00003712: 3bfa                     cmp      edi, edx
0x00003714: 0f826dffffff             jb       0x180003687
0x0000371A: b801000000               mov      eax, 1
0x0000371F: 4c8d5c2440               lea      r11, [rsp + 0x40]
0x00003724: 498b5b30                 mov      rbx, qword ptr [r11 + 0x30]
0x00003728: 498b6b38                 mov      rbp, qword ptr [r11 + 0x38]
0x0000372C: 498b7340                 mov      rsi, qword ptr [r11 + 0x40]
0x00003730: 498be3                   mov      rsp, r11
0x00003733: 415f                     pop      r15
0x00003735: 415e                     pop      r14
0x00003737: 415d                     pop      r13
0x00003739: 415c                     pop      r12
0x0000373B: 5f                       pop      rdi
0x0000373C: c3                       ret      
0x0000373D: cc                       int3     
0x0000373E: cc                       int3     
0x0000373F: cc                       int3     
0x00003740: 488bc4                   mov      rax, rsp
0x00003743: 48895810                 mov      qword ptr [rax + 0x10], rbx
0x00003747: 48897018                 mov      qword ptr [rax + 0x18], rsi
0x0000374B: 48897820                 mov      qword ptr [rax + 0x20], rdi
0x0000374F: 55                       push     rbp
0x00003750: 488da848fbffff           lea      rbp, [rax - 0x4b8]
0x00003757: 4881ecb0050000           sub      rsp, 0x5b0
0x0000375E: 488b059b380100           mov      rax, qword ptr [rip + 0x1389b]
0x00003765: 4833c4                   xor      rax, rsp
0x00003768: 488985a0040000           mov      qword ptr [rbp + 0x4a0], rax
0x0000376F: 418bf8                   mov      edi, r8d
0x00003772: 8bf2                     mov      esi, edx
0x00003774: 8bd9                     mov      ebx, ecx
0x00003776: 83f9ff                   cmp      ecx, -1
0x00003779: 7405                     je       0x180003780
0x0000377B: e818230000               call     0x180005a98
0x00003780: 8364243000               and      dword ptr [rsp + 0x30], 0
0x00003785: 488d4c2434               lea      rcx, [rsp + 0x34]
0x0000378A: 33d2                     xor      edx, edx
0x0000378C: 41b894000000             mov      r8d, 0x94
0x00003792: e839ebffff               call     0x1800022d0
0x00003797: 488d442430               lea      rax, [rsp + 0x30]
0x0000379C: 488d4dd0                 lea      rcx, [rbp - 0x30]
0x000037A0: 4889442420               mov      qword ptr [rsp + 0x20], rax
0x000037A5: 488d45d0                 lea      rax, [rbp - 0x30]
0x000037A9: 4889442428               mov      qword ptr [rsp + 0x28], rax
0x000037AE: e819160000               call     0x180004dcc
0x000037B3: 488b85b8040000           mov      rax, qword ptr [rbp + 0x4b8]
0x000037BA: 488985c8000000           mov      qword ptr [rbp + 0xc8], rax
0x000037C1: 488d85b8040000           lea      rax, [rbp + 0x4b8]
0x000037C8: 89742430                 mov      dword ptr [rsp + 0x30], esi
0x000037CC: 4883c008                 add      rax, 8
0x000037D0: 897c2434                 mov      dword ptr [rsp + 0x34], edi
0x000037D4: 48894568                 mov      qword ptr [rbp + 0x68], rax
0x000037D8: 488b85b8040000           mov      rax, qword ptr [rbp + 0x4b8]
0x000037DF: 4889442440               mov      qword ptr [rsp + 0x40], rax
0x000037E4: e83d011700               call     0x180173926
0x000037E9: 7948                     jns      0x180003833
0x000037EB: 8d4c2420                 lea      ecx, [rsp + 0x20]
0x000037EF: 8bf8                     mov      edi, eax
0x000037F1: e8c61b0000               call     0x1800053bc
0x000037F6: 85c0                     test     eax, eax
0x000037F8: 7510                     jne      0x18000380a
0x000037FA: 85ff                     test     edi, edi
0x000037FC: 750c                     jne      0x18000380a
0x000037FE: 83fbff                   cmp      ebx, -1
0x00003801: 7407                     je       0x18000380a
0x00003803: 8bcb                     mov      ecx, ebx
0x00003805: e88e220000               call     0x180005a98
0x0000380A: 488b8da0040000           mov      rcx, qword ptr [rbp + 0x4a0]
0x00003811: 4833cc                   xor      rcx, rsp
0x00003814: e8f7dfffff               call     0x180001810
0x00003819: 4c8d9c24b0050000         lea      r11, [rsp + 0x5b0]
0x00003821: 498b5b18                 mov      rbx, qword ptr [r11 + 0x18]
0x00003825: 498b7320                 mov      rsi, qword ptr [r11 + 0x20]
0x00003829: 498b7b28                 mov      rdi, qword ptr [r11 + 0x28]
0x0000382D: 498be3                   mov      rsp, r11
0x00003830: 5d                       pop      rbp
0x00003831: c3                       ret      
0x00003832: cc                       int3     
0x00003833: cc                       int3     
0x00003834: 48890d6d5b0100           mov      qword ptr [rip + 0x15b6d], rcx
0x0000383B: c3                       ret      
0x0000383C: 48895c2408               mov      qword ptr [rsp + 8], rbx
0x00003841: 48896c2410               mov      qword ptr [rsp + 0x10], rbp
0x00003846: 4889742418               mov      qword ptr [rsp + 0x18], rsi
0x0000384B: 57                       push     rdi
0x0000384C: 4883ec30                 sub      rsp, 0x30
0x00003850: 488be9                   mov      rbp, rcx
0x00003853: 488b0d4e5b0100           mov      rcx, qword ptr [rip + 0x15b4e]
0x0000385A: 418bd9                   mov      ebx, r9d
0x0000385D: 498bf8                   mov      rdi, r8
0x00003860: 488bf2                   mov      rsi, rdx
0x00003863: e857a70b00               call     0x1800bdfbf
0x00003868: 42448bcb                 mov      r9d, ebx
0x0000386C: 4c8bc7                   mov      r8, rdi
0x0000386F: 488bd6                   mov      rdx, rsi
0x00003872: 488bcd                   mov      rcx, rbp
0x00003875: 4885c0                   test     rax, rax
0x00003878: 7417                     je       0x180003891
0x0000387A: 488b5c2440               mov      rbx, qword ptr [rsp + 0x40]
0x0000387F: 488b6c2448               mov      rbp, qword ptr [rsp + 0x48]
0x00003884: 488b742450               mov      rsi, qword ptr [rsp + 0x50]
0x00003889: 4883c430                 add      rsp, 0x30
0x0000388D: 5f                       pop      rdi
0x0000388E: 48ffe0                   jmp      rax
0x00003891: 488b442460               mov      rax, qword ptr [rsp + 0x60]
0x00003896: 4889442420               mov      qword ptr [rsp + 0x20], rax
0x0000389B: e824000000               call     0x1800038c4
0x000038A0: cc                       int3     
0x000038A1: cc                       int3     
0x000038A2: cc                       int3     
0x000038A3: cc                       int3     
0x000038A4: 4883ec38                 sub      rsp, 0x38
0x000038A8: 488364242000             and      qword ptr [rsp + 0x20], 0
0x000038AE: 4533c9                   xor      r9d, r9d
0x000038B1: 4533c0                   xor      r8d, r8d
0x000038B4: 33d2                     xor      edx, edx
0x000038B6: 33c9                     xor      ecx, ecx
0x000038B8: e87fffffff               call     0x18000383c
0x000038BD: 4883c438                 add      rsp, 0x38
0x000038C1: c3                       ret      
0x000038C2: cc                       int3     
0x000038C3: cc                       int3     
0x000038C4: 4883ec28                 sub      rsp, 0x28
0x000038C8: b917000000               mov      ecx, 0x17
0x000038CD: e826b30000               call     0x18000ebf8
0x000038D2: 85c0                     test     eax, eax
0x000038D4: 7407                     je       0x1800038dd
0x000038D6: b905000000               mov      ecx, 5
0x000038DB: cd29                     int      0x29
0x000038DD: 41b801000000             mov      r8d, 1
0x000038E3: ba170400c0               mov      edx, 0xc0000417
0x000038E8: 418d4801                 lea      ecx, [r8 + 1]
0x000038EC: e84ffeffff               call     0x180003740
0x000038F1: b9170400c0               mov      ecx, 0xc0000417
0x000038F6: 4883c428                 add      rsp, 0x28
0x000038FA: e99d1a0000               jmp      0x18000539c
0x000038FF: cc                       int3     
0x00003900: 48895c2418               mov      qword ptr [rsp + 0x18], rbx
0x00003905: 4889742420               mov      qword ptr [rsp + 0x20], rsi
0x0000390A: 57                       push     rdi
0x0000390B: 4881ec90020000           sub      rsp, 0x290
0x00003912: 488b05e7360100           mov      rax, qword ptr [rip + 0x136e7]
0x00003919: 4833c4                   xor      rax, rsp
0x0000391C: 4889842480020000         mov      qword ptr [rsp + 0x280], rax
0x00003924: 33f6                     xor      esi, esi
0x00003926: 488bda                   mov      rbx, rdx
0x00003929: 4885d2                   test     rdx, rdx
0x0000392C: 7539                     jne      0x180003967
0x0000392E: e859edffff               call     0x18000268c
0x00003933: c70016000000             mov      dword ptr [rax], 0x16
0x00003939: e866ffffff               call     0x1800038a4
0x0000393E: 4883c8ff                 or       rax, 0xffffffffffffffff
0x00003942: 488b8c2480020000         mov      rcx, qword ptr [rsp + 0x280]
0x0000394A: 4833cc                   xor      rcx, rsp
0x0000394D: e8bedeffff               call     0x180001810
0x00003952: 4c8d9c2490020000         lea      r11, [rsp + 0x290]
0x0000395A: 498b5b20                 mov      rbx, qword ptr [r11 + 0x20]
0x0000395E: 498b7328                 mov      rsi, qword ptr [r11 + 0x28]
0x00003962: 498be3                   mov      rsp, r11
0x00003965: 5f                       pop      rdi
0x00003966: c3                       ret      
0x00003967: 4885c9                   test     rcx, rcx
0x0000396A: 74c2                     je       0x18000392e
0x0000396C: 4c8d442430               lea      r8, [rsp + 0x30]
0x00003971: 4533c9                   xor      r9d, r9d
0x00003974: 33d2                     xor      edx, edx
0x00003976: 89742428                 mov      dword ptr [rsp + 0x28], esi
0x0000397A: 4889742420               mov      qword ptr [rsp + 0x20], rsi
0x0000397F: e8686f1700               call     0x18017a8ec
0x00003984: 97                       xchg     edi, eax
0x00003985: 488bf8                   mov      rdi, rax
0x00003988: 4883f8ff                 cmp      rax, -1
0x0000398C: 7547                     jne      0x1800039d5
0x0000398E: 57                       push     rdi
0x0000398F: e89c650200               call     0x180029f30
0x00003994: 83f802                   cmp      eax, 2
0x00003997: 720f                     jb       0x1800039a8
0x00003999: 83f803                   cmp      eax, 3
0x0000399C: 7627                     jbe      0x1800039c5
0x0000399E: 83f808                   cmp      eax, 8
0x000039A1: 7412                     je       0x1800039b5
0x000039A3: 83f812                   cmp      eax, 0x12
0x000039A6: 741d                     je       0x1800039c5
0x000039A8: e8dfecffff               call     0x18000268c
0x000039AD: c70016000000             mov      dword ptr [rax], 0x16
0x000039B3: eb89                     jmp      0x18000393e
0x000039B5: e8d2ecffff               call     0x18000268c
0x000039BA: c7000c000000             mov      dword ptr [rax], 0xc
0x000039C0: e979ffffff               jmp      0x18000393e
0x000039C5: e8c2ecffff               call     0x18000268c
0x000039CA: c70002000000             mov      dword ptr [rax], 2
0x000039D0: e969ffffff               jmp      0x18000393e
0x000039D5: 8b442430                 mov      eax, dword ptr [rsp + 0x30]
0x000039D9: 488d4c2434               lea      rcx, [rsp + 0x34]
0x000039DE: 3d80000000               cmp      eax, 0x80
0x000039E3: 0f44c6                   cmove    eax, esi
0x000039E6: 8903                     mov      dword ptr [rbx], eax
0x000039E8: e883e2ffff               call     0x180001c70
0x000039ED: 488d4c243c               lea      rcx, [rsp + 0x3c]
0x000039F2: 48894308                 mov      qword ptr [rbx + 8], rax
0x000039F6: e875e2ffff               call     0x180001c70
0x000039FB: 488d4c2444               lea      rcx, [rsp + 0x44]
0x00003A00: 48894310                 mov      qword ptr [rbx + 0x10], rax
0x00003A04: e867e2ffff               call     0x180001c70
0x00003A09: 488d4b24                 lea      rcx, [rbx + 0x24]
0x00003A0D: 48894318                 mov      qword ptr [rbx + 0x18], rax
0x00003A11: 8b442450                 mov      eax, dword ptr [rsp + 0x50]
0x00003A15: 4c8d44245c               lea      r8, [rsp + 0x5c]
0x00003A1A: ba04010000               mov      edx, 0x104
0x00003A1F: 894320                   mov      dword ptr [rbx + 0x20], eax
0x00003A22: e809310000               call     0x180006b30
0x00003A27: 85c0                     test     eax, eax
0x00003A29: 7508                     jne      0x180003a33
0x00003A2B: 488bc7                   mov      rax, rdi
0x00003A2E: e90fffffff               jmp      0x180003942
0x00003A33: 4533c9                   xor      r9d, r9d
0x00003A36: 4533c0                   xor      r8d, r8d
0x00003A39: 33d2                     xor      edx, edx
0x00003A3B: 33c9                     xor      ecx, ecx
0x00003A3D: 4889742420               mov      qword ptr [rsp + 0x20], rsi
0x00003A42: e87dfeffff               call     0x1800038c4
0x00003A47: cc                       int3     
0x00003A48: 48895c2418               mov      qword ptr [rsp + 0x18], rbx
0x00003A4D: 56                       push     rsi
0x00003A4E: 4881ec90020000           sub      rsp, 0x290
0x00003A55: 488b05a4350100           mov      rax, qword ptr [rip + 0x135a4]
0x00003A5C: 4833c4                   xor      rax, rsp
0x00003A5F: 4889842480020000         mov      qword ptr [rsp + 0x280], rax
0x00003A67: 488bda                   mov      rbx, rdx
0x00003A6A: 4883f9ff                 cmp      rcx, -1
0x00003A6E: 7534                     jne      0x180003aa4
0x00003A70: e817ecffff               call     0x18000268c
0x00003A75: c70016000000             mov      dword ptr [rax], 0x16
0x00003A7B: e824feffff               call     0x1800038a4
0x00003A80: 83c8ff                   or       eax, 0xffffffff
0x00003A83: 488b8c2480020000         mov      rcx, qword ptr [rsp + 0x280]
0x00003A8B: 4833cc                   xor      rcx, rsp
0x00003A8E: e87dddffff               call     0x180001810
0x00003A93: 488b9c24b0020000         mov      rbx, qword ptr [rsp + 0x2b0]
0x00003A9B: 4881c490020000           add      rsp, 0x290
0x00003AA2: 5e                       pop      rsi
0x00003AA3: c3                       ret      
0x00003AA4: 33f6                     xor      esi, esi
0x00003AA6: 4885d2                   test     rdx, rdx
0x00003AA9: 74c5                     je       0x180003a70
0x00003AAB: 488d542430               lea      rdx, [rsp + 0x30]
0x00003AB0: e8aad60f00               call     0x18010115f
0x00003AB5: 3e85c0                   test     eax, eax
0x00003AB8: 7541                     jne      0x180003afb
0x00003ABA: e86a241700               call     0x180175f29
0x00003ABF: 4a83f802                 cmp      rax, 2
0x00003AC3: 720f                     jb       0x180003ad4
0x00003AC5: 83f803                   cmp      eax, 3
0x00003AC8: 7624                     jbe      0x180003aee
0x00003ACA: 83f808                   cmp      eax, 8
0x00003ACD: 7412                     je       0x180003ae1
0x00003ACF: 83f812                   cmp      eax, 0x12
0x00003AD2: 741a                     je       0x180003aee
0x00003AD4: e8b3ebffff               call     0x18000268c
0x00003AD9: c70016000000             mov      dword ptr [rax], 0x16
0x00003ADF: eb9f                     jmp      0x180003a80
0x00003AE1: e8a6ebffff               call     0x18000268c
0x00003AE6: c7000c000000             mov      dword ptr [rax], 0xc
0x00003AEC: eb92                     jmp      0x180003a80
0x00003AEE: e899ebffff               call     0x18000268c
0x00003AF3: c70002000000             mov      dword ptr [rax], 2
0x00003AF9: eb85                     jmp      0x180003a80
0x00003AFB: 8b442430                 mov      eax, dword ptr [rsp + 0x30]
0x00003AFF: 488d4c2434               lea      rcx, [rsp + 0x34]
0x00003B04: 3d80000000               cmp      eax, 0x80
0x00003B09: 0f44c6                   cmove    eax, esi
0x00003B0C: 8903                     mov      dword ptr [rbx], eax
0x00003B0E: e85de1ffff               call     0x180001c70
0x00003B13: 488d4c243c               lea      rcx, [rsp + 0x3c]
0x00003B18: 48894308                 mov      qword ptr [rbx + 8], rax
0x00003B1C: e84fe1ffff               call     0x180001c70
0x00003B21: 488d4c2444               lea      rcx, [rsp + 0x44]
0x00003B26: 48894310                 mov      qword ptr [rbx + 0x10], rax
0x00003B2A: e841e1ffff               call     0x180001c70
0x00003B2F: 488d4b24                 lea      rcx, [rbx + 0x24]
0x00003B33: 48894318                 mov      qword ptr [rbx + 0x18], rax
0x00003B37: 8b442450                 mov      eax, dword ptr [rsp + 0x50]
0x00003B3B: 4c8d44245c               lea      r8, [rsp + 0x5c]
0x00003B40: ba04010000               mov      edx, 0x104
0x00003B45: 894320                   mov      dword ptr [rbx + 0x20], eax
0x00003B48: e8e32f0000               call     0x180006b30
0x00003B4D: 85c0                     test     eax, eax
0x00003B4F: 0f842effffff             je       0x180003a83
0x00003B55: 4533c9                   xor      r9d, r9d
0x00003B58: 4533c0                   xor      r8d, r8d
0x00003B5B: 33d2                     xor      edx, edx
0x00003B5D: 33c9                     xor      ecx, ecx
0x00003B5F: 4889742420               mov      qword ptr [rsp + 0x20], rsi
0x00003B64: e85bfdffff               call     0x1800038c4
0x00003B69: cc                       int3     
0x00003B6A: cc                       int3     
0x00003B6B: cc                       int3     
0x00003B6C: 4055                     push     rbp
0x00003B6E: 53                       push     rbx
0x00003B6F: 56                       push     rsi
0x00003B70: 57                       push     rdi
0x00003B71: 4154                     push     r12
0x00003B73: 4155                     push     r13
0x00003B75: 4156                     push     r14
0x00003B77: 4157                     push     r15
0x00003B79: 488bec                   mov      rbp, rsp
0x00003B7C: 4883ec78                 sub      rsp, 0x78
0x00003B80: 488b0579340100           mov      rax, qword ptr [rip + 0x13479]
0x00003B87: 4833c4                   xor      rax, rsp
0x00003B8A: 488945f0                 mov      qword ptr [rbp - 0x10], rax
0x00003B8E: 33f6                     xor      esi, esi
0x00003B90: 8d9994f8ffff             lea      ebx, [rcx - 0x76c]
0x00003B96: 4d63e9                   movsxd   r13, r9d
0x00003B99: 8d43ba                   lea      eax, [rbx - 0x46]
0x00003B9C: 4863fa                   movsxd   rdi, edx
0x00003B9F: 8975b8                   mov      dword ptr [rbp - 0x48], esi
0x00003BA2: 8975bc                   mov      dword ptr [rbp - 0x44], esi
0x00003BA5: 8975c0                   mov      dword ptr [rbp - 0x40], esi
0x00003BA8: 3d06040000               cmp      eax, 0x406
0x00003BAD: 0f871a020000             ja       0x180003dcd
0x00003BB3: 8d47ff                   lea      eax, [rdi - 1]
0x00003BB6: 83f80b                   cmp      eax, 0xb
0x00003BB9: 0f870e020000             ja       0x180003dcd
0x00003BBF: 4183fd17                 cmp      r13d, 0x17
0x00003BC3: 0f8704020000             ja       0x180003dcd
0x00003BC9: 4c637d68                 movsxd   r15, dword ptr [rbp + 0x68]
0x00003BCD: 4183ff3b                 cmp      r15d, 0x3b
0x00003BD1: 0f87f6010000             ja       0x180003dcd
0x00003BD7: 4c636570                 movsxd   r12, dword ptr [rbp + 0x70]
0x00003BDB: 4183fc3b                 cmp      r12d, 0x3b
0x00003BDF: 0f87e8010000             ja       0x180003dcd
0x00003BE5: 448d5601                 lea      r10d, [rsi + 1]
0x00003BE9: 453bc2                   cmp      r8d, r10d
0x00003BEC: 0f8cdb010000             jl       0x180003dcd
0x00003BF2: 488d0d973e0100           lea      rcx, [rip + 0x13e97]
0x00003BF9: 41bb1f85eb51             mov      r11d, 0x51eb851f
0x00003BFF: 448b4cb9fc               mov      r9d, dword ptr [rcx + rdi*4 - 4]
0x00003C04: 8b0cb9                   mov      ecx, dword ptr [rcx + rdi*4]
0x00003C07: 412bc9                   sub      ecx, r9d
0x00003C0A: 413bc8                   cmp      ecx, r8d
0x00003C0D: 7d62                     jge      0x180003c71
0x00003C0F: 8bc3                     mov      eax, ebx
0x00003C11: 2503000080               and      eax, 0x80000003
0x00003C16: 7d09                     jge      0x180003c21
0x00003C18: 412bc2                   sub      eax, r10d
0x00003C1B: 83c8fc                   or       eax, 0xfffffffc
0x00003C1E: 4103c2                   add      eax, r10d
0x00003C21: 85c0                     test     eax, eax
0x00003C23: 7516                     jne      0x180003c3b
0x00003C25: 418bc3                   mov      eax, r11d
0x00003C28: f7eb                     imul     ebx
0x00003C2A: c1fa05                   sar      edx, 5
0x00003C2D: 8bc2                     mov      eax, edx
0x00003C2F: c1e81f                   shr      eax, 0x1f
0x00003C32: 03d0                     add      edx, eax
0x00003C34: 6bca64                   imul     ecx, edx, 0x64
0x00003C37: 3bd9                     cmp      ebx, ecx
0x00003C39: 7523                     jne      0x180003c5e
0x00003C3B: 8d8b6c070000             lea      ecx, [rbx + 0x76c]
0x00003C41: 418bc3                   mov      eax, r11d
0x00003C44: f7e9                     imul     ecx
0x00003C46: c1fa07                   sar      edx, 7
0x00003C49: 8bc2                     mov      eax, edx
0x00003C4B: c1e81f                   shr      eax, 0x1f
0x00003C4E: 03d0                     add      edx, eax
0x00003C50: 69c290010000             imul     eax, edx, 0x190
0x00003C56: 3bc8                     cmp      ecx, eax
0x00003C58: 0f856f010000             jne      0x180003dcd
0x00003C5E: 83ff02                   cmp      edi, 2
0x00003C61: 0f8566010000             jne      0x180003dcd
0x00003C67: 4183f81d                 cmp      r8d, 0x1d
0x00003C6B: 0f8f5c010000             jg       0x180003dcd
0x00003C71: 8bc3                     mov      eax, ebx
0x00003C73: 478d3401                 lea      r14d, [r9 + r8]
0x00003C77: 2503000080               and      eax, 0x80000003
0x00003C7C: 7d09                     jge      0x180003c87
0x00003C7E: 412bc2                   sub      eax, r10d
0x00003C81: 83c8fc                   or       eax, 0xfffffffc
0x00003C84: 4103c2                   add      eax, r10d
0x00003C87: 85c0                     test     eax, eax
0x00003C89: 7516                     jne      0x180003ca1
0x00003C8B: 418bc3                   mov      eax, r11d
0x00003C8E: f7eb                     imul     ebx
0x00003C90: c1fa05                   sar      edx, 5
0x00003C93: 8bc2                     mov      eax, edx
0x00003C95: c1e81f                   shr      eax, 0x1f
0x00003C98: 03d0                     add      edx, eax
0x00003C9A: 6bca64                   imul     ecx, edx, 0x64
0x00003C9D: 3bd9                     cmp      ebx, ecx
0x00003C9F: 751f                     jne      0x180003cc0
0x00003CA1: 8d8b6c070000             lea      ecx, [rbx + 0x76c]
0x00003CA7: 418bc3                   mov      eax, r11d
0x00003CAA: f7e9                     imul     ecx
0x00003CAC: c1fa07                   sar      edx, 7
0x00003CAF: 8bc2                     mov      eax, edx
0x00003CB1: c1e81f                   shr      eax, 0x1f
0x00003CB4: 03d0                     add      edx, eax
0x00003CB6: 69c290010000             imul     eax, edx, 0x190
0x00003CBC: 3bc8                     cmp      ecx, eax
0x00003CBE: 7508                     jne      0x180003cc8
0x00003CC0: 83ff02                   cmp      edi, 2
0x00003CC3: 7e03                     jle      0x180003cc8
0x00003CC5: 4503f2                   add      r14d, r10d
0x00003CC8: e837340000               call     0x180007104
0x00003CCD: 488d4db8                 lea      rcx, [rbp - 0x48]
0x00003CD1: e89e330000               call     0x180007074
0x00003CD6: 85c0                     test     eax, eax
0x00003CD8: 0f8545010000             jne      0x180003e23
0x00003CDE: 488d4dbc                 lea      rcx, [rbp - 0x44]
0x00003CE2: e8bd330000               call     0x1800070a4
0x00003CE7: 85c0                     test     eax, eax
0x00003CE9: 0f851f010000             jne      0x180003e0e
0x00003CEF: 488d4dc0                 lea      rcx, [rbp - 0x40]
0x00003CF3: e8dc330000               call     0x1800070d4
0x00003CF8: 85c0                     test     eax, eax
0x00003CFA: 0f85f9000000             jne      0x180003df9
0x00003D00: 8d8b2b010000             lea      ecx, [rbx + 0x12b]
0x00003D06: 41ba1f85eb51             mov      r10d, 0x51eb851f
0x00003D0C: 448d43ff                 lea      r8d, [rbx - 1]
0x00003D10: 418bc2                   mov      eax, r10d
0x00003D13: 448975e4                 mov      dword ptr [rbp - 0x1c], r14d
0x00003D17: 895ddc                   mov      dword ptr [rbp - 0x24], ebx
0x00003D1A: 44896dd0                 mov      dword ptr [rbp - 0x30], r13d
0x00003D1E: 44897dcc                 mov      dword ptr [rbp - 0x34], r15d
0x00003D22: 448965c8                 mov      dword ptr [rbp - 0x38], r12d
0x00003D26: f7e9                     imul     ecx
0x00003D28: 448bca                   mov      r9d, edx
0x00003D2B: 418bc2                   mov      eax, r10d
0x00003D2E: 41c1f907                 sar      r9d, 7
0x00003D32: 418bc9                   mov      ecx, r9d
0x00003D35: c1e91f                   shr      ecx, 0x1f
0x00003D38: 4403c9                   add      r9d, ecx
0x00003D3B: 41f7e8                   imul     r8d
0x00003D3E: c1fa05                   sar      edx, 5
0x00003D41: 418bc0                   mov      eax, r8d
0x00003D44: 8bca                     mov      ecx, edx
0x00003D46: c1e91f                   shr      ecx, 0x1f
0x00003D49: 03d1                     add      edx, ecx
0x00003D4B: 442bca                   sub      r9d, edx
0x00003D4E: 99                       cdq      
0x00003D4F: 83e203                   and      edx, 3
0x00003D52: 8d0c02                   lea      ecx, [rdx + rax]
0x00003D55: 4863c3                   movsxd   rax, ebx
0x00003D58: c1f902                   sar      ecx, 2
0x00003D5B: 4883e846                 sub      rax, 0x46
0x00003D5F: 83c1ef                   add      ecx, -0x11
0x00003D62: 4103c9                   add      ecx, r9d
0x00003D65: 4863d1                   movsxd   rdx, ecx
0x00003D68: 4869c06d010000           imul     rax, rax, 0x16d
0x00003D6F: 4803d0                   add      rdx, rax
0x00003D72: 4963c6                   movsxd   rax, r14d
0x00003D75: 4803d0                   add      rdx, rax
0x00003D78: 486345c0                 movsxd   rax, dword ptr [rbp - 0x40]
0x00003D7C: 488d0c52                 lea      rcx, [rdx + rdx*2]
0x00003D80: 488d0ccd00000000         lea      rcx, [rcx*8]
0x00003D88: 4903cd                   add      rcx, r13
0x00003D8B: 486bd13c                 imul     rdx, rcx, 0x3c
0x00003D8F: 4903d7                   add      rdx, r15
0x00003D92: 486bf23c                 imul     rsi, rdx, 0x3c
0x00003D96: 4803f0                   add      rsi, rax
0x00003D99: 8d47ff                   lea      eax, [rdi - 1]
0x00003D9C: 4903f4                   add      rsi, r12
0x00003D9F: 837d7801                 cmp      dword ptr [rbp + 0x78], 1
0x00003DA3: 8945d8                   mov      dword ptr [rbp - 0x28], eax
0x00003DA6: 7419                     je       0x180003dc1
0x00003DA8: 837d78ff                 cmp      dword ptr [rbp + 0x78], -1
0x00003DAC: 751a                     jne      0x180003dc8
0x00003DAE: 837db800                 cmp      dword ptr [rbp - 0x48], 0
0x00003DB2: 7414                     je       0x180003dc8
0x00003DB4: 488d4dc8                 lea      rcx, [rbp - 0x38]
0x00003DB8: e883330000               call     0x180007140
0x00003DBD: 85c0                     test     eax, eax
0x00003DBF: 7407                     je       0x180003dc8
0x00003DC1: 48634dbc                 movsxd   rcx, dword ptr [rbp - 0x44]
0x00003DC5: 4803f1                   add      rsi, rcx
0x00003DC8: 488bc6                   mov      rax, rsi
0x00003DCB: eb0f                     jmp      0x180003ddc
0x00003DCD: e8bae8ffff               call     0x18000268c
0x00003DD2: c70016000000             mov      dword ptr [rax], 0x16
0x00003DD8: 4883c8ff                 or       rax, 0xffffffffffffffff
0x00003DDC: 488b4df0                 mov      rcx, qword ptr [rbp - 0x10]
0x00003DE0: 4833cc                   xor      rcx, rsp
0x00003DE3: e828daffff               call     0x180001810
0x00003DE8: 4883c478                 add      rsp, 0x78
0x00003DEC: 415f                     pop      r15
0x00003DEE: 415e                     pop      r14
0x00003DF0: 415d                     pop      r13
0x00003DF2: 415c                     pop      r12
0x00003DF4: 5f                       pop      rdi
0x00003DF5: 5e                       pop      rsi
0x00003DF6: 5b                       pop      rbx
0x00003DF7: 5d                       pop      rbp
0x00003DF8: c3                       ret      
0x00003DF9: 4533c9                   xor      r9d, r9d
0x00003DFC: 4533c0                   xor      r8d, r8d
0x00003DFF: 33d2                     xor      edx, edx
0x00003E01: 33c9                     xor      ecx, ecx
0x00003E03: 4889742420               mov      qword ptr [rsp + 0x20], rsi
0x00003E08: e8b7faffff               call     0x1800038c4
0x00003E0D: cc                       int3     
0x00003E0E: 4533c9                   xor      r9d, r9d
0x00003E11: 4533c0                   xor      r8d, r8d
0x00003E14: 33d2                     xor      edx, edx
0x00003E16: 33c9                     xor      ecx, ecx
0x00003E18: 4889742420               mov      qword ptr [rsp + 0x20], rsi
0x00003E1D: e8a2faffff               call     0x1800038c4
0x00003E22: cc                       int3     
0x00003E23: 4533c9                   xor      r9d, r9d
0x00003E26: 4533c0                   xor      r8d, r8d
0x00003E29: 33d2                     xor      edx, edx
0x00003E2B: 33c9                     xor      ecx, ecx
0x00003E2D: 4889742420               mov      qword ptr [rsp + 0x20], rsi
0x00003E32: e88dfaffff               call     0x1800038c4
0x00003E37: cc                       int3     
0x00003E38: 4883ec28                 sub      rsp, 0x28
0x00003E3C: 4d8b4138                 mov      r8, qword ptr [r9 + 0x38]
0x00003E40: 488bca                   mov      rcx, rdx
0x00003E43: 498bd1                   mov      rdx, r9
0x00003E46: e80d000000               call     0x180003e58
0x00003E4B: b801000000               mov      eax, 1
0x00003E50: 4883c428                 add      rsp, 0x28
0x00003E54: c3                       ret      
0x00003E55: cc                       int3     
0x00003E56: cc                       int3     
0x00003E57: cc                       int3     
0x00003E58: 4053                     push     rbx
0x00003E5A: 4883ec20                 sub      rsp, 0x20
0x00003E5E: 458b18                   mov      r11d, dword ptr [r8]
0x00003E61: 488bda                   mov      rbx, rdx
0x00003E64: 4c8bc9                   mov      r9, rcx
0x00003E67: 4183e3f8                 and      r11d, 0xfffffff8
0x00003E6B: 41f60004                 test     byte ptr [r8], 4
0x00003E6F: 4c8bd1                   mov      r10, rcx
0x00003E72: 7413                     je       0x180003e87
0x00003E74: 418b4008                 mov      eax, dword ptr [r8 + 8]
0x00003E78: 4d635004                 movsxd   r10, dword ptr [r8 + 4]
0x00003E7C: f7d8                     neg      eax
0x00003E7E: 4c03d1                   add      r10, rcx
0x00003E81: 4863c8                   movsxd   rcx, eax
0x00003E84: 4c23d1                   and      r10, rcx
0x00003E87: 4963c3                   movsxd   rax, r11d
0x00003E8A: 4a8b1410                 mov      rdx, qword ptr [rax + r10]
0x00003E8E: 488b4310                 mov      rax, qword ptr [rbx + 0x10]
0x00003E92: 8b4808                   mov      ecx, dword ptr [rax + 8]
0x00003E95: 48034b08                 add      rcx, qword ptr [rbx + 8]
0x00003E99: f641030f                 test     byte ptr [rcx + 3], 0xf
0x00003E9D: 740c                     je       0x180003eab
0x00003E9F: 0fb64103                 movzx    eax, byte ptr [rcx + 3]
0x00003EA3: 83e0f0                   and      eax, 0xfffffff0
0x00003EA6: 4898                     cdqe     
0x00003EA8: 4c03c8                   add      r9, rax
0x00003EAB: 4c33ca                   xor      r9, rdx
0x00003EAE: 498bc9                   mov      rcx, r9
0x00003EB1: 4883c420                 add      rsp, 0x20
0x00003EB5: 5b                       pop      rbx
0x00003EB6: e955d9ffff               jmp      0x180001810
0x00003EBB: cc                       int3     
0x00003EBC: cc                       int3     
0x00003EBD: cc                       int3     
0x00003EBE: cc                       int3     
0x00003EBF: cc                       int3     
0x00003EC0: cc                       int3     
0x00003EC1: cc                       int3     
0x00003EC2: cc                       int3     
0x00003EC3: cc                       int3     
0x00003EC4: cc                       int3     
0x00003EC5: cc                       int3     
0x00003EC6: 66660f1f840000000000     nop      word ptr [rax + rax]
0x00003ED0: 482bd1                   sub      rdx, rcx
0x00003ED3: f6c107                   test     cl, 7
0x00003ED6: 7414                     je       0x180003eec
0x00003ED8: 0fb601                   movzx    eax, byte ptr [rcx]
0x00003EDB: 3a0411                   cmp      al, byte ptr [rcx + rdx]
0x00003EDE: 754f                     jne      0x180003f2f
0x00003EE0: 48ffc1                   inc      rcx
0x00003EE3: 84c0                     test     al, al
0x00003EE5: 7445                     je       0x180003f2c
0x00003EE7: f6c107                   test     cl, 7
0x00003EEA: 75ec                     jne      0x180003ed8
0x00003EEC: 49bb8080808080808080     movabs   r11, 0x8080808080808080
0x00003EF6: 49bafffefefefefefefe     movabs   r10, 0xfefefefefefefeff
0x00003F00: 678d0411                 lea      eax, [ecx + edx]
0x00003F04: 25ff0f0000               and      eax, 0xfff
0x00003F09: 3df80f0000               cmp      eax, 0xff8
0x00003F0E: 77c8                     ja       0x180003ed8
0x00003F10: 488b01                   mov      rax, qword ptr [rcx]
0x00003F13: 483b0411                 cmp      rax, qword ptr [rcx + rdx]
0x00003F17: 75bf                     jne      0x180003ed8
0x00003F19: 4d8d0c02                 lea      r9, [r10 + rax]
0x00003F1D: 48f7d0                   not      rax
0x00003F20: 4883c108                 add      rcx, 8
0x00003F24: 4923c1                   and      rax, r9
0x00003F27: 4985c3                   test     r11, rax
0x00003F2A: 74d4                     je       0x180003f00
0x00003F2C: 33c0                     xor      eax, eax
0x00003F2E: c3                       ret      
0x00003F2F: 481bc0                   sbb      rax, rax
0x00003F32: 4883c801                 or       rax, 1
0x00003F36: c3                       ret      
0x00003F37: cc                       int3     
0x00003F38: 48895c2408               mov      qword ptr [rsp + 8], rbx
0x00003F3D: 48896c2410               mov      qword ptr [rsp + 0x10], rbp
0x00003F42: 4889742418               mov      qword ptr [rsp + 0x18], rsi
0x00003F47: 57                       push     rdi
0x00003F48: 4883ec20                 sub      rsp, 0x20
0x00003F4C: 488bf2                   mov      rsi, rdx
0x00003F4F: 8bf9                     mov      edi, ecx
0x00003F51: e856030000               call     0x1800042ac
0x00003F56: 4533c9                   xor      r9d, r9d
0x00003F59: 488bd8                   mov      rbx, rax
0x00003F5C: 4885c0                   test     rax, rax
0x00003F5F: 0f8488010000             je       0x1800040ed
0x00003F65: 488b90a0000000           mov      rdx, qword ptr [rax + 0xa0]
0x00003F6C: 488bca                   mov      rcx, rdx
0x00003F6F: 3939                     cmp      dword ptr [rcx], edi
0x00003F71: 7410                     je       0x180003f83
0x00003F73: 488d82c0000000           lea      rax, [rdx + 0xc0]
0x00003F7A: 4883c110                 add      rcx, 0x10
0x00003F7E: 483bc8                   cmp      rcx, rax
0x00003F81: 72ec                     jb       0x180003f6f
0x00003F83: 488d82c0000000           lea      rax, [rdx + 0xc0]
0x00003F8A: 483bc8                   cmp      rcx, rax
0x00003F8D: 7304                     jae      0x180003f93
0x00003F8F: 3939                     cmp      dword ptr [rcx], edi
0x00003F91: 7403                     je       0x180003f96
0x00003F93: 498bc9                   mov      rcx, r9
0x00003F96: 4885c9                   test     rcx, rcx
0x00003F99: 0f844e010000             je       0x1800040ed
0x00003F9F: 4c8b4108                 mov      r8, qword ptr [rcx + 8]
0x00003FA3: 4d85c0                   test     r8, r8
0x00003FA6: 0f8441010000             je       0x1800040ed
0x00003FAC: 4983f805                 cmp      r8, 5
0x00003FB0: 750d                     jne      0x180003fbf
0x00003FB2: 4c894908                 mov      qword ptr [rcx + 8], r9
0x00003FB6: 418d40fc                 lea      eax, [r8 - 4]
0x00003FBA: e930010000               jmp      0x1800040ef
0x00003FBF: 4983f801                 cmp      r8, 1
0x00003FC3: 7508                     jne      0x180003fcd
0x00003FC5: 83c8ff                   or       eax, 0xffffffff
0x00003FC8: e922010000               jmp      0x1800040ef
0x00003FCD: 488baba8000000           mov      rbp, qword ptr [rbx + 0xa8]
0x00003FD4: 4889b3a8000000           mov      qword ptr [rbx + 0xa8], rsi
0x00003FDB: 83790408                 cmp      dword ptr [rcx + 4], 8
0x00003FDF: 0f85f2000000             jne      0x1800040d7
0x00003FE5: ba30000000               mov      edx, 0x30
0x00003FEA: 488b83a0000000           mov      rax, qword ptr [rbx + 0xa0]
0x00003FF1: 4883c210                 add      rdx, 0x10
0x00003FF5: 4c894c02f8               mov      qword ptr [rdx + rax - 8], r9
0x00003FFA: 4881fac0000000           cmp      rdx, 0xc0
0x00004001: 7ce7                     jl       0x180003fea
0x00004003: 81398e0000c0             cmp      dword ptr [rcx], 0xc000008e
0x00004009: 8bbbb0000000             mov      edi, dword ptr [rbx + 0xb0]
0x0000400F: 750f                     jne      0x180004020
0x00004011: c783b000000083000000     mov      dword ptr [rbx + 0xb0], 0x83
0x0000401B: e9a1000000               jmp      0x1800040c1
0x00004020: 8139900000c0             cmp      dword ptr [rcx], 0xc0000090
0x00004026: 750f                     jne      0x180004037
0x00004028: c783b000000081000000     mov      dword ptr [rbx + 0xb0], 0x81
0x00004032: e98a000000               jmp      0x1800040c1
0x00004037: 8139910000c0             cmp      dword ptr [rcx], 0xc0000091
0x0000403D: 750c                     jne      0x18000404b
0x0000403F: c783b000000084000000     mov      dword ptr [rbx + 0xb0], 0x84
0x00004049: eb76                     jmp      0x1800040c1
0x0000404B: 8139930000c0             cmp      dword ptr [rcx], 0xc0000093
0x00004051: 750c                     jne      0x18000405f
0x00004053: c783b000000085000000     mov      dword ptr [rbx + 0xb0], 0x85
0x0000405D: eb62                     jmp      0x1800040c1
0x0000405F: 81398d0000c0             cmp      dword ptr [rcx], 0xc000008d
0x00004065: 750c                     jne      0x180004073
0x00004067: c783b000000082000000     mov      dword ptr [rbx + 0xb0], 0x82
0x00004071: eb4e                     jmp      0x1800040c1
0x00004073: 81398f0000c0             cmp      dword ptr [rcx], 0xc000008f
0x00004079: 750c                     jne      0x180004087
0x0000407B: c783b000000086000000     mov      dword ptr [rbx + 0xb0], 0x86
0x00004085: eb3a                     jmp      0x1800040c1
0x00004087: 8139920000c0             cmp      dword ptr [rcx], 0xc0000092
0x0000408D: 750c                     jne      0x18000409b
0x0000408F: c783b00000008a000000     mov      dword ptr [rbx + 0xb0], 0x8a
0x00004099: eb26                     jmp      0x1800040c1
0x0000409B: 8139b50200c0             cmp      dword ptr [rcx], 0xc00002b5
0x000040A1: 750c                     jne      0x1800040af
0x000040A3: c783b00000008d000000     mov      dword ptr [rbx + 0xb0], 0x8d
0x000040AD: eb12                     jmp      0x1800040c1
0x000040AF: 8139b40200c0             cmp      dword ptr [rcx], 0xc00002b4
0x000040B5: 750a                     jne      0x1800040c1
0x000040B7: c783b00000008e000000     mov      dword ptr [rbx + 0xb0], 0x8e
0x000040C1: 8b93b0000000             mov      edx, dword ptr [rbx + 0xb0]
0x000040C7: b908000000               mov      ecx, 8
0x000040CC: 41ffd0                   call     r8
0x000040CF: 89bbb0000000             mov      dword ptr [rbx + 0xb0], edi
0x000040D5: eb0a                     jmp      0x1800040e1
0x000040D7: 4c894908                 mov      qword ptr [rcx + 8], r9
0x000040DB: 8b4904                   mov      ecx, dword ptr [rcx + 4]
0x000040DE: 41ffd0                   call     r8
0x000040E1: 4889aba8000000           mov      qword ptr [rbx + 0xa8], rbp
0x000040E8: e9d8feffff               jmp      0x180003fc5
0x000040ED: 33c0                     xor      eax, eax
0x000040EF: 488b5c2430               mov      rbx, qword ptr [rsp + 0x30]
0x000040F4: 488b6c2438               mov      rbp, qword ptr [rsp + 0x38]
0x000040F9: 488b742440               mov      rsi, qword ptr [rsp + 0x40]
0x000040FE: 4883c420                 add      rsp, 0x20
0x00004102: 5f                       pop      rdi
0x00004103: c3                       ret      
0x00004104: b863736de0               mov      eax, 0xe06d7363
0x00004109: 3bc8                     cmp      ecx, eax
0x0000410B: 7507                     jne      0x180004114
0x0000410D: 8bc8                     mov      ecx, eax
0x0000410F: e924feffff               jmp      0x180003f38
0x00004114: 33c0                     xor      eax, eax
0x00004116: c3                       ret      
0x00004117: cc                       int3     
0x00004118: 4885c9                   test     rcx, rcx
0x0000411B: 0f8429010000             je       0x18000424a
0x00004121: 48895c2410               mov      qword ptr [rsp + 0x10], rbx
0x00004126: 57                       push     rdi
0x00004127: 4883ec20                 sub      rsp, 0x20
0x0000412B: 488bd9                   mov      rbx, rcx
0x0000412E: 488b4938                 mov      rcx, qword ptr [rcx + 0x38]
0x00004132: 4885c9                   test     rcx, rcx
0x00004135: 7405                     je       0x18000413c
0x00004137: e8f4d6ffff               call     0x180001830
0x0000413C: 488b4b48                 mov      rcx, qword ptr [rbx + 0x48]
0x00004140: 4885c9                   test     rcx, rcx
0x00004143: 7405                     je       0x18000414a
0x00004145: e8e6d6ffff               call     0x180001830
0x0000414A: 488b4b58                 mov      rcx, qword ptr [rbx + 0x58]
0x0000414E: 4885c9                   test     rcx, rcx
0x00004151: 7405                     je       0x180004158
0x00004153: e8d8d6ffff               call     0x180001830
0x00004158: 488b4b68                 mov      rcx, qword ptr [rbx + 0x68]
0x0000415C: 4885c9                   test     rcx, rcx
0x0000415F: 7405                     je       0x180004166
0x00004161: e8cad6ffff               call     0x180001830
0x00004166: 488b4b70                 mov      rcx, qword ptr [rbx + 0x70]
0x0000416A: 4885c9                   test     rcx, rcx
0x0000416D: 7405                     je       0x180004174
0x0000416F: e8bcd6ffff               call     0x180001830
0x00004174: 488b4b78                 mov      rcx, qword ptr [rbx + 0x78]
0x00004178: 4885c9                   test     rcx, rcx
0x0000417B: 7405                     je       0x180004182
0x0000417D: e8aed6ffff               call     0x180001830
0x00004182: 488b8b80000000           mov      rcx, qword ptr [rbx + 0x80]
0x00004189: 4885c9                   test     rcx, rcx
0x0000418C: 7405                     je       0x180004193
0x0000418E: e89dd6ffff               call     0x180001830
0x00004193: 488b8ba0000000           mov      rcx, qword ptr [rbx + 0xa0]
0x0000419A: 488d05efbd0000           lea      rax, [rip + 0xbdef]
0x000041A1: 483bc8                   cmp      rcx, rax
0x000041A4: 7405                     je       0x1800041ab
0x000041A6: e885d6ffff               call     0x180001830
0x000041AB: bf0d000000               mov      edi, 0xd
0x000041B0: 8bcf                     mov      ecx, edi
0x000041B2: e8e9180000               call     0x180005aa0
0x000041B7: 90                       nop      
0x000041B8: 488b8bb8000000           mov      rcx, qword ptr [rbx + 0xb8]
0x000041BF: 48894c2430               mov      qword ptr [rsp + 0x30], rcx
0x000041C4: 4885c9                   test     rcx, rcx
0x000041C7: 741c                     je       0x1800041e5
0x000041C9: f0ff09                   lock dec dword ptr [rcx]
0x000041CC: 7517                     jne      0x1800041e5
0x000041CE: 488d05cb340100           lea      rax, [rip + 0x134cb]
0x000041D5: 488b4c2430               mov      rcx, qword ptr [rsp + 0x30]
0x000041DA: 483bc8                   cmp      rcx, rax
0x000041DD: 7406                     je       0x1800041e5
0x000041DF: e84cd6ffff               call     0x180001830
0x000041E4: 90                       nop      
0x000041E5: 8bcf                     mov      ecx, edi
0x000041E7: e8a41a0000               call     0x180005c90
0x000041EC: b90c000000               mov      ecx, 0xc
0x000041F1: e8aa180000               call     0x180005aa0
0x000041F6: 90                       nop      
0x000041F7: 488bbbc0000000           mov      rdi, qword ptr [rbx + 0xc0]
0x000041FE: 4885ff                   test     rdi, rdi
0x00004201: 742b                     je       0x18000422e
0x00004203: 488bcf                   mov      rcx, rdi
0x00004206: e8693b0000               call     0x180007d74
0x0000420B: 483b3dbe3b0100           cmp      rdi, qword ptr [rip + 0x13bbe]
0x00004212: 741a                     je       0x18000422e
0x00004214: 488d05c53b0100           lea      rax, [rip + 0x13bc5]
0x0000421B: 483bf8                   cmp      rdi, rax
0x0000421E: 740e                     je       0x18000422e
0x00004220: 833f00                   cmp      dword ptr [rdi], 0
0x00004223: 7509                     jne      0x18000422e
0x00004225: 488bcf                   mov      rcx, rdi
0x00004228: e8af390000               call     0x180007bdc
0x0000422D: 90                       nop      
0x0000422E: b90c000000               mov      ecx, 0xc
0x00004233: e8581a0000               call     0x180005c90
0x00004238: 488bcb                   mov      rcx, rbx
0x0000423B: e8f0d5ffff               call     0x180001830
0x00004240: 488b5c2438               mov      rbx, qword ptr [rsp + 0x38]
0x00004245: 4883c420                 add      rsp, 0x20
0x00004249: 5f                       pop      rdi
0x0000424A: c3                       ret      
0x0000424B: cc                       int3     
0x0000424C: 4053                     push     rbx
0x0000424E: 4883ec20                 sub      rsp, 0x20
0x00004252: 488bd9                   mov      rbx, rcx
0x00004255: 8b0d352f0100             mov      ecx, dword ptr [rip + 0x12f35]
0x0000425B: 83f9ff                   cmp      ecx, -1
0x0000425E: 7422                     je       0x180004282
0x00004260: 4885db                   test     rbx, rbx
0x00004263: 750e                     jne      0x180004273
0x00004265: e87e0c0000               call     0x180004ee8
0x0000426A: 8b0d202f0100             mov      ecx, dword ptr [rip + 0x12f20]
0x00004270: 488bd8                   mov      rbx, rax
0x00004273: 33d2                     xor      edx, edx
0x00004275: e88a0c0000               call     0x180004f04
0x0000427A: 488bcb                   mov      rcx, rbx
0x0000427D: e896feffff               call     0x180004118
0x00004282: 4883c420                 add      rsp, 0x20
0x00004286: 5b                       pop      rbx
0x00004287: c3                       ret      
0x00004288: 4053                     push     rbx
0x0000428A: 4883ec20                 sub      rsp, 0x20
0x0000428E: e819000000               call     0x1800042ac
0x00004293: 488bd8                   mov      rbx, rax
0x00004296: 4885c0                   test     rax, rax
0x00004299: 7508                     jne      0x1800042a3
0x0000429B: 8d4810                   lea      ecx, [rax + 0x10]
0x0000429E: e87de8ffff               call     0x180002b20
0x000042A3: 488bc3                   mov      rax, rbx
0x000042A6: 4883c420                 add      rsp, 0x20
0x000042AA: 5b                       pop      rbx
0x000042AB: c3                       ret      
0x000042AC: 48895c2408               mov      qword ptr [rsp + 8], rbx
0x000042B1: 57                       push     rdi
0x000042B2: 4883ec20                 sub      rsp, 0x20
0x000042B6: e86aa01600               call     0x18016e325
0x000042BB: 4f8b0dce2e0100           mov      r9, qword ptr [rip + 0x12ece]
0x000042C2: 8bf8                     mov      edi, eax
0x000042C4: e81f0c0000               call     0x180004ee8
0x000042C9: 488bd8                   mov      rbx, rax
0x000042CC: 4885c0                   test     rax, rax
0x000042CF: 7547                     jne      0x180004318
0x000042D1: 8d4801                   lea      ecx, [rax + 1]
0x000042D4: ba78040000               mov      edx, 0x478
0x000042D9: e87af0ffff               call     0x180003358
0x000042DE: 488bd8                   mov      rbx, rax
0x000042E1: 4885c0                   test     rax, rax
0x000042E4: 7432                     je       0x180004318
0x000042E6: 8b0da42e0100             mov      ecx, dword ptr [rip + 0x12ea4]
0x000042EC: 488bd0                   mov      rdx, rax
0x000042EF: e8100c0000               call     0x180004f04
0x000042F4: 488bcb                   mov      rcx, rbx
0x000042F7: 85c0                     test     eax, eax
0x000042F9: 7416                     je       0x180004311
0x000042FB: 33d2                     xor      edx, edx
0x000042FD: e82e000000               call     0x180004330
0x00004302: 55                       push     rbp
0x00004303: e89f2a1a00               call     0x1801a6da7
0x00004308: 48834b08ff               or       qword ptr [rbx + 8], 0xffffffffffffffff
0x0000430D: 8903                     mov      dword ptr [rbx], eax
0x0000430F: eb07                     jmp      0x180004318
0x00004311: e81ad5ffff               call     0x180001830
0x00004316: 33db                     xor      ebx, ebx
0x00004318: 8bcf                     mov      ecx, edi
0x0000431A: e879072300               call     0x180234a98
0x0000431F: 30488b                   xor      byte ptr [rax - 0x75], cl
0x00004322: c3                       ret      
0x00004323: 488b5c2430               mov      rbx, qword ptr [rsp + 0x30]
0x00004328: 4883c420                 add      rsp, 0x20
0x0000432C: 5f                       pop      rdi
0x0000432D: c3                       ret      
0x0000432E: cc                       int3     
0x0000432F: cc                       int3     
0x00004330: 48895c2408               mov      qword ptr [rsp + 8], rbx
0x00004335: 57                       push     rdi
0x00004336: 4883ec20                 sub      rsp, 0x20
0x0000433A: 488bfa                   mov      rdi, rdx
0x0000433D: 488bd9                   mov      rbx, rcx
0x00004340: 488d0549bc0000           lea      rax, [rip + 0xbc49]
0x00004347: 488981a0000000           mov      qword ptr [rcx + 0xa0], rax
0x0000434E: 83611000                 and      dword ptr [rcx + 0x10], 0
0x00004352: c7411c01000000           mov      dword ptr [rcx + 0x1c], 1
0x00004359: c781c800000001000000     mov      dword ptr [rcx + 0xc8], 1
0x00004363: b843000000               mov      eax, 0x43
0x00004368: 66898164010000           mov      word ptr [rcx + 0x164], ax
0x0000436F: 6689816a020000           mov      word ptr [rcx + 0x26a], ax
0x00004376: 488d0523330100           lea      rax, [rip + 0x13323]
0x0000437D: 488981b8000000           mov      qword ptr [rcx + 0xb8], rax
0x00004384: 4883a17004000000         and      qword ptr [rcx + 0x470], 0
0x0000438C: b90d000000               mov      ecx, 0xd
0x00004391: e80a170000               call     0x180005aa0
0x00004396: 90                       nop      
0x00004397: 488b83b8000000           mov      rax, qword ptr [rbx + 0xb8]
0x0000439E: f0ff00                   lock inc dword ptr [rax]
0x000043A1: b90d000000               mov      ecx, 0xd
0x000043A6: e8e5180000               call     0x180005c90
0x000043AB: b90c000000               mov      ecx, 0xc
0x000043B0: e8eb160000               call     0x180005aa0
0x000043B5: 90                       nop      
0x000043B6: 4889bbc0000000           mov      qword ptr [rbx + 0xc0], rdi
0x000043BD: 4885ff                   test     rdi, rdi
0x000043C0: 750e                     jne      0x1800043d0
0x000043C2: 488b05073a0100           mov      rax, qword ptr [rip + 0x13a07]
0x000043C9: 488983c0000000           mov      qword ptr [rbx + 0xc0], rax
0x000043D0: 488b8bc0000000           mov      rcx, qword ptr [rbx + 0xc0]
0x000043D7: e874370000               call     0x180007b50
0x000043DC: 90                       nop      
0x000043DD: b90c000000               mov      ecx, 0xc
0x000043E2: e8a9180000               call     0x180005c90
0x000043E7: 488b5c2430               mov      rbx, qword ptr [rsp + 0x30]
0x000043EC: 4883c420                 add      rsp, 0x20
0x000043F0: 5f                       pop      rdi
0x000043F1: c3                       ret      
0x000043F2: cc                       int3     
0x000043F3: cc                       int3     
0x000043F4: 4053                     push     rbx
0x000043F6: 4883ec20                 sub      rsp, 0x20
0x000043FA: e8fde7ffff               call     0x180002bfc
0x000043FF: e828180000               call     0x180005c2c
0x00004404: 85c0                     test     eax, eax
0x00004406: 745e                     je       0x180004466
0x00004408: 488d0d09fdffff           lea      rcx, [rip - 0x2f7]
0x0000440F: e89c0a0000               call     0x180004eb0
0x00004414: 8905762d0100             mov      dword ptr [rip + 0x12d76], eax
0x0000441A: 83f8ff                   cmp      eax, -1
0x0000441D: 7447                     je       0x180004466
0x0000441F: ba78040000               mov      edx, 0x478
0x00004424: b901000000               mov      ecx, 1
0x00004429: e82aefffff               call     0x180003358
0x0000442E: 488bd8                   mov      rbx, rax
0x00004431: 4885c0                   test     rax, rax
0x00004434: 7430                     je       0x180004466
0x00004436: 8b0d542d0100             mov      ecx, dword ptr [rip + 0x12d54]
0x0000443C: 488bd0                   mov      rdx, rax
0x0000443F: e8c00a0000               call     0x180004f04
0x00004444: 85c0                     test     eax, eax
0x00004446: 741e                     je       0x180004466
0x00004448: 33d2                     xor      edx, edx
0x0000444A: 488bcb                   mov      rcx, rbx
0x0000444D: e8defeffff               call     0x180004330
0x00004452: e850522500               call     0x1802596a7
0x00004457: 6e                       outsb    dx, byte ptr [rsi]
0x00004458: 48834b08ff               or       qword ptr [rbx + 8], 0xffffffffffffffff
0x0000445D: 8903                     mov      dword ptr [rbx], eax
0x0000445F: b801000000               mov      eax, 1
0x00004464: eb07                     jmp      0x18000446d
0x00004466: e809000000               call     0x180004474
0x0000446B: 33c0                     xor      eax, eax
0x0000446D: 4883c420                 add      rsp, 0x20
0x00004471: 5b                       pop      rbx
0x00004472: c3                       ret      
0x00004473: cc                       int3     
0x00004474: 4883ec28                 sub      rsp, 0x28
0x00004478: 8b0d122d0100             mov      ecx, dword ptr [rip + 0x12d12]
0x0000447E: 83f9ff                   cmp      ecx, -1
0x00004481: 740c                     je       0x18000448f
0x00004483: e8440a0000               call     0x180004ecc
0x00004488: 830d012d0100ff           or       dword ptr [rip + 0x12d01], 0xffffffff
0x0000448F: 4883c428                 add      rsp, 0x28
0x00004493: e94c160000               jmp      0x180005ae4
0x00004498: 488bc4                   mov      rax, rsp
0x0000449B: 48895808                 mov      qword ptr [rax + 8], rbx
0x0000449F: 48897010                 mov      qword ptr [rax + 0x10], rsi
0x000044A3: 48897818                 mov      qword ptr [rax + 0x18], rdi
0x000044A7: 4c896020                 mov      qword ptr [rax + 0x20], r12
0x000044AB: 4155                     push     r13
0x000044AD: 4156                     push     r14
0x000044AF: 4157                     push     r15
0x000044B1: 4881ecc0000000           sub      rsp, 0xc0
0x000044B8: 4889642448               mov      qword ptr [rsp + 0x48], rsp
0x000044BD: b90b000000               mov      ecx, 0xb
0x000044C2: e8d9150000               call     0x180005aa0
0x000044C7: 90                       nop      
0x000044C8: bf58000000               mov      edi, 0x58
0x000044CD: 8bd7                     mov      edx, edi
0x000044CF: 448d6fc8                 lea      r13d, [rdi - 0x38]
0x000044D3: 418bcd                   mov      ecx, r13d
0x000044D6: e87deeffff               call     0x180003358
0x000044DB: 488bc8                   mov      rcx, rax
0x000044DE: 4889442428               mov      qword ptr [rsp + 0x28], rax
0x000044E3: 4533e4                   xor      r12d, r12d
0x000044E6: 4885c0                   test     rax, rax
0x000044E9: 7519                     jne      0x180004504
0x000044EB: 488d150a000000           lea      rdx, [rip + 0xa]
0x000044F2: 488bcc                   mov      rcx, rsp
0x000044F5: e8f62a0000               call     0x180006ff0
0x000044FA: 90                       nop      
0x000044FB: 90                       nop      
0x000044FC: 83c8ff                   or       eax, 0xffffffff
0x000044FF: e99f020000               jmp      0x1800047a3
0x00004504: 488905b54e0100           mov      qword ptr [rip + 0x14eb5], rax
0x0000450B: 44892d76920100           mov      dword ptr [rip + 0x19276], r13d
0x00004512: 4805000b0000             add      rax, 0xb00
0x00004518: 483bc8                   cmp      rcx, rax
0x0000451B: 7339                     jae      0x180004556
0x0000451D: 66c74108000a             mov      word ptr [rcx + 8], 0xa00
0x00004523: 488309ff                 or       qword ptr [rcx], 0xffffffffffffffff
0x00004527: 4489610c                 mov      dword ptr [rcx + 0xc], r12d
0x0000452B: 80613880                 and      byte ptr [rcx + 0x38], 0x80
0x0000452F: 8a4138                   mov      al, byte ptr [rcx + 0x38]
0x00004532: 247f                     and      al, 0x7f
0x00004534: 884138                   mov      byte ptr [rcx + 0x38], al
0x00004537: 66c741390a0a             mov      word ptr [rcx + 0x39], 0xa0a
0x0000453D: 44896150                 mov      dword ptr [rcx + 0x50], r12d
0x00004541: 4488614c                 mov      byte ptr [rcx + 0x4c], r12b
0x00004545: 4803cf                   add      rcx, rdi
0x00004548: 48894c2428               mov      qword ptr [rsp + 0x28], rcx
0x0000454D: 488b056c4e0100           mov      rax, qword ptr [rip + 0x14e6c]
0x00004554: ebbc                     jmp      0x180004512
0x00004556: 488d4c2450               lea      rcx, [rsp + 0x50]
0x0000455B: 56                       push     rsi
0x0000455C: e895971c00               call     0x1801cdcf6
0x00004561: 664439a42492000000       cmp      word ptr [rsp + 0x92], r12w
0x0000456A: 0f8442010000             je       0x1800046b2
0x00004570: 488b842498000000         mov      rax, qword ptr [rsp + 0x98]
0x00004578: 4885c0                   test     rax, rax
0x0000457B: 0f8431010000             je       0x1800046b2
0x00004581: 4c8d7004                 lea      r14, [rax + 4]
0x00004585: 4c89742438               mov      qword ptr [rsp + 0x38], r14
0x0000458A: 486330                   movsxd   rsi, dword ptr [rax]
0x0000458D: 4903f6                   add      rsi, r14
0x00004590: 4889742440               mov      qword ptr [rsp + 0x40], rsi
0x00004595: 41bf00080000             mov      r15d, 0x800
0x0000459B: 443938                   cmp      dword ptr [rax], r15d
0x0000459E: 440f4c38                 cmovl    r15d, dword ptr [rax]
0x000045A2: bb01000000               mov      ebx, 1
0x000045A7: 895c2430                 mov      dword ptr [rsp + 0x30], ebx
0x000045AB: 44393dd6910100           cmp      dword ptr [rip + 0x191d6], r15d
0x000045B2: 7d73                     jge      0x180004627
0x000045B4: 488bd7                   mov      rdx, rdi
0x000045B7: 498bcd                   mov      rcx, r13
0x000045BA: e899edffff               call     0x180003358
0x000045BF: 488bc8                   mov      rcx, rax
0x000045C2: 4889442428               mov      qword ptr [rsp + 0x28], rax
0x000045C7: 4885c0                   test     rax, rax
0x000045CA: 7509                     jne      0x1800045d5
0x000045CC: 448b3db5910100           mov      r15d, dword ptr [rip + 0x191b5]
0x000045D3: eb52                     jmp      0x180004627
0x000045D5: 4863d3                   movsxd   rdx, ebx
0x000045D8: 4c8d05e14d0100           lea      r8, [rip + 0x14de1]
0x000045DF: 498904d0                 mov      qword ptr [r8 + rdx*8], rax
0x000045E3: 44012d9e910100           add      dword ptr [rip + 0x1919e], r13d
0x000045EA: 498b04d0                 mov      rax, qword ptr [r8 + rdx*8]
0x000045EE: 4805000b0000             add      rax, 0xb00
0x000045F4: 483bc8                   cmp      rcx, rax
0x000045F7: 732a                     jae      0x180004623
0x000045F9: 66c74108000a             mov      word ptr [rcx + 8], 0xa00
0x000045FF: 488309ff                 or       qword ptr [rcx], 0xffffffffffffffff
0x00004603: 4489610c                 mov      dword ptr [rcx + 0xc], r12d
0x00004607: 80613880                 and      byte ptr [rcx + 0x38], 0x80
0x0000460B: 66c741390a0a             mov      word ptr [rcx + 0x39], 0xa0a
0x00004611: 44896150                 mov      dword ptr [rcx + 0x50], r12d
0x00004615: 4488614c                 mov      byte ptr [rcx + 0x4c], r12b
0x00004619: 4803cf                   add      rcx, rdi
0x0000461C: 48894c2428               mov      qword ptr [rsp + 0x28], rcx
0x00004621: ebc7                     jmp      0x1800045ea
0x00004623: ffc3                     inc      ebx
0x00004625: eb80                     jmp      0x1800045a7
0x00004627: 418bfc                   mov      edi, r12d
0x0000462A: 4489642420               mov      dword ptr [rsp + 0x20], r12d
0x0000462F: 4c8d2d8a4d0100           lea      r13, [rip + 0x14d8a]
0x00004636: 413bff                   cmp      edi, r15d
0x00004639: 7d77                     jge      0x1800046b2
0x0000463B: 488b0e                   mov      rcx, qword ptr [rsi]
0x0000463E: 488d4102                 lea      rax, [rcx + 2]
0x00004642: 4883f801                 cmp      rax, 1
0x00004646: 7651                     jbe      0x180004699
0x00004648: 41f60601                 test     byte ptr [r14], 1
0x0000464C: 744b                     je       0x180004699
0x0000464E: 41f60608                 test     byte ptr [r14], 8
0x00004652: 750a                     jne      0x18000465e
0x00004654: 57                       push     rdi
0x00004655: e814e80200               call     0x180032e6e
0x0000465A: 85c0                     test     eax, eax
0x0000465C: 743b                     je       0x180004699
0x0000465E: 4863cf                   movsxd   rcx, edi
0x00004661: 488bc1                   mov      rax, rcx
0x00004664: 48c1f805                 sar      rax, 5
0x00004668: 83e11f                   and      ecx, 0x1f
0x0000466B: 486bd958                 imul     rbx, rcx, 0x58
0x0000466F: 49035cc500               add      rbx, qword ptr [r13 + rax*8]
0x00004674: 48895c2428               mov      qword ptr [rsp + 0x28], rbx
0x00004679: 488b06                   mov      rax, qword ptr [rsi]
0x0000467C: 488903                   mov      qword ptr [rbx], rax
0x0000467F: 418a06                   mov      al, byte ptr [r14]
0x00004682: 884308                   mov      byte ptr [rbx + 8], al
0x00004685: 488d4b10                 lea      rcx, [rbx + 0x10]
0x00004689: 4533c0                   xor      r8d, r8d
0x0000468C: baa00f0000               mov      edx, 0xfa0
0x00004691: e88a080000               call     0x180004f20
0x00004696: ff430c                   inc      dword ptr [rbx + 0xc]
0x00004699: ffc7                     inc      edi
0x0000469B: 897c2420                 mov      dword ptr [rsp + 0x20], edi
0x0000469F: 49ffc6                   inc      r14
0x000046A2: 4c89742438               mov      qword ptr [rsp + 0x38], r14
0x000046A7: 4883c608                 add      rsi, 8
0x000046AB: 4889742440               mov      qword ptr [rsp + 0x40], rsi
0x000046B0: eb84                     jmp      0x180004636
0x000046B2: 418bfc                   mov      edi, r12d
0x000046B5: 4489642420               mov      dword ptr [rsp + 0x20], r12d
0x000046BA: 49c7c7feffffff           mov      r15, 0xfffffffffffffffe
0x000046C1: 83ff03                   cmp      edi, 3
0x000046C4: 0f8dcd000000             jge      0x180004797
0x000046CA: 4863f7                   movsxd   rsi, edi
0x000046CD: 486bde58                 imul     rbx, rsi, 0x58
0x000046D1: 48031de84c0100           add      rbx, qword ptr [rip + 0x14ce8]
0x000046D8: 48895c2428               mov      qword ptr [rsp + 0x28], rbx
0x000046DD: 488b03                   mov      rax, qword ptr [rbx]
0x000046E0: 4883c002                 add      rax, 2
0x000046E4: 4883f801                 cmp      rax, 1
0x000046E8: 7610                     jbe      0x1800046fa
0x000046EA: 0fbe4308                 movsx    eax, byte ptr [rbx + 8]
0x000046EE: 0fbae807                 bts      eax, 7
0x000046F2: 884308                   mov      byte ptr [rbx + 8], al
0x000046F5: e992000000               jmp      0x18000478c
0x000046FA: c6430881                 mov      byte ptr [rbx + 8], 0x81
0x000046FE: 8d47ff                   lea      eax, [rdi - 1]
0x00004701: f7d8                     neg      eax
0x00004703: 1bc9                     sbb      ecx, ecx
0x00004705: 83c1f5                   add      ecx, -0xb
0x00004708: b8f6ffffff               mov      eax, 0xfffffff6
0x0000470D: 85ff                     test     edi, edi
0x0000470F: 0f44c8                   cmove    ecx, eax
0x00004712: e8006b1600               call     0x18016b217
0x00004717: 044c                     add      al, 0x4c
0x00004719: 8bf0                     mov      esi, eax
0x0000471B: 488d4801                 lea      rcx, [rax + 1]
0x0000471F: 4883f901                 cmp      rcx, 1
0x00004723: 7646                     jbe      0x18000476b
0x00004725: 488bc8                   mov      rcx, rax
0x00004728: 53                       push     rbx
0x00004729: e8bf401700               call     0x1801787ed
0x0000472E: 85c0                     test     eax, eax
0x00004730: 7439                     je       0x18000476b
0x00004732: 4c8933                   mov      qword ptr [rbx], r14
0x00004735: 0fb6c0                   movzx    eax, al
0x00004738: 83f802                   cmp      eax, 2
0x0000473B: 7509                     jne      0x180004746
0x0000473D: 0fbe4308                 movsx    eax, byte ptr [rbx + 8]
0x00004741: 83c840                   or       eax, 0x40
0x00004744: eb0c                     jmp      0x180004752
0x00004746: 83f803                   cmp      eax, 3
0x00004749: 750a                     jne      0x180004755
0x0000474B: 0fbe4308                 movsx    eax, byte ptr [rbx + 8]
0x0000474F: 83c808                   or       eax, 8
0x00004752: 884308                   mov      byte ptr [rbx + 8], al
0x00004755: 488d4b10                 lea      rcx, [rbx + 0x10]
0x00004759: 4533c0                   xor      r8d, r8d
0x0000475C: baa00f0000               mov      edx, 0xfa0
0x00004761: e8ba070000               call     0x180004f20
0x00004766: ff430c                   inc      dword ptr [rbx + 0xc]
0x00004769: eb21                     jmp      0x18000478c
0x0000476B: 0fbe4308                 movsx    eax, byte ptr [rbx + 8]
0x0000476F: 83c840                   or       eax, 0x40
0x00004772: 884308                   mov      byte ptr [rbx + 8], al
0x00004775: 4c893b                   mov      qword ptr [rbx], r15
0x00004778: 488b05b97e0100           mov      rax, qword ptr [rip + 0x17eb9]
0x0000477F: 4885c0                   test     rax, rax
0x00004782: 7408                     je       0x18000478c
0x00004784: 488b04f0                 mov      rax, qword ptr [rax + rsi*8]
0x00004788: 4489781c                 mov      dword ptr [rax + 0x1c], r15d
0x0000478C: ffc7                     inc      edi
0x0000478E: 897c2420                 mov      dword ptr [rsp + 0x20], edi
0x00004792: e92affffff               jmp      0x1800046c1
0x00004797: b90b000000               mov      ecx, 0xb
0x0000479C: e8ef140000               call     0x180005c90
0x000047A1: 33c0                     xor      eax, eax
0x000047A3: 4c8d9c24c0000000         lea      r11, [rsp + 0xc0]
0x000047AB: 498b5b20                 mov      rbx, qword ptr [r11 + 0x20]
0x000047AF: 498b7328                 mov      rsi, qword ptr [r11 + 0x28]
0x000047B3: 498b7b30                 mov      rdi, qword ptr [r11 + 0x30]
0x000047B7: 4d8b6338                 mov      r12, qword ptr [r11 + 0x38]
0x000047BB: 498be3                   mov      rsp, r11
0x000047BE: 415f                     pop      r15
0x000047C0: 415e                     pop      r14
0x000047C2: 415d                     pop      r13
0x000047C4: c3                       ret      
0x000047C5: cc                       int3     
0x000047C6: cc                       int3     
0x000047C7: cc                       int3     
0x000047C8: 48895c2408               mov      qword ptr [rsp + 8], rbx
0x000047CD: 4889742410               mov      qword ptr [rsp + 0x10], rsi
0x000047D2: 57                       push     rdi
0x000047D3: 4883ec20                 sub      rsp, 0x20
0x000047D7: 488d3de24b0100           lea      rdi, [rip + 0x14be2]
0x000047DE: be40000000               mov      esi, 0x40
0x000047E3: 488b1f                   mov      rbx, qword ptr [rdi]
0x000047E6: 4885db                   test     rbx, rbx
0x000047E9: 7437                     je       0x180004822
0x000047EB: 488d83000b0000           lea      rax, [rbx + 0xb00]
0x000047F2: eb1d                     jmp      0x180004811
0x000047F4: 837b0c00                 cmp      dword ptr [rbx + 0xc], 0
0x000047F8: 740a                     je       0x180004804
0x000047FA: 488d4b10                 lea      rcx, [rbx + 0x10]
0x000047FE: 55                       push     rbp
0x000047FF: e8a71e0300               call     0x1800366ab
0x00004804: 488b07                   mov      rax, qword ptr [rdi]
0x00004807: 4883c358                 add      rbx, 0x58
0x0000480B: 4805000b0000             add      rax, 0xb00
0x00004811: 483bd8                   cmp      rbx, rax
0x00004814: 72de                     jb       0x1800047f4
0x00004816: 488b0f                   mov      rcx, qword ptr [rdi]
0x00004819: e812d0ffff               call     0x180001830
0x0000481E: 48832700                 and      qword ptr [rdi], 0
0x00004822: 4883c708                 add      rdi, 8
0x00004826: 48ffce                   dec      rsi
0x00004829: 75b8                     jne      0x1800047e3
0x0000482B: 488b5c2430               mov      rbx, qword ptr [rsp + 0x30]
0x00004830: 488b742438               mov      rsi, qword ptr [rsp + 0x38]
0x00004835: 4883c420                 add      rsp, 0x20
0x00004839: 5f                       pop      rdi
0x0000483A: c3                       ret      
0x0000483B: cc                       int3     
0x0000483C: 48895c2418               mov      qword ptr [rsp + 0x18], rbx
0x00004841: 4889742420               mov      qword ptr [rsp + 0x20], rsi
0x00004846: 57                       push     rdi
0x00004847: 4883ec30                 sub      rsp, 0x30
0x0000484B: 833d5e8f010000           cmp      dword ptr [rip + 0x18f5e], 0
0x00004852: 7505                     jne      0x180004859
0x00004854: e817180000               call     0x180006070
0x00004859: 488d3d604d0100           lea      rdi, [rip + 0x14d60]
0x00004860: 41b804010000             mov      r8d, 0x104
0x00004866: 33c9                     xor      ecx, ecx
0x00004868: 488bd7                   mov      rdx, rdi
0x0000486B: c605524e010000           mov      byte ptr [rip + 0x14e52], 0
0x00004872: 50                       push     rax
0x00004873: e8758b2200               call     0x18022d3ed
0x00004878: 488b1d398f0100           mov      rbx, qword ptr [rip + 0x18f39]
0x0000487F: 48893daa440100           mov      qword ptr [rip + 0x144aa], rdi
0x00004886: 4885db                   test     rbx, rbx
0x00004889: 7405                     je       0x180004890
0x0000488B: 803b00                   cmp      byte ptr [rbx], 0
0x0000488E: 7503                     jne      0x180004893
0x00004890: 488bdf                   mov      rbx, rdi
0x00004893: 488d442448               lea      rax, [rsp + 0x48]
0x00004898: 4c8d4c2440               lea      r9, [rsp + 0x40]
0x0000489D: 4533c0                   xor      r8d, r8d
0x000048A0: 33d2                     xor      edx, edx
0x000048A2: 488bcb                   mov      rcx, rbx
0x000048A5: 4889442420               mov      qword ptr [rsp + 0x20], rax
0x000048AA: e881000000               call     0x180004930
0x000048AF: 4863742440               movsxd   rsi, dword ptr [rsp + 0x40]
0x000048B4: 48b9ffffffffffffff1f     movabs   rcx, 0x1fffffffffffffff
0x000048BE: 483bf1                   cmp      rsi, rcx
0x000048C1: 7359                     jae      0x18000491c
0x000048C3: 48634c2448               movsxd   rcx, dword ptr [rsp + 0x48]
0x000048C8: 4883f9ff                 cmp      rcx, -1
0x000048CC: 734e                     jae      0x18000491c
0x000048CE: 488d14f1                 lea      rdx, [rcx + rsi*8]
0x000048D2: 483bd1                   cmp      rdx, rcx
0x000048D5: 7245                     jb       0x18000491c
0x000048D7: 488bca                   mov      rcx, rdx
0x000048DA: e8f9eaffff               call     0x1800033d8
0x000048DF: 488bf8                   mov      rdi, rax
0x000048E2: 4885c0                   test     rax, rax
0x000048E5: 7435                     je       0x18000491c
0x000048E7: 4c8d04f0                 lea      r8, [rax + rsi*8]
0x000048EB: 488d442448               lea      rax, [rsp + 0x48]
0x000048F0: 4c8d4c2440               lea      r9, [rsp + 0x40]
0x000048F5: 488bd7                   mov      rdx, rdi
0x000048F8: 488bcb                   mov      rcx, rbx
0x000048FB: 4889442420               mov      qword ptr [rsp + 0x20], rax
0x00004900: e82b000000               call     0x180004930
0x00004905: 8b442440                 mov      eax, dword ptr [rsp + 0x40]
0x00004909: 48893d00440100           mov      qword ptr [rip + 0x14400], rdi
0x00004910: ffc8                     dec      eax
0x00004912: 8905f4430100             mov      dword ptr [rip + 0x143f4], eax
0x00004918: 33c0                     xor      eax, eax
0x0000491A: eb03                     jmp      0x18000491f
0x0000491C: 83c8ff                   or       eax, 0xffffffff
0x0000491F: 488b5c2450               mov      rbx, qword ptr [rsp + 0x50]
0x00004924: 488b742458               mov      rsi, qword ptr [rsp + 0x58]
0x00004929: 4883c430                 add      rsp, 0x30
0x0000492D: 5f                       pop      rdi
0x0000492E: c3                       ret      
0x0000492F: cc                       int3     
0x00004930: 488bc4                   mov      rax, rsp
0x00004933: 48895808                 mov      qword ptr [rax + 8], rbx
0x00004937: 48896810                 mov      qword ptr [rax + 0x10], rbp
0x0000493B: 48897018                 mov      qword ptr [rax + 0x18], rsi
0x0000493F: 48897820                 mov      qword ptr [rax + 0x20], rdi
0x00004943: 4154                     push     r12
0x00004945: 4156                     push     r14
0x00004947: 4157                     push     r15
0x00004949: 4883ec20                 sub      rsp, 0x20
0x0000494D: 4c8b742460               mov      r14, qword ptr [rsp + 0x60]
0x00004952: 4d8be1                   mov      r12, r9
0x00004955: 498bf8                   mov      rdi, r8
0x00004958: 41832600                 and      dword ptr [r14], 0
0x0000495C: 4c8bfa                   mov      r15, rdx
0x0000495F: 488bd9                   mov      rbx, rcx
0x00004962: 41c70101000000           mov      dword ptr [r9], 1
0x00004969: 4885d2                   test     rdx, rdx
0x0000496C: 7407                     je       0x180004975
0x0000496E: 4c8902                   mov      qword ptr [rdx], r8
0x00004971: 4983c708                 add      r15, 8
0x00004975: 33ed                     xor      ebp, ebp
0x00004977: 803b22                   cmp      byte ptr [rbx], 0x22
0x0000497A: 7511                     jne      0x18000498d
0x0000497C: 33c0                     xor      eax, eax
0x0000497E: 85ed                     test     ebp, ebp
0x00004980: 40b622                   mov      sil, 0x22
0x00004983: 0f94c0                   sete     al
0x00004986: 48ffc3                   inc      rbx
0x00004989: 8be8                     mov      ebp, eax
0x0000498B: eb37                     jmp      0x1800049c4
0x0000498D: 41ff06                   inc      dword ptr [r14]
0x00004990: 4885ff                   test     rdi, rdi
0x00004993: 7407                     je       0x18000499c
0x00004995: 8a03                     mov      al, byte ptr [rbx]
0x00004997: 8807                     mov      byte ptr [rdi], al
0x00004999: 48ffc7                   inc      rdi
0x0000499C: 0fb633                   movzx    esi, byte ptr [rbx]
0x0000499F: 48ffc3                   inc      rbx
0x000049A2: 8bce                     mov      ecx, esi
0x000049A4: e89b370000               call     0x180008144
0x000049A9: 85c0                     test     eax, eax
0x000049AB: 7412                     je       0x1800049bf
0x000049AD: 41ff06                   inc      dword ptr [r14]
0x000049B0: 4885ff                   test     rdi, rdi
0x000049B3: 7407                     je       0x1800049bc
0x000049B5: 8a03                     mov      al, byte ptr [rbx]
0x000049B7: 8807                     mov      byte ptr [rdi], al
0x000049B9: 48ffc7                   inc      rdi
0x000049BC: 48ffc3                   inc      rbx
0x000049BF: 4084f6                   test     sil, sil
0x000049C2: 741b                     je       0x1800049df
0x000049C4: 85ed                     test     ebp, ebp
0x000049C6: 75af                     jne      0x180004977
0x000049C8: 4080fe20                 cmp      sil, 0x20
0x000049CC: 7406                     je       0x1800049d4
0x000049CE: 4080fe09                 cmp      sil, 9
0x000049D2: 75a3                     jne      0x180004977
0x000049D4: 4885ff                   test     rdi, rdi
0x000049D7: 7409                     je       0x1800049e2
0x000049D9: c647ff00                 mov      byte ptr [rdi - 1], 0
0x000049DD: eb03                     jmp      0x1800049e2
0x000049DF: 48ffcb                   dec      rbx
0x000049E2: 33f6                     xor      esi, esi
0x000049E4: 803b00                   cmp      byte ptr [rbx], 0
0x000049E7: 0f84de000000             je       0x180004acb
0x000049ED: 803b20                   cmp      byte ptr [rbx], 0x20
0x000049F0: 7405                     je       0x1800049f7
0x000049F2: 803b09                   cmp      byte ptr [rbx], 9
0x000049F5: 7505                     jne      0x1800049fc
0x000049F7: 48ffc3                   inc      rbx
0x000049FA: ebf1                     jmp      0x1800049ed
0x000049FC: 803b00                   cmp      byte ptr [rbx], 0
0x000049FF: 0f84c6000000             je       0x180004acb
0x00004A05: 4d85ff                   test     r15, r15
0x00004A08: 7407                     je       0x180004a11
0x00004A0A: 49893f                   mov      qword ptr [r15], rdi
0x00004A0D: 4983c708                 add      r15, 8
0x00004A11: 41ff0424                 inc      dword ptr [r12]
0x00004A15: ba01000000               mov      edx, 1
0x00004A1A: 33c9                     xor      ecx, ecx
0x00004A1C: eb05                     jmp      0x180004a23
0x00004A1E: 48ffc3                   inc      rbx
0x00004A21: ffc1                     inc      ecx
0x00004A23: 803b5c                   cmp      byte ptr [rbx], 0x5c
0x00004A26: 74f6                     je       0x180004a1e
0x00004A28: 803b22                   cmp      byte ptr [rbx], 0x22
0x00004A2B: 7535                     jne      0x180004a62
0x00004A2D: 84ca                     test     dl, cl
0x00004A2F: 751d                     jne      0x180004a4e
0x00004A31: 85f6                     test     esi, esi
0x00004A33: 740e                     je       0x180004a43
0x00004A35: 488d4301                 lea      rax, [rbx + 1]
0x00004A39: 803822                   cmp      byte ptr [rax], 0x22
0x00004A3C: 7505                     jne      0x180004a43
0x00004A3E: 488bd8                   mov      rbx, rax
0x00004A41: eb0b                     jmp      0x180004a4e
0x00004A43: 33c0                     xor      eax, eax
0x00004A45: 33d2                     xor      edx, edx
0x00004A47: 85f6                     test     esi, esi
0x00004A49: 0f94c0                   sete     al
0x00004A4C: 8bf0                     mov      esi, eax
0x00004A4E: d1e9                     shr      ecx, 1
0x00004A50: eb10                     jmp      0x180004a62
0x00004A52: ffc9                     dec      ecx
0x00004A54: 4885ff                   test     rdi, rdi
0x00004A57: 7406                     je       0x180004a5f
0x00004A59: c6075c                   mov      byte ptr [rdi], 0x5c
0x00004A5C: 48ffc7                   inc      rdi
0x00004A5F: 41ff06                   inc      dword ptr [r14]
0x00004A62: 85c9                     test     ecx, ecx
0x00004A64: 75ec                     jne      0x180004a52
0x00004A66: 8a03                     mov      al, byte ptr [rbx]
0x00004A68: 84c0                     test     al, al
0x00004A6A: 744c                     je       0x180004ab8
0x00004A6C: 85f6                     test     esi, esi
0x00004A6E: 7508                     jne      0x180004a78
0x00004A70: 3c20                     cmp      al, 0x20
0x00004A72: 7444                     je       0x180004ab8
0x00004A74: 3c09                     cmp      al, 9
0x00004A76: 7440                     je       0x180004ab8
0x00004A78: 85d2                     test     edx, edx
0x00004A7A: 7434                     je       0x180004ab0
0x00004A7C: 0fbec8                   movsx    ecx, al
0x00004A7F: e8c0360000               call     0x180008144
0x00004A84: 4885ff                   test     rdi, rdi
0x00004A87: 741a                     je       0x180004aa3
0x00004A89: 85c0                     test     eax, eax
0x00004A8B: 740d                     je       0x180004a9a
0x00004A8D: 8a03                     mov      al, byte ptr [rbx]
0x00004A8F: 48ffc3                   inc      rbx
0x00004A92: 8807                     mov      byte ptr [rdi], al
0x00004A94: 48ffc7                   inc      rdi
0x00004A97: 41ff06                   inc      dword ptr [r14]
0x00004A9A: 8a03                     mov      al, byte ptr [rbx]
0x00004A9C: 8807                     mov      byte ptr [rdi], al
0x00004A9E: 48ffc7                   inc      rdi
0x00004AA1: eb0a                     jmp      0x180004aad
0x00004AA3: 85c0                     test     eax, eax
0x00004AA5: 7406                     je       0x180004aad
0x00004AA7: 48ffc3                   inc      rbx
0x00004AAA: 41ff06                   inc      dword ptr [r14]
0x00004AAD: 41ff06                   inc      dword ptr [r14]
0x00004AB0: 48ffc3                   inc      rbx
0x00004AB3: e95dffffff               jmp      0x180004a15
0x00004AB8: 4885ff                   test     rdi, rdi
0x00004ABB: 7406                     je       0x180004ac3
0x00004ABD: c60700                   mov      byte ptr [rdi], 0
0x00004AC0: 48ffc7                   inc      rdi
0x00004AC3: 41ff06                   inc      dword ptr [r14]
0x00004AC6: e919ffffff               jmp      0x1800049e4
0x00004ACB: 4d85ff                   test     r15, r15
0x00004ACE: 7404                     je       0x180004ad4
0x00004AD0: 49832700                 and      qword ptr [r15], 0
0x00004AD4: 41ff0424                 inc      dword ptr [r12]
0x00004AD8: 488b5c2440               mov      rbx, qword ptr [rsp + 0x40]
0x00004ADD: 488b6c2448               mov      rbp, qword ptr [rsp + 0x48]
0x00004AE2: 488b742450               mov      rsi, qword ptr [rsp + 0x50]
0x00004AE7: 488b7c2458               mov      rdi, qword ptr [rsp + 0x58]
0x00004AEC: 4883c420                 add      rsp, 0x20
0x00004AF0: 415f                     pop      r15
0x00004AF2: 415e                     pop      r14
0x00004AF4: 415c                     pop      r12
0x00004AF6: c3                       ret      
0x00004AF7: cc                       int3     
0x00004AF8: 48895c2408               mov      qword ptr [rsp + 8], rbx
0x00004AFD: 48896c2410               mov      qword ptr [rsp + 0x10], rbp
0x00004B02: 4889742418               mov      qword ptr [rsp + 0x18], rsi
0x00004B07: 57                       push     rdi
0x00004B08: 4883ec30                 sub      rsp, 0x30
0x00004B0C: 833d9d8c010000           cmp      dword ptr [rip + 0x18c9d], 0
0x00004B13: 7505                     jne      0x180004b1a
0x00004B15: e856150000               call     0x180006070
0x00004B1A: 488b1d4f3c0100           mov      rbx, qword ptr [rip + 0x13c4f]
0x00004B21: 33ff                     xor      edi, edi
0x00004B23: 4885db                   test     rbx, rbx
0x00004B26: 751c                     jne      0x180004b44
0x00004B28: 83c8ff                   or       eax, 0xffffffff
0x00004B2B: e9b5000000               jmp      0x180004be5
0x00004B30: 3c3d                     cmp      al, 0x3d
0x00004B32: 7402                     je       0x180004b36
0x00004B34: ffc7                     inc      edi
0x00004B36: 488bcb                   mov      rcx, rbx
0x00004B39: e8c21e0000               call     0x180006a00
0x00004B3E: 48ffc3                   inc      rbx
0x00004B41: 4803d8                   add      rbx, rax
0x00004B44: 8a03                     mov      al, byte ptr [rbx]
0x00004B46: 84c0                     test     al, al
0x00004B48: 75e6                     jne      0x180004b30
0x00004B4A: 8d4701                   lea      eax, [rdi + 1]
0x00004B4D: ba08000000               mov      edx, 8
0x00004B52: 4863c8                   movsxd   rcx, eax
0x00004B55: e8fee7ffff               call     0x180003358
0x00004B5A: 488bf8                   mov      rdi, rax
0x00004B5D: 488905bc410100           mov      qword ptr [rip + 0x141bc], rax
0x00004B64: 4885c0                   test     rax, rax
0x00004B67: 74bf                     je       0x180004b28
0x00004B69: 488b1d003c0100           mov      rbx, qword ptr [rip + 0x13c00]
0x00004B70: 803b00                   cmp      byte ptr [rbx], 0
0x00004B73: 7450                     je       0x180004bc5
0x00004B75: 488bcb                   mov      rcx, rbx
0x00004B78: e8831e0000               call     0x180006a00
0x00004B7D: 803b3d                   cmp      byte ptr [rbx], 0x3d
0x00004B80: 8d7001                   lea      esi, [rax + 1]
0x00004B83: 742e                     je       0x180004bb3
0x00004B85: 4863ee                   movsxd   rbp, esi
0x00004B88: ba01000000               mov      edx, 1
0x00004B8D: 488bcd                   mov      rcx, rbp
0x00004B90: e8c3e7ffff               call     0x180003358
0x00004B95: 488907                   mov      qword ptr [rdi], rax
0x00004B98: 4885c0                   test     rax, rax
0x00004B9B: 745d                     je       0x180004bfa
0x00004B9D: 4c8bc3                   mov      r8, rbx
0x00004BA0: 488bd5                   mov      rdx, rbp
0x00004BA3: 488bc8                   mov      rcx, rax
0x00004BA6: e8e9d2ffff               call     0x180001e94
0x00004BAB: 85c0                     test     eax, eax
0x00004BAD: 7564                     jne      0x180004c13
0x00004BAF: 4883c708                 add      rdi, 8
0x00004BB3: 4863c6                   movsxd   rax, esi
0x00004BB6: 4803d8                   add      rbx, rax
0x00004BB9: 803b00                   cmp      byte ptr [rbx], 0
0x00004BBC: 75b7                     jne      0x180004b75
0x00004BBE: 488b1dab3b0100           mov      rbx, qword ptr [rip + 0x13bab]
0x00004BC5: 488bcb                   mov      rcx, rbx
0x00004BC8: e863ccffff               call     0x180001830
0x00004BCD: 4883259b3b010000         and      qword ptr [rip + 0x13b9b], 0
0x00004BD5: 48832700                 and      qword ptr [rdi], 0
0x00004BD9: c705d18b010001000000     mov      dword ptr [rip + 0x18bd1], 1
0x00004BE3: 33c0                     xor      eax, eax
0x00004BE5: 488b5c2440               mov      rbx, qword ptr [rsp + 0x40]
0x00004BEA: 488b6c2448               mov      rbp, qword ptr [rsp + 0x48]
0x00004BEF: 488b742450               mov      rsi, qword ptr [rsp + 0x50]
0x00004BF4: 4883c430                 add      rsp, 0x30
0x00004BF8: 5f                       pop      rdi
0x00004BF9: c3                       ret      
0x00004BFA: 488b0d1f410100           mov      rcx, qword ptr [rip + 0x1411f]
0x00004C01: e82accffff               call     0x180001830
0x00004C06: 4883251241010000         and      qword ptr [rip + 0x14112], 0
0x00004C0E: e915ffffff               jmp      0x180004b28
0x00004C13: 488364242000             and      qword ptr [rsp + 0x20], 0
0x00004C19: 4533c9                   xor      r9d, r9d
0x00004C1C: 4533c0                   xor      r8d, r8d
0x00004C1F: 33d2                     xor      edx, edx
0x00004C21: 33c9                     xor      ecx, ecx
0x00004C23: e89cecffff               call     0x1800038c4
0x00004C28: cc                       int3     
0x00004C29: cc                       int3     
0x00004C2A: cc                       int3     
0x00004C2B: cc                       int3     
0x00004C2C: 48895c2420               mov      qword ptr [rsp + 0x20], rbx
0x00004C31: 55                       push     rbp
0x00004C32: 488bec                   mov      rbp, rsp
0x00004C35: 4883ec20                 sub      rsp, 0x20
0x00004C39: 488b05c0230100           mov      rax, qword ptr [rip + 0x123c0]
0x00004C40: 4883651800               and      qword ptr [rbp + 0x18], 0
0x00004C45: 48bb32a2df2d992b0000     movabs   rbx, 0x2b992ddfa232
0x00004C4F: 483bc3                   cmp      rax, rbx
0x00004C52: 756f                     jne      0x180004cc3
0x00004C54: 488d4d18                 lea      rcx, [rbp + 0x18]
0x00004C58: e8550b1b00               call     0x1801b57b2
0x00004C5D: 7d48                     jge      0x180004ca7
0x00004C5F: 8b4518                   mov      eax, dword ptr [rbp + 0x18]
0x00004C62: 48894510                 mov      qword ptr [rbp + 0x10], rax
0x00004C66: e86d0e2000               call     0x180205ad8
0x00004C6B: d18bc0483145             ror      dword ptr [rbx + 0x453148c0], 1
0x00004C71: 10e8                     adc      al, ch
0x00004C73: d28b10004b48             ror      byte ptr [rbx + 0x484b0010], cl
0x00004C79: 8d4d20                   lea      ecx, [rbp + 0x20]
0x00004C7C: 8bc0                     mov      eax, eax
0x00004C7E: 48314510                 xor      qword ptr [rbp + 0x10], rax
0x00004C82: e8adfa0a00               call     0x1800b4734
0x00004C87: 6a8b                     push     -0x75
0x00004C89: 452048c1                 and      byte ptr [r8 - 0x3f], r9b
0x00004C8D: e020                     loopne   0x180004caf
0x00004C8F: 488d4d10                 lea      rcx, [rbp + 0x10]
0x00004C93: 48334520                 xor      rax, qword ptr [rbp + 0x20]
0x00004C97: 48334510                 xor      rax, qword ptr [rbp + 0x10]
0x00004C9B: 4833c1                   xor      rax, rcx
0x00004C9E: 48b9ffffffffffff0000     movabs   rcx, 0xffffffffffff
0x00004CA8: 4823c1                   and      rax, rcx
0x00004CAB: 48b933a2df2d992b0000     movabs   rcx, 0x2b992ddfa233
0x00004CB5: 483bc3                   cmp      rax, rbx
0x00004CB8: 480f44c1                 cmove    rax, rcx
0x00004CBC: 4889053d230100           mov      qword ptr [rip + 0x1233d], rax
0x00004CC3: 488b5c2448               mov      rbx, qword ptr [rsp + 0x48]
0x00004CC8: 48f7d0                   not      rax
0x00004CCB: 48890536230100           mov      qword ptr [rip + 0x12336], rax
0x00004CD2: 4883c420                 add      rsp, 0x20
0x00004CD6: 5d                       pop      rbp
0x00004CD7: c3                       ret      
0x00004CD8: 488bc4                   mov      rax, rsp
0x00004CDB: 48895808                 mov      qword ptr [rax + 8], rbx
0x00004CDF: 48896810                 mov      qword ptr [rax + 0x10], rbp
0x00004CE3: 48897018                 mov      qword ptr [rax + 0x18], rsi
0x00004CE7: 48897820                 mov      qword ptr [rax + 0x20], rdi
0x00004CEB: 4156                     push     r14
0x00004CED: 4883ec40                 sub      rsp, 0x40
0x00004CF1: 50                       push     rax
0x00004CF2: e8bac02400               call     0x180250db1
0x00004CF7: 4533f6                   xor      r14d, r14d
0x00004CFA: 488bf8                   mov      rdi, rax
0x00004CFD: 4885c0                   test     rax, rax
0x00004D00: 0f84a9000000             je       0x180004daf
0x00004D06: 488bd8                   mov      rbx, rax
0x00004D09: 66443930                 cmp      word ptr [rax], r14w
0x00004D0D: 7414                     je       0x180004d23
0x00004D0F: 4883c302                 add      rbx, 2
0x00004D13: 66443933                 cmp      word ptr [rbx], r14w
0x00004D17: 75f6                     jne      0x180004d0f
0x00004D19: 4883c302                 add      rbx, 2
0x00004D1D: 66443933                 cmp      word ptr [rbx], r14w
0x00004D21: 75ec                     jne      0x180004d0f
0x00004D23: 4c89742438               mov      qword ptr [rsp + 0x38], r14
0x00004D28: 482bd8                   sub      rbx, rax
0x00004D2B: 4c89742430               mov      qword ptr [rsp + 0x30], r14
0x00004D30: 48d1fb                   sar      rbx, 1
0x00004D33: 4c8bc0                   mov      r8, rax
0x00004D36: 33d2                     xor      edx, edx
0x00004D38: 448d4b01                 lea      r9d, [rbx + 1]
0x00004D3C: 33c9                     xor      ecx, ecx
0x00004D3E: 4489742428               mov      dword ptr [rsp + 0x28], r14d
0x00004D43: 4c89742420               mov      qword ptr [rsp + 0x20], r14
0x00004D48: e8d4732400               call     0x18024c121
0x00004D4D: 95                       xchg     ebp, eax
0x00004D4E: 4863e8                   movsxd   rbp, eax
0x00004D51: 85c0                     test     eax, eax
0x00004D53: 7451                     je       0x180004da6
0x00004D55: 488bcd                   mov      rcx, rbp
0x00004D58: e87be6ffff               call     0x1800033d8
0x00004D5D: 488bf0                   mov      rsi, rax
0x00004D60: 4885c0                   test     rax, rax
0x00004D63: 7441                     je       0x180004da6
0x00004D65: 4c89742438               mov      qword ptr [rsp + 0x38], r14
0x00004D6A: 4c89742430               mov      qword ptr [rsp + 0x30], r14
0x00004D6F: 448d4b01                 lea      r9d, [rbx + 1]
0x00004D73: 4c8bc7                   mov      r8, rdi
0x00004D76: 33d2                     xor      edx, edx
0x00004D78: 33c9                     xor      ecx, ecx
0x00004D7A: 896c2428                 mov      dword ptr [rsp + 0x28], ebp
0x00004D7E: 4889442420               mov      qword ptr [rsp + 0x20], rax
0x00004D83: 56                       push     rsi
0x00004D84: e88b160300               call     0x180036414
0x00004D89: 85c0                     test     eax, eax
0x00004D8B: 750b                     jne      0x180004d98
0x00004D8D: 488bce                   mov      rcx, rsi
0x00004D90: e89bcaffff               call     0x180001830
0x00004D95: 498bf6                   mov      rsi, r14
0x00004D98: 488bcf                   mov      rcx, rdi
0x00004D9B: 56                       push     rsi
0x00004D9C: e89dd00d00               call     0x1800e1e3e
0x00004DA1: 488bc6                   mov      rax, rsi
0x00004DA4: eb0b                     jmp      0x180004db1
0x00004DA6: 488bcf                   mov      rcx, rdi
0x00004DA9: e838711700               call     0x18017bee6
0x00004DAE: ed                       in       eax, dx
0x00004DAF: 33c0                     xor      eax, eax
0x00004DB1: 488b5c2450               mov      rbx, qword ptr [rsp + 0x50]
0x00004DB6: 488b6c2458               mov      rbp, qword ptr [rsp + 0x58]
0x00004DBB: 488b742460               mov      rsi, qword ptr [rsp + 0x60]
0x00004DC0: 488b7c2468               mov      rdi, qword ptr [rsp + 0x68]
0x00004DC5: 4883c440                 add      rsp, 0x40
0x00004DC9: 415e                     pop      r14
0x00004DCB: c3                       ret      
0x00004DCC: 48895c2420               mov      qword ptr [rsp + 0x20], rbx
0x00004DD1: 57                       push     rdi
0x00004DD2: 4883ec40                 sub      rsp, 0x40
0x00004DD6: 488bd9                   mov      rbx, rcx
0x00004DD9: e8c32d1600               call     0x180167ba1
0x00004DDE: 0e                       .byte    0x0e
0x00004DDF: 488bbbf8000000           mov      rdi, qword ptr [rbx + 0xf8]
0x00004DE6: 488d542450               lea      rdx, [rsp + 0x50]
0x00004DEB: 4533c0                   xor      r8d, r8d
0x00004DEE: 488bcf                   mov      rcx, rdi
0x00004DF1: 53                       push     rbx
0x00004DF2: e8ea280300               call     0x1800376e1
0x00004DF7: 4885c0                   test     rax, rax
0x00004DFA: 7432                     je       0x180004e2e
0x00004DFC: 488364243800             and      qword ptr [rsp + 0x38], 0
0x00004E02: 488b542450               mov      rdx, qword ptr [rsp + 0x50]
0x00004E07: 488d4c2458               lea      rcx, [rsp + 0x58]
0x00004E0C: 48894c2430               mov      qword ptr [rsp + 0x30], rcx
0x00004E11: 488d4c2460               lea      rcx, [rsp + 0x60]
0x00004E16: 4c8bc8                   mov      r9, rax
0x00004E19: 48894c2428               mov      qword ptr [rsp + 0x28], rcx
0x00004E1E: 33c9                     xor      ecx, ecx
0x00004E20: 4c8bc7                   mov      r8, rdi
0x00004E23: 48895c2420               mov      qword ptr [rsp + 0x20], rbx
0x00004E28: 52                       push     rdx
0x00004E29: e806212300               call     0x180236f34
0x00004E2E: 488b5c2468               mov      rbx, qword ptr [rsp + 0x68]
0x00004E33: 4883c440                 add      rsp, 0x40
0x00004E37: 5f                       pop      rdi
0x00004E38: c3                       ret      
0x00004E39: cc                       int3     
0x00004E3A: cc                       int3     
0x00004E3B: cc                       int3     
0x00004E3C: 4053                     push     rbx
0x00004E3E: 56                       push     rsi
0x00004E3F: 57                       push     rdi
0x00004E40: 4883ec40                 sub      rsp, 0x40
0x00004E44: 488bd9                   mov      rbx, rcx
0x00004E47: 57                       push     rdi
0x00004E48: e8763c0200               call     0x180028ac3
0x00004E4D: 488bb3f8000000           mov      rsi, qword ptr [rbx + 0xf8]
0x00004E54: 33ff                     xor      edi, edi
0x00004E56: 488d542460               lea      rdx, [rsp + 0x60]
0x00004E5B: 4533c0                   xor      r8d, r8d
0x00004E5E: 488bce                   mov      rcx, rsi
0x00004E61: e8d3ad0b00               call     0x1800bfc39
0x00004E66: 1f                       .byte    0x1f
0x00004E67: 4885c0                   test     rax, rax
0x00004E6A: 7439                     je       0x180004ea5
0x00004E6C: 488364243800             and      qword ptr [rsp + 0x38], 0
0x00004E72: 488b542460               mov      rdx, qword ptr [rsp + 0x60]
0x00004E77: 488d4c2468               lea      rcx, [rsp + 0x68]
0x00004E7C: 48894c2430               mov      qword ptr [rsp + 0x30], rcx
0x00004E81: 488d4c2470               lea      rcx, [rsp + 0x70]
0x00004E86: 4c8bc8                   mov      r9, rax
0x00004E89: 48894c2428               mov      qword ptr [rsp + 0x28], rcx
0x00004E8E: 33c9                     xor      ecx, ecx
0x00004E90: 4c8bc6                   mov      r8, rsi
0x00004E93: 48895c2420               mov      qword ptr [rsp + 0x20], rbx
0x00004E98: 55                       push     rbp
0x00004E99: e869260200               call     0x180027507
0x00004E9E: ffc7                     inc      edi
0x00004EA0: 83ff02                   cmp      edi, 2
0x00004EA3: 7cb1                     jl       0x180004e56
0x00004EA5: 4883c440                 add      rsp, 0x40
0x00004EA9: 5f                       pop      rdi
0x00004EAA: 5e                       pop      rsi
0x00004EAB: 5b                       pop      rbx
0x00004EAC: c3                       ret      
0x00004EAD: cc                       int3     
0x00004EAE: cc                       int3     
0x00004EAF: cc                       int3     
0x00004EB0: 488b05c9870100           mov      rax, qword ptr [rip + 0x187c9]
0x00004EB7: 48330542210100           xor      rax, qword ptr [rip + 0x12142]
0x00004EBE: 7403                     je       0x180004ec3
0x00004EC0: 48ffe0                   jmp      rax
0x00004EC3: 48e8446c1f00             call     0x1801fbb0d
0x00004EC9: bdcccc488b               mov      ebp, 0x8b48cccc
0x00004ECE: 05b5870100               add      eax, 0x187b5
0x00004ED3: 48330526210100           xor      rax, qword ptr [rip + 0x12126]
0x00004EDA: 7403                     je       0x180004edf
0x00004EDC: 48ffe0                   jmp      rax
0x00004EDF: 4853                     push     rbx
0x00004EE1: e82fd61300               call     0x180142515
0x00004EE6: cc                       int3     
0x00004EE7: cc                       int3     
0x00004EE8: 488b05a1870100           mov      rax, qword ptr [rip + 0x187a1]
0x00004EEF: 4833050a210100           xor      rax, qword ptr [rip + 0x1210a]
0x00004EF6: 7403                     je       0x180004efb
0x00004EF8: 48ffe0                   jmp      rax
0x00004EFB: 48e8f0151600             call     0x1801664f1
0x00004F01: e0cc                     loopne   0x180004ecf
0x00004F03: cc                       int3     
0x00004F04: 488b058d870100           mov      rax, qword ptr [rip + 0x1878d]
0x00004F0B: 483305ee200100           xor      rax, qword ptr [rip + 0x120ee]
0x00004F12: 7403                     je       0x180004f17
0x00004F14: 48ffe0                   jmp      rax
0x00004F17: 4851                     push     rcx
0x00004F19: e8894e1600               call     0x180169da7
0x00004F1E: cc                       int3     
0x00004F1F: cc                       int3     
0x00004F20: 4883ec28                 sub      rsp, 0x28
0x00004F24: 488b0575870100           mov      rax, qword ptr [rip + 0x18775]
0x00004F2B: 483305ce200100           xor      rax, qword ptr [rip + 0x120ce]
0x00004F32: 7407                     je       0x180004f3b
0x00004F34: 4883c428                 add      rsp, 0x28
0x00004F38: 48ffe0                   jmp      rax
0x00004F3B: e805322100               call     0x180218145
0x00004F40: 2f                       .byte    0x2f
0x00004F41: b801000000               mov      eax, 1
0x00004F46: 4883c428                 add      rsp, 0x28
0x00004F4A: c3                       ret      
0x00004F4B: cc                       int3     
0x00004F4C: 4053                     push     rbx
0x00004F4E: 4883ec20                 sub      rsp, 0x20
0x00004F52: 8b05a0220100             mov      eax, dword ptr [rip + 0x122a0]
0x00004F58: 33db                     xor      ebx, ebx
0x00004F5A: 85c0                     test     eax, eax
0x00004F5C: 792f                     jns      0x180004f8d
0x00004F5E: 488b0503880100           mov      rax, qword ptr [rip + 0x18803]
0x00004F65: 895c2430                 mov      dword ptr [rsp + 0x30], ebx
0x00004F69: 48330590200100           xor      rax, qword ptr [rip + 0x12090]
0x00004F70: 7411                     je       0x180004f83
0x00004F72: 488d4c2430               lea      rcx, [rsp + 0x30]
0x00004F77: 33d2                     xor      edx, edx
0x00004F79: ffd0                     call     rax
0x00004F7B: 83f87a                   cmp      eax, 0x7a
0x00004F7E: 8d4301                   lea      eax, [rbx + 1]
0x00004F81: 7402                     je       0x180004f85
0x00004F83: 8bc3                     mov      eax, ebx
0x00004F85: 89056d220100             mov      dword ptr [rip + 0x1226d], eax
0x00004F8B: 85c0                     test     eax, eax
0x00004F8D: 0f9fc3                   setg     bl
0x00004F90: 8bc3                     mov      eax, ebx
0x00004F92: 4883c420                 add      rsp, 0x20
0x00004F96: 5b                       pop      rbx
0x00004F97: c3                       ret      
0x00004F98: 4053                     push     rbx
0x00004F9A: 4883ec20                 sub      rsp, 0x20
0x00004F9E: 488d0dbbb00000           lea      rcx, [rip + 0xb0bb]
0x00004FA5: e8d3c50d00               call     0x1800e157d
0x00004FAA: 0b488d                   or       ecx, dword ptr [rax - 0x73]
0x00004FAD: 15ceb00000               adc      eax, 0xb0ce
0x00004FB2: 488bc8                   mov      rcx, rax
0x00004FB5: 488bd8                   mov      rbx, rax
0x00004FB8: e8d4562000               call     0x18020a691
0x00004FBD: 4c488d15cbb00000         lea      rdx, [rip + 0xb0cb]
0x00004FC5: 488bcb                   mov      rcx, rbx
0x00004FC8: 48330531200100           xor      rax, qword ptr [rip + 0x12031]
0x00004FCF: 488905aa860100           mov      qword ptr [rip + 0x186aa], rax
0x00004FD6: e887171800               call     0x180186762
0x00004FDB: 7848                     js       0x180005025
0x00004FDD: 8d15b5b00000             lea      edx, [rip + 0xb0b5]
0x00004FE3: 48330516200100           xor      rax, qword ptr [rip + 0x12016]
0x00004FEA: 488bcb                   mov      rcx, rbx
0x00004FED: 48890594860100           mov      qword ptr [rip + 0x18694], rax
0x00004FF4: 53                       push     rbx
0x00004FF5: e8d5dd2500               call     0x180262dcf
0x00004FFA: 488d15a7b00000           lea      rdx, [rip + 0xb0a7]
0x00005001: 483305f81f0100           xor      rax, qword ptr [rip + 0x11ff8]
0x00005008: 488bcb                   mov      rcx, rbx
0x0000500B: 4889057e860100           mov      qword ptr [rip + 0x1867e], rax
0x00005012: e8b02e0200               call     0x180027ec7
0x00005017: d8488d                   fmul     dword ptr [rax - 0x73]
0x0000501A: 1599b00000               adc      eax, 0xb099
0x0000501F: 483305da1f0100           xor      rax, qword ptr [rip + 0x11fda]
0x00005026: 488bcb                   mov      rcx, rbx
0x00005029: 48890568860100           mov      qword ptr [rip + 0x18668], rax
0x00005030: e835d51800               call     0x18019256a
0x00005035: 00488d                   add      byte ptr [rax - 0x73], cl
0x00005038: 159bb00000               adc      eax, 0xb09b
0x0000503D: 483305bc1f0100           xor      rax, qword ptr [rip + 0x11fbc]
0x00005044: 488bcb                   mov      rcx, rbx
0x00005047: 48890552860100           mov      qword ptr [rip + 0x18652], rax
0x0000504E: e8f2291200               call     0x180127a45
0x00005053: dd488d                   fisttp   qword ptr [rax - 0x73]
0x00005056: 158db00000               adc      eax, 0xb08d
0x0000505B: 4833059e1f0100           xor      rax, qword ptr [rip + 0x11f9e]
0x00005062: 488bcb                   mov      rcx, rbx
0x00005065: 4889053c860100           mov      qword ptr [rip + 0x1863c], rax
0x0000506C: e8b3110300               call     0x180036224
0x00005071: b448                     mov      ah, 0x48
0x00005073: 8d1587b00000             lea      edx, [rip + 0xb087]
0x00005079: 483305801f0100           xor      rax, qword ptr [rip + 0x11f80]
0x00005080: 488bcb                   mov      rcx, rbx
0x00005083: 48890526860100           mov      qword ptr [rip + 0x18626], rax
0x0000508A: 51                       push     rcx
0x0000508B: e880182400               call     0x180246910
0x00005090: 488d1581b00000           lea      rdx, [rip + 0xb081]
0x00005097: 483305621f0100           xor      rax, qword ptr [rip + 0x11f62]
0x0000509E: 488bcb                   mov      rcx, rbx
0x000050A1: 48890510860100           mov      qword ptr [rip + 0x18610], rax
0x000050A8: 50                       push     rax
0x000050A9: e8f4fa2400               call     0x180254ba2
0x000050AE: 488d157bb00000           lea      rdx, [rip + 0xb07b]
0x000050B5: 483305441f0100           xor      rax, qword ptr [rip + 0x11f44]
0x000050BC: 488bcb                   mov      rcx, rbx
0x000050BF: 488905fa850100           mov      qword ptr [rip + 0x185fa], rax
0x000050C6: e89ae80100               call     0x180023965
0x000050CB: 99                       cdq      
0x000050CC: 488d1575b00000           lea      rdx, [rip + 0xb075]
0x000050D3: 483305261f0100           xor      rax, qword ptr [rip + 0x11f26]
0x000050DA: 488bcb                   mov      rcx, rbx
0x000050DD: 488905e4850100           mov      qword ptr [rip + 0x185e4], rax
0x000050E4: 53                       push     rbx
0x000050E5: e86bca2000               call     0x180211b55
0x000050EA: 488d1577b00000           lea      rdx, [rip + 0xb077]
0x000050F1: 483305081f0100           xor      rax, qword ptr [rip + 0x11f08]
0x000050F8: 488bcb                   mov      rcx, rbx
0x000050FB: 488905ce850100           mov      qword ptr [rip + 0x185ce], rax
0x00005102: 50                       push     rax
0x00005103: e889f20100               call     0x180024391
0x00005108: 488d1571b00000           lea      rdx, [rip + 0xb071]
0x0000510F: 483305ea1e0100           xor      rax, qword ptr [rip + 0x11eea]
0x00005116: 488bcb                   mov      rcx, rbx
0x00005119: 488905b8850100           mov      qword ptr [rip + 0x185b8], rax
0x00005120: 57                       push     rdi
0x00005121: e863e60e00               call     0x1800f3789
0x00005126: 488d156bb00000           lea      rdx, [rip + 0xb06b]
0x0000512D: 483305cc1e0100           xor      rax, qword ptr [rip + 0x11ecc]
0x00005134: 488bcb                   mov      rcx, rbx
0x00005137: 488905a2850100           mov      qword ptr [rip + 0x185a2], rax
0x0000513E: e8293d1000               call     0x180108e6c
0x00005143: 9e                       sahf     
0x00005144: 488d1565b00000           lea      rdx, [rip + 0xb065]
0x0000514B: 483305ae1e0100           xor      rax, qword ptr [rip + 0x11eae]
0x00005152: 488bcb                   mov      rcx, rbx
0x00005155: 4889058c850100           mov      qword ptr [rip + 0x1858c], rax
0x0000515C: e8dff20200               call     0x180034440
0x00005161: a3488d155fb0000048       movabs   dword ptr [0x480000b05f158d48], eax
0x0000516A: 3305901e0100             xor      eax, dword ptr [rip + 0x11e90]
0x00005170: 488bcb                   mov      rcx, rbx
0x00005173: 48890576850100           mov      qword ptr [rip + 0x18576], rax
0x0000517A: 52                       push     rdx
0x0000517B: e84d8c1300               call     0x18013ddcd
0x00005180: 483305791e0100           xor      rax, qword ptr [rip + 0x11e79]
0x00005187: 488d155ab00000           lea      rdx, [rip + 0xb05a]
0x0000518E: 488bcb                   mov      rcx, rbx
0x00005191: 48890560850100           mov      qword ptr [rip + 0x18560], rax
0x00005198: e8dcf22100               call     0x180224479
0x0000519D: cb                       retf     
0x0000519E: 488d1563b00000           lea      rdx, [rip + 0xb063]
0x000051A5: 483305541e0100           xor      rax, qword ptr [rip + 0x11e54]
0x000051AC: 488bcb                   mov      rcx, rbx
0x000051AF: 4889054a850100           mov      qword ptr [rip + 0x1854a], rax
0x000051B6: e818061b00               call     0x1801b57d3
0x000051BB: 5d                       pop      rbp
0x000051BC: 488d1565b00000           lea      rdx, [rip + 0xb065]
0x000051C3: 483305361e0100           xor      rax, qword ptr [rip + 0x11e36]
0x000051CA: 488bcb                   mov      rcx, rbx
0x000051CD: 48890534850100           mov      qword ptr [rip + 0x18534], rax
0x000051D4: 57                       push     rdi
0x000051D5: e8405a1000               call     0x18010ac1a
0x000051DA: 488d1567b00000           lea      rdx, [rip + 0xb067]
0x000051E1: 483305181e0100           xor      rax, qword ptr [rip + 0x11e18]
0x000051E8: 488bcb                   mov      rcx, rbx
0x000051EB: 4889051e850100           mov      qword ptr [rip + 0x1851e], rax
0x000051F2: e82dc02300               call     0x180241224
0x000051F7: 7448                     je       0x180005241
0x000051F9: 8d1561b00000             lea      edx, [rip + 0xb061]
0x000051FF: 483305fa1d0100           xor      rax, qword ptr [rip + 0x11dfa]
0x00005206: 488bcb                   mov      rcx, rbx
0x00005209: 48890508850100           mov      qword ptr [rip + 0x18508], rax
0x00005210: 52                       push     rdx
0x00005211: e8f9160300               call     0x18003690f
0x00005216: 488d1563b00000           lea      rdx, [rip + 0xb063]
0x0000521D: 483305dc1d0100           xor      rax, qword ptr [rip + 0x11ddc]
0x00005224: 488bcb                   mov      rcx, rbx
0x00005227: 488905f2840100           mov      qword ptr [rip + 0x184f2], rax
0x0000522E: 55                       push     rbp
0x0000522F: e84bae0100               call     0x18002007f
0x00005234: 488d155db00000           lea      rdx, [rip + 0xb05d]
0x0000523B: 483305be1d0100           xor      rax, qword ptr [rip + 0x11dbe]
0x00005242: 488bcb                   mov      rcx, rbx
0x00005245: 488905e4840100           mov      qword ptr [rip + 0x184e4], rax
0x0000524C: 57                       push     rdi
0x0000524D: e8e02e0200               call     0x180028132
0x00005252: 488d154fb00000           lea      rdx, [rip + 0xb04f]
0x00005259: 483305a01d0100           xor      rax, qword ptr [rip + 0x11da0]
0x00005260: 488bcb                   mov      rcx, rbx
0x00005263: 488905be840100           mov      qword ptr [rip + 0x184be], rax
0x0000526A: 56                       push     rsi
0x0000526B: e85f082500               call     0x180255acf
0x00005270: 488d1541b00000           lea      rdx, [rip + 0xb041]
0x00005277: 483305821d0100           xor      rax, qword ptr [rip + 0x11d82]
0x0000527E: 488bcb                   mov      rcx, rbx
0x00005281: 488905b0840100           mov      qword ptr [rip + 0x184b0], rax
0x00005288: 53                       push     rbx
0x00005289: e873ff0100               call     0x180025201
0x0000528E: 488d1533b00000           lea      rdx, [rip + 0xb033]
0x00005295: 483305641d0100           xor      rax, qword ptr [rip + 0x11d64]
0x0000529C: 488bcb                   mov      rcx, rbx
0x0000529F: 4889059a840100           mov      qword ptr [rip + 0x1849a], rax
0x000052A6: e880cb1c00               call     0x1801d1e2b
0x000052AB: fc                       cld      
0x000052AC: 488d1525b00000           lea      rdx, [rip + 0xb025]
0x000052B3: 483305461d0100           xor      rax, qword ptr [rip + 0x11d46]
0x000052BA: 488bcb                   mov      rcx, rbx
0x000052BD: 48890584840100           mov      qword ptr [rip + 0x18484], rax
0x000052C4: e856b00100               call     0x18002031f
0x000052C9: 7048                     jo       0x180005313
0x000052CB: 8d1527b00000             lea      edx, [rip + 0xb027]
0x000052D1: 483305281d0100           xor      rax, qword ptr [rip + 0x11d28]
0x000052D8: 488bcb                   mov      rcx, rbx
0x000052DB: 4889056e840100           mov      qword ptr [rip + 0x1846e], rax
0x000052E2: e899111600               call     0x180166480
0x000052E7: 9d                       popfq    
0x000052E8: 488d1521b00000           lea      rdx, [rip + 0xb021]
0x000052EF: 4833050a1d0100           xor      rax, qword ptr [rip + 0x11d0a]
0x000052F6: 488bcb                   mov      rcx, rbx
0x000052F9: 48890558840100           mov      qword ptr [rip + 0x18458], rax
0x00005300: e8db6a1000               call     0x18010bde0
0x00005305: 67488d1513b00000         lea      rdx, [eip + 0xb013]
0x0000530D: 483305ec1c0100           xor      rax, qword ptr [rip + 0x11cec]
0x00005314: 488bcb                   mov      rcx, rbx
0x00005317: 48890542840100           mov      qword ptr [rip + 0x18442], rax
0x0000531E: 50                       push     rax
0x0000531F: e80e090c00               call     0x1800c5c32
0x00005324: 488d150db00000           lea      rdx, [rip + 0xb00d]
0x0000532B: 483305ce1c0100           xor      rax, qword ptr [rip + 0x11cce]
0x00005332: 488bcb                   mov      rcx, rbx
0x00005335: 4889052c840100           mov      qword ptr [rip + 0x1842c], rax
0x0000533C: e823410200               call     0x180029464
0x00005341: 48488d15ffaf0000         lea      rdx, [rip + 0xafff]
0x00005349: 483305b01c0100           xor      rax, qword ptr [rip + 0x11cb0]
0x00005350: 488bcb                   mov      rcx, rbx
0x00005353: 48890516840100           mov      qword ptr [rip + 0x18416], rax
0x0000535A: 56                       push     rsi
0x0000535B: e83cf82400               call     0x180254b9c
0x00005360: 483305991c0100           xor      rax, qword ptr [rip + 0x11c99]
0x00005367: 488d15faaf0000           lea      rdx, [rip + 0xaffa]
0x0000536E: 488bcb                   mov      rcx, rbx
0x00005371: 48890500840100           mov      qword ptr [rip + 0x18400], rax
0x00005378: e87a641e00               call     0x1801eb7f7
0x0000537D: 55                       push     rbp
0x0000537E: 4833057b1c0100           xor      rax, qword ptr [rip + 0x11c7b]
0x00005385: 488905f4830100           mov      qword ptr [rip + 0x183f4], rax
0x0000538C: 4883c420                 add      rsp, 0x20
0x00005390: 5b                       pop      rbx
0x00005391: c3                       ret      
0x00005392: cc                       int3     
0x00005393: cc                       int3     
0x00005394: 48e8e9f60100             call     0x180024a83
0x0000539A: d3cc                     ror      esp, cl
0x0000539C: 4053                     push     rbx
0x0000539E: 4883ec20                 sub      rsp, 0x20
0x000053A2: 8bd9                     mov      ebx, ecx
0x000053A4: e874361900               call     0x180198a1d
0x000053A9: 58                       pop      rax
0x000053AA: 8bd3                     mov      edx, ebx
0x000053AC: 488bc8                   mov      rcx, rax
0x000053AF: 4883c420                 add      rsp, 0x20
0x000053B3: 5b                       pop      rbx
0x000053B4: 48e8debb0100             call     0x180020f98
0x000053BA: fb                       sti      
0x000053BB: cc                       int3     
0x000053BC: 4053                     push     rbx
0x000053BE: 4883ec20                 sub      rsp, 0x20
0x000053C2: 488bd9                   mov      rbx, rcx
0x000053C5: 33c9                     xor      ecx, ecx
0x000053C7: e803641e00               call     0x1801eb7cf
0x000053CC: ee                       out      dx, al
0x000053CD: 488bcb                   mov      rcx, rbx
0x000053D0: 4883c420                 add      rsp, 0x20
0x000053D4: 5b                       pop      rbx
0x000053D5: 48e86a720c00             call     0x1800cc645
0x000053DB: 324889                   xor      cl, byte ptr [rax - 0x77]
0x000053DE: 5c                       pop      rsp
0x000053DF: 2408                     and      al, 8
0x000053E1: 57                       push     rdi
0x000053E2: 4883ec20                 sub      rsp, 0x20
0x000053E6: 488d1d53fb0000           lea      rbx, [rip + 0xfb53]
0x000053ED: 488d3d4cfb0000           lea      rdi, [rip + 0xfb4c]
0x000053F4: eb0e                     jmp      0x180005404
0x000053F6: 488b03                   mov      rax, qword ptr [rbx]
0x000053F9: 4885c0                   test     rax, rax
0x000053FC: 7402                     je       0x180005400
0x000053FE: ffd0                     call     rax
0x00005400: 4883c308                 add      rbx, 8
0x00005404: 483bdf                   cmp      rbx, rdi
0x00005407: 72ed                     jb       0x1800053f6
0x00005409: 488b5c2430               mov      rbx, qword ptr [rsp + 0x30]
0x0000540E: 4883c420                 add      rsp, 0x20
0x00005412: 5f                       pop      rdi
0x00005413: c3                       ret      
0x00005414: 48895c2408               mov      qword ptr [rsp + 8], rbx
0x00005419: 57                       push     rdi
0x0000541A: 4883ec20                 sub      rsp, 0x20
0x0000541E: 488d1d2bfb0000           lea      rbx, [rip + 0xfb2b]
0x00005425: 488d3d24fb0000           lea      rdi, [rip + 0xfb24]
0x0000542C: eb0e                     jmp      0x18000543c
0x0000542E: 488b03                   mov      rax, qword ptr [rbx]
0x00005431: 4885c0                   test     rax, rax
0x00005434: 7402                     je       0x180005438
0x00005436: ffd0                     call     rax
0x00005438: 4883c308                 add      rbx, 8
0x0000543C: 483bdf                   cmp      rbx, rdi
0x0000543F: 72ed                     jb       0x18000542e
0x00005441: 488b5c2430               mov      rbx, qword ptr [rsp + 0x30]
0x00005446: 4883c420                 add      rsp, 0x20
0x0000544A: 5f                       pop      rdi
0x0000544B: c3                       ret      
0x0000544C: 48895c2408               mov      qword ptr [rsp + 8], rbx
0x00005451: 4889742410               mov      qword ptr [rsp + 0x10], rsi
0x00005456: 57                       push     rdi
0x00005457: 4883ec20                 sub      rsp, 0x20
0x0000545B: 488bda                   mov      rbx, rdx
0x0000545E: 488bf9                   mov      rdi, rcx
0x00005461: 4885c9                   test     rcx, rcx
0x00005464: 750a                     jne      0x180005470
0x00005466: 488bca                   mov      rcx, rdx
0x00005469: e802c4ffff               call     0x180001870
0x0000546E: eb6a                     jmp      0x1800054da
0x00005470: 4885d2                   test     rdx, rdx
0x00005473: 7507                     jne      0x18000547c
0x00005475: e8b6c3ffff               call     0x180001830
0x0000547A: eb5c                     jmp      0x1800054d8
0x0000547C: 4883fae0                 cmp      rdx, -0x20
0x00005480: 7743                     ja       0x1800054c5
0x00005482: 488b0d6f380100           mov      rcx, qword ptr [rip + 0x1386f]
0x00005489: b801000000               mov      eax, 1
0x0000548E: 4885db                   test     rbx, rbx
0x00005491: 480f44d8                 cmove    rbx, rax
0x00005495: 4c8bc7                   mov      r8, rdi
0x00005498: 33d2                     xor      edx, edx
0x0000549A: 4c8bcb                   mov      r9, rbx
0x0000549D: e81aed1000               call     0x1801141bc
0x000054A2: 01488b                   add      dword ptr [rax - 0x75], ecx
0x000054A5: f0                       .byte    0xf0
0x000054A6: 4885c0                   test     rax, rax
0x000054A9: 756f                     jne      0x18000551a
0x000054AB: 3905e73e0100             cmp      dword ptr [rip + 0x13ee7], eax
0x000054B1: 7450                     je       0x180005503
0x000054B3: 488bcb                   mov      rcx, rbx
0x000054B6: e86dd2ffff               call     0x180002728
0x000054BB: 85c0                     test     eax, eax
0x000054BD: 742b                     je       0x1800054ea
0x000054BF: 4883fbe0                 cmp      rbx, -0x20
0x000054C3: 76bd                     jbe      0x180005482
0x000054C5: 488bcb                   mov      rcx, rbx
0x000054C8: e85bd2ffff               call     0x180002728
0x000054CD: e8bad1ffff               call     0x18000268c
0x000054D2: c7000c000000             mov      dword ptr [rax], 0xc
0x000054D8: 33c0                     xor      eax, eax
0x000054DA: 488b5c2430               mov      rbx, qword ptr [rsp + 0x30]
0x000054DF: 488b742438               mov      rsi, qword ptr [rsp + 0x38]
0x000054E4: 4883c420                 add      rsp, 0x20
0x000054E8: 5f                       pop      rdi
0x000054E9: c3                       ret      
0x000054EA: e89dd1ffff               call     0x18000268c
0x000054EF: 488bd8                   mov      rbx, rax
0x000054F2: 53                       push     rbx
0x000054F3: e817d41200               call     0x18013290f
0x000054F8: 8bc8                     mov      ecx, eax
0x000054FA: e8add1ffff               call     0x1800026ac
0x000054FF: 8903                     mov      dword ptr [rbx], eax
0x00005501: ebd5                     jmp      0x1800054d8
0x00005503: e884d1ffff               call     0x18000268c
0x00005508: 488bd8                   mov      rbx, rax
0x0000550B: 52                       push     rdx
0x0000550C: e815be1200               call     0x180131326
0x00005511: 8bc8                     mov      ecx, eax
0x00005513: e894d1ffff               call     0x1800026ac
0x00005518: 8903                     mov      dword ptr [rbx], eax
0x0000551A: 488bc6                   mov      rax, rsi
0x0000551D: ebbb                     jmp      0x1800054da
0x0000551F: cc                       int3     
0x00005520: cc                       int3     
0x00005521: cc                       int3     
0x00005522: cc                       int3     
0x00005523: cc                       int3     
0x00005524: cc                       int3     
0x00005525: cc                       int3     
0x00005526: 66660f1f840000000000     nop      word ptr [rax + rax]
0x00005530: 4c8bd9                   mov      r11, rcx
0x00005533: 4c8bd2                   mov      r10, rdx
0x00005536: 4983f810                 cmp      r8, 0x10
0x0000553A: 0f86b9000000             jbe      0x1800055f9
0x00005540: 482bd1                   sub      rdx, rcx
0x00005543: 730f                     jae      0x180005554
0x00005545: 498bc2                   mov      rax, r10
0x00005548: 4903c0                   add      rax, r8
0x0000554B: 483bc8                   cmp      rcx, rax
0x0000554E: 0f8c96030000             jl       0x1800058ea
0x00005554: 0fba25403e010001         bt       dword ptr [rip + 0x13e40], 1
0x0000555C: 7313                     jae      0x180005571
0x0000555E: 57                       push     rdi
0x0000555F: 56                       push     rsi
0x00005560: 488bf9                   mov      rdi, rcx
0x00005563: 498bf2                   mov      rsi, r10
0x00005566: 498bc8                   mov      rcx, r8
0x00005569: f3a4                     rep movsb byte ptr [rdi], byte ptr [rsi]
0x0000556B: 5e                       pop      rsi
0x0000556C: 5f                       pop      rdi
0x0000556D: 498bc3                   mov      rax, r11
0x00005570: c3                       ret      
0x00005571: 0fba25233e010002         bt       dword ptr [rip + 0x13e23], 2
0x00005579: 0f8256020000             jb       0x1800057d5
0x0000557F: f6c107                   test     cl, 7
0x00005582: 7436                     je       0x1800055ba
0x00005584: f6c101                   test     cl, 1
0x00005587: 740b                     je       0x180005594
0x00005589: 8a040a                   mov      al, byte ptr [rdx + rcx]
0x0000558C: 49ffc8                   dec      r8
0x0000558F: 8801                     mov      byte ptr [rcx], al
0x00005591: 48ffc1                   inc      rcx
0x00005594: f6c102                   test     cl, 2
0x00005597: 740f                     je       0x1800055a8
0x00005599: 668b040a                 mov      ax, word ptr [rdx + rcx]
0x0000559D: 4983e802                 sub      r8, 2
0x000055A1: 668901                   mov      word ptr [rcx], ax
0x000055A4: 4883c102                 add      rcx, 2
0x000055A8: f6c104                   test     cl, 4
0x000055AB: 740d                     je       0x1800055ba
0x000055AD: 8b040a                   mov      eax, dword ptr [rdx + rcx]
0x000055B0: 4983e804                 sub      r8, 4
0x000055B4: 8901                     mov      dword ptr [rcx], eax
0x000055B6: 4883c104                 add      rcx, 4
0x000055BA: 4d8bc8                   mov      r9, r8
0x000055BD: 49c1e905                 shr      r9, 5
0x000055C1: 0f85d9010000             jne      0x1800057a0
0x000055C7: 4d8bc8                   mov      r9, r8
0x000055CA: 49c1e903                 shr      r9, 3
0x000055CE: 7414                     je       0x1800055e4
0x000055D0: 488b040a                 mov      rax, qword ptr [rdx + rcx]
0x000055D4: 488901                   mov      qword ptr [rcx], rax
0x000055D7: 4883c108                 add      rcx, 8
0x000055DB: 49ffc9                   dec      r9
0x000055DE: 75f0                     jne      0x1800055d0
0x000055E0: 4983e007                 and      r8, 7
0x000055E4: 4d85c0                   test     r8, r8
0x000055E7: 7507                     jne      0x1800055f0
0x000055E9: 498bc3                   mov      rax, r11
0x000055EC: c3                       ret      
0x000055ED: 0f1f00                   nop      dword ptr [rax]
0x000055F0: 488d140a                 lea      rdx, [rdx + rcx]
0x000055F4: 4c8bd1                   mov      r10, rcx
0x000055F7: eb03                     jmp      0x1800055fc
0x000055F9: 4d8bd3                   mov      r10, r11
0x000055FC: 4c8d0dfda9ffff           lea      r9, [rip - 0x5603]
0x00005603: 438b848110560000         mov      eax, dword ptr [r9 + r8*4 + 0x5610]
0x0000560B: 4903c1                   add      rax, r9
0x0000560E: ffe0                     jmp      rax
0x00005610: 54                       push     rsp
0x00005611: 56                       push     rsi
0x00005612: 0000                     add      byte ptr [rax], al
0x00005614: 58                       pop      rax
0x00005615: 56                       push     rsi
0x00005616: 0000                     add      byte ptr [rax], al
0x00005618: 63                       .byte    0x63
0x00005619: 56                       push     rsi
0x0000561A: 0000                     add      byte ptr [rax], al
0x0000561C: 6f                       outsd    dx, dword ptr [rsi]
0x0000561D: 56                       push     rsi
0x0000561E: 0000                     add      byte ptr [rax], al
0x00005620: 845600                   test     byte ptr [rsi], dl
0x00005623: 008d5600009f             add      byte ptr [rbp - 0x60ffffaa], cl
0x00005629: 56                       push     rsi
0x0000562A: 0000                     add      byte ptr [rax], al
0x0000562C: b256                     mov      dl, 0x56
0x0000562E: 0000                     add      byte ptr [rax], al
0x00005630: ce                       .byte    0xce
0x00005631: 56                       push     rsi
0x00005632: 0000                     add      byte ptr [rax], al
0x00005634: d85600                   fcom     dword ptr [rsi]
0x00005637: 00eb                     add      bl, ch
0x00005639: 56                       push     rsi
0x0000563A: 0000                     add      byte ptr [rax], al
0x0000563C: ff5600                   call     qword ptr [rsi]
0x0000563F: 001c57                   add      byte ptr [rdi + rdx*2], bl
0x00005642: 0000                     add      byte ptr [rax], al
0x00005644: 2d57000047               sub      eax, 0x47000057
0x00005649: 57                       push     rdi
0x0000564A: 0000                     add      byte ptr [rax], al
0x0000564C: 62                       .byte    0x62
0x0000564D: 57                       push     rdi
0x0000564E: 0000                     add      byte ptr [rax], al
0x00005650: 865700                   xchg     byte ptr [rdi], dl
0x00005653: 00498b                   add      byte ptr [rcx - 0x75], cl
0x00005656: c3                       ret      
0x00005657: c3                       ret      
0x00005658: 480fb602                 movzx    rax, byte ptr [rdx]
0x0000565C: 418802                   mov      byte ptr [r10], al
0x0000565F: 498bc3                   mov      rax, r11
0x00005662: c3                       ret      
0x00005663: 480fb702                 movzx    rax, word ptr [rdx]
0x00005667: 66418902                 mov      word ptr [r10], ax
0x0000566B: 498bc3                   mov      rax, r11
0x0000566E: c3                       ret      
0x0000566F: 480fb602                 movzx    rax, byte ptr [rdx]
0x00005673: 480fb74a01               movzx    rcx, word ptr [rdx + 1]
0x00005678: 418802                   mov      byte ptr [r10], al
0x0000567B: 6641894a01               mov      word ptr [r10 + 1], cx
0x00005680: 498bc3                   mov      rax, r11
0x00005683: c3                       ret      
0x00005684: 8b02                     mov      eax, dword ptr [rdx]
0x00005686: 418902                   mov      dword ptr [r10], eax
0x00005689: 498bc3                   mov      rax, r11
0x0000568C: c3                       ret      
0x0000568D: 480fb602                 movzx    rax, byte ptr [rdx]
0x00005691: 8b4a01                   mov      ecx, dword ptr [rdx + 1]
0x00005694: 418802                   mov      byte ptr [r10], al
0x00005697: 41894a01                 mov      dword ptr [r10 + 1], ecx
0x0000569B: 498bc3                   mov      rax, r11
0x0000569E: c3                       ret      
0x0000569F: 480fb702                 movzx    rax, word ptr [rdx]
0x000056A3: 8b4a02                   mov      ecx, dword ptr [rdx + 2]
0x000056A6: 66418902                 mov      word ptr [r10], ax
0x000056AA: 41894a02                 mov      dword ptr [r10 + 2], ecx
0x000056AE: 498bc3                   mov      rax, r11
0x000056B1: c3                       ret      
0x000056B2: 480fb602                 movzx    rax, byte ptr [rdx]
0x000056B6: 480fb74a01               movzx    rcx, word ptr [rdx + 1]
0x000056BB: 8b5203                   mov      edx, dword ptr [rdx + 3]
0x000056BE: 418802                   mov      byte ptr [r10], al
0x000056C1: 6641894a01               mov      word ptr [r10 + 1], cx
0x000056C6: 41895203                 mov      dword ptr [r10 + 3], edx
0x000056CA: 498bc3                   mov      rax, r11
0x000056CD: c3                       ret      
0x000056CE: 488b02                   mov      rax, qword ptr [rdx]
0x000056D1: 498902                   mov      qword ptr [r10], rax
0x000056D4: 498bc3                   mov      rax, r11
0x000056D7: c3                       ret      
0x000056D8: 480fb602                 movzx    rax, byte ptr [rdx]
0x000056DC: 488b4a01                 mov      rcx, qword ptr [rdx + 1]
0x000056E0: 418802                   mov      byte ptr [r10], al
0x000056E3: 49894a01                 mov      qword ptr [r10 + 1], rcx
0x000056E7: 498bc3                   mov      rax, r11
0x000056EA: c3                       ret      
0x000056EB: 480fb702                 movzx    rax, word ptr [rdx]
0x000056EF: 488b4a02                 mov      rcx, qword ptr [rdx + 2]
0x000056F3: 66418902                 mov      word ptr [r10], ax
0x000056F7: 49894a02                 mov      qword ptr [r10 + 2], rcx
0x000056FB: 498bc3                   mov      rax, r11
0x000056FE: c3                       ret      
0x000056FF: 480fb602                 movzx    rax, byte ptr [rdx]
0x00005703: 480fb74a01               movzx    rcx, word ptr [rdx + 1]
0x00005708: 488b5203                 mov      rdx, qword ptr [rdx + 3]
0x0000570C: 418802                   mov      byte ptr [r10], al
0x0000570F: 6641894a01               mov      word ptr [r10 + 1], cx
0x00005714: 49895203                 mov      qword ptr [r10 + 3], rdx
0x00005718: 498bc3                   mov      rax, r11
0x0000571B: c3                       ret      
0x0000571C: 8b02                     mov      eax, dword ptr [rdx]
0x0000571E: 488b4a04                 mov      rcx, qword ptr [rdx + 4]
0x00005722: 418902                   mov      dword ptr [r10], eax
0x00005725: 49894a04                 mov      qword ptr [r10 + 4], rcx
0x00005729: 498bc3                   mov      rax, r11
0x0000572C: c3                       ret      
0x0000572D: 480fb602                 movzx    rax, byte ptr [rdx]
0x00005731: 8b4a01                   mov      ecx, dword ptr [rdx + 1]
0x00005734: 488b5205                 mov      rdx, qword ptr [rdx + 5]
0x00005738: 418802                   mov      byte ptr [r10], al
0x0000573B: 41894a01                 mov      dword ptr [r10 + 1], ecx
0x0000573F: 49895205                 mov      qword ptr [r10 + 5], rdx
0x00005743: 498bc3                   mov      rax, r11
0x00005746: c3                       ret      
0x00005747: 480fb702                 movzx    rax, word ptr [rdx]
0x0000574B: 8b4a02                   mov      ecx, dword ptr [rdx + 2]
0x0000574E: 488b5206                 mov      rdx, qword ptr [rdx + 6]
0x00005752: 66418902                 mov      word ptr [r10], ax
0x00005756: 41894a02                 mov      dword ptr [r10 + 2], ecx
0x0000575A: 49895206                 mov      qword ptr [r10 + 6], rdx
0x0000575E: 498bc3                   mov      rax, r11
0x00005761: c3                       ret      
0x00005762: 4c0fb602                 movzx    r8, byte ptr [rdx]
0x00005766: 480fb74201               movzx    rax, word ptr [rdx + 1]
0x0000576B: 8b4a03                   mov      ecx, dword ptr [rdx + 3]
0x0000576E: 488b5207                 mov      rdx, qword ptr [rdx + 7]
0x00005772: 458802                   mov      byte ptr [r10], r8b
0x00005775: 6641894201               mov      word ptr [r10 + 1], ax
0x0000577A: 41894a03                 mov      dword ptr [r10 + 3], ecx
0x0000577E: 49895207                 mov      qword ptr [r10 + 7], rdx
0x00005782: 498bc3                   mov      rax, r11
0x00005785: c3                       ret      
0x00005786: f30f6f02                 movdqu   xmm0, xmmword ptr [rdx]
0x0000578A: f3410f7f02               movdqu   xmmword ptr [r10], xmm0
0x0000578F: 498bc3                   mov      rax, r11
0x00005792: c3                       ret      
0x00005793: 66666666660f1f840000000000 nop      word ptr [rax + rax]
0x000057A0: 488b040a                 mov      rax, qword ptr [rdx + rcx]
0x000057A4: 4c8b540a08               mov      r10, qword ptr [rdx + rcx + 8]
0x000057A9: 4883c120                 add      rcx, 0x20
0x000057AD: 488941e0                 mov      qword ptr [rcx - 0x20], rax
0x000057B1: 4c8951e8                 mov      qword ptr [rcx - 0x18], r10
0x000057B5: 488b440af0               mov      rax, qword ptr [rdx + rcx - 0x10]
0x000057BA: 4c8b540af8               mov      r10, qword ptr [rdx + rcx - 8]
0x000057BF: 49ffc9                   dec      r9
0x000057C2: 488941f0                 mov      qword ptr [rcx - 0x10], rax
0x000057C6: 4c8951f8                 mov      qword ptr [rcx - 8], r10
0x000057CA: 75d4                     jne      0x1800057a0
0x000057CC: 4983e01f                 and      r8, 0x1f
0x000057D0: e9f2fdffff               jmp      0x1800055c7
0x000057D5: 4983f820                 cmp      r8, 0x20
0x000057D9: 0f86e1000000             jbe      0x1800058c0
0x000057DF: f6c10f                   test     cl, 0xf
0x000057E2: 750e                     jne      0x1800057f2
0x000057E4: 0f10040a                 movups   xmm0, xmmword ptr [rdx + rcx]
0x000057E8: 4883c110                 add      rcx, 0x10
0x000057EC: 4983e810                 sub      r8, 0x10
0x000057F0: eb1d                     jmp      0x18000580f
0x000057F2: 0f100c0a                 movups   xmm1, xmmword ptr [rdx + rcx]
0x000057F6: 4883c120                 add      rcx, 0x20
0x000057FA: 80e1f0                   and      cl, 0xf0
0x000057FD: 0f10440af0               movups   xmm0, xmmword ptr [rdx + rcx - 0x10]
0x00005802: 410f110b                 movups   xmmword ptr [r11], xmm1
0x00005806: 488bc1                   mov      rax, rcx
0x00005809: 492bc3                   sub      rax, r11
0x0000580C: 4c2bc0                   sub      r8, rax
0x0000580F: 4d8bc8                   mov      r9, r8
0x00005812: 49c1e907                 shr      r9, 7
0x00005816: 7466                     je       0x18000587e
0x00005818: 0f2941f0                 movaps   xmmword ptr [rcx - 0x10], xmm0
0x0000581C: eb0a                     jmp      0x180005828
0x0000581E: 6690                     nop      
0x00005820: 0f2941e0                 movaps   xmmword ptr [rcx - 0x20], xmm0
0x00005824: 0f2949f0                 movaps   xmmword ptr [rcx - 0x10], xmm1
0x00005828: 0f10040a                 movups   xmm0, xmmword ptr [rdx + rcx]
0x0000582C: 0f104c0a10               movups   xmm1, xmmword ptr [rdx + rcx + 0x10]
0x00005831: 4881c180000000           add      rcx, 0x80
0x00005838: 0f294180                 movaps   xmmword ptr [rcx - 0x80], xmm0
0x0000583C: 0f294990                 movaps   xmmword ptr [rcx - 0x70], xmm1
0x00005840: 0f10440aa0               movups   xmm0, xmmword ptr [rdx + rcx - 0x60]
0x00005845: 0f104c0ab0               movups   xmm1, xmmword ptr [rdx + rcx - 0x50]
0x0000584A: 49ffc9                   dec      r9
0x0000584D: 0f2941a0                 movaps   xmmword ptr [rcx - 0x60], xmm0
0x00005851: 0f2949b0                 movaps   xmmword ptr [rcx - 0x50], xmm1
0x00005855: 0f10440ac0               movups   xmm0, xmmword ptr [rdx + rcx - 0x40]
0x0000585A: 0f104c0ad0               movups   xmm1, xmmword ptr [rdx + rcx - 0x30]
0x0000585F: 0f2941c0                 movaps   xmmword ptr [rcx - 0x40], xmm0
0x00005863: 0f2949d0                 movaps   xmmword ptr [rcx - 0x30], xmm1
0x00005867: 0f10440ae0               movups   xmm0, xmmword ptr [rdx + rcx - 0x20]
0x0000586C: 0f104c0af0               movups   xmm1, xmmword ptr [rdx + rcx - 0x10]
0x00005871: 75ad                     jne      0x180005820
0x00005873: 0f2941e0                 movaps   xmmword ptr [rcx - 0x20], xmm0
0x00005877: 4983e07f                 and      r8, 0x7f
0x0000587B: 0f28c1                   movaps   xmm0, xmm1
0x0000587E: 4d8bc8                   mov      r9, r8
0x00005881: 49c1e904                 shr      r9, 4
0x00005885: 741a                     je       0x1800058a1
0x00005887: 660f1f840000000000       nop      word ptr [rax + rax]
0x00005890: 0f2941f0                 movaps   xmmword ptr [rcx - 0x10], xmm0
0x00005894: 0f10040a                 movups   xmm0, xmmword ptr [rdx + rcx]
0x00005898: 4883c110                 add      rcx, 0x10
0x0000589C: 49ffc9                   dec      r9
0x0000589F: 75ef                     jne      0x180005890
0x000058A1: 4983e00f                 and      r8, 0xf
0x000058A5: 740d                     je       0x1800058b4
0x000058A7: 498d0408                 lea      rax, [r8 + rcx]
0x000058AB: 0f104c02f0               movups   xmm1, xmmword ptr [rdx + rax - 0x10]
0x000058B0: 0f1148f0                 movups   xmmword ptr [rax - 0x10], xmm1
0x000058B4: 0f2941f0                 movaps   xmmword ptr [rcx - 0x10], xmm0
0x000058B8: 498bc3                   mov      rax, r11
0x000058BB: c3                       ret      
0x000058BC: 0f1f4000                 nop      dword ptr [rax]
0x000058C0: 410f1002                 movups   xmm0, xmmword ptr [r10]
0x000058C4: 498d4c08f0               lea      rcx, [r8 + rcx - 0x10]
0x000058C9: 0f100c0a                 movups   xmm1, xmmword ptr [rdx + rcx]
0x000058CD: 410f1103                 movups   xmmword ptr [r11], xmm0
0x000058D1: 0f1109                   movups   xmmword ptr [rcx], xmm1
0x000058D4: 498bc3                   mov      rax, r11
0x000058D7: c3                       ret      
0x000058D8: 0f1f840000000000         nop      dword ptr [rax + rax]
0x000058E0: 66666690                 nop      
0x000058E4: 66666690                 nop      
0x000058E8: 6690                     nop      
0x000058EA: 0fba25aa3a010002         bt       dword ptr [rip + 0x13aaa], 2
0x000058F2: 0f82b9000000             jb       0x1800059b1
0x000058F8: 4903c8                   add      rcx, r8
0x000058FB: f6c107                   test     cl, 7
0x000058FE: 7436                     je       0x180005936
0x00005900: f6c101                   test     cl, 1
0x00005903: 740b                     je       0x180005910
0x00005905: 48ffc9                   dec      rcx
0x00005908: 8a040a                   mov      al, byte ptr [rdx + rcx]
0x0000590B: 49ffc8                   dec      r8
0x0000590E: 8801                     mov      byte ptr [rcx], al
0x00005910: f6c102                   test     cl, 2
0x00005913: 740f                     je       0x180005924
0x00005915: 4883e902                 sub      rcx, 2
0x00005919: 668b040a                 mov      ax, word ptr [rdx + rcx]
0x0000591D: 4983e802                 sub      r8, 2
0x00005921: 668901                   mov      word ptr [rcx], ax
0x00005924: f6c104                   test     cl, 4
0x00005927: 740d                     je       0x180005936
0x00005929: 4883e904                 sub      rcx, 4
0x0000592D: 8b040a                   mov      eax, dword ptr [rdx + rcx]
0x00005930: 4983e804                 sub      r8, 4
0x00005934: 8901                     mov      dword ptr [rcx], eax
0x00005936: 4d8bc8                   mov      r9, r8
0x00005939: 49c1e905                 shr      r9, 5
0x0000593D: 7541                     jne      0x180005980
0x0000593F: 4d8bc8                   mov      r9, r8
0x00005942: 49c1e903                 shr      r9, 3
0x00005946: 7414                     je       0x18000595c
0x00005948: 4883e908                 sub      rcx, 8
0x0000594C: 488b040a                 mov      rax, qword ptr [rdx + rcx]
0x00005950: 49ffc9                   dec      r9
0x00005953: 488901                   mov      qword ptr [rcx], rax
0x00005956: 75f0                     jne      0x180005948
0x00005958: 4983e007                 and      r8, 7
0x0000595C: 4d85c0                   test     r8, r8
0x0000595F: 750f                     jne      0x180005970
0x00005961: 498bc3                   mov      rax, r11
0x00005964: c3                       ret      
0x00005965: 6666660f1f840000000000   nop      word ptr [rax + rax]
0x00005970: 492bc8                   sub      rcx, r8
0x00005973: 4c8bd1                   mov      r10, rcx
0x00005976: 488d140a                 lea      rdx, [rdx + rcx]
0x0000597A: e97dfcffff               jmp      0x1800055fc
0x0000597F: 90                       nop      
0x00005980: 488b440af8               mov      rax, qword ptr [rdx + rcx - 8]
0x00005985: 4c8b540af0               mov      r10, qword ptr [rdx + rcx - 0x10]
0x0000598A: 4883e920                 sub      rcx, 0x20
0x0000598E: 48894118                 mov      qword ptr [rcx + 0x18], rax
0x00005992: 4c895110                 mov      qword ptr [rcx + 0x10], r10
0x00005996: 488b440a08               mov      rax, qword ptr [rdx + rcx + 8]
0x0000599B: 4c8b140a                 mov      r10, qword ptr [rdx + rcx]
0x0000599F: 49ffc9                   dec      r9
0x000059A2: 48894108                 mov      qword ptr [rcx + 8], rax
0x000059A6: 4c8911                   mov      qword ptr [rcx], r10
0x000059A9: 75d5                     jne      0x180005980
0x000059AB: 4983e01f                 and      r8, 0x1f
0x000059AF: eb8e                     jmp      0x18000593f
0x000059B1: 4983f820                 cmp      r8, 0x20
0x000059B5: 0f8605ffffff             jbe      0x1800058c0
0x000059BB: 4903c8                   add      rcx, r8
0x000059BE: f6c10f                   test     cl, 0xf
0x000059C1: 750e                     jne      0x1800059d1
0x000059C3: 4883e910                 sub      rcx, 0x10
0x000059C7: 0f10040a                 movups   xmm0, xmmword ptr [rdx + rcx]
0x000059CB: 4983e810                 sub      r8, 0x10
0x000059CF: eb1b                     jmp      0x1800059ec
0x000059D1: 4883e910                 sub      rcx, 0x10
0x000059D5: 0f100c0a                 movups   xmm1, xmmword ptr [rdx + rcx]
0x000059D9: 488bc1                   mov      rax, rcx
0x000059DC: 80e1f0                   and      cl, 0xf0
0x000059DF: 0f10040a                 movups   xmm0, xmmword ptr [rdx + rcx]
0x000059E3: 0f1108                   movups   xmmword ptr [rax], xmm1
0x000059E6: 4c8bc1                   mov      r8, rcx
0x000059E9: 4d2bc3                   sub      r8, r11
0x000059EC: 4d8bc8                   mov      r9, r8
0x000059EF: 49c1e907                 shr      r9, 7
0x000059F3: 7468                     je       0x180005a5d
0x000059F5: 0f2901                   movaps   xmmword ptr [rcx], xmm0
0x000059F8: eb0d                     jmp      0x180005a07
0x000059FA: 660f1f440000             nop      word ptr [rax + rax]
0x00005A00: 0f294110                 movaps   xmmword ptr [rcx + 0x10], xmm0
0x00005A04: 0f2909                   movaps   xmmword ptr [rcx], xmm1
0x00005A07: 0f10440af0               movups   xmm0, xmmword ptr [rdx + rcx - 0x10]
0x00005A0C: 0f104c0ae0               movups   xmm1, xmmword ptr [rdx + rcx - 0x20]
0x00005A11: 4881e980000000           sub      rcx, 0x80
0x00005A18: 0f294170                 movaps   xmmword ptr [rcx + 0x70], xmm0
0x00005A1C: 0f294960                 movaps   xmmword ptr [rcx + 0x60], xmm1
0x00005A20: 0f10440a50               movups   xmm0, xmmword ptr [rdx + rcx + 0x50]
0x00005A25: 0f104c0a40               movups   xmm1, xmmword ptr [rdx + rcx + 0x40]
0x00005A2A: 49ffc9                   dec      r9
0x00005A2D: 0f294150                 movaps   xmmword ptr [rcx + 0x50], xmm0
0x00005A31: 0f294940                 movaps   xmmword ptr [rcx + 0x40], xmm1
0x00005A35: 0f10440a30               movups   xmm0, xmmword ptr [rdx + rcx + 0x30]
0x00005A3A: 0f104c0a20               movups   xmm1, xmmword ptr [rdx + rcx + 0x20]
0x00005A3F: 0f294130                 movaps   xmmword ptr [rcx + 0x30], xmm0
0x00005A43: 0f294920                 movaps   xmmword ptr [rcx + 0x20], xmm1
0x00005A47: 0f10440a10               movups   xmm0, xmmword ptr [rdx + rcx + 0x10]
0x00005A4C: 0f100c0a                 movups   xmm1, xmmword ptr [rdx + rcx]
0x00005A50: 75ae                     jne      0x180005a00
0x00005A52: 0f294110                 movaps   xmmword ptr [rcx + 0x10], xmm0
0x00005A56: 4983e07f                 and      r8, 0x7f
0x00005A5A: 0f28c1                   movaps   xmm0, xmm1
0x00005A5D: 4d8bc8                   mov      r9, r8
0x00005A60: 49c1e904                 shr      r9, 4
0x00005A64: 741a                     je       0x180005a80
0x00005A66: 66660f1f840000000000     nop      word ptr [rax + rax]
0x00005A70: 0f2901                   movaps   xmmword ptr [rcx], xmm0
0x00005A73: 4883e910                 sub      rcx, 0x10
0x00005A77: 0f10040a                 movups   xmm0, xmmword ptr [rdx + rcx]
0x00005A7B: 49ffc9                   dec      r9
0x00005A7E: 75f0                     jne      0x180005a70
0x00005A80: 4983e00f                 and      r8, 0xf
0x00005A84: 7408                     je       0x180005a8e
0x00005A86: 410f100a                 movups   xmm1, xmmword ptr [r10]
0x00005A8A: 410f110b                 movups   xmmword ptr [r11], xmm1
0x00005A8E: 0f2901                   movaps   xmmword ptr [rcx], xmm0
0x00005A91: 498bc3                   mov      rax, r11
0x00005A94: c3                       ret      
0x00005A95: cc                       int3     
0x00005A96: cc                       int3     
0x00005A97: cc                       int3     
0x00005A98: 8325c17b010000           and      dword ptr [rip + 0x17bc1], 0
0x00005A9F: c3                       ret      
0x00005AA0: 48895c2408               mov      qword ptr [rsp + 8], rbx
0x00005AA5: 57                       push     rdi
0x00005AA6: 4883ec20                 sub      rsp, 0x20
0x00005AAA: 4863d9                   movsxd   rbx, ecx
0x00005AAD: 488d3d4c170100           lea      rdi, [rip + 0x1174c]
0x00005AB4: 4803db                   add      rbx, rbx
0x00005AB7: 48833cdf00               cmp      qword ptr [rdi + rbx*8], 0
0x00005ABC: 7511                     jne      0x180005acf
0x00005ABE: e8a9000000               call     0x180005b6c
0x00005AC3: 85c0                     test     eax, eax
0x00005AC5: 7508                     jne      0x180005acf
0x00005AC7: 8d4811                   lea      ecx, [rax + 0x11]
0x00005ACA: e851d0ffff               call     0x180002b20
0x00005ACF: 488b0cdf                 mov      rcx, qword ptr [rdi + rbx*8]
0x00005AD3: 488b5c2430               mov      rbx, qword ptr [rsp + 0x30]
0x00005AD8: 4883c420                 add      rsp, 0x20
0x00005ADC: 5f                       pop      rdi
0x00005ADD: 48e84d770200             call     0x18002d230
0x00005AE3: f1                       int1     
0x00005AE4: 48895c2408               mov      qword ptr [rsp + 8], rbx
0x00005AE9: 48896c2410               mov      qword ptr [rsp + 0x10], rbp
0x00005AEE: 4889742418               mov      qword ptr [rsp + 0x18], rsi
0x00005AF3: 57                       push     rdi
0x00005AF4: 4883ec20                 sub      rsp, 0x20
0x00005AF8: bf24000000               mov      edi, 0x24
0x00005AFD: 488d1dfc160100           lea      rbx, [rip + 0x116fc]
0x00005B04: 8bef                     mov      ebp, edi
0x00005B06: 488b33                   mov      rsi, qword ptr [rbx]
0x00005B09: 4885f6                   test     rsi, rsi
0x00005B0C: 741b                     je       0x180005b29
0x00005B0E: 837b0801                 cmp      dword ptr [rbx + 8], 1
0x00005B12: 7415                     je       0x180005b29
0x00005B14: 488bce                   mov      rcx, rsi
0x00005B17: e8ef3e1d00               call     0x1801d9a0b
0x00005B1C: 7748                     ja       0x180005b66
0x00005B1E: 8bce                     mov      ecx, esi
0x00005B20: e80bbdffff               call     0x180001830
0x00005B25: 48832300                 and      qword ptr [rbx], 0
0x00005B29: 4883c310                 add      rbx, 0x10
0x00005B2D: 48ffcd                   dec      rbp
0x00005B30: 75d4                     jne      0x180005b06
0x00005B32: 488d1dcf160100           lea      rbx, [rip + 0x116cf]
0x00005B39: 488b4bf8                 mov      rcx, qword ptr [rbx - 8]
0x00005B3D: 4885c9                   test     rcx, rcx
0x00005B40: 740b                     je       0x180005b4d
0x00005B42: 833b01                   cmp      dword ptr [rbx], 1
0x00005B45: 7506                     jne      0x180005b4d
0x00005B47: e80be71400               call     0x180154257
0x00005B4C: 94                       xchg     esp, eax
0x00005B4D: 4883c310                 add      rbx, 0x10
0x00005B51: 48ffcf                   dec      rdi
0x00005B54: 75e3                     jne      0x180005b39
0x00005B56: 488b5c2430               mov      rbx, qword ptr [rsp + 0x30]
0x00005B5B: 488b6c2438               mov      rbp, qword ptr [rsp + 0x38]
0x00005B60: 488b742440               mov      rsi, qword ptr [rsp + 0x40]
0x00005B65: 4883c420                 add      rsp, 0x20
0x00005B69: 5f                       pop      rdi
0x00005B6A: c3                       ret      
0x00005B6B: cc                       int3     
0x00005B6C: 48895c2408               mov      qword ptr [rsp + 8], rbx
0x00005B71: 48897c2410               mov      qword ptr [rsp + 0x10], rdi
0x00005B76: 4156                     push     r14
0x00005B78: 4883ec20                 sub      rsp, 0x20
0x00005B7C: 4863d9                   movsxd   rbx, ecx
0x00005B7F: 48833d7131010000         cmp      qword ptr [rip + 0x13171], 0
0x00005B87: 7519                     jne      0x180005ba2
0x00005B89: e806d3ffff               call     0x180002e94
0x00005B8E: b91e000000               mov      ecx, 0x1e
0x00005B93: e870d3ffff               call     0x180002f08
0x00005B98: b9ff000000               mov      ecx, 0xff
0x00005B9D: e81eceffff               call     0x1800029c0
0x00005BA2: 4803db                   add      rbx, rbx
0x00005BA5: 4c8d3554160100           lea      r14, [rip + 0x11654]
0x00005BAC: 49833cde00               cmp      qword ptr [r14 + rbx*8], 0
0x00005BB1: 7407                     je       0x180005bba
0x00005BB3: b801000000               mov      eax, 1
0x00005BB8: eb5e                     jmp      0x180005c18
0x00005BBA: b928000000               mov      ecx, 0x28
0x00005BBF: e814d8ffff               call     0x1800033d8
0x00005BC4: 488bf8                   mov      rdi, rax
0x00005BC7: 4885c0                   test     rax, rax
0x00005BCA: 750f                     jne      0x180005bdb
0x00005BCC: e8bbcaffff               call     0x18000268c
0x00005BD1: c7000c000000             mov      dword ptr [rax], 0xc
0x00005BD7: 33c0                     xor      eax, eax
0x00005BD9: eb3d                     jmp      0x180005c18
0x00005BDB: b90a000000               mov      ecx, 0xa
0x00005BE0: e8bbfeffff               call     0x180005aa0
0x00005BE5: 90                       nop      
0x00005BE6: 488bcf                   mov      rcx, rdi
0x00005BE9: 49833cde00               cmp      qword ptr [r14 + rbx*8], 0
0x00005BEE: 7513                     jne      0x180005c03
0x00005BF0: 4533c0                   xor      r8d, r8d
0x00005BF3: baa00f0000               mov      edx, 0xfa0
0x00005BF8: e823f3ffff               call     0x180004f20
0x00005BFD: 49893cde                 mov      qword ptr [r14 + rbx*8], rdi
0x00005C01: eb06                     jmp      0x180005c09
0x00005C03: e828bcffff               call     0x180001830
0x00005C08: 90                       nop      
0x00005C09: 488b0d90160100           mov      rcx, qword ptr [rip + 0x11690]
0x00005C10: e80ee91100               call     0x180124523
0x00005C15: 20eb                     and      bl, ch
0x00005C17: 9b                       wait     
0x00005C18: 488b5c2430               mov      rbx, qword ptr [rsp + 0x30]
0x00005C1D: 488b7c2438               mov      rdi, qword ptr [rsp + 0x38]
0x00005C22: 4883c420                 add      rsp, 0x20
0x00005C26: 415e                     pop      r14
0x00005C28: c3                       ret      
0x00005C29: cc                       int3     
0x00005C2A: cc                       int3     
0x00005C2B: cc                       int3     
0x00005C2C: 48895c2408               mov      qword ptr [rsp + 8], rbx
0x00005C31: 4889742410               mov      qword ptr [rsp + 0x10], rsi
0x00005C36: 57                       push     rdi
0x00005C37: 4883ec20                 sub      rsp, 0x20
0x00005C3B: 33f6                     xor      esi, esi
0x00005C3D: 488d1dbc150100           lea      rbx, [rip + 0x115bc]
0x00005C44: 8d7e24                   lea      edi, [rsi + 0x24]
0x00005C47: 837b0801                 cmp      dword ptr [rbx + 8], 1
0x00005C4B: 7524                     jne      0x180005c71
0x00005C4D: 4863c6                   movsxd   rax, esi
0x00005C50: 488d15793a0100           lea      rdx, [rip + 0x13a79]
0x00005C57: 4533c0                   xor      r8d, r8d
0x00005C5A: 488d0c80                 lea      rcx, [rax + rax*4]
0x00005C5E: ffc6                     inc      esi
0x00005C60: 488d0cca                 lea      rcx, [rdx + rcx*8]
0x00005C64: baa00f0000               mov      edx, 0xfa0
0x00005C69: 48890b                   mov      qword ptr [rbx], rcx
0x00005C6C: e8aff2ffff               call     0x180004f20
0x00005C71: 4883c310                 add      rbx, 0x10
0x00005C75: 48ffcf                   dec      rdi
0x00005C78: 75cd                     jne      0x180005c47
0x00005C7A: 488b5c2430               mov      rbx, qword ptr [rsp + 0x30]
0x00005C7F: 488b742438               mov      rsi, qword ptr [rsp + 0x38]
0x00005C84: 8d4701                   lea      eax, [rdi + 1]
0x00005C87: 4883c420                 add      rsp, 0x20
0x00005C8B: 5f                       pop      rdi
0x00005C8C: c3                       ret      
0x00005C8D: cc                       int3     
0x00005C8E: cc                       int3     
0x00005C8F: cc                       int3     
0x00005C90: 4863c9                   movsxd   rcx, ecx
0x00005C93: 488d0566150100           lea      rax, [rip + 0x11566]
0x00005C9A: 4803c9                   add      rcx, rcx
0x00005C9D: 488b0cc8                 mov      rcx, qword ptr [rax + rcx*8]
0x00005CA1: 48e8d7b51500             call     0x18016127e
0x00005CA7: 02cc                     add      cl, ah
0x00005CA9: cc                       int3     
0x00005CAA: cc                       int3     
0x00005CAB: cc                       int3     
0x00005CAC: cc                       int3     
0x00005CAD: cc                       int3     
0x00005CAE: cc                       int3     
0x00005CAF: cc                       int3     
0x00005CB0: 4c63413c                 movsxd   r8, dword ptr [rcx + 0x3c]
0x00005CB4: 4533c9                   xor      r9d, r9d
0x00005CB7: 4c8bd2                   mov      r10, rdx
0x00005CBA: 4c03c1                   add      r8, rcx
0x00005CBD: 410fb74014               movzx    eax, word ptr [r8 + 0x14]
0x00005CC2: 450fb75806               movzx    r11d, word ptr [r8 + 6]
0x00005CC7: 4883c018                 add      rax, 0x18
0x00005CCB: 4903c0                   add      rax, r8
0x00005CCE: 4585db                   test     r11d, r11d
0x00005CD1: 741e                     je       0x180005cf1
0x00005CD3: 8b500c                   mov      edx, dword ptr [rax + 0xc]
0x00005CD6: 4c3bd2                   cmp      r10, rdx
0x00005CD9: 720a                     jb       0x180005ce5
0x00005CDB: 8b4808                   mov      ecx, dword ptr [rax + 8]
0x00005CDE: 03ca                     add      ecx, edx
0x00005CE0: 4c3bd1                   cmp      r10, rcx
0x00005CE3: 720e                     jb       0x180005cf3
0x00005CE5: 41ffc1                   inc      r9d
0x00005CE8: 4883c028                 add      rax, 0x28
0x00005CEC: 453bcb                   cmp      r9d, r11d
0x00005CEF: 72e2                     jb       0x180005cd3
0x00005CF1: 33c0                     xor      eax, eax
0x00005CF3: c3                       ret      
0x00005CF4: cc                       int3     
0x00005CF5: cc                       int3     
0x00005CF6: cc                       int3     
0x00005CF7: cc                       int3     
0x00005CF8: cc                       int3     
0x00005CF9: cc                       int3     
0x00005CFA: cc                       int3     
0x00005CFB: cc                       int3     
0x00005CFC: cc                       int3     
0x00005CFD: cc                       int3     
0x00005CFE: cc                       int3     
0x00005CFF: cc                       int3     
0x00005D00: 48895c2408               mov      qword ptr [rsp + 8], rbx
0x00005D05: 57                       push     rdi
0x00005D06: 4883ec20                 sub      rsp, 0x20
0x00005D0A: 488bd9                   mov      rbx, rcx
0x00005D0D: 488d3deca2ffff           lea      rdi, [rip - 0x5d14]
0x00005D14: 488bcf                   mov      rcx, rdi
0x00005D17: e834000000               call     0x180005d50
0x00005D1C: 85c0                     test     eax, eax
0x00005D1E: 7422                     je       0x180005d42
0x00005D20: 482bdf                   sub      rbx, rdi
0x00005D23: 488bd3                   mov      rdx, rbx
0x00005D26: 488bcf                   mov      rcx, rdi
0x00005D29: e882ffffff               call     0x180005cb0
0x00005D2E: 4885c0                   test     rax, rax
0x00005D31: 740f                     je       0x180005d42
0x00005D33: 8b4024                   mov      eax, dword ptr [rax + 0x24]
0x00005D36: c1e81f                   shr      eax, 0x1f
0x00005D39: f7d0                     not      eax
0x00005D3B: 83e001                   and      eax, 1
0x00005D3E: eb02                     jmp      0x180005d42
0x00005D40: 33c0                     xor      eax, eax
0x00005D42: 488b5c2430               mov      rbx, qword ptr [rsp + 0x30]
0x00005D47: 4883c420                 add      rsp, 0x20
0x00005D4B: 5f                       pop      rdi
0x00005D4C: c3                       ret      
0x00005D4D: cc                       int3     
0x00005D4E: cc                       int3     
0x00005D4F: cc                       int3     
0x00005D50: 488bc1                   mov      rax, rcx
0x00005D53: b94d5a0000               mov      ecx, 0x5a4d
0x00005D58: 663908                   cmp      word ptr [rax], cx
0x00005D5B: 7403                     je       0x180005d60
0x00005D5D: 33c0                     xor      eax, eax
0x00005D5F: c3                       ret      
0x00005D60: 4863483c                 movsxd   rcx, dword ptr [rax + 0x3c]
0x00005D64: 4803c8                   add      rcx, rax
0x00005D67: 33c0                     xor      eax, eax
0x00005D69: 813950450000             cmp      dword ptr [rcx], 0x4550
0x00005D6F: 750c                     jne      0x180005d7d
0x00005D71: ba0b020000               mov      edx, 0x20b
0x00005D76: 66395118                 cmp      word ptr [rcx + 0x18], dx
0x00005D7A: 0f94c0                   sete     al
0x00005D7D: c3                       ret      
0x00005D7E: cc                       int3     
0x00005D7F: cc                       int3     
0x00005D80: 48895c2408               mov      qword ptr [rsp + 8], rbx
0x00005D85: 57                       push     rdi
0x00005D86: 4883ec20                 sub      rsp, 0x20
0x00005D8A: 33ff                     xor      edi, edi
0x00005D8C: 488d1dad160100           lea      rbx, [rip + 0x116ad]
0x00005D93: 488b0b                   mov      rcx, qword ptr [rbx]
0x00005D96: e8a7db0200               call     0x180033942
0x00005D9B: 38ff                     cmp      bh, bh
0x00005D9D: c7                       .byte    0xc7
0x00005D9E: 488903                   mov      qword ptr [rbx], rax
0x00005DA1: 4863c7                   movsxd   rax, edi
0x00005DA4: 488d5b08                 lea      rbx, [rbx + 8]
0x00005DA8: 4883f80a                 cmp      rax, 0xa
0x00005DAC: 72e5                     jb       0x180005d93
0x00005DAE: 488b5c2430               mov      rbx, qword ptr [rsp + 0x30]
0x00005DB3: 4883c420                 add      rsp, 0x20
0x00005DB7: 5f                       pop      rdi
0x00005DB8: c3                       ret      
0x00005DB9: cc                       int3     
0x00005DBA: cc                       int3     
0x00005DBB: cc                       int3     
0x00005DBC: 4883ec28                 sub      rsp, 0x28
0x00005DC0: e8c3e4ffff               call     0x180004288
0x00005DC5: 488b88d0000000           mov      rcx, qword ptr [rax + 0xd0]
0x00005DCC: 4885c9                   test     rcx, rcx
0x00005DCF: 7404                     je       0x180005dd5
0x00005DD1: ffd1                     call     rcx
0x00005DD3: eb00                     jmp      0x180005dd5
0x00005DD5: e88a230000               call     0x180008164
0x00005DDA: 90                       nop      
0x00005DDB: cc                       int3     
0x00005DDC: 4883ec28                 sub      rsp, 0x28
0x00005DE0: 488d0dd5ffffff           lea      rcx, [rip - 0x2b]
0x00005DE7: e8fd1b0f00               call     0x1800f79e9
0x00005DEC: b448                     mov      ah, 0x48
0x00005DEE: 89050c3b0100             mov      dword ptr [rip + 0x13b0c], eax
0x00005DF4: 4883c428                 add      rsp, 0x28
0x00005DF8: c3                       ret      
0x00005DF9: cc                       int3     
0x00005DFA: cc                       int3     
0x00005DFB: cc                       int3     
0x00005DFC: 48890d053b0100           mov      qword ptr [rip + 0x13b05], rcx
0x00005E03: c3                       ret      
0x00005E04: 488b0d153b0100           mov      rcx, qword ptr [rip + 0x13b15]
0x00005E0B: 48e8b52c0b00             call     0x1800b8ac6
0x00005E11: d8cc                     fmul     st(4)
0x00005E13: cc                       int3     
0x00005E14: 48890df53a0100           mov      qword ptr [rip + 0x13af5], rcx
0x00005E1B: 48890df63a0100           mov      qword ptr [rip + 0x13af6], rcx
0x00005E22: 48890df73a0100           mov      qword ptr [rip + 0x13af7], rcx
0x00005E29: 48890df83a0100           mov      qword ptr [rip + 0x13af8], rcx
0x00005E30: c3                       ret      
0x00005E31: cc                       int3     
0x00005E32: cc                       int3     
0x00005E33: cc                       int3     
0x00005E34: 48895c2418               mov      qword ptr [rsp + 0x18], rbx
0x00005E39: 4889742420               mov      qword ptr [rsp + 0x20], rsi
0x00005E3E: 57                       push     rdi
0x00005E3F: 4154                     push     r12
0x00005E41: 4155                     push     r13
0x00005E43: 4156                     push     r14
0x00005E45: 4157                     push     r15
0x00005E47: 4883ec30                 sub      rsp, 0x30
0x00005E4B: 8bd9                     mov      ebx, ecx
0x00005E4D: 4533ed                   xor      r13d, r13d
0x00005E50: 44216c2468               and      dword ptr [rsp + 0x68], r13d
0x00005E55: 33ff                     xor      edi, edi
0x00005E57: 897c2460                 mov      dword ptr [rsp + 0x60], edi
0x00005E5B: 33f6                     xor      esi, esi
0x00005E5D: 8bd1                     mov      edx, ecx
0x00005E5F: 83ea02                   sub      edx, 2
0x00005E62: 0f84c4000000             je       0x180005f2c
0x00005E68: 83ea02                   sub      edx, 2
0x00005E6B: 7462                     je       0x180005ecf
0x00005E6D: 83ea02                   sub      edx, 2
0x00005E70: 744d                     je       0x180005ebf
0x00005E72: 83ea02                   sub      edx, 2
0x00005E75: 7458                     je       0x180005ecf
0x00005E77: 83ea03                   sub      edx, 3
0x00005E7A: 7453                     je       0x180005ecf
0x00005E7C: 83ea04                   sub      edx, 4
0x00005E7F: 742e                     je       0x180005eaf
0x00005E81: 83ea06                   sub      edx, 6
0x00005E84: 7416                     je       0x180005e9c
0x00005E86: ffca                     dec      edx
0x00005E88: 7435                     je       0x180005ebf
0x00005E8A: e8fdc7ffff               call     0x18000268c
0x00005E8F: c70016000000             mov      dword ptr [rax], 0x16
0x00005E95: e80adaffff               call     0x1800038a4
0x00005E9A: eb40                     jmp      0x180005edc
0x00005E9C: 4c8d35753a0100           lea      r14, [rip + 0x13a75]
0x00005EA3: 488b0d6e3a0100           mov      rcx, qword ptr [rip + 0x13a6e]
0x00005EAA: e98b000000               jmp      0x180005f3a
0x00005EAF: 4c8d35723a0100           lea      r14, [rip + 0x13a72]
0x00005EB6: 488b0d6b3a0100           mov      rcx, qword ptr [rip + 0x13a6b]
0x00005EBD: eb7b                     jmp      0x180005f3a
0x00005EBF: 4c8d355a3a0100           lea      r14, [rip + 0x13a5a]
0x00005EC6: 488b0d533a0100           mov      rcx, qword ptr [rip + 0x13a53]
0x00005ECD: eb6b                     jmp      0x180005f3a
0x00005ECF: e8d8e3ffff               call     0x1800042ac
0x00005ED4: 488bf0                   mov      rsi, rax
0x00005ED7: 4885c0                   test     rax, rax
0x00005EDA: 7508                     jne      0x180005ee4
0x00005EDC: 83c8ff                   or       eax, 0xffffffff
0x00005EDF: e96b010000               jmp      0x18000604f
0x00005EE4: 488b90a0000000           mov      rdx, qword ptr [rax + 0xa0]
0x00005EEB: 488bca                   mov      rcx, rdx
0x00005EEE: 4c63055ba10000           movsxd   r8, dword ptr [rip + 0xa15b]
0x00005EF5: 395904                   cmp      dword ptr [rcx + 4], ebx
0x00005EF8: 7413                     je       0x180005f0d
0x00005EFA: 4883c110                 add      rcx, 0x10
0x00005EFE: 498bc0                   mov      rax, r8
0x00005F01: 48c1e004                 shl      rax, 4
0x00005F05: 4803c2                   add      rax, rdx
0x00005F08: 483bc8                   cmp      rcx, rax
0x00005F0B: 72e8                     jb       0x180005ef5
0x00005F0D: 498bc0                   mov      rax, r8
0x00005F10: 48c1e004                 shl      rax, 4
0x00005F14: 4803c2                   add      rax, rdx
0x00005F17: 483bc8                   cmp      rcx, rax
0x00005F1A: 7305                     jae      0x180005f21
0x00005F1C: 395904                   cmp      dword ptr [rcx + 4], ebx
0x00005F1F: 7402                     je       0x180005f23
0x00005F21: 33c9                     xor      ecx, ecx
0x00005F23: 4c8d7108                 lea      r14, [rcx + 8]
0x00005F27: 4d8b3e                   mov      r15, qword ptr [r14]
0x00005F2A: eb20                     jmp      0x180005f4c
0x00005F2C: 4c8d35dd390100           lea      r14, [rip + 0x139dd]
0x00005F33: 488b0dd6390100           mov      rcx, qword ptr [rip + 0x139d6]
0x00005F3A: bf01000000               mov      edi, 1
0x00005F3F: 897c2460                 mov      dword ptr [rsp + 0x60], edi
0x00005F43: e8ae731900               call     0x18019d2f6
0x00005F48: d7                       xlatb    
0x00005F49: 4c8bf8                   mov      r15, rax
0x00005F4C: 4983ff01                 cmp      r15, 1
0x00005F50: 7507                     jne      0x180005f59
0x00005F52: 33c0                     xor      eax, eax
0x00005F54: e9f6000000               jmp      0x18000604f
0x00005F59: 4d85ff                   test     r15, r15
0x00005F5C: 750a                     jne      0x180005f68
0x00005F5E: 418d4f03                 lea      ecx, [r15 + 3]
0x00005F62: e889ccffff               call     0x180002bf0
0x00005F67: cc                       int3     
0x00005F68: 85ff                     test     edi, edi
0x00005F6A: 7408                     je       0x180005f74
0x00005F6C: 33c9                     xor      ecx, ecx
0x00005F6E: e82dfbffff               call     0x180005aa0
0x00005F73: 90                       nop      
0x00005F74: 41bc10090000             mov      r12d, 0x910
0x00005F7A: 83fb0b                   cmp      ebx, 0xb
0x00005F7D: 7733                     ja       0x180005fb2
0x00005F7F: 410fa3dc                 bt       r12d, ebx
0x00005F83: 732d                     jae      0x180005fb2
0x00005F85: 4c8baea8000000           mov      r13, qword ptr [rsi + 0xa8]
0x00005F8C: 4c896c2428               mov      qword ptr [rsp + 0x28], r13
0x00005F91: 4883a6a800000000         and      qword ptr [rsi + 0xa8], 0
0x00005F99: 83fb08                   cmp      ebx, 8
0x00005F9C: 7552                     jne      0x180005ff0
0x00005F9E: 8b86b0000000             mov      eax, dword ptr [rsi + 0xb0]
0x00005FA4: 89442468                 mov      dword ptr [rsp + 0x68], eax
0x00005FA8: c786b00000008c000000     mov      dword ptr [rsi + 0xb0], 0x8c
0x00005FB2: 83fb08                   cmp      ebx, 8
0x00005FB5: 7539                     jne      0x180005ff0
0x00005FB7: 8b0d9ba00000             mov      ecx, dword ptr [rip + 0xa09b]
0x00005FBD: 8bd1                     mov      edx, ecx
0x00005FBF: 894c2420                 mov      dword ptr [rsp + 0x20], ecx
0x00005FC3: 8b0593a00000             mov      eax, dword ptr [rip + 0xa093]
0x00005FC9: 03c8                     add      ecx, eax
0x00005FCB: 3bd1                     cmp      edx, ecx
0x00005FCD: 7d2c                     jge      0x180005ffb
0x00005FCF: 4863ca                   movsxd   rcx, edx
0x00005FD2: 4803c9                   add      rcx, rcx
0x00005FD5: 488b86a0000000           mov      rax, qword ptr [rsi + 0xa0]
0x00005FDC: 488364c80800             and      qword ptr [rax + rcx*8 + 8], 0
0x00005FE2: ffc2                     inc      edx
0x00005FE4: 89542420                 mov      dword ptr [rsp + 0x20], edx
0x00005FE8: 8b0d6aa00000             mov      ecx, dword ptr [rip + 0xa06a]
0x00005FEE: ebd3                     jmp      0x180005fc3
0x00005FF0: 33c9                     xor      ecx, ecx
0x00005FF2: e8fbd00d00               call     0x1800e30f2
0x00005FF7: 084989                   or       byte ptr [rcx - 0x77], cl
0x00005FFA: 06                       .byte    0x06
0x00005FFB: 85ff                     test     edi, edi
0x00005FFD: 7407                     je       0x180006006
0x00005FFF: 33c9                     xor      ecx, ecx
0x00006001: e88afcffff               call     0x180005c90
0x00006006: 83fb08                   cmp      ebx, 8
0x00006009: 750d                     jne      0x180006018
0x0000600B: 8b96b0000000             mov      edx, dword ptr [rsi + 0xb0]
0x00006011: 8bcb                     mov      ecx, ebx
0x00006013: 41ffd7                   call     r15
0x00006016: eb05                     jmp      0x18000601d
0x00006018: 8bcb                     mov      ecx, ebx
0x0000601A: 41ffd7                   call     r15
0x0000601D: 83fb0b                   cmp      ebx, 0xb
0x00006020: 0f872cffffff             ja       0x180005f52
0x00006026: 410fa3dc                 bt       r12d, ebx
0x0000602A: 0f8322ffffff             jae      0x180005f52
0x00006030: 4c89aea8000000           mov      qword ptr [rsi + 0xa8], r13
0x00006037: 83fb08                   cmp      ebx, 8
0x0000603A: 0f8512ffffff             jne      0x180005f52
0x00006040: 8b442468                 mov      eax, dword ptr [rsp + 0x68]
0x00006044: 8986b0000000             mov      dword ptr [rsi + 0xb0], eax
0x0000604A: e903ffffff               jmp      0x180005f52
0x0000604F: 488b5c2470               mov      rbx, qword ptr [rsp + 0x70]
0x00006054: 488b742478               mov      rsi, qword ptr [rsp + 0x78]
0x00006059: 4883c430                 add      rsp, 0x30
0x0000605D: 415f                     pop      r15
0x0000605F: 415e                     pop      r14
0x00006061: 415d                     pop      r13
0x00006063: 415c                     pop      r12
0x00006065: 5f                       pop      rdi
0x00006066: c3                       ret      
0x00006067: cc                       int3     
0x00006068: 48890dc9380100           mov      qword ptr [rip + 0x138c9], rcx
0x0000606F: c3                       ret      
0x00006070: 4883ec28                 sub      rsp, 0x28
0x00006074: 833d3577010000           cmp      dword ptr [rip + 0x17735], 0
0x0000607B: 7514                     jne      0x180006091
0x0000607D: b9fdffffff               mov      ecx, 0xfffffffd
0x00006082: e869040000               call     0x1800064f0
0x00006087: c7051f77010001000000     mov      dword ptr [rip + 0x1771f], 1
0x00006091: 33c0                     xor      eax, eax
0x00006093: 4883c428                 add      rsp, 0x28
0x00006097: c3                       ret      
0x00006098: 4053                     push     rbx
0x0000609A: 4883ec20                 sub      rsp, 0x20
0x0000609E: 488bd9                   mov      rbx, rcx
0x000060A1: c6411800                 mov      byte ptr [rcx + 0x18], 0
0x000060A5: 4885d2                   test     rdx, rdx
0x000060A8: 0f8582000000             jne      0x180006130
0x000060AE: e8d5e1ffff               call     0x180004288
0x000060B3: 48894310                 mov      qword ptr [rbx + 0x10], rax
0x000060B7: 488b90c0000000           mov      rdx, qword ptr [rax + 0xc0]
0x000060BE: 488913                   mov      qword ptr [rbx], rdx
0x000060C1: 488b88b8000000           mov      rcx, qword ptr [rax + 0xb8]
0x000060C8: 48894b08                 mov      qword ptr [rbx + 8], rcx
0x000060CC: 483b15fd1c0100           cmp      rdx, qword ptr [rip + 0x11cfd]
0x000060D3: 7416                     je       0x1800060eb
0x000060D5: 8b80c8000000             mov      eax, dword ptr [rax + 0xc8]
0x000060DB: 850533220100             test     dword ptr [rip + 0x12233], eax
0x000060E1: 7508                     jne      0x1800060eb
0x000060E3: e8301d0000               call     0x180007e18
0x000060E8: 488903                   mov      qword ptr [rbx], rax
0x000060EB: 488b05ce180100           mov      rax, qword ptr [rip + 0x118ce]
0x000060F2: 48394308                 cmp      qword ptr [rbx + 8], rax
0x000060F6: 741b                     je       0x180006113
0x000060F8: 488b4310                 mov      rax, qword ptr [rbx + 0x10]
0x000060FC: 8b88c8000000             mov      ecx, dword ptr [rax + 0xc8]
0x00006102: 850d0c220100             test     dword ptr [rip + 0x1220c], ecx
0x00006108: 7509                     jne      0x180006113
0x0000610A: e825030000               call     0x180006434
0x0000610F: 48894308                 mov      qword ptr [rbx + 8], rax
0x00006113: 488b4b10                 mov      rcx, qword ptr [rbx + 0x10]
0x00006117: 8b81c8000000             mov      eax, dword ptr [rcx + 0xc8]
0x0000611D: a802                     test     al, 2
0x0000611F: 7516                     jne      0x180006137
0x00006121: 83c802                   or       eax, 2
0x00006124: 8981c8000000             mov      dword ptr [rcx + 0xc8], eax
0x0000612A: c6431801                 mov      byte ptr [rbx + 0x18], 1
0x0000612E: eb07                     jmp      0x180006137
0x00006130: 0f1002                   movups   xmm0, xmmword ptr [rdx]
0x00006133: f30f7f01                 movdqu   xmmword ptr [rcx], xmm0
0x00006137: 488bc3                   mov      rax, rbx
0x0000613A: 4883c420                 add      rsp, 0x20
0x0000613E: 5b                       pop      rbx
0x0000613F: c3                       ret      
0x00006140: 4053                     push     rbx
0x00006142: 4883ec40                 sub      rsp, 0x40
0x00006146: 8bd9                     mov      ebx, ecx
0x00006148: 488d4c2420               lea      rcx, [rsp + 0x20]
0x0000614D: 33d2                     xor      edx, edx
0x0000614F: e844ffffff               call     0x180006098
0x00006154: 83250538010000           and      dword ptr [rip + 0x13805], 0
0x0000615B: 83fbfe                   cmp      ebx, -2
0x0000615E: 7512                     jne      0x180006172
0x00006160: c705f637010001000000     mov      dword ptr [rip + 0x137f6], 1
0x0000616A: 52                       push     rdx
0x0000616B: e8e8d71b00               call     0x1801c3958
0x00006170: eb15                     jmp      0x180006187
0x00006172: 83fbfd                   cmp      ebx, -3
0x00006175: 7514                     jne      0x18000618b
0x00006177: c705df37010001000000     mov      dword ptr [rip + 0x137df], 1
0x00006181: e8e2dc0100               call     0x180023e68
0x00006186: 9d                       popfq    
0x00006187: 8bd8                     mov      ebx, eax
0x00006189: eb17                     jmp      0x1800061a2
0x0000618B: 83fbfc                   cmp      ebx, -4
0x0000618E: 7512                     jne      0x1800061a2
0x00006190: 488b442420               mov      rax, qword ptr [rsp + 0x20]
0x00006195: c705c137010001000000     mov      dword ptr [rip + 0x137c1], 1
0x0000619F: 8b5804                   mov      ebx, dword ptr [rax + 4]
0x000061A2: 807c243800               cmp      byte ptr [rsp + 0x38], 0
0x000061A7: 740c                     je       0x1800061b5
0x000061A9: 488b4c2430               mov      rcx, qword ptr [rsp + 0x30]
0x000061AE: 83a1c8000000fd           and      dword ptr [rcx + 0xc8], 0xfffffffd
0x000061B5: 8bc3                     mov      eax, ebx
0x000061B7: 4883c440                 add      rsp, 0x40
0x000061BB: 5b                       pop      rbx
0x000061BC: c3                       ret      
0x000061BD: cc                       int3     
0x000061BE: cc                       int3     
0x000061BF: cc                       int3     
0x000061C0: 48895c2408               mov      qword ptr [rsp + 8], rbx
0x000061C5: 48896c2410               mov      qword ptr [rsp + 0x10], rbp
0x000061CA: 4889742418               mov      qword ptr [rsp + 0x18], rsi
0x000061CF: 57                       push     rdi
0x000061D0: 4883ec20                 sub      rsp, 0x20
0x000061D4: 488d5918                 lea      rbx, [rcx + 0x18]
0x000061D8: 488bf1                   mov      rsi, rcx
0x000061DB: bd01010000               mov      ebp, 0x101
0x000061E0: 488bcb                   mov      rcx, rbx
0x000061E3: 448bc5                   mov      r8d, ebp
0x000061E6: 33d2                     xor      edx, edx
0x000061E8: e8e3c0ffff               call     0x1800022d0
0x000061ED: 33c0                     xor      eax, eax
0x000061EF: 488d7e0c                 lea      rdi, [rsi + 0xc]
0x000061F3: 48894604                 mov      qword ptr [rsi + 4], rax
0x000061F7: 48898620020000           mov      qword ptr [rsi + 0x220], rax
0x000061FE: b906000000               mov      ecx, 6
0x00006203: 0fb7c0                   movzx    eax, ax
0x00006206: 66f3ab                   rep stosw word ptr [rdi], ax
0x00006209: 488d3d90140100           lea      rdi, [rip + 0x11490]
0x00006210: 482bfe                   sub      rdi, rsi
0x00006213: 8a041f                   mov      al, byte ptr [rdi + rbx]
0x00006216: 8803                     mov      byte ptr [rbx], al
0x00006218: 48ffc3                   inc      rbx
0x0000621B: 48ffcd                   dec      rbp
0x0000621E: 75f3                     jne      0x180006213
0x00006220: 488d8e19010000           lea      rcx, [rsi + 0x119]
0x00006227: ba00010000               mov      edx, 0x100
0x0000622C: 8a0439                   mov      al, byte ptr [rcx + rdi]
0x0000622F: 8801                     mov      byte ptr [rcx], al
0x00006231: 48ffc1                   inc      rcx
0x00006234: 48ffca                   dec      rdx
0x00006237: 75f3                     jne      0x18000622c
0x00006239: 488b5c2430               mov      rbx, qword ptr [rsp + 0x30]
0x0000623E: 488b6c2438               mov      rbp, qword ptr [rsp + 0x38]
0x00006243: 488b742440               mov      rsi, qword ptr [rsp + 0x40]
0x00006248: 4883c420                 add      rsp, 0x20
0x0000624C: 5f                       pop      rdi
0x0000624D: c3                       ret      
0x0000624E: cc                       int3     
0x0000624F: cc                       int3     
0x00006250: 48895c2410               mov      qword ptr [rsp + 0x10], rbx
0x00006255: 48897c2418               mov      qword ptr [rsp + 0x18], rdi
0x0000625A: 55                       push     rbp
0x0000625B: 488dac2480fbffff         lea      rbp, [rsp - 0x480]
0x00006263: 4881ec80050000           sub      rsp, 0x580
0x0000626A: 488b058f0d0100           mov      rax, qword ptr [rip + 0x10d8f]
0x00006271: 4833c4                   xor      rax, rsp
0x00006274: 48898570040000           mov      qword ptr [rbp + 0x470], rax
0x0000627B: 488bf9                   mov      rdi, rcx
0x0000627E: 8b4904                   mov      ecx, dword ptr [rcx + 4]
0x00006281: 488d542450               lea      rdx, [rsp + 0x50]
0x00006286: e8d8d40300               call     0x180043763
0x0000628B: 54                       push     rsp
0x0000628C: bb00010000               mov      ebx, 0x100
0x00006291: 85c0                     test     eax, eax
0x00006293: 0f8435010000             je       0x1800063ce
0x00006299: 33c0                     xor      eax, eax
0x0000629B: 488d4c2470               lea      rcx, [rsp + 0x70]
0x000062A0: 8801                     mov      byte ptr [rcx], al
0x000062A2: ffc0                     inc      eax
0x000062A4: 48ffc1                   inc      rcx
0x000062A7: 3bc3                     cmp      eax, ebx
0x000062A9: 72f5                     jb       0x1800062a0
0x000062AB: 8a442456                 mov      al, byte ptr [rsp + 0x56]
0x000062AF: c644247020               mov      byte ptr [rsp + 0x70], 0x20
0x000062B4: 488d542456               lea      rdx, [rsp + 0x56]
0x000062B9: eb22                     jmp      0x1800062dd
0x000062BB: 440fb64201               movzx    r8d, byte ptr [rdx + 1]
0x000062C0: 0fb6c8                   movzx    ecx, al
0x000062C3: eb0d                     jmp      0x1800062d2
0x000062C5: 3bcb                     cmp      ecx, ebx
0x000062C7: 730e                     jae      0x1800062d7
0x000062C9: 8bc1                     mov      eax, ecx
0x000062CB: c6440c7020               mov      byte ptr [rsp + rcx + 0x70], 0x20
0x000062D0: ffc1                     inc      ecx
0x000062D2: 413bc8                   cmp      ecx, r8d
0x000062D5: 76ee                     jbe      0x1800062c5
0x000062D7: 4883c202                 add      rdx, 2
0x000062DB: 8a02                     mov      al, byte ptr [rdx]
0x000062DD: 84c0                     test     al, al
0x000062DF: 75da                     jne      0x1800062bb
0x000062E1: 8b4704                   mov      eax, dword ptr [rdi + 4]
0x000062E4: 8364243000               and      dword ptr [rsp + 0x30], 0
0x000062E9: 4c8d442470               lea      r8, [rsp + 0x70]
0x000062EE: 89442428                 mov      dword ptr [rsp + 0x28], eax
0x000062F2: 488d8570020000           lea      rax, [rbp + 0x270]
0x000062F9: 448bcb                   mov      r9d, ebx
0x000062FC: ba01000000               mov      edx, 1
0x00006301: 33c9                     xor      ecx, ecx
0x00006303: 4889442420               mov      qword ptr [rsp + 0x20], rax
0x00006308: e89f260000               call     0x1800089ac
0x0000630D: 8364244000               and      dword ptr [rsp + 0x40], 0
0x00006312: 8b4704                   mov      eax, dword ptr [rdi + 4]
0x00006315: 488b9720020000           mov      rdx, qword ptr [rdi + 0x220]
0x0000631C: 89442438                 mov      dword ptr [rsp + 0x38], eax
0x00006320: 488d4570                 lea      rax, [rbp + 0x70]
0x00006324: 895c2430                 mov      dword ptr [rsp + 0x30], ebx
0x00006328: 4889442428               mov      qword ptr [rsp + 0x28], rax
0x0000632D: 4c8d4c2470               lea      r9, [rsp + 0x70]
0x00006332: 448bc3                   mov      r8d, ebx
0x00006335: 33c9                     xor      ecx, ecx
0x00006337: 895c2420                 mov      dword ptr [rsp + 0x20], ebx
0x0000633B: e85c240000               call     0x18000879c
0x00006340: 8364244000               and      dword ptr [rsp + 0x40], 0
0x00006345: 8b4704                   mov      eax, dword ptr [rdi + 4]
0x00006348: 488b9720020000           mov      rdx, qword ptr [rdi + 0x220]
0x0000634F: 89442438                 mov      dword ptr [rsp + 0x38], eax
0x00006353: 488d8570010000           lea      rax, [rbp + 0x170]
0x0000635A: 895c2430                 mov      dword ptr [rsp + 0x30], ebx
0x0000635E: 4889442428               mov      qword ptr [rsp + 0x28], rax
0x00006363: 4c8d4c2470               lea      r9, [rsp + 0x70]
0x00006368: 41b800020000             mov      r8d, 0x200
0x0000636E: 33c9                     xor      ecx, ecx
0x00006370: 895c2420                 mov      dword ptr [rsp + 0x20], ebx
0x00006374: e823240000               call     0x18000879c
0x00006379: 4c8d4570                 lea      r8, [rbp + 0x70]
0x0000637D: 4c8d8d70010000           lea      r9, [rbp + 0x170]
0x00006384: 4c2bc7                   sub      r8, rdi
0x00006387: 488d9570020000           lea      rdx, [rbp + 0x270]
0x0000638E: 488d4f19                 lea      rcx, [rdi + 0x19]
0x00006392: 4c2bcf                   sub      r9, rdi
0x00006395: f60201                   test     byte ptr [rdx], 1
0x00006398: 740a                     je       0x1800063a4
0x0000639A: 800910                   or       byte ptr [rcx], 0x10
0x0000639D: 418a4408e7               mov      al, byte ptr [r8 + rcx - 0x19]
0x000063A2: eb0d                     jmp      0x1800063b1
0x000063A4: f60202                   test     byte ptr [rdx], 2
0x000063A7: 7410                     je       0x1800063b9
0x000063A9: 800920                   or       byte ptr [rcx], 0x20
0x000063AC: 418a4409e7               mov      al, byte ptr [r9 + rcx - 0x19]
0x000063B1: 888100010000             mov      byte ptr [rcx + 0x100], al
0x000063B7: eb07                     jmp      0x1800063c0
0x000063B9: c6810001000000           mov      byte ptr [rcx + 0x100], 0
0x000063C0: 48ffc1                   inc      rcx
0x000063C3: 4883c202                 add      rdx, 2
0x000063C7: 48ffcb                   dec      rbx
0x000063CA: 75c9                     jne      0x180006395
0x000063CC: eb3f                     jmp      0x18000640d
0x000063CE: 33d2                     xor      edx, edx
0x000063D0: 488d4f19                 lea      rcx, [rdi + 0x19]
0x000063D4: 448d429f                 lea      r8d, [rdx - 0x61]
0x000063D8: 418d4020                 lea      eax, [r8 + 0x20]
0x000063DC: 83f819                   cmp      eax, 0x19
0x000063DF: 7708                     ja       0x1800063e9
0x000063E1: 800910                   or       byte ptr [rcx], 0x10
0x000063E4: 8d4220                   lea      eax, [rdx + 0x20]
0x000063E7: eb0c                     jmp      0x1800063f5
0x000063E9: 4183f819                 cmp      r8d, 0x19
0x000063ED: 770e                     ja       0x1800063fd
0x000063EF: 800920                   or       byte ptr [rcx], 0x20
0x000063F2: 8d42e0                   lea      eax, [rdx - 0x20]
0x000063F5: 888100010000             mov      byte ptr [rcx + 0x100], al
0x000063FB: eb07                     jmp      0x180006404
0x000063FD: c6810001000000           mov      byte ptr [rcx + 0x100], 0
0x00006404: ffc2                     inc      edx
0x00006406: 48ffc1                   inc      rcx
0x00006409: 3bd3                     cmp      edx, ebx
0x0000640B: 72c7                     jb       0x1800063d4
0x0000640D: 488b8d70040000           mov      rcx, qword ptr [rbp + 0x470]
0x00006414: 4833cc                   xor      rcx, rsp
0x00006417: e8f4b3ffff               call     0x180001810
0x0000641C: 4c8d9c2480050000         lea      r11, [rsp + 0x580]
0x00006424: 498b5b18                 mov      rbx, qword ptr [r11 + 0x18]
0x00006428: 498b7b20                 mov      rdi, qword ptr [r11 + 0x20]
0x0000642C: 498be3                   mov      rsp, r11
0x0000642F: 5d                       pop      rbp
0x00006430: c3                       ret      
0x00006431: cc                       int3     
0x00006432: cc                       int3     
0x00006433: cc                       int3     
0x00006434: 48895c2410               mov      qword ptr [rsp + 0x10], rbx
0x00006439: 57                       push     rdi
0x0000643A: 4883ec20                 sub      rsp, 0x20
0x0000643E: e845deffff               call     0x180004288
0x00006443: 488bf8                   mov      rdi, rax
0x00006446: 8b0dc81e0100             mov      ecx, dword ptr [rip + 0x11ec8]
0x0000644C: 8588c8000000             test     dword ptr [rax + 0xc8], ecx
0x00006452: 7413                     je       0x180006467
0x00006454: 4883b8c000000000         cmp      qword ptr [rax + 0xc0], 0
0x0000645C: 7409                     je       0x180006467
0x0000645E: 488b98b8000000           mov      rbx, qword ptr [rax + 0xb8]
0x00006465: eb6c                     jmp      0x1800064d3
0x00006467: b90d000000               mov      ecx, 0xd
0x0000646C: e82ff6ffff               call     0x180005aa0
0x00006471: 90                       nop      
0x00006472: 488b9fb8000000           mov      rbx, qword ptr [rdi + 0xb8]
0x00006479: 48895c2430               mov      qword ptr [rsp + 0x30], rbx
0x0000647E: 483b1d3b150100           cmp      rbx, qword ptr [rip + 0x1153b]
0x00006485: 7442                     je       0x1800064c9
0x00006487: 4885db                   test     rbx, rbx
0x0000648A: 741b                     je       0x1800064a7
0x0000648C: f0ff0b                   lock dec dword ptr [rbx]
0x0000648F: 7516                     jne      0x1800064a7
0x00006491: 488d0508120100           lea      rax, [rip + 0x11208]
0x00006498: 488b4c2430               mov      rcx, qword ptr [rsp + 0x30]
0x0000649D: 483bc8                   cmp      rcx, rax
0x000064A0: 7405                     je       0x1800064a7
0x000064A2: e889b3ffff               call     0x180001830
0x000064A7: 488b0512150100           mov      rax, qword ptr [rip + 0x11512]
0x000064AE: 488987b8000000           mov      qword ptr [rdi + 0xb8], rax
0x000064B5: 488b0504150100           mov      rax, qword ptr [rip + 0x11504]
0x000064BC: 4889442430               mov      qword ptr [rsp + 0x30], rax
0x000064C1: f0ff00                   lock inc dword ptr [rax]
0x000064C4: 488b5c2430               mov      rbx, qword ptr [rsp + 0x30]
0x000064C9: b90d000000               mov      ecx, 0xd
0x000064CE: e8bdf7ffff               call     0x180005c90
0x000064D3: 4885db                   test     rbx, rbx
0x000064D6: 7508                     jne      0x1800064e0
0x000064D8: 8d4b20                   lea      ecx, [rbx + 0x20]
0x000064DB: e840c6ffff               call     0x180002b20
0x000064E0: 488bc3                   mov      rax, rbx
0x000064E3: 488b5c2438               mov      rbx, qword ptr [rsp + 0x38]
0x000064E8: 4883c420                 add      rsp, 0x20
0x000064EC: 5f                       pop      rdi
0x000064ED: c3                       ret      
0x000064EE: cc                       int3     
0x000064EF: cc                       int3     
0x000064F0: 488bc4                   mov      rax, rsp
0x000064F3: 48895808                 mov      qword ptr [rax + 8], rbx
0x000064F7: 48897010                 mov      qword ptr [rax + 0x10], rsi
0x000064FB: 48897818                 mov      qword ptr [rax + 0x18], rdi
0x000064FF: 4c897020                 mov      qword ptr [rax + 0x20], r14
0x00006503: 4157                     push     r15
0x00006505: 4883ec30                 sub      rsp, 0x30
0x00006509: 8bf9                     mov      edi, ecx
0x0000650B: 4183cfff                 or       r15d, 0xffffffff
0x0000650F: e874ddffff               call     0x180004288
0x00006514: 488bf0                   mov      rsi, rax
0x00006517: e818ffffff               call     0x180006434
0x0000651C: 488b9eb8000000           mov      rbx, qword ptr [rsi + 0xb8]
0x00006523: 8bcf                     mov      ecx, edi
0x00006525: e816fcffff               call     0x180006140
0x0000652A: 448bf0                   mov      r14d, eax
0x0000652D: 3b4304                   cmp      eax, dword ptr [rbx + 4]
0x00006530: 0f84db010000             je       0x180006711
0x00006536: b928020000               mov      ecx, 0x228
0x0000653B: e898ceffff               call     0x1800033d8
0x00006540: 488bd8                   mov      rbx, rax
0x00006543: 33ff                     xor      edi, edi
0x00006545: 4885c0                   test     rax, rax
0x00006548: 0f84c8010000             je       0x180006716
0x0000654E: 488b86b8000000           mov      rax, qword ptr [rsi + 0xb8]
0x00006555: 488bcb                   mov      rcx, rbx
0x00006558: 8d5704                   lea      edx, [rdi + 4]
0x0000655B: 448d427c                 lea      r8d, [rdx + 0x7c]
0x0000655F: 0f1000                   movups   xmm0, xmmword ptr [rax]
0x00006562: 0f1101                   movups   xmmword ptr [rcx], xmm0
0x00006565: 0f104810                 movups   xmm1, xmmword ptr [rax + 0x10]
0x00006569: 0f114910                 movups   xmmword ptr [rcx + 0x10], xmm1
0x0000656D: 0f104020                 movups   xmm0, xmmword ptr [rax + 0x20]
0x00006571: 0f114120                 movups   xmmword ptr [rcx + 0x20], xmm0
0x00006575: 0f104830                 movups   xmm1, xmmword ptr [rax + 0x30]
0x00006579: 0f114930                 movups   xmmword ptr [rcx + 0x30], xmm1
0x0000657D: 0f104040                 movups   xmm0, xmmword ptr [rax + 0x40]
0x00006581: 0f114140                 movups   xmmword ptr [rcx + 0x40], xmm0
0x00006585: 0f104850                 movups   xmm1, xmmword ptr [rax + 0x50]
0x00006589: 0f114950                 movups   xmmword ptr [rcx + 0x50], xmm1
0x0000658D: 0f104060                 movups   xmm0, xmmword ptr [rax + 0x60]
0x00006591: 0f114160                 movups   xmmword ptr [rcx + 0x60], xmm0
0x00006595: 4903c8                   add      rcx, r8
0x00006598: 0f104870                 movups   xmm1, xmmword ptr [rax + 0x70]
0x0000659C: 0f1149f0                 movups   xmmword ptr [rcx - 0x10], xmm1
0x000065A0: 4903c0                   add      rax, r8
0x000065A3: 48ffca                   dec      rdx
0x000065A6: 75b7                     jne      0x18000655f
0x000065A8: 0f1000                   movups   xmm0, xmmword ptr [rax]
0x000065AB: 0f1101                   movups   xmmword ptr [rcx], xmm0
0x000065AE: 0f104810                 movups   xmm1, xmmword ptr [rax + 0x10]
0x000065B2: 0f114910                 movups   xmmword ptr [rcx + 0x10], xmm1
0x000065B6: 488b4020                 mov      rax, qword ptr [rax + 0x20]
0x000065BA: 48894120                 mov      qword ptr [rcx + 0x20], rax
0x000065BE: 893b                     mov      dword ptr [rbx], edi
0x000065C0: 488bd3                   mov      rdx, rbx
0x000065C3: 418bce                   mov      ecx, r14d
0x000065C6: e869010000               call     0x180006734
0x000065CB: 448bf8                   mov      r15d, eax
0x000065CE: 85c0                     test     eax, eax
0x000065D0: 0f8515010000             jne      0x1800066eb
0x000065D6: 488b8eb8000000           mov      rcx, qword ptr [rsi + 0xb8]
0x000065DD: 4c8d35bc100100           lea      r14, [rip + 0x110bc]
0x000065E4: f0ff09                   lock dec dword ptr [rcx]
0x000065E7: 7511                     jne      0x1800065fa
0x000065E9: 488b8eb8000000           mov      rcx, qword ptr [rsi + 0xb8]
0x000065F0: 493bce                   cmp      rcx, r14
0x000065F3: 7405                     je       0x1800065fa
0x000065F5: e836b2ffff               call     0x180001830
0x000065FA: 48899eb8000000           mov      qword ptr [rsi + 0xb8], rbx
0x00006601: f0ff03                   lock inc dword ptr [rbx]
0x00006604: f686c800000002           test     byte ptr [rsi + 0xc8], 2
0x0000660B: 0f8505010000             jne      0x180006716
0x00006611: f605fc1c010001           test     byte ptr [rip + 0x11cfc], 1
0x00006618: 0f85f8000000             jne      0x180006716
0x0000661E: be0d000000               mov      esi, 0xd
0x00006623: 8bce                     mov      ecx, esi
0x00006625: e876f4ffff               call     0x180005aa0
0x0000662A: 90                       nop      
0x0000662B: 8b4304                   mov      eax, dword ptr [rbx + 4]
0x0000662E: 89050c330100             mov      dword ptr [rip + 0x1330c], eax
0x00006634: 8b4308                   mov      eax, dword ptr [rbx + 8]
0x00006637: 890507330100             mov      dword ptr [rip + 0x13307], eax
0x0000663D: 488b8320020000           mov      rax, qword ptr [rbx + 0x220]
0x00006644: 4889050d330100           mov      qword ptr [rip + 0x1330d], rax
0x0000664B: 8bd7                     mov      edx, edi
0x0000664D: 4c8d05ac99ffff           lea      r8, [rip - 0x6654]
0x00006654: 89542420                 mov      dword ptr [rsp + 0x20], edx
0x00006658: 83fa05                   cmp      edx, 5
0x0000665B: 7d15                     jge      0x180006672
0x0000665D: 4863ca                   movsxd   rcx, edx
0x00006660: 0fb7444b0c               movzx    eax, word ptr [rbx + rcx*2 + 0xc]
0x00006665: 664189844848990100       mov      word ptr [r8 + rcx*2 + 0x19948], ax
0x0000666E: ffc2                     inc      edx
0x00006670: ebe2                     jmp      0x180006654
0x00006672: 8bd7                     mov      edx, edi
0x00006674: 89542420                 mov      dword ptr [rsp + 0x20], edx
0x00006678: 81fa01010000             cmp      edx, 0x101
0x0000667E: 7d13                     jge      0x180006693
0x00006680: 4863ca                   movsxd   rcx, edx
0x00006683: 8a441918                 mov      al, byte ptr [rcx + rbx + 0x18]
0x00006687: 4288840190740100         mov      byte ptr [rcx + r8 + 0x17490], al
0x0000668F: ffc2                     inc      edx
0x00006691: ebe1                     jmp      0x180006674
0x00006693: 897c2420                 mov      dword ptr [rsp + 0x20], edi
0x00006697: 81ff00010000             cmp      edi, 0x100
0x0000669D: 7d16                     jge      0x1800066b5
0x0000669F: 4863cf                   movsxd   rcx, edi
0x000066A2: 8a841919010000           mov      al, byte ptr [rcx + rbx + 0x119]
0x000066A9: 42888401a0750100         mov      byte ptr [rcx + r8 + 0x175a0], al
0x000066B1: ffc7                     inc      edi
0x000066B3: ebde                     jmp      0x180006693
0x000066B5: 488b0d04130100           mov      rcx, qword ptr [rip + 0x11304]
0x000066BC: 83c8ff                   or       eax, 0xffffffff
0x000066BF: f00fc101                 lock xadd dword ptr [rcx], eax
0x000066C3: ffc8                     dec      eax
0x000066C5: 7511                     jne      0x1800066d8
0x000066C7: 488b0df2120100           mov      rcx, qword ptr [rip + 0x112f2]
0x000066CE: 493bce                   cmp      rcx, r14
0x000066D1: 7405                     je       0x1800066d8
0x000066D3: e858b1ffff               call     0x180001830
0x000066D8: 48891de1120100           mov      qword ptr [rip + 0x112e1], rbx
0x000066DF: f0ff03                   lock inc dword ptr [rbx]
0x000066E2: 8bce                     mov      ecx, esi
0x000066E4: e8a7f5ffff               call     0x180005c90
0x000066E9: eb2b                     jmp      0x180006716
0x000066EB: 83f8ff                   cmp      eax, -1
0x000066EE: 7526                     jne      0x180006716
0x000066F0: 4c8d35a90f0100           lea      r14, [rip + 0x10fa9]
0x000066F7: 493bde                   cmp      rbx, r14
0x000066FA: 7408                     je       0x180006704
0x000066FC: 488bcb                   mov      rcx, rbx
0x000066FF: e82cb1ffff               call     0x180001830
0x00006704: e883bfffff               call     0x18000268c
0x00006709: c70016000000             mov      dword ptr [rax], 0x16
0x0000670F: eb05                     jmp      0x180006716
0x00006711: 33ff                     xor      edi, edi
0x00006713: 448bff                   mov      r15d, edi
0x00006716: 418bc7                   mov      eax, r15d
0x00006719: 488b5c2440               mov      rbx, qword ptr [rsp + 0x40]
0x0000671E: 488b742448               mov      rsi, qword ptr [rsp + 0x48]
0x00006723: 488b7c2450               mov      rdi, qword ptr [rsp + 0x50]
0x00006728: 4c8b742458               mov      r14, qword ptr [rsp + 0x58]
0x0000672D: 4883c430                 add      rsp, 0x30
0x00006731: 415f                     pop      r15
0x00006733: c3                       ret      
0x00006734: 48895c2418               mov      qword ptr [rsp + 0x18], rbx
0x00006739: 48896c2420               mov      qword ptr [rsp + 0x20], rbp
0x0000673E: 56                       push     rsi
0x0000673F: 57                       push     rdi
0x00006740: 4154                     push     r12
0x00006742: 4156                     push     r14
0x00006744: 4157                     push     r15
0x00006746: 4883ec40                 sub      rsp, 0x40
0x0000674A: 488b05af080100           mov      rax, qword ptr [rip + 0x108af]
0x00006751: 4833c4                   xor      rax, rsp
0x00006754: 4889442438               mov      qword ptr [rsp + 0x38], rax
0x00006759: 488bda                   mov      rbx, rdx
0x0000675C: e8dff9ffff               call     0x180006140
0x00006761: 33f6                     xor      esi, esi
0x00006763: 8bf8                     mov      edi, eax
0x00006765: 85c0                     test     eax, eax
0x00006767: 750d                     jne      0x180006776
0x00006769: 488bcb                   mov      rcx, rbx
0x0000676C: e84ffaffff               call     0x1800061c0
0x00006771: e944020000               jmp      0x1800069ba
0x00006776: 4c8d2553110100           lea      r12, [rip + 0x11153]
0x0000677D: 8bee                     mov      ebp, esi
0x0000677F: 41bf01000000             mov      r15d, 1
0x00006785: 498bc4                   mov      rax, r12
0x00006788: 3938                     cmp      dword ptr [rax], edi
0x0000678A: 0f8438010000             je       0x1800068c8
0x00006790: 4103ef                   add      ebp, r15d
0x00006793: 4883c030                 add      rax, 0x30
0x00006797: 83fd05                   cmp      ebp, 5
0x0000679A: 72ec                     jb       0x180006788
0x0000679C: 8d871802ffff             lea      eax, [rdi - 0xfde8]
0x000067A2: 413bc7                   cmp      eax, r15d
0x000067A5: 0f8615010000             jbe      0x1800068c0
0x000067AB: 0fb7cf                   movzx    ecx, di
0x000067AE: 57                       push     rdi
0x000067AF: e8b7b61b00               call     0x1801c1e6b
0x000067B4: 85c0                     test     eax, eax
0x000067B6: 0f8404010000             je       0x1800068c0
0x000067BC: 488d542420               lea      rdx, [rsp + 0x20]
0x000067C1: 8bcf                     mov      ecx, edi
0x000067C3: 52                       push     rdx
0x000067C4: e8a9930100               call     0x18001fb72
0x000067C9: 85c0                     test     eax, eax
0x000067CB: 0f84e3000000             je       0x1800068b4
0x000067D1: 488d4b18                 lea      rcx, [rbx + 0x18]
0x000067D5: 33d2                     xor      edx, edx
0x000067D7: 41b801010000             mov      r8d, 0x101
0x000067DD: e8eebaffff               call     0x1800022d0
0x000067E2: 897b04                   mov      dword ptr [rbx + 4], edi
0x000067E5: 4889b320020000           mov      qword ptr [rbx + 0x220], rsi
0x000067EC: 44397c2420               cmp      dword ptr [rsp + 0x20], r15d
0x000067F1: 0f86a6000000             jbe      0x18000689d
0x000067F7: 488d542426               lea      rdx, [rsp + 0x26]
0x000067FC: 4038742426               cmp      byte ptr [rsp + 0x26], sil
0x00006801: 7439                     je       0x18000683c
0x00006803: 40387201                 cmp      byte ptr [rdx + 1], sil
0x00006807: 7433                     je       0x18000683c
0x00006809: 0fb67a01                 movzx    edi, byte ptr [rdx + 1]
0x0000680D: 440fb602                 movzx    r8d, byte ptr [rdx]
0x00006811: 443bc7                   cmp      r8d, edi
0x00006814: 771d                     ja       0x180006833
0x00006816: 418d4801                 lea      ecx, [r8 + 1]
0x0000681A: 488d4318                 lea      rax, [rbx + 0x18]
0x0000681E: 4803c1                   add      rax, rcx
0x00006821: 412bf8                   sub      edi, r8d
0x00006824: 418d0c3f                 lea      ecx, [r15 + rdi]
0x00006828: 800804                   or       byte ptr [rax], 4
0x0000682B: 4903c7                   add      rax, r15
0x0000682E: 492bcf                   sub      rcx, r15
0x00006831: 75f5                     jne      0x180006828
0x00006833: 4883c202                 add      rdx, 2
0x00006837: 403832                   cmp      byte ptr [rdx], sil
0x0000683A: 75c7                     jne      0x180006803
0x0000683C: 488d431a                 lea      rax, [rbx + 0x1a]
0x00006840: b9fe000000               mov      ecx, 0xfe
0x00006845: 800808                   or       byte ptr [rax], 8
0x00006848: 4903c7                   add      rax, r15
0x0000684B: 492bcf                   sub      rcx, r15
0x0000684E: 75f5                     jne      0x180006845
0x00006850: 8b4b04                   mov      ecx, dword ptr [rbx + 4]
0x00006853: 81e9a4030000             sub      ecx, 0x3a4
0x00006859: 742e                     je       0x180006889
0x0000685B: 83e904                   sub      ecx, 4
0x0000685E: 7420                     je       0x180006880
0x00006860: 83e90d                   sub      ecx, 0xd
0x00006863: 7412                     je       0x180006877
0x00006865: ffc9                     dec      ecx
0x00006867: 7405                     je       0x18000686e
0x00006869: 488bc6                   mov      rax, rsi
0x0000686C: eb22                     jmp      0x180006890
0x0000686E: 488b052b9b0000           mov      rax, qword ptr [rip + 0x9b2b]
0x00006875: eb19                     jmp      0x180006890
0x00006877: 488b051a9b0000           mov      rax, qword ptr [rip + 0x9b1a]
0x0000687E: eb10                     jmp      0x180006890
0x00006880: 488b05099b0000           mov      rax, qword ptr [rip + 0x9b09]
0x00006887: eb07                     jmp      0x180006890
0x00006889: 488b05f89a0000           mov      rax, qword ptr [rip + 0x9af8]
0x00006890: 48898320020000           mov      qword ptr [rbx + 0x220], rax
0x00006897: 44897b08                 mov      dword ptr [rbx + 8], r15d
0x0000689B: eb03                     jmp      0x1800068a0
0x0000689D: 897308                   mov      dword ptr [rbx + 8], esi
0x000068A0: 488d7b0c                 lea      rdi, [rbx + 0xc]
0x000068A4: 0fb7c6                   movzx    eax, si
0x000068A7: b906000000               mov      ecx, 6
0x000068AC: 66f3ab                   rep stosw word ptr [rdi], ax
0x000068AF: e9fe000000               jmp      0x1800069b2
0x000068B4: 3935a6300100             cmp      dword ptr [rip + 0x130a6], esi
0x000068BA: 0f85a9feffff             jne      0x180006769
0x000068C0: 83c8ff                   or       eax, 0xffffffff
0x000068C3: e9f4000000               jmp      0x1800069bc
0x000068C8: 488d4b18                 lea      rcx, [rbx + 0x18]
0x000068CC: 33d2                     xor      edx, edx
0x000068CE: 41b801010000             mov      r8d, 0x101
0x000068D4: e8f7b9ffff               call     0x1800022d0
0x000068D9: 8bc5                     mov      eax, ebp
0x000068DB: 4d8d4c2410               lea      r9, [r12 + 0x10]
0x000068E0: 4c8d1c40                 lea      r11, [rax + rax*2]
0x000068E4: 4c8d35dd0f0100           lea      r14, [rip + 0x10fdd]
0x000068EB: bd04000000               mov      ebp, 4
0x000068F0: 49c1e304                 shl      r11, 4
0x000068F4: 4d03cb                   add      r9, r11
0x000068F7: 498bd1                   mov      rdx, r9
0x000068FA: 413831                   cmp      byte ptr [r9], sil
0x000068FD: 7440                     je       0x18000693f
0x000068FF: 40387201                 cmp      byte ptr [rdx + 1], sil
0x00006903: 743a                     je       0x18000693f
0x00006905: 440fb602                 movzx    r8d, byte ptr [rdx]
0x00006909: 0fb64201                 movzx    eax, byte ptr [rdx + 1]
0x0000690D: 443bc0                   cmp      r8d, eax
0x00006910: 7724                     ja       0x180006936
0x00006912: 458d5001                 lea      r10d, [r8 + 1]
0x00006916: 4181fa01010000           cmp      r10d, 0x101
0x0000691D: 7317                     jae      0x180006936
0x0000691F: 418a06                   mov      al, byte ptr [r14]
0x00006922: 4503c7                   add      r8d, r15d
0x00006925: 4108441a18               or       byte ptr [r10 + rbx + 0x18], al
0x0000692A: 0fb64201                 movzx    eax, byte ptr [rdx + 1]
0x0000692E: 4503d7                   add      r10d, r15d
0x00006931: 443bc0                   cmp      r8d, eax
0x00006934: 76e0                     jbe      0x180006916
0x00006936: 4883c202                 add      rdx, 2
0x0000693A: 403832                   cmp      byte ptr [rdx], sil
0x0000693D: 75c0                     jne      0x1800068ff
0x0000693F: 4983c108                 add      r9, 8
0x00006943: 4d03f7                   add      r14, r15
0x00006946: 492bef                   sub      rbp, r15
0x00006949: 75ac                     jne      0x1800068f7
0x0000694B: 897b04                   mov      dword ptr [rbx + 4], edi
0x0000694E: 44897b08                 mov      dword ptr [rbx + 8], r15d
0x00006952: 81efa4030000             sub      edi, 0x3a4
0x00006958: 7429                     je       0x180006983
0x0000695A: 83ef04                   sub      edi, 4
0x0000695D: 741b                     je       0x18000697a
0x0000695F: 83ef0d                   sub      edi, 0xd
0x00006962: 740d                     je       0x180006971
0x00006964: ffcf                     dec      edi
0x00006966: 7522                     jne      0x18000698a
0x00006968: 488b35319a0000           mov      rsi, qword ptr [rip + 0x9a31]
0x0000696F: eb19                     jmp      0x18000698a
0x00006971: 488b35209a0000           mov      rsi, qword ptr [rip + 0x9a20]
0x00006978: eb10                     jmp      0x18000698a
0x0000697A: 488b350f9a0000           mov      rsi, qword ptr [rip + 0x9a0f]
0x00006981: eb07                     jmp      0x18000698a
0x00006983: 488b35fe990000           mov      rsi, qword ptr [rip + 0x99fe]
0x0000698A: 4c2bdb                   sub      r11, rbx
0x0000698D: 4889b320020000           mov      qword ptr [rbx + 0x220], rsi
0x00006994: 488d4b0c                 lea      rcx, [rbx + 0xc]
0x00006998: 4b8d3c23                 lea      rdi, [r11 + r12]
0x0000699C: ba06000000               mov      edx, 6
0x000069A1: 0fb7440ff8               movzx    eax, word ptr [rdi + rcx - 8]
0x000069A6: 668901                   mov      word ptr [rcx], ax
0x000069A9: 488d4902                 lea      rcx, [rcx + 2]
0x000069AD: 492bd7                   sub      rdx, r15
0x000069B0: 75ef                     jne      0x1800069a1
0x000069B2: 488bcb                   mov      rcx, rbx
0x000069B5: e896f8ffff               call     0x180006250
0x000069BA: 33c0                     xor      eax, eax
0x000069BC: 488b4c2438               mov      rcx, qword ptr [rsp + 0x38]
0x000069C1: 4833cc                   xor      rcx, rsp
0x000069C4: e847aeffff               call     0x180001810
0x000069C9: 4c8d5c2440               lea      r11, [rsp + 0x40]
0x000069CE: 498b5b40                 mov      rbx, qword ptr [r11 + 0x40]
0x000069D2: 498b6b48                 mov      rbp, qword ptr [r11 + 0x48]
0x000069D6: 498be3                   mov      rsp, r11
0x000069D9: 415f                     pop      r15
0x000069DB: 415e                     pop      r14
0x000069DD: 415c                     pop      r12
0x000069DF: 5f                       pop      rdi
0x000069E0: 5e                       pop      rsi
0x000069E1: c3                       ret      
0x000069E2: cc                       int3     
0x000069E3: cc                       int3     
0x000069E4: cc                       int3     
0x000069E5: cc                       int3     
0x000069E6: cc                       int3     
0x000069E7: cc                       int3     
0x000069E8: cc                       int3     
0x000069E9: cc                       int3     
0x000069EA: cc                       int3     
0x000069EB: cc                       int3     
0x000069EC: cc                       int3     
0x000069ED: cc                       int3     
0x000069EE: cc                       int3     
0x000069EF: cc                       int3     
0x000069F0: cc                       int3     
0x000069F1: cc                       int3     
0x000069F2: cc                       int3     
0x000069F3: cc                       int3     
0x000069F4: cc                       int3     
0x000069F5: cc                       int3     
0x000069F6: 66660f1f840000000000     nop      word ptr [rax + rax]
0x00006A00: 488bc1                   mov      rax, rcx
0x00006A03: 48f7d9                   neg      rcx
0x00006A06: 48a907000000             test     rax, 7
0x00006A0C: 740f                     je       0x180006a1d
0x00006A0E: 6690                     nop      
0x00006A10: 8a10                     mov      dl, byte ptr [rax]
0x00006A12: 48ffc0                   inc      rax
0x00006A15: 84d2                     test     dl, dl
0x00006A17: 745f                     je       0x180006a78
0x00006A19: a807                     test     al, 7
0x00006A1B: 75f3                     jne      0x180006a10
0x00006A1D: 49b8fffefefefefefe7e     movabs   r8, 0x7efefefefefefeff
0x00006A27: 49bb0001010101010181     movabs   r11, 0x8101010101010100
0x00006A31: 488b10                   mov      rdx, qword ptr [rax]
0x00006A34: 4d8bc8                   mov      r9, r8
0x00006A37: 4883c008                 add      rax, 8
0x00006A3B: 4c03ca                   add      r9, rdx
0x00006A3E: 48f7d2                   not      rdx
0x00006A41: 4933d1                   xor      rdx, r9
0x00006A44: 4923d3                   and      rdx, r11
0x00006A47: 74e8                     je       0x180006a31
0x00006A49: 488b50f8                 mov      rdx, qword ptr [rax - 8]
0x00006A4D: 84d2                     test     dl, dl
0x00006A4F: 7451                     je       0x180006aa2
0x00006A51: 84f6                     test     dh, dh
0x00006A53: 7447                     je       0x180006a9c
0x00006A55: 48c1ea10                 shr      rdx, 0x10
0x00006A59: 84d2                     test     dl, dl
0x00006A5B: 7439                     je       0x180006a96
0x00006A5D: 84f6                     test     dh, dh
0x00006A5F: 742f                     je       0x180006a90
0x00006A61: 48c1ea10                 shr      rdx, 0x10
0x00006A65: 84d2                     test     dl, dl
0x00006A67: 7421                     je       0x180006a8a
0x00006A69: 84f6                     test     dh, dh
0x00006A6B: 7417                     je       0x180006a84
0x00006A6D: c1ea10                   shr      edx, 0x10
0x00006A70: 84d2                     test     dl, dl
0x00006A72: 740a                     je       0x180006a7e
0x00006A74: 84f6                     test     dh, dh
0x00006A76: 75b9                     jne      0x180006a31
0x00006A78: 488d4401ff               lea      rax, [rcx + rax - 1]
0x00006A7D: c3                       ret      
0x00006A7E: 488d4401fe               lea      rax, [rcx + rax - 2]
0x00006A83: c3                       ret      
0x00006A84: 488d4401fd               lea      rax, [rcx + rax - 3]
0x00006A89: c3                       ret      
0x00006A8A: 488d4401fc               lea      rax, [rcx + rax - 4]
0x00006A8F: c3                       ret      
0x00006A90: 488d4401fb               lea      rax, [rcx + rax - 5]
0x00006A95: c3                       ret      
0x00006A96: 488d4401fa               lea      rax, [rcx + rax - 6]
0x00006A9B: c3                       ret      
0x00006A9C: 488d4401f9               lea      rax, [rcx + rax - 7]
0x00006AA1: c3                       ret      
0x00006AA2: 488d4401f8               lea      rax, [rcx + rax - 8]
0x00006AA7: c3                       ret      
0x00006AA8: 4053                     push     rbx
0x00006AAA: 4883ec20                 sub      rsp, 0x20
0x00006AAE: 4533d2                   xor      r10d, r10d
0x00006AB1: 4c8bc9                   mov      r9, rcx
0x00006AB4: 4885c9                   test     rcx, rcx
0x00006AB7: 740e                     je       0x180006ac7
0x00006AB9: 4885d2                   test     rdx, rdx
0x00006ABC: 7409                     je       0x180006ac7
0x00006ABE: 4d85c0                   test     r8, r8
0x00006AC1: 751d                     jne      0x180006ae0
0x00006AC3: 66448911                 mov      word ptr [rcx], r10w
0x00006AC7: e8c0bbffff               call     0x18000268c
0x00006ACC: bb16000000               mov      ebx, 0x16
0x00006AD1: 8918                     mov      dword ptr [rax], ebx
0x00006AD3: e8cccdffff               call     0x1800038a4
0x00006AD8: 8bc3                     mov      eax, ebx
0x00006ADA: 4883c420                 add      rsp, 0x20
0x00006ADE: 5b                       pop      rbx
0x00006ADF: c3                       ret      
0x00006AE0: 66443911                 cmp      word ptr [rcx], r10w
0x00006AE4: 7409                     je       0x180006aef
0x00006AE6: 4883c102                 add      rcx, 2
0x00006AEA: 48ffca                   dec      rdx
0x00006AED: 75f1                     jne      0x180006ae0
0x00006AEF: 4885d2                   test     rdx, rdx
0x00006AF2: 7506                     jne      0x180006afa
0x00006AF4: 66458911                 mov      word ptr [r9], r10w
0x00006AF8: ebcd                     jmp      0x180006ac7
0x00006AFA: 492bc8                   sub      rcx, r8
0x00006AFD: 410fb700                 movzx    eax, word ptr [r8]
0x00006B01: 6642890401               mov      word ptr [rcx + r8], ax
0x00006B06: 4d8d4002                 lea      r8, [r8 + 2]
0x00006B0A: 6685c0                   test     ax, ax
0x00006B0D: 7405                     je       0x180006b14
0x00006B0F: 48ffca                   dec      rdx
0x00006B12: 75e9                     jne      0x180006afd
0x00006B14: 4885d2                   test     rdx, rdx
0x00006B17: 7510                     jne      0x180006b29
0x00006B19: 66458911                 mov      word ptr [r9], r10w
0x00006B1D: e86abbffff               call     0x18000268c
0x00006B22: bb22000000               mov      ebx, 0x22
0x00006B27: eba8                     jmp      0x180006ad1
0x00006B29: 33c0                     xor      eax, eax
0x00006B2B: ebad                     jmp      0x180006ada
0x00006B2D: cc                       int3     
0x00006B2E: cc                       int3     
0x00006B2F: cc                       int3     
0x00006B30: 4053                     push     rbx
0x00006B32: 4883ec20                 sub      rsp, 0x20
0x00006B36: 4533d2                   xor      r10d, r10d
0x00006B39: 4885c9                   test     rcx, rcx
0x00006B3C: 740e                     je       0x180006b4c
0x00006B3E: 4885d2                   test     rdx, rdx
0x00006B41: 7409                     je       0x180006b4c
0x00006B43: 4d85c0                   test     r8, r8
0x00006B46: 751d                     jne      0x180006b65
0x00006B48: 66448911                 mov      word ptr [rcx], r10w
0x00006B4C: e83bbbffff               call     0x18000268c
0x00006B51: bb16000000               mov      ebx, 0x16
0x00006B56: 8918                     mov      dword ptr [rax], ebx
0x00006B58: e847cdffff               call     0x1800038a4
0x00006B5D: 8bc3                     mov      eax, ebx
0x00006B5F: 4883c420                 add      rsp, 0x20
0x00006B63: 5b                       pop      rbx
0x00006B64: c3                       ret      
0x00006B65: 4c8bc9                   mov      r9, rcx
0x00006B68: 4d2bc8                   sub      r9, r8
0x00006B6B: 410fb700                 movzx    eax, word ptr [r8]
0x00006B6F: 6643890401               mov      word ptr [r9 + r8], ax
0x00006B74: 4d8d4002                 lea      r8, [r8 + 2]
0x00006B78: 6685c0                   test     ax, ax
0x00006B7B: 7405                     je       0x180006b82
0x00006B7D: 48ffca                   dec      rdx
0x00006B80: 75e9                     jne      0x180006b6b
0x00006B82: 4885d2                   test     rdx, rdx
0x00006B85: 7510                     jne      0x180006b97
0x00006B87: 66448911                 mov      word ptr [rcx], r10w
0x00006B8B: e8fcbaffff               call     0x18000268c
0x00006B90: bb22000000               mov      ebx, 0x22
0x00006B95: ebbf                     jmp      0x180006b56
0x00006B97: 33c0                     xor      eax, eax
0x00006B99: ebc4                     jmp      0x180006b5f
0x00006B9B: cc                       int3     
0x00006B9C: 488bc1                   mov      rax, rcx
0x00006B9F: 0fb710                   movzx    edx, word ptr [rax]
0x00006BA2: 4883c002                 add      rax, 2
0x00006BA6: 6685d2                   test     dx, dx
0x00006BA9: 75f4                     jne      0x180006b9f
0x00006BAB: 482bc1                   sub      rax, rcx
0x00006BAE: 48d1f8                   sar      rax, 1
0x00006BB1: 48ffc8                   dec      rax
0x00006BB4: c3                       ret      
0x00006BB5: cc                       int3     
0x00006BB6: cc                       int3     
0x00006BB7: cc                       int3     
0x00006BB8: 4053                     push     rbx
0x00006BBA: 4883ec20                 sub      rsp, 0x20
0x00006BBE: 33db                     xor      ebx, ebx
0x00006BC0: 4d85c9                   test     r9, r9
0x00006BC3: 750e                     jne      0x180006bd3
0x00006BC5: 4885c9                   test     rcx, rcx
0x00006BC8: 750e                     jne      0x180006bd8
0x00006BCA: 4885d2                   test     rdx, rdx
0x00006BCD: 7520                     jne      0x180006bef
0x00006BCF: 33c0                     xor      eax, eax
0x00006BD1: eb2f                     jmp      0x180006c02
0x00006BD3: 4885c9                   test     rcx, rcx
0x00006BD6: 7417                     je       0x180006bef
0x00006BD8: 4885d2                   test     rdx, rdx
0x00006BDB: 7412                     je       0x180006bef
0x00006BDD: 4d85c9                   test     r9, r9
0x00006BE0: 7505                     jne      0x180006be7
0x00006BE2: 668919                   mov      word ptr [rcx], bx
0x00006BE5: ebe8                     jmp      0x180006bcf
0x00006BE7: 4d85c0                   test     r8, r8
0x00006BEA: 751c                     jne      0x180006c08
0x00006BEC: 668919                   mov      word ptr [rcx], bx
0x00006BEF: e898baffff               call     0x18000268c
0x00006BF4: bb16000000               mov      ebx, 0x16
0x00006BF9: 8918                     mov      dword ptr [rax], ebx
0x00006BFB: e8a4ccffff               call     0x1800038a4
0x00006C00: 8bc3                     mov      eax, ebx
0x00006C02: 4883c420                 add      rsp, 0x20
0x00006C06: 5b                       pop      rbx
0x00006C07: c3                       ret      
0x00006C08: 4c8bd9                   mov      r11, rcx
0x00006C0B: 4c8bd2                   mov      r10, rdx
0x00006C0E: 4983f9ff                 cmp      r9, -1
0x00006C12: 751c                     jne      0x180006c30
0x00006C14: 4d2bd8                   sub      r11, r8
0x00006C17: 410fb700                 movzx    eax, word ptr [r8]
0x00006C1B: 6643890403               mov      word ptr [r11 + r8], ax
0x00006C20: 4d8d4002                 lea      r8, [r8 + 2]
0x00006C24: 6685c0                   test     ax, ax
0x00006C27: 742f                     je       0x180006c58
0x00006C29: 49ffca                   dec      r10
0x00006C2C: 75e9                     jne      0x180006c17
0x00006C2E: eb28                     jmp      0x180006c58
0x00006C30: 4c2bc1                   sub      r8, rcx
0x00006C33: 430fb70418               movzx    eax, word ptr [r8 + r11]
0x00006C38: 66418903                 mov      word ptr [r11], ax
0x00006C3C: 4d8d5b02                 lea      r11, [r11 + 2]
0x00006C40: 6685c0                   test     ax, ax
0x00006C43: 740a                     je       0x180006c4f
0x00006C45: 49ffca                   dec      r10
0x00006C48: 7405                     je       0x180006c4f
0x00006C4A: 49ffc9                   dec      r9
0x00006C4D: 75e4                     jne      0x180006c33
0x00006C4F: 4d85c9                   test     r9, r9
0x00006C52: 7504                     jne      0x180006c58
0x00006C54: 6641891b                 mov      word ptr [r11], bx
0x00006C58: 4d85d2                   test     r10, r10
0x00006C5B: 0f856effffff             jne      0x180006bcf
0x00006C61: 4983f9ff                 cmp      r9, -1
0x00006C65: 750b                     jne      0x180006c72
0x00006C67: 66895c51fe               mov      word ptr [rcx + rdx*2 - 2], bx
0x00006C6C: 418d4250                 lea      eax, [r10 + 0x50]
0x00006C70: eb90                     jmp      0x180006c02
0x00006C72: 668919                   mov      word ptr [rcx], bx
0x00006C75: e812baffff               call     0x18000268c
0x00006C7A: bb22000000               mov      ebx, 0x22
0x00006C7F: e975ffffff               jmp      0x180006bf9
0x00006C84: 4883ec28                 sub      rsp, 0x28
0x00006C88: 85c9                     test     ecx, ecx
0x00006C8A: 7820                     js       0x180006cac
0x00006C8C: 83f902                   cmp      ecx, 2
0x00006C8F: 7e0d                     jle      0x180006c9e
0x00006C91: 83f903                   cmp      ecx, 3
0x00006C94: 7516                     jne      0x180006cac
0x00006C96: 8b05dc2c0100             mov      eax, dword ptr [rip + 0x12cdc]
0x00006C9C: eb21                     jmp      0x180006cbf
0x00006C9E: 8b05d42c0100             mov      eax, dword ptr [rip + 0x12cd4]
0x00006CA4: 890dce2c0100             mov      dword ptr [rip + 0x12cce], ecx
0x00006CAA: eb13                     jmp      0x180006cbf
0x00006CAC: e8dbb9ffff               call     0x18000268c
0x00006CB1: c70016000000             mov      dword ptr [rax], 0x16
0x00006CB7: e8e8cbffff               call     0x1800038a4
0x00006CBC: 83c8ff                   or       eax, 0xffffffff
0x00006CBF: 4883c428                 add      rsp, 0x28
0x00006CC3: c3                       ret      
0x00006CC4: 4053                     push     rbx
0x00006CC6: 55                       push     rbp
0x00006CC7: 56                       push     rsi
0x00006CC8: 57                       push     rdi
0x00006CC9: 4154                     push     r12
0x00006CCB: 4156                     push     r14
0x00006CCD: 4157                     push     r15
0x00006CCF: 4883ec50                 sub      rsp, 0x50
0x00006CD3: 488b0526030100           mov      rax, qword ptr [rip + 0x10326]
0x00006CDA: 4833c4                   xor      rax, rsp
0x00006CDD: 4889442448               mov      qword ptr [rsp + 0x48], rax
0x00006CE2: 4c8bf9                   mov      r15, rcx
0x00006CE5: 33c9                     xor      ecx, ecx
0x00006CE7: 418be8                   mov      ebp, r8d
0x00006CEA: 4c8be2                   mov      r12, rdx
0x00006CED: 52                       push     rdx
0x00006CEE: e82ae20100               call     0x180024f1d
0x00006CF3: 33ff                     xor      edi, edi
0x00006CF5: 488bf0                   mov      rsi, rax
0x00006CF8: e84fe2ffff               call     0x180004f4c
0x00006CFD: 48393d7c2c0100           cmp      qword ptr [rip + 0x12c7c], rdi
0x00006D04: 448bf0                   mov      r14d, eax
0x00006D07: 0f85f8000000             jne      0x180006e05
0x00006D0D: 488d0dd4960000           lea      rcx, [rip + 0x96d4]
0x00006D14: 33d2                     xor      edx, edx
0x00006D16: 41b800080000             mov      r8d, 0x800
0x00006D1C: e8af650200               call     0x18002d2d0
0x00006D21: fb                       sti      
0x00006D22: 488bd8                   mov      rbx, rax
0x00006D25: 4885c0                   test     rax, rax
0x00006D28: 752d                     jne      0x180006d57
0x00006D2A: e81bd30300               call     0x18004404a
0x00006D2F: 1083f8570f85             adc      byte ptr [rbx - 0x7af0a808], al
0x00006D35: e001                     loopne   0x180006d38
0x00006D37: 0000                     add      byte ptr [rax], al
0x00006D39: 488d0da8960000           lea      rcx, [rip + 0x96a8]
0x00006D40: 4533c0                   xor      r8d, r8d
0x00006D43: 33d2                     xor      edx, edx
0x00006D45: 55                       push     rbp
0x00006D46: e845650200               call     0x18002d290
0x00006D4B: 488bd8                   mov      rbx, rax
0x00006D4E: 4885c0                   test     rax, rax
0x00006D51: 0f84c2010000             je       0x180006f19
0x00006D57: 488d15a2960000           lea      rdx, [rip + 0x96a2]
0x00006D5E: 488bcb                   mov      rcx, rbx
0x00006D61: 52                       push     rdx
0x00006D62: e828ad0b00               call     0x1800c1a8f
0x00006D67: 4885c0                   test     rax, rax
0x00006D6A: 0f84a9010000             je       0x180006f19
0x00006D70: 488bc8                   mov      rcx, rax
0x00006D73: e8c9cd1600               call     0x180173b41
0x00006D78: 62                       .byte    0x62
0x00006D79: 488d1590960000           lea      rdx, [rip + 0x9690]
0x00006D80: 488bcb                   mov      rcx, rbx
0x00006D83: 488905f62b0100           mov      qword ptr [rip + 0x12bf6], rax
0x00006D8A: 51                       push     rcx
0x00006D8B: e8c5472300               call     0x18023b555
0x00006D90: 488bc8                   mov      rcx, rax
0x00006D93: 50                       push     rax
0x00006D94: e800492200               call     0x18022b699
0x00006D99: 488d1580960000           lea      rdx, [rip + 0x9680]
0x00006DA0: 488bcb                   mov      rcx, rbx
0x00006DA3: 488905de2b0100           mov      qword ptr [rip + 0x12bde], rax
0x00006DAA: 53                       push     rbx
0x00006DAB: e88fa5ffff               call     0x18000133f
0x00006DB0: 488bc8                   mov      rcx, rax
0x00006DB3: e8a5941e00               call     0x1801f025d
0x00006DB8: ad                       lodsd    eax, dword ptr [rsi]
0x00006DB9: 488d1578960000           lea      rdx, [rip + 0x9678]
0x00006DC0: 488bcb                   mov      rcx, rbx
0x00006DC3: 488905c62b0100           mov      qword ptr [rip + 0x12bc6], rax
0x00006DCA: e870d52100               call     0x18022433f
0x00006DCF: 35488bc857               xor      eax, 0x57c88b48
0x00006DD4: e82f0e2600               call     0x180267c08
0x00006DD9: 488905c02b0100           mov      qword ptr [rip + 0x12bc0], rax
0x00006DE0: 4885c0                   test     rax, rax
0x00006DE3: 7420                     je       0x180006e05
0x00006DE5: 488d156c960000           lea      rdx, [rip + 0x966c]
0x00006DEC: 488bcb                   mov      rcx, rbx
0x00006DEF: 52                       push     rdx
0x00006DF0: e8b8122500               call     0x1802580ad
0x00006DF5: 488bc8                   mov      rcx, rax
0x00006DF8: e8b1c11100               call     0x180122fae
0x00006DFD: d14889                   ror      dword ptr [rax - 0x77], 1
0x00006E00: 05932b0100               add      eax, 0x12b93
0x00006E05: 56                       push     rsi
0x00006E06: e80d4d1f00               call     0x1801fbb18
0x00006E0B: 85c0                     test     eax, eax
0x00006E0D: 741d                     je       0x180006e2c
0x00006E0F: 4d85ff                   test     r15, r15
0x00006E12: 7409                     je       0x180006e1d
0x00006E14: 498bcf                   mov      rcx, r15
0x00006E17: e856b40c00               call     0x1800d2272
0x00006E1C: 104585                   adc      byte ptr [rbp - 0x7b], al
0x00006E1F: f67426b8                 div      byte ptr [rsi + riz - 0x48]
0x00006E23: 0400                     add      al, 0
0x00006E25: 0000                     add      byte ptr [rax], al
0x00006E27: e9ef000000               jmp      0x180006f1b
0x00006E2C: 4585f6                   test     r14d, r14d
0x00006E2F: 7417                     je       0x180006e48
0x00006E31: 488b0d482b0100           mov      rcx, qword ptr [rip + 0x12b48]
0x00006E38: 55                       push     rbp
0x00006E39: e802141f00               call     0x1801f8240
0x00006E3E: b803000000               mov      eax, 3
0x00006E43: e9d3000000               jmp      0x180006f1b
0x00006E48: 488b0d492b0100           mov      rcx, qword ptr [rip + 0x12b49]
0x00006E4F: 483bce                   cmp      rcx, rsi
0x00006E52: 7463                     je       0x180006eb7
0x00006E54: 483935452b0100           cmp      qword ptr [rip + 0x12b45], rsi
0x00006E5B: 745a                     je       0x180006eb7
0x00006E5D: 56                       push     rsi
0x00006E5E: e81f161f00               call     0x1801f8482
0x00006E63: 488b0d362b0100           mov      rcx, qword ptr [rip + 0x12b36]
0x00006E6A: 488bd8                   mov      rbx, rax
0x00006E6D: 52                       push     rdx
0x00006E6E: e8da481800               call     0x18018b74d
0x00006E73: 4c8bf0                   mov      r14, rax
0x00006E76: 4885db                   test     rbx, rbx
0x00006E79: 743c                     je       0x180006eb7
0x00006E7B: 4885c0                   test     rax, rax
0x00006E7E: 7437                     je       0x180006eb7
0x00006E80: ffd3                     call     rbx
0x00006E82: 4885c0                   test     rax, rax
0x00006E85: 742a                     je       0x180006eb1
0x00006E87: 488d4c2430               lea      rcx, [rsp + 0x30]
0x00006E8C: 41b90c000000             mov      r9d, 0xc
0x00006E92: 4c8d442438               lea      r8, [rsp + 0x38]
0x00006E97: 48894c2420               mov      qword ptr [rsp + 0x20], rcx
0x00006E9C: 418d51f5                 lea      edx, [r9 - 0xb]
0x00006EA0: 488bc8                   mov      rcx, rax
0x00006EA3: 41ffd6                   call     r14
0x00006EA6: 85c0                     test     eax, eax
0x00006EA8: 7407                     je       0x180006eb1
0x00006EAA: f644244001               test     byte ptr [rsp + 0x40], 1
0x00006EAF: 7506                     jne      0x180006eb7
0x00006EB1: 0fbaed15                 bts      ebp, 0x15
0x00006EB5: eb40                     jmp      0x180006ef7
0x00006EB7: 488b0dca2a0100           mov      rcx, qword ptr [rip + 0x12aca]
0x00006EBE: 483bce                   cmp      rcx, rsi
0x00006EC1: 7434                     je       0x180006ef7
0x00006EC3: 55                       push     rbp
0x00006EC4: e8941b2300               call     0x180238a5d
0x00006EC9: 4885c0                   test     rax, rax
0x00006ECC: 7429                     je       0x180006ef7
0x00006ECE: ffd0                     call     rax
0x00006ED0: 488bf8                   mov      rdi, rax
0x00006ED3: 4885c0                   test     rax, rax
0x00006ED6: 741f                     je       0x180006ef7
0x00006ED8: 488b0db12a0100           mov      rcx, qword ptr [rip + 0x12ab1]
0x00006EDF: 483bce                   cmp      rcx, rsi
0x00006EE2: 7413                     je       0x180006ef7
0x00006EE4: 52                       push     rdx
0x00006EE5: e840511b00               call     0x1801bc02a
0x00006EEA: 4885c0                   test     rax, rax
0x00006EED: 7408                     je       0x180006ef7
0x00006EEF: 488bcf                   mov      rcx, rdi
0x00006EF2: ffd0                     call     rax
0x00006EF4: 488bf8                   mov      rdi, rax
0x00006EF7: 488b0d822a0100           mov      rcx, qword ptr [rip + 0x12a82]
0x00006EFE: e8bc1f0e00               call     0x1800e8ebf
0x00006F03: 0e                       .byte    0x0e
0x00006F04: 4885c0                   test     rax, rax
0x00006F07: 7410                     je       0x180006f19
0x00006F09: 448bcd                   mov      r9d, ebp
0x00006F0C: 4d8bc4                   mov      r8, r12
0x00006F0F: 498bd7                   mov      rdx, r15
0x00006F12: 488bcf                   mov      rcx, rdi
0x00006F15: ffd0                     call     rax
0x00006F17: eb02                     jmp      0x180006f1b
0x00006F19: 33c0                     xor      eax, eax
0x00006F1B: 488b4c2448               mov      rcx, qword ptr [rsp + 0x48]
0x00006F20: 4833cc                   xor      rcx, rsp
0x00006F23: e8e8a8ffff               call     0x180001810
0x00006F28: 4883c450                 add      rsp, 0x50
0x00006F2C: 415f                     pop      r15
0x00006F2E: 415e                     pop      r14
0x00006F30: 415c                     pop      r12
0x00006F32: 5f                       pop      rdi
0x00006F33: 5e                       pop      rsi
0x00006F34: 5d                       pop      rbp
0x00006F35: 5b                       pop      rbx
0x00006F36: c3                       ret      
0x00006F37: cc                       int3     
0x00006F38: 48895c2408               mov      qword ptr [rsp + 8], rbx
0x00006F3D: 57                       push     rdi
0x00006F3E: 4883ec20                 sub      rsp, 0x20
0x00006F42: 498bf8                   mov      rdi, r8
0x00006F45: 488bda                   mov      rbx, rdx
0x00006F48: 4885c9                   test     rcx, rcx
0x00006F4B: 741d                     je       0x180006f6a
0x00006F4D: 33d2                     xor      edx, edx
0x00006F4F: 488d42e0                 lea      rax, [rdx - 0x20]
0x00006F53: 48f7f1                   div      rcx
0x00006F56: 483bc3                   cmp      rax, rbx
0x00006F59: 730f                     jae      0x180006f6a
0x00006F5B: e82cb7ffff               call     0x18000268c
0x00006F60: c7000c000000             mov      dword ptr [rax], 0xc
0x00006F66: 33c0                     xor      eax, eax
0x00006F68: eb5d                     jmp      0x180006fc7
0x00006F6A: 480fafd9                 imul     rbx, rcx
0x00006F6E: b801000000               mov      eax, 1
0x00006F73: 4885db                   test     rbx, rbx
0x00006F76: 480f44d8                 cmove    rbx, rax
0x00006F7A: 33c0                     xor      eax, eax
0x00006F7C: 4883fbe0                 cmp      rbx, -0x20
0x00006F80: 7718                     ja       0x180006f9a
0x00006F82: 488b0d6f1d0100           mov      rcx, qword ptr [rip + 0x11d6f]
0x00006F89: 8d5008                   lea      edx, [rax + 8]
0x00006F8C: 4c8bc3                   mov      r8, rbx
0x00006F8F: 57                       push     rdi
0x00006F90: e834371e00               call     0x1801ea6c9
0x00006F95: 4885c0                   test     rax, rax
0x00006F98: 752d                     jne      0x180006fc7
0x00006F9A: 833df723010000           cmp      dword ptr [rip + 0x123f7], 0
0x00006FA1: 7419                     je       0x180006fbc
0x00006FA3: 488bcb                   mov      rcx, rbx
0x00006FA6: e87db7ffff               call     0x180002728
0x00006FAB: 85c0                     test     eax, eax
0x00006FAD: 75cb                     jne      0x180006f7a
0x00006FAF: 4885ff                   test     rdi, rdi
0x00006FB2: 74b2                     je       0x180006f66
0x00006FB4: c7070c000000             mov      dword ptr [rdi], 0xc
0x00006FBA: ebaa                     jmp      0x180006f66
0x00006FBC: 4885ff                   test     rdi, rdi
0x00006FBF: 7406                     je       0x180006fc7
0x00006FC1: c7070c000000             mov      dword ptr [rdi], 0xc
0x00006FC7: 488b5c2430               mov      rbx, qword ptr [rsp + 0x30]
0x00006FCC: 4883c420                 add      rsp, 0x20
0x00006FD0: 5f                       pop      rdi
0x00006FD1: c3                       ret      
0x00006FD2: cc                       int3     
0x00006FD3: cc                       int3     
0x00006FD4: cc                       int3     
0x00006FD5: cc                       int3     
0x00006FD6: cc                       int3     
0x00006FD7: cc                       int3     
0x00006FD8: cc                       int3     
0x00006FD9: cc                       int3     
0x00006FDA: cc                       int3     
0x00006FDB: cc                       int3     
0x00006FDC: cc                       int3     
0x00006FDD: cc                       int3     
0x00006FDE: cc                       int3     
0x00006FDF: cc                       int3     
0x00006FE0: cc                       int3     
0x00006FE1: cc                       int3     
0x00006FE2: cc                       int3     
0x00006FE3: cc                       int3     
0x00006FE4: cc                       int3     
0x00006FE5: cc                       int3     
0x00006FE6: 66660f1f840000000000     nop      word ptr [rax + rax]
0x00006FF0: 4881ecd8040000           sub      rsp, 0x4d8
0x00006FF7: 4d33c0                   xor      r8, r8
0x00006FFA: 4d33c9                   xor      r9, r9
0x00006FFD: 4889642420               mov      qword ptr [rsp + 0x20], rsp
0x00007002: 4c89442428               mov      qword ptr [rsp + 0x28], r8
0x00007007: e8f27b0000               call     0x18000ebfe
0x0000700C: 4881c4d8040000           add      rsp, 0x4d8
0x00007013: c3                       ret      
0x00007014: cc                       int3     
0x00007015: cc                       int3     
0x00007016: cc                       int3     
0x00007017: cc                       int3     
0x00007018: cc                       int3     
0x00007019: cc                       int3     
0x0000701A: 660f1f440000             nop      word ptr [rax + rax]
0x00007020: 48894c2408               mov      qword ptr [rsp + 8], rcx
0x00007025: 4889542418               mov      qword ptr [rsp + 0x18], rdx
0x0000702A: 4489442410               mov      dword ptr [rsp + 0x10], r8d
0x0000702F: 49c7c120059319           mov      r9, 0x19930520
0x00007036: eb08                     jmp      0x180007040
0x00007038: cc                       int3     
0x00007039: cc                       int3     
0x0000703A: cc                       int3     
0x0000703B: cc                       int3     
0x0000703C: cc                       int3     
0x0000703D: cc                       int3     
0x0000703E: 6690                     nop      
0x00007040: c3                       ret      
0x00007041: cc                       int3     
0x00007042: cc                       int3     
0x00007043: cc                       int3     
0x00007044: cc                       int3     
0x00007045: cc                       int3     
0x00007046: cc                       int3     
0x00007047: 660f1f840000000000       nop      word ptr [rax + rax]
0x00007050: c3                       ret      
0x00007051: cc                       int3     
0x00007052: cc                       int3     
0x00007053: cc                       int3     
0x00007054: 488d0579090100           lea      rax, [rip + 0x10979]
0x0000705B: c3                       ret      
0x0000705C: 488d0575090100           lea      rax, [rip + 0x10975]
0x00007063: c3                       ret      
0x00007064: 488d0565090100           lea      rax, [rip + 0x10965]
0x0000706B: c3                       ret      
0x0000706C: 488d05ed090100           lea      rax, [rip + 0x109ed]
0x00007073: c3                       ret      
0x00007074: 4883ec28                 sub      rsp, 0x28
0x00007078: 4885c9                   test     rcx, rcx
0x0000707B: 7517                     jne      0x180007094
0x0000707D: e80ab6ffff               call     0x18000268c
0x00007082: c70016000000             mov      dword ptr [rax], 0x16
0x00007088: e817c8ffff               call     0x1800038a4
0x0000708D: b816000000               mov      eax, 0x16
0x00007092: eb0a                     jmp      0x18000709e
0x00007094: 8b053a090100             mov      eax, dword ptr [rip + 0x1093a]
0x0000709A: 8901                     mov      dword ptr [rcx], eax
0x0000709C: 33c0                     xor      eax, eax
0x0000709E: 4883c428                 add      rsp, 0x28
0x000070A2: c3                       ret      
0x000070A3: cc                       int3     
0x000070A4: 4883ec28                 sub      rsp, 0x28
0x000070A8: 4885c9                   test     rcx, rcx
0x000070AB: 7517                     jne      0x1800070c4
0x000070AD: e8dab5ffff               call     0x18000268c
0x000070B2: c70016000000             mov      dword ptr [rax], 0x16
0x000070B8: e8e7c7ffff               call     0x1800038a4
0x000070BD: b816000000               mov      eax, 0x16
0x000070C2: eb0a                     jmp      0x1800070ce
0x000070C4: 8b050e090100             mov      eax, dword ptr [rip + 0x1090e]
0x000070CA: 8901                     mov      dword ptr [rcx], eax
0x000070CC: 33c0                     xor      eax, eax
0x000070CE: 4883c428                 add      rsp, 0x28
0x000070D2: c3                       ret      
0x000070D3: cc                       int3     
0x000070D4: 4883ec28                 sub      rsp, 0x28
0x000070D8: 4885c9                   test     rcx, rcx
0x000070DB: 7517                     jne      0x1800070f4
0x000070DD: e8aab5ffff               call     0x18000268c
0x000070E2: c70016000000             mov      dword ptr [rax], 0x16
0x000070E8: e8b7c7ffff               call     0x1800038a4
0x000070ED: b816000000               mov      eax, 0x16
0x000070F2: eb0a                     jmp      0x1800070fe
0x000070F4: 8b05d6080100             mov      eax, dword ptr [rip + 0x108d6]
0x000070FA: 8901                     mov      dword ptr [rcx], eax
0x000070FC: 33c0                     xor      eax, eax
0x000070FE: 4883c428                 add      rsp, 0x28
0x00007102: c3                       ret      
0x00007103: cc                       int3     
0x00007104: 4883ec28                 sub      rsp, 0x28
0x00007108: 833da928010000           cmp      dword ptr [rip + 0x128a9], 0
0x0000710F: 7529                     jne      0x18000713a
0x00007111: b906000000               mov      ecx, 6
0x00007116: e885e9ffff               call     0x180005aa0
0x0000711B: 90                       nop      
0x0000711C: 833d9528010000           cmp      dword ptr [rip + 0x12895], 0
0x00007123: 750b                     jne      0x180007130
0x00007125: e8f6020000               call     0x180007420
0x0000712A: ff0588280100             inc      dword ptr [rip + 0x12888]
0x00007130: b906000000               mov      ecx, 6
0x00007135: e856ebffff               call     0x180005c90
0x0000713A: 4883c428                 add      rsp, 0x28
0x0000713E: c3                       ret      
0x0000713F: cc                       int3     
0x00007140: 4053                     push     rbx
0x00007142: 4883ec20                 sub      rsp, 0x20
0x00007146: 488bd9                   mov      rbx, rcx
0x00007149: b906000000               mov      ecx, 6
0x0000714E: e84de9ffff               call     0x180005aa0
0x00007153: 90                       nop      
0x00007154: 488bcb                   mov      rcx, rbx
0x00007157: e814000000               call     0x180007170
0x0000715C: 8bd8                     mov      ebx, eax
0x0000715E: b906000000               mov      ecx, 6
0x00007163: e828ebffff               call     0x180005c90
0x00007168: 8bc3                     mov      eax, ebx
0x0000716A: 4883c420                 add      rsp, 0x20
0x0000716E: 5b                       pop      rbx
0x0000716F: c3                       ret      
0x00007170: 488bc4                   mov      rax, rsp
0x00007173: 48895808                 mov      qword ptr [rax + 8], rbx
0x00007177: 48896818                 mov      qword ptr [rax + 0x18], rbp
0x0000717B: 48897020                 mov      qword ptr [rax + 0x20], rsi
0x0000717F: 57                       push     rdi
0x00007180: 4156                     push     r14
0x00007182: 4157                     push     r15
0x00007184: 4883ec60                 sub      rsp, 0x60
0x00007188: 488bf1                   mov      rsi, rcx
0x0000718B: 488d4810                 lea      rcx, [rax + 0x10]
0x0000718F: 33ff                     xor      edi, edi
0x00007191: 897810                   mov      dword ptr [rax + 0x10], edi
0x00007194: e8dbfeffff               call     0x180007074
0x00007199: 85c0                     test     eax, eax
0x0000719B: 0f8567020000             jne      0x180007408
0x000071A1: 39bc2488000000           cmp      dword ptr [rsp + 0x88], edi
0x000071A8: 751c                     jne      0x1800071c6
0x000071AA: 33c0                     xor      eax, eax
0x000071AC: 4c8d5c2460               lea      r11, [rsp + 0x60]
0x000071B1: 498b5b20                 mov      rbx, qword ptr [r11 + 0x20]
0x000071B5: 498b6b30                 mov      rbp, qword ptr [r11 + 0x30]
0x000071B9: 498b7338                 mov      rsi, qword ptr [r11 + 0x38]
0x000071BD: 498be3                   mov      rsp, r11
0x000071C0: 415f                     pop      r15
0x000071C2: 415e                     pop      r14
0x000071C4: 5f                       pop      rdi
0x000071C5: c3                       ret      
0x000071C6: 8b6e14                   mov      ebp, dword ptr [rsi + 0x14]
0x000071C9: 41bf01000000             mov      r15d, 1
0x000071CF: 3b2d9b080100             cmp      ebp, dword ptr [rip + 0x1089b]
0x000071D5: 750c                     jne      0x1800071e3
0x000071D7: 3b2da3080100             cmp      ebp, dword ptr [rip + 0x108a3]
0x000071DD: 0f849f010000             je       0x180007382
0x000071E3: 393dd3270100             cmp      dword ptr [rip + 0x127d3], edi
0x000071E9: 0f8410010000             je       0x1800072ff
0x000071EF: 66393d62280100           cmp      word ptr [rip + 0x12862], di
0x000071F6: 0fb70d67280100           movzx    ecx, word ptr [rip + 0x12867]
0x000071FD: 0fb70562280100           movzx    eax, word ptr [rip + 0x12862]
0x00007204: 0fb71557280100           movzx    edx, word ptr [rip + 0x12857]
0x0000720B: 440fb70d47280100         movzx    r9d, word ptr [rip + 0x12847]
0x00007213: 89442450                 mov      dword ptr [rsp + 0x50], eax
0x00007217: 894c2448                 mov      dword ptr [rsp + 0x48], ecx
0x0000721B: 89542440                 mov      dword ptr [rsp + 0x40], edx
0x0000721F: 418bcf                   mov      ecx, r15d
0x00007222: 752e                     jne      0x180007252
0x00007224: 440fb71534280100         movzx    r10d, word ptr [rip + 0x12834]
0x0000722C: 440fb71d28280100         movzx    r11d, word ptr [rip + 0x12828]
0x00007234: 0fb71d23280100           movzx    ebx, word ptr [rip + 0x12823]
0x0000723B: 4489542438               mov      dword ptr [rsp + 0x38], r10d
0x00007240: 897c2430                 mov      dword ptr [rsp + 0x30], edi
0x00007244: 44895c2428               mov      dword ptr [rsp + 0x28], r11d
0x00007249: 895c2420                 mov      dword ptr [rsp + 0x20], ebx
0x0000724D: 418bd7                   mov      edx, r15d
0x00007250: eb24                     jmp      0x180007276
0x00007252: 440fb70506280100         movzx    r8d, word ptr [rip + 0x12806]
0x0000725A: 440fb715fc270100         movzx    r10d, word ptr [rip + 0x127fc]
0x00007262: 33d2                     xor      edx, edx
0x00007264: 4489442438               mov      dword ptr [rsp + 0x38], r8d
0x00007269: 4489542430               mov      dword ptr [rsp + 0x30], r10d
0x0000726E: 897c2428                 mov      dword ptr [rsp + 0x28], edi
0x00007272: 897c2420                 mov      dword ptr [rsp + 0x20], edi
0x00007276: 448bc5                   mov      r8d, ebp
0x00007279: e806060000               call     0x180007884
0x0000727E: 0fb70d8b270100           movzx    ecx, word ptr [rip + 0x1278b]
0x00007285: 440fb7057f270100         movzx    r8d, word ptr [rip + 0x1277f]
0x0000728D: 0fb7057e270100           movzx    eax, word ptr [rip + 0x1277e]
0x00007294: 0fb71573270100           movzx    edx, word ptr [rip + 0x12773]
0x0000729B: 440fb70d63270100         movzx    r9d, word ptr [rip + 0x12763]
0x000072A3: 89442450                 mov      dword ptr [rsp + 0x50], eax
0x000072A7: 894c2448                 mov      dword ptr [rsp + 0x48], ecx
0x000072AB: 89542440                 mov      dword ptr [rsp + 0x40], edx
0x000072AF: 33c9                     xor      ecx, ecx
0x000072B1: 66393d4c270100           cmp      word ptr [rip + 0x1274c], di
0x000072B8: 4489442438               mov      dword ptr [rsp + 0x38], r8d
0x000072BD: 448b4614                 mov      r8d, dword ptr [rsi + 0x14]
0x000072C1: 7523                     jne      0x1800072e6
0x000072C3: 440fb7153d270100         movzx    r10d, word ptr [rip + 0x1273d]
0x000072CB: 440fb71d37270100         movzx    r11d, word ptr [rip + 0x12737]
0x000072D3: 897c2430                 mov      dword ptr [rsp + 0x30], edi
0x000072D7: 4489542428               mov      dword ptr [rsp + 0x28], r10d
0x000072DC: 44895c2420               mov      dword ptr [rsp + 0x20], r11d
0x000072E1: e994000000               jmp      0x18000737a
0x000072E6: 440fb7151c270100         movzx    r10d, word ptr [rip + 0x1271c]
0x000072EE: 33d2                     xor      edx, edx
0x000072F0: 4489542430               mov      dword ptr [rsp + 0x30], r10d
0x000072F5: 897c2428                 mov      dword ptr [rsp + 0x28], edi
0x000072F9: 897c2420                 mov      dword ptr [rsp + 0x20], edi
0x000072FD: eb7e                     jmp      0x18000737d
0x000072FF: b802000000               mov      eax, 2
0x00007304: 458bf7                   mov      r14d, r15d
0x00007307: 8d5809                   lea      ebx, [rax + 9]
0x0000730A: 448d4801                 lea      r9d, [rax + 1]
0x0000730E: 83fd6b                   cmp      ebp, 0x6b
0x00007311: 7d0f                     jge      0x180007322
0x00007313: 448d4802                 lea      r9d, [rax + 2]
0x00007317: 418bc7                   mov      eax, r15d
0x0000731A: 418d5906                 lea      ebx, [r9 + 6]
0x0000731E: 458d7101                 lea      r14d, [r9 + 1]
0x00007322: 897c2450                 mov      dword ptr [rsp + 0x50], edi
0x00007326: 897c2448                 mov      dword ptr [rsp + 0x48], edi
0x0000732A: 897c2440                 mov      dword ptr [rsp + 0x40], edi
0x0000732E: c744243802000000         mov      dword ptr [rsp + 0x38], 2
0x00007336: 897c2430                 mov      dword ptr [rsp + 0x30], edi
0x0000733A: 448bc5                   mov      r8d, ebp
0x0000733D: 418bd7                   mov      edx, r15d
0x00007340: 418bcf                   mov      ecx, r15d
0x00007343: 897c2428                 mov      dword ptr [rsp + 0x28], edi
0x00007347: 89442420                 mov      dword ptr [rsp + 0x20], eax
0x0000734B: e834050000               call     0x180007884
0x00007350: 448b4614                 mov      r8d, dword ptr [rsi + 0x14]
0x00007354: 897c2450                 mov      dword ptr [rsp + 0x50], edi
0x00007358: 897c2448                 mov      dword ptr [rsp + 0x48], edi
0x0000735C: 897c2440                 mov      dword ptr [rsp + 0x40], edi
0x00007360: c744243802000000         mov      dword ptr [rsp + 0x38], 2
0x00007368: 897c2430                 mov      dword ptr [rsp + 0x30], edi
0x0000736C: 897c2428                 mov      dword ptr [rsp + 0x28], edi
0x00007370: 4489742420               mov      dword ptr [rsp + 0x20], r14d
0x00007375: 448bcb                   mov      r9d, ebx
0x00007378: 33c9                     xor      ecx, ecx
0x0000737A: 418bd7                   mov      edx, r15d
0x0000737D: e802050000               call     0x180007884
0x00007382: 448b0deb060100           mov      r9d, dword ptr [rip + 0x106eb]
0x00007389: 8b0df5060100             mov      ecx, dword ptr [rip + 0x106f5]
0x0000738F: 448b461c                 mov      r8d, dword ptr [rsi + 0x1c]
0x00007393: 443bc9                   cmp      r9d, ecx
0x00007396: 7d24                     jge      0x1800073bc
0x00007398: 453bc1                   cmp      r8d, r9d
0x0000739B: 0f8c09feffff             jl       0x1800071aa
0x000073A1: 443bc1                   cmp      r8d, ecx
0x000073A4: 0f8f00feffff             jg       0x1800071aa
0x000073AA: 453bc1                   cmp      r8d, r9d
0x000073AD: 7e25                     jle      0x1800073d4
0x000073AF: 443bc1                   cmp      r8d, ecx
0x000073B2: 7d20                     jge      0x1800073d4
0x000073B4: 418bc7                   mov      eax, r15d
0x000073B7: e9f0fdffff               jmp      0x1800071ac
0x000073BC: 443bc1                   cmp      r8d, ecx
0x000073BF: 7cf3                     jl       0x1800073b4
0x000073C1: 453bc1                   cmp      r8d, r9d
0x000073C4: 7fee                     jg       0x1800073b4
0x000073C6: 443bc1                   cmp      r8d, ecx
0x000073C9: 7e09                     jle      0x1800073d4
0x000073CB: 453bc1                   cmp      r8d, r9d
0x000073CE: 0f8cd6fdffff             jl       0x1800071aa
0x000073D4: 6b4e083c                 imul     ecx, dword ptr [rsi + 8], 0x3c
0x000073D8: 034e04                   add      ecx, dword ptr [rsi + 4]
0x000073DB: 6bd13c                   imul     edx, ecx, 0x3c
0x000073DE: 0316                     add      edx, dword ptr [rsi]
0x000073E0: 69c2e8030000             imul     eax, edx, 0x3e8
0x000073E6: 453bc1                   cmp      r8d, r9d
0x000073E9: 7511                     jne      0x1800073fc
0x000073EB: 3b0587060100             cmp      eax, dword ptr [rip + 0x10687]
0x000073F1: 400f9dc7                 setge    dil
0x000073F5: 8bc7                     mov      eax, edi
0x000073F7: e9b0fdffff               jmp      0x1800071ac
0x000073FC: 3b0586060100             cmp      eax, dword ptr [rip + 0x10686]
0x00007402: 400f9cc7                 setl     dil
0x00007406: ebed                     jmp      0x1800073f5
0x00007408: 4533c9                   xor      r9d, r9d
0x0000740B: 4533c0                   xor      r8d, r8d
0x0000740E: 33d2                     xor      edx, edx
0x00007410: 33c9                     xor      ecx, ecx
0x00007412: 48897c2420               mov      qword ptr [rsp + 0x20], rdi
0x00007417: e8a8c4ffff               call     0x1800038c4
0x0000741C: cc                       int3     
0x0000741D: cc                       int3     
0x0000741E: cc                       int3     
0x0000741F: cc                       int3     
0x00007420: 488bc4                   mov      rax, rsp
0x00007423: 53                       push     rbx
0x00007424: 56                       push     rsi
0x00007425: 57                       push     rdi
0x00007426: 4154                     push     r12
0x00007428: 4155                     push     r13
0x0000742A: 4156                     push     r14
0x0000742C: 4157                     push     r15
0x0000742E: 4883ec50                 sub      rsp, 0x50
0x00007432: 4533e4                   xor      r12d, r12d
0x00007435: 44896008                 mov      dword ptr [rax + 8], r12d
0x00007439: 44896010                 mov      dword ptr [rax + 0x10], r12d
0x0000743D: 44896018                 mov      dword ptr [rax + 0x18], r12d
0x00007441: 418bf4                   mov      esi, r12d
0x00007444: 458bfc                   mov      r15d, r12d
0x00007447: 418d4c2407               lea      ecx, [r12 + 7]
0x0000744C: e84fe6ffff               call     0x180005aa0
0x00007451: 90                       nop      
0x00007452: e815fcffff               call     0x18000706c
0x00007457: 4c8bf0                   mov      r14, rax
0x0000745A: 488d8c2490000000         lea      rcx, [rsp + 0x90]
0x00007462: e86dfcffff               call     0x1800070d4
0x00007467: 85c0                     test     eax, eax
0x00007469: 0f85ed030000             jne      0x18000785c
0x0000746F: 488d8c2498000000         lea      rcx, [rsp + 0x98]
0x00007477: e8f8fbffff               call     0x180007074
0x0000747C: 85c0                     test     eax, eax
0x0000747E: 0f85c4030000             jne      0x180007848
0x00007484: 488d8c24a0000000         lea      rcx, [rsp + 0xa0]
0x0000748C: e813fcffff               call     0x1800070a4
0x00007491: 85c0                     test     eax, eax
0x00007493: 0f859b030000             jne      0x180007834
0x00007499: e87e180000               call     0x180008d1c
0x0000749E: 8bd8                     mov      ebx, eax
0x000074A0: 44892515250100           mov      dword ptr [rip + 0x12515], r12d
0x000074A7: 4183cdff                 or       r13d, 0xffffffff
0x000074AB: 44892dce050100           mov      dword ptr [rip + 0x105ce], r13d
0x000074B2: 44892db7050100           mov      dword ptr [rip + 0x105b7], r13d
0x000074B9: 488d0df08f0000           lea      rcx, [rip + 0x8ff0]
0x000074C0: e8b3170000               call     0x180008c78
0x000074C5: 488bf8                   mov      rdi, rax
0x000074C8: 4889442440               mov      qword ptr [rsp + 0x40], rax
0x000074CD: 4885c0                   test     rax, rax
0x000074D0: 0f8491000000             je       0x180007567
0x000074D6: 443820                   cmp      byte ptr [rax], r12b
0x000074D9: 0f8488000000             je       0x180007567
0x000074DF: 488b0dca240100           mov      rcx, qword ptr [rip + 0x124ca]
0x000074E6: 4885c9                   test     rcx, rcx
0x000074E9: 7424                     je       0x18000750f
0x000074EB: 488bd1                   mov      rdx, rcx
0x000074EE: 488bc8                   mov      rcx, rax
0x000074F1: e8dac9ffff               call     0x180003ed0
0x000074F6: 85c0                     test     eax, eax
0x000074F8: 0f84b0010000             je       0x1800076ae
0x000074FE: 488b0dab240100           mov      rcx, qword ptr [rip + 0x124ab]
0x00007505: 4885c9                   test     rcx, rcx
0x00007508: 7405                     je       0x18000750f
0x0000750A: e821a3ffff               call     0x180001830
0x0000750F: 488bcf                   mov      rcx, rdi
0x00007512: e8e9f4ffff               call     0x180006a00
0x00007517: 488d4801                 lea      rcx, [rax + 1]
0x0000751B: e8b8beffff               call     0x1800033d8
0x00007520: 48890589240100           mov      qword ptr [rip + 0x12489], rax
0x00007527: 4885c0                   test     rax, rax
0x0000752A: 0f847e010000             je       0x1800076ae
0x00007530: 488bcf                   mov      rcx, rdi
0x00007533: e8c8f4ffff               call     0x180006a00
0x00007538: 488d5001                 lea      rdx, [rax + 1]
0x0000753C: 4c8bc7                   mov      r8, rdi
0x0000753F: 488b0d6a240100           mov      rcx, qword ptr [rip + 0x1246a]
0x00007546: e849a9ffff               call     0x180001e94
0x0000754B: 85c0                     test     eax, eax
0x0000754D: 0f8460010000             je       0x1800076b3
0x00007553: 4c89642420               mov      qword ptr [rsp + 0x20], r12
0x00007558: 4533c9                   xor      r9d, r9d
0x0000755B: 4533c0                   xor      r8d, r8d
0x0000755E: 33d2                     xor      edx, edx
0x00007560: 33c9                     xor      ecx, ecx
0x00007562: e85dc3ffff               call     0x1800038c4
0x00007567: 488b0d42240100           mov      rcx, qword ptr [rip + 0x12442]
0x0000756E: 4885c9                   test     rcx, rcx
0x00007571: 740c                     je       0x18000757f
0x00007573: e8b8a2ffff               call     0x180001830
0x00007578: 4c892531240100           mov      qword ptr [rip + 0x12431], r12
0x0000757F: 488d0d3a240100           lea      rcx, [rip + 0x1243a]
0x00007586: e82f412200               call     0x18022b6ba
0x0000758B: 16                       .byte    0x16
0x0000758C: 83f8ff                   cmp      eax, -1
0x0000758F: 0f8419010000             je       0x1800076ae
0x00007595: c7051d24010001000000     mov      dword ptr [rip + 0x1241d], 1
0x0000759F: 6b0d1a2401003c           imul     ecx, dword ptr [rip + 0x1241a], 0x3c
0x000075A6: 898c2490000000           mov      dword ptr [rsp + 0x90], ecx
0x000075AD: 6644392551240100         cmp      word ptr [rip + 0x12451], r12w
0x000075B5: 7410                     je       0x1800075c7
0x000075B7: 6b05562401003c           imul     eax, dword ptr [rip + 0x12456], 0x3c
0x000075BE: 03c8                     add      ecx, eax
0x000075C0: 898c2490000000           mov      dword ptr [rsp + 0x90], ecx
0x000075C7: 664439258b240100         cmp      word ptr [rip + 0x1248b], r12w
0x000075CF: 7427                     je       0x1800075f8
0x000075D1: 8b0591240100             mov      eax, dword ptr [rip + 0x12491]
0x000075D7: 85c0                     test     eax, eax
0x000075D9: 741d                     je       0x1800075f8
0x000075DB: c784249800000001000000   mov      dword ptr [rsp + 0x98], 1
0x000075E6: 2b0528240100             sub      eax, dword ptr [rip + 0x12428]
0x000075EC: 6bc03c                   imul     eax, eax, 0x3c
0x000075EF: 898424a0000000           mov      dword ptr [rsp + 0xa0], eax
0x000075F6: eb10                     jmp      0x180007608
0x000075F8: 4489a42498000000         mov      dword ptr [rsp + 0x98], r12d
0x00007600: 4489a424a0000000         mov      dword ptr [rsp + 0xa0], r12d
0x00007608: 488d8424a8000000         lea      rax, [rsp + 0xa8]
0x00007610: 4889442438               mov      qword ptr [rsp + 0x38], rax
0x00007615: 4c89642430               mov      qword ptr [rsp + 0x30], r12
0x0000761A: be3f000000               mov      esi, 0x3f
0x0000761F: 89742428                 mov      dword ptr [rsp + 0x28], esi
0x00007623: 498b06                   mov      rax, qword ptr [r14]
0x00007626: 4889442420               mov      qword ptr [rsp + 0x20], rax
0x0000762B: 458bcd                   mov      r9d, r13d
0x0000762E: 4c8d058f230100           lea      r8, [rip + 0x1238f]
0x00007635: 33d2                     xor      edx, edx
0x00007637: 8bcb                     mov      ecx, ebx
0x00007639: 55                       push     rbp
0x0000763A: e8c1dd2100               call     0x180225400
0x0000763F: 85c0                     test     eax, eax
0x00007641: 7413                     je       0x180007656
0x00007643: 4439a424a8000000         cmp      dword ptr [rsp + 0xa8], r12d
0x0000764B: 7509                     jne      0x180007656
0x0000764D: 498b06                   mov      rax, qword ptr [r14]
0x00007650: 4488603f                 mov      byte ptr [rax + 0x3f], r12b
0x00007654: eb06                     jmp      0x18000765c
0x00007656: 498b06                   mov      rax, qword ptr [r14]
0x00007659: 448820                   mov      byte ptr [rax], r12b
0x0000765C: 488d8424a8000000         lea      rax, [rsp + 0xa8]
0x00007664: 4889442438               mov      qword ptr [rsp + 0x38], rax
0x00007669: 4c89642430               mov      qword ptr [rsp + 0x30], r12
0x0000766E: 89742428                 mov      dword ptr [rsp + 0x28], esi
0x00007672: 498b4608                 mov      rax, qword ptr [r14 + 8]
0x00007676: 4889442420               mov      qword ptr [rsp + 0x20], rax
0x0000767B: 458bcd                   mov      r9d, r13d
0x0000767E: 4c8d0593230100           lea      r8, [rip + 0x12393]
0x00007685: 33d2                     xor      edx, edx
0x00007687: 8bcb                     mov      ecx, ebx
0x00007689: e871302500               call     0x18025a6ff
0x0000768E: 6985c074144439a424a8     imul     eax, dword ptr [rbp + 0x441474c0], 0xa824a439
0x00007698: 0000                     add      byte ptr [rax], al
0x0000769A: 00750a                   add      byte ptr [rbp + 0xa], dh
0x0000769D: 498b4608                 mov      rax, qword ptr [r14 + 8]
0x000076A1: 4488603f                 mov      byte ptr [rax + 0x3f], r12b
0x000076A5: eb07                     jmp      0x1800076ae
0x000076A7: 498b4608                 mov      rax, qword ptr [r14 + 8]
0x000076AB: 448820                   mov      byte ptr [rax], r12b
0x000076AE: be01000000               mov      esi, 1
0x000076B3: 8b9c2490000000           mov      ebx, dword ptr [rsp + 0x90]
0x000076BA: e8a5f9ffff               call     0x180007064
0x000076BF: 8918                     mov      dword ptr [rax], ebx
0x000076C1: 8b9c2498000000           mov      ebx, dword ptr [rsp + 0x98]
0x000076C8: e887f9ffff               call     0x180007054
0x000076CD: 8918                     mov      dword ptr [rax], ebx
0x000076CF: 8b9c24a0000000           mov      ebx, dword ptr [rsp + 0xa0]
0x000076D6: e881f9ffff               call     0x18000705c
0x000076DB: 8918                     mov      dword ptr [rax], ebx
0x000076DD: b907000000               mov      ecx, 7
0x000076E2: e8a9e5ffff               call     0x180005c90
0x000076E7: 85f6                     test     esi, esi
0x000076E9: 0f8582010000             jne      0x180007871
0x000076EF: be03000000               mov      esi, 3
0x000076F4: 448bce                   mov      r9d, esi
0x000076F7: 4c8bc7                   mov      r8, rdi
0x000076FA: 448d6e3d                 lea      r13d, [rsi + 0x3d]
0x000076FE: 418bd5                   mov      edx, r13d
0x00007701: 498b0e                   mov      rcx, qword ptr [r14]
0x00007704: e8b30a0000               call     0x1800081bc
0x00007709: 85c0                     test     eax, eax
0x0000770B: 0f850e010000             jne      0x18000781f
0x00007711: 4803fe                   add      rdi, rsi
0x00007714: 803f2d                   cmp      byte ptr [rdi], 0x2d
0x00007717: 7507                     jne      0x180007720
0x00007719: 448d7efe                 lea      r15d, [rsi - 2]
0x0000771D: 48ffc7                   inc      rdi
0x00007720: 488bcf                   mov      rcx, rdi
0x00007723: e844150000               call     0x180008c6c
0x00007728: 69d0100e0000             imul     edx, eax, 0xe10
0x0000772E: 89942490000000           mov      dword ptr [rsp + 0x90], edx
0x00007735: b330                     mov      bl, 0x30
0x00007737: 8a07                     mov      al, byte ptr [rdi]
0x00007739: 3c2b                     cmp      al, 0x2b
0x0000773B: 7406                     je       0x180007743
0x0000773D: 2ac3                     sub      al, bl
0x0000773F: 3c09                     cmp      al, 9
0x00007741: 7705                     ja       0x180007748
0x00007743: 48ffc7                   inc      rdi
0x00007746: ebef                     jmp      0x180007737
0x00007748: 803f3a                   cmp      byte ptr [rdi], 0x3a
0x0000774B: 755c                     jne      0x1800077a9
0x0000774D: 48ffc7                   inc      rdi
0x00007750: 488bcf                   mov      rcx, rdi
0x00007753: e814150000               call     0x180008c6c
0x00007758: 6bc83c                   imul     ecx, eax, 0x3c
0x0000775B: 8b942490000000           mov      edx, dword ptr [rsp + 0x90]
0x00007762: 03d1                     add      edx, ecx
0x00007764: 89942490000000           mov      dword ptr [rsp + 0x90], edx
0x0000776B: eb07                     jmp      0x180007774
0x0000776D: 3c39                     cmp      al, 0x39
0x0000776F: 7f09                     jg       0x18000777a
0x00007771: 48ffc7                   inc      rdi
0x00007774: 8a07                     mov      al, byte ptr [rdi]
0x00007776: 3ac3                     cmp      al, bl
0x00007778: 7df3                     jge      0x18000776d
0x0000777A: 803f3a                   cmp      byte ptr [rdi], 0x3a
0x0000777D: 752a                     jne      0x1800077a9
0x0000777F: 48ffc7                   inc      rdi
0x00007782: 488bcf                   mov      rcx, rdi
0x00007785: e8e2140000               call     0x180008c6c
0x0000778A: 8b942490000000           mov      edx, dword ptr [rsp + 0x90]
0x00007791: 03d0                     add      edx, eax
0x00007793: 89942490000000           mov      dword ptr [rsp + 0x90], edx
0x0000779A: eb07                     jmp      0x1800077a3
0x0000779C: 3c39                     cmp      al, 0x39
0x0000779E: 7f09                     jg       0x1800077a9
0x000077A0: 48ffc7                   inc      rdi
0x000077A3: 8a07                     mov      al, byte ptr [rdi]
0x000077A5: 3ac3                     cmp      al, bl
0x000077A7: 7df3                     jge      0x18000779c
0x000077A9: 4585ff                   test     r15d, r15d
0x000077AC: 7409                     je       0x1800077b7
0x000077AE: f7da                     neg      edx
0x000077B0: 89942490000000           mov      dword ptr [rsp + 0x90], edx
0x000077B7: 443827                   cmp      byte ptr [rdi], r12b
0x000077BA: 7436                     je       0x1800077f2
0x000077BC: c784249800000001000000   mov      dword ptr [rsp + 0x98], 1
0x000077C7: 4c8bce                   mov      r9, rsi
0x000077CA: 4c8bc7                   mov      r8, rdi
0x000077CD: 498bd5                   mov      rdx, r13
0x000077D0: 498b4e08                 mov      rcx, qword ptr [r14 + 8]
0x000077D4: e8e3090000               call     0x1800081bc
0x000077D9: 85c0                     test     eax, eax
0x000077DB: 7424                     je       0x180007801
0x000077DD: 4c89642420               mov      qword ptr [rsp + 0x20], r12
0x000077E2: 4533c9                   xor      r9d, r9d
0x000077E5: 4533c0                   xor      r8d, r8d
0x000077E8: 33d2                     xor      edx, edx
0x000077EA: 33c9                     xor      ecx, ecx
0x000077EC: e8d3c0ffff               call     0x1800038c4
0x000077F1: cc                       int3     
0x000077F2: 4489a42498000000         mov      dword ptr [rsp + 0x98], r12d
0x000077FA: 498b4608                 mov      rax, qword ptr [r14 + 8]
0x000077FE: 448820                   mov      byte ptr [rax], r12b
0x00007801: 8b9c2490000000           mov      ebx, dword ptr [rsp + 0x90]
0x00007808: e857f8ffff               call     0x180007064
0x0000780D: 8918                     mov      dword ptr [rax], ebx
0x0000780F: 8b9c2498000000           mov      ebx, dword ptr [rsp + 0x98]
0x00007816: e839f8ffff               call     0x180007054
0x0000781B: 8918                     mov      dword ptr [rax], ebx
0x0000781D: eb52                     jmp      0x180007871
0x0000781F: 4c89642420               mov      qword ptr [rsp + 0x20], r12
0x00007824: 4533c9                   xor      r9d, r9d
0x00007827: 4533c0                   xor      r8d, r8d
0x0000782A: 33d2                     xor      edx, edx
0x0000782C: 33c9                     xor      ecx, ecx
0x0000782E: e891c0ffff               call     0x1800038c4
0x00007833: 90                       nop      
0x00007834: 4c89642420               mov      qword ptr [rsp + 0x20], r12
0x00007839: 4533c9                   xor      r9d, r9d
0x0000783C: 4533c0                   xor      r8d, r8d
0x0000783F: 33d2                     xor      edx, edx
0x00007841: 33c9                     xor      ecx, ecx
0x00007843: e87cc0ffff               call     0x1800038c4
0x00007848: 4c89642420               mov      qword ptr [rsp + 0x20], r12
0x0000784D: 4533c9                   xor      r9d, r9d
0x00007850: 4533c0                   xor      r8d, r8d
0x00007853: 33d2                     xor      edx, edx
0x00007855: 33c9                     xor      ecx, ecx
0x00007857: e868c0ffff               call     0x1800038c4
0x0000785C: 4c89642420               mov      qword ptr [rsp + 0x20], r12
0x00007861: 4533c9                   xor      r9d, r9d
0x00007864: 4533c0                   xor      r8d, r8d
0x00007867: 33d2                     xor      edx, edx
0x00007869: 33c9                     xor      ecx, ecx
0x0000786B: e854c0ffff               call     0x1800038c4
0x00007870: 90                       nop      
0x00007871: 4883c450                 add      rsp, 0x50
0x00007875: 415f                     pop      r15
0x00007877: 415e                     pop      r14
0x00007879: 415d                     pop      r13
0x0000787B: 415c                     pop      r12
0x0000787D: 5f                       pop      rdi
0x0000787E: 5e                       pop      rsi
0x0000787F: 5b                       pop      rbx
0x00007880: c3                       ret      
0x00007881: cc                       int3     
0x00007882: cc                       int3     
0x00007883: cc                       int3     
0x00007884: 48895c2410               mov      qword ptr [rsp + 0x10], rbx
0x00007889: 48896c2418               mov      qword ptr [rsp + 0x18], rbp
0x0000788E: 56                       push     rsi
0x0000788F: 57                       push     rdi
0x00007890: 4156                     push     r14
0x00007892: 4883ec30                 sub      rsp, 0x30
0x00007896: 8364245000               and      dword ptr [rsp + 0x50], 0
0x0000789B: 418bd8                   mov      ebx, r8d
0x0000789E: 448bf1                   mov      r14d, ecx
0x000078A1: 83fa01                   cmp      edx, 1
0x000078A4: 0f8565010000             jne      0x180007a0f
0x000078AA: 448bdb                   mov      r11d, ebx
0x000078AD: 4181e303000080           and      r11d, 0x80000003
0x000078B4: 7d0a                     jge      0x1800078c0
0x000078B6: 41ffcb                   dec      r11d
0x000078B9: 4183cbfc                 or       r11d, 0xfffffffc
0x000078BD: 41ffc3                   inc      r11d
0x000078C0: be1f85eb51               mov      esi, 0x51eb851f
0x000078C5: 4585db                   test     r11d, r11d
0x000078C8: 7515                     jne      0x1800078df
0x000078CA: 8bc6                     mov      eax, esi
0x000078CC: f7eb                     imul     ebx
0x000078CE: c1fa05                   sar      edx, 5
0x000078D1: 8bc2                     mov      eax, edx
0x000078D3: c1e81f                   shr      eax, 0x1f
0x000078D6: 03d0                     add      edx, eax
0x000078D8: 6bca64                   imul     ecx, edx, 0x64
0x000078DB: 3bd9                     cmp      ebx, ecx
0x000078DD: 7533                     jne      0x180007912
0x000078DF: 418d886c070000           lea      ecx, [r8 + 0x76c]
0x000078E6: 8bc6                     mov      eax, esi
0x000078E8: f7e9                     imul     ecx
0x000078EA: c1fa07                   sar      edx, 7
0x000078ED: 8bc2                     mov      eax, edx
0x000078EF: c1e81f                   shr      eax, 0x1f
0x000078F2: 03d0                     add      edx, eax
0x000078F4: 69c290010000             imul     eax, edx, 0x190
0x000078FA: 3bc8                     cmp      ecx, eax
0x000078FC: 7414                     je       0x180007912
0x000078FE: 488d3dfb86ffff           lea      rdi, [rip - 0x7905]
0x00007905: 4963e9                   movsxd   rbp, r9d
0x00007908: 448b94af8c7a0100         mov      r10d, dword ptr [rdi + rbp*4 + 0x17a8c]
0x00007910: eb12                     jmp      0x180007924
0x00007912: 488d3de786ffff           lea      rdi, [rip - 0x7919]
0x00007919: 4963e9                   movsxd   rbp, r9d
0x0000791C: 448b94afc47a0100         mov      r10d, dword ptr [rdi + rbp*4 + 0x17ac4]
0x00007924: 41ffc8                   dec      r8d
0x00007927: 8d8b2b010000             lea      ecx, [rbx + 0x12b]
0x0000792D: 8bc6                     mov      eax, esi
0x0000792F: 41ffc2                   inc      r10d
0x00007932: f7e9                     imul     ecx
0x00007934: 8b4c2470                 mov      ecx, dword ptr [rsp + 0x70]
0x00007938: 448bca                   mov      r9d, edx
0x0000793B: 41c1f907                 sar      r9d, 7
0x0000793F: 418bc1                   mov      eax, r9d
0x00007942: c1e81f                   shr      eax, 0x1f
0x00007945: 4403c8                   add      r9d, eax
0x00007948: 8bc6                     mov      eax, esi
0x0000794A: 41f7e8                   imul     r8d
0x0000794D: c1fa05                   sar      edx, 5
0x00007950: 8bc2                     mov      eax, edx
0x00007952: c1e81f                   shr      eax, 0x1f
0x00007955: 03d0                     add      edx, eax
0x00007957: 418bc0                   mov      eax, r8d
0x0000795A: 442bca                   sub      r9d, edx
0x0000795D: 99                       cdq      
0x0000795E: 83e203                   and      edx, 3
0x00007961: 448d0402                 lea      r8d, [rdx + rax]
0x00007965: 69c36d010000             imul     eax, ebx, 0x16d
0x0000796B: 05259cffff               add      eax, 0xffff9c25
0x00007970: 41c1f802                 sar      r8d, 2
0x00007974: 4503c2                   add      r8d, r10d
0x00007977: 4503c1                   add      r8d, r9d
0x0000797A: 4403c0                   add      r8d, eax
0x0000797D: b893244992               mov      eax, 0x92492493
0x00007982: 41f7e8                   imul     r8d
0x00007985: 4103d0                   add      edx, r8d
0x00007988: c1fa02                   sar      edx, 2
0x0000798B: 8bc2                     mov      eax, edx
0x0000798D: c1e81f                   shr      eax, 0x1f
0x00007990: 03d0                     add      edx, eax
0x00007992: 6bc207                   imul     eax, edx, 7
0x00007995: 8b542478                 mov      edx, dword ptr [rsp + 0x78]
0x00007999: 442bc0                   sub      r8d, eax
0x0000799C: 6bc107                   imul     eax, ecx, 7
0x0000799F: 412bc0                   sub      eax, r8d
0x000079A2: 443bc2                   cmp      r8d, edx
0x000079A5: 7f03                     jg       0x1800079aa
0x000079A7: 83c0f9                   add      eax, -7
0x000079AA: 03c2                     add      eax, edx
0x000079AC: 4403d0                   add      r10d, eax
0x000079AF: 83f905                   cmp      ecx, 5
0x000079B2: 0f85d2000000             jne      0x180007a8a
0x000079B8: 4585db                   test     r11d, r11d
0x000079BB: 7515                     jne      0x1800079d2
0x000079BD: 8bc6                     mov      eax, esi
0x000079BF: f7eb                     imul     ebx
0x000079C1: c1fa05                   sar      edx, 5
0x000079C4: 8bca                     mov      ecx, edx
0x000079C6: c1e91f                   shr      ecx, 0x1f
0x000079C9: 03d1                     add      edx, ecx
0x000079CB: 6bd264                   imul     edx, edx, 0x64
0x000079CE: 3bda                     cmp      ebx, edx
0x000079D0: 7527                     jne      0x1800079f9
0x000079D2: 8d8b6c070000             lea      ecx, [rbx + 0x76c]
0x000079D8: 8bc6                     mov      eax, esi
0x000079DA: f7e9                     imul     ecx
0x000079DC: c1fa07                   sar      edx, 7
0x000079DF: 8bc2                     mov      eax, edx
0x000079E1: c1e81f                   shr      eax, 0x1f
0x000079E4: 03d0                     add      edx, eax
0x000079E6: 69c290010000             imul     eax, edx, 0x190
0x000079EC: 3bc8                     cmp      ecx, eax
0x000079EE: 7409                     je       0x1800079f9
0x000079F0: 8b84af907a0100           mov      eax, dword ptr [rdi + rbp*4 + 0x17a90]
0x000079F7: eb07                     jmp      0x180007a00
0x000079F9: 8b84afc87a0100           mov      eax, dword ptr [rdi + rbp*4 + 0x17ac8]
0x00007A00: 443bd0                   cmp      r10d, eax
0x00007A03: 0f8e81000000             jle      0x180007a8a
0x00007A09: 4183ea07                 sub      r10d, 7
0x00007A0D: eb7b                     jmp      0x180007a8a
0x00007A0F: 8bc3                     mov      eax, ebx
0x00007A11: 2503000080               and      eax, 0x80000003
0x00007A16: 7d07                     jge      0x180007a1f
0x00007A18: ffc8                     dec      eax
0x00007A1A: 83c8fc                   or       eax, 0xfffffffc
0x00007A1D: ffc0                     inc      eax
0x00007A1F: be1f85eb51               mov      esi, 0x51eb851f
0x00007A24: 85c0                     test     eax, eax
0x00007A26: 7515                     jne      0x180007a3d
0x00007A28: 8bc6                     mov      eax, esi
0x00007A2A: f7eb                     imul     ebx
0x00007A2C: c1fa05                   sar      edx, 5
0x00007A2F: 8bc2                     mov      eax, edx
0x00007A31: c1e81f                   shr      eax, 0x1f
0x00007A34: 03d0                     add      edx, eax
0x00007A36: 6bca64                   imul     ecx, edx, 0x64
0x00007A39: 3bd9                     cmp      ebx, ecx
0x00007A3B: 7533                     jne      0x180007a70
0x00007A3D: 418d886c070000           lea      ecx, [r8 + 0x76c]
0x00007A44: 8bc6                     mov      eax, esi
0x00007A46: f7e9                     imul     ecx
0x00007A48: c1fa07                   sar      edx, 7
0x00007A4B: 8bc2                     mov      eax, edx
0x00007A4D: c1e81f                   shr      eax, 0x1f
0x00007A50: 03d0                     add      edx, eax
0x00007A52: 69c290010000             imul     eax, edx, 0x190
0x00007A58: 3bc8                     cmp      ecx, eax
0x00007A5A: 7414                     je       0x180007a70
0x00007A5C: 488d3d9d85ffff           lea      rdi, [rip - 0x7a63]
0x00007A63: 4963c1                   movsxd   rax, r9d
0x00007A66: 448b94878c7a0100         mov      r10d, dword ptr [rdi + rax*4 + 0x17a8c]
0x00007A6E: eb12                     jmp      0x180007a82
0x00007A70: 488d3d8985ffff           lea      rdi, [rip - 0x7a77]
0x00007A77: 4963c1                   movsxd   rax, r9d
0x00007A7A: 448b9487c47a0100         mov      r10d, dword ptr [rdi + rax*4 + 0x17ac4]
0x00007A82: 4403942480000000         add      r10d, dword ptr [rsp + 0x80]
0x00007A8A: 6b8424880000003c         imul     eax, dword ptr [rsp + 0x88], 0x3c
0x00007A92: 03842490000000           add      eax, dword ptr [rsp + 0x90]
0x00007A99: 6bc83c                   imul     ecx, eax, 0x3c
0x00007A9C: 038c2498000000           add      ecx, dword ptr [rsp + 0x98]
0x00007AA3: 69c1e8030000             imul     eax, ecx, 0x3e8
0x00007AA9: 038424a0000000           add      eax, dword ptr [rsp + 0xa0]
0x00007AB0: 4183fe01                 cmp      r14d, 1
0x00007AB4: 7526                     jne      0x180007adc
0x00007AB6: 448915b7ff0000           mov      dword ptr [rip + 0xffb7], r10d
0x00007ABD: 8905b5ff0000             mov      dword ptr [rip + 0xffb5], eax
0x00007AC3: 891da7ff0000             mov      dword ptr [rip + 0xffa7], ebx
0x00007AC9: 488b5c2458               mov      rbx, qword ptr [rsp + 0x58]
0x00007ACE: 488b6c2460               mov      rbp, qword ptr [rsp + 0x60]
0x00007AD3: 4883c430                 add      rsp, 0x30
0x00007AD7: 415e                     pop      r14
0x00007AD9: 5f                       pop      rdi
0x00007ADA: 5e                       pop      rsi
0x00007ADB: c3                       ret      
0x00007ADC: 488d4c2450               lea      rcx, [rsp + 0x50]
0x00007AE1: 4489159cff0000           mov      dword ptr [rip + 0xff9c], r10d
0x00007AE8: 89059aff0000             mov      dword ptr [rip + 0xff9a], eax
0x00007AEE: e8b1f5ffff               call     0x1800070a4
0x00007AF3: 85c0                     test     eax, eax
0x00007AF5: 7541                     jne      0x180007b38
0x00007AF7: 69442450e8030000         imul     eax, dword ptr [rsp + 0x50], 0x3e8
0x00007AFF: 8b0d83ff0000             mov      ecx, dword ptr [rip + 0xff83]
0x00007B05: 03c8                     add      ecx, eax
0x00007B07: b8005c2605               mov      eax, 0x5265c00
0x00007B0C: 890d76ff0000             mov      dword ptr [rip + 0xff76], ecx
0x00007B12: 790a                     jns      0x180007b1e
0x00007B14: 03c8                     add      ecx, eax
0x00007B16: ff0d68ff0000             dec      dword ptr [rip + 0xff68]
0x00007B1C: eb0c                     jmp      0x180007b2a
0x00007B1E: 3bc8                     cmp      ecx, eax
0x00007B20: 7c0e                     jl       0x180007b30
0x00007B22: 2bc8                     sub      ecx, eax
0x00007B24: ff055aff0000             inc      dword ptr [rip + 0xff5a]
0x00007B2A: 890d58ff0000             mov      dword ptr [rip + 0xff58], ecx
0x00007B30: 891d4aff0000             mov      dword ptr [rip + 0xff4a], ebx
0x00007B36: eb91                     jmp      0x180007ac9
0x00007B38: 488364242000             and      qword ptr [rsp + 0x20], 0
0x00007B3E: 4533c9                   xor      r9d, r9d
0x00007B41: 4533c0                   xor      r8d, r8d
0x00007B44: 33d2                     xor      edx, edx
0x00007B46: 33c9                     xor      ecx, ecx
0x00007B48: e877bdffff               call     0x1800038c4
0x00007B4D: cc                       int3     
0x00007B4E: cc                       int3     
0x00007B4F: cc                       int3     
0x00007B50: f0ff01                   lock inc dword ptr [rcx]
0x00007B53: 488b81d8000000           mov      rax, qword ptr [rcx + 0xd8]
0x00007B5A: 4885c0                   test     rax, rax
0x00007B5D: 7403                     je       0x180007b62
0x00007B5F: f0ff00                   lock inc dword ptr [rax]
0x00007B62: 488b81e8000000           mov      rax, qword ptr [rcx + 0xe8]
0x00007B69: 4885c0                   test     rax, rax
0x00007B6C: 7403                     je       0x180007b71
0x00007B6E: f0ff00                   lock inc dword ptr [rax]
0x00007B71: 488b81e0000000           mov      rax, qword ptr [rcx + 0xe0]
0x00007B78: 4885c0                   test     rax, rax
0x00007B7B: 7403                     je       0x180007b80
0x00007B7D: f0ff00                   lock inc dword ptr [rax]
0x00007B80: 488b81f8000000           mov      rax, qword ptr [rcx + 0xf8]
0x00007B87: 4885c0                   test     rax, rax
0x00007B8A: 7403                     je       0x180007b8f
0x00007B8C: f0ff00                   lock inc dword ptr [rax]
0x00007B8F: 488d4128                 lea      rax, [rcx + 0x28]
0x00007B93: 41b806000000             mov      r8d, 6
0x00007B99: 488d1560ff0000           lea      rdx, [rip + 0xff60]
0x00007BA0: 483950f0                 cmp      qword ptr [rax - 0x10], rdx
0x00007BA4: 740b                     je       0x180007bb1
0x00007BA6: 488b10                   mov      rdx, qword ptr [rax]
0x00007BA9: 4885d2                   test     rdx, rdx
0x00007BAC: 7403                     je       0x180007bb1
0x00007BAE: f0ff02                   lock inc dword ptr [rdx]
0x00007BB1: 488378e800               cmp      qword ptr [rax - 0x18], 0
0x00007BB6: 740c                     je       0x180007bc4
0x00007BB8: 488b50f8                 mov      rdx, qword ptr [rax - 8]
0x00007BBC: 4885d2                   test     rdx, rdx
0x00007BBF: 7403                     je       0x180007bc4
0x00007BC1: f0ff02                   lock inc dword ptr [rdx]
0x00007BC4: 4883c020                 add      rax, 0x20
0x00007BC8: 49ffc8                   dec      r8
0x00007BCB: 75cc                     jne      0x180007b99
0x00007BCD: 488b8120010000           mov      rax, qword ptr [rcx + 0x120]
0x00007BD4: f0ff805c010000           lock inc dword ptr [rax + 0x15c]
0x00007BDB: c3                       ret      
0x00007BDC: 48895c2408               mov      qword ptr [rsp + 8], rbx
0x00007BE1: 48896c2410               mov      qword ptr [rsp + 0x10], rbp
0x00007BE6: 4889742418               mov      qword ptr [rsp + 0x18], rsi
0x00007BEB: 57                       push     rdi
0x00007BEC: 4883ec20                 sub      rsp, 0x20
0x00007BF0: 488b81f0000000           mov      rax, qword ptr [rcx + 0xf0]
0x00007BF7: 488bd9                   mov      rbx, rcx
0x00007BFA: 4885c0                   test     rax, rax
0x00007BFD: 7479                     je       0x180007c78
0x00007BFF: 488d0d1a070100           lea      rcx, [rip + 0x1071a]
0x00007C06: 483bc1                   cmp      rax, rcx
0x00007C09: 746d                     je       0x180007c78
0x00007C0B: 488b83d8000000           mov      rax, qword ptr [rbx + 0xd8]
0x00007C12: 4885c0                   test     rax, rax
0x00007C15: 7461                     je       0x180007c78
0x00007C17: 833800                   cmp      dword ptr [rax], 0
0x00007C1A: 755c                     jne      0x180007c78
0x00007C1C: 488b8be8000000           mov      rcx, qword ptr [rbx + 0xe8]
0x00007C23: 4885c9                   test     rcx, rcx
0x00007C26: 7416                     je       0x180007c3e
0x00007C28: 833900                   cmp      dword ptr [rcx], 0
0x00007C2B: 7511                     jne      0x180007c3e
0x00007C2D: e8fe9bffff               call     0x180001830
0x00007C32: 488b8bf0000000           mov      rcx, qword ptr [rbx + 0xf0]
0x00007C39: e816110000               call     0x180008d54
0x00007C3E: 488b8be0000000           mov      rcx, qword ptr [rbx + 0xe0]
0x00007C45: 4885c9                   test     rcx, rcx
0x00007C48: 7416                     je       0x180007c60
0x00007C4A: 833900                   cmp      dword ptr [rcx], 0
0x00007C4D: 7511                     jne      0x180007c60
0x00007C4F: e8dc9bffff               call     0x180001830
0x00007C54: 488b8bf0000000           mov      rcx, qword ptr [rbx + 0xf0]
0x00007C5B: e800120000               call     0x180008e60
0x00007C60: 488b8bd8000000           mov      rcx, qword ptr [rbx + 0xd8]
0x00007C67: e8c49bffff               call     0x180001830
0x00007C6C: 488b8bf0000000           mov      rcx, qword ptr [rbx + 0xf0]
0x00007C73: e8b89bffff               call     0x180001830
0x00007C78: 488b83f8000000           mov      rax, qword ptr [rbx + 0xf8]
0x00007C7F: 4885c0                   test     rax, rax
0x00007C82: 7447                     je       0x180007ccb
0x00007C84: 833800                   cmp      dword ptr [rax], 0
0x00007C87: 7542                     jne      0x180007ccb
0x00007C89: 488b8b00010000           mov      rcx, qword ptr [rbx + 0x100]
0x00007C90: 4881e9fe000000           sub      rcx, 0xfe
0x00007C97: e8949bffff               call     0x180001830
0x00007C9C: 488b8b10010000           mov      rcx, qword ptr [rbx + 0x110]
0x00007CA3: bf80000000               mov      edi, 0x80
0x00007CA8: 482bcf                   sub      rcx, rdi
0x00007CAB: e8809bffff               call     0x180001830
0x00007CB0: 488b8b18010000           mov      rcx, qword ptr [rbx + 0x118]
0x00007CB7: 482bcf                   sub      rcx, rdi
0x00007CBA: e8719bffff               call     0x180001830
0x00007CBF: 488b8bf8000000           mov      rcx, qword ptr [rbx + 0xf8]
0x00007CC6: e8659bffff               call     0x180001830
0x00007CCB: 488b8b20010000           mov      rcx, qword ptr [rbx + 0x120]
0x00007CD2: 488d0537fe0000           lea      rax, [rip + 0xfe37]
0x00007CD9: 483bc8                   cmp      rcx, rax
0x00007CDC: 741a                     je       0x180007cf8
0x00007CDE: 83b95c01000000           cmp      dword ptr [rcx + 0x15c], 0
0x00007CE5: 7511                     jne      0x180007cf8
0x00007CE7: e8e0110000               call     0x180008ecc
0x00007CEC: 488b8b20010000           mov      rcx, qword ptr [rbx + 0x120]
0x00007CF3: e8389bffff               call     0x180001830
0x00007CF8: 488db328010000           lea      rsi, [rbx + 0x128]
0x00007CFF: 488d7b28                 lea      rdi, [rbx + 0x28]
0x00007D03: bd06000000               mov      ebp, 6
0x00007D08: 488d05f1fd0000           lea      rax, [rip + 0xfdf1]
0x00007D0F: 483947f0                 cmp      qword ptr [rdi - 0x10], rax
0x00007D13: 741a                     je       0x180007d2f
0x00007D15: 488b0f                   mov      rcx, qword ptr [rdi]
0x00007D18: 4885c9                   test     rcx, rcx
0x00007D1B: 7412                     je       0x180007d2f
0x00007D1D: 833900                   cmp      dword ptr [rcx], 0
0x00007D20: 750d                     jne      0x180007d2f
0x00007D22: e8099bffff               call     0x180001830
0x00007D27: 488b0e                   mov      rcx, qword ptr [rsi]
0x00007D2A: e8019bffff               call     0x180001830
0x00007D2F: 48837fe800               cmp      qword ptr [rdi - 0x18], 0
0x00007D34: 7413                     je       0x180007d49
0x00007D36: 488b4ff8                 mov      rcx, qword ptr [rdi - 8]
0x00007D3A: 4885c9                   test     rcx, rcx
0x00007D3D: 740a                     je       0x180007d49
0x00007D3F: 833900                   cmp      dword ptr [rcx], 0
0x00007D42: 7505                     jne      0x180007d49
0x00007D44: e8e79affff               call     0x180001830
0x00007D49: 4883c608                 add      rsi, 8
0x00007D4D: 4883c720                 add      rdi, 0x20
0x00007D51: 48ffcd                   dec      rbp
0x00007D54: 75b2                     jne      0x180007d08
0x00007D56: 488bcb                   mov      rcx, rbx
0x00007D59: 488b5c2430               mov      rbx, qword ptr [rsp + 0x30]
0x00007D5E: 488b6c2438               mov      rbp, qword ptr [rsp + 0x38]
0x00007D63: 488b742440               mov      rsi, qword ptr [rsp + 0x40]
0x00007D68: 4883c420                 add      rsp, 0x20
0x00007D6C: 5f                       pop      rdi
0x00007D6D: e9be9affff               jmp      0x180001830
0x00007D72: cc                       int3     
0x00007D73: cc                       int3     
0x00007D74: 4885c9                   test     rcx, rcx
0x00007D77: 0f8497000000             je       0x180007e14
0x00007D7D: 4183c9ff                 or       r9d, 0xffffffff
0x00007D81: f0440109                 lock add dword ptr [rcx], r9d
0x00007D85: 488b81d8000000           mov      rax, qword ptr [rcx + 0xd8]
0x00007D8C: 4885c0                   test     rax, rax
0x00007D8F: 7404                     je       0x180007d95
0x00007D91: f0440108                 lock add dword ptr [rax], r9d
0x00007D95: 488b81e8000000           mov      rax, qword ptr [rcx + 0xe8]
0x00007D9C: 4885c0                   test     rax, rax
0x00007D9F: 7404                     je       0x180007da5
0x00007DA1: f0440108                 lock add dword ptr [rax], r9d
0x00007DA5: 488b81e0000000           mov      rax, qword ptr [rcx + 0xe0]
0x00007DAC: 4885c0                   test     rax, rax
0x00007DAF: 7404                     je       0x180007db5
0x00007DB1: f0440108                 lock add dword ptr [rax], r9d
0x00007DB5: 488b81f8000000           mov      rax, qword ptr [rcx + 0xf8]
0x00007DBC: 4885c0                   test     rax, rax
0x00007DBF: 7404                     je       0x180007dc5
0x00007DC1: f0440108                 lock add dword ptr [rax], r9d
0x00007DC5: 488d4128                 lea      rax, [rcx + 0x28]
0x00007DC9: 41b806000000             mov      r8d, 6
0x00007DCF: 488d152afd0000           lea      rdx, [rip + 0xfd2a]
0x00007DD6: 483950f0                 cmp      qword ptr [rax - 0x10], rdx
0x00007DDA: 740c                     je       0x180007de8
0x00007DDC: 488b10                   mov      rdx, qword ptr [rax]
0x00007DDF: 4885d2                   test     rdx, rdx
0x00007DE2: 7404                     je       0x180007de8
0x00007DE4: f044010a                 lock add dword ptr [rdx], r9d
0x00007DE8: 488378e800               cmp      qword ptr [rax - 0x18], 0
0x00007DED: 740d                     je       0x180007dfc
0x00007DEF: 488b50f8                 mov      rdx, qword ptr [rax - 8]
0x00007DF3: 4885d2                   test     rdx, rdx
0x00007DF6: 7404                     je       0x180007dfc
0x00007DF8: f044010a                 lock add dword ptr [rdx], r9d
0x00007DFC: 4883c020                 add      rax, 0x20
0x00007E00: 49ffc8                   dec      r8
0x00007E03: 75ca                     jne      0x180007dcf
0x00007E05: 488b8120010000           mov      rax, qword ptr [rcx + 0x120]
0x00007E0C: f04401885c010000         lock add dword ptr [rax + 0x15c], r9d
0x00007E14: 488bc1                   mov      rax, rcx
0x00007E17: c3                       ret      
0x00007E18: 4053                     push     rbx
0x00007E1A: 4883ec20                 sub      rsp, 0x20
0x00007E1E: e865c4ffff               call     0x180004288
0x00007E23: 488bd8                   mov      rbx, rax
0x00007E26: 8b0de8040100             mov      ecx, dword ptr [rip + 0x104e8]
0x00007E2C: 8588c8000000             test     dword ptr [rax + 0xc8], ecx
0x00007E32: 7418                     je       0x180007e4c
0x00007E34: 4883b8c000000000         cmp      qword ptr [rax + 0xc0], 0
0x00007E3C: 740e                     je       0x180007e4c
0x00007E3E: e845c4ffff               call     0x180004288
0x00007E43: 488b98c0000000           mov      rbx, qword ptr [rax + 0xc0]
0x00007E4A: eb2b                     jmp      0x180007e77
0x00007E4C: b90c000000               mov      ecx, 0xc
0x00007E51: e84adcffff               call     0x180005aa0
0x00007E56: 90                       nop      
0x00007E57: 488d8bc0000000           lea      rcx, [rbx + 0xc0]
0x00007E5E: 488b156bff0000           mov      rdx, qword ptr [rip + 0xff6b]
0x00007E65: e826000000               call     0x180007e90
0x00007E6A: 488bd8                   mov      rbx, rax
0x00007E6D: b90c000000               mov      ecx, 0xc
0x00007E72: e819deffff               call     0x180005c90
0x00007E77: 4885db                   test     rbx, rbx
0x00007E7A: 7508                     jne      0x180007e84
0x00007E7C: 8d4b20                   lea      ecx, [rbx + 0x20]
0x00007E7F: e89cacffff               call     0x180002b20
0x00007E84: 488bc3                   mov      rax, rbx
0x00007E87: 4883c420                 add      rsp, 0x20
0x00007E8B: 5b                       pop      rbx
0x00007E8C: c3                       ret      
0x00007E8D: cc                       int3     
0x00007E8E: cc                       int3     
0x00007E8F: cc                       int3     
0x00007E90: 48895c2408               mov      qword ptr [rsp + 8], rbx
0x00007E95: 57                       push     rdi
0x00007E96: 4883ec20                 sub      rsp, 0x20
0x00007E9A: 488bfa                   mov      rdi, rdx
0x00007E9D: 4885d2                   test     rdx, rdx
0x00007EA0: 7443                     je       0x180007ee5
0x00007EA2: 4885c9                   test     rcx, rcx
0x00007EA5: 743e                     je       0x180007ee5
0x00007EA7: 488b19                   mov      rbx, qword ptr [rcx]
0x00007EAA: 483bda                   cmp      rbx, rdx
0x00007EAD: 7431                     je       0x180007ee0
0x00007EAF: 488911                   mov      qword ptr [rcx], rdx
0x00007EB2: 488bca                   mov      rcx, rdx
0x00007EB5: e896fcffff               call     0x180007b50
0x00007EBA: 4885db                   test     rbx, rbx
0x00007EBD: 7421                     je       0x180007ee0
0x00007EBF: 488bcb                   mov      rcx, rbx
0x00007EC2: e8adfeffff               call     0x180007d74
0x00007EC7: 833b00                   cmp      dword ptr [rbx], 0
0x00007ECA: 7514                     jne      0x180007ee0
0x00007ECC: 488d050dff0000           lea      rax, [rip + 0xff0d]
0x00007ED3: 483bd8                   cmp      rbx, rax
0x00007ED6: 7408                     je       0x180007ee0
0x00007ED8: 488bcb                   mov      rcx, rbx
0x00007EDB: e8fcfcffff               call     0x180007bdc
0x00007EE0: 488bc7                   mov      rax, rdi
0x00007EE3: eb02                     jmp      0x180007ee7
0x00007EE5: 33c0                     xor      eax, eax
0x00007EE7: 488b5c2430               mov      rbx, qword ptr [rsp + 0x30]
0x00007EEC: 4883c420                 add      rsp, 0x20
0x00007EF0: 5f                       pop      rdi
0x00007EF1: c3                       ret      
0x00007EF2: cc                       int3     
0x00007EF3: cc                       int3     
0x00007EF4: 48895c2408               mov      qword ptr [rsp + 8], rbx
0x00007EF9: 57                       push     rdi
0x00007EFA: 4883ec20                 sub      rsp, 0x20
0x00007EFE: 8b053c470100             mov      eax, dword ptr [rip + 0x1473c]
0x00007F04: 33db                     xor      ebx, ebx
0x00007F06: bf14000000               mov      edi, 0x14
0x00007F0B: 85c0                     test     eax, eax
0x00007F0D: 7507                     jne      0x180007f16
0x00007F0F: b800020000               mov      eax, 0x200
0x00007F14: eb05                     jmp      0x180007f1b
0x00007F16: 3bc7                     cmp      eax, edi
0x00007F18: 0f4cc7                   cmovl    eax, edi
0x00007F1B: 4863c8                   movsxd   rcx, eax
0x00007F1E: ba08000000               mov      edx, 8
0x00007F23: 890517470100             mov      dword ptr [rip + 0x14717], eax
0x00007F29: e82ab4ffff               call     0x180003358
0x00007F2E: 48890503470100           mov      qword ptr [rip + 0x14703], rax
0x00007F35: 4885c0                   test     rax, rax
0x00007F38: 7524                     jne      0x180007f5e
0x00007F3A: 8d5008                   lea      edx, [rax + 8]
0x00007F3D: 488bcf                   mov      rcx, rdi
0x00007F40: 893dfa460100             mov      dword ptr [rip + 0x146fa], edi
0x00007F46: e80db4ffff               call     0x180003358
0x00007F4B: 488905e6460100           mov      qword ptr [rip + 0x146e6], rax
0x00007F52: 4885c0                   test     rax, rax
0x00007F55: 7507                     jne      0x180007f5e
0x00007F57: b81a000000               mov      eax, 0x1a
0x00007F5C: eb23                     jmp      0x180007f81
0x00007F5E: 488d0debff0000           lea      rcx, [rip + 0xffeb]
0x00007F65: 48890c03                 mov      qword ptr [rbx + rax], rcx
0x00007F69: 4883c130                 add      rcx, 0x30
0x00007F6D: 488d5b08                 lea      rbx, [rbx + 8]
0x00007F71: 48ffcf                   dec      rdi
0x00007F74: 7409                     je       0x180007f7f
0x00007F76: 488b05bb460100           mov      rax, qword ptr [rip + 0x146bb]
0x00007F7D: ebe6                     jmp      0x180007f65
0x00007F7F: 33c0                     xor      eax, eax
0x00007F81: 488b5c2430               mov      rbx, qword ptr [rsp + 0x30]
0x00007F86: 4883c420                 add      rsp, 0x20
0x00007F8A: 5f                       pop      rdi
0x00007F8B: c3                       ret      
0x00007F8C: 4883ec28                 sub      rsp, 0x28
0x00007F90: e8e30b0000               call     0x180008b78
0x00007F95: 803da80d010000           cmp      byte ptr [rip + 0x10da8], 0
0x00007F9C: 7405                     je       0x180007fa3
0x00007F9E: e825130000               call     0x1800092c8
0x00007FA3: 488b0d8e460100           mov      rcx, qword ptr [rip + 0x1468e]
0x00007FAA: e88198ffff               call     0x180001830
0x00007FAF: 4883258146010000         and      qword ptr [rip + 0x14681], 0
0x00007FB7: 4883c428                 add      rsp, 0x28
0x00007FBB: c3                       ret      
0x00007FBC: 4053                     push     rbx
0x00007FBE: 4883ec20                 sub      rsp, 0x20
0x00007FC2: 488bd9                   mov      rbx, rcx
0x00007FC5: 488d0d84ff0000           lea      rcx, [rip + 0xff84]
0x00007FCC: 483bd9                   cmp      rbx, rcx
0x00007FCF: 7240                     jb       0x180008011
0x00007FD1: 488d0508030100           lea      rax, [rip + 0x10308]
0x00007FD8: 483bd8                   cmp      rbx, rax
0x00007FDB: 7734                     ja       0x180008011
0x00007FDD: 488bd3                   mov      rdx, rbx
0x00007FE0: 48b8abaaaaaaaaaaaa2a     movabs   rax, 0x2aaaaaaaaaaaaaab
0x00007FEA: 482bd1                   sub      rdx, rcx
0x00007FED: 48f7ea                   imul     rdx
0x00007FF0: 48c1fa03                 sar      rdx, 3
0x00007FF4: 488bca                   mov      rcx, rdx
0x00007FF7: 48c1e93f                 shr      rcx, 0x3f
0x00007FFB: 4803ca                   add      rcx, rdx
0x00007FFE: 83c110                   add      ecx, 0x10
0x00008001: e89adaffff               call     0x180005aa0
0x00008006: 0fba6b180f               bts      dword ptr [rbx + 0x18], 0xf
0x0000800B: 4883c420                 add      rsp, 0x20
0x0000800F: 5b                       pop      rbx
0x00008010: c3                       ret      
0x00008011: 488d4b30                 lea      rcx, [rbx + 0x30]
0x00008015: 4883c420                 add      rsp, 0x20
0x00008019: 5b                       pop      rbx
0x0000801A: 48e889781c00             call     0x1801cf8a9
0x00008020: e1cc                     loope    0x180007fee
0x00008022: cc                       int3     
0x00008023: cc                       int3     
0x00008024: 4053                     push     rbx
0x00008026: 4883ec20                 sub      rsp, 0x20
0x0000802A: 488bda                   mov      rbx, rdx
0x0000802D: 83f914                   cmp      ecx, 0x14
0x00008030: 7d13                     jge      0x180008045
0x00008032: 83c110                   add      ecx, 0x10
0x00008035: e866daffff               call     0x180005aa0
0x0000803A: 0fba6b180f               bts      dword ptr [rbx + 0x18], 0xf
0x0000803F: 4883c420                 add      rsp, 0x20
0x00008043: 5b                       pop      rbx
0x00008044: c3                       ret      
0x00008045: 488d4a30                 lea      rcx, [rdx + 0x30]
0x00008049: 4883c420                 add      rsp, 0x20
0x0000804D: 5b                       pop      rbx
0x0000804E: 4857                     push     rdi
0x00008050: e8e0fa1e00               call     0x1801f7b35
0x00008055: cc                       int3     
0x00008056: cc                       int3     
0x00008057: cc                       int3     
0x00008058: 488d15f1fe0000           lea      rdx, [rip + 0xfef1]
0x0000805F: 483bca                   cmp      rcx, rdx
0x00008062: 7237                     jb       0x18000809b
0x00008064: 488d0575020100           lea      rax, [rip + 0x10275]
0x0000806B: 483bc8                   cmp      rcx, rax
0x0000806E: 772b                     ja       0x18000809b
0x00008070: 0fba71180f               btr      dword ptr [rcx + 0x18], 0xf
0x00008075: 482bca                   sub      rcx, rdx
0x00008078: 48b8abaaaaaaaaaaaa2a     movabs   rax, 0x2aaaaaaaaaaaaaab
0x00008082: 48f7e9                   imul     rcx
0x00008085: 48c1fa03                 sar      rdx, 3
0x00008089: 488bca                   mov      rcx, rdx
0x0000808C: 48c1e93f                 shr      rcx, 0x3f
0x00008090: 4803ca                   add      rcx, rdx
0x00008093: 83c110                   add      ecx, 0x10
0x00008096: e9f5dbffff               jmp      0x180005c90
0x0000809B: 4883c130                 add      rcx, 0x30
0x0000809F: 4855                     push     rbp
0x000080A1: e839810100               call     0x1800201df
0x000080A6: cc                       int3     
0x000080A7: cc                       int3     
0x000080A8: 83f914                   cmp      ecx, 0x14
0x000080AB: 7d0d                     jge      0x1800080ba
0x000080AD: 0fba72180f               btr      dword ptr [rdx + 0x18], 0xf
0x000080B2: 83c110                   add      ecx, 0x10
0x000080B5: e9d6dbffff               jmp      0x180005c90
0x000080BA: 488d4a30                 lea      rcx, [rdx + 0x30]
0x000080BE: 48e8100c1b00             call     0x1801b8cd4
0x000080C4: 16                       .byte    0x16
0x000080C5: cc                       int3     
0x000080C6: cc                       int3     
0x000080C7: cc                       int3     
0x000080C8: 48895c2408               mov      qword ptr [rsp + 8], rbx
0x000080CD: 4889742410               mov      qword ptr [rsp + 0x10], rsi
0x000080D2: 57                       push     rdi
0x000080D3: 4883ec40                 sub      rsp, 0x40
0x000080D7: 8bda                     mov      ebx, edx
0x000080D9: 488bd1                   mov      rdx, rcx
0x000080DC: 488d4c2420               lea      rcx, [rsp + 0x20]
0x000080E1: 418bf9                   mov      edi, r9d
0x000080E4: 418bf0                   mov      esi, r8d
0x000080E7: e8acdfffff               call     0x180006098
0x000080EC: 488b442428               mov      rax, qword ptr [rsp + 0x28]
0x000080F1: 0fb6d3                   movzx    edx, bl
0x000080F4: 40847c0219               test     byte ptr [rdx + rax + 0x19], dil
0x000080F9: 751e                     jne      0x180008119
0x000080FB: 85f6                     test     esi, esi
0x000080FD: 7414                     je       0x180008113
0x000080FF: 488b442420               mov      rax, qword ptr [rsp + 0x20]
0x00008104: 488b8808010000           mov      rcx, qword ptr [rax + 0x108]
0x0000810B: 0fb70451                 movzx    eax, word ptr [rcx + rdx*2]
0x0000810F: 23c6                     and      eax, esi
0x00008111: eb02                     jmp      0x180008115
0x00008113: 33c0                     xor      eax, eax
0x00008115: 85c0                     test     eax, eax
0x00008117: 7405                     je       0x18000811e
0x00008119: b801000000               mov      eax, 1
0x0000811E: 807c243800               cmp      byte ptr [rsp + 0x38], 0
0x00008123: 740c                     je       0x180008131
0x00008125: 488b4c2430               mov      rcx, qword ptr [rsp + 0x30]
0x0000812A: 83a1c8000000fd           and      dword ptr [rcx + 0xc8], 0xfffffffd
0x00008131: 488b5c2450               mov      rbx, qword ptr [rsp + 0x50]
0x00008136: 488b742458               mov      rsi, qword ptr [rsp + 0x58]
0x0000813B: 4883c440                 add      rsp, 0x40
0x0000813F: 5f                       pop      rdi
0x00008140: c3                       ret      
0x00008141: cc                       int3     
0x00008142: cc                       int3     
0x00008143: cc                       int3     
0x00008144: 8bd1                     mov      edx, ecx
0x00008146: 41b904000000             mov      r9d, 4
0x0000814C: 4533c0                   xor      r8d, r8d
0x0000814F: 33c9                     xor      ecx, ecx
0x00008151: e972ffffff               jmp      0x1800080c8
0x00008156: cc                       int3     
0x00008157: cc                       int3     
0x00008158: b902000000               mov      ecx, 2
0x0000815D: e9bea9ffff               jmp      0x180002b20
0x00008162: cc                       int3     
0x00008163: cc                       int3     
0x00008164: 4883ec28                 sub      rsp, 0x28
0x00008168: e897dcffff               call     0x180005e04
0x0000816D: 4885c0                   test     rax, rax
0x00008170: 740a                     je       0x18000817c
0x00008172: b916000000               mov      ecx, 0x16
0x00008177: e8b8dcffff               call     0x180005e34
0x0000817C: f6058d01010002           test     byte ptr [rip + 0x1018d], 2
0x00008183: 7429                     je       0x1800081ae
0x00008185: b917000000               mov      ecx, 0x17
0x0000818A: e8696a0000               call     0x18000ebf8
0x0000818F: 85c0                     test     eax, eax
0x00008191: 7407                     je       0x18000819a
0x00008193: b907000000               mov      ecx, 7
0x00008198: cd29                     int      0x29
0x0000819A: 41b801000000             mov      r8d, 1
0x000081A0: ba15000040               mov      edx, 0x40000015
0x000081A5: 418d4802                 lea      ecx, [r8 + 2]
0x000081A9: e892b5ffff               call     0x180003740
0x000081AE: b903000000               mov      ecx, 3
0x000081B3: e838aaffff               call     0x180002bf0
0x000081B8: cc                       int3     
0x000081B9: cc                       int3     
0x000081BA: cc                       int3     
0x000081BB: cc                       int3     
0x000081BC: 4053                     push     rbx
0x000081BE: 4883ec20                 sub      rsp, 0x20
0x000081C2: 33db                     xor      ebx, ebx
0x000081C4: 4d85c9                   test     r9, r9
0x000081C7: 750e                     jne      0x1800081d7
0x000081C9: 4885c9                   test     rcx, rcx
0x000081CC: 750e                     jne      0x1800081dc
0x000081CE: 4885d2                   test     rdx, rdx
0x000081D1: 751e                     jne      0x1800081f1
0x000081D3: 33c0                     xor      eax, eax
0x000081D5: eb2d                     jmp      0x180008204
0x000081D7: 4885c9                   test     rcx, rcx
0x000081DA: 7415                     je       0x1800081f1
0x000081DC: 4885d2                   test     rdx, rdx
0x000081DF: 7410                     je       0x1800081f1
0x000081E1: 4d85c9                   test     r9, r9
0x000081E4: 7504                     jne      0x1800081ea
0x000081E6: 8819                     mov      byte ptr [rcx], bl
0x000081E8: ebe9                     jmp      0x1800081d3
0x000081EA: 4d85c0                   test     r8, r8
0x000081ED: 751b                     jne      0x18000820a
0x000081EF: 8819                     mov      byte ptr [rcx], bl
0x000081F1: e896a4ffff               call     0x18000268c
0x000081F6: bb16000000               mov      ebx, 0x16
0x000081FB: 8918                     mov      dword ptr [rax], ebx
0x000081FD: e8a2b6ffff               call     0x1800038a4
0x00008202: 8bc3                     mov      eax, ebx
0x00008204: 4883c420                 add      rsp, 0x20
0x00008208: 5b                       pop      rbx
0x00008209: c3                       ret      
0x0000820A: 4c8bd9                   mov      r11, rcx
0x0000820D: 4c8bd2                   mov      r10, rdx
0x00008210: 4983f9ff                 cmp      r9, -1
0x00008214: 7518                     jne      0x18000822e
0x00008216: 4d2bd8                   sub      r11, r8
0x00008219: 418a00                   mov      al, byte ptr [r8]
0x0000821C: 43880403                 mov      byte ptr [r11 + r8], al
0x00008220: 49ffc0                   inc      r8
0x00008223: 84c0                     test     al, al
0x00008225: 742a                     je       0x180008251
0x00008227: 49ffca                   dec      r10
0x0000822A: 75ed                     jne      0x180008219
0x0000822C: eb23                     jmp      0x180008251
0x0000822E: 4c2bc1                   sub      r8, rcx
0x00008231: 438a0418                 mov      al, byte ptr [r8 + r11]
0x00008235: 418803                   mov      byte ptr [r11], al
0x00008238: 49ffc3                   inc      r11
0x0000823B: 84c0                     test     al, al
0x0000823D: 740a                     je       0x180008249
0x0000823F: 49ffca                   dec      r10
0x00008242: 7405                     je       0x180008249
0x00008244: 49ffc9                   dec      r9
0x00008247: 75e8                     jne      0x180008231
0x00008249: 4d85c9                   test     r9, r9
0x0000824C: 7503                     jne      0x180008251
0x0000824E: 41881b                   mov      byte ptr [r11], bl
0x00008251: 4d85d2                   test     r10, r10
0x00008254: 0f8579ffffff             jne      0x1800081d3
0x0000825A: 4983f9ff                 cmp      r9, -1
0x0000825E: 750a                     jne      0x18000826a
0x00008260: 885c11ff                 mov      byte ptr [rcx + rdx - 1], bl
0x00008264: 418d4250                 lea      eax, [r10 + 0x50]
0x00008268: eb9a                     jmp      0x180008204
0x0000826A: 8819                     mov      byte ptr [rcx], bl
0x0000826C: e81ba4ffff               call     0x18000268c
0x00008271: bb22000000               mov      ebx, 0x22
0x00008276: eb83                     jmp      0x1800081fb
0x00008278: 488bc4                   mov      rax, rsp
0x0000827B: 48895808                 mov      qword ptr [rax + 8], rbx
0x0000827F: 48896810                 mov      qword ptr [rax + 0x10], rbp
0x00008283: 48897018                 mov      qword ptr [rax + 0x18], rsi
0x00008287: 48897820                 mov      qword ptr [rax + 0x20], rdi
0x0000828B: 4156                     push     r14
0x0000828D: 4883ec20                 sub      rsp, 0x20
0x00008291: 488be9                   mov      rbp, rcx
0x00008294: 33ff                     xor      edi, edi
0x00008296: bee3000000               mov      esi, 0xe3
0x0000829B: 4c8d357e9d0000           lea      r14, [rip + 0x9d7e]
0x000082A2: 8d043e                   lea      eax, [rsi + rdi]
0x000082A5: 41b855000000             mov      r8d, 0x55
0x000082AB: 488bcd                   mov      rcx, rbp
0x000082AE: 99                       cdq      
0x000082AF: 2bc2                     sub      eax, edx
0x000082B1: d1f8                     sar      eax, 1
0x000082B3: 4863d8                   movsxd   rbx, eax
0x000082B6: 488bd3                   mov      rdx, rbx
0x000082B9: 4803d2                   add      rdx, rdx
0x000082BC: 498b14d6                 mov      rdx, qword ptr [r14 + rdx*8]
0x000082C0: e893010000               call     0x180008458
0x000082C5: 85c0                     test     eax, eax
0x000082C7: 7413                     je       0x1800082dc
0x000082C9: 7905                     jns      0x1800082d0
0x000082CB: 8d73ff                   lea      esi, [rbx - 1]
0x000082CE: eb03                     jmp      0x1800082d3
0x000082D0: 8d7b01                   lea      edi, [rbx + 1]
0x000082D3: 3bfe                     cmp      edi, esi
0x000082D5: 7ecb                     jle      0x1800082a2
0x000082D7: 83c8ff                   or       eax, 0xffffffff
0x000082DA: eb0b                     jmp      0x1800082e7
0x000082DC: 488bc3                   mov      rax, rbx
0x000082DF: 4803c0                   add      rax, rax
0x000082E2: 418b44c608               mov      eax, dword ptr [r14 + rax*8 + 8]
0x000082E7: 488b5c2430               mov      rbx, qword ptr [rsp + 0x30]
0x000082EC: 488b6c2438               mov      rbp, qword ptr [rsp + 0x38]
0x000082F1: 488b742440               mov      rsi, qword ptr [rsp + 0x40]
0x000082F6: 488b7c2448               mov      rdi, qword ptr [rsp + 0x48]
0x000082FB: 4883c420                 add      rsp, 0x20
0x000082FF: 415e                     pop      r14
0x00008301: c3                       ret      
0x00008302: cc                       int3     
0x00008303: cc                       int3     
0x00008304: 4c8bdc                   mov      r11, rsp
0x00008307: 49895b08                 mov      qword ptr [r11 + 8], rbx
0x0000830B: 49897310                 mov      qword ptr [r11 + 0x10], rsi
0x0000830F: 57                       push     rdi
0x00008310: 4883ec50                 sub      rsp, 0x50
0x00008314: 4c8b150d540100           mov      r10, qword ptr [rip + 0x1540d]
0x0000831B: 418bd9                   mov      ebx, r9d
0x0000831E: 498bf8                   mov      rdi, r8
0x00008321: 4c3315d8ec0000           xor      r10, qword ptr [rip + 0xecd8]
0x00008328: 8bf2                     mov      esi, edx
0x0000832A: 742a                     je       0x180008356
0x0000832C: 33c0                     xor      eax, eax
0x0000832E: 498943e8                 mov      qword ptr [r11 - 0x18], rax
0x00008332: 498943e0                 mov      qword ptr [r11 - 0x20], rax
0x00008336: 498943d8                 mov      qword ptr [r11 - 0x28], rax
0x0000833A: 8b842488000000           mov      eax, dword ptr [rsp + 0x88]
0x00008341: 89442428                 mov      dword ptr [rsp + 0x28], eax
0x00008345: 488b842480000000         mov      rax, qword ptr [rsp + 0x80]
0x0000834D: 498943c8                 mov      qword ptr [r11 - 0x38], rax
0x00008351: 41ffd2                   call     r10
0x00008354: eb2d                     jmp      0x180008383
0x00008356: e839000000               call     0x180008394
0x0000835B: 448bcb                   mov      r9d, ebx
0x0000835E: 4c8bc7                   mov      r8, rdi
0x00008361: 8bc8                     mov      ecx, eax
0x00008363: 8b842488000000           mov      eax, dword ptr [rsp + 0x88]
0x0000836A: 8bd6                     mov      edx, esi
0x0000836C: 89442428                 mov      dword ptr [rsp + 0x28], eax
0x00008370: 488b842480000000         mov      rax, qword ptr [rsp + 0x80]
0x00008378: 4889442420               mov      qword ptr [rsp + 0x20], rax
0x0000837D: e898572100               call     0x18021db1a
0x00008382: ce                       .byte    0xce
0x00008383: 488b5c2460               mov      rbx, qword ptr [rsp + 0x60]
0x00008388: 488b742468               mov      rsi, qword ptr [rsp + 0x68]
0x0000838D: 4883c450                 add      rsp, 0x50
0x00008391: 5f                       pop      rdi
0x00008392: c3                       ret      
0x00008393: cc                       int3     
0x00008394: 4883ec28                 sub      rsp, 0x28
0x00008398: 4885c9                   test     rcx, rcx
0x0000839B: 7422                     je       0x1800083bf
0x0000839D: e8d6feffff               call     0x180008278
0x000083A2: 85c0                     test     eax, eax
0x000083A4: 7819                     js       0x1800083bf
0x000083A6: 4898                     cdqe     
0x000083A8: 483de4000000             cmp      rax, 0xe4
0x000083AE: 730f                     jae      0x1800083bf
0x000083B0: 488d0d298e0000           lea      rcx, [rip + 0x8e29]
0x000083B7: 4803c0                   add      rax, rax
0x000083BA: 8b04c1                   mov      eax, dword ptr [rcx + rax*8]
0x000083BD: eb02                     jmp      0x1800083c1
0x000083BF: 33c0                     xor      eax, eax
0x000083C1: 4883c428                 add      rsp, 0x28
0x000083C5: c3                       ret      
0x000083C6: cc                       int3     
0x000083C7: cc                       int3     
0x000083C8: 4c8bdc                   mov      r11, rsp
0x000083CB: 49895b08                 mov      qword ptr [r11 + 8], rbx
0x000083CF: 49897310                 mov      qword ptr [r11 + 0x10], rsi
0x000083D3: 57                       push     rdi
0x000083D4: 4883ec50                 sub      rsp, 0x50
0x000083D8: 4c8b1581530100           mov      r10, qword ptr [rip + 0x15381]
0x000083DF: 418bd9                   mov      ebx, r9d
0x000083E2: 498bf8                   mov      rdi, r8
0x000083E5: 4c331514ec0000           xor      r10, qword ptr [rip + 0xec14]
0x000083EC: 8bf2                     mov      esi, edx
0x000083EE: 742a                     je       0x18000841a
0x000083F0: 33c0                     xor      eax, eax
0x000083F2: 498943e8                 mov      qword ptr [r11 - 0x18], rax
0x000083F6: 498943e0                 mov      qword ptr [r11 - 0x20], rax
0x000083FA: 498943d8                 mov      qword ptr [r11 - 0x28], rax
0x000083FE: 8b842488000000           mov      eax, dword ptr [rsp + 0x88]
0x00008405: 89442428                 mov      dword ptr [rsp + 0x28], eax
0x00008409: 488b842480000000         mov      rax, qword ptr [rsp + 0x80]
0x00008411: 498943c8                 mov      qword ptr [r11 - 0x38], rax
0x00008415: 41ffd2                   call     r10
0x00008418: eb2d                     jmp      0x180008447
0x0000841A: e875ffffff               call     0x180008394
0x0000841F: 448bcb                   mov      r9d, ebx
0x00008422: 4c8bc7                   mov      r8, rdi
0x00008425: 8bc8                     mov      ecx, eax
0x00008427: 8b842488000000           mov      eax, dword ptr [rsp + 0x88]
0x0000842E: 8bd6                     mov      edx, esi
0x00008430: 89442428                 mov      dword ptr [rsp + 0x28], eax
0x00008434: 488b842480000000         mov      rax, qword ptr [rsp + 0x80]
0x0000843C: 4889442420               mov      qword ptr [rsp + 0x20], rax
0x00008441: e8fafa1700               call     0x180187f40
0x00008446: 11488b                   adc      dword ptr [rax - 0x75], ecx
0x00008449: 5c                       pop      rsp
0x0000844A: 2460                     and      al, 0x60
0x0000844C: 488b742468               mov      rsi, qword ptr [rsp + 0x68]
0x00008451: 4883c450                 add      rsp, 0x50
0x00008455: 5f                       pop      rdi
0x00008456: c3                       ret      
0x00008457: cc                       int3     
0x00008458: 4533c9                   xor      r9d, r9d
0x0000845B: 4c8bd2                   mov      r10, rdx
0x0000845E: 4c8bd9                   mov      r11, rcx
0x00008461: 4d85c0                   test     r8, r8
0x00008464: 7443                     je       0x1800084a9
0x00008466: 4c2bda                   sub      r11, rdx
0x00008469: 430fb70c13               movzx    ecx, word ptr [r11 + r10]
0x0000846E: 8d41bf                   lea      eax, [rcx - 0x41]
0x00008471: 6683f819                 cmp      ax, 0x19
0x00008475: 7704                     ja       0x18000847b
0x00008477: 6683c120                 add      cx, 0x20
0x0000847B: 410fb712                 movzx    edx, word ptr [r10]
0x0000847F: 8d42bf                   lea      eax, [rdx - 0x41]
0x00008482: 6683f819                 cmp      ax, 0x19
0x00008486: 7704                     ja       0x18000848c
0x00008488: 6683c220                 add      dx, 0x20
0x0000848C: 4983c202                 add      r10, 2
0x00008490: 49ffc8                   dec      r8
0x00008493: 740a                     je       0x18000849f
0x00008495: 6685c9                   test     cx, cx
0x00008498: 7405                     je       0x18000849f
0x0000849A: 663bca                   cmp      cx, dx
0x0000849D: 74ca                     je       0x180008469
0x0000849F: 0fb7c2                   movzx    eax, dx
0x000084A2: 440fb7c9                 movzx    r9d, cx
0x000084A6: 442bc8                   sub      r9d, eax
0x000084A9: 418bc1                   mov      eax, r9d
0x000084AC: c3                       ret      
0x000084AD: cc                       int3     
0x000084AE: cc                       int3     
0x000084AF: cc                       int3     
0x000084B0: 4055                     push     rbp
0x000084B2: 4154                     push     r12
0x000084B4: 4155                     push     r13
0x000084B6: 4156                     push     r14
0x000084B8: 4157                     push     r15
0x000084BA: 4883ec50                 sub      rsp, 0x50
0x000084BE: 488d6c2440               lea      rbp, [rsp + 0x40]
0x000084C3: 48895d40                 mov      qword ptr [rbp + 0x40], rbx
0x000084C7: 48897548                 mov      qword ptr [rbp + 0x48], rsi
0x000084CB: 48897d50                 mov      qword ptr [rbp + 0x50], rdi
0x000084CF: 488b052aeb0000           mov      rax, qword ptr [rip + 0xeb2a]
0x000084D6: 4833c5                   xor      rax, rbp
0x000084D9: 48894508                 mov      qword ptr [rbp + 8], rax
0x000084DD: 8b5d60                   mov      ebx, dword ptr [rbp + 0x60]
0x000084E0: 33ff                     xor      edi, edi
0x000084E2: 4d8be1                   mov      r12, r9
0x000084E5: 458be8                   mov      r13d, r8d
0x000084E8: 48895500                 mov      qword ptr [rbp], rdx
0x000084EC: 85db                     test     ebx, ebx
0x000084EE: 7e2a                     jle      0x18000851a
0x000084F0: 448bd3                   mov      r10d, ebx
0x000084F3: 498bc1                   mov      rax, r9
0x000084F6: 41ffca                   dec      r10d
0x000084F9: 403838                   cmp      byte ptr [rax], dil
0x000084FC: 740c                     je       0x18000850a
0x000084FE: 48ffc0                   inc      rax
0x00008501: 4585d2                   test     r10d, r10d
0x00008504: 75f0                     jne      0x1800084f6
0x00008506: 4183caff                 or       r10d, 0xffffffff
0x0000850A: 8bc3                     mov      eax, ebx
0x0000850C: 412bc2                   sub      eax, r10d
0x0000850F: ffc8                     dec      eax
0x00008511: 3bc3                     cmp      eax, ebx
0x00008513: 8d5801                   lea      ebx, [rax + 1]
0x00008516: 7c02                     jl       0x18000851a
0x00008518: 8bd8                     mov      ebx, eax
0x0000851A: 448b7578                 mov      r14d, dword ptr [rbp + 0x78]
0x0000851E: 8bf7                     mov      esi, edi
0x00008520: 4585f6                   test     r14d, r14d
0x00008523: 7507                     jne      0x18000852c
0x00008525: 488b01                   mov      rax, qword ptr [rcx]
0x00008528: 448b7004                 mov      r14d, dword ptr [rax + 4]
0x0000852C: f79d80000000             neg      dword ptr [rbp + 0x80]
0x00008532: 448bcb                   mov      r9d, ebx
0x00008535: 4d8bc4                   mov      r8, r12
0x00008538: 1bd2                     sbb      edx, edx
0x0000853A: 418bce                   mov      ecx, r14d
0x0000853D: 897c2428                 mov      dword ptr [rsp + 0x28], edi
0x00008541: 83e208                   and      edx, 8
0x00008544: 48897c2420               mov      qword ptr [rsp + 0x20], rdi
0x00008549: ffc2                     inc      edx
0x0000854B: 57                       push     rdi
0x0000854C: e881f20100               call     0x1800277d2
0x00008551: 4c63f8                   movsxd   r15, eax
0x00008554: 85c0                     test     eax, eax
0x00008556: 7507                     jne      0x18000855f
0x00008558: 33c0                     xor      eax, eax
0x0000855A: e917020000               jmp      0x180008776
0x0000855F: 49b9f0ffffffffffff0f     movabs   r9, 0xffffffffffffff0
0x00008569: 85c0                     test     eax, eax
0x0000856B: 7e6e                     jle      0x1800085db
0x0000856D: 33d2                     xor      edx, edx
0x0000856F: 488d42e0                 lea      rax, [rdx - 0x20]
0x00008573: 49f7f7                   div      r15
0x00008576: 4883f802                 cmp      rax, 2
0x0000857A: 725f                     jb       0x1800085db
0x0000857C: 4b8d0c3f                 lea      rcx, [r15 + r15]
0x00008580: 488d4110                 lea      rax, [rcx + 0x10]
0x00008584: 483bc1                   cmp      rax, rcx
0x00008587: 7652                     jbe      0x1800085db
0x00008589: 4a8d0c7d10000000         lea      rcx, [r15*2 + 0x10]
0x00008591: 4881f900040000           cmp      rcx, 0x400
0x00008598: 772a                     ja       0x1800085c4
0x0000859A: 488d410f                 lea      rax, [rcx + 0xf]
0x0000859E: 483bc1                   cmp      rax, rcx
0x000085A1: 7703                     ja       0x1800085a6
0x000085A3: 498bc1                   mov      rax, r9
0x000085A6: 4883e0f0                 and      rax, 0xfffffffffffffff0
0x000085AA: e8d10d0000               call     0x180009380
0x000085AF: 482be0                   sub      rsp, rax
0x000085B2: 488d7c2440               lea      rdi, [rsp + 0x40]
0x000085B7: 4885ff                   test     rdi, rdi
0x000085BA: 749c                     je       0x180008558
0x000085BC: c707cccc0000             mov      dword ptr [rdi], 0xcccc
0x000085C2: eb13                     jmp      0x1800085d7
0x000085C4: e8a792ffff               call     0x180001870
0x000085C9: 488bf8                   mov      rdi, rax
0x000085CC: 4885c0                   test     rax, rax
0x000085CF: 740a                     je       0x1800085db
0x000085D1: c700dddd0000             mov      dword ptr [rax], 0xdddd
0x000085D7: 4883c710                 add      rdi, 0x10
0x000085DB: 4885ff                   test     rdi, rdi
0x000085DE: 0f8474ffffff             je       0x180008558
0x000085E4: 448bcb                   mov      r9d, ebx
0x000085E7: 4d8bc4                   mov      r8, r12
0x000085EA: ba01000000               mov      edx, 1
0x000085EF: 418bce                   mov      ecx, r14d
0x000085F2: 44897c2428               mov      dword ptr [rsp + 0x28], r15d
0x000085F7: 48897c2420               mov      qword ptr [rsp + 0x20], rdi
0x000085FC: 52                       push     rdx
0x000085FD: e85a531e00               call     0x1801ed95c
0x00008602: 85c0                     test     eax, eax
0x00008604: 0f8459010000             je       0x180008763
0x0000860A: 4c8b6500                 mov      r12, qword ptr [rbp]
0x0000860E: 21742428                 and      dword ptr [rsp + 0x28], esi
0x00008612: 4821742420               and      qword ptr [rsp + 0x20], rsi
0x00008617: 498bcc                   mov      rcx, r12
0x0000861A: 458bcf                   mov      r9d, r15d
0x0000861D: 4c8bc7                   mov      r8, rdi
0x00008620: 418bd5                   mov      edx, r13d
0x00008623: e8a0fdffff               call     0x1800083c8
0x00008628: 4863f0                   movsxd   rsi, eax
0x0000862B: 85c0                     test     eax, eax
0x0000862D: 0f8430010000             je       0x180008763
0x00008633: 41b900040000             mov      r9d, 0x400
0x00008639: 4585e9                   test     r9d, r13d
0x0000863C: 7436                     je       0x180008674
0x0000863E: 8b4d70                   mov      ecx, dword ptr [rbp + 0x70]
0x00008641: 85c9                     test     ecx, ecx
0x00008643: 0f841a010000             je       0x180008763
0x00008649: 3bf1                     cmp      esi, ecx
0x0000864B: 0f8f12010000             jg       0x180008763
0x00008651: 488b4568                 mov      rax, qword ptr [rbp + 0x68]
0x00008655: 894c2428                 mov      dword ptr [rsp + 0x28], ecx
0x00008659: 458bcf                   mov      r9d, r15d
0x0000865C: 4c8bc7                   mov      r8, rdi
0x0000865F: 418bd5                   mov      edx, r13d
0x00008662: 498bcc                   mov      rcx, r12
0x00008665: 4889442420               mov      qword ptr [rsp + 0x20], rax
0x0000866A: e859fdffff               call     0x1800083c8
0x0000866F: e9ef000000               jmp      0x180008763
0x00008674: 85c0                     test     eax, eax
0x00008676: 7e77                     jle      0x1800086ef
0x00008678: 33d2                     xor      edx, edx
0x0000867A: 488d42e0                 lea      rax, [rdx - 0x20]
0x0000867E: 48f7f6                   div      rsi
0x00008681: 4883f802                 cmp      rax, 2
0x00008685: 7268                     jb       0x1800086ef
0x00008687: 488d0c36                 lea      rcx, [rsi + rsi]
0x0000868B: 488d4110                 lea      rax, [rcx + 0x10]
0x0000868F: 483bc1                   cmp      rax, rcx
0x00008692: 765b                     jbe      0x1800086ef
0x00008694: 488d0c7510000000         lea      rcx, [rsi*2 + 0x10]
0x0000869C: 493bc9                   cmp      rcx, r9
0x0000869F: 7735                     ja       0x1800086d6
0x000086A1: 488d410f                 lea      rax, [rcx + 0xf]
0x000086A5: 483bc1                   cmp      rax, rcx
0x000086A8: 770a                     ja       0x1800086b4
0x000086AA: 48b8f0ffffffffffff0f     movabs   rax, 0xffffffffffffff0
0x000086B4: 4883e0f0                 and      rax, 0xfffffffffffffff0
0x000086B8: e8c30c0000               call     0x180009380
0x000086BD: 482be0                   sub      rsp, rax
0x000086C0: 488d5c2440               lea      rbx, [rsp + 0x40]
0x000086C5: 4885db                   test     rbx, rbx
0x000086C8: 0f8495000000             je       0x180008763
0x000086CE: c703cccc0000             mov      dword ptr [rbx], 0xcccc
0x000086D4: eb13                     jmp      0x1800086e9
0x000086D6: e89591ffff               call     0x180001870
0x000086DB: 488bd8                   mov      rbx, rax
0x000086DE: 4885c0                   test     rax, rax
0x000086E1: 740e                     je       0x1800086f1
0x000086E3: c700dddd0000             mov      dword ptr [rax], 0xdddd
0x000086E9: 4883c310                 add      rbx, 0x10
0x000086ED: eb02                     jmp      0x1800086f1
0x000086EF: 33db                     xor      ebx, ebx
0x000086F1: 4885db                   test     rbx, rbx
0x000086F4: 746d                     je       0x180008763
0x000086F6: 458bcf                   mov      r9d, r15d
0x000086F9: 4c8bc7                   mov      r8, rdi
0x000086FC: 418bd5                   mov      edx, r13d
0x000086FF: 498bcc                   mov      rcx, r12
0x00008702: 89742428                 mov      dword ptr [rsp + 0x28], esi
0x00008706: 48895c2420               mov      qword ptr [rsp + 0x20], rbx
0x0000870B: e8b8fcffff               call     0x1800083c8
0x00008710: 33c9                     xor      ecx, ecx
0x00008712: 85c0                     test     eax, eax
0x00008714: 743c                     je       0x180008752
0x00008716: 8b4570                   mov      eax, dword ptr [rbp + 0x70]
0x00008719: 33d2                     xor      edx, edx
0x0000871B: 48894c2438               mov      qword ptr [rsp + 0x38], rcx
0x00008720: 448bce                   mov      r9d, esi
0x00008723: 4c8bc3                   mov      r8, rbx
0x00008726: 48894c2430               mov      qword ptr [rsp + 0x30], rcx
0x0000872B: 85c0                     test     eax, eax
0x0000872D: 750b                     jne      0x18000873a
0x0000872F: 894c2428                 mov      dword ptr [rsp + 0x28], ecx
0x00008733: 48894c2420               mov      qword ptr [rsp + 0x20], rcx
0x00008738: eb0d                     jmp      0x180008747
0x0000873A: 89442428                 mov      dword ptr [rsp + 0x28], eax
0x0000873E: 488b4568                 mov      rax, qword ptr [rbp + 0x68]
0x00008742: 4889442420               mov      qword ptr [rsp + 0x20], rax
0x00008747: 418bce                   mov      ecx, r14d
0x0000874A: e8a8521700               call     0x18017d9f7
0x0000874F: b28b                     mov      dl, 0x8b
0x00008751: f0                       .byte    0xf0
0x00008752: 488d4bf0                 lea      rcx, [rbx - 0x10]
0x00008756: 8139dddd0000             cmp      dword ptr [rcx], 0xdddd
0x0000875C: 7505                     jne      0x180008763
0x0000875E: e8cd90ffff               call     0x180001830
0x00008763: 488d4ff0                 lea      rcx, [rdi - 0x10]
0x00008767: 8139dddd0000             cmp      dword ptr [rcx], 0xdddd
0x0000876D: 7505                     jne      0x180008774
0x0000876F: e8bc90ffff               call     0x180001830
0x00008774: 8bc6                     mov      eax, esi
0x00008776: 488b4d08                 mov      rcx, qword ptr [rbp + 8]
0x0000877A: 4833cd                   xor      rcx, rbp
0x0000877D: e88e90ffff               call     0x180001810
0x00008782: 488b5d40                 mov      rbx, qword ptr [rbp + 0x40]
0x00008786: 488b7548                 mov      rsi, qword ptr [rbp + 0x48]
0x0000878A: 488b7d50                 mov      rdi, qword ptr [rbp + 0x50]
0x0000878E: 488d6510                 lea      rsp, [rbp + 0x10]
0x00008792: 415f                     pop      r15
0x00008794: 415e                     pop      r14
0x00008796: 415d                     pop      r13
0x00008798: 415c                     pop      r12
0x0000879A: 5d                       pop      rbp
0x0000879B: c3                       ret      
0x0000879C: 48895c2408               mov      qword ptr [rsp + 8], rbx
0x000087A1: 4889742410               mov      qword ptr [rsp + 0x10], rsi
0x000087A6: 57                       push     rdi
0x000087A7: 4883ec70                 sub      rsp, 0x70
0x000087AB: 488bf2                   mov      rsi, rdx
0x000087AE: 488bd1                   mov      rdx, rcx
0x000087B1: 488d4c2450               lea      rcx, [rsp + 0x50]
0x000087B6: 498bd9                   mov      rbx, r9
0x000087B9: 418bf8                   mov      edi, r8d
0x000087BC: e8d7d8ffff               call     0x180006098
0x000087C1: 8b8424c0000000           mov      eax, dword ptr [rsp + 0xc0]
0x000087C8: 488d4c2450               lea      rcx, [rsp + 0x50]
0x000087CD: 4c8bcb                   mov      r9, rbx
0x000087D0: 89442440                 mov      dword ptr [rsp + 0x40], eax
0x000087D4: 8b8424b8000000           mov      eax, dword ptr [rsp + 0xb8]
0x000087DB: 448bc7                   mov      r8d, edi
0x000087DE: 89442438                 mov      dword ptr [rsp + 0x38], eax
0x000087E2: 8b8424b0000000           mov      eax, dword ptr [rsp + 0xb0]
0x000087E9: 488bd6                   mov      rdx, rsi
0x000087EC: 89442430                 mov      dword ptr [rsp + 0x30], eax
0x000087F0: 488b8424a8000000         mov      rax, qword ptr [rsp + 0xa8]
0x000087F8: 4889442428               mov      qword ptr [rsp + 0x28], rax
0x000087FD: 8b8424a0000000           mov      eax, dword ptr [rsp + 0xa0]
0x00008804: 89442420                 mov      dword ptr [rsp + 0x20], eax
0x00008808: e8a3fcffff               call     0x1800084b0
0x0000880D: 807c246800               cmp      byte ptr [rsp + 0x68], 0
0x00008812: 740c                     je       0x180008820
0x00008814: 488b4c2460               mov      rcx, qword ptr [rsp + 0x60]
0x00008819: 83a1c8000000fd           and      dword ptr [rcx + 0xc8], 0xfffffffd
0x00008820: 4c8d5c2470               lea      r11, [rsp + 0x70]
0x00008825: 498b5b10                 mov      rbx, qword ptr [r11 + 0x10]
0x00008829: 498b7318                 mov      rsi, qword ptr [r11 + 0x18]
0x0000882D: 498be3                   mov      rsp, r11
0x00008830: 5f                       pop      rdi
0x00008831: c3                       ret      
0x00008832: cc                       int3     
0x00008833: cc                       int3     
0x00008834: 4055                     push     rbp
0x00008836: 4154                     push     r12
0x00008838: 4155                     push     r13
0x0000883A: 4156                     push     r14
0x0000883C: 4157                     push     r15
0x0000883E: 4883ec40                 sub      rsp, 0x40
0x00008842: 488d6c2430               lea      rbp, [rsp + 0x30]
0x00008847: 48895d40                 mov      qword ptr [rbp + 0x40], rbx
0x0000884B: 48897548                 mov      qword ptr [rbp + 0x48], rsi
0x0000884F: 48897d50                 mov      qword ptr [rbp + 0x50], rdi
0x00008853: 488b05a6e70000           mov      rax, qword ptr [rip + 0xe7a6]
0x0000885A: 4833c5                   xor      rax, rbp
0x0000885D: 48894500                 mov      qword ptr [rbp], rax
0x00008861: 448b7568                 mov      r14d, dword ptr [rbp + 0x68]
0x00008865: 33ff                     xor      edi, edi
0x00008867: 458bf9                   mov      r15d, r9d
0x0000886A: 4d8be0                   mov      r12, r8
0x0000886D: 448bea                   mov      r13d, edx
0x00008870: 4585f6                   test     r14d, r14d
0x00008873: 7507                     jne      0x18000887c
0x00008875: 488b01                   mov      rax, qword ptr [rcx]
0x00008878: 448b7004                 mov      r14d, dword ptr [rax + 4]
0x0000887C: f75d70                   neg      dword ptr [rbp + 0x70]
0x0000887F: 418bce                   mov      ecx, r14d
0x00008882: 897c2428                 mov      dword ptr [rsp + 0x28], edi
0x00008886: 1bd2                     sbb      edx, edx
0x00008888: 48897c2420               mov      qword ptr [rsp + 0x20], rdi
0x0000888D: 83e208                   and      edx, 8
0x00008890: ffc2                     inc      edx
0x00008892: 52                       push     rdx
0x00008893: e845411a00               call     0x1801ac9dd
0x00008898: 4863f0                   movsxd   rsi, eax
0x0000889B: 85c0                     test     eax, eax
0x0000889D: 7507                     jne      0x1800088a6
0x0000889F: 33c0                     xor      eax, eax
0x000088A1: e9de000000               jmp      0x180008984
0x000088A6: 7e77                     jle      0x18000891f
0x000088A8: 48b8f0ffffffffffff7f     movabs   rax, 0x7ffffffffffffff0
0x000088B2: 483bf0                   cmp      rsi, rax
0x000088B5: 7768                     ja       0x18000891f
0x000088B7: 488d0c36                 lea      rcx, [rsi + rsi]
0x000088BB: 488d4110                 lea      rax, [rcx + 0x10]
0x000088BF: 483bc1                   cmp      rax, rcx
0x000088C2: 765b                     jbe      0x18000891f
0x000088C4: 488d0c7510000000         lea      rcx, [rsi*2 + 0x10]
0x000088CC: 4881f900040000           cmp      rcx, 0x400
0x000088D3: 7731                     ja       0x180008906
0x000088D5: 488d410f                 lea      rax, [rcx + 0xf]
0x000088D9: 483bc1                   cmp      rax, rcx
0x000088DC: 770a                     ja       0x1800088e8
0x000088DE: 48b8f0ffffffffffff0f     movabs   rax, 0xffffffffffffff0
0x000088E8: 4883e0f0                 and      rax, 0xfffffffffffffff0
0x000088EC: e88f0a0000               call     0x180009380
0x000088F1: 482be0                   sub      rsp, rax
0x000088F4: 488d5c2430               lea      rbx, [rsp + 0x30]
0x000088F9: 4885db                   test     rbx, rbx
0x000088FC: 74a1                     je       0x18000889f
0x000088FE: c703cccc0000             mov      dword ptr [rbx], 0xcccc
0x00008904: eb13                     jmp      0x180008919
0x00008906: e8658fffff               call     0x180001870
0x0000890B: 488bd8                   mov      rbx, rax
0x0000890E: 4885c0                   test     rax, rax
0x00008911: 740f                     je       0x180008922
0x00008913: c700dddd0000             mov      dword ptr [rax], 0xdddd
0x00008919: 4883c310                 add      rbx, 0x10
0x0000891D: eb03                     jmp      0x180008922
0x0000891F: 488bdf                   mov      rbx, rdi
0x00008922: 4885db                   test     rbx, rbx
0x00008925: 0f8474ffffff             je       0x18000889f
0x0000892B: 4c8bc6                   mov      r8, rsi
0x0000892E: 33d2                     xor      edx, edx
0x00008930: 488bcb                   mov      rcx, rbx
0x00008933: 4d03c0                   add      r8, r8
0x00008936: e89599ffff               call     0x1800022d0
0x0000893B: 458bcf                   mov      r9d, r15d
0x0000893E: 4d8bc4                   mov      r8, r12
0x00008941: ba01000000               mov      edx, 1
0x00008946: 418bce                   mov      ecx, r14d
0x00008949: 89742428                 mov      dword ptr [rsp + 0x28], esi
0x0000894D: 48895c2420               mov      qword ptr [rsp + 0x20], rbx
0x00008952: 50                       push     rax
0x00008953: e8e84d1000               call     0x18010d740
0x00008958: 85c0                     test     eax, eax
0x0000895A: 7415                     je       0x180008971
0x0000895C: 4c8b4d60                 mov      r9, qword ptr [rbp + 0x60]
0x00008960: 448bc0                   mov      r8d, eax
0x00008963: 488bd3                   mov      rdx, rbx
0x00008966: 418bcd                   mov      ecx, r13d
0x00008969: e881d10c00               call     0x1800d5aef
0x0000896E: 7d8b                     jge      0x1800088fb
0x00008970: f8                       clc      
0x00008971: 488d4bf0                 lea      rcx, [rbx - 0x10]
0x00008975: 8139dddd0000             cmp      dword ptr [rcx], 0xdddd
0x0000897B: 7505                     jne      0x180008982
0x0000897D: e8ae8effff               call     0x180001830
0x00008982: 8bc7                     mov      eax, edi
0x00008984: 488b4d00                 mov      rcx, qword ptr [rbp]
0x00008988: 4833cd                   xor      rcx, rbp
0x0000898B: e8808effff               call     0x180001810
0x00008990: 488b5d40                 mov      rbx, qword ptr [rbp + 0x40]
0x00008994: 488b7548                 mov      rsi, qword ptr [rbp + 0x48]
0x00008998: 488b7d50                 mov      rdi, qword ptr [rbp + 0x50]
0x0000899C: 488d6510                 lea      rsp, [rbp + 0x10]
0x000089A0: 415f                     pop      r15
0x000089A2: 415e                     pop      r14
0x000089A4: 415d                     pop      r13
0x000089A6: 415c                     pop      r12
0x000089A8: 5d                       pop      rbp
0x000089A9: c3                       ret      
0x000089AA: cc                       int3     
0x000089AB: cc                       int3     
0x000089AC: 48895c2408               mov      qword ptr [rsp + 8], rbx
0x000089B1: 4889742410               mov      qword ptr [rsp + 0x10], rsi
0x000089B6: 57                       push     rdi
0x000089B7: 4883ec60                 sub      rsp, 0x60
0x000089BB: 8bf2                     mov      esi, edx
0x000089BD: 488bd1                   mov      rdx, rcx
0x000089C0: 488d4c2440               lea      rcx, [rsp + 0x40]
0x000089C5: 418bd9                   mov      ebx, r9d
0x000089C8: 498bf8                   mov      rdi, r8
0x000089CB: e8c8d6ffff               call     0x180006098
0x000089D0: 8b8424a0000000           mov      eax, dword ptr [rsp + 0xa0]
0x000089D7: 488d4c2440               lea      rcx, [rsp + 0x40]
0x000089DC: 448bcb                   mov      r9d, ebx
0x000089DF: 89442430                 mov      dword ptr [rsp + 0x30], eax
0x000089E3: 8b842498000000           mov      eax, dword ptr [rsp + 0x98]
0x000089EA: 4c8bc7                   mov      r8, rdi
0x000089ED: 89442428                 mov      dword ptr [rsp + 0x28], eax
0x000089F1: 488b842490000000         mov      rax, qword ptr [rsp + 0x90]
0x000089F9: 8bd6                     mov      edx, esi
0x000089FB: 4889442420               mov      qword ptr [rsp + 0x20], rax
0x00008A00: e82ffeffff               call     0x180008834
0x00008A05: 807c245800               cmp      byte ptr [rsp + 0x58], 0
0x00008A0A: 740c                     je       0x180008a18
0x00008A0C: 488b4c2450               mov      rcx, qword ptr [rsp + 0x50]
0x00008A11: 83a1c8000000fd           and      dword ptr [rcx + 0xc8], 0xfffffffd
0x00008A18: 488b5c2470               mov      rbx, qword ptr [rsp + 0x70]
0x00008A1D: 488b742478               mov      rsi, qword ptr [rsp + 0x78]
0x00008A22: 4883c460                 add      rsp, 0x60
0x00008A26: 5f                       pop      rdi
0x00008A27: c3                       ret      
0x00008A28: 4883ec28                 sub      rsp, 0x28
0x00008A2C: 4885c9                   test     rcx, rcx
0x00008A2F: 7515                     jne      0x180008a46
0x00008A31: e8569cffff               call     0x18000268c
0x00008A36: c70016000000             mov      dword ptr [rax], 0x16
0x00008A3C: e863aeffff               call     0x1800038a4
0x00008A41: 83c8ff                   or       eax, 0xffffffff
0x00008A44: eb03                     jmp      0x180008a49
0x00008A46: 8b411c                   mov      eax, dword ptr [rcx + 0x1c]
0x00008A49: 4883c428                 add      rsp, 0x28
0x00008A4D: c3                       ret      
0x00008A4E: cc                       int3     
0x00008A4F: cc                       int3     
0x00008A50: 4883ec28                 sub      rsp, 0x28
0x00008A54: 83f9fe                   cmp      ecx, -2
0x00008A57: 750d                     jne      0x180008a66
0x00008A59: e82e9cffff               call     0x18000268c
0x00008A5E: c70009000000             mov      dword ptr [rax], 9
0x00008A64: eb42                     jmp      0x180008aa8
0x00008A66: 85c9                     test     ecx, ecx
0x00008A68: 782e                     js       0x180008a98
0x00008A6A: 3b0d184d0100             cmp      ecx, dword ptr [rip + 0x14d18]
0x00008A70: 7326                     jae      0x180008a98
0x00008A72: 4863c9                   movsxd   rcx, ecx
0x00008A75: 488d1544090100           lea      rdx, [rip + 0x10944]
0x00008A7C: 488bc1                   mov      rax, rcx
0x00008A7F: 83e11f                   and      ecx, 0x1f
0x00008A82: 48c1f805                 sar      rax, 5
0x00008A86: 486bc958                 imul     rcx, rcx, 0x58
0x00008A8A: 488b04c2                 mov      rax, qword ptr [rdx + rax*8]
0x00008A8E: 0fbe440808               movsx    eax, byte ptr [rax + rcx + 8]
0x00008A93: 83e040                   and      eax, 0x40
0x00008A96: eb12                     jmp      0x180008aaa
0x00008A98: e8ef9bffff               call     0x18000268c
0x00008A9D: c70009000000             mov      dword ptr [rax], 9
0x00008AA3: e8fcadffff               call     0x1800038a4
0x00008AA8: 33c0                     xor      eax, eax
0x00008AAA: 4883c428                 add      rsp, 0x28
0x00008AAE: c3                       ret      
0x00008AAF: cc                       int3     
0x00008AB0: 4053                     push     rbx
0x00008AB2: 4883ec20                 sub      rsp, 0x20
0x00008AB6: 488bd9                   mov      rbx, rcx
0x00008AB9: 4885c9                   test     rcx, rcx
0x00008ABC: 750a                     jne      0x180008ac8
0x00008ABE: 4883c420                 add      rsp, 0x20
0x00008AC2: 5b                       pop      rbx
0x00008AC3: e9bc000000               jmp      0x180008b84
0x00008AC8: e82f000000               call     0x180008afc
0x00008ACD: 85c0                     test     eax, eax
0x00008ACF: 7405                     je       0x180008ad6
0x00008AD1: 83c8ff                   or       eax, 0xffffffff
0x00008AD4: eb20                     jmp      0x180008af6
0x00008AD6: f7431800400000           test     dword ptr [rbx + 0x18], 0x4000
0x00008ADD: 7415                     je       0x180008af4
0x00008ADF: 488bcb                   mov      rcx, rbx
0x00008AE2: e841ffffff               call     0x180008a28
0x00008AE7: 8bc8                     mov      ecx, eax
0x00008AE9: e8e2080000               call     0x1800093d0
0x00008AEE: f7d8                     neg      eax
0x00008AF0: 1bc0                     sbb      eax, eax
0x00008AF2: eb02                     jmp      0x180008af6
0x00008AF4: 33c0                     xor      eax, eax
0x00008AF6: 4883c420                 add      rsp, 0x20
0x00008AFA: 5b                       pop      rbx
0x00008AFB: c3                       ret      
0x00008AFC: 48895c2408               mov      qword ptr [rsp + 8], rbx
0x00008B01: 4889742410               mov      qword ptr [rsp + 0x10], rsi
0x00008B06: 57                       push     rdi
0x00008B07: 4883ec20                 sub      rsp, 0x20
0x00008B0B: 8b4118                   mov      eax, dword ptr [rcx + 0x18]
0x00008B0E: 33f6                     xor      esi, esi
0x00008B10: 488bd9                   mov      rbx, rcx
0x00008B13: 2403                     and      al, 3
0x00008B15: 3c02                     cmp      al, 2
0x00008B17: 753f                     jne      0x180008b58
0x00008B19: f7411808010000           test     dword ptr [rcx + 0x18], 0x108
0x00008B20: 7436                     je       0x180008b58
0x00008B22: 8b39                     mov      edi, dword ptr [rcx]
0x00008B24: 2b7910                   sub      edi, dword ptr [rcx + 0x10]
0x00008B27: 85ff                     test     edi, edi
0x00008B29: 7e2d                     jle      0x180008b58
0x00008B2B: e8f8feffff               call     0x180008a28
0x00008B30: 488b5310                 mov      rdx, qword ptr [rbx + 0x10]
0x00008B34: 448bc7                   mov      r8d, edi
0x00008B37: 8bc8                     mov      ecx, eax
0x00008B39: e86a090000               call     0x1800094a8
0x00008B3E: 3bc7                     cmp      eax, edi
0x00008B40: 750f                     jne      0x180008b51
0x00008B42: 8b4318                   mov      eax, dword ptr [rbx + 0x18]
0x00008B45: 84c0                     test     al, al
0x00008B47: 790f                     jns      0x180008b58
0x00008B49: 83e0fd                   and      eax, 0xfffffffd
0x00008B4C: 894318                   mov      dword ptr [rbx + 0x18], eax
0x00008B4F: eb07                     jmp      0x180008b58
0x00008B51: 834b1820                 or       dword ptr [rbx + 0x18], 0x20
0x00008B55: 83ceff                   or       esi, 0xffffffff
0x00008B58: 488b4b10                 mov      rcx, qword ptr [rbx + 0x10]
0x00008B5C: 83630800                 and      dword ptr [rbx + 8], 0
0x00008B60: 8bc6                     mov      eax, esi
0x00008B62: 488b742438               mov      rsi, qword ptr [rsp + 0x38]
0x00008B67: 48890b                   mov      qword ptr [rbx], rcx
0x00008B6A: 488b5c2430               mov      rbx, qword ptr [rsp + 0x30]
0x00008B6F: 4883c420                 add      rsp, 0x20
0x00008B73: 5f                       pop      rdi
0x00008B74: c3                       ret      
0x00008B75: cc                       int3     
0x00008B76: cc                       int3     
0x00008B77: cc                       int3     
0x00008B78: b901000000               mov      ecx, 1
0x00008B7D: e902000000               jmp      0x180008b84
0x00008B82: cc                       int3     
0x00008B83: cc                       int3     
0x00008B84: 48895c2408               mov      qword ptr [rsp + 8], rbx
0x00008B89: 4889742410               mov      qword ptr [rsp + 0x10], rsi
0x00008B8E: 48897c2418               mov      qword ptr [rsp + 0x18], rdi
0x00008B93: 4155                     push     r13
0x00008B95: 4156                     push     r14
0x00008B97: 4157                     push     r15
0x00008B99: 4883ec30                 sub      rsp, 0x30
0x00008B9D: 448bf1                   mov      r14d, ecx
0x00008BA0: 33f6                     xor      esi, esi
0x00008BA2: 33ff                     xor      edi, edi
0x00008BA4: 8d4e01                   lea      ecx, [rsi + 1]
0x00008BA7: e8f4ceffff               call     0x180005aa0
0x00008BAC: 90                       nop      
0x00008BAD: 33db                     xor      ebx, ebx
0x00008BAF: 4183cdff                 or       r13d, 0xffffffff
0x00008BB3: 895c2420                 mov      dword ptr [rsp + 0x20], ebx
0x00008BB7: 3b1d833a0100             cmp      ebx, dword ptr [rip + 0x13a83]
0x00008BBD: 7d7e                     jge      0x180008c3d
0x00008BBF: 4c63fb                   movsxd   r15, ebx
0x00008BC2: 488b056f3a0100           mov      rax, qword ptr [rip + 0x13a6f]
0x00008BC9: 4a8b14f8                 mov      rdx, qword ptr [rax + r15*8]
0x00008BCD: 4885d2                   test     rdx, rdx
0x00008BD0: 7464                     je       0x180008c36
0x00008BD2: f6421883                 test     byte ptr [rdx + 0x18], 0x83
0x00008BD6: 745e                     je       0x180008c36
0x00008BD8: 8bcb                     mov      ecx, ebx
0x00008BDA: e845f4ffff               call     0x180008024
0x00008BDF: 90                       nop      
0x00008BE0: 488b05513a0100           mov      rax, qword ptr [rip + 0x13a51]
0x00008BE7: 4a8b0cf8                 mov      rcx, qword ptr [rax + r15*8]
0x00008BEB: f6411883                 test     byte ptr [rcx + 0x18], 0x83
0x00008BEF: 7433                     je       0x180008c24
0x00008BF1: 4183fe01                 cmp      r14d, 1
0x00008BF5: 7512                     jne      0x180008c09
0x00008BF7: e8b4feffff               call     0x180008ab0
0x00008BFC: 413bc5                   cmp      eax, r13d
0x00008BFF: 7423                     je       0x180008c24
0x00008C01: ffc6                     inc      esi
0x00008C03: 89742424                 mov      dword ptr [rsp + 0x24], esi
0x00008C07: eb1b                     jmp      0x180008c24
0x00008C09: 4585f6                   test     r14d, r14d
0x00008C0C: 7516                     jne      0x180008c24
0x00008C0E: f6411802                 test     byte ptr [rcx + 0x18], 2
0x00008C12: 7410                     je       0x180008c24
0x00008C14: e897feffff               call     0x180008ab0
0x00008C19: 413bc5                   cmp      eax, r13d
0x00008C1C: 410f44fd                 cmove    edi, r13d
0x00008C20: 897c2428                 mov      dword ptr [rsp + 0x28], edi
0x00008C24: 488b150d3a0100           mov      rdx, qword ptr [rip + 0x13a0d]
0x00008C2B: 4a8b14fa                 mov      rdx, qword ptr [rdx + r15*8]
0x00008C2F: 8bcb                     mov      ecx, ebx
0x00008C31: e872f4ffff               call     0x1800080a8
0x00008C36: ffc3                     inc      ebx
0x00008C38: e976ffffff               jmp      0x180008bb3
0x00008C3D: b901000000               mov      ecx, 1
0x00008C42: e849d0ffff               call     0x180005c90
0x00008C47: 4183fe01                 cmp      r14d, 1
0x00008C4B: 0f44fe                   cmove    edi, esi
0x00008C4E: 8bc7                     mov      eax, edi
0x00008C50: 488b5c2450               mov      rbx, qword ptr [rsp + 0x50]
0x00008C55: 488b742458               mov      rsi, qword ptr [rsp + 0x58]
0x00008C5A: 488b7c2460               mov      rdi, qword ptr [rsp + 0x60]
0x00008C5F: 4883c430                 add      rsp, 0x30
0x00008C63: 415f                     pop      r15
0x00008C65: 415e                     pop      r14
0x00008C67: 415d                     pop      r13
0x00008C69: c3                       ret      
0x00008C6A: cc                       int3     
0x00008C6B: cc                       int3     
0x00008C6C: 33d2                     xor      edx, edx
0x00008C6E: 448d420a                 lea      r8d, [rdx + 0xa]
0x00008C72: e945130000               jmp      0x180009fbc
0x00008C77: cc                       int3     
0x00008C78: 48895c2408               mov      qword ptr [rsp + 8], rbx
0x00008C7D: 4889742410               mov      qword ptr [rsp + 0x10], rsi
0x00008C82: 57                       push     rdi
0x00008C83: 4883ec20                 sub      rsp, 0x20
0x00008C87: 833d264b010000           cmp      dword ptr [rip + 0x14b26], 0
0x00008C8E: 488b1d8b000100           mov      rbx, qword ptr [rip + 0x1008b]
0x00008C95: 488bf1                   mov      rsi, rcx
0x00008C98: 746e                     je       0x180008d08
0x00008C9A: 4885db                   test     rbx, rbx
0x00008C9D: 751e                     jne      0x180008cbd
0x00008C9F: 48391d82000100           cmp      qword ptr [rip + 0x10082], rbx
0x00008CA6: 7460                     je       0x180008d08
0x00008CA8: e83f130000               call     0x180009fec
0x00008CAD: 85c0                     test     eax, eax
0x00008CAF: 7557                     jne      0x180008d08
0x00008CB1: 488b1d68000100           mov      rbx, qword ptr [rip + 0x10068]
0x00008CB8: 4885db                   test     rbx, rbx
0x00008CBB: 744b                     je       0x180008d08
0x00008CBD: 4885f6                   test     rsi, rsi
0x00008CC0: 7446                     je       0x180008d08
0x00008CC2: 488bce                   mov      rcx, rsi
0x00008CC5: e836ddffff               call     0x180006a00
0x00008CCA: 488bf8                   mov      rdi, rax
0x00008CCD: 488b0b                   mov      rcx, qword ptr [rbx]
0x00008CD0: 4885c9                   test     rcx, rcx
0x00008CD3: 7433                     je       0x180008d08
0x00008CD5: e826ddffff               call     0x180006a00
0x00008CDA: 483bc7                   cmp      rax, rdi
0x00008CDD: 7618                     jbe      0x180008cf7
0x00008CDF: 488b0b                   mov      rcx, qword ptr [rbx]
0x00008CE2: 803c393d                 cmp      byte ptr [rcx + rdi], 0x3d
0x00008CE6: 750f                     jne      0x180008cf7
0x00008CE8: 4c8bc7                   mov      r8, rdi
0x00008CEB: 488bd6                   mov      rdx, rsi
0x00008CEE: e8ed130000               call     0x18000a0e0
0x00008CF3: 85c0                     test     eax, eax
0x00008CF5: 7406                     je       0x180008cfd
0x00008CF7: 4883c308                 add      rbx, 8
0x00008CFB: ebd0                     jmp      0x180008ccd
0x00008CFD: 488b03                   mov      rax, qword ptr [rbx]
0x00008D00: 48ffc0                   inc      rax
0x00008D03: 4803c7                   add      rax, rdi
0x00008D06: eb02                     jmp      0x180008d0a
0x00008D08: 33c0                     xor      eax, eax
0x00008D0A: 488b5c2430               mov      rbx, qword ptr [rsp + 0x30]
0x00008D0F: 488b742438               mov      rsi, qword ptr [rsp + 0x38]
0x00008D14: 4883c420                 add      rsp, 0x20
0x00008D18: 5f                       pop      rdi
0x00008D19: c3                       ret      
0x00008D1A: cc                       int3     
0x00008D1B: cc                       int3     
0x00008D1C: 4883ec28                 sub      rsp, 0x28
0x00008D20: e863b5ffff               call     0x180004288
0x00008D25: 488b88c0000000           mov      rcx, qword ptr [rax + 0xc0]
0x00008D2C: 483b0d9df00000           cmp      rcx, qword ptr [rip + 0xf09d]
0x00008D33: 7416                     je       0x180008d4b
0x00008D35: 8b80c8000000             mov      eax, dword ptr [rax + 0xc8]
0x00008D3B: 8505d3f50000             test     dword ptr [rip + 0xf5d3], eax
0x00008D41: 7508                     jne      0x180008d4b
0x00008D43: e8d0f0ffff               call     0x180007e18
0x00008D48: 488bc8                   mov      rcx, rax
0x00008D4B: 8b4104                   mov      eax, dword ptr [rcx + 4]
0x00008D4E: 4883c428                 add      rsp, 0x28
0x00008D52: c3                       ret      
0x00008D53: cc                       int3     
0x00008D54: 4885c9                   test     rcx, rcx
0x00008D57: 0f8400010000             je       0x180008e5d
0x00008D5D: 53                       push     rbx
0x00008D5E: 4883ec20                 sub      rsp, 0x20
0x00008D62: 488bd9                   mov      rbx, rcx
0x00008D65: 488b4918                 mov      rcx, qword ptr [rcx + 0x18]
0x00008D69: 483b0dc8f50000           cmp      rcx, qword ptr [rip + 0xf5c8]
0x00008D70: 7405                     je       0x180008d77
0x00008D72: e8b98affff               call     0x180001830
0x00008D77: 488b4b20                 mov      rcx, qword ptr [rbx + 0x20]
0x00008D7B: 483b0dbef50000           cmp      rcx, qword ptr [rip + 0xf5be]
0x00008D82: 7405                     je       0x180008d89
0x00008D84: e8a78affff               call     0x180001830
0x00008D89: 488b4b28                 mov      rcx, qword ptr [rbx + 0x28]
0x00008D8D: 483b0db4f50000           cmp      rcx, qword ptr [rip + 0xf5b4]
0x00008D94: 7405                     je       0x180008d9b
0x00008D96: e8958affff               call     0x180001830
0x00008D9B: 488b4b30                 mov      rcx, qword ptr [rbx + 0x30]
0x00008D9F: 483b0daaf50000           cmp      rcx, qword ptr [rip + 0xf5aa]
0x00008DA6: 7405                     je       0x180008dad
0x00008DA8: e8838affff               call     0x180001830
0x00008DAD: 488b4b38                 mov      rcx, qword ptr [rbx + 0x38]
0x00008DB1: 483b0da0f50000           cmp      rcx, qword ptr [rip + 0xf5a0]
0x00008DB8: 7405                     je       0x180008dbf
0x00008DBA: e8718affff               call     0x180001830
0x00008DBF: 488b4b40                 mov      rcx, qword ptr [rbx + 0x40]
0x00008DC3: 483b0d96f50000           cmp      rcx, qword ptr [rip + 0xf596]
0x00008DCA: 7405                     je       0x180008dd1
0x00008DCC: e85f8affff               call     0x180001830
0x00008DD1: 488b4b48                 mov      rcx, qword ptr [rbx + 0x48]
0x00008DD5: 483b0d8cf50000           cmp      rcx, qword ptr [rip + 0xf58c]
0x00008DDC: 7405                     je       0x180008de3
0x00008DDE: e84d8affff               call     0x180001830
0x00008DE3: 488b4b68                 mov      rcx, qword ptr [rbx + 0x68]
0x00008DE7: 483b0d9af50000           cmp      rcx, qword ptr [rip + 0xf59a]
0x00008DEE: 7405                     je       0x180008df5
0x00008DF0: e83b8affff               call     0x180001830
0x00008DF5: 488b4b70                 mov      rcx, qword ptr [rbx + 0x70]
0x00008DF9: 483b0d90f50000           cmp      rcx, qword ptr [rip + 0xf590]
0x00008E00: 7405                     je       0x180008e07
0x00008E02: e8298affff               call     0x180001830
0x00008E07: 488b4b78                 mov      rcx, qword ptr [rbx + 0x78]
0x00008E0B: 483b0d86f50000           cmp      rcx, qword ptr [rip + 0xf586]
0x00008E12: 7405                     je       0x180008e19
0x00008E14: e8178affff               call     0x180001830
0x00008E19: 488b8b80000000           mov      rcx, qword ptr [rbx + 0x80]
0x00008E20: 483b0d79f50000           cmp      rcx, qword ptr [rip + 0xf579]
0x00008E27: 7405                     je       0x180008e2e
0x00008E29: e8028affff               call     0x180001830
0x00008E2E: 488b8b88000000           mov      rcx, qword ptr [rbx + 0x88]
0x00008E35: 483b0d6cf50000           cmp      rcx, qword ptr [rip + 0xf56c]
0x00008E3C: 7405                     je       0x180008e43
0x00008E3E: e8ed89ffff               call     0x180001830
0x00008E43: 488b8b90000000           mov      rcx, qword ptr [rbx + 0x90]
0x00008E4A: 483b0d5ff50000           cmp      rcx, qword ptr [rip + 0xf55f]
0x00008E51: 7405                     je       0x180008e58
0x00008E53: e8d889ffff               call     0x180001830
0x00008E58: 4883c420                 add      rsp, 0x20
0x00008E5C: 5b                       pop      rbx
0x00008E5D: c3                       ret      
0x00008E5E: cc                       int3     
0x00008E5F: cc                       int3     
0x00008E60: 4885c9                   test     rcx, rcx
0x00008E63: 7466                     je       0x180008ecb
0x00008E65: 53                       push     rbx
0x00008E66: 4883ec20                 sub      rsp, 0x20
0x00008E6A: 488bd9                   mov      rbx, rcx
0x00008E6D: 488b09                   mov      rcx, qword ptr [rcx]
0x00008E70: 483b0da9f40000           cmp      rcx, qword ptr [rip + 0xf4a9]
0x00008E77: 7405                     je       0x180008e7e
0x00008E79: e8b289ffff               call     0x180001830
0x00008E7E: 488b4b08                 mov      rcx, qword ptr [rbx + 8]
0x00008E82: 483b0d9ff40000           cmp      rcx, qword ptr [rip + 0xf49f]
0x00008E89: 7405                     je       0x180008e90
0x00008E8B: e8a089ffff               call     0x180001830
0x00008E90: 488b4b10                 mov      rcx, qword ptr [rbx + 0x10]
0x00008E94: 483b0d95f40000           cmp      rcx, qword ptr [rip + 0xf495]
0x00008E9B: 7405                     je       0x180008ea2
0x00008E9D: e88e89ffff               call     0x180001830
0x00008EA2: 488b4b58                 mov      rcx, qword ptr [rbx + 0x58]
0x00008EA6: 483b0dcbf40000           cmp      rcx, qword ptr [rip + 0xf4cb]
0x00008EAD: 7405                     je       0x180008eb4
0x00008EAF: e87c89ffff               call     0x180001830
0x00008EB4: 488b4b60                 mov      rcx, qword ptr [rbx + 0x60]
0x00008EB8: 483b0dc1f40000           cmp      rcx, qword ptr [rip + 0xf4c1]
0x00008EBF: 7405                     je       0x180008ec6
0x00008EC1: e86a89ffff               call     0x180001830
0x00008EC6: 4883c420                 add      rsp, 0x20
0x00008ECA: 5b                       pop      rbx
0x00008ECB: c3                       ret      
0x00008ECC: 4885c9                   test     rcx, rcx
0x00008ECF: 0f84f0030000             je       0x1800092c5
0x00008ED5: 53                       push     rbx
0x00008ED6: 4883ec20                 sub      rsp, 0x20
0x00008EDA: 488bd9                   mov      rbx, rcx
0x00008EDD: 488b4908                 mov      rcx, qword ptr [rcx + 8]
0x00008EE1: e84a89ffff               call     0x180001830
0x00008EE6: 488b4b10                 mov      rcx, qword ptr [rbx + 0x10]
0x00008EEA: e84189ffff               call     0x180001830
0x00008EEF: 488b4b18                 mov      rcx, qword ptr [rbx + 0x18]
0x00008EF3: e83889ffff               call     0x180001830
0x00008EF8: 488b4b20                 mov      rcx, qword ptr [rbx + 0x20]
0x00008EFC: e82f89ffff               call     0x180001830
0x00008F01: 488b4b28                 mov      rcx, qword ptr [rbx + 0x28]
0x00008F05: e82689ffff               call     0x180001830
0x00008F0A: 488b4b30                 mov      rcx, qword ptr [rbx + 0x30]
0x00008F0E: e81d89ffff               call     0x180001830
0x00008F13: 488b0b                   mov      rcx, qword ptr [rbx]
0x00008F16: e81589ffff               call     0x180001830
0x00008F1B: 488b4b40                 mov      rcx, qword ptr [rbx + 0x40]
0x00008F1F: e80c89ffff               call     0x180001830
0x00008F24: 488b4b48                 mov      rcx, qword ptr [rbx + 0x48]
0x00008F28: e80389ffff               call     0x180001830
0x00008F2D: 488b4b50                 mov      rcx, qword ptr [rbx + 0x50]
0x00008F31: e8fa88ffff               call     0x180001830
0x00008F36: 488b4b58                 mov      rcx, qword ptr [rbx + 0x58]
0x00008F3A: e8f188ffff               call     0x180001830
0x00008F3F: 488b4b60                 mov      rcx, qword ptr [rbx + 0x60]
0x00008F43: e8e888ffff               call     0x180001830
0x00008F48: 488b4b68                 mov      rcx, qword ptr [rbx + 0x68]
0x00008F4C: e8df88ffff               call     0x180001830
0x00008F51: 488b4b38                 mov      rcx, qword ptr [rbx + 0x38]
0x00008F55: e8d688ffff               call     0x180001830
0x00008F5A: 488b4b70                 mov      rcx, qword ptr [rbx + 0x70]
0x00008F5E: e8cd88ffff               call     0x180001830
0x00008F63: 488b4b78                 mov      rcx, qword ptr [rbx + 0x78]
0x00008F67: e8c488ffff               call     0x180001830
0x00008F6C: 488b8b80000000           mov      rcx, qword ptr [rbx + 0x80]
0x00008F73: e8b888ffff               call     0x180001830
0x00008F78: 488b8b88000000           mov      rcx, qword ptr [rbx + 0x88]
0x00008F7F: e8ac88ffff               call     0x180001830
0x00008F84: 488b8b90000000           mov      rcx, qword ptr [rbx + 0x90]
0x00008F8B: e8a088ffff               call     0x180001830
0x00008F90: 488b8b98000000           mov      rcx, qword ptr [rbx + 0x98]
0x00008F97: e89488ffff               call     0x180001830
0x00008F9C: 488b8ba0000000           mov      rcx, qword ptr [rbx + 0xa0]
0x00008FA3: e88888ffff               call     0x180001830
0x00008FA8: 488b8ba8000000           mov      rcx, qword ptr [rbx + 0xa8]
0x00008FAF: e87c88ffff               call     0x180001830
0x00008FB4: 488b8bb0000000           mov      rcx, qword ptr [rbx + 0xb0]
0x00008FBB: e87088ffff               call     0x180001830
0x00008FC0: 488b8bb8000000           mov      rcx, qword ptr [rbx + 0xb8]
0x00008FC7: e86488ffff               call     0x180001830
0x00008FCC: 488b8bc0000000           mov      rcx, qword ptr [rbx + 0xc0]
0x00008FD3: e85888ffff               call     0x180001830
0x00008FD8: 488b8bc8000000           mov      rcx, qword ptr [rbx + 0xc8]
0x00008FDF: e84c88ffff               call     0x180001830
0x00008FE4: 488b8bd0000000           mov      rcx, qword ptr [rbx + 0xd0]
0x00008FEB: e84088ffff               call     0x180001830
0x00008FF0: 488b8bd8000000           mov      rcx, qword ptr [rbx + 0xd8]
0x00008FF7: e83488ffff               call     0x180001830
0x00008FFC: 488b8be0000000           mov      rcx, qword ptr [rbx + 0xe0]
0x00009003: e82888ffff               call     0x180001830
0x00009008: 488b8be8000000           mov      rcx, qword ptr [rbx + 0xe8]
0x0000900F: e81c88ffff               call     0x180001830
0x00009014: 488b8bf0000000           mov      rcx, qword ptr [rbx + 0xf0]
0x0000901B: e81088ffff               call     0x180001830
0x00009020: 488b8bf8000000           mov      rcx, qword ptr [rbx + 0xf8]
0x00009027: e80488ffff               call     0x180001830
0x0000902C: 488b8b00010000           mov      rcx, qword ptr [rbx + 0x100]
0x00009033: e8f887ffff               call     0x180001830
0x00009038: 488b8b08010000           mov      rcx, qword ptr [rbx + 0x108]
0x0000903F: e8ec87ffff               call     0x180001830
0x00009044: 488b8b10010000           mov      rcx, qword ptr [rbx + 0x110]
0x0000904B: e8e087ffff               call     0x180001830
0x00009050: 488b8b18010000           mov      rcx, qword ptr [rbx + 0x118]
0x00009057: e8d487ffff               call     0x180001830
0x0000905C: 488b8b20010000           mov      rcx, qword ptr [rbx + 0x120]
0x00009063: e8c887ffff               call     0x180001830
0x00009068: 488b8b28010000           mov      rcx, qword ptr [rbx + 0x128]
0x0000906F: e8bc87ffff               call     0x180001830
0x00009074: 488b8b30010000           mov      rcx, qword ptr [rbx + 0x130]
0x0000907B: e8b087ffff               call     0x180001830
0x00009080: 488b8b38010000           mov      rcx, qword ptr [rbx + 0x138]
0x00009087: e8a487ffff               call     0x180001830
0x0000908C: 488b8b40010000           mov      rcx, qword ptr [rbx + 0x140]
0x00009093: e89887ffff               call     0x180001830
0x00009098: 488b8b48010000           mov      rcx, qword ptr [rbx + 0x148]
0x0000909F: e88c87ffff               call     0x180001830
0x000090A4: 488b8b50010000           mov      rcx, qword ptr [rbx + 0x150]
0x000090AB: e88087ffff               call     0x180001830
0x000090B0: 488b8b68010000           mov      rcx, qword ptr [rbx + 0x168]
0x000090B7: e87487ffff               call     0x180001830
0x000090BC: 488b8b70010000           mov      rcx, qword ptr [rbx + 0x170]
0x000090C3: e86887ffff               call     0x180001830
0x000090C8: 488b8b78010000           mov      rcx, qword ptr [rbx + 0x178]
0x000090CF: e85c87ffff               call     0x180001830
0x000090D4: 488b8b80010000           mov      rcx, qword ptr [rbx + 0x180]
0x000090DB: e85087ffff               call     0x180001830
0x000090E0: 488b8b88010000           mov      rcx, qword ptr [rbx + 0x188]
0x000090E7: e84487ffff               call     0x180001830
0x000090EC: 488b8b90010000           mov      rcx, qword ptr [rbx + 0x190]
0x000090F3: e83887ffff               call     0x180001830
0x000090F8: 488b8b60010000           mov      rcx, qword ptr [rbx + 0x160]
0x000090FF: e82c87ffff               call     0x180001830
0x00009104: 488b8ba0010000           mov      rcx, qword ptr [rbx + 0x1a0]
0x0000910B: e82087ffff               call     0x180001830
0x00009110: 488b8ba8010000           mov      rcx, qword ptr [rbx + 0x1a8]
0x00009117: e81487ffff               call     0x180001830
0x0000911C: 488b8bb0010000           mov      rcx, qword ptr [rbx + 0x1b0]
0x00009123: e80887ffff               call     0x180001830
0x00009128: 488b8bb8010000           mov      rcx, qword ptr [rbx + 0x1b8]
0x0000912F: e8fc86ffff               call     0x180001830
0x00009134: 488b8bc0010000           mov      rcx, qword ptr [rbx + 0x1c0]
0x0000913B: e8f086ffff               call     0x180001830
0x00009140: 488b8bc8010000           mov      rcx, qword ptr [rbx + 0x1c8]
0x00009147: e8e486ffff               call     0x180001830
0x0000914C: 488b8b98010000           mov      rcx, qword ptr [rbx + 0x198]
0x00009153: e8d886ffff               call     0x180001830
0x00009158: 488b8bd0010000           mov      rcx, qword ptr [rbx + 0x1d0]
0x0000915F: e8cc86ffff               call     0x180001830
0x00009164: 488b8bd8010000           mov      rcx, qword ptr [rbx + 0x1d8]
0x0000916B: e8c086ffff               call     0x180001830
0x00009170: 488b8be0010000           mov      rcx, qword ptr [rbx + 0x1e0]
0x00009177: e8b486ffff               call     0x180001830
0x0000917C: 488b8be8010000           mov      rcx, qword ptr [rbx + 0x1e8]
0x00009183: e8a886ffff               call     0x180001830
0x00009188: 488b8bf0010000           mov      rcx, qword ptr [rbx + 0x1f0]
0x0000918F: e89c86ffff               call     0x180001830
0x00009194: 488b8bf8010000           mov      rcx, qword ptr [rbx + 0x1f8]
0x0000919B: e89086ffff               call     0x180001830
0x000091A0: 488b8b00020000           mov      rcx, qword ptr [rbx + 0x200]
0x000091A7: e88486ffff               call     0x180001830
0x000091AC: 488b8b08020000           mov      rcx, qword ptr [rbx + 0x208]
0x000091B3: e87886ffff               call     0x180001830
0x000091B8: 488b8b10020000           mov      rcx, qword ptr [rbx + 0x210]
0x000091BF: e86c86ffff               call     0x180001830
0x000091C4: 488b8b18020000           mov      rcx, qword ptr [rbx + 0x218]
0x000091CB: e86086ffff               call     0x180001830
0x000091D0: 488b8b20020000           mov      rcx, qword ptr [rbx + 0x220]
0x000091D7: e85486ffff               call     0x180001830
0x000091DC: 488b8b28020000           mov      rcx, qword ptr [rbx + 0x228]
0x000091E3: e84886ffff               call     0x180001830
0x000091E8: 488b8b30020000           mov      rcx, qword ptr [rbx + 0x230]
0x000091EF: e83c86ffff               call     0x180001830
0x000091F4: 488b8b38020000           mov      rcx, qword ptr [rbx + 0x238]
0x000091FB: e83086ffff               call     0x180001830
0x00009200: 488b8b40020000           mov      rcx, qword ptr [rbx + 0x240]
0x00009207: e82486ffff               call     0x180001830
0x0000920C: 488b8b48020000           mov      rcx, qword ptr [rbx + 0x248]
0x00009213: e81886ffff               call     0x180001830
0x00009218: 488b8b50020000           mov      rcx, qword ptr [rbx + 0x250]
0x0000921F: e80c86ffff               call     0x180001830
0x00009224: 488b8b58020000           mov      rcx, qword ptr [rbx + 0x258]
0x0000922B: e80086ffff               call     0x180001830
0x00009230: 488b8b60020000           mov      rcx, qword ptr [rbx + 0x260]
0x00009237: e8f485ffff               call     0x180001830
0x0000923C: 488b8b68020000           mov      rcx, qword ptr [rbx + 0x268]
0x00009243: e8e885ffff               call     0x180001830
0x00009248: 488b8b70020000           mov      rcx, qword ptr [rbx + 0x270]
0x0000924F: e8dc85ffff               call     0x180001830
0x00009254: 488b8b78020000           mov      rcx, qword ptr [rbx + 0x278]
0x0000925B: e8d085ffff               call     0x180001830
0x00009260: 488b8b80020000           mov      rcx, qword ptr [rbx + 0x280]
0x00009267: e8c485ffff               call     0x180001830
0x0000926C: 488b8b88020000           mov      rcx, qword ptr [rbx + 0x288]
0x00009273: e8b885ffff               call     0x180001830
0x00009278: 488b8b90020000           mov      rcx, qword ptr [rbx + 0x290]
0x0000927F: e8ac85ffff               call     0x180001830
0x00009284: 488b8b98020000           mov      rcx, qword ptr [rbx + 0x298]
0x0000928B: e8a085ffff               call     0x180001830
0x00009290: 488b8ba0020000           mov      rcx, qword ptr [rbx + 0x2a0]
0x00009297: e89485ffff               call     0x180001830
0x0000929C: 488b8ba8020000           mov      rcx, qword ptr [rbx + 0x2a8]
0x000092A3: e88885ffff               call     0x180001830
0x000092A8: 488b8bb0020000           mov      rcx, qword ptr [rbx + 0x2b0]
0x000092AF: e87c85ffff               call     0x180001830
0x000092B4: 488b8bb8020000           mov      rcx, qword ptr [rbx + 0x2b8]
0x000092BB: e87085ffff               call     0x180001830
0x000092C0: 4883c420                 add      rsp, 0x20
0x000092C4: 5b                       pop      rbx
0x000092C5: c3                       ret      
0x000092C6: cc                       int3     
0x000092C7: cc                       int3     
0x000092C8: 48895c2408               mov      qword ptr [rsp + 8], rbx
0x000092CD: 4889742410               mov      qword ptr [rsp + 0x10], rsi
0x000092D2: 57                       push     rdi
0x000092D3: 4883ec30                 sub      rsp, 0x30
0x000092D7: 33ff                     xor      edi, edi
0x000092D9: 8d4f01                   lea      ecx, [rdi + 1]
0x000092DC: e8bfc7ffff               call     0x180005aa0
0x000092E1: 90                       nop      
0x000092E2: 8d5f03                   lea      ebx, [rdi + 3]
0x000092E5: 895c2420                 mov      dword ptr [rsp + 0x20], ebx
0x000092E9: 3b1d51330100             cmp      ebx, dword ptr [rip + 0x13351]
0x000092EF: 7d63                     jge      0x180009354
0x000092F1: 4863f3                   movsxd   rsi, ebx
0x000092F4: 488b053d330100           mov      rax, qword ptr [rip + 0x1333d]
0x000092FB: 488b0cf0                 mov      rcx, qword ptr [rax + rsi*8]
0x000092FF: 4885c9                   test     rcx, rcx
0x00009302: 744c                     je       0x180009350
0x00009304: f6411883                 test     byte ptr [rcx + 0x18], 0x83
0x00009308: 7410                     je       0x18000931a
0x0000930A: e89d0f0000               call     0x18000a2ac
0x0000930F: 83f8ff                   cmp      eax, -1
0x00009312: 7406                     je       0x18000931a
0x00009314: ffc7                     inc      edi
0x00009316: 897c2424                 mov      dword ptr [rsp + 0x24], edi
0x0000931A: 83fb14                   cmp      ebx, 0x14
0x0000931D: 7c31                     jl       0x180009350
0x0000931F: 488b0512330100           mov      rax, qword ptr [rip + 0x13312]
0x00009326: 488b0cf0                 mov      rcx, qword ptr [rax + rsi*8]
0x0000932A: 4883c130                 add      rcx, 0x30
0x0000932E: 51                       push     rcx
0x0000932F: e801060200               call     0x180029935
0x00009334: 488b0dfd320100           mov      rcx, qword ptr [rip + 0x132fd]
0x0000933B: 488b0cf1                 mov      rcx, qword ptr [rcx + rsi*8]
0x0000933F: e8ec84ffff               call     0x180001830
0x00009344: 488b05ed320100           mov      rax, qword ptr [rip + 0x132ed]
0x0000934B: 488324f000               and      qword ptr [rax + rsi*8], 0
0x00009350: ffc3                     inc      ebx
0x00009352: eb91                     jmp      0x1800092e5
0x00009354: b901000000               mov      ecx, 1
0x00009359: e832c9ffff               call     0x180005c90
0x0000935E: 8bc7                     mov      eax, edi
0x00009360: 488b5c2440               mov      rbx, qword ptr [rsp + 0x40]
0x00009365: 488b742448               mov      rsi, qword ptr [rsp + 0x48]
0x0000936A: 4883c430                 add      rsp, 0x30
0x0000936E: 5f                       pop      rdi
0x0000936F: c3                       ret      
0x00009370: cc                       int3     
0x00009371: cc                       int3     
0x00009372: cc                       int3     
0x00009373: cc                       int3     
0x00009374: cc                       int3     
0x00009375: cc                       int3     
0x00009376: 66660f1f840000000000     nop      word ptr [rax + rax]
0x00009380: 4883ec10                 sub      rsp, 0x10
0x00009384: 4c891424                 mov      qword ptr [rsp], r10
0x00009388: 4c895c2408               mov      qword ptr [rsp + 8], r11
0x0000938D: 4d33db                   xor      r11, r11
0x00009390: 4c8d542418               lea      r10, [rsp + 0x18]
0x00009395: 4c2bd0                   sub      r10, rax
0x00009398: 4d0f42d3                 cmovb    r10, r11
0x0000939C: 654c8b1c2510000000       mov      r11, qword ptr gs:[0x10]
0x000093A5: 4d3bd3                   cmp      r10, r11
0x000093A8: 7316                     jae      0x1800093c0
0x000093AA: 664181e200f0             and      r10w, 0xf000
0x000093B0: 4d8d9b00f0ffff           lea      r11, [r11 - 0x1000]
0x000093B7: 41c60300                 mov      byte ptr [r11], 0
0x000093BB: 4d3bd3                   cmp      r10, r11
0x000093BE: 75f0                     jne      0x1800093b0
0x000093C0: 4c8b1424                 mov      r10, qword ptr [rsp]
0x000093C4: 4c8b5c2408               mov      r11, qword ptr [rsp + 8]
0x000093C9: 4883c410                 add      rsp, 0x10
0x000093CD: c3                       ret      
0x000093CE: cc                       int3     
0x000093CF: cc                       int3     
0x000093D0: 48895c2418               mov      qword ptr [rsp + 0x18], rbx
0x000093D5: 894c2408                 mov      dword ptr [rsp + 8], ecx
0x000093D9: 56                       push     rsi
0x000093DA: 57                       push     rdi
0x000093DB: 4156                     push     r14
0x000093DD: 4883ec20                 sub      rsp, 0x20
0x000093E1: 4863f9                   movsxd   rdi, ecx
0x000093E4: 83fffe                   cmp      edi, -2
0x000093E7: 7510                     jne      0x1800093f9
0x000093E9: e89e92ffff               call     0x18000268c
0x000093EE: c70009000000             mov      dword ptr [rax], 9
0x000093F4: e99d000000               jmp      0x180009496
0x000093F9: 85c9                     test     ecx, ecx
0x000093FB: 0f8885000000             js       0x180009486
0x00009401: 3b3d81430100             cmp      edi, dword ptr [rip + 0x14381]
0x00009407: 737d                     jae      0x180009486
0x00009409: 488bc7                   mov      rax, rdi
0x0000940C: 488bdf                   mov      rbx, rdi
0x0000940F: 48c1fb05                 sar      rbx, 5
0x00009413: 4c8d35a6ff0000           lea      r14, [rip + 0xffa6]
0x0000941A: 83e01f                   and      eax, 0x1f
0x0000941D: 486bf058                 imul     rsi, rax, 0x58
0x00009421: 498b04de                 mov      rax, qword ptr [r14 + rbx*8]
0x00009425: 0fbe4c3008               movsx    ecx, byte ptr [rax + rsi + 8]
0x0000942A: 83e101                   and      ecx, 1
0x0000942D: 7457                     je       0x180009486
0x0000942F: 8bcf                     mov      ecx, edi
0x00009431: e8de0e0000               call     0x18000a314
0x00009436: 90                       nop      
0x00009437: 498b04de                 mov      rax, qword ptr [r14 + rbx*8]
0x0000943B: f644300801               test     byte ptr [rax + rsi + 8], 1
0x00009440: 742b                     je       0x18000946d
0x00009442: 8bcf                     mov      ecx, edi
0x00009444: e80f100000               call     0x18000a458
0x00009449: 488bc8                   mov      rcx, rax
0x0000944C: 51                       push     rcx
0x0000944D: e803f92400               call     0x180258d55
0x00009452: 85c0                     test     eax, eax
0x00009454: 750a                     jne      0x180009460
0x00009456: e8f53d0200               call     0x18002d250
0x0000945B: 448bd8                   mov      r11d, eax
0x0000945E: eb02                     jmp      0x180009462
0x00009460: 33db                     xor      ebx, ebx
0x00009462: 85db                     test     ebx, ebx
0x00009464: 7415                     je       0x18000947b
0x00009466: e8b191ffff               call     0x18000261c
0x0000946B: 8918                     mov      dword ptr [rax], ebx
0x0000946D: e81a92ffff               call     0x18000268c
0x00009472: c70009000000             mov      dword ptr [rax], 9
0x00009478: 83cbff                   or       ebx, 0xffffffff
0x0000947B: 8bcf                     mov      ecx, edi
0x0000947D: e84a100000               call     0x18000a4cc
0x00009482: 8bc3                     mov      eax, ebx
0x00009484: eb13                     jmp      0x180009499
0x00009486: e80192ffff               call     0x18000268c
0x0000948B: c70009000000             mov      dword ptr [rax], 9
0x00009491: e80ea4ffff               call     0x1800038a4
0x00009496: 83c8ff                   or       eax, 0xffffffff
0x00009499: 488b5c2450               mov      rbx, qword ptr [rsp + 0x50]
0x0000949E: 4883c420                 add      rsp, 0x20
0x000094A2: 415e                     pop      r14
0x000094A4: 5f                       pop      rdi
0x000094A5: 5e                       pop      rsi
0x000094A6: c3                       ret      
0x000094A7: cc                       int3     
0x000094A8: 48895c2410               mov      qword ptr [rsp + 0x10], rbx
0x000094AD: 894c2408                 mov      dword ptr [rsp + 8], ecx
0x000094B1: 56                       push     rsi
0x000094B2: 57                       push     rdi
0x000094B3: 4154                     push     r12
0x000094B5: 4156                     push     r14
0x000094B7: 4157                     push     r15
0x000094B9: 4883ec20                 sub      rsp, 0x20
0x000094BD: 418bf0                   mov      esi, r8d
0x000094C0: 4c8bf2                   mov      r14, rdx
0x000094C3: 4863d9                   movsxd   rbx, ecx
0x000094C6: 83fbfe                   cmp      ebx, -2
0x000094C9: 7518                     jne      0x1800094e3
0x000094CB: e84c91ffff               call     0x18000261c
0x000094D0: 832000                   and      dword ptr [rax], 0
0x000094D3: e8b491ffff               call     0x18000268c
0x000094D8: c70009000000             mov      dword ptr [rax], 9
0x000094DE: e991000000               jmp      0x180009574
0x000094E3: 85c9                     test     ecx, ecx
0x000094E5: 7875                     js       0x18000955c
0x000094E7: 3b1d9b420100             cmp      ebx, dword ptr [rip + 0x1429b]
0x000094ED: 736d                     jae      0x18000955c
0x000094EF: 488bc3                   mov      rax, rbx
0x000094F2: 488bfb                   mov      rdi, rbx
0x000094F5: 48c1ff05                 sar      rdi, 5
0x000094F9: 4c8d25c0fe0000           lea      r12, [rip + 0xfec0]
0x00009500: 83e01f                   and      eax, 0x1f
0x00009503: 4c6bf858                 imul     r15, rax, 0x58
0x00009507: 498b04fc                 mov      rax, qword ptr [r12 + rdi*8]
0x0000950B: 420fbe4c3808             movsx    ecx, byte ptr [rax + r15 + 8]
0x00009511: 83e101                   and      ecx, 1
0x00009514: 7446                     je       0x18000955c
0x00009516: 8bcb                     mov      ecx, ebx
0x00009518: e8f70d0000               call     0x18000a314
0x0000951D: 90                       nop      
0x0000951E: 498b04fc                 mov      rax, qword ptr [r12 + rdi*8]
0x00009522: 42f644380801             test     byte ptr [rax + r15 + 8], 1
0x00009528: 7411                     je       0x18000953b
0x0000952A: 448bc6                   mov      r8d, esi
0x0000952D: 498bd6                   mov      rdx, r14
0x00009530: 8bcb                     mov      ecx, ebx
0x00009532: e855000000               call     0x18000958c
0x00009537: 8bf8                     mov      edi, eax
0x00009539: eb16                     jmp      0x180009551
0x0000953B: e84c91ffff               call     0x18000268c
0x00009540: c70009000000             mov      dword ptr [rax], 9
0x00009546: e8d190ffff               call     0x18000261c
0x0000954B: 832000                   and      dword ptr [rax], 0
0x0000954E: 83cfff                   or       edi, 0xffffffff
0x00009551: 8bcb                     mov      ecx, ebx
0x00009553: e8740f0000               call     0x18000a4cc
0x00009558: 8bc7                     mov      eax, edi
0x0000955A: eb1b                     jmp      0x180009577
0x0000955C: e8bb90ffff               call     0x18000261c
0x00009561: 832000                   and      dword ptr [rax], 0
0x00009564: e82391ffff               call     0x18000268c
0x00009569: c70009000000             mov      dword ptr [rax], 9
0x0000956F: e830a3ffff               call     0x1800038a4
0x00009574: 83c8ff                   or       eax, 0xffffffff
0x00009577: 488b5c2458               mov      rbx, qword ptr [rsp + 0x58]
0x0000957C: 4883c420                 add      rsp, 0x20
0x00009580: 415f                     pop      r15
0x00009582: 415e                     pop      r14
0x00009584: 415c                     pop      r12
0x00009586: 5f                       pop      rdi
0x00009587: 5e                       pop      rsi
0x00009588: c3                       ret      
0x00009589: cc                       int3     
0x0000958A: cc                       int3     
0x0000958B: cc                       int3     
0x0000958C: 48895c2420               mov      qword ptr [rsp + 0x20], rbx
0x00009591: 55                       push     rbp
0x00009592: 56                       push     rsi
0x00009593: 57                       push     rdi
0x00009594: 4154                     push     r12
0x00009596: 4155                     push     r13
0x00009598: 4156                     push     r14
0x0000959A: 4157                     push     r15
0x0000959C: 488dac24c0e5ffff         lea      rbp, [rsp - 0x1a40]
0x000095A4: b8401b0000               mov      eax, 0x1b40
0x000095A9: e8d2fdffff               call     0x180009380
0x000095AE: 482be0                   sub      rsp, rax
0x000095B1: 488b0548da0000           mov      rax, qword ptr [rip + 0xda48]
0x000095B8: 4833c4                   xor      rax, rsp
0x000095BB: 488985301a0000           mov      qword ptr [rbp + 0x1a30], rax
0x000095C2: 4533e4                   xor      r12d, r12d
0x000095C5: 458bf8                   mov      r15d, r8d
0x000095C8: 4c8bf2                   mov      r14, rdx
0x000095CB: 4863f9                   movsxd   rdi, ecx
0x000095CE: 4489642440               mov      dword ptr [rsp + 0x40], r12d
0x000095D3: 418bdc                   mov      ebx, r12d
0x000095D6: 418bf4                   mov      esi, r12d
0x000095D9: 4585c0                   test     r8d, r8d
0x000095DC: 7507                     jne      0x1800095e5
0x000095DE: 33c0                     xor      eax, eax
0x000095E0: e96e070000               jmp      0x180009d53
0x000095E5: 4885d2                   test     rdx, rdx
0x000095E8: 7520                     jne      0x18000960a
0x000095EA: e82d90ffff               call     0x18000261c
0x000095EF: 448920                   mov      dword ptr [rax], r12d
0x000095F2: e89590ffff               call     0x18000268c
0x000095F7: c70016000000             mov      dword ptr [rax], 0x16
0x000095FD: e8a2a2ffff               call     0x1800038a4
0x00009602: 83c8ff                   or       eax, 0xffffffff
0x00009605: e949070000               jmp      0x180009d53
0x0000960A: 488bc7                   mov      rax, rdi
0x0000960D: 488bcf                   mov      rcx, rdi
0x00009610: 488d15a9fd0000           lea      rdx, [rip + 0xfda9]
0x00009617: 48c1f905                 sar      rcx, 5
0x0000961B: 83e01f                   and      eax, 0x1f
0x0000961E: 48894c2448               mov      qword ptr [rsp + 0x48], rcx
0x00009623: 488b0cca                 mov      rcx, qword ptr [rdx + rcx*8]
0x00009627: 4c6be858                 imul     r13, rax, 0x58
0x0000962B: 458a640d38               mov      r12b, byte ptr [r13 + rcx + 0x38]
0x00009630: 4c896c2458               mov      qword ptr [rsp + 0x58], r13
0x00009635: 4502e4                   add      r12b, r12b
0x00009638: 41d0fc                   sar      r12b, 1
0x0000963B: 418d4424ff               lea      eax, [r12 - 1]
0x00009640: 3c01                     cmp      al, 1
0x00009642: 7714                     ja       0x180009658
0x00009644: 418bc7                   mov      eax, r15d
0x00009647: f7d0                     not      eax
0x00009649: a801                     test     al, 1
0x0000964B: 750b                     jne      0x180009658
0x0000964D: e8ca8fffff               call     0x18000261c
0x00009652: 33c9                     xor      ecx, ecx
0x00009654: 8908                     mov      dword ptr [rax], ecx
0x00009656: eb9a                     jmp      0x1800095f2
0x00009658: 41f6440d0820             test     byte ptr [r13 + rcx + 8], 0x20
0x0000965E: 740d                     je       0x18000966d
0x00009660: 33d2                     xor      edx, edx
0x00009662: 8bcf                     mov      ecx, edi
0x00009664: 448d4202                 lea      r8d, [rdx + 2]
0x00009668: e8170f0000               call     0x18000a584
0x0000966D: 8bcf                     mov      ecx, edi
0x0000966F: e8dcf3ffff               call     0x180008a50
0x00009674: 488b7c2448               mov      rdi, qword ptr [rsp + 0x48]
0x00009679: 85c0                     test     eax, eax
0x0000967B: 0f8440030000             je       0x1800099c1
0x00009681: 488d0538fd0000           lea      rax, [rip + 0xfd38]
0x00009688: 488b04f8                 mov      rax, qword ptr [rax + rdi*8]
0x0000968C: 41f644050880             test     byte ptr [r13 + rax + 8], 0x80
0x00009692: 0f8429030000             je       0x1800099c1
0x00009698: e8ebabffff               call     0x180004288
0x0000969D: 488d542464               lea      rdx, [rsp + 0x64]
0x000096A2: 488b88c0000000           mov      rcx, qword ptr [rax + 0xc0]
0x000096A9: 33c0                     xor      eax, eax
0x000096AB: 48398138010000           cmp      qword ptr [rcx + 0x138], rax
0x000096B2: 8bf8                     mov      edi, eax
0x000096B4: 488b442448               mov      rax, qword ptr [rsp + 0x48]
0x000096B9: 488d0d00fd0000           lea      rcx, [rip + 0xfd00]
0x000096C0: 400f94c7                 sete     dil
0x000096C4: 488b0cc1                 mov      rcx, qword ptr [rcx + rax*8]
0x000096C8: 498b4c0d00               mov      rcx, qword ptr [r13 + rcx]
0x000096CD: e8b4641e00               call     0x1801efb86
0x000096D2: eb33                     jmp      0x180009707
0x000096D4: c9                       leave    
0x000096D5: 85c0                     test     eax, eax
0x000096D7: 0f84df020000             je       0x1800099bc
0x000096DD: 33c0                     xor      eax, eax
0x000096DF: 85ff                     test     edi, edi
0x000096E1: 7409                     je       0x1800096ec
0x000096E3: 4584e4                   test     r12b, r12b
0x000096E6: 0f84c9020000             je       0x1800099b5
0x000096EC: 53                       push     rbx
0x000096ED: e8e2890e00               call     0x1800f20d4
0x000096F2: 498bfe                   mov      rdi, r14
0x000096F5: 89442468                 mov      dword ptr [rsp + 0x68], eax
0x000096F9: 33c0                     xor      eax, eax
0x000096FB: 0fb7c8                   movzx    ecx, ax
0x000096FE: 6689442444               mov      word ptr [rsp + 0x44], ax
0x00009703: 89442460                 mov      dword ptr [rsp + 0x60], eax
0x00009707: 4585ff                   test     r15d, r15d
0x0000970A: 0f8406060000             je       0x180009d16
0x00009710: 448be8                   mov      r13d, eax
0x00009713: 4584e4                   test     r12b, r12b
0x00009716: 0f85a3010000             jne      0x1800098bf
0x0000971C: 8a0f                     mov      cl, byte ptr [rdi]
0x0000971E: 4c8b6c2458               mov      r13, qword ptr [rsp + 0x58]
0x00009723: 488d1596fc0000           lea      rdx, [rip + 0xfc96]
0x0000972A: 80f90a                   cmp      cl, 0xa
0x0000972D: 0f94c0                   sete     al
0x00009730: 4533c0                   xor      r8d, r8d
0x00009733: 89442464                 mov      dword ptr [rsp + 0x64], eax
0x00009737: 488b442448               mov      rax, qword ptr [rsp + 0x48]
0x0000973C: 488b14c2                 mov      rdx, qword ptr [rdx + rax*8]
0x00009740: 4539441550               cmp      dword ptr [r13 + rdx + 0x50], r8d
0x00009745: 741f                     je       0x180009766
0x00009747: 418a44154c               mov      al, byte ptr [r13 + rdx + 0x4c]
0x0000974C: 884c246d                 mov      byte ptr [rsp + 0x6d], cl
0x00009750: 8844246c                 mov      byte ptr [rsp + 0x6c], al
0x00009754: 4589441550               mov      dword ptr [r13 + rdx + 0x50], r8d
0x00009759: 41b802000000             mov      r8d, 2
0x0000975F: 488d54246c               lea      rdx, [rsp + 0x6c]
0x00009764: eb49                     jmp      0x1800097af
0x00009766: 0fbec9                   movsx    ecx, cl
0x00009769: e8ce0d0000               call     0x18000a53c
0x0000976E: 85c0                     test     eax, eax
0x00009770: 7434                     je       0x1800097a6
0x00009772: 498bc7                   mov      rax, r15
0x00009775: 482bc7                   sub      rax, rdi
0x00009778: 4903c6                   add      rax, r14
0x0000977B: 4883f801                 cmp      rax, 1
0x0000977F: 0f8eb3010000             jle      0x180009938
0x00009785: 488d4c2444               lea      rcx, [rsp + 0x44]
0x0000978A: 41b802000000             mov      r8d, 2
0x00009790: 488bd7                   mov      rdx, rdi
0x00009793: e8d40f0000               call     0x18000a76c
0x00009798: 83f8ff                   cmp      eax, -1
0x0000979B: 0f84d9010000             je       0x18000997a
0x000097A1: 48ffc7                   inc      rdi
0x000097A4: eb1c                     jmp      0x1800097c2
0x000097A6: 41b801000000             mov      r8d, 1
0x000097AC: 488bd7                   mov      rdx, rdi
0x000097AF: 488d4c2444               lea      rcx, [rsp + 0x44]
0x000097B4: e8b30f0000               call     0x18000a76c
0x000097B9: 83f8ff                   cmp      eax, -1
0x000097BC: 0f84b8010000             je       0x18000997a
0x000097C2: 8b4c2468                 mov      ecx, dword ptr [rsp + 0x68]
0x000097C6: 33c0                     xor      eax, eax
0x000097C8: 4c8d442444               lea      r8, [rsp + 0x44]
0x000097CD: 4889442438               mov      qword ptr [rsp + 0x38], rax
0x000097D2: 4889442430               mov      qword ptr [rsp + 0x30], rax
0x000097D7: 488d44246c               lea      rax, [rsp + 0x6c]
0x000097DC: 41b901000000             mov      r9d, 1
0x000097E2: 33d2                     xor      edx, edx
0x000097E4: c744242805000000         mov      dword ptr [rsp + 0x28], 5
0x000097EC: 4889442420               mov      qword ptr [rsp + 0x20], rax
0x000097F1: 48ffc7                   inc      rdi
0x000097F4: e842810200               call     0x18003193b
0x000097F9: b744                     mov      bh, 0x44
0x000097FB: 8be8                     mov      ebp, eax
0x000097FD: 85c0                     test     eax, eax
0x000097FF: 0f8470010000             je       0x180009975
0x00009805: 488b442448               mov      rax, qword ptr [rsp + 0x48]
0x0000980A: 488d0daffb0000           lea      rcx, [rip + 0xfbaf]
0x00009811: 4c8d4c2460               lea      r9, [rsp + 0x60]
0x00009816: 488b0cc1                 mov      rcx, qword ptr [rcx + rax*8]
0x0000981A: 33c0                     xor      eax, eax
0x0000981C: 488d54246c               lea      rdx, [rsp + 0x6c]
0x00009821: 4889442420               mov      qword ptr [rsp + 0x20], rax
0x00009826: 488b442458               mov      rax, qword ptr [rsp + 0x58]
0x0000982B: 458bc5                   mov      r8d, r13d
0x0000982E: 488b0c08                 mov      rcx, qword ptr [rax + rcx]
0x00009832: 56                       push     rsi
0x00009833: e8bfaf0100               call     0x1800247f7
0x00009838: 85c0                     test     eax, eax
0x0000983A: 0f842d010000             je       0x18000996d
0x00009840: 8b442440                 mov      eax, dword ptr [rsp + 0x40]
0x00009844: 8bdf                     mov      ebx, edi
0x00009846: 412bde                   sub      ebx, r14d
0x00009849: 03d8                     add      ebx, eax
0x0000984B: 44396c2460               cmp      dword ptr [rsp + 0x60], r13d
0x00009850: 0f8ca5040000             jl       0x180009cfb
0x00009856: 4533ed                   xor      r13d, r13d
0x00009859: 44396c2464               cmp      dword ptr [rsp + 0x64], r13d
0x0000985E: 7458                     je       0x1800098b8
0x00009860: 488b442448               mov      rax, qword ptr [rsp + 0x48]
0x00009865: 458d4501                 lea      r8d, [r13 + 1]
0x00009869: c644246c0d               mov      byte ptr [rsp + 0x6c], 0xd
0x0000986E: 488d0d4bfb0000           lea      rcx, [rip + 0xfb4b]
0x00009875: 4c896c2420               mov      qword ptr [rsp + 0x20], r13
0x0000987A: 4c8b6c2458               mov      r13, qword ptr [rsp + 0x58]
0x0000987F: 488b0cc1                 mov      rcx, qword ptr [rcx + rax*8]
0x00009883: 4c8d4c2460               lea      r9, [rsp + 0x60]
0x00009888: 488d54246c               lea      rdx, [rsp + 0x6c]
0x0000988D: 498b4c0d00               mov      rcx, qword ptr [r13 + rcx]
0x00009892: 50                       push     rax
0x00009893: e813971400               call     0x180152fab
0x00009898: 85c0                     test     eax, eax
0x0000989A: 0f84c3000000             je       0x180009963
0x000098A0: 837c246001               cmp      dword ptr [rsp + 0x60], 1
0x000098A5: 0f8ccf000000             jl       0x18000997a
0x000098AB: ff442440                 inc      dword ptr [rsp + 0x40]
0x000098AF: 0fb74c2444               movzx    ecx, word ptr [rsp + 0x44]
0x000098B4: ffc3                     inc      ebx
0x000098B6: eb6f                     jmp      0x180009927
0x000098B8: 0fb74c2444               movzx    ecx, word ptr [rsp + 0x44]
0x000098BD: eb63                     jmp      0x180009922
0x000098BF: 418d4424ff               lea      eax, [r12 - 1]
0x000098C4: 3c01                     cmp      al, 1
0x000098C6: 7719                     ja       0x1800098e1
0x000098C8: 0fb70f                   movzx    ecx, word ptr [rdi]
0x000098CB: 33c0                     xor      eax, eax
0x000098CD: 6683f90a                 cmp      cx, 0xa
0x000098D1: 448be8                   mov      r13d, eax
0x000098D4: 66894c2444               mov      word ptr [rsp + 0x44], cx
0x000098D9: 410f94c5                 sete     r13b
0x000098DD: 4883c702                 add      rdi, 2
0x000098E1: 418d4424ff               lea      eax, [r12 - 1]
0x000098E6: 3c01                     cmp      al, 1
0x000098E8: 7738                     ja       0x180009922
0x000098EA: e8850e0000               call     0x18000a774
0x000098EF: 0fb74c2444               movzx    ecx, word ptr [rsp + 0x44]
0x000098F4: 663bc1                   cmp      ax, cx
0x000098F7: 7574                     jne      0x18000996d
0x000098F9: 83c302                   add      ebx, 2
0x000098FC: 4585ed                   test     r13d, r13d
0x000098FF: 7421                     je       0x180009922
0x00009901: b80d000000               mov      eax, 0xd
0x00009906: 8bc8                     mov      ecx, eax
0x00009908: 6689442444               mov      word ptr [rsp + 0x44], ax
0x0000990D: e8620e0000               call     0x18000a774
0x00009912: 0fb74c2444               movzx    ecx, word ptr [rsp + 0x44]
0x00009917: 663bc1                   cmp      ax, cx
0x0000991A: 7551                     jne      0x18000996d
0x0000991C: ffc3                     inc      ebx
0x0000991E: ff442440                 inc      dword ptr [rsp + 0x40]
0x00009922: 4c8b6c2458               mov      r13, qword ptr [rsp + 0x58]
0x00009927: 8bc7                     mov      eax, edi
0x00009929: 412bc6                   sub      eax, r14d
0x0000992C: 413bc7                   cmp      eax, r15d
0x0000992F: 7349                     jae      0x18000997a
0x00009931: 33c0                     xor      eax, eax
0x00009933: e9d8fdffff               jmp      0x180009710
0x00009938: 8a07                     mov      al, byte ptr [rdi]
0x0000993A: 4c8b7c2448               mov      r15, qword ptr [rsp + 0x48]
0x0000993F: 4c8d257afa0000           lea      r12, [rip + 0xfa7a]
0x00009946: 4b8b0cfc                 mov      rcx, qword ptr [r12 + r15*8]
0x0000994A: ffc3                     inc      ebx
0x0000994C: 498bff                   mov      rdi, r15
0x0000994F: 4188440d4c               mov      byte ptr [r13 + rcx + 0x4c], al
0x00009954: 4b8b04fc                 mov      rax, qword ptr [r12 + r15*8]
0x00009958: 41c744055001000000       mov      dword ptr [r13 + rax + 0x50], 1
0x00009961: eb1c                     jmp      0x18000997f
0x00009963: 50                       push     rax
0x00009964: e819d52200               call     0x180236e82
0x00009969: 8bf0                     mov      esi, eax
0x0000996B: eb0d                     jmp      0x18000997a
0x0000996D: 56                       push     rsi
0x0000996E: e865910200               call     0x180032ad8
0x00009973: 8bf0                     mov      esi, eax
0x00009975: 4c8b6c2458               mov      r13, qword ptr [rsp + 0x58]
0x0000997A: 488b7c2448               mov      rdi, qword ptr [rsp + 0x48]
0x0000997F: 8b442440                 mov      eax, dword ptr [rsp + 0x40]
0x00009983: 85db                     test     ebx, ebx
0x00009985: 0f85c4030000             jne      0x180009d4f
0x0000998B: 33db                     xor      ebx, ebx
0x0000998D: 85f6                     test     esi, esi
0x0000998F: 0f8486030000             je       0x180009d1b
0x00009995: 83fe05                   cmp      esi, 5
0x00009998: 0f856c030000             jne      0x180009d0a
0x0000999E: e8e98cffff               call     0x18000268c
0x000099A3: c70009000000             mov      dword ptr [rax], 9
0x000099A9: e86e8cffff               call     0x18000261c
0x000099AE: 8930                     mov      dword ptr [rax], esi
0x000099B0: e94dfcffff               jmp      0x180009602
0x000099B5: 488b7c2448               mov      rdi, qword ptr [rsp + 0x48]
0x000099BA: eb07                     jmp      0x1800099c3
0x000099BC: 488b7c2448               mov      rdi, qword ptr [rsp + 0x48]
0x000099C1: 33c0                     xor      eax, eax
0x000099C3: 4c8d0df6f90000           lea      r9, [rip + 0xf9f6]
0x000099CA: 498b0cf9                 mov      rcx, qword ptr [r9 + rdi*8]
0x000099CE: 41f6440d0880             test     byte ptr [r13 + rcx + 8], 0x80
0x000099D4: 0f84e8020000             je       0x180009cc2
0x000099DA: 8bf0                     mov      esi, eax
0x000099DC: 4584e4                   test     r12b, r12b
0x000099DF: 0f85d8000000             jne      0x180009abd
0x000099E5: 4d8be6                   mov      r12, r14
0x000099E8: 4585ff                   test     r15d, r15d
0x000099EB: 0f842a030000             je       0x180009d1b
0x000099F1: ba0d000000               mov      edx, 0xd
0x000099F6: eb02                     jmp      0x1800099fa
0x000099F8: 33c0                     xor      eax, eax
0x000099FA: 448b6c2440               mov      r13d, dword ptr [rsp + 0x40]
0x000099FF: 488dbd30060000           lea      rdi, [rbp + 0x630]
0x00009A06: 488bc8                   mov      rcx, rax
0x00009A09: 418bc4                   mov      eax, r12d
0x00009A0C: 412bc6                   sub      eax, r14d
0x00009A0F: 413bc7                   cmp      eax, r15d
0x00009A12: 7327                     jae      0x180009a3b
0x00009A14: 418a0424                 mov      al, byte ptr [r12]
0x00009A18: 49ffc4                   inc      r12
0x00009A1B: 3c0a                     cmp      al, 0xa
0x00009A1D: 750b                     jne      0x180009a2a
0x00009A1F: 8817                     mov      byte ptr [rdi], dl
0x00009A21: 41ffc5                   inc      r13d
0x00009A24: 48ffc7                   inc      rdi
0x00009A27: 48ffc1                   inc      rcx
0x00009A2A: 48ffc1                   inc      rcx
0x00009A2D: 8807                     mov      byte ptr [rdi], al
0x00009A2F: 48ffc7                   inc      rdi
0x00009A32: 4881f9ff130000           cmp      rcx, 0x13ff
0x00009A39: 72ce                     jb       0x180009a09
0x00009A3B: 488d8530060000           lea      rax, [rbp + 0x630]
0x00009A42: 448bc7                   mov      r8d, edi
0x00009A45: 44896c2440               mov      dword ptr [rsp + 0x40], r13d
0x00009A4A: 4c8b6c2458               mov      r13, qword ptr [rsp + 0x58]
0x00009A4F: 442bc0                   sub      r8d, eax
0x00009A52: 488b442448               mov      rax, qword ptr [rsp + 0x48]
0x00009A57: 498b0cc1                 mov      rcx, qword ptr [r9 + rax*8]
0x00009A5B: 33c0                     xor      eax, eax
0x00009A5D: 4c8d4c2450               lea      r9, [rsp + 0x50]
0x00009A62: 498b4c0d00               mov      rcx, qword ptr [r13 + rcx]
0x00009A67: 488d9530060000           lea      rdx, [rbp + 0x630]
0x00009A6E: 4889442420               mov      qword ptr [rsp + 0x20], rax
0x00009A73: e8b2731f00               call     0x180200e2a
0x00009A78: fb                       sti      
0x00009A79: 85c0                     test     eax, eax
0x00009A7B: 0f84e2feffff             je       0x180009963
0x00009A81: 035c2450                 add      ebx, dword ptr [rsp + 0x50]
0x00009A85: 488d8530060000           lea      rax, [rbp + 0x630]
0x00009A8C: 482bf8                   sub      rdi, rax
0x00009A8F: 4863442450               movsxd   rax, dword ptr [rsp + 0x50]
0x00009A94: 483bc7                   cmp      rax, rdi
0x00009A97: 0f8cddfeffff             jl       0x18000997a
0x00009A9D: 418bc4                   mov      eax, r12d
0x00009AA0: ba0d000000               mov      edx, 0xd
0x00009AA5: 4c8d0d14f90000           lea      r9, [rip + 0xf914]
0x00009AAC: 412bc6                   sub      eax, r14d
0x00009AAF: 413bc7                   cmp      eax, r15d
0x00009AB2: 0f8240ffffff             jb       0x1800099f8
0x00009AB8: e9bdfeffff               jmp      0x18000997a
0x00009ABD: 4180fc02                 cmp      r12b, 2
0x00009AC1: 4d8be6                   mov      r12, r14
0x00009AC4: 0f85e0000000             jne      0x180009baa
0x00009ACA: 4585ff                   test     r15d, r15d
0x00009ACD: 0f8448020000             je       0x180009d1b
0x00009AD3: ba0d000000               mov      edx, 0xd
0x00009AD8: eb02                     jmp      0x180009adc
0x00009ADA: 33c0                     xor      eax, eax
0x00009ADC: 448b6c2440               mov      r13d, dword ptr [rsp + 0x40]
0x00009AE1: 488dbd30060000           lea      rdi, [rbp + 0x630]
0x00009AE8: 488bc8                   mov      rcx, rax
0x00009AEB: 418bc4                   mov      eax, r12d
0x00009AEE: 412bc6                   sub      eax, r14d
0x00009AF1: 413bc7                   cmp      eax, r15d
0x00009AF4: 7332                     jae      0x180009b28
0x00009AF6: 410fb70424               movzx    eax, word ptr [r12]
0x00009AFB: 4983c402                 add      r12, 2
0x00009AFF: 6683f80a                 cmp      ax, 0xa
0x00009B03: 750f                     jne      0x180009b14
0x00009B05: 668917                   mov      word ptr [rdi], dx
0x00009B08: 4183c502                 add      r13d, 2
0x00009B0C: 4883c702                 add      rdi, 2
0x00009B10: 4883c102                 add      rcx, 2
0x00009B14: 4883c102                 add      rcx, 2
0x00009B18: 668907                   mov      word ptr [rdi], ax
0x00009B1B: 4883c702                 add      rdi, 2
0x00009B1F: 4881f9fe130000           cmp      rcx, 0x13fe
0x00009B26: 72c3                     jb       0x180009aeb
0x00009B28: 488d8530060000           lea      rax, [rbp + 0x630]
0x00009B2F: 448bc7                   mov      r8d, edi
0x00009B32: 44896c2440               mov      dword ptr [rsp + 0x40], r13d
0x00009B37: 4c8b6c2458               mov      r13, qword ptr [rsp + 0x58]
0x00009B3C: 442bc0                   sub      r8d, eax
0x00009B3F: 488b442448               mov      rax, qword ptr [rsp + 0x48]
0x00009B44: 498b0cc1                 mov      rcx, qword ptr [r9 + rax*8]
0x00009B48: 33c0                     xor      eax, eax
0x00009B4A: 4c8d4c2450               lea      r9, [rsp + 0x50]
0x00009B4F: 498b4c0d00               mov      rcx, qword ptr [r13 + rcx]
0x00009B54: 488d9530060000           lea      rdx, [rbp + 0x630]
0x00009B5B: 4889442420               mov      qword ptr [rsp + 0x20], rax
0x00009B60: e88fb92100               call     0x1802254f4
0x00009B65: 6585c0                   test     eax, eax
0x00009B68: 0f84f5fdffff             je       0x180009963
0x00009B6E: 035c2450                 add      ebx, dword ptr [rsp + 0x50]
0x00009B72: 488d8530060000           lea      rax, [rbp + 0x630]
0x00009B79: 482bf8                   sub      rdi, rax
0x00009B7C: 4863442450               movsxd   rax, dword ptr [rsp + 0x50]
0x00009B81: 483bc7                   cmp      rax, rdi
0x00009B84: 0f8cf0fdffff             jl       0x18000997a
0x00009B8A: 418bc4                   mov      eax, r12d
0x00009B8D: ba0d000000               mov      edx, 0xd
0x00009B92: 4c8d0d27f80000           lea      r9, [rip + 0xf827]
0x00009B99: 412bc6                   sub      eax, r14d
0x00009B9C: 413bc7                   cmp      eax, r15d
0x00009B9F: 0f8235ffffff             jb       0x180009ada
0x00009BA5: e9d0fdffff               jmp      0x18000997a
0x00009BAA: 4585ff                   test     r15d, r15d
0x00009BAD: 0f8468010000             je       0x180009d1b
0x00009BB3: 41b80d000000             mov      r8d, 0xd
0x00009BB9: eb02                     jmp      0x180009bbd
0x00009BBB: 33c0                     xor      eax, eax
0x00009BBD: 488d4d80                 lea      rcx, [rbp - 0x80]
0x00009BC1: 488bd0                   mov      rdx, rax
0x00009BC4: 418bc4                   mov      eax, r12d
0x00009BC7: 412bc6                   sub      eax, r14d
0x00009BCA: 413bc7                   cmp      eax, r15d
0x00009BCD: 732f                     jae      0x180009bfe
0x00009BCF: 410fb70424               movzx    eax, word ptr [r12]
0x00009BD4: 4983c402                 add      r12, 2
0x00009BD8: 6683f80a                 cmp      ax, 0xa
0x00009BDC: 750c                     jne      0x180009bea
0x00009BDE: 66448901                 mov      word ptr [rcx], r8w
0x00009BE2: 4883c102                 add      rcx, 2
0x00009BE6: 4883c202                 add      rdx, 2
0x00009BEA: 4883c202                 add      rdx, 2
0x00009BEE: 668901                   mov      word ptr [rcx], ax
0x00009BF1: 4883c102                 add      rcx, 2
0x00009BF5: 4881faa8060000           cmp      rdx, 0x6a8
0x00009BFC: 72c6                     jb       0x180009bc4
0x00009BFE: 488d4580                 lea      rax, [rbp - 0x80]
0x00009C02: 33ff                     xor      edi, edi
0x00009C04: 4c8d4580                 lea      r8, [rbp - 0x80]
0x00009C08: 2bc8                     sub      ecx, eax
0x00009C0A: 48897c2438               mov      qword ptr [rsp + 0x38], rdi
0x00009C0F: 48897c2430               mov      qword ptr [rsp + 0x30], rdi
0x00009C14: 8bc1                     mov      eax, ecx
0x00009C16: b9e9fd0000               mov      ecx, 0xfde9
0x00009C1B: c7442428550d0000         mov      dword ptr [rsp + 0x28], 0xd55
0x00009C23: 99                       cdq      
0x00009C24: 2bc2                     sub      eax, edx
0x00009C26: 33d2                     xor      edx, edx
0x00009C28: d1f8                     sar      eax, 1
0x00009C2A: 448bc8                   mov      r9d, eax
0x00009C2D: 488d8530060000           lea      rax, [rbp + 0x630]
0x00009C34: 4889442420               mov      qword ptr [rsp + 0x20], rax
0x00009C39: 51                       push     rcx
0x00009C3A: e8bc7a1c00               call     0x1801d16fb
0x00009C3F: 448be8                   mov      r13d, eax
0x00009C42: 85c0                     test     eax, eax
0x00009C44: 0f8423fdffff             je       0x18000996d
0x00009C4A: 4863c7                   movsxd   rax, edi
0x00009C4D: 458bc5                   mov      r8d, r13d
0x00009C50: 488d9530060000           lea      rdx, [rbp + 0x630]
0x00009C57: 4803d0                   add      rdx, rax
0x00009C5A: 488b442448               mov      rax, qword ptr [rsp + 0x48]
0x00009C5F: 488d0d5af70000           lea      rcx, [rip + 0xf75a]
0x00009C66: 488b0cc1                 mov      rcx, qword ptr [rcx + rax*8]
0x00009C6A: 33c0                     xor      eax, eax
0x00009C6C: 4c8d4c2450               lea      r9, [rsp + 0x50]
0x00009C71: 4889442420               mov      qword ptr [rsp + 0x20], rax
0x00009C76: 488b442458               mov      rax, qword ptr [rsp + 0x58]
0x00009C7B: 442bc7                   sub      r8d, edi
0x00009C7E: 488b0c08                 mov      rcx, qword ptr [rax + rcx]
0x00009C82: e8bd702400               call     0x180250d44
0x00009C87: fb                       sti      
0x00009C88: 85c0                     test     eax, eax
0x00009C8A: 740b                     je       0x180009c97
0x00009C8C: 037c2450                 add      edi, dword ptr [rsp + 0x50]
0x00009C90: 443bef                   cmp      r13d, edi
0x00009C93: 7fb5                     jg       0x180009c4a
0x00009C95: eb08                     jmp      0x180009c9f
0x00009C97: e80bc21600               call     0x180175ea7
0x00009C9C: 6e                       outsb    dx, byte ptr [rsi]
0x00009C9D: 8bf0                     mov      esi, eax
0x00009C9F: 443bef                   cmp      r13d, edi
0x00009CA2: 0f8fcdfcffff             jg       0x180009975
0x00009CA8: 418bdc                   mov      ebx, r12d
0x00009CAB: 41b80d000000             mov      r8d, 0xd
0x00009CB1: 412bde                   sub      ebx, r14d
0x00009CB4: 413bdf                   cmp      ebx, r15d
0x00009CB7: 0f82fefeffff             jb       0x180009bbb
0x00009CBD: e9b3fcffff               jmp      0x180009975
0x00009CC2: 498b4c0d00               mov      rcx, qword ptr [r13 + rcx]
0x00009CC7: 4c8d4c2450               lea      r9, [rsp + 0x50]
0x00009CCC: 458bc7                   mov      r8d, r15d
0x00009CCF: 498bd6                   mov      rdx, r14
0x00009CD2: 4889442420               mov      qword ptr [rsp + 0x20], rax
0x00009CD7: 50                       push     rax
0x00009CD8: e885df2500               call     0x180267c62
0x00009CDD: 85c0                     test     eax, eax
0x00009CDF: 740b                     je       0x180009cec
0x00009CE1: 8b5c2450                 mov      ebx, dword ptr [rsp + 0x50]
0x00009CE5: 8bc6                     mov      eax, esi
0x00009CE7: e997fcffff               jmp      0x180009983
0x00009CEC: 50                       push     rax
0x00009CED: e824d71e00               call     0x1801f7416
0x00009CF2: 8bf0                     mov      esi, eax
0x00009CF4: 8bc3                     mov      eax, ebx
0x00009CF6: e988fcffff               jmp      0x180009983
0x00009CFB: 4c8b6c2458               mov      r13, qword ptr [rsp + 0x58]
0x00009D00: 488b7c2448               mov      rdi, qword ptr [rsp + 0x48]
0x00009D05: e979fcffff               jmp      0x180009983
0x00009D0A: 8bce                     mov      ecx, esi
0x00009D0C: e82b89ffff               call     0x18000263c
0x00009D11: e9ecf8ffff               jmp      0x180009602
0x00009D16: 488b7c2448               mov      rdi, qword ptr [rsp + 0x48]
0x00009D1B: 488d059ef60000           lea      rax, [rip + 0xf69e]
0x00009D22: 488b04f8                 mov      rax, qword ptr [rax + rdi*8]
0x00009D26: 41f644050840             test     byte ptr [r13 + rax + 8], 0x40
0x00009D2C: 740a                     je       0x180009d38
0x00009D2E: 41803e1a                 cmp      byte ptr [r14], 0x1a
0x00009D32: 0f84a6f8ffff             je       0x1800095de
0x00009D38: e84f89ffff               call     0x18000268c
0x00009D3D: c7001c000000             mov      dword ptr [rax], 0x1c
0x00009D43: e8d488ffff               call     0x18000261c
0x00009D48: 8918                     mov      dword ptr [rax], ebx
0x00009D4A: e9b3f8ffff               jmp      0x180009602
0x00009D4F: 2bd8                     sub      ebx, eax
0x00009D51: 8bc3                     mov      eax, ebx
0x00009D53: 488b8d301a0000           mov      rcx, qword ptr [rbp + 0x1a30]
0x00009D5A: 4833cc                   xor      rcx, rsp
0x00009D5D: e8ae7affff               call     0x180001810
0x00009D62: 488b9c24981b0000         mov      rbx, qword ptr [rsp + 0x1b98]
0x00009D6A: 4881c4401b0000           add      rsp, 0x1b40
0x00009D71: 415f                     pop      r15
0x00009D73: 415e                     pop      r14
0x00009D75: 415d                     pop      r13
0x00009D77: 415c                     pop      r12
0x00009D79: 5f                       pop      rdi
0x00009D7A: 5e                       pop      rsi
0x00009D7B: 5d                       pop      rbp
0x00009D7C: c3                       ret      
0x00009D7D: cc                       int3     
0x00009D7E: cc                       int3     
0x00009D7F: cc                       int3     
0x00009D80: 48895c2408               mov      qword ptr [rsp + 8], rbx
0x00009D85: 48896c2418               mov      qword ptr [rsp + 0x18], rbp
0x00009D8A: 56                       push     rsi
0x00009D8B: 57                       push     rdi
0x00009D8C: 4154                     push     r12
0x00009D8E: 4156                     push     r14
0x00009D90: 4157                     push     r15
0x00009D92: 4883ec40                 sub      rsp, 0x40
0x00009D96: 4c8be2                   mov      r12, rdx
0x00009D99: 488bd1                   mov      rdx, rcx
0x00009D9C: 488d4c2420               lea      rcx, [rsp + 0x20]
0x00009DA1: 458bf1                   mov      r14d, r9d
0x00009DA4: 4d8bf8                   mov      r15, r8
0x00009DA7: e8ecc2ffff               call     0x180006098
0x00009DAC: 4d85ff                   test     r15, r15
0x00009DAF: 7403                     je       0x180009db4
0x00009DB1: 4d8927                   mov      qword ptr [r15], r12
0x00009DB4: 4d85e4                   test     r12, r12
0x00009DB7: 740e                     je       0x180009dc7
0x00009DB9: 4585f6                   test     r14d, r14d
0x00009DBC: 741e                     je       0x180009ddc
0x00009DBE: 418d46fe                 lea      eax, [r14 - 2]
0x00009DC2: 83f822                   cmp      eax, 0x22
0x00009DC5: 7615                     jbe      0x180009ddc
0x00009DC7: e8c088ffff               call     0x18000268c
0x00009DCC: c70016000000             mov      dword ptr [rax], 0x16
0x00009DD2: e8cd9affff               call     0x1800038a4
0x00009DD7: e986000000               jmp      0x180009e62
0x00009DDC: 418a3424                 mov      sil, byte ptr [r12]
0x00009DE0: 4c8b442420               mov      r8, qword ptr [rsp + 0x20]
0x00009DE5: 33ff                     xor      edi, edi
0x00009DE7: 498d5c2401               lea      rbx, [r12 + 1]
0x00009DEC: 4183b8d400000001         cmp      dword ptr [r8 + 0xd4], 1
0x00009DF4: 7e1a                     jle      0x180009e10
0x00009DF6: 4c8d442420               lea      r8, [rsp + 0x20]
0x00009DFB: 400fb6ce                 movzx    ecx, sil
0x00009DFF: ba08000000               mov      edx, 8
0x00009E04: e8c7090000               call     0x18000a7d0
0x00009E09: 4c8b442420               mov      r8, qword ptr [rsp + 0x20]
0x00009E0E: eb12                     jmp      0x180009e22
0x00009E10: 498b8008010000           mov      rax, qword ptr [r8 + 0x108]
0x00009E17: 400fb6ce                 movzx    ecx, sil
0x00009E1B: 0fb70448                 movzx    eax, word ptr [rax + rcx*2]
0x00009E1F: 83e008                   and      eax, 8
0x00009E22: 85c0                     test     eax, eax
0x00009E24: 7408                     je       0x180009e2e
0x00009E26: 408a33                   mov      sil, byte ptr [rbx]
0x00009E29: 48ffc3                   inc      rbx
0x00009E2C: ebbe                     jmp      0x180009dec
0x00009E2E: 8bac2490000000           mov      ebp, dword ptr [rsp + 0x90]
0x00009E35: 4080fe2d                 cmp      sil, 0x2d
0x00009E39: 7505                     jne      0x180009e40
0x00009E3B: 83cd02                   or       ebp, 2
0x00009E3E: eb06                     jmp      0x180009e46
0x00009E40: 4080fe2b                 cmp      sil, 0x2b
0x00009E44: 7506                     jne      0x180009e4c
0x00009E46: 408a33                   mov      sil, byte ptr [rbx]
0x00009E49: 48ffc3                   inc      rbx
0x00009E4C: 4585f6                   test     r14d, r14d
0x00009E4F: 741d                     je       0x180009e6e
0x00009E51: 418d46fe                 lea      eax, [r14 - 2]
0x00009E55: 83f822                   cmp      eax, 0x22
0x00009E58: 760f                     jbe      0x180009e69
0x00009E5A: 4d85ff                   test     r15, r15
0x00009E5D: 7403                     je       0x180009e62
0x00009E5F: 4d8927                   mov      qword ptr [r15], r12
0x00009E62: 33ff                     xor      edi, edi
0x00009E64: e925010000               jmp      0x180009f8e
0x00009E69: 4585f6                   test     r14d, r14d
0x00009E6C: 7526                     jne      0x180009e94
0x00009E6E: 4080fe30                 cmp      sil, 0x30
0x00009E72: 7408                     je       0x180009e7c
0x00009E74: 41be0a000000             mov      r14d, 0xa
0x00009E7A: eb34                     jmp      0x180009eb0
0x00009E7C: 8a03                     mov      al, byte ptr [rbx]
0x00009E7E: 2c58                     sub      al, 0x58
0x00009E80: a8df                     test     al, 0xdf
0x00009E82: 7408                     je       0x180009e8c
0x00009E84: 41be08000000             mov      r14d, 8
0x00009E8A: eb24                     jmp      0x180009eb0
0x00009E8C: 41be10000000             mov      r14d, 0x10
0x00009E92: eb0c                     jmp      0x180009ea0
0x00009E94: 4183fe10                 cmp      r14d, 0x10
0x00009E98: 7516                     jne      0x180009eb0
0x00009E9A: 4080fe30                 cmp      sil, 0x30
0x00009E9E: 7510                     jne      0x180009eb0
0x00009EA0: 8a03                     mov      al, byte ptr [rbx]
0x00009EA2: 2c58                     sub      al, 0x58
0x00009EA4: a8df                     test     al, 0xdf
0x00009EA6: 7508                     jne      0x180009eb0
0x00009EA8: 408a7301                 mov      sil, byte ptr [rbx + 1]
0x00009EAC: 4883c302                 add      rbx, 2
0x00009EB0: 4d8b9008010000           mov      r10, qword ptr [r8 + 0x108]
0x00009EB7: 33d2                     xor      edx, edx
0x00009EB9: 83c8ff                   or       eax, 0xffffffff
0x00009EBC: 41f7f6                   div      r14d
0x00009EBF: 448bc8                   mov      r9d, eax
0x00009EC2: 400fb6ce                 movzx    ecx, sil
0x00009EC6: 450fb7044a               movzx    r8d, word ptr [r10 + rcx*2]
0x00009ECB: 418bc8                   mov      ecx, r8d
0x00009ECE: 83e104                   and      ecx, 4
0x00009ED1: 7409                     je       0x180009edc
0x00009ED3: 400fbece                 movsx    ecx, sil
0x00009ED7: 83e930                   sub      ecx, 0x30
0x00009EDA: eb1a                     jmp      0x180009ef6
0x00009EDC: 4181e003010000           and      r8d, 0x103
0x00009EE3: 742c                     je       0x180009f11
0x00009EE5: 8d469f                   lea      eax, [rsi - 0x61]
0x00009EE8: 400fbece                 movsx    ecx, sil
0x00009EEC: 3c19                     cmp      al, 0x19
0x00009EEE: 7703                     ja       0x180009ef3
0x00009EF0: 83e920                   sub      ecx, 0x20
0x00009EF3: 83c1c9                   add      ecx, -0x37
0x00009EF6: 413bce                   cmp      ecx, r14d
0x00009EF9: 7316                     jae      0x180009f11
0x00009EFB: 83cd08                   or       ebp, 8
0x00009EFE: 413bf9                   cmp      edi, r9d
0x00009F01: 7222                     jb       0x180009f25
0x00009F03: 7504                     jne      0x180009f09
0x00009F05: 3bca                     cmp      ecx, edx
0x00009F07: 761c                     jbe      0x180009f25
0x00009F09: 83cd04                   or       ebp, 4
0x00009F0C: 4d85ff                   test     r15, r15
0x00009F0F: 751a                     jne      0x180009f2b
0x00009F11: 48ffcb                   dec      rbx
0x00009F14: 40f6c508                 test     bpl, 8
0x00009F18: 7519                     jne      0x180009f33
0x00009F1A: 4d85ff                   test     r15, r15
0x00009F1D: 490f45dc                 cmovne   rbx, r12
0x00009F21: 33ff                     xor      edi, edi
0x00009F23: eb59                     jmp      0x180009f7e
0x00009F25: 410faffe                 imul     edi, r14d
0x00009F29: 03f9                     add      edi, ecx
0x00009F2B: 408a33                   mov      sil, byte ptr [rbx]
0x00009F2E: 48ffc3                   inc      rbx
0x00009F31: eb8f                     jmp      0x180009ec2
0x00009F33: beffffff7f               mov      esi, 0x7fffffff
0x00009F38: 40f6c504                 test     bpl, 4
0x00009F3C: 751d                     jne      0x180009f5b
0x00009F3E: 40f6c501                 test     bpl, 1
0x00009F42: 753a                     jne      0x180009f7e
0x00009F44: 8bc5                     mov      eax, ebp
0x00009F46: 83e002                   and      eax, 2
0x00009F49: 7408                     je       0x180009f53
0x00009F4B: 81ff00000080             cmp      edi, 0x80000000
0x00009F51: 7708                     ja       0x180009f5b
0x00009F53: 85c0                     test     eax, eax
0x00009F55: 7527                     jne      0x180009f7e
0x00009F57: 3bfe                     cmp      edi, esi
0x00009F59: 7623                     jbe      0x180009f7e
0x00009F5B: e82c87ffff               call     0x18000268c
0x00009F60: c70022000000             mov      dword ptr [rax], 0x22
0x00009F66: 40f6c501                 test     bpl, 1
0x00009F6A: 7405                     je       0x180009f71
0x00009F6C: 83cfff                   or       edi, 0xffffffff
0x00009F6F: eb0d                     jmp      0x180009f7e
0x00009F71: 408ac5                   mov      al, bpl
0x00009F74: 2402                     and      al, 2
0x00009F76: f6d8                     neg      al
0x00009F78: 1bff                     sbb      edi, edi
0x00009F7A: f7df                     neg      edi
0x00009F7C: 03fe                     add      edi, esi
0x00009F7E: 4d85ff                   test     r15, r15
0x00009F81: 7403                     je       0x180009f86
0x00009F83: 49891f                   mov      qword ptr [r15], rbx
0x00009F86: 40f6c502                 test     bpl, 2
0x00009F8A: 7402                     je       0x180009f8e
0x00009F8C: f7df                     neg      edi
0x00009F8E: 807c243800               cmp      byte ptr [rsp + 0x38], 0
0x00009F93: 740c                     je       0x180009fa1
0x00009F95: 488b4c2430               mov      rcx, qword ptr [rsp + 0x30]
0x00009F9A: 83a1c8000000fd           and      dword ptr [rcx + 0xc8], 0xfffffffd
0x00009FA1: 4c8d5c2440               lea      r11, [rsp + 0x40]
0x00009FA6: 8bc7                     mov      eax, edi
0x00009FA8: 498b5b30                 mov      rbx, qword ptr [r11 + 0x30]
0x00009FAC: 498b6b40                 mov      rbp, qword ptr [r11 + 0x40]
0x00009FB0: 498be3                   mov      rsp, r11
0x00009FB3: 415f                     pop      r15
0x00009FB5: 415e                     pop      r14
0x00009FB7: 415c                     pop      r12
0x00009FB9: 5f                       pop      rdi
0x00009FBA: 5e                       pop      rsi
0x00009FBB: c3                       ret      
0x00009FBC: 4883ec38                 sub      rsp, 0x38
0x00009FC0: 33c0                     xor      eax, eax
0x00009FC2: 458bc8                   mov      r9d, r8d
0x00009FC5: 4c8bc2                   mov      r8, rdx
0x00009FC8: 39052afb0000             cmp      dword ptr [rip + 0xfb2a], eax
0x00009FCE: 89442420                 mov      dword ptr [rsp + 0x20], eax
0x00009FD2: 488bd1                   mov      rdx, rcx
0x00009FD5: 7509                     jne      0x180009fe0
0x00009FD7: 488d0d5adf0000           lea      rcx, [rip + 0xdf5a]
0x00009FDE: eb02                     jmp      0x180009fe2
0x00009FE0: 33c9                     xor      ecx, ecx
0x00009FE2: e899fdffff               call     0x180009d80
0x00009FE7: 4883c438                 add      rsp, 0x38
0x00009FEB: c3                       ret      
0x00009FEC: 48895c2410               mov      qword ptr [rsp + 0x10], rbx
0x00009FF1: 48896c2418               mov      qword ptr [rsp + 0x18], rbp
0x00009FF6: 57                       push     rdi
0x00009FF7: 4883ec40                 sub      rsp, 0x40
0x00009FFB: 488364245000             and      qword ptr [rsp + 0x50], 0
0x0000A001: 488b1d20ed0000           mov      rbx, qword ptr [rip + 0xed20]
0x0000A008: 488b03                   mov      rax, qword ptr [rbx]
0x0000A00B: 4885c0                   test     rax, rax
0x0000A00E: 0f84aa000000             je       0x18000a0be
0x0000A014: 83cdff                   or       ebp, 0xffffffff
0x0000A017: 488364243800             and      qword ptr [rsp + 0x38], 0
0x0000A01D: 488364243000             and      qword ptr [rsp + 0x30], 0
0x0000A023: 8364242800               and      dword ptr [rsp + 0x28], 0
0x0000A028: 488364242000             and      qword ptr [rsp + 0x20], 0
0x0000A02E: 448bcd                   mov      r9d, ebp
0x0000A031: 4c8bc0                   mov      r8, rax
0x0000A034: 33d2                     xor      edx, edx
0x0000A036: 33c9                     xor      ecx, ecx
0x0000A038: 57                       push     rdi
0x0000A039: e8a2960300               call     0x1800436e0
0x0000A03E: 4863f8                   movsxd   rdi, eax
0x0000A041: 85c0                     test     eax, eax
0x0000A043: 0f8491000000             je       0x18000a0da
0x0000A049: 488bcf                   mov      rcx, rdi
0x0000A04C: ba01000000               mov      edx, 1
0x0000A051: e80293ffff               call     0x180003358
0x0000A056: 4889442450               mov      qword ptr [rsp + 0x50], rax
0x0000A05B: 4885c0                   test     rax, rax
0x0000A05E: 747a                     je       0x18000a0da
0x0000A060: 488364243800             and      qword ptr [rsp + 0x38], 0
0x0000A066: 488364243000             and      qword ptr [rsp + 0x30], 0
0x0000A06C: 4c8b03                   mov      r8, qword ptr [rbx]
0x0000A06F: 448bcd                   mov      r9d, ebp
0x0000A072: 33d2                     xor      edx, edx
0x0000A074: 33c9                     xor      ecx, ecx
0x0000A076: 897c2428                 mov      dword ptr [rsp + 0x28], edi
0x0000A07A: 4889442420               mov      qword ptr [rsp + 0x20], rax
0x0000A07F: e859bb2400               call     0x180255bdd
0x0000A084: 6585c0                   test     eax, eax
0x0000A087: 7447                     je       0x18000a0d0
0x0000A089: 488d4c2450               lea      rcx, [rsp + 0x50]
0x0000A08E: 33d2                     xor      edx, edx
0x0000A090: e8470a0000               call     0x18000aadc
0x0000A095: 85c0                     test     eax, eax
0x0000A097: 7915                     jns      0x18000a0ae
0x0000A099: 488b4c2450               mov      rcx, qword ptr [rsp + 0x50]
0x0000A09E: 4885c9                   test     rcx, rcx
0x0000A0A1: 740b                     je       0x18000a0ae
0x0000A0A3: e88877ffff               call     0x180001830
0x0000A0A8: 488364245000             and      qword ptr [rsp + 0x50], 0
0x0000A0AE: 4883c308                 add      rbx, 8
0x0000A0B2: 488b03                   mov      rax, qword ptr [rbx]
0x0000A0B5: 4885c0                   test     rax, rax
0x0000A0B8: 0f8559ffffff             jne      0x18000a017
0x0000A0BE: 33c0                     xor      eax, eax
0x0000A0C0: 488b5c2458               mov      rbx, qword ptr [rsp + 0x58]
0x0000A0C5: 488b6c2460               mov      rbp, qword ptr [rsp + 0x60]
0x0000A0CA: 4883c440                 add      rsp, 0x40
0x0000A0CE: 5f                       pop      rdi
0x0000A0CF: c3                       ret      
0x0000A0D0: 488b4c2450               mov      rcx, qword ptr [rsp + 0x50]
0x0000A0D5: e85677ffff               call     0x180001830
0x0000A0DA: 8bc5                     mov      eax, ebp
0x0000A0DC: ebe2                     jmp      0x18000a0c0
0x0000A0DE: cc                       int3     
0x0000A0DF: cc                       int3     
0x0000A0E0: 4533c9                   xor      r9d, r9d
0x0000A0E3: e900000000               jmp      0x18000a0e8
0x0000A0E8: 488bc4                   mov      rax, rsp
0x0000A0EB: 48895808                 mov      qword ptr [rax + 8], rbx
0x0000A0EF: 48896810                 mov      qword ptr [rax + 0x10], rbp
0x0000A0F3: 48897018                 mov      qword ptr [rax + 0x18], rsi
0x0000A0F7: 48897820                 mov      qword ptr [rax + 0x20], rdi
0x0000A0FB: 4156                     push     r14
0x0000A0FD: 4883ec60                 sub      rsp, 0x60
0x0000A101: 488be9                   mov      rbp, rcx
0x0000A104: 488bf2                   mov      rsi, rdx
0x0000A107: 488d48d8                 lea      rcx, [rax - 0x28]
0x0000A10B: 498bd1                   mov      rdx, r9
0x0000A10E: 4d8bf1                   mov      r14, r9
0x0000A111: 498bf8                   mov      rdi, r8
0x0000A114: e87fbfffff               call     0x180006098
0x0000A119: 4885ff                   test     rdi, rdi
0x0000A11C: 7507                     jne      0x18000a125
0x0000A11E: 33db                     xor      ebx, ebx
0x0000A120: e992000000               jmp      0x18000a1b7
0x0000A125: 4885ed                   test     rbp, rbp
0x0000A128: 7405                     je       0x18000a12f
0x0000A12A: 4885f6                   test     rsi, rsi
0x0000A12D: 7517                     jne      0x18000a146
0x0000A12F: e85885ffff               call     0x18000268c
0x0000A134: c70016000000             mov      dword ptr [rax], 0x16
0x0000A13A: e86597ffff               call     0x1800038a4
0x0000A13F: bbffffff7f               mov      ebx, 0x7fffffff
0x0000A144: eb71                     jmp      0x18000a1b7
0x0000A146: bbffffff7f               mov      ebx, 0x7fffffff
0x0000A14B: 483bfb                   cmp      rdi, rbx
0x0000A14E: 7612                     jbe      0x18000a162
0x0000A150: e83785ffff               call     0x18000268c
0x0000A155: c70016000000             mov      dword ptr [rax], 0x16
0x0000A15B: e84497ffff               call     0x1800038a4
0x0000A160: eb55                     jmp      0x18000a1b7
0x0000A162: 488b542448               mov      rdx, qword ptr [rsp + 0x48]
0x0000A167: 837a0800                 cmp      dword ptr [rdx + 8], 0
0x0000A16B: 7515                     jne      0x18000a182
0x0000A16D: 4d8bce                   mov      r9, r14
0x0000A170: 4c8bc7                   mov      r8, rdi
0x0000A173: 488bd6                   mov      rdx, rsi
0x0000A176: 488bcd                   mov      rcx, rbp
0x0000A179: e8120d0000               call     0x18000ae90
0x0000A17E: 8bd8                     mov      ebx, eax
0x0000A180: eb35                     jmp      0x18000a1b7
0x0000A182: 8b4204                   mov      eax, dword ptr [rdx + 4]
0x0000A185: 488b9220020000           mov      rdx, qword ptr [rdx + 0x220]
0x0000A18C: 488d4c2440               lea      rcx, [rsp + 0x40]
0x0000A191: 89442438                 mov      dword ptr [rsp + 0x38], eax
0x0000A195: 897c2430                 mov      dword ptr [rsp + 0x30], edi
0x0000A199: 4c8bcd                   mov      r9, rbp
0x0000A19C: 41b801100000             mov      r8d, 0x1001
0x0000A1A2: 4889742428               mov      qword ptr [rsp + 0x28], rsi
0x0000A1A7: 897c2420                 mov      dword ptr [rsp + 0x20], edi
0x0000A1AB: e848110000               call     0x18000b2f8
0x0000A1B0: 85c0                     test     eax, eax
0x0000A1B2: 7403                     je       0x18000a1b7
0x0000A1B4: 8d58fe                   lea      ebx, [rax - 2]
0x0000A1B7: 807c245800               cmp      byte ptr [rsp + 0x58], 0
0x0000A1BC: 740c                     je       0x18000a1ca
0x0000A1BE: 488b442450               mov      rax, qword ptr [rsp + 0x50]
0x0000A1C3: 83a0c8000000fd           and      dword ptr [rax + 0xc8], 0xfffffffd
0x0000A1CA: 4c8d5c2460               lea      r11, [rsp + 0x60]
0x0000A1CF: 8bc3                     mov      eax, ebx
0x0000A1D1: 498b5b10                 mov      rbx, qword ptr [r11 + 0x10]
0x0000A1D5: 498b6b18                 mov      rbp, qword ptr [r11 + 0x18]
0x0000A1D9: 498b7320                 mov      rsi, qword ptr [r11 + 0x20]
0x0000A1DD: 498b7b28                 mov      rdi, qword ptr [r11 + 0x28]
0x0000A1E1: 498be3                   mov      rsp, r11
0x0000A1E4: 415e                     pop      r14
0x0000A1E6: c3                       ret      
0x0000A1E7: cc                       int3     
0x0000A1E8: 4057                     push     rdi
0x0000A1EA: 4883ec20                 sub      rsp, 0x20
0x0000A1EE: 488d3debdb0000           lea      rdi, [rip + 0xdbeb]
0x0000A1F5: 48393dd4db0000           cmp      qword ptr [rip + 0xdbd4], rdi
0x0000A1FC: 742b                     je       0x18000a229
0x0000A1FE: b90c000000               mov      ecx, 0xc
0x0000A203: e898b8ffff               call     0x180005aa0
0x0000A208: 90                       nop      
0x0000A209: 488bd7                   mov      rdx, rdi
0x0000A20C: 488d0dbddb0000           lea      rcx, [rip + 0xdbbd]
0x0000A213: e878dcffff               call     0x180007e90
0x0000A218: 488905b1db0000           mov      qword ptr [rip + 0xdbb1], rax
0x0000A21F: b90c000000               mov      ecx, 0xc
0x0000A224: e867baffff               call     0x180005c90
0x0000A229: 4883c420                 add      rsp, 0x20
0x0000A22D: 5f                       pop      rdi
0x0000A22E: c3                       ret      
0x0000A22F: cc                       int3     
0x0000A230: 48895c2408               mov      qword ptr [rsp + 8], rbx
0x0000A235: 57                       push     rdi
0x0000A236: 4883ec20                 sub      rsp, 0x20
0x0000A23A: 83cfff                   or       edi, 0xffffffff
0x0000A23D: 488bd9                   mov      rbx, rcx
0x0000A240: 4885c9                   test     rcx, rcx
0x0000A243: 7514                     jne      0x18000a259
0x0000A245: e84284ffff               call     0x18000268c
0x0000A24A: c70016000000             mov      dword ptr [rax], 0x16
0x0000A250: e84f96ffff               call     0x1800038a4
0x0000A255: 0bc7                     or       eax, edi
0x0000A257: eb46                     jmp      0x18000a29f
0x0000A259: f6411883                 test     byte ptr [rcx + 0x18], 0x83
0x0000A25D: 743a                     je       0x18000a299
0x0000A25F: e898e8ffff               call     0x180008afc
0x0000A264: 488bcb                   mov      rcx, rbx
0x0000A267: 8bf8                     mov      edi, eax
0x0000A269: e87a130000               call     0x18000b5e8
0x0000A26E: 488bcb                   mov      rcx, rbx
0x0000A271: e8b2e7ffff               call     0x180008a28
0x0000A276: 8bc8                     mov      ecx, eax
0x0000A278: e8eb110000               call     0x18000b468
0x0000A27D: 85c0                     test     eax, eax
0x0000A27F: 7905                     jns      0x18000a286
0x0000A281: 83cfff                   or       edi, 0xffffffff
0x0000A284: eb13                     jmp      0x18000a299
0x0000A286: 488b4b28                 mov      rcx, qword ptr [rbx + 0x28]
0x0000A28A: 4885c9                   test     rcx, rcx
0x0000A28D: 740a                     je       0x18000a299
0x0000A28F: e89c75ffff               call     0x180001830
0x0000A294: 4883632800               and      qword ptr [rbx + 0x28], 0
0x0000A299: 83631800                 and      dword ptr [rbx + 0x18], 0
0x0000A29D: 8bc7                     mov      eax, edi
0x0000A29F: 488b5c2430               mov      rbx, qword ptr [rsp + 0x30]
0x0000A2A4: 4883c420                 add      rsp, 0x20
0x0000A2A8: 5f                       pop      rdi
0x0000A2A9: c3                       ret      
0x0000A2AA: cc                       int3     
0x0000A2AB: cc                       int3     
0x0000A2AC: 48895c2410               mov      qword ptr [rsp + 0x10], rbx
0x0000A2B1: 48894c2408               mov      qword ptr [rsp + 8], rcx
0x0000A2B6: 57                       push     rdi
0x0000A2B7: 4883ec20                 sub      rsp, 0x20
0x0000A2BB: 488bd9                   mov      rbx, rcx
0x0000A2BE: 83cfff                   or       edi, 0xffffffff
0x0000A2C1: 33c0                     xor      eax, eax
0x0000A2C3: 4885c9                   test     rcx, rcx
0x0000A2C6: 0f95c0                   setne    al
0x0000A2C9: 85c0                     test     eax, eax
0x0000A2CB: 7514                     jne      0x18000a2e1
0x0000A2CD: e8ba83ffff               call     0x18000268c
0x0000A2D2: c70016000000             mov      dword ptr [rax], 0x16
0x0000A2D8: e8c795ffff               call     0x1800038a4
0x0000A2DD: 8bc7                     mov      eax, edi
0x0000A2DF: eb26                     jmp      0x18000a307
0x0000A2E1: f6411840                 test     byte ptr [rcx + 0x18], 0x40
0x0000A2E5: 7406                     je       0x18000a2ed
0x0000A2E7: 83611800                 and      dword ptr [rcx + 0x18], 0
0x0000A2EB: ebf0                     jmp      0x18000a2dd
0x0000A2ED: e8cadcffff               call     0x180007fbc
0x0000A2F2: 90                       nop      
0x0000A2F3: 488bcb                   mov      rcx, rbx
0x0000A2F6: e835ffffff               call     0x18000a230
0x0000A2FB: 8bf8                     mov      edi, eax
0x0000A2FD: 488bcb                   mov      rcx, rbx
0x0000A300: e853ddffff               call     0x180008058
0x0000A305: ebd6                     jmp      0x18000a2dd
0x0000A307: 488b5c2438               mov      rbx, qword ptr [rsp + 0x38]
0x0000A30C: 4883c420                 add      rsp, 0x20
0x0000A310: 5f                       pop      rdi
0x0000A311: c3                       ret      
0x0000A312: cc                       int3     
0x0000A313: cc                       int3     
0x0000A314: 48895c2408               mov      qword ptr [rsp + 8], rbx
0x0000A319: 4889742410               mov      qword ptr [rsp + 0x10], rsi
0x0000A31E: 48897c2418               mov      qword ptr [rsp + 0x18], rdi
0x0000A323: 4157                     push     r15
0x0000A325: 4883ec20                 sub      rsp, 0x20
0x0000A329: 4863c1                   movsxd   rax, ecx
0x0000A32C: 488bf0                   mov      rsi, rax
0x0000A32F: 48c1fe05                 sar      rsi, 5
0x0000A333: 4c8d3d86f00000           lea      r15, [rip + 0xf086]
0x0000A33A: 83e01f                   and      eax, 0x1f
0x0000A33D: 486bd858                 imul     rbx, rax, 0x58
0x0000A341: 498b3cf7                 mov      rdi, qword ptr [r15 + rsi*8]
0x0000A345: 837c3b0c00               cmp      dword ptr [rbx + rdi + 0xc], 0
0x0000A34A: 7534                     jne      0x18000a380
0x0000A34C: b90a000000               mov      ecx, 0xa
0x0000A351: e84ab7ffff               call     0x180005aa0
0x0000A356: 90                       nop      
0x0000A357: 837c3b0c00               cmp      dword ptr [rbx + rdi + 0xc], 0
0x0000A35C: 7518                     jne      0x18000a376
0x0000A35E: 488d4b10                 lea      rcx, [rbx + 0x10]
0x0000A362: 4803cf                   add      rcx, rdi
0x0000A365: 4533c0                   xor      r8d, r8d
0x0000A368: baa00f0000               mov      edx, 0xfa0
0x0000A36D: e8aeabffff               call     0x180004f20
0x0000A372: ff443b0c                 inc      dword ptr [rbx + rdi + 0xc]
0x0000A376: b90a000000               mov      ecx, 0xa
0x0000A37B: e810b9ffff               call     0x180005c90
0x0000A380: 498b0cf7                 mov      rcx, qword ptr [r15 + rsi*8]
0x0000A384: 4883c110                 add      rcx, 0x10
0x0000A388: 4803cb                   add      rcx, rbx
0x0000A38B: 52                       push     rdx
0x0000A38C: e89dbd0e00               call     0x1800f612e
0x0000A391: b801000000               mov      eax, 1
0x0000A396: 488b5c2430               mov      rbx, qword ptr [rsp + 0x30]
0x0000A39B: 488b742438               mov      rsi, qword ptr [rsp + 0x38]
0x0000A3A0: 488b7c2440               mov      rdi, qword ptr [rsp + 0x40]
0x0000A3A5: 4883c420                 add      rsp, 0x20
0x0000A3A9: 415f                     pop      r15
0x0000A3AB: c3                       ret      
0x0000A3AC: 48895c2408               mov      qword ptr [rsp + 8], rbx
0x0000A3B1: 48897c2410               mov      qword ptr [rsp + 0x10], rdi
0x0000A3B6: 4156                     push     r14
0x0000A3B8: 4883ec20                 sub      rsp, 0x20
0x0000A3BC: 85c9                     test     ecx, ecx
0x0000A3BE: 786f                     js       0x18000a42f
0x0000A3C0: 3b0dc2330100             cmp      ecx, dword ptr [rip + 0x133c2]
0x0000A3C6: 7367                     jae      0x18000a42f
0x0000A3C8: 4863c1                   movsxd   rax, ecx
0x0000A3CB: 4c8d35eeef0000           lea      r14, [rip + 0xefee]
0x0000A3D2: 488bf8                   mov      rdi, rax
0x0000A3D5: 83e01f                   and      eax, 0x1f
0x0000A3D8: 48c1ff05                 sar      rdi, 5
0x0000A3DC: 486bd858                 imul     rbx, rax, 0x58
0x0000A3E0: 498b04fe                 mov      rax, qword ptr [r14 + rdi*8]
0x0000A3E4: f644180801               test     byte ptr [rax + rbx + 8], 1
0x0000A3E9: 7444                     je       0x18000a42f
0x0000A3EB: 48833c18ff               cmp      qword ptr [rax + rbx], -1
0x0000A3F0: 743d                     je       0x18000a42f
0x0000A3F2: 833d67e9000001           cmp      dword ptr [rip + 0xe967], 1
0x0000A3F9: 7527                     jne      0x18000a422
0x0000A3FB: 85c9                     test     ecx, ecx
0x0000A3FD: 7416                     je       0x18000a415
0x0000A3FF: ffc9                     dec      ecx
0x0000A401: 740b                     je       0x18000a40e
0x0000A403: ffc9                     dec      ecx
0x0000A405: 751b                     jne      0x18000a422
0x0000A407: b9f4ffffff               mov      ecx, 0xfffffff4
0x0000A40C: eb0c                     jmp      0x18000a41a
0x0000A40E: b9f5ffffff               mov      ecx, 0xfffffff5
0x0000A413: eb05                     jmp      0x18000a41a
0x0000A415: b9f6ffffff               mov      ecx, 0xfffffff6
0x0000A41A: 33d2                     xor      edx, edx
0x0000A41C: 53                       push     rbx
0x0000A41D: e878e90f00               call     0x180108d9a
0x0000A422: 498b04fe                 mov      rax, qword ptr [r14 + rdi*8]
0x0000A426: 48830c03ff               or       qword ptr [rbx + rax], 0xffffffffffffffff
0x0000A42B: 33c0                     xor      eax, eax
0x0000A42D: eb16                     jmp      0x18000a445
0x0000A42F: e85882ffff               call     0x18000268c
0x0000A434: c70009000000             mov      dword ptr [rax], 9
0x0000A43A: e8dd81ffff               call     0x18000261c
0x0000A43F: 832000                   and      dword ptr [rax], 0
0x0000A442: 83c8ff                   or       eax, 0xffffffff
0x0000A445: 488b5c2430               mov      rbx, qword ptr [rsp + 0x30]
0x0000A44A: 488b7c2438               mov      rdi, qword ptr [rsp + 0x38]
0x0000A44F: 4883c420                 add      rsp, 0x20
0x0000A453: 415e                     pop      r14
0x0000A455: c3                       ret      
0x0000A456: cc                       int3     
0x0000A457: cc                       int3     
0x0000A458: 4883ec28                 sub      rsp, 0x28
0x0000A45C: 83f9fe                   cmp      ecx, -2
0x0000A45F: 7515                     jne      0x18000a476
0x0000A461: e8b681ffff               call     0x18000261c
0x0000A466: 832000                   and      dword ptr [rax], 0
0x0000A469: e81e82ffff               call     0x18000268c
0x0000A46E: c70009000000             mov      dword ptr [rax], 9
0x0000A474: eb4d                     jmp      0x18000a4c3
0x0000A476: 85c9                     test     ecx, ecx
0x0000A478: 7831                     js       0x18000a4ab
0x0000A47A: 3b0d08330100             cmp      ecx, dword ptr [rip + 0x13308]
0x0000A480: 7329                     jae      0x18000a4ab
0x0000A482: 4863c9                   movsxd   rcx, ecx
0x0000A485: 4c8d0534ef0000           lea      r8, [rip + 0xef34]
0x0000A48C: 488bc1                   mov      rax, rcx
0x0000A48F: 83e11f                   and      ecx, 0x1f
0x0000A492: 48c1f805                 sar      rax, 5
0x0000A496: 486bd158                 imul     rdx, rcx, 0x58
0x0000A49A: 498b04c0                 mov      rax, qword ptr [r8 + rax*8]
0x0000A49E: f644100801               test     byte ptr [rax + rdx + 8], 1
0x0000A4A3: 7406                     je       0x18000a4ab
0x0000A4A5: 488b0410                 mov      rax, qword ptr [rax + rdx]
0x0000A4A9: eb1c                     jmp      0x18000a4c7
0x0000A4AB: e86c81ffff               call     0x18000261c
0x0000A4B0: 832000                   and      dword ptr [rax], 0
0x0000A4B3: e8d481ffff               call     0x18000268c
0x0000A4B8: c70009000000             mov      dword ptr [rax], 9
0x0000A4BE: e8e193ffff               call     0x1800038a4
0x0000A4C3: 4883c8ff                 or       rax, 0xffffffffffffffff
0x0000A4C7: 4883c428                 add      rsp, 0x28
0x0000A4CB: c3                       ret      
0x0000A4CC: 4863d1                   movsxd   rdx, ecx
0x0000A4CF: 4c8d05eaee0000           lea      r8, [rip + 0xeeea]
0x0000A4D6: 488bc2                   mov      rax, rdx
0x0000A4D9: 83e21f                   and      edx, 0x1f
0x0000A4DC: 48c1f805                 sar      rax, 5
0x0000A4E0: 486bca58                 imul     rcx, rdx, 0x58
0x0000A4E4: 498b04c0                 mov      rax, qword ptr [r8 + rax*8]
0x0000A4E8: 4883c110                 add      rcx, 0x10
0x0000A4EC: 4803c8                   add      rcx, rax
0x0000A4EF: 4855                     push     rbp
0x0000A4F1: e81a562000               call     0x18020fb10
0x0000A4F6: cc                       int3     
0x0000A4F7: cc                       int3     
0x0000A4F8: 4053                     push     rbx
0x0000A4FA: 4883ec40                 sub      rsp, 0x40
0x0000A4FE: 8bd9                     mov      ebx, ecx
0x0000A500: 488d4c2420               lea      rcx, [rsp + 0x20]
0x0000A505: e88ebbffff               call     0x180006098
0x0000A50A: 488b442420               mov      rax, qword ptr [rsp + 0x20]
0x0000A50F: 0fb6d3                   movzx    edx, bl
0x0000A512: 488b8808010000           mov      rcx, qword ptr [rax + 0x108]
0x0000A519: 0fb70451                 movzx    eax, word ptr [rcx + rdx*2]
0x0000A51D: 2500800000               and      eax, 0x8000
0x0000A522: 807c243800               cmp      byte ptr [rsp + 0x38], 0
0x0000A527: 740c                     je       0x18000a535
0x0000A529: 488b4c2430               mov      rcx, qword ptr [rsp + 0x30]
0x0000A52E: 83a1c8000000fd           and      dword ptr [rcx + 0xc8], 0xfffffffd
0x0000A535: 4883c440                 add      rsp, 0x40
0x0000A539: 5b                       pop      rbx
0x0000A53A: c3                       ret      
0x0000A53B: cc                       int3     
0x0000A53C: 4053                     push     rbx
0x0000A53E: 4883ec40                 sub      rsp, 0x40
0x0000A542: 8bd9                     mov      ebx, ecx
0x0000A544: 488d4c2420               lea      rcx, [rsp + 0x20]
0x0000A549: 33d2                     xor      edx, edx
0x0000A54B: e848bbffff               call     0x180006098
0x0000A550: 488b442420               mov      rax, qword ptr [rsp + 0x20]
0x0000A555: 0fb6d3                   movzx    edx, bl
0x0000A558: 488b8808010000           mov      rcx, qword ptr [rax + 0x108]
0x0000A55F: 0fb70451                 movzx    eax, word ptr [rcx + rdx*2]
0x0000A563: 2500800000               and      eax, 0x8000
0x0000A568: 807c243800               cmp      byte ptr [rsp + 0x38], 0
0x0000A56D: 740c                     je       0x18000a57b
0x0000A56F: 488b4c2430               mov      rcx, qword ptr [rsp + 0x30]
0x0000A574: 83a1c8000000fd           and      dword ptr [rcx + 0xc8], 0xfffffffd
0x0000A57B: 4883c440                 add      rsp, 0x40
0x0000A57F: 5b                       pop      rbx
0x0000A580: c3                       ret      
0x0000A581: cc                       int3     
0x0000A582: cc                       int3     
0x0000A583: cc                       int3     
0x0000A584: 48895c2408               mov      qword ptr [rsp + 8], rbx
0x0000A589: 4889742410               mov      qword ptr [rsp + 0x10], rsi
0x0000A58E: 57                       push     rdi
0x0000A58F: 4883ec20                 sub      rsp, 0x20
0x0000A593: 4863d9                   movsxd   rbx, ecx
0x0000A596: 418bf8                   mov      edi, r8d
0x0000A599: 488bf2                   mov      rsi, rdx
0x0000A59C: 8bcb                     mov      ecx, ebx
0x0000A59E: e8b5feffff               call     0x18000a458
0x0000A5A3: 4883f8ff                 cmp      rax, -1
0x0000A5A7: 7511                     jne      0x18000a5ba
0x0000A5A9: e8de80ffff               call     0x18000268c
0x0000A5AE: c70009000000             mov      dword ptr [rax], 9
0x0000A5B4: 4883c8ff                 or       rax, 0xffffffffffffffff
0x0000A5B8: eb4d                     jmp      0x18000a607
0x0000A5BA: 4c8d442448               lea      r8, [rsp + 0x48]
0x0000A5BF: 448bcf                   mov      r9d, edi
0x0000A5C2: 488bd6                   mov      rdx, rsi
0x0000A5C5: 488bc8                   mov      rcx, rax
0x0000A5C8: 50                       push     rax
0x0000A5C9: e8e6720100               call     0x1800218b4
0x0000A5CE: 85c0                     test     eax, eax
0x0000A5D0: 750f                     jne      0x18000a5e1
0x0000A5D2: e85f740100               call     0x180021a36
0x0000A5D7: bb8bc8e85d               mov      ebx, 0x5de8c88b
0x0000A5DC: 80ffff                   cmp      bh, 0xff
0x0000A5DF: ebd3                     jmp      0x18000a5b4
0x0000A5E1: 488bcb                   mov      rcx, rbx
0x0000A5E4: 488bc3                   mov      rax, rbx
0x0000A5E7: 488d15d2ed0000           lea      rdx, [rip + 0xedd2]
0x0000A5EE: 48c1f805                 sar      rax, 5
0x0000A5F2: 83e11f                   and      ecx, 0x1f
0x0000A5F5: 488b04c2                 mov      rax, qword ptr [rdx + rax*8]
0x0000A5F9: 486bc958                 imul     rcx, rcx, 0x58
0x0000A5FD: 80640808fd               and      byte ptr [rax + rcx + 8], 0xfd
0x0000A602: 488b442448               mov      rax, qword ptr [rsp + 0x48]
0x0000A607: 488b5c2430               mov      rbx, qword ptr [rsp + 0x30]
0x0000A60C: 488b742438               mov      rsi, qword ptr [rsp + 0x38]
0x0000A611: 4883c420                 add      rsp, 0x20
0x0000A615: 5f                       pop      rdi
0x0000A616: c3                       ret      
0x0000A617: cc                       int3     
0x0000A618: 488bc4                   mov      rax, rsp
0x0000A61B: 48895808                 mov      qword ptr [rax + 8], rbx
0x0000A61F: 48896810                 mov      qword ptr [rax + 0x10], rbp
0x0000A623: 48897018                 mov      qword ptr [rax + 0x18], rsi
0x0000A627: 48897820                 mov      qword ptr [rax + 0x20], rdi
0x0000A62B: 4156                     push     r14
0x0000A62D: 4883ec50                 sub      rsp, 0x50
0x0000A631: 4533f6                   xor      r14d, r14d
0x0000A634: 498be8                   mov      rbp, r8
0x0000A637: 488bf2                   mov      rsi, rdx
0x0000A63A: 488bf9                   mov      rdi, rcx
0x0000A63D: 4885d2                   test     rdx, rdx
0x0000A640: 7413                     je       0x18000a655
0x0000A642: 4d85c0                   test     r8, r8
0x0000A645: 740e                     je       0x18000a655
0x0000A647: 443832                   cmp      byte ptr [rdx], r14b
0x0000A64A: 7526                     jne      0x18000a672
0x0000A64C: 4885c9                   test     rcx, rcx
0x0000A64F: 7404                     je       0x18000a655
0x0000A651: 66448931                 mov      word ptr [rcx], r14w
0x0000A655: 33c0                     xor      eax, eax
0x0000A657: 488b5c2460               mov      rbx, qword ptr [rsp + 0x60]
0x0000A65C: 488b6c2468               mov      rbp, qword ptr [rsp + 0x68]
0x0000A661: 488b742470               mov      rsi, qword ptr [rsp + 0x70]
0x0000A666: 488b7c2478               mov      rdi, qword ptr [rsp + 0x78]
0x0000A66B: 4883c450                 add      rsp, 0x50
0x0000A66F: 415e                     pop      r14
0x0000A671: c3                       ret      
0x0000A672: 488d4c2430               lea      rcx, [rsp + 0x30]
0x0000A677: 498bd1                   mov      rdx, r9
0x0000A67A: e819baffff               call     0x180006098
0x0000A67F: 488b442430               mov      rax, qword ptr [rsp + 0x30]
0x0000A684: 4c39b038010000           cmp      qword ptr [rax + 0x138], r14
0x0000A68B: 7515                     jne      0x18000a6a2
0x0000A68D: 4885ff                   test     rdi, rdi
0x0000A690: 7406                     je       0x18000a698
0x0000A692: 0fb606                   movzx    eax, byte ptr [rsi]
0x0000A695: 668907                   mov      word ptr [rdi], ax
0x0000A698: bb01000000               mov      ebx, 1
0x0000A69D: e9ad000000               jmp      0x18000a74f
0x0000A6A2: 0fb60e                   movzx    ecx, byte ptr [rsi]
0x0000A6A5: 488d542430               lea      rdx, [rsp + 0x30]
0x0000A6AA: e849feffff               call     0x18000a4f8
0x0000A6AF: bb01000000               mov      ebx, 1
0x0000A6B4: 85c0                     test     eax, eax
0x0000A6B6: 745a                     je       0x18000a712
0x0000A6B8: 488b4c2430               mov      rcx, qword ptr [rsp + 0x30]
0x0000A6BD: 448b89d4000000           mov      r9d, dword ptr [rcx + 0xd4]
0x0000A6C4: 443bcb                   cmp      r9d, ebx
0x0000A6C7: 7e2f                     jle      0x18000a6f8
0x0000A6C9: 413be9                   cmp      ebp, r9d
0x0000A6CC: 7c2a                     jl       0x18000a6f8
0x0000A6CE: 8b4904                   mov      ecx, dword ptr [rcx + 4]
0x0000A6D1: 418bc6                   mov      eax, r14d
0x0000A6D4: 4885ff                   test     rdi, rdi
0x0000A6D7: 0f95c0                   setne    al
0x0000A6DA: 8d5308                   lea      edx, [rbx + 8]
0x0000A6DD: 4c8bc6                   mov      r8, rsi
0x0000A6E0: 89442428                 mov      dword ptr [rsp + 0x28], eax
0x0000A6E4: 48897c2420               mov      qword ptr [rsp + 0x20], rdi
0x0000A6E9: e856421300               call     0x18013e944
0x0000A6EE: 7248                     jb       0x18000a738
0x0000A6F0: 8b4c2430                 mov      ecx, dword ptr [rsp + 0x30]
0x0000A6F4: 85c0                     test     eax, eax
0x0000A6F6: 7512                     jne      0x18000a70a
0x0000A6F8: 486381d4000000           movsxd   rax, dword ptr [rcx + 0xd4]
0x0000A6FF: 483be8                   cmp      rbp, rax
0x0000A702: 723d                     jb       0x18000a741
0x0000A704: 44387601                 cmp      byte ptr [rsi + 1], r14b
0x0000A708: 7437                     je       0x18000a741
0x0000A70A: 8b99d4000000             mov      ebx, dword ptr [rcx + 0xd4]
0x0000A710: eb3d                     jmp      0x18000a74f
0x0000A712: 418bc6                   mov      eax, r14d
0x0000A715: 4885ff                   test     rdi, rdi
0x0000A718: 448bcb                   mov      r9d, ebx
0x0000A71B: 0f95c0                   setne    al
0x0000A71E: 4c8bc6                   mov      r8, rsi
0x0000A721: ba09000000               mov      edx, 9
0x0000A726: 89442428                 mov      dword ptr [rsp + 0x28], eax
0x0000A72A: 488b442430               mov      rax, qword ptr [rsp + 0x30]
0x0000A72F: 48897c2420               mov      qword ptr [rsp + 0x20], rdi
0x0000A734: 8b4804                   mov      ecx, dword ptr [rax + 4]
0x0000A737: 56                       push     rsi
0x0000A738: e868710200               call     0x1800318a5
0x0000A73D: 85c0                     test     eax, eax
0x0000A73F: 750e                     jne      0x18000a74f
0x0000A741: e8467fffff               call     0x18000268c
0x0000A746: 83cbff                   or       ebx, 0xffffffff
0x0000A749: c7002a000000             mov      dword ptr [rax], 0x2a
0x0000A74F: 4438742448               cmp      byte ptr [rsp + 0x48], r14b
0x0000A754: 740c                     je       0x18000a762
0x0000A756: 488b4c2440               mov      rcx, qword ptr [rsp + 0x40]
0x0000A75B: 83a1c8000000fd           and      dword ptr [rcx + 0xc8], 0xfffffffd
0x0000A762: 8bc3                     mov      eax, ebx
0x0000A764: e9eefeffff               jmp      0x18000a657
0x0000A769: cc                       int3     
0x0000A76A: cc                       int3     
0x0000A76B: cc                       int3     
0x0000A76C: 4533c9                   xor      r9d, r9d
0x0000A76F: e9a4feffff               jmp      0x18000a618
0x0000A774: 66894c2408               mov      word ptr [rsp + 8], cx
0x0000A779: 4883ec38                 sub      rsp, 0x38
0x0000A77D: 488b0d6cdc0000           mov      rcx, qword ptr [rip + 0xdc6c]
0x0000A784: 4883f9fe                 cmp      rcx, -2
0x0000A788: 750c                     jne      0x18000a796
0x0000A78A: e8b10e0000               call     0x18000b640
0x0000A78F: 488b0d5adc0000           mov      rcx, qword ptr [rip + 0xdc5a]
0x0000A796: 4883f9ff                 cmp      rcx, -1
0x0000A79A: 7507                     jne      0x18000a7a3
0x0000A79C: b8ffff0000               mov      eax, 0xffff
0x0000A7A1: eb25                     jmp      0x18000a7c8
0x0000A7A3: 488364242000             and      qword ptr [rsp + 0x20], 0
0x0000A7A9: 4c8d4c2448               lea      r9, [rsp + 0x48]
0x0000A7AE: 488d542440               lea      rdx, [rsp + 0x40]
0x0000A7B3: 41b801000000             mov      r8d, 1
0x0000A7B9: 56                       push     rsi
0x0000A7BA: e8624c1900               call     0x18019f421
0x0000A7BF: 85c0                     test     eax, eax
0x0000A7C1: 74d9                     je       0x18000a79c
0x0000A7C3: 0fb7442440               movzx    eax, word ptr [rsp + 0x40]
0x0000A7C8: 4883c438                 add      rsp, 0x38
0x0000A7CC: c3                       ret      
0x0000A7CD: cc                       int3     
0x0000A7CE: cc                       int3     
0x0000A7CF: cc                       int3     
0x0000A7D0: 4889742410               mov      qword ptr [rsp + 0x10], rsi
0x0000A7D5: 55                       push     rbp
0x0000A7D6: 57                       push     rdi
0x0000A7D7: 4156                     push     r14
0x0000A7D9: 488bec                   mov      rbp, rsp
0x0000A7DC: 4883ec60                 sub      rsp, 0x60
0x0000A7E0: 4863f9                   movsxd   rdi, ecx
0x0000A7E3: 448bf2                   mov      r14d, edx
0x0000A7E6: 488d4de0                 lea      rcx, [rbp - 0x20]
0x0000A7EA: 498bd0                   mov      rdx, r8
0x0000A7ED: e8a6b8ffff               call     0x180006098
0x0000A7F2: 8d4701                   lea      eax, [rdi + 1]
0x0000A7F5: 3d00010000               cmp      eax, 0x100
0x0000A7FA: 7711                     ja       0x18000a80d
0x0000A7FC: 488b45e0                 mov      rax, qword ptr [rbp - 0x20]
0x0000A800: 488b8808010000           mov      rcx, qword ptr [rax + 0x108]
0x0000A807: 0fb70479                 movzx    eax, word ptr [rcx + rdi*2]
0x0000A80B: eb79                     jmp      0x18000a886
0x0000A80D: 8bf7                     mov      esi, edi
0x0000A80F: 488d55e0                 lea      rdx, [rbp - 0x20]
0x0000A813: c1fe08                   sar      esi, 8
0x0000A816: 400fb6ce                 movzx    ecx, sil
0x0000A81A: e8d9fcffff               call     0x18000a4f8
0x0000A81F: ba01000000               mov      edx, 1
0x0000A824: 85c0                     test     eax, eax
0x0000A826: 7412                     je       0x18000a83a
0x0000A828: 40887538                 mov      byte ptr [rbp + 0x38], sil
0x0000A82C: 40887d39                 mov      byte ptr [rbp + 0x39], dil
0x0000A830: c6453a00                 mov      byte ptr [rbp + 0x3a], 0
0x0000A834: 448d4a01                 lea      r9d, [rdx + 1]
0x0000A838: eb0b                     jmp      0x18000a845
0x0000A83A: 40887d38                 mov      byte ptr [rbp + 0x38], dil
0x0000A83E: c6453900                 mov      byte ptr [rbp + 0x39], 0
0x0000A842: 448bca                   mov      r9d, edx
0x0000A845: 488b45e0                 mov      rax, qword ptr [rbp - 0x20]
0x0000A849: 89542430                 mov      dword ptr [rsp + 0x30], edx
0x0000A84D: 4c8d4538                 lea      r8, [rbp + 0x38]
0x0000A851: 8b4804                   mov      ecx, dword ptr [rax + 4]
0x0000A854: 488d4520                 lea      rax, [rbp + 0x20]
0x0000A858: 894c2428                 mov      dword ptr [rsp + 0x28], ecx
0x0000A85C: 488d4de0                 lea      rcx, [rbp - 0x20]
0x0000A860: 4889442420               mov      qword ptr [rsp + 0x20], rax
0x0000A865: e842e1ffff               call     0x1800089ac
0x0000A86A: 85c0                     test     eax, eax
0x0000A86C: 7514                     jne      0x18000a882
0x0000A86E: 3845f8                   cmp      byte ptr [rbp - 8], al
0x0000A871: 740b                     je       0x18000a87e
0x0000A873: 488b45f0                 mov      rax, qword ptr [rbp - 0x10]
0x0000A877: 83a0c8000000fd           and      dword ptr [rax + 0xc8], 0xfffffffd
0x0000A87E: 33c0                     xor      eax, eax
0x0000A880: eb18                     jmp      0x18000a89a
0x0000A882: 0fb74520                 movzx    eax, word ptr [rbp + 0x20]
0x0000A886: 4123c6                   and      eax, r14d
0x0000A889: 807df800                 cmp      byte ptr [rbp - 8], 0
0x0000A88D: 740b                     je       0x18000a89a
0x0000A88F: 488b4df0                 mov      rcx, qword ptr [rbp - 0x10]
0x0000A893: 83a1c8000000fd           and      dword ptr [rcx + 0xc8], 0xfffffffd
0x0000A89A: 488bb42488000000         mov      rsi, qword ptr [rsp + 0x88]
0x0000A8A2: 4883c460                 add      rsp, 0x60
0x0000A8A6: 415e                     pop      r14
0x0000A8A8: 5f                       pop      rdi
0x0000A8A9: 5d                       pop      rbp
0x0000A8AA: c3                       ret      
0x0000A8AB: cc                       int3     
0x0000A8AC: 4053                     push     rbx
0x0000A8AE: 56                       push     rsi
0x0000A8AF: 57                       push     rdi
0x0000A8B0: 4881ec80000000           sub      rsp, 0x80
0x0000A8B7: 488b0542c70000           mov      rax, qword ptr [rip + 0xc742]
0x0000A8BE: 4833c4                   xor      rax, rsp
0x0000A8C1: 4889442478               mov      qword ptr [rsp + 0x78], rax
0x0000A8C6: 488bf1                   mov      rsi, rcx
0x0000A8C9: 488bda                   mov      rbx, rdx
0x0000A8CC: 488d4c2448               lea      rcx, [rsp + 0x48]
0x0000A8D1: 498bd0                   mov      rdx, r8
0x0000A8D4: 498bf9                   mov      rdi, r9
0x0000A8D7: e8bcb7ffff               call     0x180006098
0x0000A8DC: 488d442448               lea      rax, [rsp + 0x48]
0x0000A8E1: 488d542440               lea      rdx, [rsp + 0x40]
0x0000A8E6: 4889442438               mov      qword ptr [rsp + 0x38], rax
0x0000A8EB: 8364243000               and      dword ptr [rsp + 0x30], 0
0x0000A8F0: 8364242800               and      dword ptr [rsp + 0x28], 0
0x0000A8F5: 8364242000               and      dword ptr [rsp + 0x20], 0
0x0000A8FA: 488d4c2468               lea      rcx, [rsp + 0x68]
0x0000A8FF: 4533c9                   xor      r9d, r9d
0x0000A902: 4c8bc3                   mov      r8, rbx
0x0000A905: e8e6180000               call     0x18000c1f0
0x0000A90A: 8bd8                     mov      ebx, eax
0x0000A90C: 4885ff                   test     rdi, rdi
0x0000A90F: 7408                     je       0x18000a919
0x0000A911: 488b4c2440               mov      rcx, qword ptr [rsp + 0x40]
0x0000A916: 48890f                   mov      qword ptr [rdi], rcx
0x0000A919: 488d4c2468               lea      rcx, [rsp + 0x68]
0x0000A91E: 488bd6                   mov      rdx, rsi
0x0000A921: e812130000               call     0x18000bc38
0x0000A926: 8bc8                     mov      ecx, eax
0x0000A928: b803000000               mov      eax, 3
0x0000A92D: 84d8                     test     al, bl
0x0000A92F: 750c                     jne      0x18000a93d
0x0000A931: 83f901                   cmp      ecx, 1
0x0000A934: 741a                     je       0x18000a950
0x0000A936: 83f902                   cmp      ecx, 2
0x0000A939: 7513                     jne      0x18000a94e
0x0000A93B: eb05                     jmp      0x18000a942
0x0000A93D: f6c301                   test     bl, 1
0x0000A940: 7407                     je       0x18000a949
0x0000A942: b804000000               mov      eax, 4
0x0000A947: eb07                     jmp      0x18000a950
0x0000A949: f6c302                   test     bl, 2
0x0000A94C: 7502                     jne      0x18000a950
0x0000A94E: 33c0                     xor      eax, eax
0x0000A950: 807c246000               cmp      byte ptr [rsp + 0x60], 0
0x0000A955: 740c                     je       0x18000a963
0x0000A957: 488b4c2458               mov      rcx, qword ptr [rsp + 0x58]
0x0000A95C: 83a1c8000000fd           and      dword ptr [rcx + 0xc8], 0xfffffffd
0x0000A963: 488b4c2478               mov      rcx, qword ptr [rsp + 0x78]
0x0000A968: 4833cc                   xor      rcx, rsp
0x0000A96B: e8a06effff               call     0x180001810
0x0000A970: 4881c480000000           add      rsp, 0x80
0x0000A977: 5f                       pop      rdi
0x0000A978: 5e                       pop      rsi
0x0000A979: 5b                       pop      rbx
0x0000A97A: c3                       ret      
0x0000A97B: cc                       int3     
0x0000A97C: 48895c2418               mov      qword ptr [rsp + 0x18], rbx
0x0000A981: 57                       push     rdi
0x0000A982: 4881ec80000000           sub      rsp, 0x80
0x0000A989: 488b0570c60000           mov      rax, qword ptr [rip + 0xc670]
0x0000A990: 4833c4                   xor      rax, rsp
0x0000A993: 4889442478               mov      qword ptr [rsp + 0x78], rax
0x0000A998: 488bf9                   mov      rdi, rcx
0x0000A99B: 488bda                   mov      rbx, rdx
0x0000A99E: 488d4c2440               lea      rcx, [rsp + 0x40]
0x0000A9A3: 498bd0                   mov      rdx, r8
0x0000A9A6: e8edb6ffff               call     0x180006098
0x0000A9AB: 488d442440               lea      rax, [rsp + 0x40]
0x0000A9B0: 488d542460               lea      rdx, [rsp + 0x60]
0x0000A9B5: 4889442438               mov      qword ptr [rsp + 0x38], rax
0x0000A9BA: 8364243000               and      dword ptr [rsp + 0x30], 0
0x0000A9BF: 8364242800               and      dword ptr [rsp + 0x28], 0
0x0000A9C4: 8364242000               and      dword ptr [rsp + 0x20], 0
0x0000A9C9: 488d4c2468               lea      rcx, [rsp + 0x68]
0x0000A9CE: 4533c9                   xor      r9d, r9d
0x0000A9D1: 4c8bc3                   mov      r8, rbx
0x0000A9D4: e817180000               call     0x18000c1f0
0x0000A9D9: 488d4c2468               lea      rcx, [rsp + 0x68]
0x0000A9DE: 488bd7                   mov      rdx, rdi
0x0000A9E1: 8bd8                     mov      ebx, eax
0x0000A9E3: e8980c0000               call     0x18000b680
0x0000A9E8: 8bc8                     mov      ecx, eax
0x0000A9EA: b803000000               mov      eax, 3
0x0000A9EF: 84d8                     test     al, bl
0x0000A9F1: 750c                     jne      0x18000a9ff
0x0000A9F3: 83f901                   cmp      ecx, 1
0x0000A9F6: 741a                     je       0x18000aa12
0x0000A9F8: 83f902                   cmp      ecx, 2
0x0000A9FB: 7513                     jne      0x18000aa10
0x0000A9FD: eb05                     jmp      0x18000aa04
0x0000A9FF: f6c301                   test     bl, 1
0x0000AA02: 7407                     je       0x18000aa0b
0x0000AA04: b804000000               mov      eax, 4
0x0000AA09: eb07                     jmp      0x18000aa12
0x0000AA0B: f6c302                   test     bl, 2
0x0000AA0E: 7502                     jne      0x18000aa12
0x0000AA10: 33c0                     xor      eax, eax
0x0000AA12: 807c245800               cmp      byte ptr [rsp + 0x58], 0
0x0000AA17: 740c                     je       0x18000aa25
0x0000AA19: 488b4c2450               mov      rcx, qword ptr [rsp + 0x50]
0x0000AA1E: 83a1c8000000fd           and      dword ptr [rcx + 0xc8], 0xfffffffd
0x0000AA25: 488b4c2478               mov      rcx, qword ptr [rsp + 0x78]
0x0000AA2A: 4833cc                   xor      rcx, rsp
0x0000AA2D: e8de6dffff               call     0x180001810
0x0000AA32: 488b9c24a0000000         mov      rbx, qword ptr [rsp + 0xa0]
0x0000AA3A: 4881c480000000           add      rsp, 0x80
0x0000AA41: 5f                       pop      rdi
0x0000AA42: c3                       ret      
0x0000AA43: cc                       int3     
0x0000AA44: 4533c9                   xor      r9d, r9d
0x0000AA47: e960feffff               jmp      0x18000a8ac
0x0000AA4C: e903000000               jmp      0x18000aa54
0x0000AA51: cc                       int3     
0x0000AA52: cc                       int3     
0x0000AA53: cc                       int3     
0x0000AA54: 488d05ad2a0000           lea      rax, [rip + 0x2aad]
0x0000AA5B: 488d0df21f0000           lea      rcx, [rip + 0x1ff2]
0x0000AA62: 488905dfc90000           mov      qword ptr [rip + 0xc9df], rax
0x0000AA69: 488d05382b0000           lea      rax, [rip + 0x2b38]
0x0000AA70: 48890dc9c90000           mov      qword ptr [rip + 0xc9c9], rcx
0x0000AA77: 488905d2c90000           mov      qword ptr [rip + 0xc9d2], rax
0x0000AA7E: 488d056b2b0000           lea      rax, [rip + 0x2b6b]
0x0000AA85: 48890ddcc90000           mov      qword ptr [rip + 0xc9dc], rcx
0x0000AA8C: 488905c5c90000           mov      qword ptr [rip + 0xc9c5], rax
0x0000AA93: 488d05de2b0000           lea      rax, [rip + 0x2bde]
0x0000AA9A: 488905bfc90000           mov      qword ptr [rip + 0xc9bf], rax
0x0000AAA1: 488d05d01f0000           lea      rax, [rip + 0x1fd0]
0x0000AAA8: 488905c1c90000           mov      qword ptr [rip + 0xc9c1], rax
0x0000AAAF: 488d05fa2a0000           lea      rax, [rip + 0x2afa]
0x0000AAB6: 488905bbc90000           mov      qword ptr [rip + 0xc9bb], rax
0x0000AABD: 488d054c2a0000           lea      rax, [rip + 0x2a4c]
0x0000AAC4: 488905b5c90000           mov      qword ptr [rip + 0xc9b5], rax
0x0000AACB: 488d05262b0000           lea      rax, [rip + 0x2b26]
0x0000AAD2: 488905afc90000           mov      qword ptr [rip + 0xc9af], rax
0x0000AAD9: c3                       ret      
0x0000AADA: cc                       int3     
0x0000AADB: cc                       int3     
0x0000AADC: 488bc4                   mov      rax, rsp
0x0000AADF: 48895808                 mov      qword ptr [rax + 8], rbx
0x0000AAE3: 48896818                 mov      qword ptr [rax + 0x18], rbp
0x0000AAE7: 48897020                 mov      qword ptr [rax + 0x20], rsi
0x0000AAEB: 895010                   mov      dword ptr [rax + 0x10], edx
0x0000AAEE: 57                       push     rdi
0x0000AAEF: 4154                     push     r12
0x0000AAF1: 4155                     push     r13
0x0000AAF3: 4156                     push     r14
0x0000AAF5: 4157                     push     r15
0x0000AAF7: 4883ec30                 sub      rsp, 0x30
0x0000AAFB: 4533f6                   xor      r14d, r14d
0x0000AAFE: 8bda                     mov      ebx, edx
0x0000AB00: 4c8bf9                   mov      r15, rcx
0x0000AB03: 418bfe                   mov      edi, r14d
0x0000AB06: 4885c9                   test     rcx, rcx
0x0000AB09: 7515                     jne      0x18000ab20
0x0000AB0B: e87c7bffff               call     0x18000268c
0x0000AB10: c70016000000             mov      dword ptr [rax], 0x16
0x0000AB16: e8898dffff               call     0x1800038a4
0x0000AB1B: e9ed000000               jmp      0x18000ac0d
0x0000AB20: 488b29                   mov      rbp, qword ptr [rcx]
0x0000AB23: 4885ed                   test     rbp, rbp
0x0000AB26: 0f84d6000000             je       0x18000ac02
0x0000AB2C: ba3d000000               mov      edx, 0x3d
0x0000AB31: 488bcd                   mov      rcx, rbp
0x0000AB34: e8c32b0000               call     0x18000d6fc
0x0000AB39: 4c8be8                   mov      r13, rax
0x0000AB3C: 4885c0                   test     rax, rax
0x0000AB3F: 0f84bd000000             je       0x18000ac02
0x0000AB45: 483be8                   cmp      rbp, rax
0x0000AB48: 0f84b4000000             je       0x18000ac02
0x0000AB4E: 44387001                 cmp      byte ptr [rax + 1], r14b
0x0000AB52: 488b35c7e10000           mov      rsi, qword ptr [rip + 0xe1c7]
0x0000AB59: 458be6                   mov      r12d, r14d
0x0000AB5C: 410f94c4                 sete     r12b
0x0000AB60: 483b35f1e10000           cmp      rsi, qword ptr [rip + 0xe1f1]
0x0000AB67: 757a                     jne      0x18000abe3
0x0000AB69: 488bde                   mov      rbx, rsi
0x0000AB6C: 418bce                   mov      ecx, r14d
0x0000AB6F: 488bc6                   mov      rax, rsi
0x0000AB72: 4885f6                   test     rsi, rsi
0x0000AB75: 7505                     jne      0x18000ab7c
0x0000AB77: 498bf6                   mov      rsi, r14
0x0000AB7A: eb5c                     jmp      0x18000abd8
0x0000AB7C: 4c3936                   cmp      qword ptr [rsi], r14
0x0000AB7F: 740b                     je       0x18000ab8c
0x0000AB81: 488d4008                 lea      rax, [rax + 8]
0x0000AB85: ffc1                     inc      ecx
0x0000AB87: 4c3930                   cmp      qword ptr [rax], r14
0x0000AB8A: 75f5                     jne      0x18000ab81
0x0000AB8C: 8d4101                   lea      eax, [rcx + 1]
0x0000AB8F: ba08000000               mov      edx, 8
0x0000AB94: 4863c8                   movsxd   rcx, eax
0x0000AB97: e8bc87ffff               call     0x180003358
0x0000AB9C: 4c8bf0                   mov      r14, rax
0x0000AB9F: 488bf0                   mov      rsi, rax
0x0000ABA2: 4885c0                   test     rax, rax
0x0000ABA5: 7508                     jne      0x18000abaf
0x0000ABA7: 8d4809                   lea      ecx, [rax + 9]
0x0000ABAA: e8717fffff               call     0x180002b20
0x0000ABAF: 488b03                   mov      rax, qword ptr [rbx]
0x0000ABB2: 4885c0                   test     rax, rax
0x0000ABB5: 741b                     je       0x18000abd2
0x0000ABB7: 492bde                   sub      rbx, r14
0x0000ABBA: 488bc8                   mov      rcx, rax
0x0000ABBD: e8ca2a0000               call     0x18000d68c
0x0000ABC2: 498906                   mov      qword ptr [r14], rax
0x0000ABC5: 4983c608                 add      r14, 8
0x0000ABC9: 4a8b0433                 mov      rax, qword ptr [rbx + r14]
0x0000ABCD: 4885c0                   test     rax, rax
0x0000ABD0: 75e8                     jne      0x18000abba
0x0000ABD2: 49213e                   and      qword ptr [r14], rdi
0x0000ABD5: 4533f6                   xor      r14d, r14d
0x0000ABD8: 8b5c2468                 mov      ebx, dword ptr [rsp + 0x68]
0x0000ABDC: 4889353de10000           mov      qword ptr [rip + 0xe13d], rsi
0x0000ABE3: 4885f6                   test     rsi, rsi
0x0000ABE6: 0f858c000000             jne      0x18000ac78
0x0000ABEC: 85db                     test     ebx, ebx
0x0000ABEE: 743d                     je       0x18000ac2d
0x0000ABF0: 4c393531e10000           cmp      qword ptr [rip + 0xe131], r14
0x0000ABF7: 7434                     je       0x18000ac2d
0x0000ABF9: e8eef3ffff               call     0x180009fec
0x0000ABFE: 85c0                     test     eax, eax
0x0000AC00: 746f                     je       0x18000ac71
0x0000AC02: e8857affff               call     0x18000268c
0x0000AC07: c70016000000             mov      dword ptr [rax], 0x16
0x0000AC0D: 83c8ff                   or       eax, 0xffffffff
0x0000AC10: 488b5c2460               mov      rbx, qword ptr [rsp + 0x60]
0x0000AC15: 488b6c2470               mov      rbp, qword ptr [rsp + 0x70]
0x0000AC1A: 488b742478               mov      rsi, qword ptr [rsp + 0x78]
0x0000AC1F: 4883c430                 add      rsp, 0x30
0x0000AC23: 415f                     pop      r15
0x0000AC25: 415e                     pop      r14
0x0000AC27: 415d                     pop      r13
0x0000AC29: 415c                     pop      r12
0x0000AC2B: 5f                       pop      rdi
0x0000AC2C: c3                       ret      
0x0000AC2D: 4585e4                   test     r12d, r12d
0x0000AC30: 7404                     je       0x18000ac36
0x0000AC32: 33c0                     xor      eax, eax
0x0000AC34: ebda                     jmp      0x18000ac10
0x0000AC36: b908000000               mov      ecx, 8
0x0000AC3B: e89887ffff               call     0x1800033d8
0x0000AC40: 488905d9e00000           mov      qword ptr [rip + 0xe0d9], rax
0x0000AC47: 4885c0                   test     rax, rax
0x0000AC4A: 74c1                     je       0x18000ac0d
0x0000AC4C: 4c8930                   mov      qword ptr [rax], r14
0x0000AC4F: 4c3935d2e00000           cmp      qword ptr [rip + 0xe0d2], r14
0x0000AC56: 7519                     jne      0x18000ac71
0x0000AC58: b908000000               mov      ecx, 8
0x0000AC5D: e87687ffff               call     0x1800033d8
0x0000AC62: 488905bfe00000           mov      qword ptr [rip + 0xe0bf], rax
0x0000AC69: 4885c0                   test     rax, rax
0x0000AC6C: 749f                     je       0x18000ac0d
0x0000AC6E: 4c8930                   mov      qword ptr [rax], r14
0x0000AC71: 488b35a8e00000           mov      rsi, qword ptr [rip + 0xe0a8]
0x0000AC78: 4c8bf6                   mov      r14, rsi
0x0000AC7B: 4885f6                   test     rsi, rsi
0x0000AC7E: 748d                     je       0x18000ac0d
0x0000AC80: 488b06                   mov      rax, qword ptr [rsi]
0x0000AC83: 418bcd                   mov      ecx, r13d
0x0000AC86: 488bde                   mov      rbx, rsi
0x0000AC89: 2bcd                     sub      ecx, ebp
0x0000AC8B: 4885c0                   test     rax, rax
0x0000AC8E: 743f                     je       0x18000accf
0x0000AC90: 4863f1                   movsxd   rsi, ecx
0x0000AC93: 4c8bc6                   mov      r8, rsi
0x0000AC96: 488bd0                   mov      rdx, rax
0x0000AC99: 488bcd                   mov      rcx, rbp
0x0000AC9C: e83ff4ffff               call     0x18000a0e0
0x0000ACA1: 85c0                     test     eax, eax
0x0000ACA3: 7517                     jne      0x18000acbc
0x0000ACA5: 488b03                   mov      rax, qword ptr [rbx]
0x0000ACA8: 803c063d                 cmp      byte ptr [rsi + rax], 0x3d
0x0000ACAC: 0f84a9000000             je       0x18000ad5b
0x0000ACB2: 40383c06                 cmp      byte ptr [rsi + rax], dil
0x0000ACB6: 0f849f000000             je       0x18000ad5b
0x0000ACBC: 4883c308                 add      rbx, 8
0x0000ACC0: 488b03                   mov      rax, qword ptr [rbx]
0x0000ACC3: 4885c0                   test     rax, rax
0x0000ACC6: 75cb                     jne      0x18000ac93
0x0000ACC8: 488b3551e00000           mov      rsi, qword ptr [rip + 0xe051]
0x0000ACCF: 482bde                   sub      rbx, rsi
0x0000ACD2: 48c1fb03                 sar      rbx, 3
0x0000ACD6: f7db                     neg      ebx
0x0000ACD8: 85db                     test     ebx, ebx
0x0000ACDA: 0f889a000000             js       0x18000ad7a
0x0000ACE0: 49393e                   cmp      qword ptr [r14], rdi
0x0000ACE3: 0f8491000000             je       0x18000ad7a
0x0000ACE9: 4863f3                   movsxd   rsi, ebx
0x0000ACEC: 498b0cf6                 mov      rcx, qword ptr [r14 + rsi*8]
0x0000ACF0: e83b6bffff               call     0x180001830
0x0000ACF5: 4585e4                   test     r12d, r12d
0x0000ACF8: 7474                     je       0x18000ad6e
0x0000ACFA: 49393cf6                 cmp      qword ptr [r14 + rsi*8], rdi
0x0000ACFE: 741e                     je       0x18000ad1e
0x0000AD00: 488d4e01                 lea      rcx, [rsi + 1]
0x0000AD04: 498d0cce                 lea      rcx, [r14 + rcx*8]
0x0000AD08: 488b01                   mov      rax, qword ptr [rcx]
0x0000AD0B: ffc3                     inc      ebx
0x0000AD0D: 488d4908                 lea      rcx, [rcx + 8]
0x0000AD11: 498904f6                 mov      qword ptr [r14 + rsi*8], rax
0x0000AD15: 48ffc6                   inc      rsi
0x0000AD18: 49393cf6                 cmp      qword ptr [r14 + rsi*8], rdi
0x0000AD1C: 75ea                     jne      0x18000ad08
0x0000AD1E: 4863d3                   movsxd   rdx, ebx
0x0000AD21: 48b8ffffffffffffff1f     movabs   rax, 0x1fffffffffffffff
0x0000AD2B: 483bd0                   cmp      rdx, rax
0x0000AD2E: 0f83a3000000             jae      0x18000add7
0x0000AD34: 488b0de5df0000           mov      rcx, qword ptr [rip + 0xdfe5]
0x0000AD3B: 41b808000000             mov      r8d, 8
0x0000AD41: e89287ffff               call     0x1800034d8
0x0000AD46: 4533f6                   xor      r14d, r14d
0x0000AD49: 4885c0                   test     rax, rax
0x0000AD4C: 0f8488000000             je       0x18000adda
0x0000AD52: 488905c7df0000           mov      qword ptr [rip + 0xdfc7], rax
0x0000AD59: eb7f                     jmp      0x18000adda
0x0000AD5B: 488b35bedf0000           mov      rsi, qword ptr [rip + 0xdfbe]
0x0000AD62: 482bde                   sub      rbx, rsi
0x0000AD65: 48c1fb03                 sar      rbx, 3
0x0000AD69: e96affffff               jmp      0x18000acd8
0x0000AD6E: 49892cf6                 mov      qword ptr [r14 + rsi*8], rbp
0x0000AD72: 4533f6                   xor      r14d, r14d
0x0000AD75: 4d8937                   mov      qword ptr [r15], r14
0x0000AD78: eb60                     jmp      0x18000adda
0x0000AD7A: 4533f6                   xor      r14d, r14d
0x0000AD7D: 4585e4                   test     r12d, r12d
0x0000AD80: 0f85e4000000             jne      0x18000ae6a
0x0000AD86: 85db                     test     ebx, ebx
0x0000AD88: 7902                     jns      0x18000ad8c
0x0000AD8A: f7db                     neg      ebx
0x0000AD8C: 8d4302                   lea      eax, [rbx + 2]
0x0000AD8F: 3bc3                     cmp      eax, ebx
0x0000AD91: 0f8c76feffff             jl       0x18000ac0d
0x0000AD97: 4c63c0                   movsxd   r8, eax
0x0000AD9A: 48b8ffffffffffffff1f     movabs   rax, 0x1fffffffffffffff
0x0000ADA4: 4c3bc0                   cmp      r8, rax
0x0000ADA7: 0f8360feffff             jae      0x18000ac0d
0x0000ADAD: ba08000000               mov      edx, 8
0x0000ADB2: 488bce                   mov      rcx, rsi
0x0000ADB5: e81e87ffff               call     0x1800034d8
0x0000ADBA: 4885c0                   test     rax, rax
0x0000ADBD: 0f844afeffff             je       0x18000ac0d
0x0000ADC3: 4863cb                   movsxd   rcx, ebx
0x0000ADC6: 48892cc8                 mov      qword ptr [rax + rcx*8], rbp
0x0000ADCA: 4c8974c808               mov      qword ptr [rax + rcx*8 + 8], r14
0x0000ADCF: 4d8937                   mov      qword ptr [r15], r14
0x0000ADD2: e97bffffff               jmp      0x18000ad52
0x0000ADD7: 4533f6                   xor      r14d, r14d
0x0000ADDA: 4439742468               cmp      dword ptr [rsp + 0x68], r14d
0x0000ADDF: 7472                     je       0x18000ae53
0x0000ADE1: 488bcd                   mov      rcx, rbp
0x0000ADE4: e817bcffff               call     0x180006a00
0x0000ADE9: ba01000000               mov      edx, 1
0x0000ADEE: 488d4802                 lea      rcx, [rax + 2]
0x0000ADF2: e86185ffff               call     0x180003358
0x0000ADF7: 488bd8                   mov      rbx, rax
0x0000ADFA: 4885c0                   test     rax, rax
0x0000ADFD: 7454                     je       0x18000ae53
0x0000ADFF: 488bcd                   mov      rcx, rbp
0x0000AE02: e8f9bbffff               call     0x180006a00
0x0000AE07: 4c8bc5                   mov      r8, rbp
0x0000AE0A: 488bcb                   mov      rcx, rbx
0x0000AE0D: 488d5002                 lea      rdx, [rax + 2]
0x0000AE11: e87e70ffff               call     0x180001e94
0x0000AE16: 85c0                     test     eax, eax
0x0000AE18: 7560                     jne      0x18000ae7a
0x0000AE1A: 488bd3                   mov      rdx, rbx
0x0000AE1D: 488bcb                   mov      rcx, rbx
0x0000AE20: 482bd5                   sub      rdx, rbp
0x0000AE23: 4903d5                   add      rdx, r13
0x0000AE26: 448832                   mov      byte ptr [rdx], r14b
0x0000AE29: 48ffc2                   inc      rdx
0x0000AE2C: 4585e4                   test     r12d, r12d
0x0000AE2F: 490f45d6                 cmovne   rdx, r14
0x0000AE33: e86ff01c00               call     0x1801d9ea7
0x0000AE38: d185c0750e83             rol      dword ptr [rbp - 0x7cf18a40], 1
0x0000AE3E: cf                       iretd    
0x0000AE3F: ff                       .byte    0xff
0x0000AE40: e84778ffff               call     0x18000268c
0x0000AE45: c7002a000000             mov      dword ptr [rax], 0x2a
0x0000AE4B: 488bcb                   mov      rcx, rbx
0x0000AE4E: e8dd69ffff               call     0x180001830
0x0000AE53: 4585e4                   test     r12d, r12d
0x0000AE56: 740b                     je       0x18000ae63
0x0000AE58: 488bcd                   mov      rcx, rbp
0x0000AE5B: e8d069ffff               call     0x180001830
0x0000AE60: 4d8937                   mov      qword ptr [r15], r14
0x0000AE63: 8bc7                     mov      eax, edi
0x0000AE65: e9a6fdffff               jmp      0x18000ac10
0x0000AE6A: 488bcd                   mov      rcx, rbp
0x0000AE6D: e8be69ffff               call     0x180001830
0x0000AE72: 4d8937                   mov      qword ptr [r15], r14
0x0000AE75: e9b8fdffff               jmp      0x18000ac32
0x0000AE7A: 4533c9                   xor      r9d, r9d
0x0000AE7D: 4533c0                   xor      r8d, r8d
0x0000AE80: 33d2                     xor      edx, edx
0x0000AE82: 33c9                     xor      ecx, ecx
0x0000AE84: 4c89742420               mov      qword ptr [rsp + 0x20], r14
0x0000AE89: e8368affff               call     0x1800038c4
0x0000AE8E: cc                       int3     
0x0000AE8F: cc                       int3     
0x0000AE90: 488bc4                   mov      rax, rsp
0x0000AE93: 48895808                 mov      qword ptr [rax + 8], rbx
0x0000AE97: 48896810                 mov      qword ptr [rax + 0x10], rbp
0x0000AE9B: 48897018                 mov      qword ptr [rax + 0x18], rsi
0x0000AE9F: 57                       push     rdi
0x0000AEA0: 4883ec60                 sub      rsp, 0x60
0x0000AEA4: 488be9                   mov      rbp, rcx
0x0000AEA7: 488bf2                   mov      rsi, rdx
0x0000AEAA: 488d48d8                 lea      rcx, [rax - 0x28]
0x0000AEAE: 498bd1                   mov      rdx, r9
0x0000AEB1: 498bf8                   mov      rdi, r8
0x0000AEB4: e8dfb1ffff               call     0x180006098
0x0000AEB9: 4885ff                   test     rdi, rdi
0x0000AEBC: 7507                     jne      0x18000aec5
0x0000AEBE: 33db                     xor      ebx, ebx
0x0000AEC0: e9a0000000               jmp      0x18000af65
0x0000AEC5: 4885ed                   test     rbp, rbp
0x0000AEC8: 7405                     je       0x18000aecf
0x0000AECA: 4885f6                   test     rsi, rsi
0x0000AECD: 7517                     jne      0x18000aee6
0x0000AECF: e8b877ffff               call     0x18000268c
0x0000AED4: c70016000000             mov      dword ptr [rax], 0x16
0x0000AEDA: e8c589ffff               call     0x1800038a4
0x0000AEDF: bbffffff7f               mov      ebx, 0x7fffffff
0x0000AEE4: eb7f                     jmp      0x18000af65
0x0000AEE6: bbffffff7f               mov      ebx, 0x7fffffff
0x0000AEEB: 483bfb                   cmp      rdi, rbx
0x0000AEEE: 7612                     jbe      0x18000af02
0x0000AEF0: e89777ffff               call     0x18000268c
0x0000AEF5: c70016000000             mov      dword ptr [rax], 0x16
0x0000AEFB: e8a489ffff               call     0x1800038a4
0x0000AF00: eb63                     jmp      0x18000af65
0x0000AF02: 488b442440               mov      rax, qword ptr [rsp + 0x40]
0x0000AF07: 488b9030010000           mov      rdx, qword ptr [rax + 0x130]
0x0000AF0E: 4885d2                   test     rdx, rdx
0x0000AF11: 7517                     jne      0x18000af2a
0x0000AF13: 4c8d4c2440               lea      r9, [rsp + 0x40]
0x0000AF18: 4c8bc7                   mov      r8, rdi
0x0000AF1B: 488bd6                   mov      rdx, rsi
0x0000AF1E: 488bcd                   mov      rcx, rbp
0x0000AF21: e8e6280000               call     0x18000d80c
0x0000AF26: 8bd8                     mov      ebx, eax
0x0000AF28: eb3b                     jmp      0x18000af65
0x0000AF2A: 8b4008                   mov      eax, dword ptr [rax + 8]
0x0000AF2D: 488d4c2440               lea      rcx, [rsp + 0x40]
0x0000AF32: 4c8bcd                   mov      r9, rbp
0x0000AF35: 89442438                 mov      dword ptr [rsp + 0x38], eax
0x0000AF39: 897c2430                 mov      dword ptr [rsp + 0x30], edi
0x0000AF3D: 41b801100000             mov      r8d, 0x1001
0x0000AF43: 4889742428               mov      qword ptr [rsp + 0x28], rsi
0x0000AF48: 897c2420                 mov      dword ptr [rsp + 0x20], edi
0x0000AF4C: e8a7030000               call     0x18000b2f8
0x0000AF51: 85c0                     test     eax, eax
0x0000AF53: 750d                     jne      0x18000af62
0x0000AF55: e83277ffff               call     0x18000268c
0x0000AF5A: c70016000000             mov      dword ptr [rax], 0x16
0x0000AF60: eb03                     jmp      0x18000af65
0x0000AF62: 8d58fe                   lea      ebx, [rax - 2]
0x0000AF65: 807c245800               cmp      byte ptr [rsp + 0x58], 0
0x0000AF6A: 740c                     je       0x18000af78
0x0000AF6C: 488b442450               mov      rax, qword ptr [rsp + 0x50]
0x0000AF71: 83a0c8000000fd           and      dword ptr [rax + 0xc8], 0xfffffffd
0x0000AF78: 4c8d5c2460               lea      r11, [rsp + 0x60]
0x0000AF7D: 8bc3                     mov      eax, ebx
0x0000AF7F: 498b5b10                 mov      rbx, qword ptr [r11 + 0x10]
0x0000AF83: 498b6b18                 mov      rbp, qword ptr [r11 + 0x18]
0x0000AF87: 498b7320                 mov      rsi, qword ptr [r11 + 0x20]
0x0000AF8B: 498be3                   mov      rsp, r11
0x0000AF8E: 5f                       pop      rdi
0x0000AF8F: c3                       ret      
0x0000AF90: 4055                     push     rbp
0x0000AF92: 53                       push     rbx
0x0000AF93: 56                       push     rsi
0x0000AF94: 57                       push     rdi
0x0000AF95: 4154                     push     r12
0x0000AF97: 4155                     push     r13
0x0000AF99: 4156                     push     r14
0x0000AF9B: 4157                     push     r15
0x0000AF9D: 4883ec78                 sub      rsp, 0x78
0x0000AFA1: 488d6c2430               lea      rbp, [rsp + 0x30]
0x0000AFA6: 488b0553c00000           mov      rax, qword ptr [rip + 0xc053]
0x0000AFAD: 4833c5                   xor      rax, rbp
0x0000AFB0: 48894530                 mov      qword ptr [rbp + 0x30], rax
0x0000AFB4: 8bbdb0000000             mov      edi, dword ptr [rbp + 0xb0]
0x0000AFBA: 4c8bb5b8000000           mov      r14, qword ptr [rbp + 0xb8]
0x0000AFC1: 33db                     xor      ebx, ebx
0x0000AFC3: 44894500                 mov      dword ptr [rbp], r8d
0x0000AFC7: 4d8bf9                   mov      r15, r9
0x0000AFCA: 48895510                 mov      qword ptr [rbp + 0x10], rdx
0x0000AFCE: 4c8bc1                   mov      r8, rcx
0x0000AFD1: 4c897508                 mov      qword ptr [rbp + 8], r14
0x0000AFD5: 41bd01000000             mov      r13d, 1
0x0000AFDB: 85ff                     test     edi, edi
0x0000AFDD: 7e43                     jle      0x18000b022
0x0000AFDF: 8bd7                     mov      edx, edi
0x0000AFE1: 498bc1                   mov      rax, r9
0x0000AFE4: 412bd5                   sub      edx, r13d
0x0000AFE7: 83c9ff                   or       ecx, 0xffffffff
0x0000AFEA: 3818                     cmp      byte ptr [rax], bl
0x0000AFEC: 7409                     je       0x18000aff7
0x0000AFEE: 4903c5                   add      rax, r13
0x0000AFF1: 85d2                     test     edx, edx
0x0000AFF3: 75ef                     jne      0x18000afe4
0x0000AFF5: 8bd1                     mov      edx, ecx
0x0000AFF7: 8bc1                     mov      eax, ecx
0x0000AFF9: 2bc2                     sub      eax, edx
0x0000AFFB: 03f8                     add      edi, eax
0x0000AFFD: 8bb5c0000000             mov      esi, dword ptr [rbp + 0xc0]
0x0000B003: 85f6                     test     esi, esi
0x0000B005: 7e29                     jle      0x18000b030
0x0000B007: 8bc6                     mov      eax, esi
0x0000B009: 498bd6                   mov      rdx, r14
0x0000B00C: 412bc5                   sub      eax, r13d
0x0000B00F: 381a                     cmp      byte ptr [rdx], bl
0x0000B011: 7409                     je       0x18000b01c
0x0000B013: 4903d5                   add      rdx, r13
0x0000B016: 85c0                     test     eax, eax
0x0000B018: 75f2                     jne      0x18000b00c
0x0000B01A: 8bc1                     mov      eax, ecx
0x0000B01C: 2bc8                     sub      ecx, eax
0x0000B01E: 03f1                     add      esi, ecx
0x0000B020: eb12                     jmp      0x18000b034
0x0000B022: 83c9ff                   or       ecx, 0xffffffff
0x0000B025: 3bf9                     cmp      edi, ecx
0x0000B027: 7dd4                     jge      0x18000affd
0x0000B029: 33c0                     xor      eax, eax
0x0000B02B: e9a8020000               jmp      0x18000b2d8
0x0000B030: 3bf1                     cmp      esi, ecx
0x0000B032: 7cf5                     jl       0x18000b029
0x0000B034: 448ba5c8000000           mov      r12d, dword ptr [rbp + 0xc8]
0x0000B03B: 4585e4                   test     r12d, r12d
0x0000B03E: 7507                     jne      0x18000b047
0x0000B040: 498b00                   mov      rax, qword ptr [r8]
0x0000B043: 448b6004                 mov      r12d, dword ptr [rax + 4]
0x0000B047: 85ff                     test     edi, edi
0x0000B049: 7408                     je       0x18000b053
0x0000B04B: 85f6                     test     esi, esi
0x0000B04D: 0f8597000000             jne      0x18000b0ea
0x0000B053: 3bfe                     cmp      edi, esi
0x0000B055: 750a                     jne      0x18000b061
0x0000B057: b802000000               mov      eax, 2
0x0000B05C: e977020000               jmp      0x18000b2d8
0x0000B061: 413bf5                   cmp      esi, r13d
0x0000B064: 7e08                     jle      0x18000b06e
0x0000B066: 418bc5                   mov      eax, r13d
0x0000B069: e96a020000               jmp      0x18000b2d8
0x0000B06E: 413bfd                   cmp      edi, r13d
0x0000B071: 7e0a                     jle      0x18000b07d
0x0000B073: b803000000               mov      eax, 3
0x0000B078: e95b020000               jmp      0x18000b2d8
0x0000B07D: 488d5518                 lea      rdx, [rbp + 0x18]
0x0000B081: 418bcc                   mov      ecx, r12d
0x0000B084: e8ffb40200               call     0x180036588
0x0000B089: 1a85c0749b85             sbb      al, byte ptr [rbp - 0x7a648b40]
0x0000B08F: ff                       .byte    0xff
0x0000B090: 7e28                     jle      0x18000b0ba
0x0000B092: 837d1802                 cmp      dword ptr [rbp + 0x18], 2
0x0000B096: 72db                     jb       0x18000b073
0x0000B098: 385d1e                   cmp      byte ptr [rbp + 0x1e], bl
0x0000B09B: 488d451e                 lea      rax, [rbp + 0x1e]
0x0000B09F: 74d2                     je       0x18000b073
0x0000B0A1: 385801                   cmp      byte ptr [rax + 1], bl
0x0000B0A4: 74cd                     je       0x18000b073
0x0000B0A6: 418a0f                   mov      cl, byte ptr [r15]
0x0000B0A9: 3a08                     cmp      cl, byte ptr [rax]
0x0000B0AB: 7205                     jb       0x18000b0b2
0x0000B0AD: 3a4801                   cmp      cl, byte ptr [rax + 1]
0x0000B0B0: 76a5                     jbe      0x18000b057
0x0000B0B2: 4883c002                 add      rax, 2
0x0000B0B6: 3818                     cmp      byte ptr [rax], bl
0x0000B0B8: ebe5                     jmp      0x18000b09f
0x0000B0BA: 85f6                     test     esi, esi
0x0000B0BC: 7e2c                     jle      0x18000b0ea
0x0000B0BE: 837d1802                 cmp      dword ptr [rbp + 0x18], 2
0x0000B0C2: 72a2                     jb       0x18000b066
0x0000B0C4: 385d1e                   cmp      byte ptr [rbp + 0x1e], bl
0x0000B0C7: 488d451e                 lea      rax, [rbp + 0x1e]
0x0000B0CB: 7499                     je       0x18000b066
0x0000B0CD: 385801                   cmp      byte ptr [rax + 1], bl
0x0000B0D0: 7494                     je       0x18000b066
0x0000B0D2: 418a0e                   mov      cl, byte ptr [r14]
0x0000B0D5: 3a08                     cmp      cl, byte ptr [rax]
0x0000B0D7: 7209                     jb       0x18000b0e2
0x0000B0D9: 3a4801                   cmp      cl, byte ptr [rax + 1]
0x0000B0DC: 0f8675ffffff             jbe      0x18000b057
0x0000B0E2: 4883c002                 add      rax, 2
0x0000B0E6: 3818                     cmp      byte ptr [rax], bl
0x0000B0E8: ebe1                     jmp      0x18000b0cb
0x0000B0EA: 448bcf                   mov      r9d, edi
0x0000B0ED: 4d8bc7                   mov      r8, r15
0x0000B0F0: ba09000000               mov      edx, 9
0x0000B0F5: 418bcc                   mov      ecx, r12d
0x0000B0F8: 895c2428                 mov      dword ptr [rsp + 0x28], ebx
0x0000B0FC: 48895c2420               mov      qword ptr [rsp + 0x20], rbx
0x0000B101: 56                       push     rsi
0x0000B102: e831451d00               call     0x1801df638
0x0000B107: 4c63e8                   movsxd   r13, eax
0x0000B10A: 85c0                     test     eax, eax
0x0000B10C: 0f8417ffffff             je       0x18000b029
0x0000B112: 49b9f0ffffffffffff0f     movabs   r9, 0xffffffffffffff0
0x0000B11C: 7e79                     jle      0x18000b197
0x0000B11E: 33d2                     xor      edx, edx
0x0000B120: 488d42e0                 lea      rax, [rdx - 0x20]
0x0000B124: 49f7f5                   div      r13
0x0000B127: 4883f802                 cmp      rax, 2
0x0000B12B: 726a                     jb       0x18000b197
0x0000B12D: 4a8d0c6d00000000         lea      rcx, [r13*2]
0x0000B135: 488d4110                 lea      rax, [rcx + 0x10]
0x0000B139: 483bc1                   cmp      rax, rcx
0x0000B13C: 7659                     jbe      0x18000b197
0x0000B13E: 4a8d0c6d10000000         lea      rcx, [r13*2 + 0x10]
0x0000B146: 4881f900040000           cmp      rcx, 0x400
0x0000B14D: 772f                     ja       0x18000b17e
0x0000B14F: 488d410f                 lea      rax, [rcx + 0xf]
0x0000B153: 483bc1                   cmp      rax, rcx
0x0000B156: 7703                     ja       0x18000b15b
0x0000B158: 498bc1                   mov      rax, r9
0x0000B15B: 4883e0f0                 and      rax, 0xfffffffffffffff0
0x0000B15F: e81ce2ffff               call     0x180009380
0x0000B164: 482be0                   sub      rsp, rax
0x0000B167: 4c8d742430               lea      r14, [rsp + 0x30]
0x0000B16C: 4d85f6                   test     r14, r14
0x0000B16F: 0f84b4feffff             je       0x18000b029
0x0000B175: 41c706cccc0000           mov      dword ptr [r14], 0xcccc
0x0000B17C: eb13                     jmp      0x18000b191
0x0000B17E: e8ed66ffff               call     0x180001870
0x0000B183: 4c8bf0                   mov      r14, rax
0x0000B186: 4885c0                   test     rax, rax
0x0000B189: 740f                     je       0x18000b19a
0x0000B18B: c700dddd0000             mov      dword ptr [rax], 0xdddd
0x0000B191: 4983c610                 add      r14, 0x10
0x0000B195: eb03                     jmp      0x18000b19a
0x0000B197: 4c8bf3                   mov      r14, rbx
0x0000B19A: 4d85f6                   test     r14, r14
0x0000B19D: 0f8486feffff             je       0x18000b029
0x0000B1A3: 448bcf                   mov      r9d, edi
0x0000B1A6: 4d8bc7                   mov      r8, r15
0x0000B1A9: ba01000000               mov      edx, 1
0x0000B1AE: 418bcc                   mov      ecx, r12d
0x0000B1B1: 44896c2428               mov      dword ptr [rsp + 0x28], r13d
0x0000B1B6: 4c89742420               mov      qword ptr [rsp + 0x20], r14
0x0000B1BB: e8d3620d00               call     0x1800e1493
0x0000B1C0: 4285c0                   test     eax, eax
0x0000B1C3: 0f84fc000000             je       0x18000b2c5
0x0000B1C9: 4c8b4508                 mov      r8, qword ptr [rbp + 8]
0x0000B1CD: 448bce                   mov      r9d, esi
0x0000B1D0: ba09000000               mov      edx, 9
0x0000B1D5: 418bcc                   mov      ecx, r12d
0x0000B1D8: 895c2428                 mov      dword ptr [rsp + 0x28], ebx
0x0000B1DC: 48895c2420               mov      qword ptr [rsp + 0x20], rbx
0x0000B1E1: 57                       push     rdi
0x0000B1E2: e8632b1200               call     0x18012dd4a
0x0000B1E7: 4c63f8                   movsxd   r15, eax
0x0000B1EA: 85c0                     test     eax, eax
0x0000B1EC: 0f84d3000000             je       0x18000b2c5
0x0000B1F2: 7e77                     jle      0x18000b26b
0x0000B1F4: 33d2                     xor      edx, edx
0x0000B1F6: 488d42e0                 lea      rax, [rdx - 0x20]
0x0000B1FA: 49f7f7                   div      r15
0x0000B1FD: 4883f802                 cmp      rax, 2
0x0000B201: 7268                     jb       0x18000b26b
0x0000B203: 4b8d0c3f                 lea      rcx, [r15 + r15]
0x0000B207: 488d4110                 lea      rax, [rcx + 0x10]
0x0000B20B: 483bc1                   cmp      rax, rcx
0x0000B20E: 765b                     jbe      0x18000b26b
0x0000B210: 4a8d0c7d10000000         lea      rcx, [r15*2 + 0x10]
0x0000B218: 4881f900040000           cmp      rcx, 0x400
0x0000B21F: 7731                     ja       0x18000b252
0x0000B221: 488d410f                 lea      rax, [rcx + 0xf]
0x0000B225: 483bc1                   cmp      rax, rcx
0x0000B228: 770a                     ja       0x18000b234
0x0000B22A: 48b8f0ffffffffffff0f     movabs   rax, 0xffffffffffffff0
0x0000B234: 4883e0f0                 and      rax, 0xfffffffffffffff0
0x0000B238: e843e1ffff               call     0x180009380
0x0000B23D: 482be0                   sub      rsp, rax
0x0000B240: 488d7c2430               lea      rdi, [rsp + 0x30]
0x0000B245: 4885ff                   test     rdi, rdi
0x0000B248: 747b                     je       0x18000b2c5
0x0000B24A: c707cccc0000             mov      dword ptr [rdi], 0xcccc
0x0000B250: eb13                     jmp      0x18000b265
0x0000B252: e81966ffff               call     0x180001870
0x0000B257: 488bf8                   mov      rdi, rax
0x0000B25A: 4885c0                   test     rax, rax
0x0000B25D: 740f                     je       0x18000b26e
0x0000B25F: c700dddd0000             mov      dword ptr [rax], 0xdddd
0x0000B265: 4883c710                 add      rdi, 0x10
0x0000B269: eb03                     jmp      0x18000b26e
0x0000B26B: 488bfb                   mov      rdi, rbx
0x0000B26E: 4885ff                   test     rdi, rdi
0x0000B271: 7452                     je       0x18000b2c5
0x0000B273: 4c8b4508                 mov      r8, qword ptr [rbp + 8]
0x0000B277: 448bce                   mov      r9d, esi
0x0000B27A: ba01000000               mov      edx, 1
0x0000B27F: 418bcc                   mov      ecx, r12d
0x0000B282: 44897c2428               mov      dword ptr [rsp + 0x28], r15d
0x0000B287: 48897c2420               mov      qword ptr [rsp + 0x20], rdi
0x0000B28C: e865940a00               call     0x1800b46f6
0x0000B291: 3385c0741e8b             xor      eax, dword ptr [rbp - 0x74e18b40]
0x0000B297: 55                       push     rbp
0x0000B298: 00488b                   add      byte ptr [rax - 0x75], cl
0x0000B29B: 4d10458b                 adc      byte ptr [r13 - 0x75], r8b
0x0000B29F: cd4d                     int      0x4d
0x0000B2A1: 8bc6                     mov      eax, esi
0x0000B2A3: 44897c2428               mov      dword ptr [rsp + 0x28], r15d
0x0000B2A8: 48897c2420               mov      qword ptr [rsp + 0x20], rdi
0x0000B2AD: e852d0ffff               call     0x180008304
0x0000B2B2: 8bd8                     mov      ebx, eax
0x0000B2B4: 488d4ff0                 lea      rcx, [rdi - 0x10]
0x0000B2B8: 8139dddd0000             cmp      dword ptr [rcx], 0xdddd
0x0000B2BE: 7505                     jne      0x18000b2c5
0x0000B2C0: e86b65ffff               call     0x180001830
0x0000B2C5: 498d4ef0                 lea      rcx, [r14 - 0x10]
0x0000B2C9: 8139dddd0000             cmp      dword ptr [rcx], 0xdddd
0x0000B2CF: 7505                     jne      0x18000b2d6
0x0000B2D1: e85a65ffff               call     0x180001830
0x0000B2D6: 8bc3                     mov      eax, ebx
0x0000B2D8: 488b4d30                 mov      rcx, qword ptr [rbp + 0x30]
0x0000B2DC: 4833cd                   xor      rcx, rbp
0x0000B2DF: e82c65ffff               call     0x180001810
0x0000B2E4: 488d6548                 lea      rsp, [rbp + 0x48]
0x0000B2E8: 415f                     pop      r15
0x0000B2EA: 415e                     pop      r14
0x0000B2EC: 415d                     pop      r13
0x0000B2EE: 415c                     pop      r12
0x0000B2F0: 5f                       pop      rdi
0x0000B2F1: 5e                       pop      rsi
0x0000B2F2: 5b                       pop      rbx
0x0000B2F3: 5d                       pop      rbp
0x0000B2F4: c3                       ret      
0x0000B2F5: cc                       int3     
0x0000B2F6: cc                       int3     
0x0000B2F7: cc                       int3     
0x0000B2F8: 48895c2408               mov      qword ptr [rsp + 8], rbx
0x0000B2FD: 4889742410               mov      qword ptr [rsp + 0x10], rsi
0x0000B302: 57                       push     rdi
0x0000B303: 4883ec60                 sub      rsp, 0x60
0x0000B307: 488bf2                   mov      rsi, rdx
0x0000B30A: 488bd1                   mov      rdx, rcx
0x0000B30D: 488d4c2440               lea      rcx, [rsp + 0x40]
0x0000B312: 498bd9                   mov      rbx, r9
0x0000B315: 418bf8                   mov      edi, r8d
0x0000B318: e87badffff               call     0x180006098
0x0000B31D: 8b8424a8000000           mov      eax, dword ptr [rsp + 0xa8]
0x0000B324: 488d4c2440               lea      rcx, [rsp + 0x40]
0x0000B329: 4c8bcb                   mov      r9, rbx
0x0000B32C: 89442438                 mov      dword ptr [rsp + 0x38], eax
0x0000B330: 8b8424a0000000           mov      eax, dword ptr [rsp + 0xa0]
0x0000B337: 448bc7                   mov      r8d, edi
0x0000B33A: 89442430                 mov      dword ptr [rsp + 0x30], eax
0x0000B33E: 488b842498000000         mov      rax, qword ptr [rsp + 0x98]
0x0000B346: 488bd6                   mov      rdx, rsi
0x0000B349: 4889442428               mov      qword ptr [rsp + 0x28], rax
0x0000B34E: 8b842490000000           mov      eax, dword ptr [rsp + 0x90]
0x0000B355: 89442420                 mov      dword ptr [rsp + 0x20], eax
0x0000B359: e832fcffff               call     0x18000af90
0x0000B35E: 807c245800               cmp      byte ptr [rsp + 0x58], 0
0x0000B363: 740c                     je       0x18000b371
0x0000B365: 488b4c2450               mov      rcx, qword ptr [rsp + 0x50]
0x0000B36A: 83a1c8000000fd           and      dword ptr [rcx + 0xc8], 0xfffffffd
0x0000B371: 488b5c2470               mov      rbx, qword ptr [rsp + 0x70]
0x0000B376: 488b742478               mov      rsi, qword ptr [rsp + 0x78]
0x0000B37B: 4883c460                 add      rsp, 0x60
0x0000B37F: 5f                       pop      rdi
0x0000B380: c3                       ret      
0x0000B381: cc                       int3     
0x0000B382: cc                       int3     
0x0000B383: cc                       int3     
0x0000B384: cc                       int3     
0x0000B385: cc                       int3     
0x0000B386: cc                       int3     
0x0000B387: cc                       int3     
0x0000B388: cc                       int3     
0x0000B389: cc                       int3     
0x0000B38A: cc                       int3     
0x0000B38B: cc                       int3     
0x0000B38C: cc                       int3     
0x0000B38D: cc                       int3     
0x0000B38E: cc                       int3     
0x0000B38F: cc                       int3     
0x0000B390: cc                       int3     
0x0000B391: cc                       int3     
0x0000B392: cc                       int3     
0x0000B393: cc                       int3     
0x0000B394: cc                       int3     
0x0000B395: cc                       int3     
0x0000B396: 66660f1f840000000000     nop      word ptr [rax + rax]
0x0000B3A0: 482bd1                   sub      rdx, rcx
0x0000B3A3: 4983f808                 cmp      r8, 8
0x0000B3A7: 7222                     jb       0x18000b3cb
0x0000B3A9: f6c107                   test     cl, 7
0x0000B3AC: 7414                     je       0x18000b3c2
0x0000B3AE: 6690                     nop      
0x0000B3B0: 8a01                     mov      al, byte ptr [rcx]
0x0000B3B2: 3a040a                   cmp      al, byte ptr [rdx + rcx]
0x0000B3B5: 752c                     jne      0x18000b3e3
0x0000B3B7: 48ffc1                   inc      rcx
0x0000B3BA: 49ffc8                   dec      r8
0x0000B3BD: f6c107                   test     cl, 7
0x0000B3C0: 75ee                     jne      0x18000b3b0
0x0000B3C2: 4d8bc8                   mov      r9, r8
0x0000B3C5: 49c1e903                 shr      r9, 3
0x0000B3C9: 751f                     jne      0x18000b3ea
0x0000B3CB: 4d85c0                   test     r8, r8
0x0000B3CE: 740f                     je       0x18000b3df
0x0000B3D0: 8a01                     mov      al, byte ptr [rcx]
0x0000B3D2: 3a040a                   cmp      al, byte ptr [rdx + rcx]
0x0000B3D5: 750c                     jne      0x18000b3e3
0x0000B3D7: 48ffc1                   inc      rcx
0x0000B3DA: 49ffc8                   dec      r8
0x0000B3DD: 75f1                     jne      0x18000b3d0
0x0000B3DF: 4833c0                   xor      rax, rax
0x0000B3E2: c3                       ret      
0x0000B3E3: 1bc0                     sbb      eax, eax
0x0000B3E5: 83d8ff                   sbb      eax, -1
0x0000B3E8: c3                       ret      
0x0000B3E9: 90                       nop      
0x0000B3EA: 49c1e902                 shr      r9, 2
0x0000B3EE: 7437                     je       0x18000b427
0x0000B3F0: 488b01                   mov      rax, qword ptr [rcx]
0x0000B3F3: 483b040a                 cmp      rax, qword ptr [rdx + rcx]
0x0000B3F7: 755b                     jne      0x18000b454
0x0000B3F9: 488b4108                 mov      rax, qword ptr [rcx + 8]
0x0000B3FD: 483b440a08               cmp      rax, qword ptr [rdx + rcx + 8]
0x0000B402: 754c                     jne      0x18000b450
0x0000B404: 488b4110                 mov      rax, qword ptr [rcx + 0x10]
0x0000B408: 483b440a10               cmp      rax, qword ptr [rdx + rcx + 0x10]
0x0000B40D: 753d                     jne      0x18000b44c
0x0000B40F: 488b4118                 mov      rax, qword ptr [rcx + 0x18]
0x0000B413: 483b440a18               cmp      rax, qword ptr [rdx + rcx + 0x18]
0x0000B418: 752e                     jne      0x18000b448
0x0000B41A: 4883c120                 add      rcx, 0x20
0x0000B41E: 49ffc9                   dec      r9
0x0000B421: 75cd                     jne      0x18000b3f0
0x0000B423: 4983e01f                 and      r8, 0x1f
0x0000B427: 4d8bc8                   mov      r9, r8
0x0000B42A: 49c1e903                 shr      r9, 3
0x0000B42E: 749b                     je       0x18000b3cb
0x0000B430: 488b01                   mov      rax, qword ptr [rcx]
0x0000B433: 483b040a                 cmp      rax, qword ptr [rdx + rcx]
0x0000B437: 751b                     jne      0x18000b454
0x0000B439: 4883c108                 add      rcx, 8
0x0000B43D: 49ffc9                   dec      r9
0x0000B440: 75ee                     jne      0x18000b430
0x0000B442: 4983e007                 and      r8, 7
0x0000B446: eb83                     jmp      0x18000b3cb
0x0000B448: 4883c108                 add      rcx, 8
0x0000B44C: 4883c108                 add      rcx, 8
0x0000B450: 4883c108                 add      rcx, 8
0x0000B454: 488b0c11                 mov      rcx, qword ptr [rcx + rdx]
0x0000B458: 480fc8                   bswap    rax
0x0000B45B: 480fc9                   bswap    rcx
0x0000B45E: 483bc1                   cmp      rax, rcx
0x0000B461: 1bc0                     sbb      eax, eax
0x0000B463: 83d8ff                   sbb      eax, -1
0x0000B466: c3                       ret      
0x0000B467: cc                       int3     
0x0000B468: 48895c2418               mov      qword ptr [rsp + 0x18], rbx
0x0000B46D: 894c2408                 mov      dword ptr [rsp + 8], ecx
0x0000B471: 56                       push     rsi
0x0000B472: 57                       push     rdi
0x0000B473: 4156                     push     r14
0x0000B475: 4883ec20                 sub      rsp, 0x20
0x0000B479: 4863d9                   movsxd   rbx, ecx
0x0000B47C: 83fbfe                   cmp      ebx, -2
0x0000B47F: 7518                     jne      0x18000b499
0x0000B481: e89671ffff               call     0x18000261c
0x0000B486: 832000                   and      dword ptr [rax], 0
0x0000B489: e8fe71ffff               call     0x18000268c
0x0000B48E: c70009000000             mov      dword ptr [rax], 9
0x0000B494: e981000000               jmp      0x18000b51a
0x0000B499: 85c9                     test     ecx, ecx
0x0000B49B: 7865                     js       0x18000b502
0x0000B49D: 3b1de5220100             cmp      ebx, dword ptr [rip + 0x122e5]
0x0000B4A3: 735d                     jae      0x18000b502
0x0000B4A5: 488bc3                   mov      rax, rbx
0x0000B4A8: 488bfb                   mov      rdi, rbx
0x0000B4AB: 48c1ff05                 sar      rdi, 5
0x0000B4AF: 4c8d350adf0000           lea      r14, [rip + 0xdf0a]
0x0000B4B6: 83e01f                   and      eax, 0x1f
0x0000B4B9: 486bf058                 imul     rsi, rax, 0x58
0x0000B4BD: 498b04fe                 mov      rax, qword ptr [r14 + rdi*8]
0x0000B4C1: 0fbe4c3008               movsx    ecx, byte ptr [rax + rsi + 8]
0x0000B4C6: 83e101                   and      ecx, 1
0x0000B4C9: 7437                     je       0x18000b502
0x0000B4CB: 8bcb                     mov      ecx, ebx
0x0000B4CD: e842eeffff               call     0x18000a314
0x0000B4D2: 90                       nop      
0x0000B4D3: 498b04fe                 mov      rax, qword ptr [r14 + rdi*8]
0x0000B4D7: f644300801               test     byte ptr [rax + rsi + 8], 1
0x0000B4DC: 740b                     je       0x18000b4e9
0x0000B4DE: 8bcb                     mov      ecx, ebx
0x0000B4E0: e847000000               call     0x18000b52c
0x0000B4E5: 8bf8                     mov      edi, eax
0x0000B4E7: eb0e                     jmp      0x18000b4f7
0x0000B4E9: e89e71ffff               call     0x18000268c
0x0000B4EE: c70009000000             mov      dword ptr [rax], 9
0x0000B4F4: 83cfff                   or       edi, 0xffffffff
0x0000B4F7: 8bcb                     mov      ecx, ebx
0x0000B4F9: e8ceefffff               call     0x18000a4cc
0x0000B4FE: 8bc7                     mov      eax, edi
0x0000B500: eb1b                     jmp      0x18000b51d
0x0000B502: e81571ffff               call     0x18000261c
0x0000B507: 832000                   and      dword ptr [rax], 0
0x0000B50A: e87d71ffff               call     0x18000268c
0x0000B50F: c70009000000             mov      dword ptr [rax], 9
0x0000B515: e88a83ffff               call     0x1800038a4
0x0000B51A: 83c8ff                   or       eax, 0xffffffff
0x0000B51D: 488b5c2450               mov      rbx, qword ptr [rsp + 0x50]
0x0000B522: 4883c420                 add      rsp, 0x20
0x0000B526: 415e                     pop      r14
0x0000B528: 5f                       pop      rdi
0x0000B529: 5e                       pop      rsi
0x0000B52A: c3                       ret      
0x0000B52B: cc                       int3     
0x0000B52C: 48895c2408               mov      qword ptr [rsp + 8], rbx
0x0000B531: 57                       push     rdi
0x0000B532: 4883ec20                 sub      rsp, 0x20
0x0000B536: 4863f9                   movsxd   rdi, ecx
0x0000B539: 8bcf                     mov      ecx, edi
0x0000B53B: e818efffff               call     0x18000a458
0x0000B540: 4883f8ff                 cmp      rax, -1
0x0000B544: 7459                     je       0x18000b59f
0x0000B546: 488b0573de0000           mov      rax, qword ptr [rip + 0xde73]
0x0000B54D: b902000000               mov      ecx, 2
0x0000B552: 83ff01                   cmp      edi, 1
0x0000B555: 7509                     jne      0x18000b560
0x0000B557: 4084b8b8000000           test     byte ptr [rax + 0xb8], dil
0x0000B55E: 750a                     jne      0x18000b56a
0x0000B560: 3bf9                     cmp      edi, ecx
0x0000B562: 751d                     jne      0x18000b581
0x0000B564: f6406001                 test     byte ptr [rax + 0x60], 1
0x0000B568: 7417                     je       0x18000b581
0x0000B56A: e8e9eeffff               call     0x18000a458
0x0000B56F: b901000000               mov      ecx, 1
0x0000B574: 488bd8                   mov      rbx, rax
0x0000B577: e8dceeffff               call     0x18000a458
0x0000B57C: 483bc3                   cmp      rax, rbx
0x0000B57F: 741e                     je       0x18000b59f
0x0000B581: 8bcf                     mov      ecx, edi
0x0000B583: e8d0eeffff               call     0x18000a458
0x0000B588: 488bc8                   mov      rcx, rax
0x0000B58B: e803d92100               call     0x180228e93
0x0000B590: d085c0750a53             rol      byte ptr [rbp + 0x530a75c0], 1
0x0000B596: e89de91300               call     0x180149f38
0x0000B59B: 8bd8                     mov      ebx, eax
0x0000B59D: eb02                     jmp      0x18000b5a1
0x0000B59F: 33db                     xor      ebx, ebx
0x0000B5A1: 8bcf                     mov      ecx, edi
0x0000B5A3: e804eeffff               call     0x18000a3ac
0x0000B5A8: 488bd7                   mov      rdx, rdi
0x0000B5AB: 488bcf                   mov      rcx, rdi
0x0000B5AE: 48c1f905                 sar      rcx, 5
0x0000B5B2: 83e21f                   and      edx, 0x1f
0x0000B5B5: 4c8d0504de0000           lea      r8, [rip + 0xde04]
0x0000B5BC: 498b0cc8                 mov      rcx, qword ptr [r8 + rcx*8]
0x0000B5C0: 486bd258                 imul     rdx, rdx, 0x58
0x0000B5C4: c644110800               mov      byte ptr [rcx + rdx + 8], 0
0x0000B5C9: 85db                     test     ebx, ebx
0x0000B5CB: 740c                     je       0x18000b5d9
0x0000B5CD: 8bcb                     mov      ecx, ebx
0x0000B5CF: e86870ffff               call     0x18000263c
0x0000B5D4: 83c8ff                   or       eax, 0xffffffff
0x0000B5D7: eb02                     jmp      0x18000b5db
0x0000B5D9: 33c0                     xor      eax, eax
0x0000B5DB: 488b5c2430               mov      rbx, qword ptr [rsp + 0x30]
0x0000B5E0: 4883c420                 add      rsp, 0x20
0x0000B5E4: 5f                       pop      rdi
0x0000B5E5: c3                       ret      
0x0000B5E6: cc                       int3     
0x0000B5E7: cc                       int3     
0x0000B5E8: 4053                     push     rbx
0x0000B5EA: 4883ec20                 sub      rsp, 0x20
0x0000B5EE: f6411883                 test     byte ptr [rcx + 0x18], 0x83
0x0000B5F2: 488bd9                   mov      rbx, rcx
0x0000B5F5: 7422                     je       0x18000b619
0x0000B5F7: f6411808                 test     byte ptr [rcx + 0x18], 8
0x0000B5FB: 741c                     je       0x18000b619
0x0000B5FD: 488b4910                 mov      rcx, qword ptr [rcx + 0x10]
0x0000B601: e82a62ffff               call     0x180001830
0x0000B606: 816318f7fbffff           and      dword ptr [rbx + 0x18], 0xfffffbf7
0x0000B60D: 33c0                     xor      eax, eax
0x0000B60F: 488903                   mov      qword ptr [rbx], rax
0x0000B612: 48894310                 mov      qword ptr [rbx + 0x10], rax
0x0000B616: 894308                   mov      dword ptr [rbx + 8], eax
0x0000B619: 4883c420                 add      rsp, 0x20
0x0000B61D: 5b                       pop      rbx
0x0000B61E: c3                       ret      
0x0000B61F: cc                       int3     
0x0000B620: 4883ec28                 sub      rsp, 0x28
0x0000B624: 488b0dc5cd0000           mov      rcx, qword ptr [rip + 0xcdc5]
0x0000B62B: 488d4102                 lea      rax, [rcx + 2]
0x0000B62F: 4883f801                 cmp      rax, 1
0x0000B633: 7606                     jbe      0x18000b63b
0x0000B635: e878061100               call     0x18011bcb2
0x0000B63A: 9d                       popfq    
0x0000B63B: 4883c428                 add      rsp, 0x28
0x0000B63F: c3                       ret      
0x0000B640: 4883ec48                 sub      rsp, 0x48
0x0000B644: 488364243000             and      qword ptr [rsp + 0x30], 0
0x0000B64A: 8364242800               and      dword ptr [rsp + 0x28], 0
0x0000B64F: 41b803000000             mov      r8d, 3
0x0000B655: 488d0d24970000           lea      rcx, [rip + 0x9724]
0x0000B65C: 4533c9                   xor      r9d, r9d
0x0000B65F: ba00000040               mov      edx, 0x40000000
0x0000B664: 4489442420               mov      dword ptr [rsp + 0x20], r8d
0x0000B669: e88b290b00               call     0x1800bdff9
0x0000B66E: 7848                     js       0x18000b6b8
0x0000B670: 89057acd0000             mov      dword ptr [rip + 0xcd7a], eax
0x0000B676: 4883c448                 add      rsp, 0x48
0x0000B67A: c3                       ret      
0x0000B67B: cc                       int3     
0x0000B67C: cc                       int3     
0x0000B67D: cc                       int3     
0x0000B67E: cc                       int3     
0x0000B67F: cc                       int3     
0x0000B680: 48895c2408               mov      qword ptr [rsp + 8], rbx
0x0000B685: 4889742418               mov      qword ptr [rsp + 0x18], rsi
0x0000B68A: 48897c2420               mov      qword ptr [rsp + 0x20], rdi
0x0000B68F: 55                       push     rbp
0x0000B690: 4154                     push     r12
0x0000B692: 4155                     push     r13
0x0000B694: 4156                     push     r14
0x0000B696: 4157                     push     r15
0x0000B698: 488bec                   mov      rbp, rsp
0x0000B69B: 4883ec60                 sub      rsp, 0x60
0x0000B69F: 488b055ab90000           mov      rax, qword ptr [rip + 0xb95a]
0x0000B6A6: 4833c4                   xor      rax, rsp
0x0000B6A9: 488945f8                 mov      qword ptr [rbp - 8], rax
0x0000B6AD: 0fb7410a                 movzx    eax, word ptr [rcx + 0xa]
0x0000B6B1: 440fb709                 movzx    r9d, word ptr [rcx]
0x0000B6B5: 33db                     xor      ebx, ebx
0x0000B6B7: 8bf8                     mov      edi, eax
0x0000B6B9: 2500800000               and      eax, 0x8000
0x0000B6BE: 41c1e110                 shl      r9d, 0x10
0x0000B6C2: 8945c4                   mov      dword ptr [rbp - 0x3c], eax
0x0000B6C5: 8b4106                   mov      eax, dword ptr [rcx + 6]
0x0000B6C8: 81e7ff7f0000             and      edi, 0x7fff
0x0000B6CE: 8945e8                   mov      dword ptr [rbp - 0x18], eax
0x0000B6D1: 8b4102                   mov      eax, dword ptr [rcx + 2]
0x0000B6D4: 81efff3f0000             sub      edi, 0x3fff
0x0000B6DA: 41bc1f000000             mov      r12d, 0x1f
0x0000B6E0: 488955d0                 mov      qword ptr [rbp - 0x30], rdx
0x0000B6E4: 44894dd8                 mov      dword ptr [rbp - 0x28], r9d
0x0000B6E8: 8945ec                   mov      dword ptr [rbp - 0x14], eax
0x0000B6EB: 44894df0                 mov      dword ptr [rbp - 0x10], r9d
0x0000B6EF: 8d7301                   lea      esi, [rbx + 1]
0x0000B6F2: 458d7424e4               lea      r14d, [r12 - 0x1c]
0x0000B6F7: 81ff01c0ffff             cmp      edi, 0xffffc001
0x0000B6FD: 7529                     jne      0x18000b728
0x0000B6FF: 448bc3                   mov      r8d, ebx
0x0000B702: 8bc3                     mov      eax, ebx
0x0000B704: 395c85e8                 cmp      dword ptr [rbp + rax*4 - 0x18], ebx
0x0000B708: 750d                     jne      0x18000b717
0x0000B70A: 4803c6                   add      rax, rsi
0x0000B70D: 493bc6                   cmp      rax, r14
0x0000B710: 7cf2                     jl       0x18000b704
0x0000B712: e9b7040000               jmp      0x18000bbce
0x0000B717: 48895de8                 mov      qword ptr [rbp - 0x18], rbx
0x0000B71B: 895df0                   mov      dword ptr [rbp - 0x10], ebx
0x0000B71E: bb02000000               mov      ebx, 2
0x0000B723: e9a6040000               jmp      0x18000bbce
0x0000B728: 488b45e8                 mov      rax, qword ptr [rbp - 0x18]
0x0000B72C: 458bc4                   mov      r8d, r12d
0x0000B72F: 4183cfff                 or       r15d, 0xffffffff
0x0000B733: 488945e0                 mov      qword ptr [rbp - 0x20], rax
0x0000B737: 8b05d3cc0000             mov      eax, dword ptr [rip + 0xccd3]
0x0000B73D: 897dc0                   mov      dword ptr [rbp - 0x40], edi
0x0000B740: ffc8                     dec      eax
0x0000B742: 448beb                   mov      r13d, ebx
0x0000B745: 8945c8                   mov      dword ptr [rbp - 0x38], eax
0x0000B748: ffc0                     inc      eax
0x0000B74A: 99                       cdq      
0x0000B74B: 4123d4                   and      edx, r12d
0x0000B74E: 03c2                     add      eax, edx
0x0000B750: 448bd0                   mov      r10d, eax
0x0000B753: 4123c4                   and      eax, r12d
0x0000B756: 41c1fa05                 sar      r10d, 5
0x0000B75A: 2bc2                     sub      eax, edx
0x0000B75C: 442bc0                   sub      r8d, eax
0x0000B75F: 4d63da                   movsxd   r11, r10d
0x0000B762: 428b4c9de8               mov      ecx, dword ptr [rbp + r11*4 - 0x18]
0x0000B767: 448945dc                 mov      dword ptr [rbp - 0x24], r8d
0x0000B76B: 440fa3c1                 bt       ecx, r8d
0x0000B76F: 0f839e000000             jae      0x18000b813
0x0000B775: 418bc8                   mov      ecx, r8d
0x0000B778: 418bc7                   mov      eax, r15d
0x0000B77B: 4963d2                   movsxd   rdx, r10d
0x0000B77E: d3e0                     shl      eax, cl
0x0000B780: f7d0                     not      eax
0x0000B782: 854495e8                 test     dword ptr [rbp + rdx*4 - 0x18], eax
0x0000B786: 7519                     jne      0x18000b7a1
0x0000B788: 418d4201                 lea      eax, [r10 + 1]
0x0000B78C: 4863c8                   movsxd   rcx, eax
0x0000B78F: eb09                     jmp      0x18000b79a
0x0000B791: 395c8de8                 cmp      dword ptr [rbp + rcx*4 - 0x18], ebx
0x0000B795: 750a                     jne      0x18000b7a1
0x0000B797: 4803ce                   add      rcx, rsi
0x0000B79A: 493bce                   cmp      rcx, r14
0x0000B79D: 7cf2                     jl       0x18000b791
0x0000B79F: eb72                     jmp      0x18000b813
0x0000B7A1: 8b45c8                   mov      eax, dword ptr [rbp - 0x38]
0x0000B7A4: 418bcc                   mov      ecx, r12d
0x0000B7A7: 99                       cdq      
0x0000B7A8: 4123d4                   and      edx, r12d
0x0000B7AB: 03c2                     add      eax, edx
0x0000B7AD: 448bc0                   mov      r8d, eax
0x0000B7B0: 4123c4                   and      eax, r12d
0x0000B7B3: 2bc2                     sub      eax, edx
0x0000B7B5: 41c1f805                 sar      r8d, 5
0x0000B7B9: 8bd6                     mov      edx, esi
0x0000B7BB: 2bc8                     sub      ecx, eax
0x0000B7BD: 4d63d8                   movsxd   r11, r8d
0x0000B7C0: 428b449de8               mov      eax, dword ptr [rbp + r11*4 - 0x18]
0x0000B7C5: d3e2                     shl      edx, cl
0x0000B7C7: 8d0c10                   lea      ecx, [rax + rdx]
0x0000B7CA: 3bc8                     cmp      ecx, eax
0x0000B7CC: 7204                     jb       0x18000b7d2
0x0000B7CE: 3bca                     cmp      ecx, edx
0x0000B7D0: 7303                     jae      0x18000b7d5
0x0000B7D2: 448bee                   mov      r13d, esi
0x0000B7D5: 418d40ff                 lea      eax, [r8 - 1]
0x0000B7D9: 42894c9de8               mov      dword ptr [rbp + r11*4 - 0x18], ecx
0x0000B7DE: 4863d0                   movsxd   rdx, eax
0x0000B7E1: 85c0                     test     eax, eax
0x0000B7E3: 7827                     js       0x18000b80c
0x0000B7E5: 4585ed                   test     r13d, r13d
0x0000B7E8: 7422                     je       0x18000b80c
0x0000B7EA: 8b4495e8                 mov      eax, dword ptr [rbp + rdx*4 - 0x18]
0x0000B7EE: 448beb                   mov      r13d, ebx
0x0000B7F1: 448d4001                 lea      r8d, [rax + 1]
0x0000B7F5: 443bc0                   cmp      r8d, eax
0x0000B7F8: 7205                     jb       0x18000b7ff
0x0000B7FA: 443bc6                   cmp      r8d, esi
0x0000B7FD: 7303                     jae      0x18000b802
0x0000B7FF: 448bee                   mov      r13d, esi
0x0000B802: 44894495e8               mov      dword ptr [rbp + rdx*4 - 0x18], r8d
0x0000B807: 482bd6                   sub      rdx, rsi
0x0000B80A: 79d9                     jns      0x18000b7e5
0x0000B80C: 448b45dc                 mov      r8d, dword ptr [rbp - 0x24]
0x0000B810: 4d63da                   movsxd   r11, r10d
0x0000B813: 418bc8                   mov      ecx, r8d
0x0000B816: 418bc7                   mov      eax, r15d
0x0000B819: d3e0                     shl      eax, cl
0x0000B81B: 4221449de8               and      dword ptr [rbp + r11*4 - 0x18], eax
0x0000B820: 418d4201                 lea      eax, [r10 + 1]
0x0000B824: 4863d0                   movsxd   rdx, eax
0x0000B827: 493bd6                   cmp      rdx, r14
0x0000B82A: 7d1d                     jge      0x18000b849
0x0000B82C: 488d4de8                 lea      rcx, [rbp - 0x18]
0x0000B830: 4d8bc6                   mov      r8, r14
0x0000B833: 4c2bc2                   sub      r8, rdx
0x0000B836: 488d0c91                 lea      rcx, [rcx + rdx*4]
0x0000B83A: 33d2                     xor      edx, edx
0x0000B83C: 49c1e002                 shl      r8, 2
0x0000B840: e88b6affff               call     0x1800022d0
0x0000B845: 448b4dd8                 mov      r9d, dword ptr [rbp - 0x28]
0x0000B849: 4585ed                   test     r13d, r13d
0x0000B84C: 7402                     je       0x18000b850
0x0000B84E: 03fe                     add      edi, esi
0x0000B850: 8b0db6cb0000             mov      ecx, dword ptr [rip + 0xcbb6]
0x0000B856: 8bc1                     mov      eax, ecx
0x0000B858: 2b05b2cb0000             sub      eax, dword ptr [rip + 0xcbb2]
0x0000B85E: 3bf8                     cmp      edi, eax
0x0000B860: 7d14                     jge      0x18000b876
0x0000B862: 48895de8                 mov      qword ptr [rbp - 0x18], rbx
0x0000B866: 895df0                   mov      dword ptr [rbp - 0x10], ebx
0x0000B869: 448bc3                   mov      r8d, ebx
0x0000B86C: bb02000000               mov      ebx, 2
0x0000B871: e954030000               jmp      0x18000bbca
0x0000B876: 3bf9                     cmp      edi, ecx
0x0000B878: 0f8f31020000             jg       0x18000baaf
0x0000B87E: 2b4dc0                   sub      ecx, dword ptr [rbp - 0x40]
0x0000B881: 488b45e0                 mov      rax, qword ptr [rbp - 0x20]
0x0000B885: 458bd7                   mov      r10d, r15d
0x0000B888: 488945e8                 mov      qword ptr [rbp - 0x18], rax
0x0000B88C: 8bc1                     mov      eax, ecx
0x0000B88E: 44894df0                 mov      dword ptr [rbp - 0x10], r9d
0x0000B892: 99                       cdq      
0x0000B893: 4d8bde                   mov      r11, r14
0x0000B896: 448bcb                   mov      r9d, ebx
0x0000B899: 4123d4                   and      edx, r12d
0x0000B89C: 4c8d45e8                 lea      r8, [rbp - 0x18]
0x0000B8A0: 03c2                     add      eax, edx
0x0000B8A2: 448be8                   mov      r13d, eax
0x0000B8A5: 4123c4                   and      eax, r12d
0x0000B8A8: 2bc2                     sub      eax, edx
0x0000B8AA: 41c1fd05                 sar      r13d, 5
0x0000B8AE: 8bc8                     mov      ecx, eax
0x0000B8B0: 8bf8                     mov      edi, eax
0x0000B8B2: b820000000               mov      eax, 0x20
0x0000B8B7: 41d3e2                   shl      r10d, cl
0x0000B8BA: 2bc1                     sub      eax, ecx
0x0000B8BC: 448bf0                   mov      r14d, eax
0x0000B8BF: 41f7d2                   not      r10d
0x0000B8C2: 418b00                   mov      eax, dword ptr [r8]
0x0000B8C5: 8bcf                     mov      ecx, edi
0x0000B8C7: 8bd0                     mov      edx, eax
0x0000B8C9: d3e8                     shr      eax, cl
0x0000B8CB: 418bce                   mov      ecx, r14d
0x0000B8CE: 410bc1                   or       eax, r9d
0x0000B8D1: 4123d2                   and      edx, r10d
0x0000B8D4: 448bca                   mov      r9d, edx
0x0000B8D7: 418900                   mov      dword ptr [r8], eax
0x0000B8DA: 4d8d4004                 lea      r8, [r8 + 4]
0x0000B8DE: 41d3e1                   shl      r9d, cl
0x0000B8E1: 4c2bde                   sub      r11, rsi
0x0000B8E4: 75dc                     jne      0x18000b8c2
0x0000B8E6: 4d63d5                   movsxd   r10, r13d
0x0000B8E9: 418d7b02                 lea      edi, [r11 + 2]
0x0000B8ED: 458d7303                 lea      r14d, [r11 + 3]
0x0000B8F1: 4d8bca                   mov      r9, r10
0x0000B8F4: 448bc7                   mov      r8d, edi
0x0000B8F7: 49f7d9                   neg      r9
0x0000B8FA: 4d3bc2                   cmp      r8, r10
0x0000B8FD: 7c15                     jl       0x18000b914
0x0000B8FF: 498bd0                   mov      rdx, r8
0x0000B902: 48c1e202                 shl      rdx, 2
0x0000B906: 4a8d048a                 lea      rax, [rdx + r9*4]
0x0000B90A: 8b4c05e8                 mov      ecx, dword ptr [rbp + rax - 0x18]
0x0000B90E: 894c15e8                 mov      dword ptr [rbp + rdx - 0x18], ecx
0x0000B912: eb05                     jmp      0x18000b919
0x0000B914: 42895c85e8               mov      dword ptr [rbp + r8*4 - 0x18], ebx
0x0000B919: 4c2bc6                   sub      r8, rsi
0x0000B91C: 79dc                     jns      0x18000b8fa
0x0000B91E: 448b45c8                 mov      r8d, dword ptr [rbp - 0x38]
0x0000B922: 458bdc                   mov      r11d, r12d
0x0000B925: 418d4001                 lea      eax, [r8 + 1]
0x0000B929: 99                       cdq      
0x0000B92A: 4123d4                   and      edx, r12d
0x0000B92D: 03c2                     add      eax, edx
0x0000B92F: 448bc8                   mov      r9d, eax
0x0000B932: 4123c4                   and      eax, r12d
0x0000B935: 2bc2                     sub      eax, edx
0x0000B937: 41c1f905                 sar      r9d, 5
0x0000B93B: 442bd8                   sub      r11d, eax
0x0000B93E: 4963c1                   movsxd   rax, r9d
0x0000B941: 8b4c85e8                 mov      ecx, dword ptr [rbp + rax*4 - 0x18]
0x0000B945: 440fa3d9                 bt       ecx, r11d
0x0000B949: 0f8398000000             jae      0x18000b9e7
0x0000B94F: 418bcb                   mov      ecx, r11d
0x0000B952: 418bc7                   mov      eax, r15d
0x0000B955: 4963d1                   movsxd   rdx, r9d
0x0000B958: d3e0                     shl      eax, cl
0x0000B95A: f7d0                     not      eax
0x0000B95C: 854495e8                 test     dword ptr [rbp + rdx*4 - 0x18], eax
0x0000B960: 7519                     jne      0x18000b97b
0x0000B962: 418d4101                 lea      eax, [r9 + 1]
0x0000B966: 4863c8                   movsxd   rcx, eax
0x0000B969: eb09                     jmp      0x18000b974
0x0000B96B: 395c8de8                 cmp      dword ptr [rbp + rcx*4 - 0x18], ebx
0x0000B96F: 750a                     jne      0x18000b97b
0x0000B971: 4803ce                   add      rcx, rsi
0x0000B974: 493bce                   cmp      rcx, r14
0x0000B977: 7cf2                     jl       0x18000b96b
0x0000B979: eb6c                     jmp      0x18000b9e7
0x0000B97B: 418bc0                   mov      eax, r8d
0x0000B97E: 418bcc                   mov      ecx, r12d
0x0000B981: 99                       cdq      
0x0000B982: 4123d4                   and      edx, r12d
0x0000B985: 03c2                     add      eax, edx
0x0000B987: 448bd0                   mov      r10d, eax
0x0000B98A: 4123c4                   and      eax, r12d
0x0000B98D: 2bc2                     sub      eax, edx
0x0000B98F: 41c1fa05                 sar      r10d, 5
0x0000B993: 8bd6                     mov      edx, esi
0x0000B995: 2bc8                     sub      ecx, eax
0x0000B997: 4d63ea                   movsxd   r13, r10d
0x0000B99A: 428b44ade8               mov      eax, dword ptr [rbp + r13*4 - 0x18]
0x0000B99F: d3e2                     shl      edx, cl
0x0000B9A1: 8bcb                     mov      ecx, ebx
0x0000B9A3: 448d0410                 lea      r8d, [rax + rdx]
0x0000B9A7: 443bc0                   cmp      r8d, eax
0x0000B9AA: 7205                     jb       0x18000b9b1
0x0000B9AC: 443bc2                   cmp      r8d, edx
0x0000B9AF: 7302                     jae      0x18000b9b3
0x0000B9B1: 8bce                     mov      ecx, esi
0x0000B9B3: 418d42ff                 lea      eax, [r10 - 1]
0x0000B9B7: 468944ade8               mov      dword ptr [rbp + r13*4 - 0x18], r8d
0x0000B9BC: 4863d0                   movsxd   rdx, eax
0x0000B9BF: 85c0                     test     eax, eax
0x0000B9C1: 7824                     js       0x18000b9e7
0x0000B9C3: 85c9                     test     ecx, ecx
0x0000B9C5: 7420                     je       0x18000b9e7
0x0000B9C7: 8b4495e8                 mov      eax, dword ptr [rbp + rdx*4 - 0x18]
0x0000B9CB: 8bcb                     mov      ecx, ebx
0x0000B9CD: 448d4001                 lea      r8d, [rax + 1]
0x0000B9D1: 443bc0                   cmp      r8d, eax
0x0000B9D4: 7205                     jb       0x18000b9db
0x0000B9D6: 443bc6                   cmp      r8d, esi
0x0000B9D9: 7302                     jae      0x18000b9dd
0x0000B9DB: 8bce                     mov      ecx, esi
0x0000B9DD: 44894495e8               mov      dword ptr [rbp + rdx*4 - 0x18], r8d
0x0000B9E2: 482bd6                   sub      rdx, rsi
0x0000B9E5: 79dc                     jns      0x18000b9c3
0x0000B9E7: 418bcb                   mov      ecx, r11d
0x0000B9EA: 418bc7                   mov      eax, r15d
0x0000B9ED: d3e0                     shl      eax, cl
0x0000B9EF: 4963c9                   movsxd   rcx, r9d
0x0000B9F2: 21448de8                 and      dword ptr [rbp + rcx*4 - 0x18], eax
0x0000B9F6: 418d4101                 lea      eax, [r9 + 1]
0x0000B9FA: 4863d0                   movsxd   rdx, eax
0x0000B9FD: 493bd6                   cmp      rdx, r14
0x0000BA00: 7d19                     jge      0x18000ba1b
0x0000BA02: 488d4de8                 lea      rcx, [rbp - 0x18]
0x0000BA06: 4d8bc6                   mov      r8, r14
0x0000BA09: 4c2bc2                   sub      r8, rdx
0x0000BA0C: 488d0c91                 lea      rcx, [rcx + rdx*4]
0x0000BA10: 33d2                     xor      edx, edx
0x0000BA12: 49c1e002                 shl      r8, 2
0x0000BA16: e8b568ffff               call     0x1800022d0
0x0000BA1B: 8b05f3c90000             mov      eax, dword ptr [rip + 0xc9f3]
0x0000BA21: 41bd20000000             mov      r13d, 0x20
0x0000BA27: 448bcb                   mov      r9d, ebx
0x0000BA2A: ffc0                     inc      eax
0x0000BA2C: 4c8d45e8                 lea      r8, [rbp - 0x18]
0x0000BA30: 99                       cdq      
0x0000BA31: 4123d4                   and      edx, r12d
0x0000BA34: 03c2                     add      eax, edx
0x0000BA36: 448bd0                   mov      r10d, eax
0x0000BA39: 4123c4                   and      eax, r12d
0x0000BA3C: 2bc2                     sub      eax, edx
0x0000BA3E: 41c1fa05                 sar      r10d, 5
0x0000BA42: 8bc8                     mov      ecx, eax
0x0000BA44: 448bd8                   mov      r11d, eax
0x0000BA47: 41d3e7                   shl      r15d, cl
0x0000BA4A: 442be8                   sub      r13d, eax
0x0000BA4D: 41f7d7                   not      r15d
0x0000BA50: 418b00                   mov      eax, dword ptr [r8]
0x0000BA53: 418bcb                   mov      ecx, r11d
0x0000BA56: 8bd0                     mov      edx, eax
0x0000BA58: d3e8                     shr      eax, cl
0x0000BA5A: 418bcd                   mov      ecx, r13d
0x0000BA5D: 410bc1                   or       eax, r9d
0x0000BA60: 4123d7                   and      edx, r15d
0x0000BA63: 448bca                   mov      r9d, edx
0x0000BA66: 418900                   mov      dword ptr [r8], eax
0x0000BA69: 4d8d4004                 lea      r8, [r8 + 4]
0x0000BA6D: 41d3e1                   shl      r9d, cl
0x0000BA70: 4c2bf6                   sub      r14, rsi
0x0000BA73: 75db                     jne      0x18000ba50
0x0000BA75: 4d63d2                   movsxd   r10, r10d
0x0000BA78: 4c8bc7                   mov      r8, rdi
0x0000BA7B: 4d8bca                   mov      r9, r10
0x0000BA7E: 49f7d9                   neg      r9
0x0000BA81: 4d3bc2                   cmp      r8, r10
0x0000BA84: 7c15                     jl       0x18000ba9b
0x0000BA86: 498bd0                   mov      rdx, r8
0x0000BA89: 48c1e202                 shl      rdx, 2
0x0000BA8D: 4a8d048a                 lea      rax, [rdx + r9*4]
0x0000BA91: 8b4c05e8                 mov      ecx, dword ptr [rbp + rax - 0x18]
0x0000BA95: 894c15e8                 mov      dword ptr [rbp + rdx - 0x18], ecx
0x0000BA99: eb05                     jmp      0x18000baa0
0x0000BA9B: 42895c85e8               mov      dword ptr [rbp + r8*4 - 0x18], ebx
0x0000BAA0: 4c2bc6                   sub      r8, rsi
0x0000BAA3: 79dc                     jns      0x18000ba81
0x0000BAA5: 448bc3                   mov      r8d, ebx
0x0000BAA8: 8bdf                     mov      ebx, edi
0x0000BAAA: e91b010000               jmp      0x18000bbca
0x0000BAAF: 8b055fc90000             mov      eax, dword ptr [rip + 0xc95f]
0x0000BAB5: 448b154cc90000           mov      r10d, dword ptr [rip + 0xc94c]
0x0000BABC: 41bd20000000             mov      r13d, 0x20
0x0000BAC2: 99                       cdq      
0x0000BAC3: 4123d4                   and      edx, r12d
0x0000BAC6: 03c2                     add      eax, edx
0x0000BAC8: 448bd8                   mov      r11d, eax
0x0000BACB: 4123c4                   and      eax, r12d
0x0000BACE: 2bc2                     sub      eax, edx
0x0000BAD0: 41c1fb05                 sar      r11d, 5
0x0000BAD4: 8bc8                     mov      ecx, eax
0x0000BAD6: 41d3e7                   shl      r15d, cl
0x0000BAD9: 41f7d7                   not      r15d
0x0000BADC: 413bfa                   cmp      edi, r10d
0x0000BADF: 7c7a                     jl       0x18000bb5b
0x0000BAE1: 48895de8                 mov      qword ptr [rbp - 0x18], rbx
0x0000BAE5: 0fba6de81f               bts      dword ptr [rbp - 0x18], 0x1f
0x0000BAEA: 895df0                   mov      dword ptr [rbp - 0x10], ebx
0x0000BAED: 442be8                   sub      r13d, eax
0x0000BAF0: 8bf8                     mov      edi, eax
0x0000BAF2: 448bcb                   mov      r9d, ebx
0x0000BAF5: 4c8d45e8                 lea      r8, [rbp - 0x18]
0x0000BAF9: 418b00                   mov      eax, dword ptr [r8]
0x0000BAFC: 8bcf                     mov      ecx, edi
0x0000BAFE: 418bd7                   mov      edx, r15d
0x0000BB01: 23d0                     and      edx, eax
0x0000BB03: d3e8                     shr      eax, cl
0x0000BB05: 418bcd                   mov      ecx, r13d
0x0000BB08: 410bc1                   or       eax, r9d
0x0000BB0B: 448bca                   mov      r9d, edx
0x0000BB0E: 41d3e1                   shl      r9d, cl
0x0000BB11: 418900                   mov      dword ptr [r8], eax
0x0000BB14: 4d8d4004                 lea      r8, [r8 + 4]
0x0000BB18: 4c2bf6                   sub      r14, rsi
0x0000BB1B: 75dc                     jne      0x18000baf9
0x0000BB1D: 4d63cb                   movsxd   r9, r11d
0x0000BB20: 418d7e02                 lea      edi, [r14 + 2]
0x0000BB24: 4d8bc1                   mov      r8, r9
0x0000BB27: 49f7d8                   neg      r8
0x0000BB2A: 493bf9                   cmp      rdi, r9
0x0000BB2D: 7c15                     jl       0x18000bb44
0x0000BB2F: 488bd7                   mov      rdx, rdi
0x0000BB32: 48c1e202                 shl      rdx, 2
0x0000BB36: 4a8d0482                 lea      rax, [rdx + r8*4]
0x0000BB3A: 8b4c05e8                 mov      ecx, dword ptr [rbp + rax - 0x18]
0x0000BB3E: 894c15e8                 mov      dword ptr [rbp + rdx - 0x18], ecx
0x0000BB42: eb04                     jmp      0x18000bb48
0x0000BB44: 895cbde8                 mov      dword ptr [rbp + rdi*4 - 0x18], ebx
0x0000BB48: 482bfe                   sub      rdi, rsi
0x0000BB4B: 79dd                     jns      0x18000bb2a
0x0000BB4D: 448b05c8c80000           mov      r8d, dword ptr [rip + 0xc8c8]
0x0000BB54: 8bde                     mov      ebx, esi
0x0000BB56: 4503c2                   add      r8d, r10d
0x0000BB59: eb6f                     jmp      0x18000bbca
0x0000BB5B: 448b05bac80000           mov      r8d, dword ptr [rip + 0xc8ba]
0x0000BB62: 0fba75e81f               btr      dword ptr [rbp - 0x18], 0x1f
0x0000BB67: 448bd3                   mov      r10d, ebx
0x0000BB6A: 4403c7                   add      r8d, edi
0x0000BB6D: 8bf8                     mov      edi, eax
0x0000BB6F: 442be8                   sub      r13d, eax
0x0000BB72: 4c8d4de8                 lea      r9, [rbp - 0x18]
0x0000BB76: 418b01                   mov      eax, dword ptr [r9]
0x0000BB79: 8bcf                     mov      ecx, edi
0x0000BB7B: 8bd0                     mov      edx, eax
0x0000BB7D: d3e8                     shr      eax, cl
0x0000BB7F: 418bcd                   mov      ecx, r13d
0x0000BB82: 410bc2                   or       eax, r10d
0x0000BB85: 4123d7                   and      edx, r15d
0x0000BB88: 448bd2                   mov      r10d, edx
0x0000BB8B: 418901                   mov      dword ptr [r9], eax
0x0000BB8E: 4d8d4904                 lea      r9, [r9 + 4]
0x0000BB92: 41d3e2                   shl      r10d, cl
0x0000BB95: 4c2bf6                   sub      r14, rsi
0x0000BB98: 75dc                     jne      0x18000bb76
0x0000BB9A: 4d63d3                   movsxd   r10, r11d
0x0000BB9D: 418d7e02                 lea      edi, [r14 + 2]
0x0000BBA1: 4d8bca                   mov      r9, r10
0x0000BBA4: 49f7d9                   neg      r9
0x0000BBA7: 493bfa                   cmp      rdi, r10
0x0000BBAA: 7c15                     jl       0x18000bbc1
0x0000BBAC: 488bd7                   mov      rdx, rdi
0x0000BBAF: 48c1e202                 shl      rdx, 2
0x0000BBB3: 4a8d048a                 lea      rax, [rdx + r9*4]
0x0000BBB7: 8b4c05e8                 mov      ecx, dword ptr [rbp + rax - 0x18]
0x0000BBBB: 894c15e8                 mov      dword ptr [rbp + rdx - 0x18], ecx
0x0000BBBF: eb04                     jmp      0x18000bbc5
0x0000BBC1: 895cbde8                 mov      dword ptr [rbp + rdi*4 - 0x18], ebx
0x0000BBC5: 482bfe                   sub      rdi, rsi
0x0000BBC8: 79dd                     jns      0x18000bba7
0x0000BBCA: 488b55d0                 mov      rdx, qword ptr [rbp - 0x30]
0x0000BBCE: 442b253fc80000           sub      r12d, dword ptr [rip + 0xc83f]
0x0000BBD5: 418acc                   mov      cl, r12b
0x0000BBD8: 41d3e0                   shl      r8d, cl
0x0000BBDB: f75dc4                   neg      dword ptr [rbp - 0x3c]
0x0000BBDE: 1bc0                     sbb      eax, eax
0x0000BBE0: 2500000080               and      eax, 0x80000000
0x0000BBE5: 440bc0                   or       r8d, eax
0x0000BBE8: 8b052ac80000             mov      eax, dword ptr [rip + 0xc82a]
0x0000BBEE: 440b45e8                 or       r8d, dword ptr [rbp - 0x18]
0x0000BBF2: 83f840                   cmp      eax, 0x40
0x0000BBF5: 750b                     jne      0x18000bc02
0x0000BBF7: 8b45ec                   mov      eax, dword ptr [rbp - 0x14]
0x0000BBFA: 44894204                 mov      dword ptr [rdx + 4], r8d
0x0000BBFE: 8902                     mov      dword ptr [rdx], eax
0x0000BC00: eb08                     jmp      0x18000bc0a
0x0000BC02: 83f820                   cmp      eax, 0x20
0x0000BC05: 7503                     jne      0x18000bc0a
0x0000BC07: 448902                   mov      dword ptr [rdx], r8d
0x0000BC0A: 8bc3                     mov      eax, ebx
0x0000BC0C: 488b4df8                 mov      rcx, qword ptr [rbp - 8]
0x0000BC10: 4833cc                   xor      rcx, rsp
0x0000BC13: e8f85bffff               call     0x180001810
0x0000BC18: 4c8d5c2460               lea      r11, [rsp + 0x60]
0x0000BC1D: 498b5b30                 mov      rbx, qword ptr [r11 + 0x30]
0x0000BC21: 498b7340                 mov      rsi, qword ptr [r11 + 0x40]
0x0000BC25: 498b7b48                 mov      rdi, qword ptr [r11 + 0x48]
0x0000BC29: 498be3                   mov      rsp, r11
0x0000BC2C: 415f                     pop      r15
0x0000BC2E: 415e                     pop      r14
0x0000BC30: 415d                     pop      r13
0x0000BC32: 415c                     pop      r12
0x0000BC34: 5d                       pop      rbp
0x0000BC35: c3                       ret      
0x0000BC36: cc                       int3     
0x0000BC37: cc                       int3     
0x0000BC38: 48895c2408               mov      qword ptr [rsp + 8], rbx
0x0000BC3D: 4889742418               mov      qword ptr [rsp + 0x18], rsi
0x0000BC42: 48897c2420               mov      qword ptr [rsp + 0x20], rdi
0x0000BC47: 55                       push     rbp
0x0000BC48: 4154                     push     r12
0x0000BC4A: 4155                     push     r13
0x0000BC4C: 4156                     push     r14
0x0000BC4E: 4157                     push     r15
0x0000BC50: 488bec                   mov      rbp, rsp
0x0000BC53: 4883ec60                 sub      rsp, 0x60
0x0000BC57: 488b05a2b30000           mov      rax, qword ptr [rip + 0xb3a2]
0x0000BC5E: 4833c4                   xor      rax, rsp
0x0000BC61: 488945f8                 mov      qword ptr [rbp - 8], rax
0x0000BC65: 0fb7410a                 movzx    eax, word ptr [rcx + 0xa]
0x0000BC69: 440fb709                 movzx    r9d, word ptr [rcx]
0x0000BC6D: 33db                     xor      ebx, ebx
0x0000BC6F: 8bf8                     mov      edi, eax
0x0000BC71: 2500800000               and      eax, 0x8000
0x0000BC76: 41c1e110                 shl      r9d, 0x10
0x0000BC7A: 8945c4                   mov      dword ptr [rbp - 0x3c], eax
0x0000BC7D: 8b4106                   mov      eax, dword ptr [rcx + 6]
0x0000BC80: 81e7ff7f0000             and      edi, 0x7fff
0x0000BC86: 8945e8                   mov      dword ptr [rbp - 0x18], eax
0x0000BC89: 8b4102                   mov      eax, dword ptr [rcx + 2]
0x0000BC8C: 81efff3f0000             sub      edi, 0x3fff
0x0000BC92: 41bc1f000000             mov      r12d, 0x1f
0x0000BC98: 488955d0                 mov      qword ptr [rbp - 0x30], rdx
0x0000BC9C: 44894dd8                 mov      dword ptr [rbp - 0x28], r9d
0x0000BCA0: 8945ec                   mov      dword ptr [rbp - 0x14], eax
0x0000BCA3: 44894df0                 mov      dword ptr [rbp - 0x10], r9d
0x0000BCA7: 8d7301                   lea      esi, [rbx + 1]
0x0000BCAA: 458d7424e4               lea      r14d, [r12 - 0x1c]
0x0000BCAF: 81ff01c0ffff             cmp      edi, 0xffffc001
0x0000BCB5: 7529                     jne      0x18000bce0
0x0000BCB7: 448bc3                   mov      r8d, ebx
0x0000BCBA: 8bc3                     mov      eax, ebx
0x0000BCBC: 395c85e8                 cmp      dword ptr [rbp + rax*4 - 0x18], ebx
0x0000BCC0: 750d                     jne      0x18000bccf
0x0000BCC2: 4803c6                   add      rax, rsi
0x0000BCC5: 493bc6                   cmp      rax, r14
0x0000BCC8: 7cf2                     jl       0x18000bcbc
0x0000BCCA: e9b7040000               jmp      0x18000c186
0x0000BCCF: 48895de8                 mov      qword ptr [rbp - 0x18], rbx
0x0000BCD3: 895df0                   mov      dword ptr [rbp - 0x10], ebx
0x0000BCD6: bb02000000               mov      ebx, 2
0x0000BCDB: e9a6040000               jmp      0x18000c186
0x0000BCE0: 488b45e8                 mov      rax, qword ptr [rbp - 0x18]
0x0000BCE4: 458bc4                   mov      r8d, r12d
0x0000BCE7: 4183cfff                 or       r15d, 0xffffffff
0x0000BCEB: 488945e0                 mov      qword ptr [rbp - 0x20], rax
0x0000BCEF: 8b0533c70000             mov      eax, dword ptr [rip + 0xc733]
0x0000BCF5: 897dc0                   mov      dword ptr [rbp - 0x40], edi
0x0000BCF8: ffc8                     dec      eax
0x0000BCFA: 448beb                   mov      r13d, ebx
0x0000BCFD: 8945c8                   mov      dword ptr [rbp - 0x38], eax
0x0000BD00: ffc0                     inc      eax
0x0000BD02: 99                       cdq      
0x0000BD03: 4123d4                   and      edx, r12d
0x0000BD06: 03c2                     add      eax, edx
0x0000BD08: 448bd0                   mov      r10d, eax
0x0000BD0B: 4123c4                   and      eax, r12d
0x0000BD0E: 41c1fa05                 sar      r10d, 5
0x0000BD12: 2bc2                     sub      eax, edx
0x0000BD14: 442bc0                   sub      r8d, eax
0x0000BD17: 4d63da                   movsxd   r11, r10d
0x0000BD1A: 428b4c9de8               mov      ecx, dword ptr [rbp + r11*4 - 0x18]
0x0000BD1F: 448945dc                 mov      dword ptr [rbp - 0x24], r8d
0x0000BD23: 440fa3c1                 bt       ecx, r8d
0x0000BD27: 0f839e000000             jae      0x18000bdcb
0x0000BD2D: 418bc8                   mov      ecx, r8d
0x0000BD30: 418bc7                   mov      eax, r15d
0x0000BD33: 4963d2                   movsxd   rdx, r10d
0x0000BD36: d3e0                     shl      eax, cl
0x0000BD38: f7d0                     not      eax
0x0000BD3A: 854495e8                 test     dword ptr [rbp + rdx*4 - 0x18], eax
0x0000BD3E: 7519                     jne      0x18000bd59
0x0000BD40: 418d4201                 lea      eax, [r10 + 1]
0x0000BD44: 4863c8                   movsxd   rcx, eax
0x0000BD47: eb09                     jmp      0x18000bd52
0x0000BD49: 395c8de8                 cmp      dword ptr [rbp + rcx*4 - 0x18], ebx
0x0000BD4D: 750a                     jne      0x18000bd59
0x0000BD4F: 4803ce                   add      rcx, rsi
0x0000BD52: 493bce                   cmp      rcx, r14
0x0000BD55: 7cf2                     jl       0x18000bd49
0x0000BD57: eb72                     jmp      0x18000bdcb
0x0000BD59: 8b45c8                   mov      eax, dword ptr [rbp - 0x38]
0x0000BD5C: 418bcc                   mov      ecx, r12d
0x0000BD5F: 99                       cdq      
0x0000BD60: 4123d4                   and      edx, r12d
0x0000BD63: 03c2                     add      eax, edx
0x0000BD65: 448bc0                   mov      r8d, eax
0x0000BD68: 4123c4                   and      eax, r12d
0x0000BD6B: 2bc2                     sub      eax, edx
0x0000BD6D: 41c1f805                 sar      r8d, 5
0x0000BD71: 8bd6                     mov      edx, esi
0x0000BD73: 2bc8                     sub      ecx, eax
0x0000BD75: 4d63d8                   movsxd   r11, r8d
0x0000BD78: 428b449de8               mov      eax, dword ptr [rbp + r11*4 - 0x18]
0x0000BD7D: d3e2                     shl      edx, cl
0x0000BD7F: 8d0c10                   lea      ecx, [rax + rdx]
0x0000BD82: 3bc8                     cmp      ecx, eax
0x0000BD84: 7204                     jb       0x18000bd8a
0x0000BD86: 3bca                     cmp      ecx, edx
0x0000BD88: 7303                     jae      0x18000bd8d
0x0000BD8A: 448bee                   mov      r13d, esi
0x0000BD8D: 418d40ff                 lea      eax, [r8 - 1]
0x0000BD91: 42894c9de8               mov      dword ptr [rbp + r11*4 - 0x18], ecx
0x0000BD96: 4863d0                   movsxd   rdx, eax
0x0000BD99: 85c0                     test     eax, eax
0x0000BD9B: 7827                     js       0x18000bdc4
0x0000BD9D: 4585ed                   test     r13d, r13d
0x0000BDA0: 7422                     je       0x18000bdc4
0x0000BDA2: 8b4495e8                 mov      eax, dword ptr [rbp + rdx*4 - 0x18]
0x0000BDA6: 448beb                   mov      r13d, ebx
0x0000BDA9: 448d4001                 lea      r8d, [rax + 1]
0x0000BDAD: 443bc0                   cmp      r8d, eax
0x0000BDB0: 7205                     jb       0x18000bdb7
0x0000BDB2: 443bc6                   cmp      r8d, esi
0x0000BDB5: 7303                     jae      0x18000bdba
0x0000BDB7: 448bee                   mov      r13d, esi
0x0000BDBA: 44894495e8               mov      dword ptr [rbp + rdx*4 - 0x18], r8d
0x0000BDBF: 482bd6                   sub      rdx, rsi
0x0000BDC2: 79d9                     jns      0x18000bd9d
0x0000BDC4: 448b45dc                 mov      r8d, dword ptr [rbp - 0x24]
0x0000BDC8: 4d63da                   movsxd   r11, r10d
0x0000BDCB: 418bc8                   mov      ecx, r8d
0x0000BDCE: 418bc7                   mov      eax, r15d
0x0000BDD1: d3e0                     shl      eax, cl
0x0000BDD3: 4221449de8               and      dword ptr [rbp + r11*4 - 0x18], eax
0x0000BDD8: 418d4201                 lea      eax, [r10 + 1]
0x0000BDDC: 4863d0                   movsxd   rdx, eax
0x0000BDDF: 493bd6                   cmp      rdx, r14
0x0000BDE2: 7d1d                     jge      0x18000be01
0x0000BDE4: 488d4de8                 lea      rcx, [rbp - 0x18]
0x0000BDE8: 4d8bc6                   mov      r8, r14
0x0000BDEB: 4c2bc2                   sub      r8, rdx
0x0000BDEE: 488d0c91                 lea      rcx, [rcx + rdx*4]
0x0000BDF2: 33d2                     xor      edx, edx
0x0000BDF4: 49c1e002                 shl      r8, 2
0x0000BDF8: e8d364ffff               call     0x1800022d0
0x0000BDFD: 448b4dd8                 mov      r9d, dword ptr [rbp - 0x28]
0x0000BE01: 4585ed                   test     r13d, r13d
0x0000BE04: 7402                     je       0x18000be08
0x0000BE06: 03fe                     add      edi, esi
0x0000BE08: 8b0d16c60000             mov      ecx, dword ptr [rip + 0xc616]
0x0000BE0E: 8bc1                     mov      eax, ecx
0x0000BE10: 2b0512c60000             sub      eax, dword ptr [rip + 0xc612]
0x0000BE16: 3bf8                     cmp      edi, eax
0x0000BE18: 7d14                     jge      0x18000be2e
0x0000BE1A: 48895de8                 mov      qword ptr [rbp - 0x18], rbx
0x0000BE1E: 895df0                   mov      dword ptr [rbp - 0x10], ebx
0x0000BE21: 448bc3                   mov      r8d, ebx
0x0000BE24: bb02000000               mov      ebx, 2
0x0000BE29: e954030000               jmp      0x18000c182
0x0000BE2E: 3bf9                     cmp      edi, ecx
0x0000BE30: 0f8f31020000             jg       0x18000c067
0x0000BE36: 2b4dc0                   sub      ecx, dword ptr [rbp - 0x40]
0x0000BE39: 488b45e0                 mov      rax, qword ptr [rbp - 0x20]
0x0000BE3D: 458bd7                   mov      r10d, r15d
0x0000BE40: 488945e8                 mov      qword ptr [rbp - 0x18], rax
0x0000BE44: 8bc1                     mov      eax, ecx
0x0000BE46: 44894df0                 mov      dword ptr [rbp - 0x10], r9d
0x0000BE4A: 99                       cdq      
0x0000BE4B: 4d8bde                   mov      r11, r14
0x0000BE4E: 448bcb                   mov      r9d, ebx
0x0000BE51: 4123d4                   and      edx, r12d
0x0000BE54: 4c8d45e8                 lea      r8, [rbp - 0x18]
0x0000BE58: 03c2                     add      eax, edx
0x0000BE5A: 448be8                   mov      r13d, eax
0x0000BE5D: 4123c4                   and      eax, r12d
0x0000BE60: 2bc2                     sub      eax, edx
0x0000BE62: 41c1fd05                 sar      r13d, 5
0x0000BE66: 8bc8                     mov      ecx, eax
0x0000BE68: 8bf8                     mov      edi, eax
0x0000BE6A: b820000000               mov      eax, 0x20
0x0000BE6F: 41d3e2                   shl      r10d, cl
0x0000BE72: 2bc1                     sub      eax, ecx
0x0000BE74: 448bf0                   mov      r14d, eax
0x0000BE77: 41f7d2                   not      r10d
0x0000BE7A: 418b00                   mov      eax, dword ptr [r8]
0x0000BE7D: 8bcf                     mov      ecx, edi
0x0000BE7F: 8bd0                     mov      edx, eax
0x0000BE81: d3e8                     shr      eax, cl
0x0000BE83: 418bce                   mov      ecx, r14d
0x0000BE86: 410bc1                   or       eax, r9d
0x0000BE89: 4123d2                   and      edx, r10d
0x0000BE8C: 448bca                   mov      r9d, edx
0x0000BE8F: 418900                   mov      dword ptr [r8], eax
0x0000BE92: 4d8d4004                 lea      r8, [r8 + 4]
0x0000BE96: 41d3e1                   shl      r9d, cl
0x0000BE99: 4c2bde                   sub      r11, rsi
0x0000BE9C: 75dc                     jne      0x18000be7a
0x0000BE9E: 4d63d5                   movsxd   r10, r13d
0x0000BEA1: 418d7b02                 lea      edi, [r11 + 2]
0x0000BEA5: 458d7303                 lea      r14d, [r11 + 3]
0x0000BEA9: 4d8bca                   mov      r9, r10
0x0000BEAC: 448bc7                   mov      r8d, edi
0x0000BEAF: 49f7d9                   neg      r9
0x0000BEB2: 4d3bc2                   cmp      r8, r10
0x0000BEB5: 7c15                     jl       0x18000becc
0x0000BEB7: 498bd0                   mov      rdx, r8
0x0000BEBA: 48c1e202                 shl      rdx, 2
0x0000BEBE: 4a8d048a                 lea      rax, [rdx + r9*4]
0x0000BEC2: 8b4c05e8                 mov      ecx, dword ptr [rbp + rax - 0x18]
0x0000BEC6: 894c15e8                 mov      dword ptr [rbp + rdx - 0x18], ecx
0x0000BECA: eb05                     jmp      0x18000bed1
0x0000BECC: 42895c85e8               mov      dword ptr [rbp + r8*4 - 0x18], ebx
0x0000BED1: 4c2bc6                   sub      r8, rsi
0x0000BED4: 79dc                     jns      0x18000beb2
0x0000BED6: 448b45c8                 mov      r8d, dword ptr [rbp - 0x38]
0x0000BEDA: 458bdc                   mov      r11d, r12d
0x0000BEDD: 418d4001                 lea      eax, [r8 + 1]
0x0000BEE1: 99                       cdq      
0x0000BEE2: 4123d4                   and      edx, r12d
0x0000BEE5: 03c2                     add      eax, edx
0x0000BEE7: 448bc8                   mov      r9d, eax
0x0000BEEA: 4123c4                   and      eax, r12d
0x0000BEED: 2bc2                     sub      eax, edx
0x0000BEEF: 41c1f905                 sar      r9d, 5
0x0000BEF3: 442bd8                   sub      r11d, eax
0x0000BEF6: 4963c1                   movsxd   rax, r9d
0x0000BEF9: 8b4c85e8                 mov      ecx, dword ptr [rbp + rax*4 - 0x18]
0x0000BEFD: 440fa3d9                 bt       ecx, r11d
0x0000BF01: 0f8398000000             jae      0x18000bf9f
0x0000BF07: 418bcb                   mov      ecx, r11d
0x0000BF0A: 418bc7                   mov      eax, r15d
0x0000BF0D: 4963d1                   movsxd   rdx, r9d
0x0000BF10: d3e0                     shl      eax, cl
0x0000BF12: f7d0                     not      eax
0x0000BF14: 854495e8                 test     dword ptr [rbp + rdx*4 - 0x18], eax
0x0000BF18: 7519                     jne      0x18000bf33
0x0000BF1A: 418d4101                 lea      eax, [r9 + 1]
0x0000BF1E: 4863c8                   movsxd   rcx, eax
0x0000BF21: eb09                     jmp      0x18000bf2c
0x0000BF23: 395c8de8                 cmp      dword ptr [rbp + rcx*4 - 0x18], ebx
0x0000BF27: 750a                     jne      0x18000bf33
0x0000BF29: 4803ce                   add      rcx, rsi
0x0000BF2C: 493bce                   cmp      rcx, r14
0x0000BF2F: 7cf2                     jl       0x18000bf23
0x0000BF31: eb6c                     jmp      0x18000bf9f
0x0000BF33: 418bc0                   mov      eax, r8d
0x0000BF36: 418bcc                   mov      ecx, r12d
0x0000BF39: 99                       cdq      
0x0000BF3A: 4123d4                   and      edx, r12d
0x0000BF3D: 03c2                     add      eax, edx
0x0000BF3F: 448bd0                   mov      r10d, eax
0x0000BF42: 4123c4                   and      eax, r12d
0x0000BF45: 2bc2                     sub      eax, edx
0x0000BF47: 41c1fa05                 sar      r10d, 5
0x0000BF4B: 8bd6                     mov      edx, esi
0x0000BF4D: 2bc8                     sub      ecx, eax
0x0000BF4F: 4d63ea                   movsxd   r13, r10d
0x0000BF52: 428b44ade8               mov      eax, dword ptr [rbp + r13*4 - 0x18]
0x0000BF57: d3e2                     shl      edx, cl
0x0000BF59: 8bcb                     mov      ecx, ebx
0x0000BF5B: 448d0410                 lea      r8d, [rax + rdx]
0x0000BF5F: 443bc0                   cmp      r8d, eax
0x0000BF62: 7205                     jb       0x18000bf69
0x0000BF64: 443bc2                   cmp      r8d, edx
0x0000BF67: 7302                     jae      0x18000bf6b
0x0000BF69: 8bce                     mov      ecx, esi
0x0000BF6B: 418d42ff                 lea      eax, [r10 - 1]
0x0000BF6F: 468944ade8               mov      dword ptr [rbp + r13*4 - 0x18], r8d
0x0000BF74: 4863d0                   movsxd   rdx, eax
0x0000BF77: 85c0                     test     eax, eax
0x0000BF79: 7824                     js       0x18000bf9f
0x0000BF7B: 85c9                     test     ecx, ecx
0x0000BF7D: 7420                     je       0x18000bf9f
0x0000BF7F: 8b4495e8                 mov      eax, dword ptr [rbp + rdx*4 - 0x18]
0x0000BF83: 8bcb                     mov      ecx, ebx
0x0000BF85: 448d4001                 lea      r8d, [rax + 1]
0x0000BF89: 443bc0                   cmp      r8d, eax
0x0000BF8C: 7205                     jb       0x18000bf93
0x0000BF8E: 443bc6                   cmp      r8d, esi
0x0000BF91: 7302                     jae      0x18000bf95
0x0000BF93: 8bce                     mov      ecx, esi
0x0000BF95: 44894495e8               mov      dword ptr [rbp + rdx*4 - 0x18], r8d
0x0000BF9A: 482bd6                   sub      rdx, rsi
0x0000BF9D: 79dc                     jns      0x18000bf7b
0x0000BF9F: 418bcb                   mov      ecx, r11d
0x0000BFA2: 418bc7                   mov      eax, r15d
0x0000BFA5: d3e0                     shl      eax, cl
0x0000BFA7: 4963c9                   movsxd   rcx, r9d
0x0000BFAA: 21448de8                 and      dword ptr [rbp + rcx*4 - 0x18], eax
0x0000BFAE: 418d4101                 lea      eax, [r9 + 1]
0x0000BFB2: 4863d0                   movsxd   rdx, eax
0x0000BFB5: 493bd6                   cmp      rdx, r14
0x0000BFB8: 7d19                     jge      0x18000bfd3
0x0000BFBA: 488d4de8                 lea      rcx, [rbp - 0x18]
0x0000BFBE: 4d8bc6                   mov      r8, r14
0x0000BFC1: 4c2bc2                   sub      r8, rdx
0x0000BFC4: 488d0c91                 lea      rcx, [rcx + rdx*4]
0x0000BFC8: 33d2                     xor      edx, edx
0x0000BFCA: 49c1e002                 shl      r8, 2
0x0000BFCE: e8fd62ffff               call     0x1800022d0
0x0000BFD3: 8b0553c40000             mov      eax, dword ptr [rip + 0xc453]
0x0000BFD9: 41bd20000000             mov      r13d, 0x20
0x0000BFDF: 448bcb                   mov      r9d, ebx
0x0000BFE2: ffc0                     inc      eax
0x0000BFE4: 4c8d45e8                 lea      r8, [rbp - 0x18]
0x0000BFE8: 99                       cdq      
0x0000BFE9: 4123d4                   and      edx, r12d
0x0000BFEC: 03c2                     add      eax, edx
0x0000BFEE: 448bd0                   mov      r10d, eax
0x0000BFF1: 4123c4                   and      eax, r12d
0x0000BFF4: 2bc2                     sub      eax, edx
0x0000BFF6: 41c1fa05                 sar      r10d, 5
0x0000BFFA: 8bc8                     mov      ecx, eax
0x0000BFFC: 448bd8                   mov      r11d, eax
0x0000BFFF: 41d3e7                   shl      r15d, cl
0x0000C002: 442be8                   sub      r13d, eax
0x0000C005: 41f7d7                   not      r15d
0x0000C008: 418b00                   mov      eax, dword ptr [r8]
0x0000C00B: 418bcb                   mov      ecx, r11d
0x0000C00E: 8bd0                     mov      edx, eax
0x0000C010: d3e8                     shr      eax, cl
0x0000C012: 418bcd                   mov      ecx, r13d
0x0000C015: 410bc1                   or       eax, r9d
0x0000C018: 4123d7                   and      edx, r15d
0x0000C01B: 448bca                   mov      r9d, edx
0x0000C01E: 418900                   mov      dword ptr [r8], eax
0x0000C021: 4d8d4004                 lea      r8, [r8 + 4]
0x0000C025: 41d3e1                   shl      r9d, cl
0x0000C028: 4c2bf6                   sub      r14, rsi
0x0000C02B: 75db                     jne      0x18000c008
0x0000C02D: 4d63d2                   movsxd   r10, r10d
0x0000C030: 4c8bc7                   mov      r8, rdi
0x0000C033: 4d8bca                   mov      r9, r10
0x0000C036: 49f7d9                   neg      r9
0x0000C039: 4d3bc2                   cmp      r8, r10
0x0000C03C: 7c15                     jl       0x18000c053
0x0000C03E: 498bd0                   mov      rdx, r8
0x0000C041: 48c1e202                 shl      rdx, 2
0x0000C045: 4a8d048a                 lea      rax, [rdx + r9*4]
0x0000C049: 8b4c05e8                 mov      ecx, dword ptr [rbp + rax - 0x18]
0x0000C04D: 894c15e8                 mov      dword ptr [rbp + rdx - 0x18], ecx
0x0000C051: eb05                     jmp      0x18000c058
0x0000C053: 42895c85e8               mov      dword ptr [rbp + r8*4 - 0x18], ebx
0x0000C058: 4c2bc6                   sub      r8, rsi
0x0000C05B: 79dc                     jns      0x18000c039
0x0000C05D: 448bc3                   mov      r8d, ebx
0x0000C060: 8bdf                     mov      ebx, edi
0x0000C062: e91b010000               jmp      0x18000c182
0x0000C067: 8b05bfc30000             mov      eax, dword ptr [rip + 0xc3bf]
0x0000C06D: 448b15acc30000           mov      r10d, dword ptr [rip + 0xc3ac]
0x0000C074: 41bd20000000             mov      r13d, 0x20
0x0000C07A: 99                       cdq      
0x0000C07B: 4123d4                   and      edx, r12d
0x0000C07E: 03c2                     add      eax, edx
0x0000C080: 448bd8                   mov      r11d, eax
0x0000C083: 4123c4                   and      eax, r12d
0x0000C086: 2bc2                     sub      eax, edx
0x0000C088: 41c1fb05                 sar      r11d, 5
0x0000C08C: 8bc8                     mov      ecx, eax
0x0000C08E: 41d3e7                   shl      r15d, cl
0x0000C091: 41f7d7                   not      r15d
0x0000C094: 413bfa                   cmp      edi, r10d
0x0000C097: 7c7a                     jl       0x18000c113
0x0000C099: 48895de8                 mov      qword ptr [rbp - 0x18], rbx
0x0000C09D: 0fba6de81f               bts      dword ptr [rbp - 0x18], 0x1f
0x0000C0A2: 895df0                   mov      dword ptr [rbp - 0x10], ebx
0x0000C0A5: 442be8                   sub      r13d, eax
0x0000C0A8: 8bf8                     mov      edi, eax
0x0000C0AA: 448bcb                   mov      r9d, ebx
0x0000C0AD: 4c8d45e8                 lea      r8, [rbp - 0x18]
0x0000C0B1: 418b00                   mov      eax, dword ptr [r8]
0x0000C0B4: 8bcf                     mov      ecx, edi
0x0000C0B6: 418bd7                   mov      edx, r15d
0x0000C0B9: 23d0                     and      edx, eax
0x0000C0BB: d3e8                     shr      eax, cl
0x0000C0BD: 418bcd                   mov      ecx, r13d
0x0000C0C0: 410bc1                   or       eax, r9d
0x0000C0C3: 448bca                   mov      r9d, edx
0x0000C0C6: 41d3e1                   shl      r9d, cl
0x0000C0C9: 418900                   mov      dword ptr [r8], eax
0x0000C0CC: 4d8d4004                 lea      r8, [r8 + 4]
0x0000C0D0: 4c2bf6                   sub      r14, rsi
0x0000C0D3: 75dc                     jne      0x18000c0b1
0x0000C0D5: 4d63cb                   movsxd   r9, r11d
0x0000C0D8: 418d7e02                 lea      edi, [r14 + 2]
0x0000C0DC: 4d8bc1                   mov      r8, r9
0x0000C0DF: 49f7d8                   neg      r8
0x0000C0E2: 493bf9                   cmp      rdi, r9
0x0000C0E5: 7c15                     jl       0x18000c0fc
0x0000C0E7: 488bd7                   mov      rdx, rdi
0x0000C0EA: 48c1e202                 shl      rdx, 2
0x0000C0EE: 4a8d0482                 lea      rax, [rdx + r8*4]
0x0000C0F2: 8b4c05e8                 mov      ecx, dword ptr [rbp + rax - 0x18]
0x0000C0F6: 894c15e8                 mov      dword ptr [rbp + rdx - 0x18], ecx
0x0000C0FA: eb04                     jmp      0x18000c100
0x0000C0FC: 895cbde8                 mov      dword ptr [rbp + rdi*4 - 0x18], ebx
0x0000C100: 482bfe                   sub      rdi, rsi
0x0000C103: 79dd                     jns      0x18000c0e2
0x0000C105: 448b0528c30000           mov      r8d, dword ptr [rip + 0xc328]
0x0000C10C: 8bde                     mov      ebx, esi
0x0000C10E: 4503c2                   add      r8d, r10d
0x0000C111: eb6f                     jmp      0x18000c182
0x0000C113: 448b051ac30000           mov      r8d, dword ptr [rip + 0xc31a]
0x0000C11A: 0fba75e81f               btr      dword ptr [rbp - 0x18], 0x1f
0x0000C11F: 448bd3                   mov      r10d, ebx
0x0000C122: 4403c7                   add      r8d, edi
0x0000C125: 8bf8                     mov      edi, eax
0x0000C127: 442be8                   sub      r13d, eax
0x0000C12A: 4c8d4de8                 lea      r9, [rbp - 0x18]
0x0000C12E: 418b01                   mov      eax, dword ptr [r9]
0x0000C131: 8bcf                     mov      ecx, edi
0x0000C133: 8bd0                     mov      edx, eax
0x0000C135: d3e8                     shr      eax, cl
0x0000C137: 418bcd                   mov      ecx, r13d
0x0000C13A: 410bc2                   or       eax, r10d
0x0000C13D: 4123d7                   and      edx, r15d
0x0000C140: 448bd2                   mov      r10d, edx
0x0000C143: 418901                   mov      dword ptr [r9], eax
0x0000C146: 4d8d4904                 lea      r9, [r9 + 4]
0x0000C14A: 41d3e2                   shl      r10d, cl
0x0000C14D: 4c2bf6                   sub      r14, rsi
0x0000C150: 75dc                     jne      0x18000c12e
0x0000C152: 4d63d3                   movsxd   r10, r11d
0x0000C155: 418d7e02                 lea      edi, [r14 + 2]
0x0000C159: 4d8bca                   mov      r9, r10
0x0000C15C: 49f7d9                   neg      r9
0x0000C15F: 493bfa                   cmp      rdi, r10
0x0000C162: 7c15                     jl       0x18000c179
0x0000C164: 488bd7                   mov      rdx, rdi
0x0000C167: 48c1e202                 shl      rdx, 2
0x0000C16B: 4a8d048a                 lea      rax, [rdx + r9*4]
0x0000C16F: 8b4c05e8                 mov      ecx, dword ptr [rbp + rax - 0x18]
0x0000C173: 894c15e8                 mov      dword ptr [rbp + rdx - 0x18], ecx
0x0000C177: eb04                     jmp      0x18000c17d
0x0000C179: 895cbde8                 mov      dword ptr [rbp + rdi*4 - 0x18], ebx
0x0000C17D: 482bfe                   sub      rdi, rsi
0x0000C180: 79dd                     jns      0x18000c15f
0x0000C182: 488b55d0                 mov      rdx, qword ptr [rbp - 0x30]
0x0000C186: 442b259fc20000           sub      r12d, dword ptr [rip + 0xc29f]
0x0000C18D: 418acc                   mov      cl, r12b
0x0000C190: 41d3e0                   shl      r8d, cl
0x0000C193: f75dc4                   neg      dword ptr [rbp - 0x3c]
0x0000C196: 1bc0                     sbb      eax, eax
0x0000C198: 2500000080               and      eax, 0x80000000
0x0000C19D: 440bc0                   or       r8d, eax
0x0000C1A0: 8b058ac20000             mov      eax, dword ptr [rip + 0xc28a]
0x0000C1A6: 440b45e8                 or       r8d, dword ptr [rbp - 0x18]
0x0000C1AA: 83f840                   cmp      eax, 0x40
0x0000C1AD: 750b                     jne      0x18000c1ba
0x0000C1AF: 8b45ec                   mov      eax, dword ptr [rbp - 0x14]
0x0000C1B2: 44894204                 mov      dword ptr [rdx + 4], r8d
0x0000C1B6: 8902                     mov      dword ptr [rdx], eax
0x0000C1B8: eb08                     jmp      0x18000c1c2
0x0000C1BA: 83f820                   cmp      eax, 0x20
0x0000C1BD: 7503                     jne      0x18000c1c2
0x0000C1BF: 448902                   mov      dword ptr [rdx], r8d
0x0000C1C2: 8bc3                     mov      eax, ebx
0x0000C1C4: 488b4df8                 mov      rcx, qword ptr [rbp - 8]
0x0000C1C8: 4833cc                   xor      rcx, rsp
0x0000C1CB: e84056ffff               call     0x180001810
0x0000C1D0: 4c8d5c2460               lea      r11, [rsp + 0x60]
0x0000C1D5: 498b5b30                 mov      rbx, qword ptr [r11 + 0x30]
0x0000C1D9: 498b7340                 mov      rsi, qword ptr [r11 + 0x40]
0x0000C1DD: 498b7b48                 mov      rdi, qword ptr [r11 + 0x48]
0x0000C1E1: 498be3                   mov      rsp, r11
0x0000C1E4: 415f                     pop      r15
0x0000C1E6: 415e                     pop      r14
0x0000C1E8: 415d                     pop      r13
0x0000C1EA: 415c                     pop      r12
0x0000C1EC: 5d                       pop      rbp
0x0000C1ED: c3                       ret      
0x0000C1EE: cc                       int3     
0x0000C1EF: cc                       int3     
0x0000C1F0: 48895c2418               mov      qword ptr [rsp + 0x18], rbx
0x0000C1F5: 55                       push     rbp
0x0000C1F6: 56                       push     rsi
0x0000C1F7: 57                       push     rdi
0x0000C1F8: 4154                     push     r12
0x0000C1FA: 4155                     push     r13
0x0000C1FC: 4156                     push     r14
0x0000C1FE: 4157                     push     r15
0x0000C200: 488d6c24f9               lea      rbp, [rsp - 7]
0x0000C205: 4881eca0000000           sub      rsp, 0xa0
0x0000C20C: 488b05edad0000           mov      rax, qword ptr [rip + 0xaded]
0x0000C213: 4833c4                   xor      rax, rsp
0x0000C216: 488945ff                 mov      qword ptr [rbp - 1], rax
0x0000C21A: 4c8b757f                 mov      r14, qword ptr [rbp + 0x7f]
0x0000C21E: 33db                     xor      ebx, ebx
0x0000C220: 44894d93                 mov      dword ptr [rbp - 0x6d], r9d
0x0000C224: 448d4b01                 lea      r9d, [rbx + 1]
0x0000C228: 48894da7                 mov      qword ptr [rbp - 0x59], rcx
0x0000C22C: 48895597                 mov      qword ptr [rbp - 0x69], rdx
0x0000C230: 4c8d55df                 lea      r10, [rbp - 0x21]
0x0000C234: 66895d8f                 mov      word ptr [rbp - 0x71], bx
0x0000C238: 448bdb                   mov      r11d, ebx
0x0000C23B: 44894d8b                 mov      dword ptr [rbp - 0x75], r9d
0x0000C23F: 448bfb                   mov      r15d, ebx
0x0000C242: 895d87                   mov      dword ptr [rbp - 0x79], ebx
0x0000C245: 448be3                   mov      r12d, ebx
0x0000C248: 448beb                   mov      r13d, ebx
0x0000C24B: 8bf3                     mov      esi, ebx
0x0000C24D: 8bcb                     mov      ecx, ebx
0x0000C24F: 4d85f6                   test     r14, r14
0x0000C252: 7517                     jne      0x18000c26b
0x0000C254: e83364ffff               call     0x18000268c
0x0000C259: c70016000000             mov      dword ptr [rax], 0x16
0x0000C25F: e84076ffff               call     0x1800038a4
0x0000C264: 33c0                     xor      eax, eax
0x0000C266: e9bf070000               jmp      0x18000ca2a
0x0000C26B: 498bf8                   mov      rdi, r8
0x0000C26E: 41803820                 cmp      byte ptr [r8], 0x20
0x0000C272: 7719                     ja       0x18000c28d
0x0000C274: 490fbe00                 movsx    rax, byte ptr [r8]
0x0000C278: 48ba0026000001000000     movabs   rdx, 0x100002600
0x0000C282: 480fa3c2                 bt       rdx, rax
0x0000C286: 7305                     jae      0x18000c28d
0x0000C288: 4d03c1                   add      r8, r9
0x0000C28B: ebe1                     jmp      0x18000c26e
0x0000C28D: 418a10                   mov      dl, byte ptr [r8]
0x0000C290: 4d03c1                   add      r8, r9
0x0000C293: 83f905                   cmp      ecx, 5
0x0000C296: 0f8f0a020000             jg       0x18000c4a6
0x0000C29C: 0f84ea010000             je       0x18000c48c
0x0000C2A2: 448bc9                   mov      r9d, ecx
0x0000C2A5: 85c9                     test     ecx, ecx
0x0000C2A7: 0f8483010000             je       0x18000c430
0x0000C2AD: 41ffc9                   dec      r9d
0x0000C2B0: 0f843a010000             je       0x18000c3f0
0x0000C2B6: 41ffc9                   dec      r9d
0x0000C2B9: 0f84df000000             je       0x18000c39e
0x0000C2BF: 41ffc9                   dec      r9d
0x0000C2C2: 0f8489000000             je       0x18000c351
0x0000C2C8: 41ffc9                   dec      r9d
0x0000C2CB: 0f859a020000             jne      0x18000c56b
0x0000C2D1: 41b901000000             mov      r9d, 1
0x0000C2D7: b030                     mov      al, 0x30
0x0000C2D9: 458bf9                   mov      r15d, r9d
0x0000C2DC: 44894d87                 mov      dword ptr [rbp - 0x79], r9d
0x0000C2E0: 4585db                   test     r11d, r11d
0x0000C2E3: 7530                     jne      0x18000c315
0x0000C2E5: eb09                     jmp      0x18000c2f0
0x0000C2E7: 418a10                   mov      dl, byte ptr [r8]
0x0000C2EA: 412bf1                   sub      esi, r9d
0x0000C2ED: 4d03c1                   add      r8, r9
0x0000C2F0: 3ad0                     cmp      dl, al
0x0000C2F2: 74f3                     je       0x18000c2e7
0x0000C2F4: eb1f                     jmp      0x18000c315
0x0000C2F6: 80fa39                   cmp      dl, 0x39
0x0000C2F9: 7f1e                     jg       0x18000c319
0x0000C2FB: 4183fb19                 cmp      r11d, 0x19
0x0000C2FF: 730e                     jae      0x18000c30f
0x0000C301: 2ad0                     sub      dl, al
0x0000C303: 4503d9                   add      r11d, r9d
0x0000C306: 418812                   mov      byte ptr [r10], dl
0x0000C309: 4d03d1                   add      r10, r9
0x0000C30C: 412bf1                   sub      esi, r9d
0x0000C30F: 418a10                   mov      dl, byte ptr [r8]
0x0000C312: 4d03c1                   add      r8, r9
0x0000C315: 3ad0                     cmp      dl, al
0x0000C317: 7ddd                     jge      0x18000c2f6
0x0000C319: 8d42d5                   lea      eax, [rdx - 0x2b]
0x0000C31C: a8fd                     test     al, 0xfd
0x0000C31E: 7424                     je       0x18000c344
0x0000C320: 80fa43                   cmp      dl, 0x43
0x0000C323: 0f8e3c010000             jle      0x18000c465
0x0000C329: 80fa45                   cmp      dl, 0x45
0x0000C32C: 7e0c                     jle      0x18000c33a
0x0000C32E: 80ea64                   sub      dl, 0x64
0x0000C331: 413ad1                   cmp      dl, r9b
0x0000C334: 0f872b010000             ja       0x18000c465
0x0000C33A: b906000000               mov      ecx, 6
0x0000C33F: e949ffffff               jmp      0x18000c28d
0x0000C344: 4d2bc1                   sub      r8, r9
0x0000C347: b90b000000               mov      ecx, 0xb
0x0000C34C: e93cffffff               jmp      0x18000c28d
0x0000C351: 41b901000000             mov      r9d, 1
0x0000C357: b030                     mov      al, 0x30
0x0000C359: 458bf9                   mov      r15d, r9d
0x0000C35C: eb21                     jmp      0x18000c37f
0x0000C35E: 80fa39                   cmp      dl, 0x39
0x0000C361: 7f20                     jg       0x18000c383
0x0000C363: 4183fb19                 cmp      r11d, 0x19
0x0000C367: 730d                     jae      0x18000c376
0x0000C369: 2ad0                     sub      dl, al
0x0000C36B: 4503d9                   add      r11d, r9d
0x0000C36E: 418812                   mov      byte ptr [r10], dl
0x0000C371: 4d03d1                   add      r10, r9
0x0000C374: eb03                     jmp      0x18000c379
0x0000C376: 4103f1                   add      esi, r9d
0x0000C379: 418a10                   mov      dl, byte ptr [r8]
0x0000C37C: 4d03c1                   add      r8, r9
0x0000C37F: 3ad0                     cmp      dl, al
0x0000C381: 7ddb                     jge      0x18000c35e
0x0000C383: 498b06                   mov      rax, qword ptr [r14]
0x0000C386: 488b88f0000000           mov      rcx, qword ptr [rax + 0xf0]
0x0000C38D: 488b01                   mov      rax, qword ptr [rcx]
0x0000C390: 3a10                     cmp      dl, byte ptr [rax]
0x0000C392: 7585                     jne      0x18000c319
0x0000C394: b904000000               mov      ecx, 4
0x0000C399: e9effeffff               jmp      0x18000c28d
0x0000C39E: 8d42cf                   lea      eax, [rdx - 0x31]
0x0000C3A1: 3c08                     cmp      al, 8
0x0000C3A3: 7713                     ja       0x18000c3b8
0x0000C3A5: b903000000               mov      ecx, 3
0x0000C3AA: 41b901000000             mov      r9d, 1
0x0000C3B0: 4d2bc1                   sub      r8, r9
0x0000C3B3: e9d5feffff               jmp      0x18000c28d
0x0000C3B8: 498b06                   mov      rax, qword ptr [r14]
0x0000C3BB: 488b88f0000000           mov      rcx, qword ptr [rax + 0xf0]
0x0000C3C2: 488b01                   mov      rax, qword ptr [rcx]
0x0000C3C5: 3a10                     cmp      dl, byte ptr [rax]
0x0000C3C7: 7510                     jne      0x18000c3d9
0x0000C3C9: b905000000               mov      ecx, 5
0x0000C3CE: 41b901000000             mov      r9d, 1
0x0000C3D4: e9b4feffff               jmp      0x18000c28d
0x0000C3D9: 80fa30                   cmp      dl, 0x30
0x0000C3DC: 0f85f2010000             jne      0x18000c5d4
0x0000C3E2: 41b901000000             mov      r9d, 1
0x0000C3E8: 418bc9                   mov      ecx, r9d
0x0000C3EB: e99dfeffff               jmp      0x18000c28d
0x0000C3F0: 8d42cf                   lea      eax, [rdx - 0x31]
0x0000C3F3: 41b901000000             mov      r9d, 1
0x0000C3F9: 458bf9                   mov      r15d, r9d
0x0000C3FC: 3c08                     cmp      al, 8
0x0000C3FE: 7706                     ja       0x18000c406
0x0000C400: 418d4902                 lea      ecx, [r9 + 2]
0x0000C404: ebaa                     jmp      0x18000c3b0
0x0000C406: 498b06                   mov      rax, qword ptr [r14]
0x0000C409: 488b88f0000000           mov      rcx, qword ptr [rax + 0xf0]
0x0000C410: 488b01                   mov      rax, qword ptr [rcx]
0x0000C413: 3a10                     cmp      dl, byte ptr [rax]
0x0000C415: 0f8479ffffff             je       0x18000c394
0x0000C41B: 8d42d5                   lea      eax, [rdx - 0x2b]
0x0000C41E: a8fd                     test     al, 0xfd
0x0000C420: 0f841effffff             je       0x18000c344
0x0000C426: 80fa30                   cmp      dl, 0x30
0x0000C429: 74bd                     je       0x18000c3e8
0x0000C42B: e9f0feffff               jmp      0x18000c320
0x0000C430: 8d42cf                   lea      eax, [rdx - 0x31]
0x0000C433: 3c08                     cmp      al, 8
0x0000C435: 0f866affffff             jbe      0x18000c3a5
0x0000C43B: 498b06                   mov      rax, qword ptr [r14]
0x0000C43E: 488b88f0000000           mov      rcx, qword ptr [rax + 0xf0]
0x0000C445: 488b01                   mov      rax, qword ptr [rcx]
0x0000C448: 3a10                     cmp      dl, byte ptr [rax]
0x0000C44A: 0f8479ffffff             je       0x18000c3c9
0x0000C450: 80fa2b                   cmp      dl, 0x2b
0x0000C453: 7429                     je       0x18000c47e
0x0000C455: 80fa2d                   cmp      dl, 0x2d
0x0000C458: 7413                     je       0x18000c46d
0x0000C45A: 80fa30                   cmp      dl, 0x30
0x0000C45D: 7483                     je       0x18000c3e2
0x0000C45F: 41b901000000             mov      r9d, 1
0x0000C465: 4d2bc1                   sub      r8, r9
0x0000C468: e970010000               jmp      0x18000c5dd
0x0000C46D: b902000000               mov      ecx, 2
0x0000C472: c7458f00800000           mov      dword ptr [rbp - 0x71], 0x8000
0x0000C479: e950ffffff               jmp      0x18000c3ce
0x0000C47E: b902000000               mov      ecx, 2
0x0000C483: 66895d8f                 mov      word ptr [rbp - 0x71], bx
0x0000C487: e942ffffff               jmp      0x18000c3ce
0x0000C48C: 80ea30                   sub      dl, 0x30
0x0000C48F: 44894d87                 mov      dword ptr [rbp - 0x79], r9d
0x0000C493: 80fa09                   cmp      dl, 9
0x0000C496: 0f87d9000000             ja       0x18000c575
0x0000C49C: b904000000               mov      ecx, 4
0x0000C4A1: e90affffff               jmp      0x18000c3b0
0x0000C4A6: 448bc9                   mov      r9d, ecx
0x0000C4A9: 4183e906                 sub      r9d, 6
0x0000C4AD: 0f849c000000             je       0x18000c54f
0x0000C4B3: 41ffc9                   dec      r9d
0x0000C4B6: 7473                     je       0x18000c52b
0x0000C4B8: 41ffc9                   dec      r9d
0x0000C4BB: 7442                     je       0x18000c4ff
0x0000C4BD: 41ffc9                   dec      r9d
0x0000C4C0: 0f84b4000000             je       0x18000c57a
0x0000C4C6: 4183f902                 cmp      r9d, 2
0x0000C4CA: 0f859b000000             jne      0x18000c56b
0x0000C4D0: 395d77                   cmp      dword ptr [rbp + 0x77], ebx
0x0000C4D3: 748a                     je       0x18000c45f
0x0000C4D5: 498d78ff                 lea      rdi, [r8 - 1]
0x0000C4D9: 80fa2b                   cmp      dl, 0x2b
0x0000C4DC: 7417                     je       0x18000c4f5
0x0000C4DE: 80fa2d                   cmp      dl, 0x2d
0x0000C4E1: 0f85ed000000             jne      0x18000c5d4
0x0000C4E7: 834d8bff                 or       dword ptr [rbp - 0x75], 0xffffffff
0x0000C4EB: b907000000               mov      ecx, 7
0x0000C4F0: e9d9feffff               jmp      0x18000c3ce
0x0000C4F5: b907000000               mov      ecx, 7
0x0000C4FA: e9cffeffff               jmp      0x18000c3ce
0x0000C4FF: 41b901000000             mov      r9d, 1
0x0000C505: 458be1                   mov      r12d, r9d
0x0000C508: eb06                     jmp      0x18000c510
0x0000C50A: 418a10                   mov      dl, byte ptr [r8]
0x0000C50D: 4d03c1                   add      r8, r9
0x0000C510: 80fa30                   cmp      dl, 0x30
0x0000C513: 74f5                     je       0x18000c50a
0x0000C515: 80ea31                   sub      dl, 0x31
0x0000C518: 80fa08                   cmp      dl, 8
0x0000C51B: 0f8744ffffff             ja       0x18000c465
0x0000C521: b909000000               mov      ecx, 9
0x0000C526: e985feffff               jmp      0x18000c3b0
0x0000C52B: 8d42cf                   lea      eax, [rdx - 0x31]
0x0000C52E: 3c08                     cmp      al, 8
0x0000C530: 770a                     ja       0x18000c53c
0x0000C532: b909000000               mov      ecx, 9
0x0000C537: e96efeffff               jmp      0x18000c3aa
0x0000C53C: 80fa30                   cmp      dl, 0x30
0x0000C53F: 0f858f000000             jne      0x18000c5d4
0x0000C545: b908000000               mov      ecx, 8
0x0000C54A: e97ffeffff               jmp      0x18000c3ce
0x0000C54F: 8d42cf                   lea      eax, [rdx - 0x31]
0x0000C552: 498d78fe                 lea      rdi, [r8 - 2]
0x0000C556: 3c08                     cmp      al, 8
0x0000C558: 76d8                     jbe      0x18000c532
0x0000C55A: 80fa2b                   cmp      dl, 0x2b
0x0000C55D: 7407                     je       0x18000c566
0x0000C55F: 80fa2d                   cmp      dl, 0x2d
0x0000C562: 7483                     je       0x18000c4e7
0x0000C564: ebd6                     jmp      0x18000c53c
0x0000C566: b907000000               mov      ecx, 7
0x0000C56B: 83f90a                   cmp      ecx, 0xa
0x0000C56E: 7467                     je       0x18000c5d7
0x0000C570: e959feffff               jmp      0x18000c3ce
0x0000C575: 4c8bc7                   mov      r8, rdi
0x0000C578: eb63                     jmp      0x18000c5dd
0x0000C57A: 41b901000000             mov      r9d, 1
0x0000C580: 40b730                   mov      dil, 0x30
0x0000C583: 458be1                   mov      r12d, r9d
0x0000C586: eb24                     jmp      0x18000c5ac
0x0000C588: 80fa39                   cmp      dl, 0x39
0x0000C58B: 7f3d                     jg       0x18000c5ca
0x0000C58D: 478d6cad00               lea      r13d, [r13 + r13*4]
0x0000C592: 0fbec2                   movsx    eax, dl
0x0000C595: 458d6de8                 lea      r13d, [r13 - 0x18]
0x0000C599: 468d2c68                 lea      r13d, [rax + r13*2]
0x0000C59D: 4181fd50140000           cmp      r13d, 0x1450
0x0000C5A4: 7f0d                     jg       0x18000c5b3
0x0000C5A6: 418a10                   mov      dl, byte ptr [r8]
0x0000C5A9: 4d03c1                   add      r8, r9
0x0000C5AC: 403ad7                   cmp      dl, dil
0x0000C5AF: 7dd7                     jge      0x18000c588
0x0000C5B1: eb17                     jmp      0x18000c5ca
0x0000C5B3: 41bd51140000             mov      r13d, 0x1451
0x0000C5B9: eb0f                     jmp      0x18000c5ca
0x0000C5BB: 80fa39                   cmp      dl, 0x39
0x0000C5BE: 0f8fa1feffff             jg       0x18000c465
0x0000C5C4: 418a10                   mov      dl, byte ptr [r8]
0x0000C5C7: 4d03c1                   add      r8, r9
0x0000C5CA: 403ad7                   cmp      dl, dil
0x0000C5CD: 7dec                     jge      0x18000c5bb
0x0000C5CF: e991feffff               jmp      0x18000c465
0x0000C5D4: 4c8bc7                   mov      r8, rdi
0x0000C5D7: 41b901000000             mov      r9d, 1
0x0000C5DD: 488b4597                 mov      rax, qword ptr [rbp - 0x69]
0x0000C5E1: 4c8900                   mov      qword ptr [rax], r8
0x0000C5E4: 4585ff                   test     r15d, r15d
0x0000C5E7: 0f8413040000             je       0x18000ca00
0x0000C5ED: 4183fb18                 cmp      r11d, 0x18
0x0000C5F1: 7619                     jbe      0x18000c60c
0x0000C5F3: 8a45f6                   mov      al, byte ptr [rbp - 0xa]
0x0000C5F6: 3c05                     cmp      al, 5
0x0000C5F8: 7c06                     jl       0x18000c600
0x0000C5FA: 4102c1                   add      al, r9b
0x0000C5FD: 8845f6                   mov      byte ptr [rbp - 0xa], al
0x0000C600: 4d2bd1                   sub      r10, r9
0x0000C603: 41bb18000000             mov      r11d, 0x18
0x0000C609: 4103f1                   add      esi, r9d
0x0000C60C: 4585db                   test     r11d, r11d
0x0000C60F: 7515                     jne      0x18000c626
0x0000C611: 0fb7d3                   movzx    edx, bx
0x0000C614: 0fb7c3                   movzx    eax, bx
0x0000C617: 8bfb                     mov      edi, ebx
0x0000C619: 8bcb                     mov      ecx, ebx
0x0000C61B: e9ef030000               jmp      0x18000ca0f
0x0000C620: 41ffcb                   dec      r11d
0x0000C623: 4103f1                   add      esi, r9d
0x0000C626: 4d2bd1                   sub      r10, r9
0x0000C629: 41381a                   cmp      byte ptr [r10], bl
0x0000C62C: 74f2                     je       0x18000c620
0x0000C62E: 4c8d45bf                 lea      r8, [rbp - 0x41]
0x0000C632: 488d4ddf                 lea      rcx, [rbp - 0x21]
0x0000C636: 418bd3                   mov      edx, r11d
0x0000C639: e8aa120000               call     0x18000d8e8
0x0000C63E: 395d8b                   cmp      dword ptr [rbp - 0x75], ebx
0x0000C641: 7d03                     jge      0x18000c646
0x0000C643: 41f7dd                   neg      r13d
0x0000C646: 4403ee                   add      r13d, esi
0x0000C649: 4585e4                   test     r12d, r12d
0x0000C64C: 7504                     jne      0x18000c652
0x0000C64E: 44036d67                 add      r13d, dword ptr [rbp + 0x67]
0x0000C652: 395d87                   cmp      dword ptr [rbp - 0x79], ebx
0x0000C655: 7504                     jne      0x18000c65b
0x0000C657: 442b6d6f                 sub      r13d, dword ptr [rbp + 0x6f]
0x0000C65B: 4181fd50140000           cmp      r13d, 0x1450
0x0000C662: 0f8f82030000             jg       0x18000c9ea
0x0000C668: 4181fdb0ebffff           cmp      r13d, 0xffffebb0
0x0000C66F: 0f8c65030000             jl       0x18000c9da
0x0000C675: 488d35c4bd0000           lea      rsi, [rip + 0xbdc4]
0x0000C67C: 4883ee60                 sub      rsi, 0x60
0x0000C680: 4585ed                   test     r13d, r13d
0x0000C683: 0f843f030000             je       0x18000c9c8
0x0000C689: 790e                     jns      0x18000c699
0x0000C68B: 488d350ebf0000           lea      rsi, [rip + 0xbf0e]
0x0000C692: 41f7dd                   neg      r13d
0x0000C695: 4883ee60                 sub      rsi, 0x60
0x0000C699: 395d93                   cmp      dword ptr [rbp - 0x6d], ebx
0x0000C69C: 7504                     jne      0x18000c6a2
0x0000C69E: 66895dbf                 mov      word ptr [rbp - 0x41], bx
0x0000C6A2: 4585ed                   test     r13d, r13d
0x0000C6A5: 0f841d030000             je       0x18000c9c8
0x0000C6AB: bf00000080               mov      edi, 0x80000000
0x0000C6B0: 41b9ff7f0000             mov      r9d, 0x7fff
0x0000C6B6: 418bc5                   mov      eax, r13d
0x0000C6B9: 4883c654                 add      rsi, 0x54
0x0000C6BD: 41c1fd03                 sar      r13d, 3
0x0000C6C1: 4889759f                 mov      qword ptr [rbp - 0x61], rsi
0x0000C6C5: 83e007                   and      eax, 7
0x0000C6C8: 0f84f1020000             je       0x18000c9bf
0x0000C6CE: 4898                     cdqe     
0x0000C6D0: 41bb00800000             mov      r11d, 0x8000
0x0000C6D6: 41be01000000             mov      r14d, 1
0x0000C6DC: 488d0c40                 lea      rcx, [rax + rax*2]
0x0000C6E0: 488d148e                 lea      rdx, [rsi + rcx*4]
0x0000C6E4: 48895597                 mov      qword ptr [rbp - 0x69], rdx
0x0000C6E8: 6644391a                 cmp      word ptr [rdx], r11w
0x0000C6EC: 7225                     jb       0x18000c713
0x0000C6EE: 8b4208                   mov      eax, dword ptr [rdx + 8]
0x0000C6F1: f20f1002                 movsd    xmm0, qword ptr [rdx]
0x0000C6F5: 488d55cf                 lea      rdx, [rbp - 0x31]
0x0000C6F9: 8945d7                   mov      dword ptr [rbp - 0x29], eax
0x0000C6FC: f20f1145cf               movsd    qword ptr [rbp - 0x31], xmm0
0x0000C701: 488b45cf                 mov      rax, qword ptr [rbp - 0x31]
0x0000C705: 48c1e810                 shr      rax, 0x10
0x0000C709: 48895597                 mov      qword ptr [rbp - 0x69], rdx
0x0000C70D: 412bc6                   sub      eax, r14d
0x0000C710: 8945d1                   mov      dword ptr [rbp - 0x2f], eax
0x0000C713: 0fb7420a                 movzx    eax, word ptr [rdx + 0xa]
0x0000C717: 0fb74dc9                 movzx    ecx, word ptr [rbp - 0x37]
0x0000C71B: 48895daf                 mov      qword ptr [rbp - 0x51], rbx
0x0000C71F: 440fb7e0                 movzx    r12d, ax
0x0000C723: 664123c1                 and      ax, r9w
0x0000C727: 895db7                   mov      dword ptr [rbp - 0x49], ebx
0x0000C72A: 664433e1                 xor      r12w, cx
0x0000C72E: 664123c9                 and      cx, r9w
0x0000C732: 664523e3                 and      r12w, r11w
0x0000C736: 448d0401                 lea      r8d, [rcx + rax]
0x0000C73A: 66413bc9                 cmp      cx, r9w
0x0000C73E: 0f8367020000             jae      0x18000c9ab
0x0000C744: 66413bc1                 cmp      ax, r9w
0x0000C748: 0f835d020000             jae      0x18000c9ab
0x0000C74E: 41bafdbf0000             mov      r10d, 0xbffd
0x0000C754: 66453bc2                 cmp      r8w, r10w
0x0000C758: 0f874d020000             ja       0x18000c9ab
0x0000C75E: 41babf3f0000             mov      r10d, 0x3fbf
0x0000C764: 66453bc2                 cmp      r8w, r10w
0x0000C768: 770c                     ja       0x18000c776
0x0000C76A: 48895dc3                 mov      qword ptr [rbp - 0x3d], rbx
0x0000C76E: 895dbf                   mov      dword ptr [rbp - 0x41], ebx
0x0000C771: e949020000               jmp      0x18000c9bf
0x0000C776: 6685c9                   test     cx, cx
0x0000C779: 7520                     jne      0x18000c79b
0x0000C77B: 664503c6                 add      r8w, r14w
0x0000C77F: f745c7ffffff7f           test     dword ptr [rbp - 0x39], 0x7fffffff
0x0000C786: 7513                     jne      0x18000c79b
0x0000C788: 395dc3                   cmp      dword ptr [rbp - 0x3d], ebx
0x0000C78B: 750e                     jne      0x18000c79b
0x0000C78D: 395dbf                   cmp      dword ptr [rbp - 0x41], ebx
0x0000C790: 7509                     jne      0x18000c79b
0x0000C792: 66895dc9                 mov      word ptr [rbp - 0x37], bx
0x0000C796: e924020000               jmp      0x18000c9bf
0x0000C79B: 6685c0                   test     ax, ax
0x0000C79E: 7516                     jne      0x18000c7b6
0x0000C7A0: 664503c6                 add      r8w, r14w
0x0000C7A4: f74208ffffff7f           test     dword ptr [rdx + 8], 0x7fffffff
0x0000C7AB: 7509                     jne      0x18000c7b6
0x0000C7AD: 395a04                   cmp      dword ptr [rdx + 4], ebx
0x0000C7B0: 7504                     jne      0x18000c7b6
0x0000C7B2: 391a                     cmp      dword ptr [rdx], ebx
0x0000C7B4: 74b4                     je       0x18000c76a
0x0000C7B6: 448bfb                   mov      r15d, ebx
0x0000C7B9: 4c8d4daf                 lea      r9, [rbp - 0x51]
0x0000C7BD: 41ba05000000             mov      r10d, 5
0x0000C7C3: 44895587                 mov      dword ptr [rbp - 0x79], r10d
0x0000C7C7: 4585d2                   test     r10d, r10d
0x0000C7CA: 7e6c                     jle      0x18000c838
0x0000C7CC: 438d043f                 lea      eax, [r15 + r15]
0x0000C7D0: 488d7dbf                 lea      rdi, [rbp - 0x41]
0x0000C7D4: 488d7208                 lea      rsi, [rdx + 8]
0x0000C7D8: 4863c8                   movsxd   rcx, eax
0x0000C7DB: 418bc7                   mov      eax, r15d
0x0000C7DE: 4123c6                   and      eax, r14d
0x0000C7E1: 4803f9                   add      rdi, rcx
0x0000C7E4: 8bd0                     mov      edx, eax
0x0000C7E6: 0fb707                   movzx    eax, word ptr [rdi]
0x0000C7E9: 0fb70e                   movzx    ecx, word ptr [rsi]
0x0000C7EC: 448bdb                   mov      r11d, ebx
0x0000C7EF: 0fafc8                   imul     ecx, eax
0x0000C7F2: 418b01                   mov      eax, dword ptr [r9]
0x0000C7F5: 448d3408                 lea      r14d, [rax + rcx]
0x0000C7F9: 443bf0                   cmp      r14d, eax
0x0000C7FC: 7205                     jb       0x18000c803
0x0000C7FE: 443bf1                   cmp      r14d, ecx
0x0000C801: 7306                     jae      0x18000c809
0x0000C803: 41bb01000000             mov      r11d, 1
0x0000C809: 458931                   mov      dword ptr [r9], r14d
0x0000C80C: 41be01000000             mov      r14d, 1
0x0000C812: 4585db                   test     r11d, r11d
0x0000C815: 7405                     je       0x18000c81c
0x0000C817: 6645017104               add      word ptr [r9 + 4], r14w
0x0000C81C: 448b5d87                 mov      r11d, dword ptr [rbp - 0x79]
0x0000C820: 4883c702                 add      rdi, 2
0x0000C824: 4883ee02                 sub      rsi, 2
0x0000C828: 452bde                   sub      r11d, r14d
0x0000C82B: 44895d87                 mov      dword ptr [rbp - 0x79], r11d
0x0000C82F: 4585db                   test     r11d, r11d
0x0000C832: 7fb2                     jg       0x18000c7e6
0x0000C834: 488b5597                 mov      rdx, qword ptr [rbp - 0x69]
0x0000C838: 452bd6                   sub      r10d, r14d
0x0000C83B: 4983c102                 add      r9, 2
0x0000C83F: 4503fe                   add      r15d, r14d
0x0000C842: 4585d2                   test     r10d, r10d
0x0000C845: 0f8f78ffffff             jg       0x18000c7c3
0x0000C84B: 448b55b7                 mov      r10d, dword ptr [rbp - 0x49]
0x0000C84F: 448b4daf                 mov      r9d, dword ptr [rbp - 0x51]
0x0000C853: b802c00000               mov      eax, 0xc002
0x0000C858: 664403c0                 add      r8w, ax
0x0000C85C: bf00000080               mov      edi, 0x80000000
0x0000C861: 41bfffff0000             mov      r15d, 0xffff
0x0000C867: 664585c0                 test     r8w, r8w
0x0000C86B: 7e3f                     jle      0x18000c8ac
0x0000C86D: 4485d7                   test     edi, r10d
0x0000C870: 7534                     jne      0x18000c8a6
0x0000C872: 448b5db3                 mov      r11d, dword ptr [rbp - 0x4d]
0x0000C876: 418bd1                   mov      edx, r9d
0x0000C879: 4503d2                   add      r10d, r10d
0x0000C87C: c1ea1f                   shr      edx, 0x1f
0x0000C87F: 4503c9                   add      r9d, r9d
0x0000C882: 418bcb                   mov      ecx, r11d
0x0000C885: c1e91f                   shr      ecx, 0x1f
0x0000C888: 438d041b                 lea      eax, [r11 + r11]
0x0000C88C: 664503c7                 add      r8w, r15w
0x0000C890: 0bc2                     or       eax, edx
0x0000C892: 440bd1                   or       r10d, ecx
0x0000C895: 44894daf                 mov      dword ptr [rbp - 0x51], r9d
0x0000C899: 8945b3                   mov      dword ptr [rbp - 0x4d], eax
0x0000C89C: 448955b7                 mov      dword ptr [rbp - 0x49], r10d
0x0000C8A0: 664585c0                 test     r8w, r8w
0x0000C8A4: 7fc7                     jg       0x18000c86d
0x0000C8A6: 664585c0                 test     r8w, r8w
0x0000C8AA: 7f6a                     jg       0x18000c916
0x0000C8AC: 664503c7                 add      r8w, r15w
0x0000C8B0: 7964                     jns      0x18000c916
0x0000C8B2: 410fb7c0                 movzx    eax, r8w
0x0000C8B6: 8bfb                     mov      edi, ebx
0x0000C8B8: 66f7d8                   neg      ax
0x0000C8BB: 0fb7d0                   movzx    edx, ax
0x0000C8BE: 664403c2                 add      r8w, dx
0x0000C8C2: 448475af                 test     byte ptr [rbp - 0x51], r14b
0x0000C8C6: 7403                     je       0x18000c8cb
0x0000C8C8: 4103fe                   add      edi, r14d
0x0000C8CB: 448b5db3                 mov      r11d, dword ptr [rbp - 0x4d]
0x0000C8CF: 418bc2                   mov      eax, r10d
0x0000C8D2: 41d1e9                   shr      r9d, 1
0x0000C8D5: 418bcb                   mov      ecx, r11d
0x0000C8D8: c1e01f                   shl      eax, 0x1f
0x0000C8DB: 41d1eb                   shr      r11d, 1
0x0000C8DE: c1e11f                   shl      ecx, 0x1f
0x0000C8E1: 440bd8                   or       r11d, eax
0x0000C8E4: 41d1ea                   shr      r10d, 1
0x0000C8E7: 440bc9                   or       r9d, ecx
0x0000C8EA: 44895db3                 mov      dword ptr [rbp - 0x4d], r11d
0x0000C8EE: 44894daf                 mov      dword ptr [rbp - 0x51], r9d
0x0000C8F2: 492bd6                   sub      rdx, r14
0x0000C8F5: 75cb                     jne      0x18000c8c2
0x0000C8F7: 85ff                     test     edi, edi
0x0000C8F9: 448955b7                 mov      dword ptr [rbp - 0x49], r10d
0x0000C8FD: bf00000080               mov      edi, 0x80000000
0x0000C902: 7412                     je       0x18000c916
0x0000C904: 410fb7c1                 movzx    eax, r9w
0x0000C908: 66410bc6                 or       ax, r14w
0x0000C90C: 668945af                 mov      word ptr [rbp - 0x51], ax
0x0000C910: 448b4daf                 mov      r9d, dword ptr [rbp - 0x51]
0x0000C914: eb04                     jmp      0x18000c91a
0x0000C916: 0fb745af                 movzx    eax, word ptr [rbp - 0x51]
0x0000C91A: 488b759f                 mov      rsi, qword ptr [rbp - 0x61]
0x0000C91E: 41bb00800000             mov      r11d, 0x8000
0x0000C924: 66413bc3                 cmp      ax, r11w
0x0000C928: 7710                     ja       0x18000c93a
0x0000C92A: 4181e1ffff0100           and      r9d, 0x1ffff
0x0000C931: 4181f900800100           cmp      r9d, 0x18000
0x0000C938: 7548                     jne      0x18000c982
0x0000C93A: 8b45b1                   mov      eax, dword ptr [rbp - 0x4f]
0x0000C93D: 83c9ff                   or       ecx, 0xffffffff
0x0000C940: 3bc1                     cmp      eax, ecx
0x0000C942: 7538                     jne      0x18000c97c
0x0000C944: 8b45b5                   mov      eax, dword ptr [rbp - 0x4b]
0x0000C947: 895db1                   mov      dword ptr [rbp - 0x4f], ebx
0x0000C94A: 3bc1                     cmp      eax, ecx
0x0000C94C: 7522                     jne      0x18000c970
0x0000C94E: 0fb745b9                 movzx    eax, word ptr [rbp - 0x47]
0x0000C952: 895db5                   mov      dword ptr [rbp - 0x4b], ebx
0x0000C955: 66413bc7                 cmp      ax, r15w
0x0000C959: 750b                     jne      0x18000c966
0x0000C95B: 6644895db9               mov      word ptr [rbp - 0x47], r11w
0x0000C960: 664503c6                 add      r8w, r14w
0x0000C964: eb10                     jmp      0x18000c976
0x0000C966: 664103c6                 add      ax, r14w
0x0000C96A: 668945b9                 mov      word ptr [rbp - 0x47], ax
0x0000C96E: eb06                     jmp      0x18000c976
0x0000C970: 4103c6                   add      eax, r14d
0x0000C973: 8945b5                   mov      dword ptr [rbp - 0x4b], eax
0x0000C976: 448b55b7                 mov      r10d, dword ptr [rbp - 0x49]
0x0000C97A: eb06                     jmp      0x18000c982
0x0000C97C: 4103c6                   add      eax, r14d
0x0000C97F: 8945b1                   mov      dword ptr [rbp - 0x4f], eax
0x0000C982: 41b9ff7f0000             mov      r9d, 0x7fff
0x0000C988: 66453bc1                 cmp      r8w, r9w
0x0000C98C: 731d                     jae      0x18000c9ab
0x0000C98E: 0fb745b1                 movzx    eax, word ptr [rbp - 0x4f]
0x0000C992: 66450bc4                 or       r8w, r12w
0x0000C996: 448955c5                 mov      dword ptr [rbp - 0x3b], r10d
0x0000C99A: 668945bf                 mov      word ptr [rbp - 0x41], ax
0x0000C99E: 8b45b3                   mov      eax, dword ptr [rbp - 0x4d]
0x0000C9A1: 66448945c9               mov      word ptr [rbp - 0x37], r8w
0x0000C9A6: 8945c1                   mov      dword ptr [rbp - 0x3f], eax
0x0000C9A9: eb14                     jmp      0x18000c9bf
0x0000C9AB: 6641f7dc                 neg      r12w
0x0000C9AF: 48895dbf                 mov      qword ptr [rbp - 0x41], rbx
0x0000C9B3: 1bc0                     sbb      eax, eax
0x0000C9B5: 23c7                     and      eax, edi
0x0000C9B7: 050080ff7f               add      eax, 0x7fff8000
0x0000C9BC: 8945c7                   mov      dword ptr [rbp - 0x39], eax
0x0000C9BF: 4585ed                   test     r13d, r13d
0x0000C9C2: 0f85eefcffff             jne      0x18000c6b6
0x0000C9C8: 8b45c7                   mov      eax, dword ptr [rbp - 0x39]
0x0000C9CB: 0fb755bf                 movzx    edx, word ptr [rbp - 0x41]
0x0000C9CF: 8b4dc1                   mov      ecx, dword ptr [rbp - 0x3f]
0x0000C9D2: 8b7dc5                   mov      edi, dword ptr [rbp - 0x3b]
0x0000C9D5: c1e810                   shr      eax, 0x10
0x0000C9D8: eb35                     jmp      0x18000ca0f
0x0000C9DA: 8bd3                     mov      edx, ebx
0x0000C9DC: 0fb7c3                   movzx    eax, bx
0x0000C9DF: 8bfb                     mov      edi, ebx
0x0000C9E1: 8bcb                     mov      ecx, ebx
0x0000C9E3: bb01000000               mov      ebx, 1
0x0000C9E8: eb25                     jmp      0x18000ca0f
0x0000C9EA: 8bcb                     mov      ecx, ebx
0x0000C9EC: 0fb7d3                   movzx    edx, bx
0x0000C9EF: b8ff7f0000               mov      eax, 0x7fff
0x0000C9F4: bb02000000               mov      ebx, 2
0x0000C9F9: bf00000080               mov      edi, 0x80000000
0x0000C9FE: eb0f                     jmp      0x18000ca0f
0x0000CA00: 0fb7d3                   movzx    edx, bx
0x0000CA03: 0fb7c3                   movzx    eax, bx
0x0000CA06: 8bfb                     mov      edi, ebx
0x0000CA08: 8bcb                     mov      ecx, ebx
0x0000CA0A: bb04000000               mov      ebx, 4
0x0000CA0F: 4c8b45a7                 mov      r8, qword ptr [rbp - 0x59]
0x0000CA13: 660b458f                 or       ax, word ptr [rbp - 0x71]
0x0000CA17: 664189400a               mov      word ptr [r8 + 0xa], ax
0x0000CA1C: 8bc3                     mov      eax, ebx
0x0000CA1E: 66418910                 mov      word ptr [r8], dx
0x0000CA22: 41894802                 mov      dword ptr [r8 + 2], ecx
0x0000CA26: 41897806                 mov      dword ptr [r8 + 6], edi
0x0000CA2A: 488b4dff                 mov      rcx, qword ptr [rbp - 1]
0x0000CA2E: 4833cc                   xor      rcx, rsp
0x0000CA31: e8da4dffff               call     0x180001810
0x0000CA36: 488b9c24f0000000         mov      rbx, qword ptr [rsp + 0xf0]
0x0000CA3E: 4881c4a0000000           add      rsp, 0xa0
0x0000CA45: 415f                     pop      r15
0x0000CA47: 415e                     pop      r14
0x0000CA49: 415d                     pop      r13
0x0000CA4B: 415c                     pop      r12
0x0000CA4D: 5f                       pop      rdi
0x0000CA4E: 5e                       pop      rsi
0x0000CA4F: 5d                       pop      rbp
0x0000CA50: c3                       ret      
0x0000CA51: cc                       int3     
0x0000CA52: cc                       int3     
0x0000CA53: cc                       int3     
0x0000CA54: 4883ec48                 sub      rsp, 0x48
0x0000CA58: 8b442478                 mov      eax, dword ptr [rsp + 0x78]
0x0000CA5C: 488364243000             and      qword ptr [rsp + 0x30], 0
0x0000CA62: 89442428                 mov      dword ptr [rsp + 0x28], eax
0x0000CA66: 8b442470                 mov      eax, dword ptr [rsp + 0x70]
0x0000CA6A: 89442420                 mov      dword ptr [rsp + 0x20], eax
0x0000CA6E: e805000000               call     0x18000ca78
0x0000CA73: 4883c448                 add      rsp, 0x48
0x0000CA77: c3                       ret      
0x0000CA78: 4883ec38                 sub      rsp, 0x38
0x0000CA7C: 418d41bb                 lea      eax, [r9 - 0x45]
0x0000CA80: 41badfffffff             mov      r10d, 0xffffffdf
0x0000CA86: 4185c2                   test     r10d, eax
0x0000CA89: 744a                     je       0x18000cad5
0x0000CA8B: 4183f966                 cmp      r9d, 0x66
0x0000CA8F: 7516                     jne      0x18000caa7
0x0000CA91: 488b442470               mov      rax, qword ptr [rsp + 0x70]
0x0000CA96: 448b4c2460               mov      r9d, dword ptr [rsp + 0x60]
0x0000CA9B: 4889442420               mov      qword ptr [rsp + 0x20], rax
0x0000CAA0: e85b080000               call     0x18000d300
0x0000CAA5: eb4a                     jmp      0x18000caf1
0x0000CAA7: 418d41bf                 lea      eax, [r9 - 0x41]
0x0000CAAB: 448b4c2460               mov      r9d, dword ptr [rsp + 0x60]
0x0000CAB0: 4185c2                   test     r10d, eax
0x0000CAB3: 488b442470               mov      rax, qword ptr [rsp + 0x70]
0x0000CAB8: 4889442428               mov      qword ptr [rsp + 0x28], rax
0x0000CABD: 8b442468                 mov      eax, dword ptr [rsp + 0x68]
0x0000CAC1: 89442420                 mov      dword ptr [rsp + 0x20], eax
0x0000CAC5: 7407                     je       0x18000cace
0x0000CAC7: e808090000               call     0x18000d3d4
0x0000CACC: eb23                     jmp      0x18000caf1
0x0000CACE: e825000000               call     0x18000caf8
0x0000CAD3: eb1c                     jmp      0x18000caf1
0x0000CAD5: 488b442470               mov      rax, qword ptr [rsp + 0x70]
0x0000CADA: 448b4c2460               mov      r9d, dword ptr [rsp + 0x60]
0x0000CADF: 4889442428               mov      qword ptr [rsp + 0x28], rax
0x0000CAE4: 8b442468                 mov      eax, dword ptr [rsp + 0x68]
0x0000CAE8: 89442420                 mov      dword ptr [rsp + 0x20], eax
0x0000CAEC: e8b3050000               call     0x18000d0a4
0x0000CAF1: 4883c438                 add      rsp, 0x38
0x0000CAF5: c3                       ret      
0x0000CAF6: cc                       int3     
0x0000CAF7: cc                       int3     
0x0000CAF8: 488bc4                   mov      rax, rsp
0x0000CAFB: 48895808                 mov      qword ptr [rax + 8], rbx
0x0000CAFF: 48896810                 mov      qword ptr [rax + 0x10], rbp
0x0000CB03: 48897018                 mov      qword ptr [rax + 0x18], rsi
0x0000CB07: 57                       push     rdi
0x0000CB08: 4154                     push     r12
0x0000CB0A: 4155                     push     r13
0x0000CB0C: 4156                     push     r14
0x0000CB0E: 4157                     push     r15
0x0000CB10: 4883ec50                 sub      rsp, 0x50
0x0000CB14: 488bfa                   mov      rdi, rdx
0x0000CB17: 488b9424a8000000         mov      rdx, qword ptr [rsp + 0xa8]
0x0000CB1F: 4c8bf1                   mov      r14, rcx
0x0000CB22: 488d48b8                 lea      rcx, [rax - 0x48]
0x0000CB26: 41bf30000000             mov      r15d, 0x30
0x0000CB2C: 418bd9                   mov      ebx, r9d
0x0000CB2F: 498bf0                   mov      rsi, r8
0x0000CB32: 41bcff030000             mov      r12d, 0x3ff
0x0000CB38: 410fb7ef                 movzx    ebp, r15w
0x0000CB3C: e85795ffff               call     0x180006098
0x0000CB41: 4533c9                   xor      r9d, r9d
0x0000CB44: 85db                     test     ebx, ebx
0x0000CB46: 410f48d9                 cmovs    ebx, r9d
0x0000CB4A: 4885ff                   test     rdi, rdi
0x0000CB4D: 750c                     jne      0x18000cb5b
0x0000CB4F: e8385bffff               call     0x18000268c
0x0000CB54: bb16000000               mov      ebx, 0x16
0x0000CB59: eb1d                     jmp      0x18000cb78
0x0000CB5B: 4885f6                   test     rsi, rsi
0x0000CB5E: 74ef                     je       0x18000cb4f
0x0000CB60: 8d430b                   lea      eax, [rbx + 0xb]
0x0000CB63: 44880f                   mov      byte ptr [rdi], r9b
0x0000CB66: 4863c8                   movsxd   rcx, eax
0x0000CB69: 483bf1                   cmp      rsi, rcx
0x0000CB6C: 7719                     ja       0x18000cb87
0x0000CB6E: e8195bffff               call     0x18000268c
0x0000CB73: bb22000000               mov      ebx, 0x22
0x0000CB78: 8918                     mov      dword ptr [rax], ebx
0x0000CB7A: e8256dffff               call     0x1800038a4
0x0000CB7F: 4533c9                   xor      r9d, r9d
0x0000CB82: e9ee020000               jmp      0x18000ce75
0x0000CB87: 498b06                   mov      rax, qword ptr [r14]
0x0000CB8A: b9ff070000               mov      ecx, 0x7ff
0x0000CB8F: 48c1e834                 shr      rax, 0x34
0x0000CB93: 4823c1                   and      rax, rcx
0x0000CB96: 483bc1                   cmp      rax, rcx
0x0000CB99: 0f8592000000             jne      0x18000cc31
0x0000CB9F: 4c894c2428               mov      qword ptr [rsp + 0x28], r9
0x0000CBA4: 44894c2420               mov      dword ptr [rsp + 0x20], r9d
0x0000CBA9: 4c8d46fe                 lea      r8, [rsi - 2]
0x0000CBAD: 4883feff                 cmp      rsi, -1
0x0000CBB1: 488d5702                 lea      rdx, [rdi + 2]
0x0000CBB5: 448bcb                   mov      r9d, ebx
0x0000CBB8: 4c0f44c6                 cmove    r8, rsi
0x0000CBBC: 498bce                   mov      rcx, r14
0x0000CBBF: e8e0040000               call     0x18000d0a4
0x0000CBC4: 4533c9                   xor      r9d, r9d
0x0000CBC7: 8bd8                     mov      ebx, eax
0x0000CBC9: 85c0                     test     eax, eax
0x0000CBCB: 7408                     je       0x18000cbd5
0x0000CBCD: 44880f                   mov      byte ptr [rdi], r9b
0x0000CBD0: e9a0020000               jmp      0x18000ce75
0x0000CBD5: 807f022d                 cmp      byte ptr [rdi + 2], 0x2d
0x0000CBD9: be01000000               mov      esi, 1
0x0000CBDE: 7506                     jne      0x18000cbe6
0x0000CBE0: c6072d                   mov      byte ptr [rdi], 0x2d
0x0000CBE3: 4803fe                   add      rdi, rsi
0x0000CBE6: 8b9c24a0000000           mov      ebx, dword ptr [rsp + 0xa0]
0x0000CBED: 44883f                   mov      byte ptr [rdi], r15b
0x0000CBF0: ba65000000               mov      edx, 0x65
0x0000CBF5: 8bc3                     mov      eax, ebx
0x0000CBF7: f7d8                     neg      eax
0x0000CBF9: 1ac9                     sbb      cl, cl
0x0000CBFB: 80e1e0                   and      cl, 0xe0
0x0000CBFE: 80c178                   add      cl, 0x78
0x0000CC01: 880c37                   mov      byte ptr [rdi + rsi], cl
0x0000CC04: 488d4e01                 lea      rcx, [rsi + 1]
0x0000CC08: 4803cf                   add      rcx, rdi
0x0000CC0B: e8ec100000               call     0x18000dcfc
0x0000CC10: 4533c9                   xor      r9d, r9d
0x0000CC13: 4885c0                   test     rax, rax
0x0000CC16: 0f8456020000             je       0x18000ce72
0x0000CC1C: f7db                     neg      ebx
0x0000CC1E: 1ac9                     sbb      cl, cl
0x0000CC20: 80e1e0                   and      cl, 0xe0
0x0000CC23: 80c170                   add      cl, 0x70
0x0000CC26: 8808                     mov      byte ptr [rax], cl
0x0000CC28: 44884803                 mov      byte ptr [rax + 3], r9b
0x0000CC2C: e941020000               jmp      0x18000ce72
0x0000CC31: 48b80000000000000080     movabs   rax, 0x8000000000000000
0x0000CC3B: be01000000               mov      esi, 1
0x0000CC40: 498506                   test     qword ptr [r14], rax
0x0000CC43: 7406                     je       0x18000cc4b
0x0000CC45: c6072d                   mov      byte ptr [rdi], 0x2d
0x0000CC48: 4803fe                   add      rdi, rsi
0x0000CC4B: 448bac24a0000000         mov      r13d, dword ptr [rsp + 0xa0]
0x0000CC53: 458bd7                   mov      r10d, r15d
0x0000CC56: 49bbffffffffffff0f00     movabs   r11, 0xfffffffffffff
0x0000CC60: 448817                   mov      byte ptr [rdi], r10b
0x0000CC63: 4803fe                   add      rdi, rsi
0x0000CC66: 418bc5                   mov      eax, r13d
0x0000CC69: f7d8                     neg      eax
0x0000CC6B: 418bc5                   mov      eax, r13d
0x0000CC6E: 1ac9                     sbb      cl, cl
0x0000CC70: 80e1e0                   and      cl, 0xe0
0x0000CC73: 80c178                   add      cl, 0x78
0x0000CC76: 880f                     mov      byte ptr [rdi], cl
0x0000CC78: 4803fe                   add      rdi, rsi
0x0000CC7B: f7d8                     neg      eax
0x0000CC7D: 1bd2                     sbb      edx, edx
0x0000CC7F: 48b8000000000000f07f     movabs   rax, 0x7ff0000000000000
0x0000CC89: 83e2e0                   and      edx, 0xffffffe0
0x0000CC8C: 83ead9                   sub      edx, -0x27
0x0000CC8F: 498506                   test     qword ptr [r14], rax
0x0000CC92: 751b                     jne      0x18000ccaf
0x0000CC94: 448817                   mov      byte ptr [rdi], r10b
0x0000CC97: 498b06                   mov      rax, qword ptr [r14]
0x0000CC9A: 4803fe                   add      rdi, rsi
0x0000CC9D: 4923c3                   and      rax, r11
0x0000CCA0: 48f7d8                   neg      rax
0x0000CCA3: 4d1be4                   sbb      r12, r12
0x0000CCA6: 4181e4fe030000           and      r12d, 0x3fe
0x0000CCAD: eb06                     jmp      0x18000ccb5
0x0000CCAF: c60731                   mov      byte ptr [rdi], 0x31
0x0000CCB2: 4803fe                   add      rdi, rsi
0x0000CCB5: 4c8bff                   mov      r15, rdi
0x0000CCB8: 4803fe                   add      rdi, rsi
0x0000CCBB: 85db                     test     ebx, ebx
0x0000CCBD: 7505                     jne      0x18000ccc4
0x0000CCBF: 45880f                   mov      byte ptr [r15], r9b
0x0000CCC2: eb14                     jmp      0x18000ccd8
0x0000CCC4: 488b442430               mov      rax, qword ptr [rsp + 0x30]
0x0000CCC9: 488b88f0000000           mov      rcx, qword ptr [rax + 0xf0]
0x0000CCD0: 488b01                   mov      rax, qword ptr [rcx]
0x0000CCD3: 8a08                     mov      cl, byte ptr [rax]
0x0000CCD5: 41880f                   mov      byte ptr [r15], cl
0x0000CCD8: 4d851e                   test     qword ptr [r14], r11
0x0000CCDB: 0f8688000000             jbe      0x18000cd69
0x0000CCE1: 49b80000000000000f00     movabs   r8, 0xf000000000000
0x0000CCEB: 85db                     test     ebx, ebx
0x0000CCED: 7e2d                     jle      0x18000cd1c
0x0000CCEF: 498b06                   mov      rax, qword ptr [r14]
0x0000CCF2: 408acd                   mov      cl, bpl
0x0000CCF5: 4923c0                   and      rax, r8
0x0000CCF8: 4923c3                   and      rax, r11
0x0000CCFB: 48d3e8                   shr      rax, cl
0x0000CCFE: 664103c2                 add      ax, r10w
0x0000CD02: 6683f839                 cmp      ax, 0x39
0x0000CD06: 7603                     jbe      0x18000cd0b
0x0000CD08: 6603c2                   add      ax, dx
0x0000CD0B: 8807                     mov      byte ptr [rdi], al
0x0000CD0D: 49c1e804                 shr      r8, 4
0x0000CD11: 2bde                     sub      ebx, esi
0x0000CD13: 4803fe                   add      rdi, rsi
0x0000CD16: 6683c5fc                 add      bp, -4
0x0000CD1A: 79cf                     jns      0x18000cceb
0x0000CD1C: 6685ed                   test     bp, bp
0x0000CD1F: 7848                     js       0x18000cd69
0x0000CD21: 498b06                   mov      rax, qword ptr [r14]
0x0000CD24: 408acd                   mov      cl, bpl
0x0000CD27: 4923c0                   and      rax, r8
0x0000CD2A: 4923c3                   and      rax, r11
0x0000CD2D: 48d3e8                   shr      rax, cl
0x0000CD30: 6683f808                 cmp      ax, 8
0x0000CD34: 7633                     jbe      0x18000cd69
0x0000CD36: 488d4fff                 lea      rcx, [rdi - 1]
0x0000CD3A: 8a01                     mov      al, byte ptr [rcx]
0x0000CD3C: 2c46                     sub      al, 0x46
0x0000CD3E: a8df                     test     al, 0xdf
0x0000CD40: 7508                     jne      0x18000cd4a
0x0000CD42: 448811                   mov      byte ptr [rcx], r10b
0x0000CD45: 482bce                   sub      rcx, rsi
0x0000CD48: ebf0                     jmp      0x18000cd3a
0x0000CD4A: 493bcf                   cmp      rcx, r15
0x0000CD4D: 7414                     je       0x18000cd63
0x0000CD4F: 8a01                     mov      al, byte ptr [rcx]
0x0000CD51: 3c39                     cmp      al, 0x39
0x0000CD53: 7507                     jne      0x18000cd5c
0x0000CD55: 80c23a                   add      dl, 0x3a
0x0000CD58: 8811                     mov      byte ptr [rcx], dl
0x0000CD5A: eb0d                     jmp      0x18000cd69
0x0000CD5C: 4002c6                   add      al, sil
0x0000CD5F: 8801                     mov      byte ptr [rcx], al
0x0000CD61: eb06                     jmp      0x18000cd69
0x0000CD63: 482bce                   sub      rcx, rsi
0x0000CD66: 400031                   add      byte ptr [rcx], sil
0x0000CD69: 85db                     test     ebx, ebx
0x0000CD6B: 7e18                     jle      0x18000cd85
0x0000CD6D: 4c8bc3                   mov      r8, rbx
0x0000CD70: 418ad2                   mov      dl, r10b
0x0000CD73: 488bcf                   mov      rcx, rdi
0x0000CD76: e85555ffff               call     0x1800022d0
0x0000CD7B: 4803fb                   add      rdi, rbx
0x0000CD7E: 4533c9                   xor      r9d, r9d
0x0000CD81: 458d5130                 lea      r10d, [r9 + 0x30]
0x0000CD85: 45380f                   cmp      byte ptr [r15], r9b
0x0000CD88: 490f44ff                 cmove    rdi, r15
0x0000CD8C: 41f7dd                   neg      r13d
0x0000CD8F: 1ac0                     sbb      al, al
0x0000CD91: 24e0                     and      al, 0xe0
0x0000CD93: 0470                     add      al, 0x70
0x0000CD95: 8807                     mov      byte ptr [rdi], al
0x0000CD97: 498b0e                   mov      rcx, qword ptr [r14]
0x0000CD9A: 4803fe                   add      rdi, rsi
0x0000CD9D: 48c1e934                 shr      rcx, 0x34
0x0000CDA1: 81e1ff070000             and      ecx, 0x7ff
0x0000CDA7: 492bcc                   sub      rcx, r12
0x0000CDAA: 7808                     js       0x18000cdb4
0x0000CDAC: c6072b                   mov      byte ptr [rdi], 0x2b
0x0000CDAF: 4803fe                   add      rdi, rsi
0x0000CDB2: eb09                     jmp      0x18000cdbd
0x0000CDB4: c6072d                   mov      byte ptr [rdi], 0x2d
0x0000CDB7: 4803fe                   add      rdi, rsi
0x0000CDBA: 48f7d9                   neg      rcx
0x0000CDBD: 4c8bc7                   mov      r8, rdi
0x0000CDC0: 448817                   mov      byte ptr [rdi], r10b
0x0000CDC3: 4881f9e8030000           cmp      rcx, 0x3e8
0x0000CDCA: 7c33                     jl       0x18000cdff
0x0000CDCC: 48b8cff753e3a59bc420     movabs   rax, 0x20c49ba5e353f7cf
0x0000CDD6: 48f7e9                   imul     rcx
0x0000CDD9: 48c1fa07                 sar      rdx, 7
0x0000CDDD: 488bc2                   mov      rax, rdx
0x0000CDE0: 48c1e83f                 shr      rax, 0x3f
0x0000CDE4: 4803d0                   add      rdx, rax
0x0000CDE7: 418d0412                 lea      eax, [r10 + rdx]
0x0000CDEB: 8807                     mov      byte ptr [rdi], al
0x0000CDED: 4803fe                   add      rdi, rsi
0x0000CDF0: 4869c218fcffff           imul     rax, rdx, -0x3e8
0x0000CDF7: 4803c8                   add      rcx, rax
0x0000CDFA: 493bf8                   cmp      rdi, r8
0x0000CDFD: 7506                     jne      0x18000ce05
0x0000CDFF: 4883f964                 cmp      rcx, 0x64
0x0000CE03: 7c2e                     jl       0x18000ce33
0x0000CE05: 48b80bd7a3703d0ad7a3     movabs   rax, 0xa3d70a3d70a3d70b
0x0000CE0F: 48f7e9                   imul     rcx
0x0000CE12: 4803d1                   add      rdx, rcx
0x0000CE15: 48c1fa06                 sar      rdx, 6
0x0000CE19: 488bc2                   mov      rax, rdx
0x0000CE1C: 48c1e83f                 shr      rax, 0x3f
0x0000CE20: 4803d0                   add      rdx, rax
0x0000CE23: 418d0412                 lea      eax, [r10 + rdx]
0x0000CE27: 8807                     mov      byte ptr [rdi], al
0x0000CE29: 4803fe                   add      rdi, rsi
0x0000CE2C: 486bc29c                 imul     rax, rdx, -0x64
0x0000CE30: 4803c8                   add      rcx, rax
0x0000CE33: 493bf8                   cmp      rdi, r8
0x0000CE36: 7506                     jne      0x18000ce3e
0x0000CE38: 4883f90a                 cmp      rcx, 0xa
0x0000CE3C: 7c2b                     jl       0x18000ce69
0x0000CE3E: 48b86766666666666666     movabs   rax, 0x6666666666666667
0x0000CE48: 48f7e9                   imul     rcx
0x0000CE4B: 48c1fa02                 sar      rdx, 2
0x0000CE4F: 488bc2                   mov      rax, rdx
0x0000CE52: 48c1e83f                 shr      rax, 0x3f
0x0000CE56: 4803d0                   add      rdx, rax
0x0000CE59: 418d0412                 lea      eax, [r10 + rdx]
0x0000CE5D: 8807                     mov      byte ptr [rdi], al
0x0000CE5F: 4803fe                   add      rdi, rsi
0x0000CE62: 486bc2f6                 imul     rax, rdx, -0xa
0x0000CE66: 4803c8                   add      rcx, rax
0x0000CE69: 4102ca                   add      cl, r10b
0x0000CE6C: 880f                     mov      byte ptr [rdi], cl
0x0000CE6E: 44884f01                 mov      byte ptr [rdi + 1], r9b
0x0000CE72: 418bd9                   mov      ebx, r9d
0x0000CE75: 44384c2448               cmp      byte ptr [rsp + 0x48], r9b
0x0000CE7A: 740c                     je       0x18000ce88
0x0000CE7C: 488b4c2440               mov      rcx, qword ptr [rsp + 0x40]
0x0000CE81: 83a1c8000000fd           and      dword ptr [rcx + 0xc8], 0xfffffffd
0x0000CE88: 4c8d5c2450               lea      r11, [rsp + 0x50]
0x0000CE8D: 8bc3                     mov      eax, ebx
0x0000CE8F: 498b5b30                 mov      rbx, qword ptr [r11 + 0x30]
0x0000CE93: 498b6b38                 mov      rbp, qword ptr [r11 + 0x38]
0x0000CE97: 498b7340                 mov      rsi, qword ptr [r11 + 0x40]
0x0000CE9B: 498be3                   mov      rsp, r11
0x0000CE9E: 415f                     pop      r15
0x0000CEA0: 415e                     pop      r14
0x0000CEA2: 415d                     pop      r13
0x0000CEA4: 415c                     pop      r12
0x0000CEA6: 5f                       pop      rdi
0x0000CEA7: c3                       ret      
0x0000CEA8: 488bc4                   mov      rax, rsp
0x0000CEAB: 48895808                 mov      qword ptr [rax + 8], rbx
0x0000CEAF: 48896810                 mov      qword ptr [rax + 0x10], rbp
0x0000CEB3: 48897018                 mov      qword ptr [rax + 0x18], rsi
0x0000CEB7: 48897820                 mov      qword ptr [rax + 0x20], rdi
0x0000CEBB: 4155                     push     r13
0x0000CEBD: 4156                     push     r14
0x0000CEBF: 4157                     push     r15
0x0000CEC1: 4883ec50                 sub      rsp, 0x50
0x0000CEC5: 4c8bf2                   mov      r14, rdx
0x0000CEC8: 488b9424a0000000         mov      rdx, qword ptr [rsp + 0xa0]
0x0000CED0: 488bf9                   mov      rdi, rcx
0x0000CED3: 488d48c8                 lea      rcx, [rax - 0x38]
0x0000CED7: 458be9                   mov      r13d, r9d
0x0000CEDA: 4963f0                   movsxd   rsi, r8d
0x0000CEDD: e8b691ffff               call     0x180006098
0x0000CEE2: 4885ff                   test     rdi, rdi
0x0000CEE5: 7405                     je       0x18000ceec
0x0000CEE7: 4d85f6                   test     r14, r14
0x0000CEEA: 750c                     jne      0x18000cef8
0x0000CEEC: e89b57ffff               call     0x18000268c
0x0000CEF1: bb16000000               mov      ebx, 0x16
0x0000CEF6: eb1b                     jmp      0x18000cf13
0x0000CEF8: 33c0                     xor      eax, eax
0x0000CEFA: 85f6                     test     esi, esi
0x0000CEFC: 0f4fc6                   cmovg    eax, esi
0x0000CEFF: 83c009                   add      eax, 9
0x0000CF02: 4898                     cdqe     
0x0000CF04: 4c3bf0                   cmp      r14, rax
0x0000CF07: 7716                     ja       0x18000cf1f
0x0000CF09: e87e57ffff               call     0x18000268c
0x0000CF0E: bb22000000               mov      ebx, 0x22
0x0000CF13: 8918                     mov      dword ptr [rax], ebx
0x0000CF15: e88a69ffff               call     0x1800038a4
0x0000CF1A: e938010000               jmp      0x18000d057
0x0000CF1F: 80bc249800000000         cmp      byte ptr [rsp + 0x98], 0
0x0000CF27: 488bac2490000000         mov      rbp, qword ptr [rsp + 0x90]
0x0000CF2F: 7434                     je       0x18000cf65
0x0000CF31: 33db                     xor      ebx, ebx
0x0000CF33: 837d002d                 cmp      dword ptr [rbp], 0x2d
0x0000CF37: 0f94c3                   sete     bl
0x0000CF3A: 4533ff                   xor      r15d, r15d
0x0000CF3D: 4803df                   add      rbx, rdi
0x0000CF40: 85f6                     test     esi, esi
0x0000CF42: 410f9fc7                 setg     r15b
0x0000CF46: 4585ff                   test     r15d, r15d
0x0000CF49: 741a                     je       0x18000cf65
0x0000CF4B: 488bcb                   mov      rcx, rbx
0x0000CF4E: e8ad9affff               call     0x180006a00
0x0000CF53: 4963cf                   movsxd   rcx, r15d
0x0000CF56: 488bd3                   mov      rdx, rbx
0x0000CF59: 4c8d4001                 lea      r8, [rax + 1]
0x0000CF5D: 4803cb                   add      rcx, rbx
0x0000CF60: e8cb85ffff               call     0x180005530
0x0000CF65: 837d002d                 cmp      dword ptr [rbp], 0x2d
0x0000CF69: 488bd7                   mov      rdx, rdi
0x0000CF6C: 7507                     jne      0x18000cf75
0x0000CF6E: c6072d                   mov      byte ptr [rdi], 0x2d
0x0000CF71: 488d5701                 lea      rdx, [rdi + 1]
0x0000CF75: 85f6                     test     esi, esi
0x0000CF77: 7e1b                     jle      0x18000cf94
0x0000CF79: 8a4201                   mov      al, byte ptr [rdx + 1]
0x0000CF7C: 8802                     mov      byte ptr [rdx], al
0x0000CF7E: 488b442430               mov      rax, qword ptr [rsp + 0x30]
0x0000CF83: 48ffc2                   inc      rdx
0x0000CF86: 488b88f0000000           mov      rcx, qword ptr [rax + 0xf0]
0x0000CF8D: 488b01                   mov      rax, qword ptr [rcx]
0x0000CF90: 8a08                     mov      cl, byte ptr [rax]
0x0000CF92: 880a                     mov      byte ptr [rdx], cl
0x0000CF94: 33c9                     xor      ecx, ecx
0x0000CF96: 488d1c32                 lea      rbx, [rdx + rsi]
0x0000CF9A: 4c8d05ef7d0000           lea      r8, [rip + 0x7def]
0x0000CFA1: 388c2498000000           cmp      byte ptr [rsp + 0x98], cl
0x0000CFA8: 0f94c1                   sete     cl
0x0000CFAB: 4803d9                   add      rbx, rcx
0x0000CFAE: 482bfb                   sub      rdi, rbx
0x0000CFB1: 4983feff                 cmp      r14, -1
0x0000CFB5: 488bcb                   mov      rcx, rbx
0x0000CFB8: 498d143e                 lea      rdx, [r14 + rdi]
0x0000CFBC: 490f44d6                 cmove    rdx, r14
0x0000CFC0: e8cf4effff               call     0x180001e94
0x0000CFC5: 85c0                     test     eax, eax
0x0000CFC7: 0f85be000000             jne      0x18000d08b
0x0000CFCD: 488d4b02                 lea      rcx, [rbx + 2]
0x0000CFD1: 4585ed                   test     r13d, r13d
0x0000CFD4: 7403                     je       0x18000cfd9
0x0000CFD6: c60345                   mov      byte ptr [rbx], 0x45
0x0000CFD9: 488b4510                 mov      rax, qword ptr [rbp + 0x10]
0x0000CFDD: 803830                   cmp      byte ptr [rax], 0x30
0x0000CFE0: 7456                     je       0x18000d038
0x0000CFE2: 448b4504                 mov      r8d, dword ptr [rbp + 4]
0x0000CFE6: 41ffc8                   dec      r8d
0x0000CFE9: 7907                     jns      0x18000cff2
0x0000CFEB: 41f7d8                   neg      r8d
0x0000CFEE: c643012d                 mov      byte ptr [rbx + 1], 0x2d
0x0000CFF2: 4183f864                 cmp      r8d, 0x64
0x0000CFF6: 7c1b                     jl       0x18000d013
0x0000CFF8: b81f85eb51               mov      eax, 0x51eb851f
0x0000CFFD: 41f7e8                   imul     r8d
0x0000D000: c1fa05                   sar      edx, 5
0x0000D003: 8bc2                     mov      eax, edx
0x0000D005: c1e81f                   shr      eax, 0x1f
0x0000D008: 03d0                     add      edx, eax
0x0000D00A: 005302                   add      byte ptr [rbx + 2], dl
0x0000D00D: 6bc29c                   imul     eax, edx, -0x64
0x0000D010: 4403c0                   add      r8d, eax
0x0000D013: 4183f80a                 cmp      r8d, 0xa
0x0000D017: 7c1b                     jl       0x18000d034
0x0000D019: b867666666               mov      eax, 0x66666667
0x0000D01E: 41f7e8                   imul     r8d
0x0000D021: c1fa02                   sar      edx, 2
0x0000D024: 8bc2                     mov      eax, edx
0x0000D026: c1e81f                   shr      eax, 0x1f
0x0000D029: 03d0                     add      edx, eax
0x0000D02B: 005303                   add      byte ptr [rbx + 3], dl
0x0000D02E: 6bc2f6                   imul     eax, edx, -0xa
0x0000D031: 4403c0                   add      r8d, eax
0x0000D034: 44004304                 add      byte ptr [rbx + 4], r8b
0x0000D038: f605c1ca000001           test     byte ptr [rip + 0xcac1], 1
0x0000D03F: 7414                     je       0x18000d055
0x0000D041: 803930                   cmp      byte ptr [rcx], 0x30
0x0000D044: 750f                     jne      0x18000d055
0x0000D046: 488d5101                 lea      rdx, [rcx + 1]
0x0000D04A: 41b803000000             mov      r8d, 3
0x0000D050: e8db84ffff               call     0x180005530
0x0000D055: 33db                     xor      ebx, ebx
0x0000D057: 807c244800               cmp      byte ptr [rsp + 0x48], 0
0x0000D05C: 740c                     je       0x18000d06a
0x0000D05E: 488b4c2440               mov      rcx, qword ptr [rsp + 0x40]
0x0000D063: 83a1c8000000fd           and      dword ptr [rcx + 0xc8], 0xfffffffd
0x0000D06A: 4c8d5c2450               lea      r11, [rsp + 0x50]
0x0000D06F: 8bc3                     mov      eax, ebx
0x0000D071: 498b5b20                 mov      rbx, qword ptr [r11 + 0x20]
0x0000D075: 498b6b28                 mov      rbp, qword ptr [r11 + 0x28]
0x0000D079: 498b7330                 mov      rsi, qword ptr [r11 + 0x30]
0x0000D07D: 498b7b38                 mov      rdi, qword ptr [r11 + 0x38]
0x0000D081: 498be3                   mov      rsp, r11
0x0000D084: 415f                     pop      r15
0x0000D086: 415e                     pop      r14
0x0000D088: 415d                     pop      r13
0x0000D08A: c3                       ret      
0x0000D08B: 488364242000             and      qword ptr [rsp + 0x20], 0
0x0000D091: 4533c9                   xor      r9d, r9d
0x0000D094: 4533c0                   xor      r8d, r8d
0x0000D097: 33d2                     xor      edx, edx
0x0000D099: 33c9                     xor      ecx, ecx
0x0000D09B: e82468ffff               call     0x1800038c4
0x0000D0A0: cc                       int3     
0x0000D0A1: cc                       int3     
0x0000D0A2: cc                       int3     
0x0000D0A3: cc                       int3     
0x0000D0A4: 4053                     push     rbx
0x0000D0A6: 55                       push     rbp
0x0000D0A7: 56                       push     rsi
0x0000D0A8: 57                       push     rdi
0x0000D0A9: 4881ec88000000           sub      rsp, 0x88
0x0000D0B0: 488b05499f0000           mov      rax, qword ptr [rip + 0x9f49]
0x0000D0B7: 4833c4                   xor      rax, rsp
0x0000D0BA: 4889442470               mov      qword ptr [rsp + 0x70], rax
0x0000D0BF: 488b09                   mov      rcx, qword ptr [rcx]
0x0000D0C2: 498bd8                   mov      rbx, r8
0x0000D0C5: 488bfa                   mov      rdi, rdx
0x0000D0C8: 418bf1                   mov      esi, r9d
0x0000D0CB: bd16000000               mov      ebp, 0x16
0x0000D0D0: 4c8d442458               lea      r8, [rsp + 0x58]
0x0000D0D5: 488d542440               lea      rdx, [rsp + 0x40]
0x0000D0DA: 448bcd                   mov      r9d, ebp
0x0000D0DD: e8fa0e0000               call     0x18000dfdc
0x0000D0E2: 4885ff                   test     rdi, rdi
0x0000D0E5: 7513                     jne      0x18000d0fa
0x0000D0E7: e8a055ffff               call     0x18000268c
0x0000D0EC: 8928                     mov      dword ptr [rax], ebp
0x0000D0EE: e8b167ffff               call     0x1800038a4
0x0000D0F3: 8bc5                     mov      eax, ebp
0x0000D0F5: e988000000               jmp      0x18000d182
0x0000D0FA: 4885db                   test     rbx, rbx
0x0000D0FD: 74e8                     je       0x18000d0e7
0x0000D0FF: 4883caff                 or       rdx, 0xffffffffffffffff
0x0000D103: 483bda                   cmp      rbx, rdx
0x0000D106: 741a                     je       0x18000d122
0x0000D108: 33c0                     xor      eax, eax
0x0000D10A: 837c24402d               cmp      dword ptr [rsp + 0x40], 0x2d
0x0000D10F: 488bd3                   mov      rdx, rbx
0x0000D112: 0f94c0                   sete     al
0x0000D115: 482bd0                   sub      rdx, rax
0x0000D118: 33c0                     xor      eax, eax
0x0000D11A: 85f6                     test     esi, esi
0x0000D11C: 0f9fc0                   setg     al
0x0000D11F: 482bd0                   sub      rdx, rax
0x0000D122: 33c0                     xor      eax, eax
0x0000D124: 837c24402d               cmp      dword ptr [rsp + 0x40], 0x2d
0x0000D129: 448d4601                 lea      r8d, [rsi + 1]
0x0000D12D: 0f94c0                   sete     al
0x0000D130: 33c9                     xor      ecx, ecx
0x0000D132: 85f6                     test     esi, esi
0x0000D134: 0f9fc1                   setg     cl
0x0000D137: 4803c7                   add      rax, rdi
0x0000D13A: 4c8d4c2440               lea      r9, [rsp + 0x40]
0x0000D13F: 4803c8                   add      rcx, rax
0x0000D142: e8f90c0000               call     0x18000de40
0x0000D147: 85c0                     test     eax, eax
0x0000D149: 7405                     je       0x18000d150
0x0000D14B: c60700                   mov      byte ptr [rdi], 0
0x0000D14E: eb32                     jmp      0x18000d182
0x0000D150: 488b8424d8000000         mov      rax, qword ptr [rsp + 0xd8]
0x0000D158: 448b8c24d0000000         mov      r9d, dword ptr [rsp + 0xd0]
0x0000D160: 448bc6                   mov      r8d, esi
0x0000D163: 4889442430               mov      qword ptr [rsp + 0x30], rax
0x0000D168: 488d442440               lea      rax, [rsp + 0x40]
0x0000D16D: 488bd3                   mov      rdx, rbx
0x0000D170: 488bcf                   mov      rcx, rdi
0x0000D173: c644242800               mov      byte ptr [rsp + 0x28], 0
0x0000D178: 4889442420               mov      qword ptr [rsp + 0x20], rax
0x0000D17D: e826fdffff               call     0x18000cea8
0x0000D182: 488b4c2470               mov      rcx, qword ptr [rsp + 0x70]
0x0000D187: 4833cc                   xor      rcx, rsp
0x0000D18A: e88146ffff               call     0x180001810
0x0000D18F: 4881c488000000           add      rsp, 0x88
0x0000D196: 5f                       pop      rdi
0x0000D197: 5e                       pop      rsi
0x0000D198: 5d                       pop      rbp
0x0000D199: 5b                       pop      rbx
0x0000D19A: c3                       ret      
0x0000D19B: cc                       int3     
0x0000D19C: 488bc4                   mov      rax, rsp
0x0000D19F: 48895808                 mov      qword ptr [rax + 8], rbx
0x0000D1A3: 48896810                 mov      qword ptr [rax + 0x10], rbp
0x0000D1A7: 48897018                 mov      qword ptr [rax + 0x18], rsi
0x0000D1AB: 48897820                 mov      qword ptr [rax + 0x20], rdi
0x0000D1AF: 4156                     push     r14
0x0000D1B1: 4883ec40                 sub      rsp, 0x40
0x0000D1B5: 418b5904                 mov      ebx, dword ptr [r9 + 4]
0x0000D1B9: 488bf2                   mov      rsi, rdx
0x0000D1BC: 488b542478               mov      rdx, qword ptr [rsp + 0x78]
0x0000D1C1: 488bf9                   mov      rdi, rcx
0x0000D1C4: 488d48d8                 lea      rcx, [rax - 0x28]
0x0000D1C8: 498be9                   mov      rbp, r9
0x0000D1CB: ffcb                     dec      ebx
0x0000D1CD: 458bf0                   mov      r14d, r8d
0x0000D1D0: e8c38effff               call     0x180006098
0x0000D1D5: 4885ff                   test     rdi, rdi
0x0000D1D8: 7405                     je       0x18000d1df
0x0000D1DA: 4885f6                   test     rsi, rsi
0x0000D1DD: 7516                     jne      0x18000d1f5
0x0000D1DF: e8a854ffff               call     0x18000268c
0x0000D1E4: bb16000000               mov      ebx, 0x16
0x0000D1E9: 8918                     mov      dword ptr [rax], ebx
0x0000D1EB: e8b466ffff               call     0x1800038a4
0x0000D1F0: e9d8000000               jmp      0x18000d2cd
0x0000D1F5: 807c247000               cmp      byte ptr [rsp + 0x70], 0
0x0000D1FA: 741a                     je       0x18000d216
0x0000D1FC: 413bde                   cmp      ebx, r14d
0x0000D1FF: 7515                     jne      0x18000d216
0x0000D201: 33c0                     xor      eax, eax
0x0000D203: 837d002d                 cmp      dword ptr [rbp], 0x2d
0x0000D207: 4863cb                   movsxd   rcx, ebx
0x0000D20A: 0f94c0                   sete     al
0x0000D20D: 4803c7                   add      rax, rdi
0x0000D210: 66c704013000             mov      word ptr [rcx + rax], 0x30
0x0000D216: 837d002d                 cmp      dword ptr [rbp], 0x2d
0x0000D21A: 7506                     jne      0x18000d222
0x0000D21C: c6072d                   mov      byte ptr [rdi], 0x2d
0x0000D21F: 48ffc7                   inc      rdi
0x0000D222: 837d0400                 cmp      dword ptr [rbp + 4], 0
0x0000D226: 7f20                     jg       0x18000d248
0x0000D228: 488bcf                   mov      rcx, rdi
0x0000D22B: e8d097ffff               call     0x180006a00
0x0000D230: 488d4f01                 lea      rcx, [rdi + 1]
0x0000D234: 488bd7                   mov      rdx, rdi
0x0000D237: 4c8d4001                 lea      r8, [rax + 1]
0x0000D23B: e8f082ffff               call     0x180005530
0x0000D240: c60730                   mov      byte ptr [rdi], 0x30
0x0000D243: 48ffc7                   inc      rdi
0x0000D246: eb07                     jmp      0x18000d24f
0x0000D248: 48634504                 movsxd   rax, dword ptr [rbp + 4]
0x0000D24C: 4803f8                   add      rdi, rax
0x0000D24F: 4585f6                   test     r14d, r14d
0x0000D252: 7e77                     jle      0x18000d2cb
0x0000D254: 488bcf                   mov      rcx, rdi
0x0000D257: 488d7701                 lea      rsi, [rdi + 1]
0x0000D25B: e8a097ffff               call     0x180006a00
0x0000D260: 488bd7                   mov      rdx, rdi
0x0000D263: 488bce                   mov      rcx, rsi
0x0000D266: 4c8d4001                 lea      r8, [rax + 1]
0x0000D26A: e8c182ffff               call     0x180005530
0x0000D26F: 488b442420               mov      rax, qword ptr [rsp + 0x20]
0x0000D274: 488b88f0000000           mov      rcx, qword ptr [rax + 0xf0]
0x0000D27B: 488b01                   mov      rax, qword ptr [rcx]
0x0000D27E: 8a08                     mov      cl, byte ptr [rax]
0x0000D280: 880f                     mov      byte ptr [rdi], cl
0x0000D282: 8b5d04                   mov      ebx, dword ptr [rbp + 4]
0x0000D285: 85db                     test     ebx, ebx
0x0000D287: 7942                     jns      0x18000d2cb
0x0000D289: f7db                     neg      ebx
0x0000D28B: 807c247000               cmp      byte ptr [rsp + 0x70], 0
0x0000D290: 750b                     jne      0x18000d29d
0x0000D292: 8bc3                     mov      eax, ebx
0x0000D294: 418bde                   mov      ebx, r14d
0x0000D297: 443bf0                   cmp      r14d, eax
0x0000D29A: 0f4dd8                   cmovge   ebx, eax
0x0000D29D: 85db                     test     ebx, ebx
0x0000D29F: 741a                     je       0x18000d2bb
0x0000D2A1: 488bce                   mov      rcx, rsi
0x0000D2A4: e85797ffff               call     0x180006a00
0x0000D2A9: 4863cb                   movsxd   rcx, ebx
0x0000D2AC: 488bd6                   mov      rdx, rsi
0x0000D2AF: 4c8d4001                 lea      r8, [rax + 1]
0x0000D2B3: 4803ce                   add      rcx, rsi
0x0000D2B6: e87582ffff               call     0x180005530
0x0000D2BB: 4c63c3                   movsxd   r8, ebx
0x0000D2BE: ba30000000               mov      edx, 0x30
0x0000D2C3: 488bce                   mov      rcx, rsi
0x0000D2C6: e80550ffff               call     0x1800022d0
0x0000D2CB: 33db                     xor      ebx, ebx
0x0000D2CD: 807c243800               cmp      byte ptr [rsp + 0x38], 0
0x0000D2D2: 740c                     je       0x18000d2e0
0x0000D2D4: 488b4c2430               mov      rcx, qword ptr [rsp + 0x30]
0x0000D2D9: 83a1c8000000fd           and      dword ptr [rcx + 0xc8], 0xfffffffd
0x0000D2E0: 488b6c2458               mov      rbp, qword ptr [rsp + 0x58]
0x0000D2E5: 488b742460               mov      rsi, qword ptr [rsp + 0x60]
0x0000D2EA: 488b7c2468               mov      rdi, qword ptr [rsp + 0x68]
0x0000D2EF: 8bc3                     mov      eax, ebx
0x0000D2F1: 488b5c2450               mov      rbx, qword ptr [rsp + 0x50]
0x0000D2F6: 4883c440                 add      rsp, 0x40
0x0000D2FA: 415e                     pop      r14
0x0000D2FC: c3                       ret      
0x0000D2FD: cc                       int3     
0x0000D2FE: cc                       int3     
0x0000D2FF: cc                       int3     
0x0000D300: 4053                     push     rbx
0x0000D302: 55                       push     rbp
0x0000D303: 56                       push     rsi
0x0000D304: 57                       push     rdi
0x0000D305: 4883ec78                 sub      rsp, 0x78
0x0000D309: 488b05f09c0000           mov      rax, qword ptr [rip + 0x9cf0]
0x0000D310: 4833c4                   xor      rax, rsp
0x0000D313: 4889442460               mov      qword ptr [rsp + 0x60], rax
0x0000D318: 488b09                   mov      rcx, qword ptr [rcx]
0x0000D31B: 498bd8                   mov      rbx, r8
0x0000D31E: 488bfa                   mov      rdi, rdx
0x0000D321: 418bf1                   mov      esi, r9d
0x0000D324: bd16000000               mov      ebp, 0x16
0x0000D329: 4c8d442448               lea      r8, [rsp + 0x48]
0x0000D32E: 488d542430               lea      rdx, [rsp + 0x30]
0x0000D333: 448bcd                   mov      r9d, ebp
0x0000D336: e8a10c0000               call     0x18000dfdc
0x0000D33B: 4885ff                   test     rdi, rdi
0x0000D33E: 7510                     jne      0x18000d350
0x0000D340: e84753ffff               call     0x18000268c
0x0000D345: 8928                     mov      dword ptr [rax], ebp
0x0000D347: e85865ffff               call     0x1800038a4
0x0000D34C: 8bc5                     mov      eax, ebp
0x0000D34E: eb6b                     jmp      0x18000d3bb
0x0000D350: 4885db                   test     rbx, rbx
0x0000D353: 74eb                     je       0x18000d340
0x0000D355: 4883caff                 or       rdx, 0xffffffffffffffff
0x0000D359: 483bda                   cmp      rbx, rdx
0x0000D35C: 7410                     je       0x18000d36e
0x0000D35E: 33c0                     xor      eax, eax
0x0000D360: 837c24302d               cmp      dword ptr [rsp + 0x30], 0x2d
0x0000D365: 488bd3                   mov      rdx, rbx
0x0000D368: 0f94c0                   sete     al
0x0000D36B: 482bd0                   sub      rdx, rax
0x0000D36E: 448b442434               mov      r8d, dword ptr [rsp + 0x34]
0x0000D373: 33c9                     xor      ecx, ecx
0x0000D375: 4c8d4c2430               lea      r9, [rsp + 0x30]
0x0000D37A: 4403c6                   add      r8d, esi
0x0000D37D: 837c24302d               cmp      dword ptr [rsp + 0x30], 0x2d
0x0000D382: 0f94c1                   sete     cl
0x0000D385: 4803cf                   add      rcx, rdi
0x0000D388: e8b30a0000               call     0x18000de40
0x0000D38D: 85c0                     test     eax, eax
0x0000D38F: 7405                     je       0x18000d396
0x0000D391: c60700                   mov      byte ptr [rdi], 0
0x0000D394: eb25                     jmp      0x18000d3bb
0x0000D396: 488b8424c0000000         mov      rax, qword ptr [rsp + 0xc0]
0x0000D39E: 4c8d4c2430               lea      r9, [rsp + 0x30]
0x0000D3A3: 448bc6                   mov      r8d, esi
0x0000D3A6: 4889442428               mov      qword ptr [rsp + 0x28], rax
0x0000D3AB: 488bd3                   mov      rdx, rbx
0x0000D3AE: 488bcf                   mov      rcx, rdi
0x0000D3B1: c644242000               mov      byte ptr [rsp + 0x20], 0
0x0000D3B6: e8e1fdffff               call     0x18000d19c
0x0000D3BB: 488b4c2460               mov      rcx, qword ptr [rsp + 0x60]
0x0000D3C0: 4833cc                   xor      rcx, rsp
0x0000D3C3: e84844ffff               call     0x180001810
0x0000D3C8: 4883c478                 add      rsp, 0x78
0x0000D3CC: 5f                       pop      rdi
0x0000D3CD: 5e                       pop      rsi
0x0000D3CE: 5d                       pop      rbp
0x0000D3CF: 5b                       pop      rbx
0x0000D3D0: c3                       ret      
0x0000D3D1: cc                       int3     
0x0000D3D2: cc                       int3     
0x0000D3D3: cc                       int3     
0x0000D3D4: 4053                     push     rbx
0x0000D3D6: 55                       push     rbp
0x0000D3D7: 56                       push     rsi
0x0000D3D8: 57                       push     rdi
0x0000D3D9: 4156                     push     r14
0x0000D3DB: 4881ec80000000           sub      rsp, 0x80
0x0000D3E2: 488b05179c0000           mov      rax, qword ptr [rip + 0x9c17]
0x0000D3E9: 4833c4                   xor      rax, rsp
0x0000D3EC: 4889442470               mov      qword ptr [rsp + 0x70], rax
0x0000D3F1: 488b09                   mov      rcx, qword ptr [rcx]
0x0000D3F4: 498bf8                   mov      rdi, r8
0x0000D3F7: 488bf2                   mov      rsi, rdx
0x0000D3FA: 418be9                   mov      ebp, r9d
0x0000D3FD: bb16000000               mov      ebx, 0x16
0x0000D402: 4c8d442458               lea      r8, [rsp + 0x58]
0x0000D407: 488d542440               lea      rdx, [rsp + 0x40]
0x0000D40C: 448bcb                   mov      r9d, ebx
0x0000D40F: e8c80b0000               call     0x18000dfdc
0x0000D414: 4885f6                   test     rsi, rsi
0x0000D417: 7513                     jne      0x18000d42c
0x0000D419: e86e52ffff               call     0x18000268c
0x0000D41E: 8918                     mov      dword ptr [rax], ebx
0x0000D420: e87f64ffff               call     0x1800038a4
0x0000D425: 8bc3                     mov      eax, ebx
0x0000D427: e9c1000000               jmp      0x18000d4ed
0x0000D42C: 4885ff                   test     rdi, rdi
0x0000D42F: 74e8                     je       0x18000d419
0x0000D431: 448b742444               mov      r14d, dword ptr [rsp + 0x44]
0x0000D436: 33c0                     xor      eax, eax
0x0000D438: 41ffce                   dec      r14d
0x0000D43B: 837c24402d               cmp      dword ptr [rsp + 0x40], 0x2d
0x0000D440: 0f94c0                   sete     al
0x0000D443: 4883caff                 or       rdx, 0xffffffffffffffff
0x0000D447: 488d1c30                 lea      rbx, [rax + rsi]
0x0000D44B: 483bfa                   cmp      rdi, rdx
0x0000D44E: 7406                     je       0x18000d456
0x0000D450: 488bd7                   mov      rdx, rdi
0x0000D453: 482bd0                   sub      rdx, rax
0x0000D456: 4c8d4c2440               lea      r9, [rsp + 0x40]
0x0000D45B: 448bc5                   mov      r8d, ebp
0x0000D45E: 488bcb                   mov      rcx, rbx
0x0000D461: e8da090000               call     0x18000de40
0x0000D466: 85c0                     test     eax, eax
0x0000D468: 7405                     je       0x18000d46f
0x0000D46A: c60600                   mov      byte ptr [rsi], 0
0x0000D46D: eb7e                     jmp      0x18000d4ed
0x0000D46F: 8b442444                 mov      eax, dword ptr [rsp + 0x44]
0x0000D473: ffc8                     dec      eax
0x0000D475: 443bf0                   cmp      r14d, eax
0x0000D478: 0f9cc1                   setl     cl
0x0000D47B: 83f8fc                   cmp      eax, -4
0x0000D47E: 7c3b                     jl       0x18000d4bb
0x0000D480: 3bc5                     cmp      eax, ebp
0x0000D482: 7d37                     jge      0x18000d4bb
0x0000D484: 84c9                     test     cl, cl
0x0000D486: 740c                     je       0x18000d494
0x0000D488: 8a03                     mov      al, byte ptr [rbx]
0x0000D48A: 48ffc3                   inc      rbx
0x0000D48D: 84c0                     test     al, al
0x0000D48F: 75f7                     jne      0x18000d488
0x0000D491: 8843fe                   mov      byte ptr [rbx - 2], al
0x0000D494: 488b8424d8000000         mov      rax, qword ptr [rsp + 0xd8]
0x0000D49C: 4c8d4c2440               lea      r9, [rsp + 0x40]
0x0000D4A1: 448bc5                   mov      r8d, ebp
0x0000D4A4: 4889442428               mov      qword ptr [rsp + 0x28], rax
0x0000D4A9: 488bd7                   mov      rdx, rdi
0x0000D4AC: 488bce                   mov      rcx, rsi
0x0000D4AF: c644242001               mov      byte ptr [rsp + 0x20], 1
0x0000D4B4: e8e3fcffff               call     0x18000d19c
0x0000D4B9: eb32                     jmp      0x18000d4ed
0x0000D4BB: 488b8424d8000000         mov      rax, qword ptr [rsp + 0xd8]
0x0000D4C3: 448b8c24d0000000         mov      r9d, dword ptr [rsp + 0xd0]
0x0000D4CB: 448bc5                   mov      r8d, ebp
0x0000D4CE: 4889442430               mov      qword ptr [rsp + 0x30], rax
0x0000D4D3: 488d442440               lea      rax, [rsp + 0x40]
0x0000D4D8: 488bd7                   mov      rdx, rdi
0x0000D4DB: 488bce                   mov      rcx, rsi
0x0000D4DE: c644242801               mov      byte ptr [rsp + 0x28], 1
0x0000D4E3: 4889442420               mov      qword ptr [rsp + 0x20], rax
0x0000D4E8: e8bbf9ffff               call     0x18000cea8
0x0000D4ED: 488b4c2470               mov      rcx, qword ptr [rsp + 0x70]
0x0000D4F2: 4833cc                   xor      rcx, rsp
0x0000D4F5: e81643ffff               call     0x180001810
0x0000D4FA: 4881c480000000           add      rsp, 0x80
0x0000D501: 415e                     pop      r14
0x0000D503: 5f                       pop      rdi
0x0000D504: 5e                       pop      rsi
0x0000D505: 5d                       pop      rbp
0x0000D506: 5b                       pop      rbx
0x0000D507: c3                       ret      
0x0000D508: 33d2                     xor      edx, edx
0x0000D50A: e901000000               jmp      0x18000d510
0x0000D50F: cc                       int3     
0x0000D510: 4053                     push     rbx
0x0000D512: 4883ec40                 sub      rsp, 0x40
0x0000D516: 488bd9                   mov      rbx, rcx
0x0000D519: 488d4c2420               lea      rcx, [rsp + 0x20]
0x0000D51E: e8758bffff               call     0x180006098
0x0000D523: 8a0b                     mov      cl, byte ptr [rbx]
0x0000D525: 4c8b442420               mov      r8, qword ptr [rsp + 0x20]
0x0000D52A: 84c9                     test     cl, cl
0x0000D52C: 7419                     je       0x18000d547
0x0000D52E: 498b80f0000000           mov      rax, qword ptr [r8 + 0xf0]
0x0000D535: 488b10                   mov      rdx, qword ptr [rax]
0x0000D538: 8a02                     mov      al, byte ptr [rdx]
0x0000D53A: 3ac8                     cmp      cl, al
0x0000D53C: 7409                     je       0x18000d547
0x0000D53E: 48ffc3                   inc      rbx
0x0000D541: 8a0b                     mov      cl, byte ptr [rbx]
0x0000D543: 84c9                     test     cl, cl
0x0000D545: 75f3                     jne      0x18000d53a
0x0000D547: 8a03                     mov      al, byte ptr [rbx]
0x0000D549: 48ffc3                   inc      rbx
0x0000D54C: 84c0                     test     al, al
0x0000D54E: 743d                     je       0x18000d58d
0x0000D550: eb09                     jmp      0x18000d55b
0x0000D552: 2c45                     sub      al, 0x45
0x0000D554: a8df                     test     al, 0xdf
0x0000D556: 7409                     je       0x18000d561
0x0000D558: 48ffc3                   inc      rbx
0x0000D55B: 8a03                     mov      al, byte ptr [rbx]
0x0000D55D: 84c0                     test     al, al
0x0000D55F: 75f1                     jne      0x18000d552
0x0000D561: 488bd3                   mov      rdx, rbx
0x0000D564: 48ffcb                   dec      rbx
0x0000D567: 803b30                   cmp      byte ptr [rbx], 0x30
0x0000D56A: 74f8                     je       0x18000d564
0x0000D56C: 498b80f0000000           mov      rax, qword ptr [r8 + 0xf0]
0x0000D573: 488b08                   mov      rcx, qword ptr [rax]
0x0000D576: 8a01                     mov      al, byte ptr [rcx]
0x0000D578: 3803                     cmp      byte ptr [rbx], al
0x0000D57A: 7503                     jne      0x18000d57f
0x0000D57C: 48ffcb                   dec      rbx
0x0000D57F: 8a02                     mov      al, byte ptr [rdx]
0x0000D581: 48ffc3                   inc      rbx
0x0000D584: 48ffc2                   inc      rdx
0x0000D587: 8803                     mov      byte ptr [rbx], al
0x0000D589: 84c0                     test     al, al
0x0000D58B: 75f2                     jne      0x18000d57f
0x0000D58D: 807c243800               cmp      byte ptr [rsp + 0x38], 0
0x0000D592: 740c                     je       0x18000d5a0
0x0000D594: 488b442430               mov      rax, qword ptr [rsp + 0x30]
0x0000D599: 83a0c8000000fd           and      dword ptr [rax + 0xc8], 0xfffffffd
0x0000D5A0: 4883c440                 add      rsp, 0x40
0x0000D5A4: 5b                       pop      rbx
0x0000D5A5: c3                       ret      
0x0000D5A6: cc                       int3     
0x0000D5A7: cc                       int3     
0x0000D5A8: 4533c9                   xor      r9d, r9d
0x0000D5AB: e900000000               jmp      0x18000d5b0
0x0000D5B0: 4053                     push     rbx
0x0000D5B2: 4883ec30                 sub      rsp, 0x30
0x0000D5B6: 498bc0                   mov      rax, r8
0x0000D5B9: 488bda                   mov      rbx, rdx
0x0000D5BC: 4d8bc1                   mov      r8, r9
0x0000D5BF: 488bd0                   mov      rdx, rax
0x0000D5C2: 85c9                     test     ecx, ecx
0x0000D5C4: 7414                     je       0x18000d5da
0x0000D5C6: 488d4c2420               lea      rcx, [rsp + 0x20]
0x0000D5CB: e8acd3ffff               call     0x18000a97c
0x0000D5D0: 488b442420               mov      rax, qword ptr [rsp + 0x20]
0x0000D5D5: 488903                   mov      qword ptr [rbx], rax
0x0000D5D8: eb10                     jmp      0x18000d5ea
0x0000D5DA: 488d4c2440               lea      rcx, [rsp + 0x40]
0x0000D5DF: e860d4ffff               call     0x18000aa44
0x0000D5E4: 8b442440                 mov      eax, dword ptr [rsp + 0x40]
0x0000D5E8: 8903                     mov      dword ptr [rbx], eax
0x0000D5EA: 4883c430                 add      rsp, 0x30
0x0000D5EE: 5b                       pop      rbx
0x0000D5EF: c3                       ret      
0x0000D5F0: 33d2                     xor      edx, edx
0x0000D5F2: e901000000               jmp      0x18000d5f8
0x0000D5F7: cc                       int3     
0x0000D5F8: 4053                     push     rbx
0x0000D5FA: 4883ec40                 sub      rsp, 0x40
0x0000D5FE: 488bd9                   mov      rbx, rcx
0x0000D601: 488d4c2420               lea      rcx, [rsp + 0x20]
0x0000D606: e88d8affff               call     0x180006098
0x0000D60B: 0fbe0b                   movsx    ecx, byte ptr [rbx]
0x0000D60E: e8c9060000               call     0x18000dcdc
0x0000D613: 83f865                   cmp      eax, 0x65
0x0000D616: 740f                     je       0x18000d627
0x0000D618: 48ffc3                   inc      rbx
0x0000D61B: 0fb60b                   movzx    ecx, byte ptr [rbx]
0x0000D61E: e8e9040000               call     0x18000db0c
0x0000D623: 85c0                     test     eax, eax
0x0000D625: 75f1                     jne      0x18000d618
0x0000D627: 0fbe0b                   movsx    ecx, byte ptr [rbx]
0x0000D62A: e8ad060000               call     0x18000dcdc
0x0000D62F: 83f878                   cmp      eax, 0x78
0x0000D632: 7504                     jne      0x18000d638
0x0000D634: 4883c302                 add      rbx, 2
0x0000D638: 488b442420               mov      rax, qword ptr [rsp + 0x20]
0x0000D63D: 8a13                     mov      dl, byte ptr [rbx]
0x0000D63F: 488b88f0000000           mov      rcx, qword ptr [rax + 0xf0]
0x0000D646: 488b01                   mov      rax, qword ptr [rcx]
0x0000D649: 8a08                     mov      cl, byte ptr [rax]
0x0000D64B: 880b                     mov      byte ptr [rbx], cl
0x0000D64D: 48ffc3                   inc      rbx
0x0000D650: 8a03                     mov      al, byte ptr [rbx]
0x0000D652: 8813                     mov      byte ptr [rbx], dl
0x0000D654: 8ad0                     mov      dl, al
0x0000D656: 8a03                     mov      al, byte ptr [rbx]
0x0000D658: 48ffc3                   inc      rbx
0x0000D65B: 84c0                     test     al, al
0x0000D65D: 75f1                     jne      0x18000d650
0x0000D65F: 38442438                 cmp      byte ptr [rsp + 0x38], al
0x0000D663: 740c                     je       0x18000d671
0x0000D665: 488b442430               mov      rax, qword ptr [rsp + 0x30]
0x0000D66A: 83a0c8000000fd           and      dword ptr [rax + 0xc8], 0xfffffffd
0x0000D671: 4883c440                 add      rsp, 0x40
0x0000D675: 5b                       pop      rbx
0x0000D676: c3                       ret      
0x0000D677: cc                       int3     
0x0000D678: f20f1001                 movsd    xmm0, qword ptr [rcx]
0x0000D67C: 33c0                     xor      eax, eax
0x0000D67E: 660f2f0512770000         comisd   xmm0, xmmword ptr [rip + 0x7712]
0x0000D686: 0f93c0                   setae    al
0x0000D689: c3                       ret      
0x0000D68A: cc                       int3     
0x0000D68B: cc                       int3     
0x0000D68C: 48895c2408               mov      qword ptr [rsp + 8], rbx
0x0000D691: 4889742410               mov      qword ptr [rsp + 0x10], rsi
0x0000D696: 57                       push     rdi
0x0000D697: 4883ec30                 sub      rsp, 0x30
0x0000D69B: 488bd9                   mov      rbx, rcx
0x0000D69E: 4885c9                   test     rcx, rcx
0x0000D6A1: 7431                     je       0x18000d6d4
0x0000D6A3: e85893ffff               call     0x180006a00
0x0000D6A8: 488bf0                   mov      rsi, rax
0x0000D6AB: 488d4801                 lea      rcx, [rax + 1]
0x0000D6AF: e8bc41ffff               call     0x180001870
0x0000D6B4: 488bf8                   mov      rdi, rax
0x0000D6B7: 4885c0                   test     rax, rax
0x0000D6BA: 7418                     je       0x18000d6d4
0x0000D6BC: 488d5601                 lea      rdx, [rsi + 1]
0x0000D6C0: 4c8bc3                   mov      r8, rbx
0x0000D6C3: 488bc8                   mov      rcx, rax
0x0000D6C6: e8c947ffff               call     0x180001e94
0x0000D6CB: 85c0                     test     eax, eax
0x0000D6CD: 7517                     jne      0x18000d6e6
0x0000D6CF: 488bc7                   mov      rax, rdi
0x0000D6D2: eb02                     jmp      0x18000d6d6
0x0000D6D4: 33c0                     xor      eax, eax
0x0000D6D6: 488b5c2440               mov      rbx, qword ptr [rsp + 0x40]
0x0000D6DB: 488b742448               mov      rsi, qword ptr [rsp + 0x48]
0x0000D6E0: 4883c430                 add      rsp, 0x30
0x0000D6E4: 5f                       pop      rdi
0x0000D6E5: c3                       ret      
0x0000D6E6: 488364242000             and      qword ptr [rsp + 0x20], 0
0x0000D6EC: 4533c9                   xor      r9d, r9d
0x0000D6EF: 4533c0                   xor      r8d, r8d
0x0000D6F2: 33d2                     xor      edx, edx
0x0000D6F4: 33c9                     xor      ecx, ecx
0x0000D6F6: e8c961ffff               call     0x1800038c4
0x0000D6FB: cc                       int3     
0x0000D6FC: 4533c0                   xor      r8d, r8d
0x0000D6FF: e900000000               jmp      0x18000d704
0x0000D704: 48895c2408               mov      qword ptr [rsp + 8], rbx
0x0000D709: 4889742410               mov      qword ptr [rsp + 0x10], rsi
0x0000D70E: 57                       push     rdi
0x0000D70F: 4883ec40                 sub      rsp, 0x40
0x0000D713: 488bd9                   mov      rbx, rcx
0x0000D716: 8bfa                     mov      edi, edx
0x0000D718: 488d4c2420               lea      rcx, [rsp + 0x20]
0x0000D71D: 498bd0                   mov      rdx, r8
0x0000D720: e87389ffff               call     0x180006098
0x0000D725: 33f6                     xor      esi, esi
0x0000D727: 4885db                   test     rbx, rbx
0x0000D72A: 7512                     jne      0x18000d73e
0x0000D72C: e85b4fffff               call     0x18000268c
0x0000D731: c70016000000             mov      dword ptr [rax], 0x16
0x0000D737: e86861ffff               call     0x1800038a4
0x0000D73C: eb5a                     jmp      0x18000d798
0x0000D73E: 488b542428               mov      rdx, qword ptr [rsp + 0x28]
0x0000D743: 397208                   cmp      dword ptr [rdx + 8], esi
0x0000D746: 750f                     jne      0x18000d757
0x0000D748: 8bd7                     mov      edx, edi
0x0000D74A: 488bcb                   mov      rcx, rbx
0x0000D74D: e842090000               call     0x18000e094
0x0000D752: 488bd8                   mov      rbx, rax
0x0000D755: eb44                     jmp      0x18000d79b
0x0000D757: 0fb60b                   movzx    ecx, byte ptr [rbx]
0x0000D75A: 6685c9                   test     cx, cx
0x0000D75D: 7432                     je       0x18000d791
0x0000D75F: 0fb6c1                   movzx    eax, cl
0x0000D762: f644101904               test     byte ptr [rax + rdx + 0x19], 4
0x0000D767: 741c                     je       0x18000d785
0x0000D769: 48ffc3                   inc      rbx
0x0000D76C: 403833                   cmp      byte ptr [rbx], sil
0x0000D76F: 7427                     je       0x18000d798
0x0000D771: 0fb603                   movzx    eax, byte ptr [rbx]
0x0000D774: 0fb7c9                   movzx    ecx, cx
0x0000D777: c1e108                   shl      ecx, 8
0x0000D77A: 0bc8                     or       ecx, eax
0x0000D77C: 3bf9                     cmp      edi, ecx
0x0000D77E: 750c                     jne      0x18000d78c
0x0000D780: 48ffcb                   dec      rbx
0x0000D783: eb16                     jmp      0x18000d79b
0x0000D785: 0fb7c1                   movzx    eax, cx
0x0000D788: 3bf8                     cmp      edi, eax
0x0000D78A: 7405                     je       0x18000d791
0x0000D78C: 48ffc3                   inc      rbx
0x0000D78F: ebc6                     jmp      0x18000d757
0x0000D791: 0fb7c1                   movzx    eax, cx
0x0000D794: 3bf8                     cmp      edi, eax
0x0000D796: 7403                     je       0x18000d79b
0x0000D798: 488bde                   mov      rbx, rsi
0x0000D79B: 4038742438               cmp      byte ptr [rsp + 0x38], sil
0x0000D7A0: 740c                     je       0x18000d7ae
0x0000D7A2: 488b4c2430               mov      rcx, qword ptr [rsp + 0x30]
0x0000D7A7: 83a1c8000000fd           and      dword ptr [rcx + 0xc8], 0xfffffffd
0x0000D7AE: 488b742458               mov      rsi, qword ptr [rsp + 0x58]
0x0000D7B3: 488bc3                   mov      rax, rbx
0x0000D7B6: 488b5c2450               mov      rbx, qword ptr [rsp + 0x50]
0x0000D7BB: 4883c440                 add      rsp, 0x40
0x0000D7BF: 5f                       pop      rdi
0x0000D7C0: c3                       ret      
0x0000D7C1: cc                       int3     
0x0000D7C2: cc                       int3     
0x0000D7C3: cc                       int3     
0x0000D7C4: 4c8bd1                   mov      r10, rcx
0x0000D7C7: 4d85c0                   test     r8, r8
0x0000D7CA: 743b                     je       0x18000d807
0x0000D7CC: 450fb60a                 movzx    r9d, byte ptr [r10]
0x0000D7D0: 49ffc2                   inc      r10
0x0000D7D3: 418d41bf                 lea      eax, [r9 - 0x41]
0x0000D7D7: 83f819                   cmp      eax, 0x19
0x0000D7DA: 7704                     ja       0x18000d7e0
0x0000D7DC: 4183c120                 add      r9d, 0x20
0x0000D7E0: 0fb60a                   movzx    ecx, byte ptr [rdx]
0x0000D7E3: 48ffc2                   inc      rdx
0x0000D7E6: 8d41bf                   lea      eax, [rcx - 0x41]
0x0000D7E9: 83f819                   cmp      eax, 0x19
0x0000D7EC: 7703                     ja       0x18000d7f1
0x0000D7EE: 83c120                   add      ecx, 0x20
0x0000D7F1: 49ffc8                   dec      r8
0x0000D7F4: 740a                     je       0x18000d800
0x0000D7F6: 4585c9                   test     r9d, r9d
0x0000D7F9: 7405                     je       0x18000d800
0x0000D7FB: 443bc9                   cmp      r9d, ecx
0x0000D7FE: 74cc                     je       0x18000d7cc
0x0000D800: 442bc9                   sub      r9d, ecx
0x0000D803: 418bc1                   mov      eax, r9d
0x0000D806: c3                       ret      
0x0000D807: 33c0                     xor      eax, eax
0x0000D809: c3                       ret      
0x0000D80A: cc                       int3     
0x0000D80B: cc                       int3     
0x0000D80C: 488bc4                   mov      rax, rsp
0x0000D80F: 48895808                 mov      qword ptr [rax + 8], rbx
0x0000D813: 48896810                 mov      qword ptr [rax + 0x10], rbp
0x0000D817: 48897018                 mov      qword ptr [rax + 0x18], rsi
0x0000D81B: 57                       push     rdi
0x0000D81C: 4883ec40                 sub      rsp, 0x40
0x0000D820: 498be8                   mov      rbp, r8
0x0000D823: 488bfa                   mov      rdi, rdx
0x0000D826: 488bf1                   mov      rsi, rcx
0x0000D829: 4d85c0                   test     r8, r8
0x0000D82C: 0f849c000000             je       0x18000d8ce
0x0000D832: 488d48d8                 lea      rcx, [rax - 0x28]
0x0000D836: 498bd1                   mov      rdx, r9
0x0000D839: e85a88ffff               call     0x180006098
0x0000D83E: bbffffff7f               mov      ebx, 0x7fffffff
0x0000D843: 4885f6                   test     rsi, rsi
0x0000D846: 740a                     je       0x18000d852
0x0000D848: 4885ff                   test     rdi, rdi
0x0000D84B: 7405                     je       0x18000d852
0x0000D84D: 483beb                   cmp      rbp, rbx
0x0000D850: 7612                     jbe      0x18000d864
0x0000D852: e8354effff               call     0x18000268c
0x0000D857: c70016000000             mov      dword ptr [rax], 0x16
0x0000D85D: e84260ffff               call     0x1800038a4
0x0000D862: eb53                     jmp      0x18000d8b7
0x0000D864: 488b442420               mov      rax, qword ptr [rsp + 0x20]
0x0000D869: 4883b83801000000         cmp      qword ptr [rax + 0x138], 0
0x0000D871: 7512                     jne      0x18000d885
0x0000D873: 4c8bc5                   mov      r8, rbp
0x0000D876: 488bd7                   mov      rdx, rdi
0x0000D879: 488bce                   mov      rcx, rsi
0x0000D87C: e843ffffff               call     0x18000d7c4
0x0000D881: 8bd8                     mov      ebx, eax
0x0000D883: eb32                     jmp      0x18000d8b7
0x0000D885: 482bf7                   sub      rsi, rdi
0x0000D888: 0fb60c3e                 movzx    ecx, byte ptr [rsi + rdi]
0x0000D88C: 488d542420               lea      rdx, [rsp + 0x20]
0x0000D891: e8f2020000               call     0x18000db88
0x0000D896: 0fb60f                   movzx    ecx, byte ptr [rdi]
0x0000D899: 488d542420               lea      rdx, [rsp + 0x20]
0x0000D89E: 8bd8                     mov      ebx, eax
0x0000D8A0: e8e3020000               call     0x18000db88
0x0000D8A5: 48ffc7                   inc      rdi
0x0000D8A8: 48ffcd                   dec      rbp
0x0000D8AB: 7408                     je       0x18000d8b5
0x0000D8AD: 85db                     test     ebx, ebx
0x0000D8AF: 7404                     je       0x18000d8b5
0x0000D8B1: 3bd8                     cmp      ebx, eax
0x0000D8B3: 74d3                     je       0x18000d888
0x0000D8B5: 2bd8                     sub      ebx, eax
0x0000D8B7: 807c243800               cmp      byte ptr [rsp + 0x38], 0
0x0000D8BC: 740c                     je       0x18000d8ca
0x0000D8BE: 488b442430               mov      rax, qword ptr [rsp + 0x30]
0x0000D8C3: 83a0c8000000fd           and      dword ptr [rax + 0xc8], 0xfffffffd
0x0000D8CA: 8bc3                     mov      eax, ebx
0x0000D8CC: eb02                     jmp      0x18000d8d0
0x0000D8CE: 33c0                     xor      eax, eax
0x0000D8D0: 488b5c2450               mov      rbx, qword ptr [rsp + 0x50]
0x0000D8D5: 488b6c2458               mov      rbp, qword ptr [rsp + 0x58]
0x0000D8DA: 488b742460               mov      rsi, qword ptr [rsp + 0x60]
0x0000D8DF: 4883c440                 add      rsp, 0x40
0x0000D8E3: 5f                       pop      rdi
0x0000D8E4: c3                       ret      
0x0000D8E5: cc                       int3     
0x0000D8E6: cc                       int3     
0x0000D8E7: cc                       int3     
0x0000D8E8: 48895c2408               mov      qword ptr [rsp + 8], rbx
0x0000D8ED: 48896c2410               mov      qword ptr [rsp + 0x10], rbp
0x0000D8F2: 4889742418               mov      qword ptr [rsp + 0x18], rsi
0x0000D8F7: 57                       push     rdi
0x0000D8F8: 4154                     push     r12
0x0000D8FA: 4156                     push     r14
0x0000D8FC: 4883ec10                 sub      rsp, 0x10
0x0000D900: 41832000                 and      dword ptr [r8], 0
0x0000D904: 4183600400               and      dword ptr [r8 + 4], 0
0x0000D909: 4183600800               and      dword ptr [r8 + 8], 0
0x0000D90E: 4d8bd0                   mov      r10, r8
0x0000D911: 8bfa                     mov      edi, edx
0x0000D913: 488be9                   mov      rbp, rcx
0x0000D916: bb4e400000               mov      ebx, 0x404e
0x0000D91B: 85d2                     test     edx, edx
0x0000D91D: 0f8441010000             je       0x18000da64
0x0000D923: 4533db                   xor      r11d, r11d
0x0000D926: 4533c0                   xor      r8d, r8d
0x0000D929: 4533c9                   xor      r9d, r9d
0x0000D92C: 458d6301                 lea      r12d, [r11 + 1]
0x0000D930: f2410f1002               movsd    xmm0, qword ptr [r10]
0x0000D935: 458b7208                 mov      r14d, dword ptr [r10 + 8]
0x0000D939: 418bc8                   mov      ecx, r8d
0x0000D93C: c1e91f                   shr      ecx, 0x1f
0x0000D93F: 4503c0                   add      r8d, r8d
0x0000D942: 4503c9                   add      r9d, r9d
0x0000D945: f20f110424               movsd    qword ptr [rsp], xmm0
0x0000D94A: 440bc9                   or       r9d, ecx
0x0000D94D: 438d141b                 lea      edx, [r11 + r11]
0x0000D951: 418bc3                   mov      eax, r11d
0x0000D954: c1e81f                   shr      eax, 0x1f
0x0000D957: 4503c9                   add      r9d, r9d
0x0000D95A: 440bc0                   or       r8d, eax
0x0000D95D: 8bc2                     mov      eax, edx
0x0000D95F: 03d2                     add      edx, edx
0x0000D961: 418bc8                   mov      ecx, r8d
0x0000D964: c1e81f                   shr      eax, 0x1f
0x0000D967: 4503c0                   add      r8d, r8d
0x0000D96A: c1e91f                   shr      ecx, 0x1f
0x0000D96D: 440bc0                   or       r8d, eax
0x0000D970: 33c0                     xor      eax, eax
0x0000D972: 440bc9                   or       r9d, ecx
0x0000D975: 8b0c24                   mov      ecx, dword ptr [rsp]
0x0000D978: 418912                   mov      dword ptr [r10], edx
0x0000D97B: 8d340a                   lea      esi, [rdx + rcx]
0x0000D97E: 45894204                 mov      dword ptr [r10 + 4], r8d
0x0000D982: 45894a08                 mov      dword ptr [r10 + 8], r9d
0x0000D986: 3bf2                     cmp      esi, edx
0x0000D988: 7204                     jb       0x18000d98e
0x0000D98A: 3bf1                     cmp      esi, ecx
0x0000D98C: 7303                     jae      0x18000d991
0x0000D98E: 418bc4                   mov      eax, r12d
0x0000D991: 418932                   mov      dword ptr [r10], esi
0x0000D994: 85c0                     test     eax, eax
0x0000D996: 7424                     je       0x18000d9bc
0x0000D998: 418bc0                   mov      eax, r8d
0x0000D99B: 41ffc0                   inc      r8d
0x0000D99E: 33c9                     xor      ecx, ecx
0x0000D9A0: 443bc0                   cmp      r8d, eax
0x0000D9A3: 7205                     jb       0x18000d9aa
0x0000D9A5: 453bc4                   cmp      r8d, r12d
0x0000D9A8: 7303                     jae      0x18000d9ad
0x0000D9AA: 418bcc                   mov      ecx, r12d
0x0000D9AD: 45894204                 mov      dword ptr [r10 + 4], r8d
0x0000D9B1: 85c9                     test     ecx, ecx
0x0000D9B3: 7407                     je       0x18000d9bc
0x0000D9B5: 41ffc1                   inc      r9d
0x0000D9B8: 45894a08                 mov      dword ptr [r10 + 8], r9d
0x0000D9BC: 488b0424                 mov      rax, qword ptr [rsp]
0x0000D9C0: 33c9                     xor      ecx, ecx
0x0000D9C2: 48c1e820                 shr      rax, 0x20
0x0000D9C6: 458d1c00                 lea      r11d, [r8 + rax]
0x0000D9CA: 453bd8                   cmp      r11d, r8d
0x0000D9CD: 7205                     jb       0x18000d9d4
0x0000D9CF: 443bd8                   cmp      r11d, eax
0x0000D9D2: 7303                     jae      0x18000d9d7
0x0000D9D4: 418bcc                   mov      ecx, r12d
0x0000D9D7: 45895a04                 mov      dword ptr [r10 + 4], r11d
0x0000D9DB: 85c9                     test     ecx, ecx
0x0000D9DD: 7407                     je       0x18000d9e6
0x0000D9DF: 4503cc                   add      r9d, r12d
0x0000D9E2: 45894a08                 mov      dword ptr [r10 + 8], r9d
0x0000D9E6: 4503ce                   add      r9d, r14d
0x0000D9E9: 8d1436                   lea      edx, [rsi + rsi]
0x0000D9EC: 418bcb                   mov      ecx, r11d
0x0000D9EF: c1e91f                   shr      ecx, 0x1f
0x0000D9F2: 478d041b                 lea      r8d, [r11 + r11]
0x0000D9F6: 4503c9                   add      r9d, r9d
0x0000D9F9: 440bc9                   or       r9d, ecx
0x0000D9FC: 8bc6                     mov      eax, esi
0x0000D9FE: 418912                   mov      dword ptr [r10], edx
0x0000DA01: c1e81f                   shr      eax, 0x1f
0x0000DA04: 45894a08                 mov      dword ptr [r10 + 8], r9d
0x0000DA08: 440bc0                   or       r8d, eax
0x0000DA0B: 33c0                     xor      eax, eax
0x0000DA0D: 45894204                 mov      dword ptr [r10 + 4], r8d
0x0000DA11: 0fbe4d00                 movsx    ecx, byte ptr [rbp]
0x0000DA15: 448d1c0a                 lea      r11d, [rdx + rcx]
0x0000DA19: 443bda                   cmp      r11d, edx
0x0000DA1C: 7205                     jb       0x18000da23
0x0000DA1E: 443bd9                   cmp      r11d, ecx
0x0000DA21: 7303                     jae      0x18000da26
0x0000DA23: 418bc4                   mov      eax, r12d
0x0000DA26: 45891a                   mov      dword ptr [r10], r11d
0x0000DA29: 85c0                     test     eax, eax
0x0000DA2B: 7424                     je       0x18000da51
0x0000DA2D: 418bc0                   mov      eax, r8d
0x0000DA30: 41ffc0                   inc      r8d
0x0000DA33: 33c9                     xor      ecx, ecx
0x0000DA35: 443bc0                   cmp      r8d, eax
0x0000DA38: 7205                     jb       0x18000da3f
0x0000DA3A: 453bc4                   cmp      r8d, r12d
0x0000DA3D: 7303                     jae      0x18000da42
0x0000DA3F: 418bcc                   mov      ecx, r12d
0x0000DA42: 45894204                 mov      dword ptr [r10 + 4], r8d
0x0000DA46: 85c9                     test     ecx, ecx
0x0000DA48: 7407                     je       0x18000da51
0x0000DA4A: 41ffc1                   inc      r9d
0x0000DA4D: 45894a08                 mov      dword ptr [r10 + 8], r9d
0x0000DA51: 4903ec                   add      rbp, r12
0x0000DA54: 45894204                 mov      dword ptr [r10 + 4], r8d
0x0000DA58: 45894a08                 mov      dword ptr [r10 + 8], r9d
0x0000DA5C: ffcf                     dec      edi
0x0000DA5E: 0f85ccfeffff             jne      0x18000d930
0x0000DA64: 41837a0800               cmp      dword ptr [r10 + 8], 0
0x0000DA69: 753a                     jne      0x18000daa5
0x0000DA6B: 458b4204                 mov      r8d, dword ptr [r10 + 4]
0x0000DA6F: 418b12                   mov      edx, dword ptr [r10]
0x0000DA72: 418bc0                   mov      eax, r8d
0x0000DA75: 458bc8                   mov      r9d, r8d
0x0000DA78: c1e010                   shl      eax, 0x10
0x0000DA7B: 8bca                     mov      ecx, edx
0x0000DA7D: c1e210                   shl      edx, 0x10
0x0000DA80: c1e910                   shr      ecx, 0x10
0x0000DA83: 41c1e910                 shr      r9d, 0x10
0x0000DA87: 418912                   mov      dword ptr [r10], edx
0x0000DA8A: 448bc1                   mov      r8d, ecx
0x0000DA8D: 440bc0                   or       r8d, eax
0x0000DA90: b8f0ff0000               mov      eax, 0xfff0
0x0000DA95: 6603d8                   add      bx, ax
0x0000DA98: 4585c9                   test     r9d, r9d
0x0000DA9B: 74d2                     je       0x18000da6f
0x0000DA9D: 45894204                 mov      dword ptr [r10 + 4], r8d
0x0000DAA1: 45894a08                 mov      dword ptr [r10 + 8], r9d
0x0000DAA5: 418b5208                 mov      edx, dword ptr [r10 + 8]
0x0000DAA9: 41bb00800000             mov      r11d, 0x8000
0x0000DAAF: 4185d3                   test     r11d, edx
0x0000DAB2: 7538                     jne      0x18000daec
0x0000DAB4: 458b0a                   mov      r9d, dword ptr [r10]
0x0000DAB7: 458b4204                 mov      r8d, dword ptr [r10 + 4]
0x0000DABB: 418bc8                   mov      ecx, r8d
0x0000DABE: 418bc1                   mov      eax, r9d
0x0000DAC1: 4503c0                   add      r8d, r8d
0x0000DAC4: c1e81f                   shr      eax, 0x1f
0x0000DAC7: 03d2                     add      edx, edx
0x0000DAC9: c1e91f                   shr      ecx, 0x1f
0x0000DACC: 440bc0                   or       r8d, eax
0x0000DACF: b8ffff0000               mov      eax, 0xffff
0x0000DAD4: 0bd1                     or       edx, ecx
0x0000DAD6: 6603d8                   add      bx, ax
0x0000DAD9: 4503c9                   add      r9d, r9d
0x0000DADC: 4185d3                   test     r11d, edx
0x0000DADF: 74da                     je       0x18000dabb
0x0000DAE1: 45890a                   mov      dword ptr [r10], r9d
0x0000DAE4: 45894204                 mov      dword ptr [r10 + 4], r8d
0x0000DAE8: 41895208                 mov      dword ptr [r10 + 8], edx
0x0000DAEC: 488b6c2438               mov      rbp, qword ptr [rsp + 0x38]
0x0000DAF1: 488b742440               mov      rsi, qword ptr [rsp + 0x40]
0x0000DAF6: 6641895a0a               mov      word ptr [r10 + 0xa], bx
0x0000DAFB: 488b5c2430               mov      rbx, qword ptr [rsp + 0x30]
0x0000DB00: 4883c410                 add      rsp, 0x10
0x0000DB04: 415e                     pop      r14
0x0000DB06: 415c                     pop      r12
0x0000DB08: 5f                       pop      rdi
0x0000DB09: c3                       ret      
0x0000DB0A: cc                       int3     
0x0000DB0B: cc                       int3     
0x0000DB0C: 4053                     push     rbx
0x0000DB0E: 4883ec40                 sub      rsp, 0x40
0x0000DB12: 833ddfbf000000           cmp      dword ptr [rip + 0xbfdf], 0
0x0000DB19: 4863d9                   movsxd   rbx, ecx
0x0000DB1C: 7510                     jne      0x18000db2e
0x0000DB1E: 488b05c3a30000           mov      rax, qword ptr [rip + 0xa3c3]
0x0000DB25: 0fb70458                 movzx    eax, word ptr [rax + rbx*2]
0x0000DB29: 83e004                   and      eax, 4
0x0000DB2C: eb52                     jmp      0x18000db80
0x0000DB2E: 488d4c2420               lea      rcx, [rsp + 0x20]
0x0000DB33: 33d2                     xor      edx, edx
0x0000DB35: e85e85ffff               call     0x180006098
0x0000DB3A: 488b442420               mov      rax, qword ptr [rsp + 0x20]
0x0000DB3F: 83b8d400000001           cmp      dword ptr [rax + 0xd4], 1
0x0000DB46: 7e15                     jle      0x18000db5d
0x0000DB48: 4c8d442420               lea      r8, [rsp + 0x20]
0x0000DB4D: ba04000000               mov      edx, 4
0x0000DB52: 8bcb                     mov      ecx, ebx
0x0000DB54: e877ccffff               call     0x18000a7d0
0x0000DB59: 8bc8                     mov      ecx, eax
0x0000DB5B: eb0e                     jmp      0x18000db6b
0x0000DB5D: 488b8008010000           mov      rax, qword ptr [rax + 0x108]
0x0000DB64: 0fb70c58                 movzx    ecx, word ptr [rax + rbx*2]
0x0000DB68: 83e104                   and      ecx, 4
0x0000DB6B: 807c243800               cmp      byte ptr [rsp + 0x38], 0
0x0000DB70: 740c                     je       0x18000db7e
0x0000DB72: 488b442430               mov      rax, qword ptr [rsp + 0x30]
0x0000DB77: 83a0c8000000fd           and      dword ptr [rax + 0xc8], 0xfffffffd
0x0000DB7E: 8bc1                     mov      eax, ecx
0x0000DB80: 4883c440                 add      rsp, 0x40
0x0000DB84: 5b                       pop      rbx
0x0000DB85: c3                       ret      
0x0000DB86: cc                       int3     
0x0000DB87: cc                       int3     
0x0000DB88: 48897c2410               mov      qword ptr [rsp + 0x10], rdi
0x0000DB8D: 4c89742420               mov      qword ptr [rsp + 0x20], r14
0x0000DB92: 55                       push     rbp
0x0000DB93: 488bec                   mov      rbp, rsp
0x0000DB96: 4883ec70                 sub      rsp, 0x70
0x0000DB9A: 4863f9                   movsxd   rdi, ecx
0x0000DB9D: 488d4de0                 lea      rcx, [rbp - 0x20]
0x0000DBA1: e8f284ffff               call     0x180006098
0x0000DBA6: 81ff00010000             cmp      edi, 0x100
0x0000DBAC: 735d                     jae      0x18000dc0b
0x0000DBAE: 488b55e0                 mov      rdx, qword ptr [rbp - 0x20]
0x0000DBB2: 83bad400000001           cmp      dword ptr [rdx + 0xd4], 1
0x0000DBB9: 7e16                     jle      0x18000dbd1
0x0000DBBB: 4c8d45e0                 lea      r8, [rbp - 0x20]
0x0000DBBF: ba01000000               mov      edx, 1
0x0000DBC4: 8bcf                     mov      ecx, edi
0x0000DBC6: e805ccffff               call     0x18000a7d0
0x0000DBCB: 488b55e0                 mov      rdx, qword ptr [rbp - 0x20]
0x0000DBCF: eb0e                     jmp      0x18000dbdf
0x0000DBD1: 488b8208010000           mov      rax, qword ptr [rdx + 0x108]
0x0000DBD8: 0fb70478                 movzx    eax, word ptr [rax + rdi*2]
0x0000DBDC: 83e001                   and      eax, 1
0x0000DBDF: 85c0                     test     eax, eax
0x0000DBE1: 7410                     je       0x18000dbf3
0x0000DBE3: 488b8210010000           mov      rax, qword ptr [rdx + 0x110]
0x0000DBEA: 0fb60438                 movzx    eax, byte ptr [rax + rdi]
0x0000DBEE: e9c4000000               jmp      0x18000dcb7
0x0000DBF3: 807df800                 cmp      byte ptr [rbp - 8], 0
0x0000DBF7: 740b                     je       0x18000dc04
0x0000DBF9: 488b45f0                 mov      rax, qword ptr [rbp - 0x10]
0x0000DBFD: 83a0c8000000fd           and      dword ptr [rax + 0xc8], 0xfffffffd
0x0000DC04: 8bc7                     mov      eax, edi
0x0000DC06: e9bd000000               jmp      0x18000dcc8
0x0000DC0B: 488b45e0                 mov      rax, qword ptr [rbp - 0x20]
0x0000DC0F: 83b8d400000001           cmp      dword ptr [rax + 0xd4], 1
0x0000DC16: 7e2b                     jle      0x18000dc43
0x0000DC18: 448bf7                   mov      r14d, edi
0x0000DC1B: 488d55e0                 lea      rdx, [rbp - 0x20]
0x0000DC1F: 41c1fe08                 sar      r14d, 8
0x0000DC23: 410fb6ce                 movzx    ecx, r14b
0x0000DC27: e8ccc8ffff               call     0x18000a4f8
0x0000DC2C: 85c0                     test     eax, eax
0x0000DC2E: 7413                     je       0x18000dc43
0x0000DC30: 44887510                 mov      byte ptr [rbp + 0x10], r14b
0x0000DC34: 40887d11                 mov      byte ptr [rbp + 0x11], dil
0x0000DC38: c6451200                 mov      byte ptr [rbp + 0x12], 0
0x0000DC3C: b902000000               mov      ecx, 2
0x0000DC41: eb18                     jmp      0x18000dc5b
0x0000DC43: e8444affff               call     0x18000268c
0x0000DC48: b901000000               mov      ecx, 1
0x0000DC4D: c7002a000000             mov      dword ptr [rax], 0x2a
0x0000DC53: 40887d10                 mov      byte ptr [rbp + 0x10], dil
0x0000DC57: c6451100                 mov      byte ptr [rbp + 0x11], 0
0x0000DC5B: 488b55e0                 mov      rdx, qword ptr [rbp - 0x20]
0x0000DC5F: c744244001000000         mov      dword ptr [rsp + 0x40], 1
0x0000DC67: 4c8d4d10                 lea      r9, [rbp + 0x10]
0x0000DC6B: 8b4204                   mov      eax, dword ptr [rdx + 4]
0x0000DC6E: 488b9238010000           mov      rdx, qword ptr [rdx + 0x138]
0x0000DC75: 41b800010000             mov      r8d, 0x100
0x0000DC7B: 89442438                 mov      dword ptr [rsp + 0x38], eax
0x0000DC7F: 488d4520                 lea      rax, [rbp + 0x20]
0x0000DC83: c744243003000000         mov      dword ptr [rsp + 0x30], 3
0x0000DC8B: 4889442428               mov      qword ptr [rsp + 0x28], rax
0x0000DC90: 894c2420                 mov      dword ptr [rsp + 0x20], ecx
0x0000DC94: 488d4de0                 lea      rcx, [rbp - 0x20]
0x0000DC98: e8ffaaffff               call     0x18000879c
0x0000DC9D: 85c0                     test     eax, eax
0x0000DC9F: 0f844effffff             je       0x18000dbf3
0x0000DCA5: 83f801                   cmp      eax, 1
0x0000DCA8: 0fb64520                 movzx    eax, byte ptr [rbp + 0x20]
0x0000DCAC: 7409                     je       0x18000dcb7
0x0000DCAE: 0fb64d21                 movzx    ecx, byte ptr [rbp + 0x21]
0x0000DCB2: c1e008                   shl      eax, 8
0x0000DCB5: 0bc1                     or       eax, ecx
0x0000DCB7: 807df800                 cmp      byte ptr [rbp - 8], 0
0x0000DCBB: 740b                     je       0x18000dcc8
0x0000DCBD: 488b4df0                 mov      rcx, qword ptr [rbp - 0x10]
0x0000DCC1: 83a1c8000000fd           and      dword ptr [rcx + 0xc8], 0xfffffffd
0x0000DCC8: 4c8d5c2470               lea      r11, [rsp + 0x70]
0x0000DCCD: 498b7b18                 mov      rdi, qword ptr [r11 + 0x18]
0x0000DCD1: 4d8b7328                 mov      r14, qword ptr [r11 + 0x28]
0x0000DCD5: 498be3                   mov      rsp, r11
0x0000DCD8: 5d                       pop      rbp
0x0000DCD9: c3                       ret      
0x0000DCDA: cc                       int3     
0x0000DCDB: cc                       int3     
0x0000DCDC: 833d15be000000           cmp      dword ptr [rip + 0xbe15], 0
0x0000DCE3: 750e                     jne      0x18000dcf3
0x0000DCE5: 8d41bf                   lea      eax, [rcx - 0x41]
0x0000DCE8: 83f819                   cmp      eax, 0x19
0x0000DCEB: 7703                     ja       0x18000dcf0
0x0000DCED: 83c120                   add      ecx, 0x20
0x0000DCF0: 8bc1                     mov      eax, ecx
0x0000DCF2: c3                       ret      
0x0000DCF3: 33d2                     xor      edx, edx
0x0000DCF5: e98efeffff               jmp      0x18000db88
0x0000DCFA: cc                       int3     
0x0000DCFB: cc                       int3     
0x0000DCFC: 4883ec18                 sub      rsp, 0x18
0x0000DD00: 4533c0                   xor      r8d, r8d
0x0000DD03: 4c8bc9                   mov      r9, rcx
0x0000DD06: 85d2                     test     edx, edx
0x0000DD08: 7548                     jne      0x18000dd52
0x0000DD0A: 4183e10f                 and      r9d, 0xf
0x0000DD0E: 488bd1                   mov      rdx, rcx
0x0000DD11: 0f57c9                   xorps    xmm1, xmm1
0x0000DD14: 4883e2f0                 and      rdx, 0xfffffffffffffff0
0x0000DD18: 418bc9                   mov      ecx, r9d
0x0000DD1B: 4183c9ff                 or       r9d, 0xffffffff
0x0000DD1F: 41d3e1                   shl      r9d, cl
0x0000DD22: 660f6f02                 movdqa   xmm0, xmmword ptr [rdx]
0x0000DD26: 660f74c1                 pcmpeqb  xmm0, xmm1
0x0000DD2A: 660fd7c0                 pmovmskb eax, xmm0
0x0000DD2E: 4123c1                   and      eax, r9d
0x0000DD31: 7514                     jne      0x18000dd47
0x0000DD33: 4883c210                 add      rdx, 0x10
0x0000DD37: 660f6f02                 movdqa   xmm0, xmmword ptr [rdx]
0x0000DD3B: 660f74c1                 pcmpeqb  xmm0, xmm1
0x0000DD3F: 660fd7c0                 pmovmskb eax, xmm0
0x0000DD43: 85c0                     test     eax, eax
0x0000DD45: 74ec                     je       0x18000dd33
0x0000DD47: 0fbcc0                   bsf      eax, eax
0x0000DD4A: 4803c2                   add      rax, rdx
0x0000DD4D: e9a6000000               jmp      0x18000ddf8
0x0000DD52: 833d2794000002           cmp      dword ptr [rip + 0x9427], 2
0x0000DD59: 0f8d9e000000             jge      0x18000ddfd
0x0000DD5F: 4c8bd1                   mov      r10, rcx
0x0000DD62: 0fb6c2                   movzx    eax, dl
0x0000DD65: 4183e10f                 and      r9d, 0xf
0x0000DD69: 4983e2f0                 and      r10, 0xfffffffffffffff0
0x0000DD6D: 8bc8                     mov      ecx, eax
0x0000DD6F: 0f57d2                   xorps    xmm2, xmm2
0x0000DD72: c1e108                   shl      ecx, 8
0x0000DD75: 0bc8                     or       ecx, eax
0x0000DD77: 660f6ec1                 movd     xmm0, ecx
0x0000DD7B: 418bc9                   mov      ecx, r9d
0x0000DD7E: 4183c9ff                 or       r9d, 0xffffffff
0x0000DD82: 41d3e1                   shl      r9d, cl
0x0000DD85: f20f70c800               pshuflw  xmm1, xmm0, 0
0x0000DD8A: 660f6fc2                 movdqa   xmm0, xmm2
0x0000DD8E: 66410f7402               pcmpeqb  xmm0, xmmword ptr [r10]
0x0000DD93: 660f70d900               pshufd   xmm3, xmm1, 0
0x0000DD98: 660fd7c8                 pmovmskb ecx, xmm0
0x0000DD9C: 660f6fc3                 movdqa   xmm0, xmm3
0x0000DDA0: 66410f7402               pcmpeqb  xmm0, xmmword ptr [r10]
0x0000DDA5: 660fd7d0                 pmovmskb edx, xmm0
0x0000DDA9: 4123d1                   and      edx, r9d
0x0000DDAC: 4123c9                   and      ecx, r9d
0x0000DDAF: 752e                     jne      0x18000dddf
0x0000DDB1: 0fbdca                   bsr      ecx, edx
0x0000DDB4: 660f6fca                 movdqa   xmm1, xmm2
0x0000DDB8: 660f6fc3                 movdqa   xmm0, xmm3
0x0000DDBC: 4903ca                   add      rcx, r10
0x0000DDBF: 85d2                     test     edx, edx
0x0000DDC1: 4c0f45c1                 cmovne   r8, rcx
0x0000DDC5: 4983c210                 add      r10, 0x10
0x0000DDC9: 66410f740a               pcmpeqb  xmm1, xmmword ptr [r10]
0x0000DDCE: 66410f7402               pcmpeqb  xmm0, xmmword ptr [r10]
0x0000DDD3: 660fd7c9                 pmovmskb ecx, xmm1
0x0000DDD7: 660fd7d0                 pmovmskb edx, xmm0
0x0000DDDB: 85c9                     test     ecx, ecx
0x0000DDDD: 74d2                     je       0x18000ddb1
0x0000DDDF: 8bc1                     mov      eax, ecx
0x0000DDE1: f7d8                     neg      eax
0x0000DDE3: 23c1                     and      eax, ecx
0x0000DDE5: ffc8                     dec      eax
0x0000DDE7: 23d0                     and      edx, eax
0x0000DDE9: 0fbdca                   bsr      ecx, edx
0x0000DDEC: 4903ca                   add      rcx, r10
0x0000DDEF: 85d2                     test     edx, edx
0x0000DDF1: 4c0f45c1                 cmovne   r8, rcx
0x0000DDF5: 498bc0                   mov      rax, r8
0x0000DDF8: 4883c418                 add      rsp, 0x18
0x0000DDFC: c3                       ret      
0x0000DDFD: f6c10f                   test     cl, 0xf
0x0000DE00: 7419                     je       0x18000de1b
0x0000DE02: 410fbe01                 movsx    eax, byte ptr [r9]
0x0000DE06: 3bc2                     cmp      eax, edx
0x0000DE08: 4d0f44c1                 cmove    r8, r9
0x0000DE0C: 41803900                 cmp      byte ptr [r9], 0
0x0000DE10: 74e3                     je       0x18000ddf5
0x0000DE12: 49ffc1                   inc      r9
0x0000DE15: 41f6c10f                 test     r9b, 0xf
0x0000DE19: 75e7                     jne      0x18000de02
0x0000DE1B: 0fb6c2                   movzx    eax, dl
0x0000DE1E: 660f6ec0                 movd     xmm0, eax
0x0000DE22: 66410f3a630140           pcmpistri xmm0, xmmword ptr [r9], 0x40
0x0000DE29: 730d                     jae      0x18000de38
0x0000DE2B: 4c63c1                   movsxd   r8, ecx
0x0000DE2E: 4d03c1                   add      r8, r9
0x0000DE31: 66410f3a630140           pcmpistri xmm0, xmmword ptr [r9], 0x40
0x0000DE38: 74bb                     je       0x18000ddf5
0x0000DE3A: 4983c110                 add      r9, 0x10
0x0000DE3E: ebe2                     jmp      0x18000de22
0x0000DE40: 48895c2408               mov      qword ptr [rsp + 8], rbx
0x0000DE45: 57                       push     rdi
0x0000DE46: 4883ec20                 sub      rsp, 0x20
0x0000DE4A: 488bd9                   mov      rbx, rcx
0x0000DE4D: 498b4910                 mov      rcx, qword ptr [r9 + 0x10]
0x0000DE51: 4533d2                   xor      r10d, r10d
0x0000DE54: 4885db                   test     rbx, rbx
0x0000DE57: 7518                     jne      0x18000de71
0x0000DE59: e82e48ffff               call     0x18000268c
0x0000DE5E: bb16000000               mov      ebx, 0x16
0x0000DE63: 8918                     mov      dword ptr [rax], ebx
0x0000DE65: e83a5affff               call     0x1800038a4
0x0000DE6A: 8bc3                     mov      eax, ebx
0x0000DE6C: e98f000000               jmp      0x18000df00
0x0000DE71: 4885d2                   test     rdx, rdx
0x0000DE74: 74e3                     je       0x18000de59
0x0000DE76: 418bc2                   mov      eax, r10d
0x0000DE79: 4585c0                   test     r8d, r8d
0x0000DE7C: 448813                   mov      byte ptr [rbx], r10b
0x0000DE7F: 410f4fc0                 cmovg    eax, r8d
0x0000DE83: ffc0                     inc      eax
0x0000DE85: 4898                     cdqe     
0x0000DE87: 483bd0                   cmp      rdx, rax
0x0000DE8A: 770c                     ja       0x18000de98
0x0000DE8C: e8fb47ffff               call     0x18000268c
0x0000DE91: bb22000000               mov      ebx, 0x22
0x0000DE96: ebcb                     jmp      0x18000de63
0x0000DE98: 488d7b01                 lea      rdi, [rbx + 1]
0x0000DE9C: c60330                   mov      byte ptr [rbx], 0x30
0x0000DE9F: 488bc7                   mov      rax, rdi
0x0000DEA2: eb1a                     jmp      0x18000debe
0x0000DEA4: 443811                   cmp      byte ptr [rcx], r10b
0x0000DEA7: 7408                     je       0x18000deb1
0x0000DEA9: 0fbe11                   movsx    edx, byte ptr [rcx]
0x0000DEAC: 48ffc1                   inc      rcx
0x0000DEAF: eb05                     jmp      0x18000deb6
0x0000DEB1: ba30000000               mov      edx, 0x30
0x0000DEB6: 8810                     mov      byte ptr [rax], dl
0x0000DEB8: 48ffc0                   inc      rax
0x0000DEBB: 41ffc8                   dec      r8d
0x0000DEBE: 4585c0                   test     r8d, r8d
0x0000DEC1: 7fe1                     jg       0x18000dea4
0x0000DEC3: 448810                   mov      byte ptr [rax], r10b
0x0000DEC6: 7814                     js       0x18000dedc
0x0000DEC8: 803935                   cmp      byte ptr [rcx], 0x35
0x0000DECB: 7c0f                     jl       0x18000dedc
0x0000DECD: eb03                     jmp      0x18000ded2
0x0000DECF: c60030                   mov      byte ptr [rax], 0x30
0x0000DED2: 48ffc8                   dec      rax
0x0000DED5: 803839                   cmp      byte ptr [rax], 0x39
0x0000DED8: 74f5                     je       0x18000decf
0x0000DEDA: fe00                     inc      byte ptr [rax]
0x0000DEDC: 803b31                   cmp      byte ptr [rbx], 0x31
0x0000DEDF: 7506                     jne      0x18000dee7
0x0000DEE1: 41ff4104                 inc      dword ptr [r9 + 4]
0x0000DEE5: eb17                     jmp      0x18000defe
0x0000DEE7: 488bcf                   mov      rcx, rdi
0x0000DEEA: e8118bffff               call     0x180006a00
0x0000DEEF: 488bd7                   mov      rdx, rdi
0x0000DEF2: 488bcb                   mov      rcx, rbx
0x0000DEF5: 4c8d4001                 lea      r8, [rax + 1]
0x0000DEF9: e83276ffff               call     0x180005530
0x0000DEFE: 33c0                     xor      eax, eax
0x0000DF00: 488b5c2430               mov      rbx, qword ptr [rsp + 0x30]
0x0000DF05: 4883c420                 add      rsp, 0x20
0x0000DF09: 5f                       pop      rdi
0x0000DF0A: c3                       ret      
0x0000DF0B: cc                       int3     
0x0000DF0C: 48895c2408               mov      qword ptr [rsp + 8], rbx
0x0000DF11: 440fb75a06               movzx    r11d, word ptr [rdx + 6]
0x0000DF16: 4c8bd1                   mov      r10, rcx
0x0000DF19: 8b4a04                   mov      ecx, dword ptr [rdx + 4]
0x0000DF1C: 450fb7c3                 movzx    r8d, r11w
0x0000DF20: b800800000               mov      eax, 0x8000
0x0000DF25: 41b9ff070000             mov      r9d, 0x7ff
0x0000DF2B: 6641c1e804               shr      r8w, 4
0x0000DF30: 664423d8                 and      r11w, ax
0x0000DF34: 8b02                     mov      eax, dword ptr [rdx]
0x0000DF36: 664523c1                 and      r8w, r9w
0x0000DF3A: 81e1ffff0f00             and      ecx, 0xfffff
0x0000DF40: bb00000080               mov      ebx, 0x80000000
0x0000DF45: 410fb7d0                 movzx    edx, r8w
0x0000DF49: 85d2                     test     edx, edx
0x0000DF4B: 7418                     je       0x18000df65
0x0000DF4D: 413bd1                   cmp      edx, r9d
0x0000DF50: 740b                     je       0x18000df5d
0x0000DF52: ba003c0000               mov      edx, 0x3c00
0x0000DF57: 664403c2                 add      r8w, dx
0x0000DF5B: eb24                     jmp      0x18000df81
0x0000DF5D: 41b8ff7f0000             mov      r8d, 0x7fff
0x0000DF63: eb1c                     jmp      0x18000df81
0x0000DF65: 85c9                     test     ecx, ecx
0x0000DF67: 750d                     jne      0x18000df76
0x0000DF69: 85c0                     test     eax, eax
0x0000DF6B: 7509                     jne      0x18000df76
0x0000DF6D: 41214204                 and      dword ptr [r10 + 4], eax
0x0000DF71: 412102                   and      dword ptr [r10], eax
0x0000DF74: eb58                     jmp      0x18000dfce
0x0000DF76: ba013c0000               mov      edx, 0x3c01
0x0000DF7B: 664403c2                 add      r8w, dx
0x0000DF7F: 33db                     xor      ebx, ebx
0x0000DF81: 448bc8                   mov      r9d, eax
0x0000DF84: c1e10b                   shl      ecx, 0xb
0x0000DF87: c1e00b                   shl      eax, 0xb
0x0000DF8A: 41c1e915                 shr      r9d, 0x15
0x0000DF8E: 418902                   mov      dword ptr [r10], eax
0x0000DF91: 440bc9                   or       r9d, ecx
0x0000DF94: 440bcb                   or       r9d, ebx
0x0000DF97: 45894a04                 mov      dword ptr [r10 + 4], r9d
0x0000DF9B: 4585c9                   test     r9d, r9d
0x0000DF9E: 782a                     js       0x18000dfca
0x0000DFA0: 418b12                   mov      edx, dword ptr [r10]
0x0000DFA3: 438d0409                 lea      eax, [r9 + r9]
0x0000DFA7: 8bca                     mov      ecx, edx
0x0000DFA9: c1e91f                   shr      ecx, 0x1f
0x0000DFAC: 448bc9                   mov      r9d, ecx
0x0000DFAF: 440bc8                   or       r9d, eax
0x0000DFB2: 8d0412                   lea      eax, [rdx + rdx]
0x0000DFB5: 418902                   mov      dword ptr [r10], eax
0x0000DFB8: b8ffff0000               mov      eax, 0xffff
0x0000DFBD: 664403c0                 add      r8w, ax
0x0000DFC1: 4585c9                   test     r9d, r9d
0x0000DFC4: 79da                     jns      0x18000dfa0
0x0000DFC6: 45894a04                 mov      dword ptr [r10 + 4], r9d
0x0000DFCA: 66450bd8                 or       r11w, r8w
0x0000DFCE: 488b5c2408               mov      rbx, qword ptr [rsp + 8]
0x0000DFD3: 6645895a08               mov      word ptr [r10 + 8], r11w
0x0000DFD8: c3                       ret      
0x0000DFD9: cc                       int3     
0x0000DFDA: cc                       int3     
0x0000DFDB: cc                       int3     
0x0000DFDC: 4055                     push     rbp
0x0000DFDE: 53                       push     rbx
0x0000DFDF: 56                       push     rsi
0x0000DFE0: 57                       push     rdi
0x0000DFE1: 488d6c24c1               lea      rbp, [rsp - 0x3f]
0x0000DFE6: 4881ec88000000           sub      rsp, 0x88
0x0000DFED: 488b050c900000           mov      rax, qword ptr [rip + 0x900c]
0x0000DFF4: 4833c4                   xor      rax, rsp
0x0000DFF7: 48894527                 mov      qword ptr [rbp + 0x27], rax
0x0000DFFB: 488bfa                   mov      rdi, rdx
0x0000DFFE: 48894de7                 mov      qword ptr [rbp - 0x19], rcx
0x0000E002: 488d55e7                 lea      rdx, [rbp - 0x19]
0x0000E006: 488d4df7                 lea      rcx, [rbp - 9]
0x0000E00A: 498bd9                   mov      rbx, r9
0x0000E00D: 498bf0                   mov      rsi, r8
0x0000E010: e8f7feffff               call     0x18000df0c
0x0000E015: 0fb745ff                 movzx    eax, word ptr [rbp - 1]
0x0000E019: 4533c0                   xor      r8d, r8d
0x0000E01C: f20f1045f7               movsd    xmm0, qword ptr [rbp - 9]
0x0000E021: f20f1145e7               movsd    qword ptr [rbp - 0x19], xmm0
0x0000E026: 4c8d4d07                 lea      r9, [rbp + 7]
0x0000E02A: 488d4de7                 lea      rcx, [rbp - 0x19]
0x0000E02E: 418d5011                 lea      edx, [r8 + 0x11]
0x0000E032: 668945ef                 mov      word ptr [rbp - 0x11], ax
0x0000E036: e8e5000000               call     0x18000e120
0x0000E03B: 0fbe4d09                 movsx    ecx, byte ptr [rbp + 9]
0x0000E03F: 890f                     mov      dword ptr [rdi], ecx
0x0000E041: 0fbf4d07                 movsx    ecx, word ptr [rbp + 7]
0x0000E045: 4c8d450b                 lea      r8, [rbp + 0xb]
0x0000E049: 894f04                   mov      dword ptr [rdi + 4], ecx
0x0000E04C: 488bd3                   mov      rdx, rbx
0x0000E04F: 488bce                   mov      rcx, rsi
0x0000E052: 894708                   mov      dword ptr [rdi + 8], eax
0x0000E055: e83a3effff               call     0x180001e94
0x0000E05A: 85c0                     test     eax, eax
0x0000E05C: 751f                     jne      0x18000e07d
0x0000E05E: 48897710                 mov      qword ptr [rdi + 0x10], rsi
0x0000E062: 488bc7                   mov      rax, rdi
0x0000E065: 488b4d27                 mov      rcx, qword ptr [rbp + 0x27]
0x0000E069: 4833cc                   xor      rcx, rsp
0x0000E06C: e89f37ffff               call     0x180001810
0x0000E071: 4881c488000000           add      rsp, 0x88
0x0000E078: 5f                       pop      rdi
0x0000E079: 5e                       pop      rsi
0x0000E07A: 5b                       pop      rbx
0x0000E07B: 5d                       pop      rbp
0x0000E07C: c3                       ret      
0x0000E07D: 488364242000             and      qword ptr [rsp + 0x20], 0
0x0000E083: 4533c9                   xor      r9d, r9d
0x0000E086: 4533c0                   xor      r8d, r8d
0x0000E089: 33d2                     xor      edx, edx
0x0000E08B: 33c9                     xor      ecx, ecx
0x0000E08D: e83258ffff               call     0x1800038c4
0x0000E092: cc                       int3     
0x0000E093: cc                       int3     
0x0000E094: 4883ec18                 sub      rsp, 0x18
0x0000E098: 0fb6c2                   movzx    eax, dl
0x0000E09B: 4c8bc1                   mov      r8, rcx
0x0000E09E: 83e10f                   and      ecx, 0xf
0x0000E0A1: 448bd0                   mov      r10d, eax
0x0000E0A4: 4983e0f0                 and      r8, 0xfffffffffffffff0
0x0000E0A8: 0f57d2                   xorps    xmm2, xmm2
0x0000E0AB: 41c1e208                 shl      r10d, 8
0x0000E0AF: 4533c9                   xor      r9d, r9d
0x0000E0B2: 440bd0                   or       r10d, eax
0x0000E0B5: 83c8ff                   or       eax, 0xffffffff
0x0000E0B8: d3e0                     shl      eax, cl
0x0000E0BA: 66410f6ec2               movd     xmm0, r10d
0x0000E0BF: f20f70c800               pshuflw  xmm1, xmm0, 0
0x0000E0C4: 660f6fc2                 movdqa   xmm0, xmm2
0x0000E0C8: 66410f7400               pcmpeqb  xmm0, xmmword ptr [r8]
0x0000E0CD: 660f70d900               pshufd   xmm3, xmm1, 0
0x0000E0D2: 660f6fcb                 movdqa   xmm1, xmm3
0x0000E0D6: 66410f7408               pcmpeqb  xmm1, xmmword ptr [r8]
0x0000E0DB: 660febc8                 por      xmm1, xmm0
0x0000E0DF: 660fd7d1                 pmovmskb edx, xmm1
0x0000E0E3: 23d0                     and      edx, eax
0x0000E0E5: 7522                     jne      0x18000e109
0x0000E0E7: 4983c010                 add      r8, 0x10
0x0000E0EB: 660f6fcb                 movdqa   xmm1, xmm3
0x0000E0EF: 660f6fc2                 movdqa   xmm0, xmm2
0x0000E0F3: 66410f7408               pcmpeqb  xmm1, xmmword ptr [r8]
0x0000E0F8: 66410f7400               pcmpeqb  xmm0, xmmword ptr [r8]
0x0000E0FD: 660febc8                 por      xmm1, xmm0
0x0000E101: 660fd7d1                 pmovmskb edx, xmm1
0x0000E105: 85d2                     test     edx, edx
0x0000E107: 74de                     je       0x18000e0e7
0x0000E109: 0fbcd2                   bsf      edx, edx
0x0000E10C: 4903d0                   add      rdx, r8
0x0000E10F: 443812                   cmp      byte ptr [rdx], r10b
0x0000E112: 4c0f44ca                 cmove    r9, rdx
0x0000E116: 498bc1                   mov      rax, r9
0x0000E119: 4883c418                 add      rsp, 0x18
0x0000E11D: c3                       ret      
0x0000E11E: cc                       int3     
0x0000E11F: cc                       int3     
0x0000E120: 48895c2410               mov      qword ptr [rsp + 0x10], rbx
0x0000E125: 55                       push     rbp
0x0000E126: 56                       push     rsi
0x0000E127: 57                       push     rdi
0x0000E128: 4154                     push     r12
0x0000E12A: 4155                     push     r13
0x0000E12C: 4156                     push     r14
0x0000E12E: 4157                     push     r15
0x0000E130: 488d6c24d9               lea      rbp, [rsp - 0x27]
0x0000E135: 4881ecc0000000           sub      rsp, 0xc0
0x0000E13C: 488b05bd8e0000           mov      rax, qword ptr [rip + 0x8ebd]
0x0000E143: 4833c4                   xor      rax, rsp
0x0000E146: 48894517                 mov      qword ptr [rbp + 0x17], rax
0x0000E14A: 440fb75108               movzx    r10d, word ptr [rcx + 8]
0x0000E14F: 498bd9                   mov      rbx, r9
0x0000E152: 448b09                   mov      r9d, dword ptr [rcx]
0x0000E155: 8955b3                   mov      dword ptr [rbp - 0x4d], edx
0x0000E158: ba00800000               mov      edx, 0x8000
0x0000E15D: 41bb01000000             mov      r11d, 1
0x0000E163: 448945c7                 mov      dword ptr [rbp - 0x39], r8d
0x0000E167: 448b4104                 mov      r8d, dword ptr [rcx + 4]
0x0000E16B: 410fb7ca                 movzx    ecx, r10w
0x0000E16F: 6623ca                   and      cx, dx
0x0000E172: 448d6aff                 lea      r13d, [rdx - 1]
0x0000E176: 418d431f                 lea      eax, [r11 + 0x1f]
0x0000E17A: 4533e4                   xor      r12d, r12d
0x0000E17D: 664523d5                 and      r10w, r13w
0x0000E181: 48895dbf                 mov      qword ptr [rbp - 0x41], rbx
0x0000E185: c745f7cccccccc           mov      dword ptr [rbp - 9], 0xcccccccc
0x0000E18C: c745fbcccccccc           mov      dword ptr [rbp - 5], 0xcccccccc
0x0000E193: c745ffccccfb3f           mov      dword ptr [rbp - 1], 0x3ffbcccc
0x0000E19A: 66894d99                 mov      word ptr [rbp - 0x67], cx
0x0000E19E: 8d780d                   lea      edi, [rax + 0xd]
0x0000E1A1: 6685c9                   test     cx, cx
0x0000E1A4: 7406                     je       0x18000e1ac
0x0000E1A6: 40887b02                 mov      byte ptr [rbx + 2], dil
0x0000E1AA: eb03                     jmp      0x18000e1af
0x0000E1AC: 884302                   mov      byte ptr [rbx + 2], al
0x0000E1AF: 664585d2                 test     r10w, r10w
0x0000E1B3: 752e                     jne      0x18000e1e3
0x0000E1B5: 4585c0                   test     r8d, r8d
0x0000E1B8: 0f85f4000000             jne      0x18000e2b2
0x0000E1BE: 4585c9                   test     r9d, r9d
0x0000E1C1: 0f85eb000000             jne      0x18000e2b2
0x0000E1C7: 663bca                   cmp      cx, dx
0x0000E1CA: 0f44c7                   cmove    eax, edi
0x0000E1CD: 66448923                 mov      word ptr [rbx], r12w
0x0000E1D1: 884302                   mov      byte ptr [rbx + 2], al
0x0000E1D4: 66c743030130             mov      word ptr [rbx + 3], 0x3001
0x0000E1DA: 44886305                 mov      byte ptr [rbx + 5], r12b
0x0000E1DE: e95b090000               jmp      0x18000eb3e
0x0000E1E3: 66453bd5                 cmp      r10w, r13w
0x0000E1E7: 0f85c5000000             jne      0x18000e2b2
0x0000E1ED: be00000080               mov      esi, 0x80000000
0x0000E1F2: 6644891b                 mov      word ptr [rbx], r11w
0x0000E1F6: 443bc6                   cmp      r8d, esi
0x0000E1F9: 7505                     jne      0x18000e200
0x0000E1FB: 4585c9                   test     r9d, r9d
0x0000E1FE: 7429                     je       0x18000e229
0x0000E200: 410fbae01e               bt       r8d, 0x1e
0x0000E205: 7222                     jb       0x18000e229
0x0000E207: 488d4b04                 lea      rcx, [rbx + 4]
0x0000E20B: 4c8d058e6b0000           lea      r8, [rip + 0x6b8e]
0x0000E212: ba16000000               mov      edx, 0x16
0x0000E217: e8783cffff               call     0x180001e94
0x0000E21C: 85c0                     test     eax, eax
0x0000E21E: 0f8482000000             je       0x18000e2a6
0x0000E224: e97b090000               jmp      0x18000eba4
0x0000E229: 6685c9                   test     cx, cx
0x0000E22C: 742b                     je       0x18000e259
0x0000E22E: 4181f8000000c0           cmp      r8d, 0xc0000000
0x0000E235: 7522                     jne      0x18000e259
0x0000E237: 4585c9                   test     r9d, r9d
0x0000E23A: 754d                     jne      0x18000e289
0x0000E23C: 488d4b04                 lea      rcx, [rbx + 4]
0x0000E240: 4c8d05616b0000           lea      r8, [rip + 0x6b61]
0x0000E247: 418d5116                 lea      edx, [r9 + 0x16]
0x0000E24B: e8443cffff               call     0x180001e94
0x0000E250: 85c0                     test     eax, eax
0x0000E252: 742b                     je       0x18000e27f
0x0000E254: e960090000               jmp      0x18000ebb9
0x0000E259: 443bc6                   cmp      r8d, esi
0x0000E25C: 752b                     jne      0x18000e289
0x0000E25E: 4585c9                   test     r9d, r9d
0x0000E261: 7526                     jne      0x18000e289
0x0000E263: 488d4b04                 lea      rcx, [rbx + 4]
0x0000E267: 4c8d05426b0000           lea      r8, [rip + 0x6b42]
0x0000E26E: 418d5116                 lea      edx, [r9 + 0x16]
0x0000E272: e81d3cffff               call     0x180001e94
0x0000E277: 85c0                     test     eax, eax
0x0000E279: 0f854f090000             jne      0x18000ebce
0x0000E27F: b805000000               mov      eax, 5
0x0000E284: 884303                   mov      byte ptr [rbx + 3], al
0x0000E287: eb21                     jmp      0x18000e2aa
0x0000E289: 488d4b04                 lea      rcx, [rbx + 4]
0x0000E28D: 4c8d05246b0000           lea      r8, [rip + 0x6b24]
0x0000E294: ba16000000               mov      edx, 0x16
0x0000E299: e8f63bffff               call     0x180001e94
0x0000E29E: 85c0                     test     eax, eax
0x0000E2A0: 0f853d090000             jne      0x18000ebe3
0x0000E2A6: c6430306                 mov      byte ptr [rbx + 3], 6
0x0000E2AA: 458bdc                   mov      r11d, r12d
0x0000E2AD: e98c080000               jmp      0x18000eb3e
0x0000E2B2: 410fb7d2                 movzx    edx, r10w
0x0000E2B6: 44894de9                 mov      dword ptr [rbp - 0x17], r9d
0x0000E2BA: 66448955f1               mov      word ptr [rbp - 0xf], r10w
0x0000E2BF: 418bc8                   mov      ecx, r8d
0x0000E2C2: 8bc2                     mov      eax, edx
0x0000E2C4: 4c8d0d75a10000           lea      r9, [rip + 0xa175]
0x0000E2CB: c1e918                   shr      ecx, 0x18
0x0000E2CE: c1e808                   shr      eax, 8
0x0000E2D1: 41bf00000080             mov      r15d, 0x80000000
0x0000E2D7: 8d0448                   lea      eax, [rax + rcx*2]
0x0000E2DA: 41be05000000             mov      r14d, 5
0x0000E2E0: 4983e960                 sub      r9, 0x60
0x0000E2E4: 448945ed                 mov      dword ptr [rbp - 0x13], r8d
0x0000E2E8: 66448965e7               mov      word ptr [rbp - 0x19], r12w
0x0000E2ED: befdbf0000               mov      esi, 0xbffd
0x0000E2F2: 6bc84d                   imul     ecx, eax, 0x4d
0x0000E2F5: 69c2104d0000             imul     eax, edx, 0x4d10
0x0000E2FB: 050cedbcec               add      eax, 0xecbced0c
0x0000E300: 448975b7                 mov      dword ptr [rbp - 0x49], r14d
0x0000E304: 418d7fff                 lea      edi, [r15 - 1]
0x0000E308: 03c8                     add      ecx, eax
0x0000E30A: c1f910                   sar      ecx, 0x10
0x0000E30D: 440fbfd1                 movsx    r10d, cx
0x0000E311: 894d9f                   mov      dword ptr [rbp - 0x61], ecx
0x0000E314: 41f7da                   neg      r10d
0x0000E317: 0f846f030000             je       0x18000e68c
0x0000E31D: 4585d2                   test     r10d, r10d
0x0000E320: 7911                     jns      0x18000e333
0x0000E322: 4c8d0d77a20000           lea      r9, [rip + 0xa277]
0x0000E329: 41f7da                   neg      r10d
0x0000E32C: 4983e960                 sub      r9, 0x60
0x0000E330: 4585d2                   test     r10d, r10d
0x0000E333: 0f8453030000             je       0x18000e68c
0x0000E339: 448b45eb                 mov      r8d, dword ptr [rbp - 0x15]
0x0000E33D: 8b55e7                   mov      edx, dword ptr [rbp - 0x19]
0x0000E340: 418bc2                   mov      eax, r10d
0x0000E343: 4983c154                 add      r9, 0x54
0x0000E347: 41c1fa03                 sar      r10d, 3
0x0000E34B: 448955af                 mov      dword ptr [rbp - 0x51], r10d
0x0000E34F: 4c894da7                 mov      qword ptr [rbp - 0x59], r9
0x0000E353: 83e007                   and      eax, 7
0x0000E356: 0f8419030000             je       0x18000e675
0x0000E35C: 4898                     cdqe     
0x0000E35E: 488d0c40                 lea      rcx, [rax + rax*2]
0x0000E362: 498d3489                 lea      rsi, [r9 + rcx*4]
0x0000E366: 41b900800000             mov      r9d, 0x8000
0x0000E36C: 488975cf                 mov      qword ptr [rbp - 0x31], rsi
0x0000E370: 6644390e                 cmp      word ptr [rsi], r9w
0x0000E374: 7225                     jb       0x18000e39b
0x0000E376: 8b4608                   mov      eax, dword ptr [rsi + 8]
0x0000E379: f20f1006                 movsd    xmm0, qword ptr [rsi]
0x0000E37D: 488d7507                 lea      rsi, [rbp + 7]
0x0000E381: 89450f                   mov      dword ptr [rbp + 0xf], eax
0x0000E384: f20f114507               movsd    qword ptr [rbp + 7], xmm0
0x0000E389: 488b4507                 mov      rax, qword ptr [rbp + 7]
0x0000E38D: 48c1e810                 shr      rax, 0x10
0x0000E391: 488975cf                 mov      qword ptr [rbp - 0x31], rsi
0x0000E395: 412bc3                   sub      eax, r11d
0x0000E398: 894509                   mov      dword ptr [rbp + 9], eax
0x0000E39B: 0fb74e0a                 movzx    ecx, word ptr [rsi + 0xa]
0x0000E39F: 0fb745f1                 movzx    eax, word ptr [rbp - 0xf]
0x0000E3A3: 4489659b                 mov      dword ptr [rbp - 0x65], r12d
0x0000E3A7: 0fb7d9                   movzx    ebx, cx
0x0000E3AA: 664123cd                 and      cx, r13w
0x0000E3AE: 48c745d700000000         mov      qword ptr [rbp - 0x29], 0
0x0000E3B6: 6633d8                   xor      bx, ax
0x0000E3B9: 664123c5                 and      ax, r13w
0x0000E3BD: 448965df                 mov      dword ptr [rbp - 0x21], r12d
0x0000E3C1: 664123d9                 and      bx, r9w
0x0000E3C5: 448d0c08                 lea      r9d, [rax + rcx]
0x0000E3C9: 66895d97                 mov      word ptr [rbp - 0x69], bx
0x0000E3CD: 66413bc5                 cmp      ax, r13w
0x0000E3D1: 0f837d020000             jae      0x18000e654
0x0000E3D7: 66413bcd                 cmp      cx, r13w
0x0000E3DB: 0f8373020000             jae      0x18000e654
0x0000E3E1: 41bdfdbf0000             mov      r13d, 0xbffd
0x0000E3E7: 66453bcd                 cmp      r9w, r13w
0x0000E3EB: 0f875d020000             ja       0x18000e64e
0x0000E3F1: bbbf3f0000               mov      ebx, 0x3fbf
0x0000E3F6: 66443bcb                 cmp      r9w, bx
0x0000E3FA: 7713                     ja       0x18000e40f
0x0000E3FC: 48c745eb00000000         mov      qword ptr [rbp - 0x15], 0
0x0000E404: 41bdff7f0000             mov      r13d, 0x7fff
0x0000E40A: e959020000               jmp      0x18000e668
0x0000E40F: 6685c0                   test     ax, ax
0x0000E412: 7522                     jne      0x18000e436
0x0000E414: 664503cb                 add      r9w, r11w
0x0000E418: 857def                   test     dword ptr [rbp - 0x11], edi
0x0000E41B: 7519                     jne      0x18000e436
0x0000E41D: 4585c0                   test     r8d, r8d
0x0000E420: 7514                     jne      0x18000e436
0x0000E422: 85d2                     test     edx, edx
0x0000E424: 7510                     jne      0x18000e436
0x0000E426: 66448965f1               mov      word ptr [rbp - 0xf], r12w
0x0000E42B: 41bdff7f0000             mov      r13d, 0x7fff
0x0000E431: e93b020000               jmp      0x18000e671
0x0000E436: 6685c9                   test     cx, cx
0x0000E439: 7514                     jne      0x18000e44f
0x0000E43B: 664503cb                 add      r9w, r11w
0x0000E43F: 857e08                   test     dword ptr [rsi + 8], edi
0x0000E442: 750b                     jne      0x18000e44f
0x0000E444: 44396604                 cmp      dword ptr [rsi + 4], r12d
0x0000E448: 7505                     jne      0x18000e44f
0x0000E44A: 443926                   cmp      dword ptr [rsi], r12d
0x0000E44D: 74ad                     je       0x18000e3fc
0x0000E44F: 418bfe                   mov      edi, r14d
0x0000E452: 488d55d7                 lea      rdx, [rbp - 0x29]
0x0000E456: 4533f6                   xor      r14d, r14d
0x0000E459: 448bef                   mov      r13d, edi
0x0000E45C: 85ff                     test     edi, edi
0x0000E45E: 7e5f                     jle      0x18000e4bf
0x0000E460: 438d0424                 lea      eax, [r12 + r12]
0x0000E464: 4c8d75e7                 lea      r14, [rbp - 0x19]
0x0000E468: 418bdc                   mov      ebx, r12d
0x0000E46B: 4863c8                   movsxd   rcx, eax
0x0000E46E: 4123db                   and      ebx, r11d
0x0000E471: 4c8d7e08                 lea      r15, [rsi + 8]
0x0000E475: 4c03f1                   add      r14, rcx
0x0000E478: 33f6                     xor      esi, esi
0x0000E47A: 410fb707                 movzx    eax, word ptr [r15]
0x0000E47E: 410fb70e                 movzx    ecx, word ptr [r14]
0x0000E482: 448bd6                   mov      r10d, esi
0x0000E485: 0fafc8                   imul     ecx, eax
0x0000E488: 8b02                     mov      eax, dword ptr [rdx]
0x0000E48A: 448d0408                 lea      r8d, [rax + rcx]
0x0000E48E: 443bc0                   cmp      r8d, eax
0x0000E491: 7205                     jb       0x18000e498
0x0000E493: 443bc1                   cmp      r8d, ecx
0x0000E496: 7303                     jae      0x18000e49b
0x0000E498: 458bd3                   mov      r10d, r11d
0x0000E49B: 448902                   mov      dword ptr [rdx], r8d
0x0000E49E: 4585d2                   test     r10d, r10d
0x0000E4A1: 7405                     je       0x18000e4a8
0x0000E4A3: 6644015a04               add      word ptr [rdx + 4], r11w
0x0000E4A8: 452beb                   sub      r13d, r11d
0x0000E4AB: 4983c602                 add      r14, 2
0x0000E4AF: 4983ef02                 sub      r15, 2
0x0000E4B3: 4585ed                   test     r13d, r13d
0x0000E4B6: 7fc2                     jg       0x18000e47a
0x0000E4B8: 488b75cf                 mov      rsi, qword ptr [rbp - 0x31]
0x0000E4BC: 4533f6                   xor      r14d, r14d
0x0000E4BF: 412bfb                   sub      edi, r11d
0x0000E4C2: 4883c202                 add      rdx, 2
0x0000E4C6: 4503e3                   add      r12d, r11d
0x0000E4C9: 85ff                     test     edi, edi
0x0000E4CB: 7f8c                     jg       0x18000e459
0x0000E4CD: 448b55df                 mov      r10d, dword ptr [rbp - 0x21]
0x0000E4D1: 448b45d7                 mov      r8d, dword ptr [rbp - 0x29]
0x0000E4D5: b802c00000               mov      eax, 0xc002
0x0000E4DA: 664403c8                 add      r9w, ax
0x0000E4DE: 4533e4                   xor      r12d, r12d
0x0000E4E1: bbffff0000               mov      ebx, 0xffff
0x0000E4E6: 41bf00000080             mov      r15d, 0x80000000
0x0000E4EC: 664585c9                 test     r9w, r9w
0x0000E4F0: 7e3c                     jle      0x18000e52e
0x0000E4F2: 4585d7                   test     r15d, r10d
0x0000E4F5: 7531                     jne      0x18000e528
0x0000E4F7: 8b7ddb                   mov      edi, dword ptr [rbp - 0x25]
0x0000E4FA: 418bd0                   mov      edx, r8d
0x0000E4FD: 4503d2                   add      r10d, r10d
0x0000E500: c1ea1f                   shr      edx, 0x1f
0x0000E503: 4503c0                   add      r8d, r8d
0x0000E506: 8bcf                     mov      ecx, edi
0x0000E508: c1e91f                   shr      ecx, 0x1f
0x0000E50B: 8d043f                   lea      eax, [rdi + rdi]
0x0000E50E: 664403cb                 add      r9w, bx
0x0000E512: 0bc2                     or       eax, edx
0x0000E514: 440bd1                   or       r10d, ecx
0x0000E517: 448945d7                 mov      dword ptr [rbp - 0x29], r8d
0x0000E51B: 8945db                   mov      dword ptr [rbp - 0x25], eax
0x0000E51E: 448955df                 mov      dword ptr [rbp - 0x21], r10d
0x0000E522: 664585c9                 test     r9w, r9w
0x0000E526: 7fca                     jg       0x18000e4f2
0x0000E528: 664585c9                 test     r9w, r9w
0x0000E52C: 7f6d                     jg       0x18000e59b
0x0000E52E: 664403cb                 add      r9w, bx
0x0000E532: 7967                     jns      0x18000e59b
0x0000E534: 410fb7c1                 movzx    eax, r9w
0x0000E538: 66f7d8                   neg      ax
0x0000E53B: 0fb7d0                   movzx    edx, ax
0x0000E53E: 664403ca                 add      r9w, dx
0x0000E542: 6644894da3               mov      word ptr [rbp - 0x5d], r9w
0x0000E547: 448b4d9b                 mov      r9d, dword ptr [rbp - 0x65]
0x0000E54B: 44845dd7                 test     byte ptr [rbp - 0x29], r11b
0x0000E54F: 7403                     je       0x18000e554
0x0000E551: 4503cb                   add      r9d, r11d
0x0000E554: 8b7ddb                   mov      edi, dword ptr [rbp - 0x25]
0x0000E557: 418bc2                   mov      eax, r10d
0x0000E55A: 41d1e8                   shr      r8d, 1
0x0000E55D: 8bcf                     mov      ecx, edi
0x0000E55F: c1e01f                   shl      eax, 0x1f
0x0000E562: d1ef                     shr      edi, 1
0x0000E564: c1e11f                   shl      ecx, 0x1f
0x0000E567: 0bf8                     or       edi, eax
0x0000E569: 41d1ea                   shr      r10d, 1
0x0000E56C: 440bc1                   or       r8d, ecx
0x0000E56F: 897ddb                   mov      dword ptr [rbp - 0x25], edi
0x0000E572: 448945d7                 mov      dword ptr [rbp - 0x29], r8d
0x0000E576: 492bd3                   sub      rdx, r11
0x0000E579: 75d0                     jne      0x18000e54b
0x0000E57B: 4585c9                   test     r9d, r9d
0x0000E57E: 440fb74da3               movzx    r9d, word ptr [rbp - 0x5d]
0x0000E583: 448955df                 mov      dword ptr [rbp - 0x21], r10d
0x0000E587: 7412                     je       0x18000e59b
0x0000E589: 410fb7c0                 movzx    eax, r8w
0x0000E58D: 66410bc3                 or       ax, r11w
0x0000E591: 668945d7                 mov      word ptr [rbp - 0x29], ax
0x0000E595: 448b45d7                 mov      r8d, dword ptr [rbp - 0x29]
0x0000E599: eb04                     jmp      0x18000e59f
0x0000E59B: 0fb745d7                 movzx    eax, word ptr [rbp - 0x29]
0x0000E59F: b900800000               mov      ecx, 0x8000
0x0000E5A4: 663bc1                   cmp      ax, cx
0x0000E5A7: 7710                     ja       0x18000e5b9
0x0000E5A9: 4181e0ffff0100           and      r8d, 0x1ffff
0x0000E5B0: 4181f800800100           cmp      r8d, 0x18000
0x0000E5B7: 7548                     jne      0x18000e601
0x0000E5B9: 8b45d9                   mov      eax, dword ptr [rbp - 0x27]
0x0000E5BC: 83caff                   or       edx, 0xffffffff
0x0000E5BF: 3bc2                     cmp      eax, edx
0x0000E5C1: 7538                     jne      0x18000e5fb
0x0000E5C3: 8b45dd                   mov      eax, dword ptr [rbp - 0x23]
0x0000E5C6: 448965d9                 mov      dword ptr [rbp - 0x27], r12d
0x0000E5CA: 3bc2                     cmp      eax, edx
0x0000E5CC: 7521                     jne      0x18000e5ef
0x0000E5CE: 0fb745e1                 movzx    eax, word ptr [rbp - 0x1f]
0x0000E5D2: 448965dd                 mov      dword ptr [rbp - 0x23], r12d
0x0000E5D6: 663bc3                   cmp      ax, bx
0x0000E5D9: 750a                     jne      0x18000e5e5
0x0000E5DB: 66894de1                 mov      word ptr [rbp - 0x1f], cx
0x0000E5DF: 664503cb                 add      r9w, r11w
0x0000E5E3: eb10                     jmp      0x18000e5f5
0x0000E5E5: 664103c3                 add      ax, r11w
0x0000E5E9: 668945e1                 mov      word ptr [rbp - 0x1f], ax
0x0000E5ED: eb06                     jmp      0x18000e5f5
0x0000E5EF: 4103c3                   add      eax, r11d
0x0000E5F2: 8945dd                   mov      dword ptr [rbp - 0x23], eax
0x0000E5F5: 448b55df                 mov      r10d, dword ptr [rbp - 0x21]
0x0000E5F9: eb06                     jmp      0x18000e601
0x0000E5FB: 4103c3                   add      eax, r11d
0x0000E5FE: 8945d9                   mov      dword ptr [rbp - 0x27], eax
0x0000E601: 41bdff7f0000             mov      r13d, 0x7fff
0x0000E607: 41be05000000             mov      r14d, 5
0x0000E60D: bfffffff7f               mov      edi, 0x7fffffff
0x0000E612: 66453bcd                 cmp      r9w, r13w
0x0000E616: 720d                     jb       0x18000e625
0x0000E618: 0fb74597                 movzx    eax, word ptr [rbp - 0x69]
0x0000E61C: 448b55af                 mov      r10d, dword ptr [rbp - 0x51]
0x0000E620: 66f7d8                   neg      ax
0x0000E623: eb32                     jmp      0x18000e657
0x0000E625: 0fb745d9                 movzx    eax, word ptr [rbp - 0x27]
0x0000E629: 66440b4d97               or       r9w, word ptr [rbp - 0x69]
0x0000E62E: 448955ed                 mov      dword ptr [rbp - 0x13], r10d
0x0000E632: 448b55af                 mov      r10d, dword ptr [rbp - 0x51]
0x0000E636: 668945e7                 mov      word ptr [rbp - 0x19], ax
0x0000E63A: 8b45db                   mov      eax, dword ptr [rbp - 0x25]
0x0000E63D: 8945e9                   mov      dword ptr [rbp - 0x17], eax
0x0000E640: 448b45eb                 mov      r8d, dword ptr [rbp - 0x15]
0x0000E644: 8b55e7                   mov      edx, dword ptr [rbp - 0x19]
0x0000E647: 6644894df1               mov      word ptr [rbp - 0xf], r9w
0x0000E64C: eb23                     jmp      0x18000e671
0x0000E64E: 41bdff7f0000             mov      r13d, 0x7fff
0x0000E654: 66f7db                   neg      bx
0x0000E657: 1bc0                     sbb      eax, eax
0x0000E659: 448965eb                 mov      dword ptr [rbp - 0x15], r12d
0x0000E65D: 4123c7                   and      eax, r15d
0x0000E660: 050080ff7f               add      eax, 0x7fff8000
0x0000E665: 8945ef                   mov      dword ptr [rbp - 0x11], eax
0x0000E668: 418bd4                   mov      edx, r12d
0x0000E66B: 458bc4                   mov      r8d, r12d
0x0000E66E: 8955e7                   mov      dword ptr [rbp - 0x19], edx
0x0000E671: 4c8b4da7                 mov      r9, qword ptr [rbp - 0x59]
0x0000E675: 4585d2                   test     r10d, r10d
0x0000E678: 0f85c2fcffff             jne      0x18000e340
0x0000E67E: 488b5dbf                 mov      rbx, qword ptr [rbp - 0x41]
0x0000E682: 8b4d9f                   mov      ecx, dword ptr [rbp - 0x61]
0x0000E685: befdbf0000               mov      esi, 0xbffd
0x0000E68A: eb07                     jmp      0x18000e693
0x0000E68C: 448b45eb                 mov      r8d, dword ptr [rbp - 0x15]
0x0000E690: 8b55e7                   mov      edx, dword ptr [rbp - 0x19]
0x0000E693: 8b45ef                   mov      eax, dword ptr [rbp - 0x11]
0x0000E696: 41b9ff3f0000             mov      r9d, 0x3fff
0x0000E69C: c1e810                   shr      eax, 0x10
0x0000E69F: 66413bc1                 cmp      ax, r9w
0x0000E6A3: 0f82b6020000             jb       0x18000e95f
0x0000E6A9: 664103cb                 add      cx, r11w
0x0000E6AD: 41b900800000             mov      r9d, 0x8000
0x0000E6B3: 4489659b                 mov      dword ptr [rbp - 0x65], r12d
0x0000E6B7: 458d51ff                 lea      r10d, [r9 - 1]
0x0000E6BB: 894d9f                   mov      dword ptr [rbp - 0x61], ecx
0x0000E6BE: 0fb74d01                 movzx    ecx, word ptr [rbp + 1]
0x0000E6C2: 440fb7e9                 movzx    r13d, cx
0x0000E6C6: 664123ca                 and      cx, r10w
0x0000E6CA: 48c745d700000000         mov      qword ptr [rbp - 0x29], 0
0x0000E6D2: 664433e8                 xor      r13w, ax
0x0000E6D6: 664123c2                 and      ax, r10w
0x0000E6DA: 448965df                 mov      dword ptr [rbp - 0x21], r12d
0x0000E6DE: 664523e9                 and      r13w, r9w
0x0000E6E2: 448d0c08                 lea      r9d, [rax + rcx]
0x0000E6E6: 66413bc2                 cmp      ax, r10w
0x0000E6EA: 0f8358020000             jae      0x18000e948
0x0000E6F0: 66413bca                 cmp      cx, r10w
0x0000E6F4: 0f834e020000             jae      0x18000e948
0x0000E6FA: 66443bce                 cmp      r9w, si
0x0000E6FE: 0f8744020000             ja       0x18000e948
0x0000E704: 41babf3f0000             mov      r10d, 0x3fbf
0x0000E70A: 66453bca                 cmp      r9w, r10w
0x0000E70E: 7709                     ja       0x18000e719
0x0000E710: 448965ef                 mov      dword ptr [rbp - 0x11], r12d
0x0000E714: e940020000               jmp      0x18000e959
0x0000E719: 6685c0                   test     ax, ax
0x0000E71C: 751c                     jne      0x18000e73a
0x0000E71E: 664503cb                 add      r9w, r11w
0x0000E722: 857def                   test     dword ptr [rbp - 0x11], edi
0x0000E725: 7513                     jne      0x18000e73a
0x0000E727: 4585c0                   test     r8d, r8d
0x0000E72A: 750e                     jne      0x18000e73a
0x0000E72C: 85d2                     test     edx, edx
0x0000E72E: 750a                     jne      0x18000e73a
0x0000E730: 66448965f1               mov      word ptr [rbp - 0xf], r12w
0x0000E735: e925020000               jmp      0x18000e95f
0x0000E73A: 6685c9                   test     cx, cx
0x0000E73D: 7515                     jne      0x18000e754
0x0000E73F: 664503cb                 add      r9w, r11w
0x0000E743: 857dff                   test     dword ptr [rbp - 1], edi
0x0000E746: 750c                     jne      0x18000e754
0x0000E748: 443965fb                 cmp      dword ptr [rbp - 5], r12d
0x0000E74C: 7506                     jne      0x18000e754
0x0000E74E: 443965f7                 cmp      dword ptr [rbp - 9], r12d
0x0000E752: 74bc                     je       0x18000e710
0x0000E754: 418bfc                   mov      edi, r12d
0x0000E757: 488d55d7                 lea      rdx, [rbp - 0x29]
0x0000E75B: 418bf6                   mov      esi, r14d
0x0000E75E: 4585f6                   test     r14d, r14d
0x0000E761: 7e5d                     jle      0x18000e7c0
0x0000E763: 8d043f                   lea      eax, [rdi + rdi]
0x0000E766: 4c8d7de7                 lea      r15, [rbp - 0x19]
0x0000E76A: 448be7                   mov      r12d, edi
0x0000E76D: 4863c8                   movsxd   rcx, eax
0x0000E770: 4523e3                   and      r12d, r11d
0x0000E773: 4c8d75ff                 lea      r14, [rbp - 1]
0x0000E777: 4c03f9                   add      r15, rcx
0x0000E77A: 33db                     xor      ebx, ebx
0x0000E77C: 410fb707                 movzx    eax, word ptr [r15]
0x0000E780: 410fb70e                 movzx    ecx, word ptr [r14]
0x0000E784: 448bc3                   mov      r8d, ebx
0x0000E787: 0fafc8                   imul     ecx, eax
0x0000E78A: 8b02                     mov      eax, dword ptr [rdx]
0x0000E78C: 448d1408                 lea      r10d, [rax + rcx]
0x0000E790: 443bd0                   cmp      r10d, eax
0x0000E793: 7205                     jb       0x18000e79a
0x0000E795: 443bd1                   cmp      r10d, ecx
0x0000E798: 7303                     jae      0x18000e79d
0x0000E79A: 458bc3                   mov      r8d, r11d
0x0000E79D: 448912                   mov      dword ptr [rdx], r10d
0x0000E7A0: 4585c0                   test     r8d, r8d
0x0000E7A3: 7405                     je       0x18000e7aa
0x0000E7A5: 6644015a04               add      word ptr [rdx + 4], r11w
0x0000E7AA: 412bf3                   sub      esi, r11d
0x0000E7AD: 4983c702                 add      r15, 2
0x0000E7B1: 4983ee02                 sub      r14, 2
0x0000E7B5: 85f6                     test     esi, esi
0x0000E7B7: 7fc3                     jg       0x18000e77c
0x0000E7B9: 448b75b7                 mov      r14d, dword ptr [rbp - 0x49]
0x0000E7BD: 4533e4                   xor      r12d, r12d
0x0000E7C0: 452bf3                   sub      r14d, r11d
0x0000E7C3: 4883c202                 add      rdx, 2
0x0000E7C7: 4103fb                   add      edi, r11d
0x0000E7CA: 448975b7                 mov      dword ptr [rbp - 0x49], r14d
0x0000E7CE: 4585f6                   test     r14d, r14d
0x0000E7D1: 7f88                     jg       0x18000e75b
0x0000E7D3: 488b5dbf                 mov      rbx, qword ptr [rbp - 0x41]
0x0000E7D7: 448b45df                 mov      r8d, dword ptr [rbp - 0x21]
0x0000E7DB: 448b55d7                 mov      r10d, dword ptr [rbp - 0x29]
0x0000E7DF: b802c00000               mov      eax, 0xc002
0x0000E7E4: be00000080               mov      esi, 0x80000000
0x0000E7E9: 41beffff0000             mov      r14d, 0xffff
0x0000E7EF: 664403c8                 add      r9w, ax
0x0000E7F3: 664585c9                 test     r9w, r9w
0x0000E7F7: 7e3c                     jle      0x18000e835
0x0000E7F9: 4485c6                   test     esi, r8d
0x0000E7FC: 7531                     jne      0x18000e82f
0x0000E7FE: 8b7ddb                   mov      edi, dword ptr [rbp - 0x25]
0x0000E801: 418bd2                   mov      edx, r10d
0x0000E804: 4503c0                   add      r8d, r8d
0x0000E807: c1ea1f                   shr      edx, 0x1f
0x0000E80A: 4503d2                   add      r10d, r10d
0x0000E80D: 8bcf                     mov      ecx, edi
0x0000E80F: c1e91f                   shr      ecx, 0x1f
0x0000E812: 8d043f                   lea      eax, [rdi + rdi]
0x0000E815: 664503ce                 add      r9w, r14w
0x0000E819: 0bc2                     or       eax, edx
0x0000E81B: 440bc1                   or       r8d, ecx
0x0000E81E: 448955d7                 mov      dword ptr [rbp - 0x29], r10d
0x0000E822: 8945db                   mov      dword ptr [rbp - 0x25], eax
0x0000E825: 448945df                 mov      dword ptr [rbp - 0x21], r8d
0x0000E829: 664585c9                 test     r9w, r9w
0x0000E82D: 7fca                     jg       0x18000e7f9
0x0000E82F: 664585c9                 test     r9w, r9w
0x0000E833: 7f65                     jg       0x18000e89a
0x0000E835: 664503ce                 add      r9w, r14w
0x0000E839: 795f                     jns      0x18000e89a
0x0000E83B: 8b5d9b                   mov      ebx, dword ptr [rbp - 0x65]
0x0000E83E: 410fb7c1                 movzx    eax, r9w
0x0000E842: 66f7d8                   neg      ax
0x0000E845: 0fb7d0                   movzx    edx, ax
0x0000E848: 664403ca                 add      r9w, dx
0x0000E84C: 44845dd7                 test     byte ptr [rbp - 0x29], r11b
0x0000E850: 7403                     je       0x18000e855
0x0000E852: 4103db                   add      ebx, r11d
0x0000E855: 8b7ddb                   mov      edi, dword ptr [rbp - 0x25]
0x0000E858: 418bc0                   mov      eax, r8d
0x0000E85B: 41d1ea                   shr      r10d, 1
0x0000E85E: 8bcf                     mov      ecx, edi
0x0000E860: c1e01f                   shl      eax, 0x1f
0x0000E863: d1ef                     shr      edi, 1
0x0000E865: c1e11f                   shl      ecx, 0x1f
0x0000E868: 0bf8                     or       edi, eax
0x0000E86A: 41d1e8                   shr      r8d, 1
0x0000E86D: 440bd1                   or       r10d, ecx
0x0000E870: 897ddb                   mov      dword ptr [rbp - 0x25], edi
0x0000E873: 448955d7                 mov      dword ptr [rbp - 0x29], r10d
0x0000E877: 492bd3                   sub      rdx, r11
0x0000E87A: 75d0                     jne      0x18000e84c
0x0000E87C: 85db                     test     ebx, ebx
0x0000E87E: 488b5dbf                 mov      rbx, qword ptr [rbp - 0x41]
0x0000E882: 448945df                 mov      dword ptr [rbp - 0x21], r8d
0x0000E886: 7412                     je       0x18000e89a
0x0000E888: 410fb7c2                 movzx    eax, r10w
0x0000E88C: 66410bc3                 or       ax, r11w
0x0000E890: 668945d7                 mov      word ptr [rbp - 0x29], ax
0x0000E894: 448b55d7                 mov      r10d, dword ptr [rbp - 0x29]
0x0000E898: eb04                     jmp      0x18000e89e
0x0000E89A: 0fb745d7                 movzx    eax, word ptr [rbp - 0x29]
0x0000E89E: b900800000               mov      ecx, 0x8000
0x0000E8A3: 663bc1                   cmp      ax, cx
0x0000E8A6: 7710                     ja       0x18000e8b8
0x0000E8A8: 4181e2ffff0100           and      r10d, 0x1ffff
0x0000E8AF: 4181fa00800100           cmp      r10d, 0x18000
0x0000E8B6: 7549                     jne      0x18000e901
0x0000E8B8: 8b45d9                   mov      eax, dword ptr [rbp - 0x27]
0x0000E8BB: 83caff                   or       edx, 0xffffffff
0x0000E8BE: 3bc2                     cmp      eax, edx
0x0000E8C0: 7539                     jne      0x18000e8fb
0x0000E8C2: 8b45dd                   mov      eax, dword ptr [rbp - 0x23]
0x0000E8C5: 448965d9                 mov      dword ptr [rbp - 0x27], r12d
0x0000E8C9: 3bc2                     cmp      eax, edx
0x0000E8CB: 7522                     jne      0x18000e8ef
0x0000E8CD: 0fb745e1                 movzx    eax, word ptr [rbp - 0x1f]
0x0000E8D1: 448965dd                 mov      dword ptr [rbp - 0x23], r12d
0x0000E8D5: 66413bc6                 cmp      ax, r14w
0x0000E8D9: 750a                     jne      0x18000e8e5
0x0000E8DB: 66894de1                 mov      word ptr [rbp - 0x1f], cx
0x0000E8DF: 664503cb                 add      r9w, r11w
0x0000E8E3: eb10                     jmp      0x18000e8f5
0x0000E8E5: 664103c3                 add      ax, r11w
0x0000E8E9: 668945e1                 mov      word ptr [rbp - 0x1f], ax
0x0000E8ED: eb06                     jmp      0x18000e8f5
0x0000E8EF: 4103c3                   add      eax, r11d
0x0000E8F2: 8945dd                   mov      dword ptr [rbp - 0x23], eax
0x0000E8F5: 448b45df                 mov      r8d, dword ptr [rbp - 0x21]
0x0000E8F9: eb06                     jmp      0x18000e901
0x0000E8FB: 4103c3                   add      eax, r11d
0x0000E8FE: 8945d9                   mov      dword ptr [rbp - 0x27], eax
0x0000E901: b8ff7f0000               mov      eax, 0x7fff
0x0000E906: 66443bc8                 cmp      r9w, ax
0x0000E90A: 7218                     jb       0x18000e924
0x0000E90C: 6641f7dd                 neg      r13w
0x0000E910: 458bc4                   mov      r8d, r12d
0x0000E913: 418bd4                   mov      edx, r12d
0x0000E916: 1bc0                     sbb      eax, eax
0x0000E918: 23c6                     and      eax, esi
0x0000E91A: 050080ff7f               add      eax, 0x7fff8000
0x0000E91F: 8945ef                   mov      dword ptr [rbp - 0x11], eax
0x0000E922: eb40                     jmp      0x18000e964
0x0000E924: 0fb745d9                 movzx    eax, word ptr [rbp - 0x27]
0x0000E928: 66450bcd                 or       r9w, r13w
0x0000E92C: 448945ed                 mov      dword ptr [rbp - 0x13], r8d
0x0000E930: 668945e7                 mov      word ptr [rbp - 0x19], ax
0x0000E934: 8b45db                   mov      eax, dword ptr [rbp - 0x25]
0x0000E937: 6644894df1               mov      word ptr [rbp - 0xf], r9w
0x0000E93C: 8945e9                   mov      dword ptr [rbp - 0x17], eax
0x0000E93F: 448b45eb                 mov      r8d, dword ptr [rbp - 0x15]
0x0000E943: 8b55e7                   mov      edx, dword ptr [rbp - 0x19]
0x0000E946: eb1c                     jmp      0x18000e964
0x0000E948: 6641f7dd                 neg      r13w
0x0000E94C: 1bc0                     sbb      eax, eax
0x0000E94E: 4123c7                   and      eax, r15d
0x0000E951: 050080ff7f               add      eax, 0x7fff8000
0x0000E956: 8945ef                   mov      dword ptr [rbp - 0x11], eax
0x0000E959: 418bd4                   mov      edx, r12d
0x0000E95C: 458bc4                   mov      r8d, r12d
0x0000E95F: b900800000               mov      ecx, 0x8000
0x0000E964: 8b459f                   mov      eax, dword ptr [rbp - 0x61]
0x0000E967: 448b75b3                 mov      r14d, dword ptr [rbp - 0x4d]
0x0000E96B: 668903                   mov      word ptr [rbx], ax
0x0000E96E: 44845dc7                 test     byte ptr [rbp - 0x39], r11b
0x0000E972: 741d                     je       0x18000e991
0x0000E974: 98                       cwde     
0x0000E975: 4403f0                   add      r14d, eax
0x0000E978: 4585f6                   test     r14d, r14d
0x0000E97B: 7f14                     jg       0x18000e991
0x0000E97D: 66394d99                 cmp      word ptr [rbp - 0x67], cx
0x0000E981: b820000000               mov      eax, 0x20
0x0000E986: 8d480d                   lea      ecx, [rax + 0xd]
0x0000E989: 0f44c1                   cmove    eax, ecx
0x0000E98C: e93cf8ffff               jmp      0x18000e1cd
0x0000E991: 448b4def                 mov      r9d, dword ptr [rbp - 0x11]
0x0000E995: b815000000               mov      eax, 0x15
0x0000E99A: 66448965f1               mov      word ptr [rbp - 0xf], r12w
0x0000E99F: 8b75ef                   mov      esi, dword ptr [rbp - 0x11]
0x0000E9A2: 443bf0                   cmp      r14d, eax
0x0000E9A5: 448d50f3                 lea      r10d, [rax - 0xd]
0x0000E9A9: 440f4ff0                 cmovg    r14d, eax
0x0000E9AD: 41c1e910                 shr      r9d, 0x10
0x0000E9B1: 4181e9fe3f0000           sub      r9d, 0x3ffe
0x0000E9B8: 418bc8                   mov      ecx, r8d
0x0000E9BB: 8bc2                     mov      eax, edx
0x0000E9BD: 03f6                     add      esi, esi
0x0000E9BF: 4503c0                   add      r8d, r8d
0x0000E9C2: c1e81f                   shr      eax, 0x1f
0x0000E9C5: c1e91f                   shr      ecx, 0x1f
0x0000E9C8: 440bc0                   or       r8d, eax
0x0000E9CB: 0bf1                     or       esi, ecx
0x0000E9CD: 03d2                     add      edx, edx
0x0000E9CF: 4d2bd3                   sub      r10, r11
0x0000E9D2: 75e4                     jne      0x18000e9b8
0x0000E9D4: 448945eb                 mov      dword ptr [rbp - 0x15], r8d
0x0000E9D8: 8955e7                   mov      dword ptr [rbp - 0x19], edx
0x0000E9DB: 4585c9                   test     r9d, r9d
0x0000E9DE: 7932                     jns      0x18000ea12
0x0000E9E0: 41f7d9                   neg      r9d
0x0000E9E3: 450fb6d1                 movzx    r10d, r9b
0x0000E9E7: 4585d2                   test     r10d, r10d
0x0000E9EA: 7e26                     jle      0x18000ea12
0x0000E9EC: 418bc8                   mov      ecx, r8d
0x0000E9EF: 8bc6                     mov      eax, esi
0x0000E9F1: d1ea                     shr      edx, 1
0x0000E9F3: 41d1e8                   shr      r8d, 1
0x0000E9F6: c1e01f                   shl      eax, 0x1f
0x0000E9F9: c1e11f                   shl      ecx, 0x1f
0x0000E9FC: 452bd3                   sub      r10d, r11d
0x0000E9FF: d1ee                     shr      esi, 1
0x0000EA01: 440bc0                   or       r8d, eax
0x0000EA04: 0bd1                     or       edx, ecx
0x0000EA06: 4585d2                   test     r10d, r10d
0x0000EA09: 7fe1                     jg       0x18000e9ec
0x0000EA0B: 448945eb                 mov      dword ptr [rbp - 0x15], r8d
0x0000EA0F: 8955e7                   mov      dword ptr [rbp - 0x19], edx
0x0000EA12: 458d7e01                 lea      r15d, [r14 + 1]
0x0000EA16: 488d7b04                 lea      rdi, [rbx + 4]
0x0000EA1A: 4c8bd7                   mov      r10, rdi
0x0000EA1D: 4585ff                   test     r15d, r15d
0x0000EA20: 0f8ed4000000             jle      0x18000eafa
0x0000EA26: f20f1045e7               movsd    xmm0, qword ptr [rbp - 0x19]
0x0000EA2B: 418bc8                   mov      ecx, r8d
0x0000EA2E: 4503c0                   add      r8d, r8d
0x0000EA31: c1e91f                   shr      ecx, 0x1f
0x0000EA34: 8bc2                     mov      eax, edx
0x0000EA36: 03d2                     add      edx, edx
0x0000EA38: c1e81f                   shr      eax, 0x1f
0x0000EA3B: 448d0c36                 lea      r9d, [rsi + rsi]
0x0000EA3F: f20f114507               movsd    qword ptr [rbp + 7], xmm0
0x0000EA44: 440bc0                   or       r8d, eax
0x0000EA47: 440bc9                   or       r9d, ecx
0x0000EA4A: 8bc2                     mov      eax, edx
0x0000EA4C: 418bc8                   mov      ecx, r8d
0x0000EA4F: c1e81f                   shr      eax, 0x1f
0x0000EA52: 4503c0                   add      r8d, r8d
0x0000EA55: 440bc0                   or       r8d, eax
0x0000EA58: 8b4507                   mov      eax, dword ptr [rbp + 7]
0x0000EA5B: 03d2                     add      edx, edx
0x0000EA5D: c1e91f                   shr      ecx, 0x1f
0x0000EA60: 4503c9                   add      r9d, r9d
0x0000EA63: 448d2410                 lea      r12d, [rax + rdx]
0x0000EA67: 440bc9                   or       r9d, ecx
0x0000EA6A: 443be2                   cmp      r12d, edx
0x0000EA6D: 7205                     jb       0x18000ea74
0x0000EA6F: 443be0                   cmp      r12d, eax
0x0000EA72: 7321                     jae      0x18000ea95
0x0000EA74: 4533f6                   xor      r14d, r14d
0x0000EA77: 418d4001                 lea      eax, [r8 + 1]
0x0000EA7B: 418bce                   mov      ecx, r14d
0x0000EA7E: 413bc0                   cmp      eax, r8d
0x0000EA81: 7205                     jb       0x18000ea88
0x0000EA83: 413bc3                   cmp      eax, r11d
0x0000EA86: 7303                     jae      0x18000ea8b
0x0000EA88: 418bcb                   mov      ecx, r11d
0x0000EA8B: 448bc0                   mov      r8d, eax
0x0000EA8E: 85c9                     test     ecx, ecx
0x0000EA90: 7403                     je       0x18000ea95
0x0000EA92: 4503cb                   add      r9d, r11d
0x0000EA95: 488b4507                 mov      rax, qword ptr [rbp + 7]
0x0000EA99: 48c1e820                 shr      rax, 0x20
0x0000EA9D: 458d3400                 lea      r14d, [r8 + rax]
0x0000EAA1: 453bf0                   cmp      r14d, r8d
0x0000EAA4: 7205                     jb       0x18000eaab
0x0000EAA6: 443bf0                   cmp      r14d, eax
0x0000EAA9: 7303                     jae      0x18000eaae
0x0000EAAB: 4503cb                   add      r9d, r11d
0x0000EAAE: 418bc4                   mov      eax, r12d
0x0000EAB1: 4403ce                   add      r9d, esi
0x0000EAB4: 438d1424                 lea      edx, [r12 + r12]
0x0000EAB8: c1e81f                   shr      eax, 0x1f
0x0000EABB: 4533e4                   xor      r12d, r12d
0x0000EABE: 478d0436                 lea      r8d, [r14 + r14]
0x0000EAC2: 440bc0                   or       r8d, eax
0x0000EAC5: 418bce                   mov      ecx, r14d
0x0000EAC8: 438d0409                 lea      eax, [r9 + r9]
0x0000EACC: c1e91f                   shr      ecx, 0x1f
0x0000EACF: 452bfb                   sub      r15d, r11d
0x0000EAD2: 8955e7                   mov      dword ptr [rbp - 0x19], edx
0x0000EAD5: 0bc1                     or       eax, ecx
0x0000EAD7: 448945eb                 mov      dword ptr [rbp - 0x15], r8d
0x0000EADB: 8945ef                   mov      dword ptr [rbp - 0x11], eax
0x0000EADE: c1e818                   shr      eax, 0x18
0x0000EAE1: 448865f2                 mov      byte ptr [rbp - 0xe], r12b
0x0000EAE5: 0430                     add      al, 0x30
0x0000EAE7: 418802                   mov      byte ptr [r10], al
0x0000EAEA: 4d03d3                   add      r10, r11
0x0000EAED: 4585ff                   test     r15d, r15d
0x0000EAF0: 7e08                     jle      0x18000eafa
0x0000EAF2: 8b75ef                   mov      esi, dword ptr [rbp - 0x11]
0x0000EAF5: e92cffffff               jmp      0x18000ea26
0x0000EAFA: 4d2bd3                   sub      r10, r11
0x0000EAFD: 418a02                   mov      al, byte ptr [r10]
0x0000EB00: 4d2bd3                   sub      r10, r11
0x0000EB03: 3c35                     cmp      al, 0x35
0x0000EB05: 7c6a                     jl       0x18000eb71
0x0000EB07: eb0d                     jmp      0x18000eb16
0x0000EB09: 41803a39                 cmp      byte ptr [r10], 0x39
0x0000EB0D: 750c                     jne      0x18000eb1b
0x0000EB0F: 41c60230                 mov      byte ptr [r10], 0x30
0x0000EB13: 4d2bd3                   sub      r10, r11
0x0000EB16: 4c3bd7                   cmp      r10, rdi
0x0000EB19: 73ee                     jae      0x18000eb09
0x0000EB1B: 4c3bd7                   cmp      r10, rdi
0x0000EB1E: 7307                     jae      0x18000eb27
0x0000EB20: 4d03d3                   add      r10, r11
0x0000EB23: 6644011b                 add      word ptr [rbx], r11w
0x0000EB27: 45001a                   add      byte ptr [r10], r11b
0x0000EB2A: 442ad3                   sub      r10b, bl
0x0000EB2D: 4180ea03                 sub      r10b, 3
0x0000EB31: 490fbec2                 movsx    rax, r10b
0x0000EB35: 44885303                 mov      byte ptr [rbx + 3], r10b
0x0000EB39: 4488641804               mov      byte ptr [rax + rbx + 4], r12b
0x0000EB3E: 418bc3                   mov      eax, r11d
0x0000EB41: 488b4d17                 mov      rcx, qword ptr [rbp + 0x17]
0x0000EB45: 4833cc                   xor      rcx, rsp
0x0000EB48: e8c32cffff               call     0x180001810
0x0000EB4D: 488b9c2408010000         mov      rbx, qword ptr [rsp + 0x108]
0x0000EB55: 4881c4c0000000           add      rsp, 0xc0
0x0000EB5C: 415f                     pop      r15
0x0000EB5E: 415e                     pop      r14
0x0000EB60: 415d                     pop      r13
0x0000EB62: 415c                     pop      r12
0x0000EB64: 5f                       pop      rdi
0x0000EB65: 5e                       pop      rsi
0x0000EB66: 5d                       pop      rbp
0x0000EB67: c3                       ret      
0x0000EB68: 41803a30                 cmp      byte ptr [r10], 0x30
0x0000EB6C: 7508                     jne      0x18000eb76
0x0000EB6E: 4d2bd3                   sub      r10, r11
0x0000EB71: 4c3bd7                   cmp      r10, rdi
0x0000EB74: 73f2                     jae      0x18000eb68
0x0000EB76: 4c3bd7                   cmp      r10, rdi
0x0000EB79: 73af                     jae      0x18000eb2a
0x0000EB7B: b820000000               mov      eax, 0x20
0x0000EB80: 41b900800000             mov      r9d, 0x8000
0x0000EB86: 66448923                 mov      word ptr [rbx], r12w
0x0000EB8A: 6644394d99               cmp      word ptr [rbp - 0x67], r9w
0x0000EB8F: 8d480d                   lea      ecx, [rax + 0xd]
0x0000EB92: 44885b03                 mov      byte ptr [rbx + 3], r11b
0x0000EB96: 0f44c1                   cmove    eax, ecx
0x0000EB99: 884302                   mov      byte ptr [rbx + 2], al
0x0000EB9C: c60730                   mov      byte ptr [rdi], 0x30
0x0000EB9F: e936f6ffff               jmp      0x18000e1da
0x0000EBA4: 4533c9                   xor      r9d, r9d
0x0000EBA7: 4533c0                   xor      r8d, r8d
0x0000EBAA: 33d2                     xor      edx, edx
0x0000EBAC: 33c9                     xor      ecx, ecx
0x0000EBAE: 4c89642420               mov      qword ptr [rsp + 0x20], r12
0x0000EBB3: e80c4dffff               call     0x1800038c4
0x0000EBB8: cc                       int3     
0x0000EBB9: 4533c9                   xor      r9d, r9d
0x0000EBBC: 4533c0                   xor      r8d, r8d
0x0000EBBF: 33d2                     xor      edx, edx
0x0000EBC1: 33c9                     xor      ecx, ecx
0x0000EBC3: 4c89642420               mov      qword ptr [rsp + 0x20], r12
0x0000EBC8: e8f74cffff               call     0x1800038c4
0x0000EBCD: cc                       int3     
0x0000EBCE: 4533c9                   xor      r9d, r9d
0x0000EBD1: 4533c0                   xor      r8d, r8d
0x0000EBD4: 33d2                     xor      edx, edx
0x0000EBD6: 33c9                     xor      ecx, ecx
0x0000EBD8: 4c89642420               mov      qword ptr [rsp + 0x20], r12
0x0000EBDD: e8e24cffff               call     0x1800038c4
0x0000EBE2: cc                       int3     
0x0000EBE3: 4533c9                   xor      r9d, r9d
0x0000EBE6: 4533c0                   xor      r8d, r8d
0x0000EBE9: 33d2                     xor      edx, edx
0x0000EBEB: 33c9                     xor      ecx, ecx
0x0000EBED: 4c89642420               mov      qword ptr [rsp + 0x20], r12
0x0000EBF2: e8cd4cffff               call     0x1800038c4
0x0000EBF7: cc                       int3     
0x0000EBF8: e8d4ee1900               call     0x1801adad1
0x0000EBFD: 90                       nop      
0x0000EBFE: e8fbc91200               call     0x18013b5fe
0x0000EC03: fecc                     dec      ah
0x0000EC05: cc                       int3     
0x0000EC06: cc                       int3     
0x0000EC07: cc                       int3     
0x0000EC08: cc                       int3     
0x0000EC09: cc                       int3     
0x0000EC0A: cc                       int3     
0x0000EC0B: cc                       int3     
0x0000EC0C: cc                       int3     
0x0000EC0D: cc                       int3     
0x0000EC0E: cc                       int3     
0x0000EC0F: cc                       int3     
0x0000EC10: 4055                     push     rbp
0x0000EC12: 4883ec20                 sub      rsp, 0x20
0x0000EC16: 488bea                   mov      rbp, rdx
0x0000EC19: 4883c420                 add      rsp, 0x20
0x0000EC1D: 5d                       pop      rbp
0x0000EC1E: e9cd40ffff               jmp      0x180002cf0
0x0000EC23: cc                       int3     
0x0000EC24: 4055                     push     rbp
0x0000EC26: 4883ec20                 sub      rsp, 0x20
0x0000EC2A: 488bea                   mov      rbp, rdx
0x0000EC2D: 48837d4000               cmp      qword ptr [rbp + 0x40], 0
0x0000EC32: 750f                     jne      0x18000ec43
0x0000EC34: 833d55850000ff           cmp      dword ptr [rip + 0x8555], -1
0x0000EC3B: 7406                     je       0x18000ec43
0x0000EC3D: e83258ffff               call     0x180004474
0x0000EC42: 90                       nop      
0x0000EC43: 4883c420                 add      rsp, 0x20
0x0000EC47: 5d                       pop      rbp
0x0000EC48: c3                       ret      
0x0000EC49: cc                       int3     
0x0000EC4A: 4055                     push     rbp
0x0000EC4C: 4883ec20                 sub      rsp, 0x20
0x0000EC50: 488bea                   mov      rbp, rdx
0x0000EC53: 48894d40                 mov      qword ptr [rbp + 0x40], rcx
0x0000EC57: 488b01                   mov      rax, qword ptr [rcx]
0x0000EC5A: 8b10                     mov      edx, dword ptr [rax]
0x0000EC5C: 895530                   mov      dword ptr [rbp + 0x30], edx
0x0000EC5F: 48894d38                 mov      qword ptr [rbp + 0x38], rcx
0x0000EC63: 895528                   mov      dword ptr [rbp + 0x28], edx
0x0000EC66: 837d7801                 cmp      dword ptr [rbp + 0x78], 1
0x0000EC6A: 7513                     jne      0x18000ec7f
0x0000EC6C: 4c8b8580000000           mov      r8, qword ptr [rbp + 0x80]
0x0000EC73: 33d2                     xor      edx, edx
0x0000EC75: 488b4d70                 mov      rcx, qword ptr [rbp + 0x70]
0x0000EC79: e8f632ffff               call     0x180001f74
0x0000EC7E: 90                       nop      
0x0000EC7F: 488b5538                 mov      rdx, qword ptr [rbp + 0x38]
0x0000EC83: 8b4d28                   mov      ecx, dword ptr [rbp + 0x28]
0x0000EC86: e87954ffff               call     0x180004104
0x0000EC8B: 90                       nop      
0x0000EC8C: 4883c420                 add      rsp, 0x20
0x0000EC90: 5d                       pop      rbp
0x0000EC91: c3                       ret      
0x0000EC92: cc                       int3     
0x0000EC93: 4055                     push     rbp
0x0000EC95: 4883ec20                 sub      rsp, 0x20
0x0000EC99: 488bea                   mov      rbp, rdx
0x0000EC9C: 83bd8000000000           cmp      dword ptr [rbp + 0x80], 0
0x0000ECA3: 740b                     je       0x18000ecb0
0x0000ECA5: b908000000               mov      ecx, 8
0x0000ECAA: e8e16fffff               call     0x180005c90
0x0000ECAF: 90                       nop      
0x0000ECB0: 4883c420                 add      rsp, 0x20
0x0000ECB4: 5d                       pop      rbp
0x0000ECB5: c3                       ret      
0x0000ECB6: cc                       int3     
0x0000ECB7: 4055                     push     rbp
0x0000ECB9: 4883ec20                 sub      rsp, 0x20
0x0000ECBD: 488bea                   mov      rbp, rdx
0x0000ECC0: b90d000000               mov      ecx, 0xd
0x0000ECC5: 4883c420                 add      rsp, 0x20
0x0000ECC9: 5d                       pop      rbp
0x0000ECCA: e9c16fffff               jmp      0x180005c90
0x0000ECCF: cc                       int3     
0x0000ECD0: 4055                     push     rbp
0x0000ECD2: 4883ec20                 sub      rsp, 0x20
0x0000ECD6: 488bea                   mov      rbp, rdx
0x0000ECD9: b90c000000               mov      ecx, 0xc
0x0000ECDE: 4883c420                 add      rsp, 0x20
0x0000ECE2: 5d                       pop      rbp
0x0000ECE3: e9a86fffff               jmp      0x180005c90
0x0000ECE8: cc                       int3     
0x0000ECE9: 4055                     push     rbp
0x0000ECEB: 4883ec20                 sub      rsp, 0x20
0x0000ECEF: 488bea                   mov      rbp, rdx
0x0000ECF2: b90b000000               mov      ecx, 0xb
0x0000ECF7: e8946fffff               call     0x180005c90
0x0000ECFC: 90                       nop      
0x0000ECFD: 4883c420                 add      rsp, 0x20
0x0000ED01: 5d                       pop      rbp
0x0000ED02: c3                       ret      
0x0000ED03: cc                       int3     
0x0000ED04: 4055                     push     rbp
0x0000ED06: 4883ec20                 sub      rsp, 0x20
0x0000ED0A: 488bea                   mov      rbp, rdx
0x0000ED0D: 488b0d8c850000           mov      rcx, qword ptr [rip + 0x858c]
0x0000ED14: 4883c420                 add      rsp, 0x20
0x0000ED18: 5d                       pop      rbp
0x0000ED19: 4852                     push     rdx
0x0000ED1B: e89025ffff               call     0x1800012b0
0x0000ED20: cc                       int3     
0x0000ED21: cc                       int3     
0x0000ED22: cc                       int3     
0x0000ED23: cc                       int3     
0x0000ED24: cc                       int3     
0x0000ED25: cc                       int3     
0x0000ED26: cc                       int3     
0x0000ED27: cc                       int3     
0x0000ED28: cc                       int3     
0x0000ED29: cc                       int3     
0x0000ED2A: cc                       int3     
0x0000ED2B: cc                       int3     
0x0000ED2C: cc                       int3     
0x0000ED2D: cc                       int3     
0x0000ED2E: cc                       int3     
0x0000ED2F: cc                       int3     
0x0000ED30: 4055                     push     rbp
0x0000ED32: 4883ec20                 sub      rsp, 0x20
0x0000ED36: 488bea                   mov      rbp, rdx
0x0000ED39: 488b01                   mov      rax, qword ptr [rcx]
0x0000ED3C: 33c9                     xor      ecx, ecx
0x0000ED3E: 8138050000c0             cmp      dword ptr [rax], 0xc0000005
0x0000ED44: 0f94c1                   sete     cl
0x0000ED47: 8bc1                     mov      eax, ecx
0x0000ED49: 4883c420                 add      rsp, 0x20
0x0000ED4D: 5d                       pop      rbp
0x0000ED4E: c3                       ret      
0x0000ED4F: cc                       int3     
0x0000ED50: 4055                     push     rbp
0x0000ED52: 4883ec20                 sub      rsp, 0x20
0x0000ED56: 488bea                   mov      rbp, rdx
0x0000ED59: 837d6000                 cmp      dword ptr [rbp + 0x60], 0
0x0000ED5D: 7408                     je       0x18000ed67
0x0000ED5F: 33c9                     xor      ecx, ecx
0x0000ED61: e82a6fffff               call     0x180005c90
0x0000ED66: 90                       nop      
0x0000ED67: 4883c420                 add      rsp, 0x20
0x0000ED6B: 5d                       pop      rbp
0x0000ED6C: c3                       ret      
0x0000ED6D: cc                       int3     
0x0000ED6E: 4055                     push     rbp
0x0000ED70: 4883ec20                 sub      rsp, 0x20
0x0000ED74: 488bea                   mov      rbp, rdx
0x0000ED77: b90d000000               mov      ecx, 0xd
0x0000ED7C: 4883c420                 add      rsp, 0x20
0x0000ED80: 5d                       pop      rbp
0x0000ED81: e90a6fffff               jmp      0x180005c90
0x0000ED86: cc                       int3     
0x0000ED87: 4055                     push     rbp
0x0000ED89: 4883ec20                 sub      rsp, 0x20
0x0000ED8D: 488bea                   mov      rbp, rdx
0x0000ED90: b906000000               mov      ecx, 6
0x0000ED95: 4883c420                 add      rsp, 0x20
0x0000ED99: 5d                       pop      rbp
0x0000ED9A: e9f16effff               jmp      0x180005c90
0x0000ED9F: cc                       int3     
0x0000EDA0: 4055                     push     rbp
0x0000EDA2: 4883ec40                 sub      rsp, 0x40
0x0000EDA6: 488bea                   mov      rbp, rdx
0x0000EDA9: b907000000               mov      ecx, 7
0x0000EDAE: e8dd6effff               call     0x180005c90
0x0000EDB3: 90                       nop      
0x0000EDB4: 4883c440                 add      rsp, 0x40
0x0000EDB8: 5d                       pop      rbp
0x0000EDB9: c3                       ret      
0x0000EDBA: cc                       int3     
0x0000EDBB: 4055                     push     rbp
0x0000EDBD: 4883ec20                 sub      rsp, 0x20
0x0000EDC1: 488bea                   mov      rbp, rdx
0x0000EDC4: b90c000000               mov      ecx, 0xc
0x0000EDC9: 4883c420                 add      rsp, 0x20
0x0000EDCD: 5d                       pop      rbp
0x0000EDCE: e9bd6effff               jmp      0x180005c90
0x0000EDD3: cc                       int3     
0x0000EDD4: 4055                     push     rbp
0x0000EDD6: 4883ec20                 sub      rsp, 0x20
0x0000EDDA: 488bea                   mov      rbp, rdx
0x0000EDDD: 48634d20                 movsxd   rcx, dword ptr [rbp + 0x20]
0x0000EDE1: 488bc1                   mov      rax, rcx
0x0000EDE4: 488b154dd80000           mov      rdx, qword ptr [rip + 0xd84d]
0x0000EDEB: 488b14ca                 mov      rdx, qword ptr [rdx + rcx*8]
0x0000EDEF: e8b492ffff               call     0x1800080a8
0x0000EDF4: 90                       nop      
0x0000EDF5: 4883c420                 add      rsp, 0x20
0x0000EDF9: 5d                       pop      rbp
0x0000EDFA: c3                       ret      
0x0000EDFB: cc                       int3     
0x0000EDFC: 4055                     push     rbp
0x0000EDFE: 4883ec20                 sub      rsp, 0x20
0x0000EE02: 488bea                   mov      rbp, rdx
0x0000EE05: b901000000               mov      ecx, 1
0x0000EE0A: 4883c420                 add      rsp, 0x20
0x0000EE0E: 5d                       pop      rbp
0x0000EE0F: e97c6effff               jmp      0x180005c90
0x0000EE14: cc                       int3     
0x0000EE15: 4055                     push     rbp
0x0000EE17: 4883ec20                 sub      rsp, 0x20
0x0000EE1B: 488bea                   mov      rbp, rdx
0x0000EE1E: b901000000               mov      ecx, 1
0x0000EE23: 4883c420                 add      rsp, 0x20
0x0000EE27: 5d                       pop      rbp
0x0000EE28: e9636effff               jmp      0x180005c90
0x0000EE2D: cc                       int3     
0x0000EE2E: 4055                     push     rbp
0x0000EE30: 4883ec20                 sub      rsp, 0x20
0x0000EE34: 488bea                   mov      rbp, rdx
0x0000EE37: 8b4d40                   mov      ecx, dword ptr [rbp + 0x40]
0x0000EE3A: 4883c420                 add      rsp, 0x20
0x0000EE3E: 5d                       pop      rbp
0x0000EE3F: e988b6ffff               jmp      0x18000a4cc
0x0000EE44: cc                       int3     
0x0000EE45: 4055                     push     rbp
0x0000EE47: 4883ec20                 sub      rsp, 0x20
0x0000EE4B: 488bea                   mov      rbp, rdx
0x0000EE4E: 8b4d50                   mov      ecx, dword ptr [rbp + 0x50]
0x0000EE51: 4883c420                 add      rsp, 0x20
0x0000EE55: 5d                       pop      rbp
0x0000EE56: e971b6ffff               jmp      0x18000a4cc
0x0000EE5B: cc                       int3     
0x0000EE5C: 4055                     push     rbp
0x0000EE5E: 4883ec20                 sub      rsp, 0x20
0x0000EE62: 488bea                   mov      rbp, rdx
0x0000EE65: 488b4d30                 mov      rcx, qword ptr [rbp + 0x30]
0x0000EE69: 4883c420                 add      rsp, 0x20
0x0000EE6D: 5d                       pop      rbp
0x0000EE6E: e9e591ffff               jmp      0x180008058
0x0000EE73: cc                       int3     
0x0000EE74: 4055                     push     rbp
0x0000EE76: 4883ec20                 sub      rsp, 0x20
0x0000EE7A: 488bea                   mov      rbp, rdx
0x0000EE7D: b90a000000               mov      ecx, 0xa
0x0000EE82: 4883c420                 add      rsp, 0x20
0x0000EE86: 5d                       pop      rbp
0x0000EE87: e9046effff               jmp      0x180005c90
0x0000EE8C: cc                       int3     
0x0000EE8D: cc                       int3     
0x0000EE8E: cc                       int3     
0x0000EE8F: cc                       int3     
0x0000EE90: 488d0d69980000           lea      rcx, [rip + 0x9869]
0x0000EE97: e92429ffff               jmp      0x1800017c0
