/*----------------------------------------------------------------
//           Mon premier programme                              //
----------------------------------------------------------------*/
    .text
    .globl    _start
_start:
    /* 0x00 Reset Interrupt vector address */
    b    _good

    /* 0x04 Undefined Instruction Interrupt vector address */
    b    _bad
    nop 

_bad :
    add r4, r5, r6
_good :
    add r7, r8, r9
