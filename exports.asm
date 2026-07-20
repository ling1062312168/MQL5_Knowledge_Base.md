; Export entry disassembly (from live unpack)

; ---- check_ex4 RVA=0x11A0 ----
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

; ---- GetAccount_checkout_time_HttpSendRequestW RVA=0x13A0 ----
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
0x000013B0: b801000000               mov      eax, 1
0x000013B5: c3                       ret      

; ---- HttpOpenRequestW_HttpQueryInfoW_ShellExecuteW RVA=0x13B0 ----
0x000013B0: b801000000               mov      eax, 1
0x000013B5: c3                       ret      

; ---- InternetReadFile RVA=0x13C0 ----
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
0x000014B0: 4883ec68                 sub      rsp, 0x68
0x000014B4: 0f29742450               movaps   xmmword ptr [rsp + 0x50], xmm6
0x000014B9: 0f297c2440               movaps   xmmword ptr [rsp + 0x40], xmm7
0x000014BE: 440f29442430             movaps   xmmword ptr [rsp + 0x30], xmm8
0x000014C4: 0f28f2                   movaps   xmm6, xmm2

; ---- InternetOpenUrlW RVA=0x1480 ----
0x00001480: b864000000               mov      eax, 0x64
0x00001485: c3                       ret      

; ---- ex4 RVA=0x1490 ----
0x00001490: 8b0582880100             mov      eax, dword ptr [rip + 0x18882]
0x00001496: c3                       ret      

; ---- GetStrategy_InternetAttemptConnect RVA=0x14A0 ----
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

; ---- CalculateMax RVA=0x14B0 ----
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
0x00001540: 4883ec28                 sub      rsp, 0x28
0x00001544: e857fcffff               call     0x1800011a0
0x00001549: b001                     mov      al, 1
0x0000154B: 4883c428                 add      rsp, 0x28
0x0000154F: c3                       ret      
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

; ---- GetExpirationTime RVA=0x1530 ----
0x00001530: b80077bd7f               mov      eax, 0x7fbd7700
0x00001535: c3                       ret      

; ---- GetAuth RVA=0x1540 ----
0x00001540: 4883ec28                 sub      rsp, 0x28
0x00001544: e857fcffff               call     0x1800011a0
0x00001549: b001                     mov      al, 1
0x0000154B: 4883c428                 add      rsp, 0x28
0x0000154F: c3                       ret      

; ---- ProfitPoint RVA=0x1550 ----
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

; ---- OrdersCheck RVA=0x15D0 ----
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

; ---- InternetCloseHandle_InternetConnectW RVA=0x1700 ----
0x00001700: b86f000000               mov      eax, 0x6f
0x00001705: c3                       ret      

; ---- InternetOpenW RVA=0x1710 ----
0x00001710: b80b000000               mov      eax, 0xb
0x00001715: c3                       ret      

