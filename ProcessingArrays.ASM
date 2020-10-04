; Вариант 8
; Разработать программу, которая вводит одномерный массив A[N], формирует из элементов массива A новый массив B по правилам:
; B[i] = A[i] + 5, если A[i] > 5
; B[i] = A[i] - 5, если A[i] < -5
; B[i] = 0 во всех остальных случаях
; и выводит его. Память под массивы может выделяться как статически, так и динамически по выбору разработчика.     

format PE console
entry start

include 'win32a.inc'

;--------------------------------------------------------------------------
section '.data' data readable writable

        stringArraySize   db 'Input array size: ', 0
        stringIncorrectSize db 'Incorrect array size = %d', 10, 0
        stringInputArrayElement  db '[%d]? ', 0
        stringScanningInteger   db '%d', 0
        stringOutputArrayElement  db '[%d] = %d', 10, 0
        stringInputError db 'Error, the input numbers must be between -1000 and 1000, the program execution is completed', 10, 0
        stringOutputArrayA db 'Array A: ', 10, 0
        stringOutputArrayB db 'Array B: ', 10, 0

        arraySize     dd 0
        i             dd ?
        tmp1          dd ?
        tmp2          dd ?
        tmpStack      dd ?
        arrayA        rd 10
        arrayB        rd 10
        maxElem       dd 1000
        minElem       dd -1000

;--------------------------------------------------------------------------
section '.code' code readable executable

start:

        call ArraySizeInput

        call FormingArrays

        push stringOutputArrayA
        call [printf]
        add esp, 4
        mov eax, arrayA
        call ArrayOutput

        push stringOutputArrayB
        call [printf]
        add esp, 4
        mov eax, arrayB
        call ArrayOutput

finish:

        call [getch]
        push 0
        call [ExitProcess]

;--------------------------------------------------------------------------
proc ArraySizeInput

        push stringArraySize
        call [printf]
        add esp, 4

        push arraySize
        push stringScanningInteger
        call [scanf]
        add esp, 8

        mov eax, [arraySize]
        cmp eax, 0
        jg  greaterThan

lessThan:

        push [arraySize]
        push stringIncorrectSize
        call [printf]
        jmp finish

greaterThan:

        cmp eax, 10
        jng endArrayInput
        push [arraySize]
        push stringIncorrectSize
        call [printf]
        jmp finish

endArrayInput:

        ret
endp
;--------------------------------------------------------------------------
proc FormingArrays

        xor ecx, ecx
        mov ebx, arrayA
        mov eax, arrayB
        mov esi, 0

getArrayLoop:

        mov [tmp1], ebx
        mov [tmp2], eax
        cmp ecx, [arraySize]
        jge endInputArray


        mov [i], ecx
        push ecx
        push stringInputArrayElement
        call [printf]
        add esp, 8


        push ebx
        push stringScanningInteger
        call [scanf]

        mov edi, [minElem]
        cmp edi, [ebx]
        jle  moreThanM1000

        push stringInputError
        call [printf]
        jmp finish

moreThanM1000:
        mov edi, [maxElem]
        cmp edi, [ebx]
        jge formingB
        push stringInputError
        call [printf]
        jmp finish

formingB:
        mov edx, 5
        cmp [ebx], edx
        jle lessEqThanFive
        add edx, [ebx]
        jmp increment

lessEqThanFive:

        mov edx, -5
        cmp [ebx], edx
        jge moreEqThanMFive
        add edx, [ebx]
        jmp increment

moreEqThanMFive:

        mov edx, 0
        jmp increment

increment:

        mov [arrayB + 4*esi], edx
        add esp, 8
        mov ecx, [i]
        inc ecx
        inc esi
        mov ebx, [tmp1]
        add ebx, 4
        mov eax, [tmp2]
        add eax, 4
        jmp getArrayLoop

endInputArray:

        ret
endp
;--------------------------------------------------------------------------
proc ArrayOutput

        mov [tmpStack], esp
        xor ecx, ecx

putArrayLoop:

        mov [tmp1], eax
        cmp ecx, [arraySize]
        je endOutputArray
        mov [i], ecx

        push dword [eax]
        push ecx
        push stringOutputArrayElement
        call [printf]

        mov ecx, [i]
        inc ecx
        mov eax, [tmp1]
        add eax, 4
        jmp putArrayLoop

endOutputArray:

        mov esp, [tmpStack]
        ret

endp
;-------------------------------------------------------------------------
                                                 
section '.idata' import data readable

    library kernel, 'kernel32.dll',\
            msvcrt, 'msvcrt.dll',\
            user32,'USER32.DLL'

    import kernel,\
           ExitProcess, 'ExitProcess'

    import msvcrt,\
           printf, 'printf',\
           scanf, 'scanf',\
           getch, '_getch'
