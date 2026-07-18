// riscv_test.h — riscv-tests environment for Koti-1 (RV32IMA + Zicsr).
//
// Same minimal protocol as the TinyRV32 env, with one difference that
// matters: Koti-1 traps on ECALL (it is the SBI path), so the tests
// stop the core with EBREAK instead.
//
// Protocol (mirrors the official tohost values):
//   a0 == 1              -> all tests in the file passed
//   a0 == (testnum<<1)|1 -> test number `testnum` failed
#ifndef _ENV_KOTI_TEST_H
#define _ENV_KOTI_TEST_H

#define RVTEST_RV32U
#define RVTEST_RV64U

#define TESTNUM gp

#define RVTEST_CODE_BEGIN   \
        .section .text.init;\
        .align 2;           \
        .globl _start;      \
_start:

#define RVTEST_CODE_END

#define RVTEST_PASS         \
        li a0, 1;           \
        ebreak

#define RVTEST_FAIL         \
        slli a0, TESTNUM, 1;\
        ori a0, a0, 1;      \
        ebreak

#define RVTEST_DATA_BEGIN .data; .balign 4;
#define RVTEST_DATA_END

#endif
