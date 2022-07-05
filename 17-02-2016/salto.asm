section .data
    a equ 16
    n equ 12
    ks equ 8

section .text
    global _salto
_salto:
    push EBP
    mov EBP, ESP
    pushad

    mov EAX, [EBP + a]  ; v
    mov ESI, [EBP + n]  ; n
    sub ESI, 2          ; ignore last 2 elements
    xor DX, DX          ; cont
    xor EDI, EDI        ; i
loop:
    cmp EDI, ESI
    jge end
    
    mov EBX, [EAX + EDI*2]  ; v[i]
    cmp EBX, 0              ; positive?
    jge positive
negative:
    add EDI, 1

    mov ECX, [EAX + EDI*2]  ; v[i+1]
    cmp ECX, 0              ; positive?
    jl next
    
    ; a < 0, b > 0
    ; | a - b | > 2
    sub EBX, ECX
    cmp EBX, 0              ; v[i] - v[i+1] positive?
    jge g2
    neg EBX                 ; | ... |
g2:
    cmp EBX, 2              ; | ... | > 2
    jl restorePosG2
    inc DX

restorePosG2:
    sub EDI, 1
    jmp next
positive:
    add EDI, 2

    mov ECX, [EAX + EDI*2]
    cmp ECX, 0              ; negative?
    jge next
    
    ; a > 0, b < 0
    ; | a - b | > 4
    sub EBX, ECX
    cmp EBX, 0              ; v[i] - v[i+1] positive?
    jge g4
    neg EBX                 ; | ... |
g4:
    cmp EBX, 4              ; | ... | > 4
    jl restorePosG4
    inc DX
    
restorePosG4:
    sub EDI, 2
next:
    inc EDI
    jmp loop
end:
    mov EAX, [EBP + ks]
    mov [EAX], DX

    popad
    mov ESP, EBP
    pop EBP