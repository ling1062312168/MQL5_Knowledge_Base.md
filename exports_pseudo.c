/*
 * WININET.dll — recovered pseudo-C from UNPACKED .text (live dump)
 * NOT original source. Hand-lifted from disassembly.
 * Image: PE32+ x64, packed on disk; bodies appear only after LoadLibrary unpack.
 *
 * Preferred base: 0x180000000
 * .text RVA: 0x1000
 *
 * IMPORTANT:
 *  - check_ex4 body is still control-flow obfuscated (not fully recovered).
 *  - Internet* names are stubs, not real WinINet.
 *  - Large logic may live in .NQ6 (3.6MB) still partially protected.
 */

#include <stdint.h>
#include <stdbool.h>

/* ============================================================
 * License / gate surface
 * ============================================================ */

/* RVA 0x11A0 — still mutated/obfuscated after unpack.
 * Called by GetAuth / CalculateMax / ProfitPoint.
 * Observed return when called alone: 0 (sometimes 1 depending on state).
 * Side effects unclear; GetAuth IGNORES its return value.
 */
int check_ex4(void) {
    /* obfuscated: push imm; push r12; call ...; popfq; ... */
    /* NOT recovered to clean C */
    return 0; /* observed */
}

/* RVA 0x1540 */
bool GetAuth(void) {
    check_ex4();       /* return value discarded */
    return true;       /* mov al, 1 */
}

/* RVA 0x1530
 * Hard-coded unix timestamp 0x7FBD7700 = 2037-11-29T16:00:00+00:00
 */
uint32_t GetExpirationTime(void) {
    return 0x7FBD7700u;  /* 2037-11-29 16:00:00 UTC */
}

/* RVA 0x13A0 — shared with checkout_time / HttpSendRequestW */
bool GetAccount(void) { return true; }
bool checkout_time(void) { return true; }

/* RVA 0x14A0 — shared with InternetAttemptConnect */
int GetStrategy(void) {
    return 0;          /* xor eax, eax; ret */
}

/* RVA 0x1490
 * returns dword global at RVA 0x19D18 (image-relative)
 */
extern uint32_t g_ex4_state; /* RVA 0x19D18, zero at load */
int ex4(void) {
    return (int)g_ex4_state;
}

/* ============================================================
 * Math helpers used by EA
 * ============================================================ */

/* RVA 0x14B0
 * double CalculateMax(double a, double b, double c, double d)
 * MS x64: xmm0=a, xmm1=b, xmm2=c, xmm3=d
 * Recovered formula (constants at .rdata):
 *   t = (a - c) / (b - c)
 *   t = (t - K1) * K2 + d * K3
 * Exact K1/K2/K3 need rdata dword dump (RIP-relative).
 */
double CalculateMax(double a, double b, double c, double d) {
    check_ex4();
    /* approximate structure: */
    double t = (a - c) / (b - c);
    /* t = (t - K1) * K2 + d * K3; */
    return t; /* placeholder — see exports.asm for constant loads */
}

/* RVA 0x1550
 * int ProfitPoint(uint8_t flag, int a, int b, int c)
 * RCX=flag, EDX=a, R8=b, R9=c
 */
int ProfitPoint(unsigned char flag, int a, int b, int c) {
    check_ex4();
    if (flag) {
        if (a == 0 || b <= a) return c;
        int v = (a - b) * 0x32 + c;   /* imul 0x32 = 50 */
        if (v < 100) v = 100;
        return v;
    } else {
        if (a == 0 || b <= a) return c;
        /* eax = ((a-b)<<2) - b + a + c ; clamp min 10 */
        int v = ((a - b) << 2) - b + a + c;
        if (v < 10) v = 10;
        return v;
    }
}

/* RVA 0x15D0 — OrdersCheck: floating path + switch on r9
 * Signature not fully confirmed; uses xmm1 and cl flag.
 * Partial recovery only — see exports.asm.
 */
int OrdersCheck(/* double x in xmm1, bool flag in cl, ... */) {
    /* complex branch table — not fully lifted */
    return 0;
}

/* ============================================================
 * Cover / disguise APIs (NOT real wininet)
 * ============================================================ */

int HttpOpenRequestW(void) { return 1; }          /* 0x13B0 */
int HttpQueryInfoW(void) { return 1; }            /* 0x13B0 */
int HttpSendRequestW(void) { return 1; }          /* 0x13A0 mov al,1 */
int InternetAttemptConnect(void) { return 0; }    /* 0x14A0 xor eax,eax */
int InternetCloseHandle(void) { return 0x6F; }    /* original imm; stub */
int InternetConnectW(void) { return 0x6F; }
int InternetOpenUrlW(void) { return 0x64; }       /* original */
int InternetOpenW(void) { return 0xB; }           /* original */
int InternetReadFile(void) { /* obfuscated path */ return 0; }
int ShellExecuteW(void) { return 1; }

/*
 * Original Internet* immediates observed live:
 *   InternetOpenW        mov eax, 0x0B; ret
 *   InternetCloseHandle  mov eax, 0x6F; ret
 *   InternetOpenUrlW     mov eax, 0x64; ret
 * These are FAKE handles/status codes for name camouflage only.
 */
